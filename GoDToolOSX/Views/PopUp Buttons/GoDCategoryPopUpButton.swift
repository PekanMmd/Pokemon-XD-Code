//
//  GoDCategoryPopUpButton.swift
//  GoD Tool
//
//  Created by The Steez on 06/10/2017.
//
//

import Cocoa

class GoDCategoryPopUpButton: GoDPopUpButton {

	var selectedValue : XGMoveCategories {
		return XGMoveCategories(rawValue: self.indexOfSelectedItem) ?? .none
	}
	
	func selectCategory(category: XGMoveCategories) {
		self.selectItem(withTitle: category.string)
	}
	
	override func setUpItems() {
		var values = [String]()
		
		for g in [XGMoveCategories.none,XGMoveCategories.physical,XGMoveCategories.special] {
			values.append(g.string)
		}
		
		self.setTitles(values: values)
	}
	
}
