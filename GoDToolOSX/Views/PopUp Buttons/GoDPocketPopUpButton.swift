//
//  GoDPocketPopUpButton.swift
//  GoD Tool
//
//  Created by The Steez on 26/10/2018.
//

import Cocoa

class GoDPocketPopUpButton: GoDPopUpButton {

	var selectedValue : XGBagSlots {
		return XGBagSlots(rawValue: self.indexOfSelectedItem) ?? .none
	}
	
	func selectPocket(pocket: XGBagSlots) {
		self.selectItem(withTitle: pocket.name)
	}
	
	override func setUpItems() {
		var values = [String]()
		
		for g in 0 ..< kNumberOfBagSlots {
			values.append(XGBagSlots(rawValue: g)!.name)
		}
		
		self.setTitles(values: values)
	}
    
}
