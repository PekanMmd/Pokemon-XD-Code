//
//  DolphinProcess.swift
//  GoD Tool
//
//  Created by Stars Momodu on 27/09/2021.
//

import Foundation

class DolphinProcess: ProcessIO {

	let kMEMSize: UInt = 0x2_000_000

	private let process: GoDProcess
	private var gameIdentifier: String?
	private var RAMInfo: (mem1: VMRegionInfo, mem2: VMRegionInfo)?

	/// Settings don't seem to work atm
	convenience init?(isoFile: XGFiles? = nil, dolphinFile: XGFiles? = nil, settings: [(key: DolphinSystems, value: String)] = []) {
		
		let iso = isoFile ?? XGFiles.iso
		guard iso.exists, let isoData = iso.data else { return nil }
		let args = "--exec=\(iso.path.escapedPath)"
		var dolphinFile = XGSettings.current.dolphinPath.flatMap { XGFiles.path($0) }
		let hasNoPathSet = dolphinFile == nil
		
		#if os(macOS)
		let dolphinApp = dolphinFile ?? XGFiles.path("/Applications/Dolphin.app")
		dolphinFile = XGFiles.path(dolphinApp.path + "/Contents/MacOS/Dolphin")
		GoDShellManager.stripEntitlements(appFile: dolphinApp)
		#elseif os(Linux)
		if dolphinFile == nil {
			dolphinFile = XGFiles.path("/usr/games/dolphin-emu")
		}
		#elseif os(Windows)
		if dolphinFile == nil {
			dolphinFile = XGFiles.path("C:/Program Files/Dolphin-x64/Dolphin.exe")
		}
		#else
		return nil
		#endif
		
		if hasNoPathSet, let dolphinFile {
			XGSettings.current.dolphinPath = dolphinFile.path
			XGSettings.current.save()
			
			printg("Path to Dolphin executable not set. Defaulting to:", dolphinFile.path,"\n Update the path in the tool settings by updating the text in ",settingsFile.path)
		}
		
		guard let dolphinFile, let process = GoDShellManager.runAsync(.file(dolphinFile), args: args) else {
			return nil
		}
		
		self.init(process: process)
		self.gameIdentifier = isoData.readString(atAddress: 0, charLength: .char, maxCharacters: 4)
		
		
	}

	private init(process: GoDProcess) {
		self.process = process
		#if os(macOS)
		let appleScriptUser = "sudo -H -u `logname`"
		let saveStateScript =
		"""
		#!/bin/bash
		SCRIPT='tell application "System Events" to tell application process "Dolphin" to click (every menu item of menu of menu item "Save State to Slot" of menu of menu item "Save State" of menu "Emulation" of menu bar 1 whose (name starts with "Save to Slot '$1' - "))'
		\(appleScriptUser) osascript -e "${SCRIPT}"
		"""
		let loadStateScript =
		"""
		#!/bin/bash
		SCRIPT='tell application "System Events" to tell application process "Dolphin" to click (every menu item of menu of menu item "Load State from Slot" of menu of menu item "Load State" of menu "Emulation" of menu bar 1 whose (name starts with "Load from Slot '$1' - "))'
		\(appleScriptUser) osascript -e "${SCRIPT}"
		"""
		if !saveStateScriptFile.exists {
			saveStateScript.save(toFile: saveStateScriptFile, isExecutable: true)
		}
		if !loadStateScriptFile.exists {
			loadStateScript.save(toFile: loadStateScriptFile, isExecutable: true)
		}
		#elseif os(Linux)
		let saveStateScript =
		"""
		#!/bin/bash
		xdotool key shift+F$1
		"""
		let loadStateScript =
		"""
		#!/bin/bash
		xdotool key F$1
		"""
		if !saveStateScriptFile.exists {
			saveStateScript.save(toFile: saveStateScriptFile, isExecutable: true)
		}
		if !loadStateScriptFile.exists {
			loadStateScript.save(toFile: loadStateScriptFile, isExecutable: true)
		}
		#else
		canUseSavedStates = false
		#endif
		load()
	}

