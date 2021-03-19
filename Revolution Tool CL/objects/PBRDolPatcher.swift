//
//  PBRDolPatcher.swift
//  GoD Tool
//
//  Created by Stars Momodu on 11/07/2020.
//

import Foundation

let patches: [XGDolPatches] = [
	.gen7CritRatios,
	.disableRentalPassChecksums,
	.disableBlurEffect
]

enum XGDolPatches: Int {

	case gen7CritRatios
	case disableRentalPassChecksums
	case disableBlurEffect

	var name: String {
		switch self {
		case .gen7CritRatios : return "Update the critical hit ratios to gen 7 odds"
		case .disableRentalPassChecksums : return "Disable legality checks on battle passes"
		case .disableBlurEffect : return "Remove the blur effect from the games rendering"
		}
	}

}

class XGDolPatcher {

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

	class func applyPatch(_ patch: XGDolPatches) {
		switch patch {
		case .gen7CritRatios: XGDolPatcher.gen7CritRatios()
		case .disableRentalPassChecksums: XGDolPatcher.disableRentalPassChecksums()
		case .disableBlurEffect: XGDolPatcher.disableBlurEffect()
		}
	}
}
