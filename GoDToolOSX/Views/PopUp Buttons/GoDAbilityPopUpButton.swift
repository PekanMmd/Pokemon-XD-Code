//
//  GoDAbilityPopUpButton.swift
//  GoD Tool
//
//  Created by The Steez on 06/09/2017.
//
//

import Cocoa

var abilitiesAlphabetical = XGAbilities.allAbilities().filter { (a1) -> Bool in
	return a1.nameID > 0 || a1.index == 0
}.sorted { (a1, a2) -> Bool in
	return a1.index == 0 || a1.name.string < a2.name.string
}

class GoDAbilityPopUpButton: GoDPopUpButton {
	
	var selectedValue : XGAbilities {
		return abilitiesAlphabetical[self.indexOfSelectedItem]
	}
	
	func selectAbility(ability: XGAbilities) {
		self.selectItem(withTitle: ability.name.string)
	}
	
	override func setUpItems() {
		let values = abilitiesAlphabetical.map { (a) -> String in
			return a.name.string
		}
		
		self.addItems(withTitles: values)
	}
	
}
