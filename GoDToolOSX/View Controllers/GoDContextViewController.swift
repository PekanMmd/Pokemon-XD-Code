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
						let type = XGMoveTypes.index(value)
						text += "\n\("Type:".spaceToLength(20)) \(type.name)"
					}
				}
				
				if value > 0 {
					
					if value < kNumberOfMoves {
						text += "\n\("Move:".spaceToLength(20)) \(XGMoves.index(value).name.unformattedString)"
					}
					if value <= kNumberOfPokemon {
						text += "\n\("Pokemon:".spaceToLength(20)) \(XGPokemon.index(value).name.unformattedString)"
						
						if value >= 277 && value <= 386 {
							text += "\n\("Pokemon national index:".spaceToLength(20)) \(XGPokemon.index(value).name.unformattedString)"
						}
					}
					
					if value <= kNumberOfAbilities {
						text += "\n\("Ability:".spaceToLength(20)) \(XGAbilities.index(value).name.unformattedString)"
					}
					
					if value <= kNumberOfItems {
						text += "\n\("Item:".spaceToLength(20)) \(XGItems.index(value).name.unformattedString)"
					}
					#if !GAME_PBR
					if value > kNumberOfItems && value < 0x250 {
						text += "\n\("Item script index:".spaceToLength(20)) \(XGItems.index(value).name.unformattedString)"
					}
					#endif
					
					for i in 1 ..< kNumberOfItems {
						let item = XGItems.index(i).data
						if item.holdItemID == value {
							text += "\n\("Item hold id:".spaceToLength(20)) \(item.name.unformattedString)"
						}
						#if !GAME_PBR
						if item.inBattleUseID == value {
							text += "\n\("Item battle usage id:".spaceToLength(20)) \(item.name.unformattedString)"
						}
						#else
						if item.subID == value {
							text += "\n\("Item sub id:".spaceToLength(20)) \(item.name.unformattedString)"
						}
						#endif
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
