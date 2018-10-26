//
//  GoDContextViewController.swift
//  GoD Tool
//
//  Created by The Steez on 26/10/2018.
//

import Cocoa

class GoDContextViewController: GoDViewController {

	@IBOutlet var value: NSTextField!
	@IBOutlet var result: NSTextView!
	
	@IBAction func getContext(_ sender: Any) {
		if self.value.stringValue.length > 0 {
			if let value = self.value.stringValue.integerValue {
				var text = "Value \(value) (\(value.hexString())):\n"
				
				if value >= 0 {
					if value < kNumberOfTypes {
						if let type = XGMoveTypes(rawValue: value) {
							text += "\n\("Type:".spaceToLength(20)) \(type.name)"
						}
					}
				}
				
				if value > 0 {
					
					if value < CommonIndexes.NumberOfMoves.value {
						text += "\n\("Move:".spaceToLength(20)) \(XGMoves.move(value).name.string)"
					}
					if value <= CommonIndexes.NumberOfPokemon.value {
						text += "\n\("Pokemon:".spaceToLength(20)) \(XGPokemon.pokemon(value).name.string)"
						
						if value >= 277 && value <= 386 {
							text += "\n\("Pokemon national index:".spaceToLength(20)) \(XGPokemon.pokemon(value).name.string)"
						}
					}
					
					if value <= kNumberOfAbilities {
						text += "\n\("Ability:".spaceToLength(20)) \(XGAbilities.ability(value).name.string)"
					}
					
					if value <= kNumberOfItems {
						text += "\n\("Item:".spaceToLength(20)) \(XGItems.item(value).name.string)"
					}
					if value > kNumberOfItems && value < 0x250 {
						text += "\n\("Item script index:".spaceToLength(20)) \(XGItems.item(value).name.string)"
					}
					
					for i in 1 ..< kNumberOfItems {
						let item = XGItems.item(i).data
						if item.holdItemID == value {
							text += "\n\("Item hold id:".spaceToLength(20)) \(item.name.string)"
						}
						if item.inBattleUseID == value {
							text += "\n\("Item battle usage id:".spaceToLength(20)) \(item.name.string)"
						}
					}
					
					loadAllStrings()
					if let str = getStringWithID(id: value) {
						text += "\n\("Msg id:".spaceToLength(20)) \(str.stringPlusIDAndFile)"
					}
					
				}
				self.result.string = text
			}
		}
	}
	
}
