//
//  Pokemon.swift
//  Mausoleum Tool
//
//  Created by StarsMmd on 03/10/2014.
//  Copyright (c) 2014 Steezy. All rights reserved.
//

import Foundation

let kSizeOfPokemonData		= 0x20
let kNumberOfPokemonMoves	= 0x04
let kNumberOfEVs			= 0x06
let kNumberOfIVs			= 0x06

let kPokemonIndexOffset		= 0x00
let kPokemonLevelOffset		= 0x02
let kPokemonHappinessOffset	= 0x03
let kPokemonItemOffset		= 0x04
let kFirstPokemonIVOffset	= 0x08
let kFirstPokemonEVOffset	= 0x0E
let kFirstPokemonMoveOffset	= 0x14
let kPokemonPriority1Offset = 0x1D // priority in vanilla but moved by stars in xg
let kPokemonPIDOffset		= 0x1E
let kPokemonGenRandomOffset = 0x1F // If value is set to 1 then the pokemon is generated with a random nature and gender. Always 0 in vanilla and unused in XG

// added by stars by modifying dol behaviour
let kPokemonshinynessOffset = 0x1C
let kPokemonPriority2Offset	= 0x1F

let kSizeOfShadowData		= 0x18

let kFleeAfterBattleOffset	= 0x00 // 0 = no flee. Other values probably chances of finding with mirorb. Higher value = more common encounter.
let kShadowCatchRateOFfset	= 0x01
let kShadowLevelOffset		= 0x02
let kShadowInUseFlagOffset	= 0x03
let kShadowStoryIndexOffset	= 0x06
let kShadowCounterOffset	= 0x08
let kFirstShadowMoveOFfset	= 0x0C
let kShadowAggressionOffset	= 0x14 // determines how often it enters reverse mode
let kShadowUnknown2Offset	= 0x15

let kPurificationExperienceOffset = 0xA // Should always be 0. The value gets increased as the pokemon gains exp and it is all gained at once upon purification.

let isShinyAvailable = XGFiles.dol.data.get4BytesAtOffset(0x28bb30 - kDOLtoRAMOffsetDifference) == 0xa0db001c

class XGTrainerPokemon : NSObject, XGDictionaryRepresentable {
	
	var deckData	= XGDeckPokemon.dpkm(0, XGDecks.DeckStory)
	
	var species		= XGPokemon.pokemon(0)
	var level		= 0x0
	var happiness	= 0x0
	var ability		= 0x0
	var item		= XGItems.item(0)
	var nature		= XGNatures.hardy
	var gender		= XGGenders.male
	var IVs			= 0x0 // All IVs will be the same. Not much point in varying them.
	var EVs			= [Int]()
	var moves		= [XGMoves](repeating: XGMoves.move(0), count: kNumberOfPokemonMoves)
	
	var shadowCatchRate = 0x0
	var shadowCounter	= 0x0
	var ShadowDataInUse = false
	var shadowMoves		= [XGMoves](repeating: XGMoves.move(0), count: kNumberOfPokemonMoves)
	var shadowFleeValue = 0x0
	
	var shadowAggression = 0x0
	var shadowUnknown2 = 0x0
	
	var priority1 = 0x0
	
	// function of these bytes modified by editing dol code
	var shinyness = XGShinyValues.never
	var priority	  = 0
	
	var dictionaryRepresentation : [String : AnyObject] {
		get {
			var dictRep = [String : AnyObject]()
			dictRep["level"] = self.level as AnyObject?
			dictRep["happiness"] = self.happiness as AnyObject?
			dictRep["ability"] = self.ability as AnyObject?
			dictRep["IVs"] = self.IVs as AnyObject?
			
			if self.isShadowPokemon {
				dictRep["shadowCatchRate"] = self.shadowCatchRate as AnyObject?
				dictRep["shadowCounter"] = self.shadowCounter as AnyObject?
				dictRep["fleesToMirorB"] = self.shadowFleeValue as AnyObject?
				dictRep["Aggressiveness"] = self.shadowAggression as AnyObject?
				dictRep["ShadowDataInUse"] = self.ShadowDataInUse as AnyObject?
			}
			
			dictRep["species"] = self.species.dictionaryRepresentation as AnyObject?
			dictRep["item"] = self.item.dictionaryRepresentation as AnyObject?
			dictRep["nature"] = self.nature.dictionaryRepresentation as AnyObject?
			dictRep["gender"] = self.gender.dictionaryRepresentation as AnyObject?
			dictRep["shinyness"] = self.shinyness.dictionaryRepresentation as AnyObject?
			
			var EVsArray = [AnyObject]()
			for a in EVs {
				EVsArray.append(a as AnyObject)
			}
			dictRep["EVs"] = EVsArray as AnyObject?
			
			var movesArray = [ [String : AnyObject] ]()
			for a in moves {
				movesArray.append(a.dictionaryRepresentation)
			}
			dictRep["moves"] = movesArray as AnyObject?
			
			if self.isShadowPokemon {
				var shadowMovesArray = [ [String : AnyObject] ]()
				for a in shadowMoves {
					shadowMovesArray.append(a.dictionaryRepresentation)
				}
				dictRep["shadowMoves"] = shadowMovesArray as AnyObject?
			}
			
			return dictRep
		}
	}
	
