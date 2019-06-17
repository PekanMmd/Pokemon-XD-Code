//
//  XGBattleBingoCard.swift
//  XG Tool
//
//  Created by StarsMmd on 11/06/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

//let kFirstBattleBingoCardOffset			= 0x1CB0

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


class XGBattleBingoCard: NSObject, XGDictionaryRepresentable, Codable {
	
	@objc var difficulty		= 0
	@objc var subIndex			= 0
	
	@objc var index				= 0
	
	@objc var nameID			= 0
	@objc var detailsID			= 0
	
	@objc var pokemonLevel		= 0
	@objc var startingPokemon	: XGBattleBingoPokemon!
	var panels					= [XGBattleBingoPanel]()
	@objc var rewards			= [Int]()
	
	var name : XGString {
		get {
			return getStringSafelyWithID(id: nameID)
		}
	}
	
	@objc var startOffset : Int {
		get {
			return CommonIndexes.BattleBingo.startOffset + (index * kSizeOfBingoCardData)
		}
	}
	
	override var description : String {
		get {
			var s = ""
			s += "Battle Bingo Card - \(self.index)\n"
			s += "\(startingPokemon)\n\n"
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
	
	
	@objc init(index: Int) {
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
	
	@objc func save() {
		
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
	
	@objc var dictionaryRepresentation : [String : AnyObject] {
		get {
			var dictRep = [String : AnyObject]()
			dictRep["difficulty"] = self.difficulty as AnyObject?
			dictRep["pokemonLevel"] = self.pokemonLevel as AnyObject?
			
			dictRep["startingPokemon"] = self.startingPokemon.dictionaryRepresentation as AnyObject?
			
			var rewardsArray = [AnyObject]()
			for a in rewards {
				rewardsArray.append(a as AnyObject)
			}
			
			var panelsArray = [ [String : AnyObject] ]()
			for a in panels {
				panelsArray.append(a.dictionaryRepresentation)
			}
			
			return dictRep
		}
	}
	
	@objc var readableDictionaryRepresentation : [String : AnyObject] {
		get {
			var dictRep = [String : AnyObject]()
			dictRep["Difficulty"] = self.difficulty as AnyObject?
			dictRep["PokemonLevel"] = self.pokemonLevel as AnyObject?
			
			dictRep["StartingPokemon"] = self.startingPokemon.readableDictionaryRepresentation as AnyObject?
			
			var rewardsArray = [AnyObject]()
			for a in rewards {
				rewardsArray.append(a as AnyObject)
			}
			dictRep["Rewards"] = rewardsArray as AnyObject?
			
			var panelsArray = [ [String : AnyObject] ]()
			for a in panels {
				panelsArray.append(a.readableDictionaryRepresentation)
			}
			dictRep["Panels"] = panelsArray as AnyObject?
			
			return dictRep
		}
	}
	
   
}





















