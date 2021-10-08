//
//  DolphinProcess.swift
//  GoD Tool
//
//  Created by Stars Momodu on 27/09/2021.
//

import Foundation

class DolphinProcess {
	
	private let kMEMSize: UInt = 0x2_000_000

	private let process: GoDProcess
	private var RAMInfo: (mem1: VMRegionInfo, mem2: VMRegionInfo)?

	var isRunning: Bool {
		return process.isRunning
	}

	private init(process: GoDProcess) {
		self.process = process
		load()
	}

	func terminate() {
		process.terminate()
	}

	func pause() {
		process.pause()
	}

	func resume() {
		process.resume()
	}

	func read(RAMOffset: UInt, length: UInt) -> XGMutableData? {
		guard validate(),
			  let mem1 = RAMInfo?.mem1 else {
			return nil
		}
		let address = RAMOffset >= 0x80_000_000 ? RAMOffset - 0x80_000_000 : RAMOffset
		return process.readVirtualMemory(at: address, length: length, relativeToRegion: mem1)
	}

	func read(RAMOffset: Int, length: Int) -> XGMutableData? {
		return read(RAMOffset: UInt(RAMOffset), length: UInt(length))
	}

	func readByte(RAMOffset: Int) -> Int? {
		return read(RAMOffset: RAMOffset, length: 1)?.getByteAtOffset(0)
	}

	func read2Bytes(RAMOffset: Int) -> Int? {
		return read(RAMOffset: RAMOffset, length: 2)?.get2BytesAtOffset(0)
	}

	func read4Bytes(RAMOffset: Int) -> Int? {
		return read(RAMOffset: RAMOffset, length: 4)?.get4BytesAtOffset(0)
	}

	func readChar(RAMOffset: Int) -> UInt8? {
		return read(RAMOffset: RAMOffset, length: 1)?.getCharAtOffset(0)
	}

	func readShort(RAMOffset: Int) -> UInt16? {
		return read(RAMOffset: RAMOffset, length: 2)?.getHalfAtOffset(0)
	}

	func readWord(RAMOffset: Int) -> UInt32? {
		return read(RAMOffset: RAMOffset, length: 4)?.getWordAtOffset(0)
	}

	func readString(RAMOffset: Int, charLength: ByteLengths = .char, maxCharacters: Int? = nil) -> String {
		var currentOffset = RAMOffset

		var currChar: Int? = 0x0
		var nextChar: Int? = 0x1
		var characterCounter = 0

		let string = XGString(string: "", file: nil, sid: nil)

		while nextChar != 0x00 && nextChar != nil && (maxCharacters == nil || characterCounter < maxCharacters!) {
			switch charLength {
			case .char: currChar = Int(readChar(RAMOffset: currentOffset) ?? 0)
			case .short: currChar = Int(readShort(RAMOffset: currentOffset) ?? 0)
			case .word: currChar = Int(readWord(RAMOffset: currentOffset) ?? 0)
			}
			currentOffset += charLength.rawValue
			characterCounter += 1

			string.append(.unicode(currChar ?? 0))
			switch charLength {
			case .char: nextChar = Int(readChar(RAMOffset: currentOffset) ?? 0)
			case .short: nextChar = Int(readShort(RAMOffset: currentOffset) ?? 0)
			case .word: nextChar = Int(readWord(RAMOffset: currentOffset) ?? 0)
			}
		}

		return string.string
	}

	@discardableResult
	func write(_ data: XGMutableData, atAddress address: UInt) -> Bool {
		guard validate(),
			  let mem1 = RAMInfo?.mem1,
			  let mem2 = RAMInfo?.mem2 else {
			return false
		}
		let RAMOffset = address >= 0x80_000_000 ? address - 0x80_000_000 : address
		guard process.writeVirtualMemory(at: RAMOffset, data: data, relativeToRegion: mem1) else {
			return false
		}
		return process.writeVirtualMemory(at: RAMOffset, data: data, relativeToRegion: mem2)
	}

	@discardableResult
	func write(_ data: XGMutableData, atAddress address: Int) -> Bool {
		return write(data, atAddress: UInt(address))
	}

	@discardableResult
	func write(_ value: Int, atAddress address: Int) -> Bool {
		return write(value.unsigned, atAddress: address)
	}

	@discardableResult
	func write8(_ value: Int, atAddress address: Int) -> Bool {
		return write(UInt8(value & 0xFFFF), atAddress: address)
	}

	@discardableResult
	func write(_ value: UInt8, atAddress address: Int) -> Bool {
		let data = XGMutableData(byteStream: [value])
		return write(data, atAddress: address)
	}

	@discardableResult
	func write16(_ value: Int, atAddress address: Int) -> Bool {
		return write(UInt16(value & 0xFFFF), atAddress: address)
	}

