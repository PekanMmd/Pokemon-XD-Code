//
//  GoDTypePopUpButton.swift
//  GoD Tool
//
//  Created by StarsMmd on 06/09/2017.
//
//

import Cocoa

class GoDTypePopUpButton: GoDPopUpButton {
	
	var selectedValue : XGMoveTypes {
		return XGMoveTypes(rawValue: self.indexOfSelectedItem) ?? .normal
	}
	
	func selectType(type: XGMoveTypes) {
		self.selectItem(withTitle: type.name)
	}
	
	override func setUpItems() {
		let values = XGMoveTypes.allValues.map { (t) -> String in
			return t.name
		}
		
		self.setTitles(values: values)
	}
	
}
