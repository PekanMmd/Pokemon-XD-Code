//
//  PBRPatcher.swift
//  GoD Tool
//
//  Created by Stars Momodu on 11/07/2020.
//

import Foundation

let patches: [XGDolPatches] = [
	.freeSpaceInDol,
	.moveTypeMatchupsTable,
	.gen7CritRatios,
	.disableRentalPassChecksums,
	.disableBlurEffect
]

enum XGDolPatches: Int {

	case freeSpaceInDol
	case gen7CritRatios
	case gen6CriticalHitMultipliers
	case disableRentalPassChecksums
	case disableBlurEffect
	case unlockSaveFileBoxes
	case moveTypeMatchupsTable

	var name: String {
		switch self {
		case .unlockSaveFileBoxes: return "Unlock save file. Links a DS to the save file which lets you use pokemon in your box to create battle passes."
		case .freeSpaceInDol: return "Create some space in \(XGFiles.dol.fileName) which is needed for other assembly patches. Recommended to use this first."
		case .gen7CritRatios: return "Update the critical hit ratios to gen 7 odds"
		case .gen6CriticalHitMultipliers: return "Critical hits deal 1.5x damage, 2.25x with Sniper"
		case .disableRentalPassChecksums: return "Disable legality checks on battle passes"
		case .disableBlurEffect: return "Remove the blur effect from the games rendering"
		case .moveTypeMatchupsTable: return "Move type matchups table to a large area so more matchups can be added"
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
			var offset = start
			while offset < end {
				// replace with nops rather than zeroes so dolphin doesn't complain
				// when panic handlers aren't disabled
				data.replace4BytesAtOffset(offset, withBytes: 0x60000000)
				offset += 4
			}
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

	static func gen6CriticalHitMultipliers() {
		guard region == .EU else {
			printg("This patch hasn't been implemented for this region yet:", region.name)
			return
		}
		let damageMultipliersOffset: Int
		switch region {
		case .US: damageMultipliersOffset = -1
		case .EU: damageMultipliersOffset = 0x3c85f4
		case .JP: damageMultipliersOffset = -1
		case .OtherGame: damageMultipliersOffset = -1
		}

		// These values have to be whole numbers so we will have to divide the damage by 4 after the multipliers are applied
		// In order to get the proper 1.5x and 2.25x multipliers
		XGAssembly.replaceRamASM(RAMOffset: damageMultipliersOffset, newASM: [
			.li(.r30, 6), // regular crit multiplier
			.cmpwi(.r30, 6),
		])
		XGAssembly.replaceRamASM(RAMOffset: damageMultipliersOffset + 0x24, newASM: [
			.li(.r30, 9) // sniper crit multiplier
		])

		let damageCalcOffset: Int
		switch region {
		case .US: damageCalcOffset = -1
		case .EU: damageCalcOffset = 0x3cad84
		case .JP: damageCalcOffset = -1
		case .OtherGame: damageCalcOffset = -1
		}
		let calcDamageBoostFunctionOffset = 0x3c6178

		// Rewrite the assembly to be more concise so we can squeeze in 2 extra instructions for dividing the
		// multiplied value by 4
		XGAssembly.replaceRamASM(RAMOffset: damageCalcOffset, newASM: [
			// shortened code
			.lwz(.r8, .r31, 0x2154),
			.lwz(.r10, .r31, 0x64),
			.lwz(.r6, .r7, 0x01BC),
			.lwz(.r5, .r31, 0x3044),
			.lwz(.r7, .r31, 0x0180),
			.bl(calcDamageBoostFunctionOffset),

			// updated code for crit multipliers
			.lwz(.r0, .r31, 0x2150), // get crit multiplier
			.mullw(.r0, .r3, .r0), // multiply damage by our updated multipliers
			.li(.r4, 4),
			.divw(.r0, .r0, .r4), // divided result by 4
			.stw(.r0, .r31, 0x2144), // store damage

			// rearranged code. moved these instructions just for readability
			.mr(.r3, .r31),
			.lwz(.r4, .r31, 0x64)
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

	static func hidePlayer2TeamPreview() {
		let nopRAMAddresses = [
			0x80154a48,
			0x80154a5c,
			0x80154a70,
			0x80154a84,
			0x80154a98,
			0x80154aac,
			0x80154ad4,
			0x80154ae8,
			0x80154b10,
			0x80154b24,
			0x80154b4c,
			0x80154b60,
			0x80154b88,
			0x80154b9c,
			0x80154bc4,
			0x80154bd8,
			0x80154c00,
			0x80154c14,
			0x80154c30,
			0x80154c4c,
			0x80154c68,
			0x80154c84,
			0x80154ca0,
			0x80154cbc,
			0x80154844,
			0x8015485c,
			0x80154874,
			0x8015488c,
			0x801548a4,
			0x801548bc
		]

		for address in nopRAMAddresses {
			XGAssembly.replaceRamASM(RAMOffset: address & 0xFFFFFF, newASM: [.nop])
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
		case .gen6CriticalHitMultipliers: XGPatcher.gen6CriticalHitMultipliers()
		case .disableRentalPassChecksums: XGPatcher.disableRentalPassChecksums()
		case .disableBlurEffect: XGPatcher.disableBlurEffect()
		case .moveTypeMatchupsTable: XGPatcher.moveTypeMatchupsTableToPassValidationFunction()
		}
	}
}
