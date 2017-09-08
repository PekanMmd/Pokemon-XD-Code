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
	
	func selectNature(nature: XGNatures) {
		selectItem(withTitle: nature.string)
	}
	
	override func setUpItems() {
		let values = XGNatures.allNatures().map { (nature) -> String in
			return nature.string
		}
		
		self.addItems(withTitles: values)
	}
	
}
