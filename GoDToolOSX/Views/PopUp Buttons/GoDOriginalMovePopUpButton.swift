//
//  GoDOriginalMovePopUpButton.swift
//  GoD Tool
//
//  Created by The Steez on 05/10/2017.
//
//

import Cocoa

class GoDOriginalMovesPopUpButton: GoDJSONPopUpButton {

	override var startIndex: Int {
		return game == .PBR ? -1 : 0
	}
	
	override var file : XGFiles {
		return XGFiles.nameAndFolder("Original Moves.json", .JSON)
	}
	
}
