//
//  GoDGenderPopUpButton.swift
//  GoD Tool
//
//  Created by The Steez on 06/09/2017.
//
//

import Cocoa

class GoDGenderPopUpButton: GoDPopUpButton {
	
	var selectedValue : XGGenders {
		return XGGenders(rawValue: self.indexOfSelectedItem) ?? .genderless
	}
	
	func selectGender(gender: XGGenders) {
		self.selectItem(withTitle: gender.string)
	}
	
	override func setUpItems() {
		var values = [String]()
		
		for g in [XGGenders.male,XGGenders.female,XGGenders.genderless] {
			values.append(g.string)
		}
		
		self.addItems(withTitles: values)
	}
	
}
