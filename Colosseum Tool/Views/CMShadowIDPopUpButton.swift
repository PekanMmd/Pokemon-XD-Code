//
//  CMShadowIDPopUpButton.swift
//  Colosseum Tool
//
//  Created by Stars Momodu on 30/03/2021.
//

import Cocoa

class CMShadowIDPopUpButton: GoDPopUpButton {

	var selectedValue : Int {
		return self.indexOfSelectedItem
	}

	func selectID(level: Int) {
		selectItem(at: level)
	}

	override func setUpItems() {
		var values = [String]()

		for i in 0 ... CommonIndexes.NumberOfShadowPokemon.value {
			let data = CMShadowData(index: i)
			values.append(i.string + " - \(data.species.name)")
		}

		self.setTitles(values: values)
	}

}
