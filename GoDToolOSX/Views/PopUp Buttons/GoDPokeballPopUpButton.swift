//
//  GoDPokeballPopUpButton.swift
//  GoDToolCL
//
//  Created by The Steez on 08/06/2018.
//

import Cocoa

let pokeballs = XGItems.pokeballs()

class GoDPokeballPopUpButton: GoDPopUpButton {
	
	var selectedValue : XGItems {
		return pokeballs[self.indexOfSelectedItem]
	}
	
	func select(_ value: XGItems) {
		self.selectItem(withTitle: value.name.string)
	}
	
	override func setUpItems() {
		let values = pokeballs.map { (item) -> String in
			return item.name.string
		}
		
		self.setTitles(values: values)
	}
	
}