	var readableDictionaryRepresentation : [String : AnyObject] {
		get {
			var dictRep = [String : AnyObject]()
			
			var shadowData = [String : AnyObject]()
			
			dictRep["level"] = self.level as AnyObject?
			dictRep["happiness"] = self.happiness as AnyObject?
			if self.ability == 0xFF {
				dictRep["ability"] = "Random" as AnyObject?
			} else if self.isShadowPokemon {
				dictRep["ability"] = (self.species.stats.ability2.index == 0 ? self.species.stats.ability1.name.string : self.species.stats.ability1.name.string + " / " + self.species.stats.ability2.name.string) as AnyObject?
			} else {
				dictRep["ability"] = (self.ability == 0 ? self.species.stats.ability1.name.string : self.species.stats.ability2.name.string ) as AnyObject?
			}
			dictRep["IVs"] = self.IVs as AnyObject?
			
			if self.isShadowPokemon {
				shadowData["shadowCatchRate"] = self.shadowCatchRate as AnyObject?
				shadowData["shadowCounter"] = self.shadowCounter as AnyObject?
				shadowData["fleesToMirorB"] = self.shadowFleeValue as AnyObject?
				shadowData["aggressiveness"] = self.shadowAggression as AnyObject?
				shadowData["inUse"] = self.ShadowDataInUse as AnyObject?
				shadowData["Aggression"] = self.shadowAggression as AnyObject?
			}
			
			dictRep["item"] = self.item.name.string as AnyObject?
			dictRep["nature"] = self.nature.string as AnyObject?
			dictRep["gender"] = self.gender.string as AnyObject?
			dictRep["shinyness"] = self.shinyness.string as AnyObject?
			
			var EVsDict = [String : AnyObject]()
			EVsDict["HP"] = EVs[0] as AnyObject?
			EVsDict["attack"] = EVs[1] as AnyObject?
			EVsDict["defense"] = EVs[2] as AnyObject?
			EVsDict["sp.atk"] = EVs[3] as AnyObject?
			EVsDict["sp.def"] = EVs[4] as AnyObject?
			EVsDict["speed"] = EVs[5] as AnyObject?
			dictRep["EVs"] = EVsDict as AnyObject?
			
			var movesArray = [AnyObject]()
			for a in moves {
				movesArray.append(a.name.string as AnyObject)
			}
			dictRep["moves"] = movesArray as AnyObject?
			
			if self.isShadowPokemon {
				var shadowMovesArray = [AnyObject]()
				for a in shadowMoves {
					shadowMovesArray.append(a.name.string as AnyObject)
				}
				shadowData["moves"] = shadowMovesArray as AnyObject?
				dictRep["shadowData"] = shadowData as AnyObject?
			}
			
			return [self.species.name.string : dictRep as AnyObject]
		}
	}
	
	
	var startOffset : Int {
		get {
			return deckData.deck.DPKMDataOffset + (deckData.DPKMIndex * kSizeOfPokemonData)
		}
	}
	
	var shadowStartOffset : Int {
		get {
			return XGDecks.DeckDarkPokemon.DDPKDataOffset + (deckData.index * kSizeOfShadowData)
		}
	}
	
	var isShadowPokemon : Bool {
		get {
			return deckData.isShadow
		}
	}
	
	var isSet : Bool {
		get {
			return deckData.isSet
		}
	}
	
