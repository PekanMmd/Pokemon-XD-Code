//
//  GoDEvolutionConditionPopUpButton.swift
//  GoD Tool
//
//  Created by StarsMmd on 09/09/2017.
//
//

import Cocoa

var allItems2 = [String]()

func allItemsList() -> [String] {
	
	if allItems2.isEmpty {
		allItems2 = XGItems.allItems().map({ (item) -> String in
			return item.name.string
		})
	}
	
	return allItems2
}

let levelPopUp = GoDLevelPopUpButton()

class GoDEvolutionConditionPopUpButton: GoDPopUpButton {
	
	var method = XGEvolutionMethods.none {
		didSet {
			self.setUpItems()
		}
	}

	var selectedValue : Int {
		return self.indexOfSelectedItem
	}
	
	func selectCondition(condition: Int) {
		self.selectItem(at: condition)
	}
	
	override func setUpItems() {
		
		var values = [String]()
		self.isEnabled = true
		
		switch method {
		case .levelUp:
			values = levelPopUp.itemTitles
		case .shedinja:
			values = levelPopUp.itemTitles
		case .ninjask:
			values = levelPopUp.itemTitles
		case .evolutionStone:
			values = allItemsList()
		case .levelUpWithKeyItem:
			values = allItemsList()
		case .tradeWithItem:
			values = allItemsList()
		default:
			values = ["-"]
			self.isEnabled = false
			
		}
		
		self.setTitles(values: values)
	}
	
	
}








