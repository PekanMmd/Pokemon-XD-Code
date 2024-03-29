//
//  XGBattleBingoCard.swift
//  XG Tool
//
//  Created by StarsMmd on 11/06/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

let kNumberOfBingoCouponRewards			= 0x0A
let kNumberOfBingoCards					= 0x0B
let kNumberOfPanels						= 0x10
let kSizeOfBingoCardData				= 0xB8

let kNumberOfMysteryPanels				= 0x03
let kNumberOfPokemonPanels				= 0x0D

let kBingoCardIndexOffset				= 0x00
let kBingoCardDifficultyLevelOffset		= 0x01
let kBingoCardSubIndexOffset			= 0x02
let kBingoCardPokemonLevelOffset		= 0x03
let kBingoCardPokemonCountOffset		= 0x06
let kBingoCardMysteryPanelCountOffset	= 0x07
let kBingoCardNameIDOffset				= 0x08
let kBingoCardDetailsIDOffset			= 0x0C
let kBingoCardFirstCouponsRewardOffset	= 0x10
let kBingoCardFirstPokemonOffset		= 0x24
let kBingoCardFirstMysteryPanelOffset	= 0xB0


final class XGBattleBingoCard: NSObject, Codable {
	
	var difficulty		= 0
	var subIndex		= 0
	
	var index			= 0
	
	var nameID			= 0
	var detailsID		= 0
	
	var pokemonLevel	= 0
	var startingPokemon	: XGBattleBingoPokemon!
	var panels			= [XGBattleBingoPanel]()
	var rewards			= [Int]()
	
	var name: XGString {
		get {
			return getStringSafelyWithID(id: nameID)
		}
	}
	
	var startOffset : Int {
		get {
			return CommonIndexes.BattleBingo.startOffset + (index * kSizeOfBingoCardData)
		}
	}
	
	override var description : String {
		get {
			var s = ""
			s += "Battle Bingo Card - \(self.index)\n"
			s += startingPokemon.description + "\n\n"
			for i in 0 ..< 4 {
				for j in 0 ..< 4 {
					var r = "\(panels[i*4 + j])"
					while (r as NSString).length < 30 {
						r += " "
					}
					s += r
				}
				s += "\n"
			}
			s += "\nRewards:\n"
			for reward in rewards.reversed() {
				s += "\(reward)\n"
			}
			return s
		}
	}
	
	
	init(index: Int) {
		super.init()
		
		self.index = index
		
		let start = self.startOffset
		let rel = XGFiles.common_rel.data!
		
		difficulty = rel.getByteAtOffset(start + kBingoCardDifficultyLevelOffset)
		subIndex = rel.getByteAtOffset(start + kBingoCardSubIndexOffset)
		
		nameID = Int(rel.getWordAtOffset(start + kBingoCardNameIDOffset))
		detailsID = Int(rel.getWordAtOffset(start + kBingoCardDetailsIDOffset))
		
		pokemonLevel = rel.getByteAtOffset(start + kBingoCardPokemonLevelOffset)
		
		startingPokemon = XGBattleBingoPokemon(startOffset: start + kBingoCardFirstPokemonOffset)
		for i in 1 ... kNumberOfPokemonPanels {
			
			let poke = XGBattleBingoPokemon(startOffset: start + kBingoCardFirstPokemonOffset + (i * kSizeOfBattleBingoPokemonData))
			
			self.panels.append( .pokemon(poke) )
			
		}
		
		var mysteryOffset = start + kBingoCardFirstMysteryPanelOffset
		for _ in 0  ..< kNumberOfMysteryPanels {
			
			let panelType = rel.getByteAtOffset(mysteryOffset)
			
			mysteryOffset += 1
			
			let panelPosition = rel.getByteAtOffset(mysteryOffset)
			
			// mystery panels are always listed in order of their position
			self.panels.insert( .mysteryPanel( XGBattleBingoItem(rawValue: panelType) ?? .masterBall ) , at:  panelPosition)
			
			mysteryOffset += 1
			
		}
		
		for i in 0 ..< kNumberOfBingoCouponRewards {
			
			rewards.append( rel.get2BytesAtOffset(start + kBingoCardFirstCouponsRewardOffset + (i*2) ) )
			
		}
		
	}
	
	func save() {
		
		let start = self.startOffset
		let rel = XGFiles.common_rel.data!
		
		rel.replaceByteAtOffset(start + kBingoCardPokemonLevelOffset, withByte: self.pokemonLevel)
		
		for i in 0 ..< kNumberOfBingoCouponRewards {
			rel.replace2BytesAtOffset(start + kBingoCardFirstCouponsRewardOffset + (i*2), withBytes: self.rewards[i] & 0xFFFF)
		}
		
		rel.replaceWordAtOffset(start + kBingoCardNameIDOffset, withBytes: UInt32(self.nameID))
		rel.replaceWordAtOffset(start + kBingoCardDetailsIDOffset, withBytes: UInt32(self.detailsID))
		
		rel.save()
		
		
		// do at end because they resave
		self.startingPokemon.save()
		for panel in self.panels {
			switch panel {
			case .pokemon(let poke):
				poke.save()
			case .mysteryPanel(_):
				break
			}
		}
	}
   
}

extension XGBattleBingoCard: XGEnumerable {
	var enumerableName: String {
		return name.string
	}
	
	var enumerableValue: String? {
		return String(format: "%02d", index)
	}
	
	static var className: String {
		return "Battle Bingo Cards"
	}
	
	static var allValues: [XGBattleBingoCard] {
		var values = [XGBattleBingoCard]()
		for i in 0 ..< CommonIndexes.NumberOfBingoCards.value {
			values.append(XGBattleBingoCard(index: i))
		}
		return values
	}
}

extension XGBattleBingoCard: XGDocumentable {
	
	var documentableName: String {
		return (enumerableValue ?? "") + " - " + enumerableName
	}
	
	static var DocumentableKeys: [String] {
		return ["index", "sub index", "name", "difficulty", "pokemon level", "starting pokemon", "panels", "rewards"]
	}
	
	func documentableValue(for key: String) -> String {
		switch key {
		case "index":
			return index.string
		case "sub index":
			return subIndex.string
		case "name":
			return name.string
		case "difficulty":
			return difficulty.string
		case "pokemon level":
			return pokemonLevel.string
		case "starting pokemon":
			return "\n" + startingPokemon.documentableFields
		case "panels":
			var text = ""
			for panel in panels {
				switch panel {
				case .mysteryPanel(let item):
					text += "\n\n" + item.description
				case .pokemon(let pokemon):
					text += "\n\n" + pokemon.documentableFields
				}
			}
			return text
		default:
			return ""
		}
	}
}

















