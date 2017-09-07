//
//  GoDNaturePopUpButton.swift
//  GoD Tool
//
//  Created by The Steez on 06/09/2017.
//
//

import Cocoa

class GoDNaturePopUpButton: GoDPopUpButton {

	var selectedValue : XGNatures {
		return XGNatures.allNatures()[self.indexOfSelectedItem]
	}
	
	override func setUpItems() {
		let values = XGNatures.allNatures().map { (nature) -> String in
			return nature.string
		}
		
		self.addItems(withTitles: values)
	}
	
}
