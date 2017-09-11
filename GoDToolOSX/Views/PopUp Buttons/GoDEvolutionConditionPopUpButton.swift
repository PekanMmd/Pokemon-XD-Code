//
//  GoDEvolutionConditionPopUpButton.swift
//  GoD Tool
//
//  Created by The Steez on 09/09/2017.
//
//

import Cocoa

func allItemsList() -> [String] {
	return XGItems.allItems().map({ (item) -> String in
		return item.name.string
	})
}

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
			values = GoDLevelPopUpButton().itemTitles
		case .shedinja:
			values = GoDLevelPopUpButton().itemTitles
		case .ninjask:
			values = GoDLevelPopUpButton().itemTitles
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








