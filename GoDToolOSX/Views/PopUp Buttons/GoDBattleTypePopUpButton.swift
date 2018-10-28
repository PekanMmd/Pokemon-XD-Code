//
//  GoDBattleTypePopUpButton.swift
//  GoD Tool
//
//  Created by The Steez on 27/10/2018.
//

import Cocoa

class GoDBattleTypePopUpButton: GoDPopUpButton {

	var selectedValue : XGBattleTypes {
		return XGBattleTypes(rawValue: self.indexOfSelectedItem) ?? .none
	}
	
	func selectType(type: XGBattleTypes) {
		self.selectItem(withTitle: type.name)
	}
	
	override func setUpItems() {
		var values = [String]()
		
		for i in 0 ... 17 {
			values.append(XGBattleTypes(rawValue: i)!.name)
		}
		
		self.setTitles(values: values)
	}
    
}
