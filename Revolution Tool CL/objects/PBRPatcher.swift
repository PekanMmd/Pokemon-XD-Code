//
//  PBRPatcher.swift
//  GoD Tool
//
//  Created by Stars Momodu on 11/07/2020.
//

import Foundation

let patches: [XGDolPatches] = [
	.unlockSaveFileBoxes,
	.freeSpaceInDol,
	.gen7CritRatios,
	.disableRentalPassChecksums,
	.disableBlurEffect
]

enum XGDolPatches: Int {

	case freeSpaceInDol
	case gen7CritRatios
	case disableRentalPassChecksums
	case disableBlurEffect
	case unlockSaveFileBoxes

	var name: String {
		switch self {
		case .unlockSaveFileBoxes: return "Unlock save file. Links a DS to the save file which lets you use pokemon in your box to create battle passes."
		case .freeSpaceInDol: return "Create some space in \(XGFiles.dol.fileName) which is needed for other assembly patches. Recommended to use this first."
		case .gen7CritRatios : return "Update the critical hit ratios to gen 7 odds"
		case .disableRentalPassChecksums : return "Disable legality checks on battle passes"
		case .disableBlurEffect : return "Remove the blur effect from the games rendering"
		}
	}

}

class XGPatcher {

	/// Clears some unused function data from the assembly so those addresses can be used for our own ASM
	static func clearUnusedFunctionsInDol() {
		guard !checkIfUnusedFunctionsInDolWereCleared() else {
			printg("ASM space already created in \(XGFiles.dol.fileName)")
			return
		}
		if let data = XGFiles.dol.data,
		let start = kDolFreeSpaceStart,
		let end = kDolFreeSpaceEnd {
			let length = end - start
			data.nullBytes(start: start, length: length)
			// Reserve 16 bytes for tool's usage
			data.replaceWordAtOffset(start, withBytes: 0x0DE1E7ED)
			(1 ... 3).forEach {
				data.replaceWordAtOffset(start + ($0 * 4), withBytes: 0xFFFFFFFF)
			}
			data.save()
		}
	}

	static func checkIfUnusedFunctionsInDolWereCleared() -> Bool {
		if let data = XGFiles.dol.data, let start = kDolFreeSpaceStart {
			return data.getWordAtOffset(start) == 0x0DE1E7ED
		}
		return false
	}

	/// Removes the code for rental pass validation checks
	/// allowing the space to be reused for the type matchups table
	static func moveTypeMatchupsTableToPassValidationFunction() {
		guard region == .EU else {
			printg("Couldn't move type match ups table. Not implemented for region: \(region.name)")
			return
		}
		let startOffset = 0x1317cc - kDolToRAMOffsetDifference

		// rental pass validation checks just pass immediately
		XGAssembly.replaceASM(startOffset: startOffset, newASM: [
			.li(.r3, 1),
			.blr
		])

		let movedFromOriginalLocation = PBRTypeManager.typeMatchupDataDolOffset == 0x401348
		let additionalEntryCount = movedFromOriginalLocation ? 20 : 0

		PBRTypeManager.moveTypeMatchupTableToDolOffset(startOffset + 8, increaseEntryNumberBy: additionalEntryCount)
	}

	static func gen7CritRatios() {
		let critRatiosStartOffset: Int
		switch region {
		case .US: critRatiosStartOffset = 0x44AAF0
		case .JP: critRatiosStartOffset = 0x4359F0
		case .EU: critRatiosStartOffset = 0x475010
		case .OtherGame: critRatiosStartOffset = 0
		}

		let dol = XGFiles.dol.data!
		dol.replaceBytesFromOffset(critRatiosStartOffset, withByteStream: [24,8,2,1,1])
		dol.save()
	}

