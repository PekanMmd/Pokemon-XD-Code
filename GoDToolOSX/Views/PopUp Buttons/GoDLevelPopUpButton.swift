//
//  GoDLevelPopUpButton.swift
//  GoD Tool
//
//  Created by The Steez on 06/09/2017.
//
//

import Cocoa

class GoDLevelPopUpButton: GoDPopUpButton {
	
	var selectedValue : Int {
		return self.indexOfSelectedItem + 1
	}
	
	override func setUpItems() {
		var values = [String]()
		
		for i in 1 ... 100 {
			values.append(i.string)
		}
		
		self.addItems(withTitles: values)
	}

}
