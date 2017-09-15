//
//  GoDLevelPopUpButton.swift
//  GoD Tool
//
//  Created by StarsMmd on 06/09/2017.
//
//

import Cocoa

class GoDLevelPopUpButton: GoDPopUpButton {
	
	var selectedValue : Int {
		return self.indexOfSelectedItem
	}
	
	func selectLevel(level: Int) {
		selectItem(withTitle: "Lv. " + level.string)
	}
	
	override func setUpItems() {
		var values = [String]()
		
		for i in 0 ... 100 {
			values.append("Lv. " + i.string)
		}
		
		self.setTitles(values: values)
	}

}
