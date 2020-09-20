//
//  PBRDolPatcher.swift
//  GoD Tool
//
//  Created by Stars Momodu on 11/07/2020.
//

import Foundation

class XGDolPatcher {

	/// Removes the code for rental pass validation checks
	/// allowing the space to be reused for the type matchups table
	static func moveTypeMatchupsTableToPassValidationFunction() {
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

	static func disableRentalPassChecksums() {
		XGAssembly.replaceASM(startOffset: 0x3DAF40 - kDolToRAMOffsetDifference, newASM: [
			.b(0x2c)
		])
		XGAssembly.replaceASM(startOffset: 0x3dda20 - kDolToRAMOffsetDifference, newASM: [
			.b(0x2c)
		])

		XGAssembly.replaceASM(startOffset: 0x3de140 - kDolToRAMOffsetDifference, newASM: [
			.b(0x24)
		])

		XGAssembly.replaceASM(startOffset: 0x3db6bc - kDolToRAMOffsetDifference, newASM: [
			.b(0x30)
		])

		XGAssembly.replaceASM(startOffset: 0x3db568 - kDolToRAMOffsetDifference, newASM: [
			.b(0x30)
		])

		XGAssembly.replaceASM(startOffset: 0x3DA370 - kDolToRAMOffsetDifference, newASM: [
			.li(.r3, 0)
		])
	}

	static func isClassSplitImplemented() -> Bool {
		return true
	}
}
