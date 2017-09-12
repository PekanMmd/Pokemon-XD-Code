//
//  GoDEvolutionMethodPopUpButton.swift
//  GoD Tool
//
//  Created by StarsMmd on 09/09/2017.
//
//

import Cocoa

class GoDEvolutionMethodPopUpButton: GoDPopUpButton {

	var selectedValue : XGEvolutionMethods {
		return XGEvolutionMethods(rawValue: self.indexOfSelectedItem) ?? .levelUp
	}
	
	func selectEvolutionMethod(method: XGEvolutionMethods) {
		self.selectItem(withTitle: method.string)
	}
	
	override func setUpItems() {
		var values = [String]()
		for i in 0 ... 0x11 {
			values.append(XGEvolutionMethods(rawValue: i)!.string)
		}
		
		self.setTitles(values: values)
	}
	
}
