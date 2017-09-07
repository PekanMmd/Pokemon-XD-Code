//
//  GoDTypePopUpButton.swift
//  GoD Tool
//
//  Created by The Steez on 06/09/2017.
//
//

import Cocoa

class GoDTypePopUpButton: GoDPopUpButton {
	
	var selectedValue : XGMoveTypes {
		return XGMoveTypes(rawValue: self.indexOfSelectedItem) ?? .normal
	}
	
	override func setUpItems() {
		let values = XGMoveTypes.allTypes.map { (t) -> String in
			return t.name
		}
		
		self.addItems(withTitles: values)
	}
	
}