	static func disableRentalPassChecksums() {
		printg("Disabling rental pass checksums")
		guard region == .EU else {
			printg("Couldn't disable rental pass checksums. Not implemented for region: \(region.name)")
			return
		}
		XGAssembly.replaceASM(startOffset: 0x3DAF40 - kDolToRAMOffsetDifference, newASM: [
			.b_f(0, 0x2c)
		])
		XGAssembly.replaceASM(startOffset: 0x3dda20 - kDolToRAMOffsetDifference, newASM: [
			.b_f(0, 0x2c)
		])

		XGAssembly.replaceASM(startOffset: 0x3de140 - kDolToRAMOffsetDifference, newASM: [
			.b_f(0, 0x24)
		])

		XGAssembly.replaceASM(startOffset: 0x3db6bc - kDolToRAMOffsetDifference, newASM: [
			.b_f(0, 0x30)
		])

		XGAssembly.replaceASM(startOffset: 0x3db568 - kDolToRAMOffsetDifference, newASM: [
			.b_f(0, 0x30)
		])

		XGAssembly.replaceASM(startOffset: 0x3DA370 - kDolToRAMOffsetDifference, newASM: [
			.li(.r3, 0)
		])
	}

	static func overrideHardcodedPokemonCount(newCount count: Int) {
		guard region == .EU else {
			printg("Couldn't override hard coded pokemon count for game region \(region.name)")
			return
		}
		XGAssembly.replaceASM(startOffset: 0x56c0c - kDolToRAMOffsetDifference, newASM: [.cmpwi(.r0, count)])

		for offset in [0x5b704 , 0x5b9b4 , 0x5c09c , 0x5c348] {
			XGAssembly.replaceASM(startOffset: offset - kDolToRAMOffsetDifference, newASM: [.cmpwi(.r4, count)])
		}
	}

	static func isClassSplitImplemented() -> Bool {
		// for colo/xd compatibility
		return true
	}

	static func disableBlurEffect() {
		let bloomStrengthOffset: Int
		switch region {
		case .EU: bloomStrengthOffset = 0x473ea8
		case .US: bloomStrengthOffset = 0x449990
		case .JP: bloomStrengthOffset = 0x434910
		case .OtherGame: bloomStrengthOffset = 0
		}
		if let dol = XGFiles.dol.data {
			dol.replace4BytesAtOffset(bloomStrengthOffset, withBytes: 0)
			dol.save()
		}
	}

	static func unlockSaveFile() {
		guard environment == .Windows else {
			printg("The save file decrypting tool is only available on Windows.")
			return
		}

		XGFolders.setUpFolderFormat()
		guard XGFiles.saveData.exists else {
			printg("Please place your save file at \(XGFiles.saveData.path) then try again.")
			return
		}
		printg("Decrypting save file \(XGFiles.saveData.path) using PbrSaveTool")
		GoDShellManager.run(.pbrSaveTool, inputRedirectFile: .nameAndFolder("pbrsavetool_decrypt", .Resources))
		guard XGFiles.decryptedSaveData.exists, let saveData = XGFiles.decryptedSaveData.data else {
			printg("Couldn't load decrypted save at \(XGFiles.decryptedSaveData.path)")
			return
		}

		printg("Linking a random DS TID and SID to the save file.")
		// SID and TID are randomly generated so we can put any non zero value here
		saveData.replaceByteAtOffset(0x12860, withByte: 1) // TID second byte
		saveData.replaceByteAtOffset(0x12865, withByte: 1) // SID second byte
		saveData.replaceByteAtOffset(0x12866, withByte: 1) // SID first byte
		saveData.replaceByteAtOffset(0x12867, withByte: 1) // TID first byte
		saveData.save()

		printg("Encrypting save file \(XGFiles.saveData.path) using PbrSaveTool")
		GoDShellManager.run(.pbrSaveTool, inputRedirectFile: .nameAndFolder("pbrsavetool_encrypt", .Resources))
		printg("Done.")
	}

	class func applyPatch(_ patch: XGDolPatches) {
		switch patch {
		case .unlockSaveFileBoxes: XGPatcher.unlockSaveFile()
		case .freeSpaceInDol: XGPatcher.clearUnusedFunctionsInDol()
		case .gen7CritRatios: XGPatcher.gen7CritRatios()
		case .disableRentalPassChecksums: XGPatcher.disableRentalPassChecksums()
		case .disableBlurEffect: XGPatcher.disableBlurEffect()
		}
	}
}