	init(DeckData: XGDeckPokemon) {
		super.init()
		
		self.deckData = DeckData
		
		
		let data = deckData.deck.data
		let start = self.startOffset
		
		species			= deckData.pokemon
		level			= deckData.level
		
		happiness		= data.getByteAtOffset(start + kPokemonHappinessOffset)
		let item		= data.get2BytesAtOffset(start + kPokemonItemOffset)
		self.item		= .item(item)
		IVs				= data.getByteAtOffset(start + kFirstPokemonIVOffset)
		
		let pid = data.getByteAtOffset(start + kPokemonPIDOffset)
		
		ability		= pid % 2
		
		let gender	= (pid / 2) % 4
		self.gender = XGGenders(rawValue: gender)!
		
		let nature	= pid / 8
		self.nature	= XGNatures(rawValue: nature)!
		
		self.EVs = data.getByteStreamFromOffset(start + kFirstPokemonEVOffset, length: kNumberOfEVs)
		
		for i in 0 ..< kNumberOfPokemonMoves {
			let index = data.get2BytesAtOffset(start + kFirstPokemonMoveOffset + (i * 2))
			self.moves[i] = .move(index)
		}
		
		if isShadowPokemon {
			
			let data = XGDecks.DeckDarkPokemon.data
			let start = self.shadowStartOffset
			
			shadowCatchRate = data.getByteAtOffset(start + kShadowCatchRateOFfset)
			shadowCounter	= data.get2BytesAtOffset(start + kShadowCounterOffset)
			shadowFleeValue = data.getByteAtOffset(start + kFleeAfterBattleOffset)
			level			= data.getByteAtOffset(start + kShadowLevelOffset)
			ShadowDataInUse	= data.getByteAtOffset(start + kShadowInUseFlagOffset) == 0x80
			
			shadowAggression = data.getByteAtOffset(start + kShadowAggressionOffset)
			shadowUnknown2 = data.getByteAtOffset(start + kShadowUnknown2Offset)
			
			for i in 0 ..< kNumberOfPokemonMoves {
				let index = data.get2BytesAtOffset(start + kFirstShadowMoveOFfset + (i * 2) )
				self.shadowMoves[i] = .move(index)
			}
		}
		
		// priority in vanilla files
		self.priority1 = data.getByteAtOffset(start + kPokemonPriority1Offset)
		
		let shiny = data.get2BytesAtOffset(start + kPokemonshinynessOffset)
		self.shinyness = XGShinyValues(rawValue: shiny) ?? .never
		// priority in XG
		self.priority = data.getByteAtOffset(start + kPokemonPriority2Offset)
		
	}
	
	
	func save() {
		
		let data = self.deckData.deck.data
		let start = startOffset
		
		if self.isShadowPokemon {
			
			self.shinyness = .random
			
			let data = XGDecks.DeckDarkPokemon.data
			
			data.replaceByteAtOffset(shadowStartOffset + kShadowCatchRateOFfset, withByte: shadowCatchRate)
			data.replaceByteAtOffset(shadowStartOffset + kShadowLevelOffset, withByte: level)
			data.replace2BytesAtOffset(shadowStartOffset + kShadowCounterOffset, withBytes: shadowCounter)
			data.replaceByteAtOffset(shadowStartOffset + kFleeAfterBattleOffset, withByte: shadowFleeValue)
			data.replaceByteAtOffset(shadowStartOffset + kShadowAggressionOffset, withByte: shadowAggression)
			data.replaceByteAtOffset(shadowStartOffset + kShadowInUseFlagOffset, withByte: ShadowDataInUse ? 0x80 : 0x00)
			
			for i in 0 ..< kNumberOfPokemonMoves {
				data.replace2BytesAtOffset(shadowStartOffset + kFirstShadowMoveOFfset + (i * 2), withBytes: self.shadowMoves[i].index)
			}
			
		}
		
		data.replace2BytesAtOffset(start + kPokemonIndexOffset, withBytes: species.index)
		data.replace2BytesAtOffset(start + kPokemonItemOffset, withBytes: item.index)
		data.replaceByteAtOffset(start + kPokemonHappinessOffset, withByte: happiness)
		data.replaceByteAtOffset(start + kPokemonLevelOffset, withByte: isShadowPokemon ? (level + 5) : level)
		// The shadow pokemon's level is often increased here to increase the prize money from shadow trainers
		
		var pid = self.nature.rawValue << 3
		pid += self.gender.rawValue << 1
		pid += self.ability
		
		data.replaceByteAtOffset(start + kPokemonPIDOffset, withByte: pid)
		
		let IVs = [Int](repeating: self.IVs, count: kNumberOfIVs)
		data.replaceBytesFromOffset(start + kFirstPokemonIVOffset, withByteStream: IVs)
		
		data.replaceBytesFromOffset(start + kFirstPokemonEVOffset, withByteStream: self.EVs)
		
		for i in 0 ..< kNumberOfPokemonMoves {
			data.replace2BytesAtOffset(start + kFirstPokemonMoveOffset + (i * 2), withBytes: self.moves[i].index)
		}
		
		data.replaceByteAtOffset(start + kPokemonPriority2Offset, withByte: self.priority)
		
		if isShinyAvailable {
			data.replace2BytesAtOffset(start + kPokemonshinynessOffset, withBytes: self.shinyness.rawValue)
		}
		
		data.save()
		
	}
	
	func purge() {
		species		= XGPokemon.pokemon(0)
		level		= 0
		happiness	= 0
		ability		= 0
		item		= XGItems.item(0)
		nature		= XGNatures.hardy
		gender		= XGGenders.male
		IVs			= 0
		EVs			= [Int](repeating: 0, count: 6)
		moves		= [XGMoves](repeating: XGMoves.move(0), count: kNumberOfPokemonMoves)
		
		shadowCatchRate = 0
		shadowCounter	= 0
		shadowMoves		= [XGMoves](repeating: XGMoves.move(0), count: kNumberOfPokemonMoves)
	}


}





