	@discardableResult
	func write(_ value: UInt16, atAddress address: Int) -> Bool {
		let data = XGMutableData(byteStream: Int(value).byteArrayU16)
		return write(data, atAddress: address)
	}

	@discardableResult
	func write(_ value: UInt32, atAddress address: Int) -> Bool {
		let data = XGMutableData(byteStream: value.charArray)
		return write(data, atAddress: address)
	}

	@discardableResult
	func write(_ asm: ASM, atAddress address: Int) -> Bool {
		let bytes = asm.wordStreamAtRAMOffset(address)
		let data = XGMutableData(length: bytes.count * 4)
		data.replaceBytesFromOffset(0, withWordStream: bytes)
		return write(data, atAddress: address)
	}

	func writeString(_ string: String, atAddress offset: Int, charLength: ByteLengths = .short, maxCharacters: Int? = nil, includeNullTerminator: Bool = true) {
		var unicodeRepresentation = string.unicodeRepresentation
		if !includeNullTerminator {
			unicodeRepresentation.removeLast()
		}

		unicodeRepresentation.forEachIndexed { (index, unicode) in
			guard maxCharacters == nil || index < maxCharacters! else { return }
			let currentOffset = offset + (index * charLength.rawValue)
			let data: XGMutableData
			switch charLength {
			case .char: data = XGMutableData(byteStream: [UInt8(unicode & 0xFF)])
			case .short: data = XGMutableData(byteStream: (unicode & 0xFFFF).byteArrayU16)
			case .word: data = XGMutableData(byteStream: (unicode & 0xFF).byteArray)
			}
			write(data, atAddress: currentOffset)
		}
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

	class func launch(delaySeconds seconds: Int = 0,
					  refreshTimeMicroSeconds: UInt32,
					  settings: [(key: DolphinSystems, value: String)] = [],
					  autoCloseDolphinOnFinish: Bool = false,
					  onStart: ((DolphinProcess) -> Bool)?,
					  onUpdate: ((DolphinProcess) -> Bool)?,
					  onFinish: ((DolphinProcess?) -> Void)?) {

		let dolphinFile = XGFiles.path("/Applications/Dolphin.app/Contents/MacOS/Dolphin")
		var args = "--exec=\(XGFiles.iso.path.escapedPath)"
		settings.forEach { (setting) in
			var value = setting.value
			if ["yes", "true"].contains(value.lowercased()) {
				value = "True"
			}
			if ["no", "false"].contains(value.lowercased()) {
				value = "False"
			}
			if value.isHexInteger {
				let integer = value.hexValue
				value = integer.string
			}
			let key = setting.key.string

			args += " " + "--config=\(key)=\(value)".replacingOccurrences(of: " ", with: "\\ ")
		}

		// Settings as command line args don't work and I don't know why
		guard let process = GoDShellManager.runAsync(.file(dolphinFile), args: args) else {
			onFinish?(nil)
			return
		}

		let dolphin = DolphinProcess(process: process)
		// wait up to 15 seconds for the emulator to launch fully
		var attemps = 0
		while !dolphin.validate() && attemps < 15 {
			sleep(1)
			attemps += 1
		}
		if dolphin.validate() {
			if onStart?(dolphin) ?? true {
				DispatchQueue.main.asyncAfter(deadline: DispatchTime.now().advanced(by: .seconds(seconds))) {
					dolphin.runLoop(refreshTimeMicroSeconds: refreshTimeMicroSeconds, onUpdate: onUpdate)
				}
				process.await()
			}
		}
		onFinish?(dolphin)
		if dolphin.isRunning && autoCloseDolphinOnFinish {
			process.terminate()
			process.terminate()
		}
	}

	private func runLoop(refreshTimeMicroSeconds: UInt32, onUpdate: ((DolphinProcess) -> Bool)?) {
		var shouldContinue = true
		while isRunning && shouldContinue {
			if refreshTimeMicroSeconds > 0 {
				usleep(refreshTimeMicroSeconds)
			}
			if validate() {
				shouldContinue = onUpdate?(self) ?? false
			} else {
				shouldContinue = false
			}
		}
	}

	private var memIsValid: Bool {
		guard let mem1 = RAMInfo?.mem1,
			  let data = process.readVirtualMemory(at: 0, length: 4, relativeToRegion: mem1) else { return false }
		return data.string == region.identifier
	}

	private func validate() -> Bool {
		if !memIsValid {
			load()
		}
		return memIsValid
	}

	private func load() {
		var memRegions = [VMRegionInfo]()

		var lastRegion: VMRegionInfo?
		repeat {
			var address: UInt = 0
			if let region = lastRegion {
				address = region.virtualAddress + region.size
			}
			lastRegion = process.getNextRegion(fromOffset: vm_address_t(address))
			if let regionInfo = lastRegion,
			   regionInfo.size == kMEMSize,
			   process.readVirtualMemory(at: 0, length: 4, relativeToRegion: regionInfo)?.string == region.identifier {
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
