//
//  GoDItemPopUpButton.swift
//  GoD Tool
//
//  Created by The Steez on 06/09/2017.
//
//

import Cocoa

let itemsOrdered = XGItems.allItems().filter { (item) -> Bool in
	return item.nameID > 0 || item.index == 0
}.sorted { (i1, i2) -> Bool in
	return i1.index == 0 || i1.name.string < i2.name.string
}

class GoDItemPopUpButton: GoDPopUpButton {
	
	var selectedValue : XGItems {
		return itemsOrdered[self.indexOfSelectedItem]
	}
	
	func selectItem(item: XGItems) {
		self.selectItem(withTitle: item.name.string)
	}
	
	override func setUpItems() {
		let values = itemsOrdered.map { (item) -> String in
			return item.name.string
		}
		
		self.addItems(withTitles: values)
	}

}
