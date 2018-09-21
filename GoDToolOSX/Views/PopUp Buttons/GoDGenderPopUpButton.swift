//
//  GoDGenderPopUpButton.swift
//  GoD Tool
//
//  Created by StarsMmd on 06/09/2017.
//
//

import Cocoa

class GoDGenderPopUpButton: GoDPopUpButton {
	
	var selectedValue : XGGenders {
		return XGGenders(rawValue: self.indexOfSelectedItem) ?? .random
	}
	
	func selectGender(gender: XGGenders) {
		self.selectItem(withTitle: gender.string)
	}
	
	override func setUpItems() {
		var values = [String]()
		
		for g in [XGGenders.male,XGGenders.female,XGGenders.genderless, XGGenders.random] {
			values.append(g.string)
		}
		
		self.setTitles(values: values)
	}
	
}
