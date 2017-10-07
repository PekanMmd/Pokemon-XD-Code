//
//  GoDEffectsPopUpButton.swift
//  GoD Tool
//
//  Created by The Steez on 05/10/2017.
//
//

import Cocoa

class GoDEffectsPopUpButton: GoDJSONPopUpButton {
	
	override var file : XGFiles {
		return XGFiles.nameAndFolder("Move Effects.json", .JSON)
	}
	
}