	// MARK: - Process
	var isRunning: Bool { return process.isRunning }

	func terminate() {
		process.terminate()
		process.terminate()
	}

	func pause() {
		process.pause()
	}

	func resume() {
		process.resume()
	}

	// MARK: - State Saves
	private(set) var canUseSavedStates = true
	private let saveStateScriptFile = XGFiles.nameAndFolder("Dolphin Save States.sh", .Resources)
	private let loadStateScriptFile = XGFiles.nameAndFolder("Dolphin Load States.sh", .Resources)

	func saveStateToSlot(_ slot: Int) {
		guard canUseSavedStates else { return }
		GoDShellManager.run(.file(saveStateScriptFile), args: [slot.string])
	}

	func loadStateFromSlot(_ slot: Int) {
		guard canUseSavedStates else { return }
		GoDShellManager.run(.file(loadStateScriptFile), args: [slot.string])
	}

	// MARK: - IO
	func read(atAddress address: UInt, length: UInt) -> XGMutableData? {
		guard let mem1 = RAMInfo?.mem1 else {
			return nil
		}
		let virtualAddress = address >= 0x80_000_000 ? address - 0x80_000_000 : address
		return process.readVirtualMemory(at: virtualAddress, length: length, relativeToRegion: mem1)
	}

	@discardableResult
	func write(_ data: XGMutableData, atAddress address: UInt) -> Bool {
		guard let mem1 = RAMInfo?.mem1,
			  let mem2 = RAMInfo?.mem2 else {
			return false
		}
		let RAMOffset = address >= 0x80_000_000 ? address - 0x80_000_000 : address
		return process.writeVirtualMemory(at: RAMOffset, data: data, relativeToRegion: mem1)
		    && process.writeVirtualMemory(at: RAMOffset, data: data, relativeToRegion: mem2)
	}

	func dumpDolphinRAM(toFile file: XGFiles, size: UInt) {
		let fullRAM = XGMutableData()
		for region in process.getRegions(maxOffset: size) {
			var text = "Region: \(region.virtualAddress) size: \(region.size)"
			while text.length < 0x30 { text += "-" }
			let textData = XGMutableData(data: text.data(using: .utf8)!)
			if let data = process.readVirtualMemory(at: 0, length: region.size, relativeToRegion: region) {
				fullRAM.appendData(textData)
				fullRAM.appendData(data)
			}
		}
		fullRAM.writeToFile(file)
	}

	// MARK: - Launch
	func begin(onStart: ((ProcessIO) -> Void)?,
			   onLaunchFailed: ((String?) -> Void)?) {

		// wait up to 15 seconds for the emulator to launch fully
		var attemps = 0
		while !validate() && attemps < 15 {
			sleep(1)
			attemps += 1
		}
		if validate() {
			sleep(5)
			onStart?(self)
		} else {
			onLaunchFailed?("Timed out waiting for Dolphin to launch.")
		}
	}

	private func validate() -> Bool {
		if RAMInfo?.mem1 != nil { return true }
		load()
		return RAMInfo?.mem1 != nil
	}

	private func load() {
		var memRegions = [VMRegionInfo]()

		var lastRegion: VMRegionInfo?
		repeat {
			var address: UInt = 0
			if let region = lastRegion {
				address = region.virtualAddress + region.size
			}
			lastRegion = process.getNextRegion(fromOffset: address)
			if let regionInfo = lastRegion,
			   regionInfo.size == kMEMSize,
			   process.readVirtualMemory(at: 0, length: 4, relativeToRegion: regionInfo)?.string == self.gameIdentifier {
				memRegions.append(regionInfo)
			}
		} while lastRegion != nil && memRegions.count < 2

		guard memRegions.count >= 2 else {
			RAMInfo = nil
			return
		}
		RAMInfo = (mem1: memRegions[0], mem2: memRegions[1])
	}
}
