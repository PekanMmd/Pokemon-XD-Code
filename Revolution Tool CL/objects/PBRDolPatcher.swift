//
//  PBRDolPatcher.swift
//  GoD Tool
//
//  Created by Stars Momodu on 11/07/2020.
//

import Foundation

class PBRDolPatcher {

	/// Removes the code for rental pass validation checks
	/// allowing the space to be reused for the type matchups table
	static func moveTypeMatchupsTableToPassValidationFunction() {
		let startOffset = 0x1317cc - kPBRDolToRAMOffsetDifference

		// rental pass validation checks just pass immediately
		XGAssembly.replaceASM(startOffset: startOffset, newASM: [
			.li(.r3, 1),
			.blr
		])

		let movedFromOriginalLocation = PBRTypeManager.typeMatchupDataDolOffset == 0x401348
		let additionalEntryCount = movedFromOriginalLocation ? 20 : 0

		PBRTypeManager.moveTypeMatchupTableToDolOffset(startOffset + 8, increaseEntryNumberBy: additionalEntryCount)
	}
}
