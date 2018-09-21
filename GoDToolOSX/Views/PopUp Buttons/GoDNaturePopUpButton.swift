//
//  GoDNaturePopUpButton.swift
//  GoD Tool
//
//  Created by StarsMmd on 06/09/2017.
//
//

import Cocoa

class GoDNaturePopUpButton: GoDPopUpButton {

	var selectedValue : XGNatures {
		let all = game == .XD ? XGNatures.allNatures() : XGNatures.allNatures() + [XGNatures.random]
		return all[self.indexOfSelectedItem]
	}
	
	func selectNature(nature: XGNatures) {
		selectItem(withTitle: nature.string)
	}
	
	override func setUpItems() {
		var values = XGNatures.allNatures().map { (nature) -> String in
			return nature.string
		}
		if game == .Colosseum {
			values.append(XGNatures.random.string)
		}
		
		self.setTitles(values: values)
	}
	
}
