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
let kPokemonAIRoleOffset	= 0x06
let kFirstPokemonIVOffset	= 0x08
let kFirstPokemonEVOffset	= 0x0E
let kFirstPokemonMoveOffset	= 0x14
let kPokemonPriority1Offset = 0x1D // priority? in vanilla but moved by stars in xg
let kPokemonPIDOffset		= 0x1E
let kPokemonGenRandomOffset = 0x1F // If value is set to 1 then the pokemon is generated with a random nature and gender. Always 0 in vanilla and unused in XG

// added by stars by modifying dol behaviour
let kPokemonshinynessOffset = 0x1C
let kPokemonPriority2Offset	= 0x1F

var isShinyAvailable: Bool {
	return region == .US && XGFiles.dol.data!.getWordAtOffset(0x28bb30 - kDolToRAMOffsetDifference) == 0xa0db001c
}

let kSizeOfShadowData		= 0x18

let kFleeAfterBattleOffset	= 0x00 // 0 = no flee. Other values probably chances of finding with mirorb. Higher value = more common encounter.
let kShadowCatchRateOFfset	= 0x01 // this catch rate overrides the species' catch rate
let kShadowLevelOffset		= 0x02 // the pokemon's level after it's caught. Regular level can be increased so AI shadows are stronger
let kShadowInUseFlagOffset	= 0x03 // flags for whether pokemon is seen/caught/purified etc. default 0x80 and updated in save file
let kShadowStoryIndexOffset	= 0x06 // dpkm index of pokemon data in deck story
let kShadowCounterOffset	= 0x08 // the starting value of the heart gauge
let kFirstShadowMoveOFfset	= 0x0C
let kShadowAggressionOffset	= 0x14 // determines how often it enters reverse mode
let kShadowAlwaysFleeOffset	= 0x15 // the shadow pokemon is sent to miror b. even if you lose the battle

let kPurificationExperienceOffset = 0xA // Should always be 0. The value gets increased as the pokemon gains exp and it is all gained at once upon purification.

final class XGTrainerPokemon : NSObject, Codable {
	
	var deckData		= XGDeckPokemon.dpkm(0, XGDecks.DeckStory)
	
	var species			= XGPokemon.index(0)
	var level			= 0x0
	var happiness		= 0x0
	var item			= XGItems.index(0)
	var AIRole			= 0
	var nature			= XGNatures.hardy
	var gender			= XGGenders.male
	var IVs				= 0x0 // All IVs will be the same. Not much point in varying them.
	var EVs				= [0,0,0,0,0,0]
	var moves			= [XGMoves](repeating: XGMoves.index(0), count: kNumberOfPokemonMoves)
	
	var ability			= 0x0 {
		didSet {
			if ![0,1].contains(ability) {
				ability = 0
			}
		}
	}
	
	var shadowCatchRate 	= 0x0
	var shadowCounter		= 0x0
	var ShadowDataInUse 	= false
	var shadowMoves			= [XGMoves](repeating: XGMoves.index(0), count: kNumberOfPokemonMoves)
	var shadowFleeValue 	= 0x0
	
	var shadowAggression = XGShadowAggression.none
	var shadowAlwaysFlee = 0x0
	var shadowBoostLevel = 0x0 // level before snagged
	
	var priority1 = 0x0
	
	// function of these bytes modified by editing dol code
	var shinyness = XGShinyValues.never
	var priority	  = 0

	var shadowID: Int {
		switch self.deckData {
		case .dpkm:
			return 0
		case .ddpk(let id):
			return id
		}
	}
	
	var startOffset : Int {
		return deckData.pokemonDeck.DPKMDataOffset + (deckData.DPKMIndex * kSizeOfPokemonData)
	}
	
	var shadowStartOffset : Int {
		return XGDecks.DeckDarkPokemon.DDPKDataOffset + (deckData.index * kSizeOfShadowData)
	}
	
	var isShadowPokemon : Bool {
		return deckData.isShadow
	}
	
	var isSet : Bool {
		return deckData.isSet
	}
	
	init(DeckData: XGDeckPokemon) {
		super.init()
		
		self.deckData = DeckData
		
		let data = deckData.pokemonDeck.data
		let start = self.startOffset
		
		species			= deckData.pokemon
		level			= deckData.level
		
		happiness		= data.getByteAtOffset(start + kPokemonHappinessOffset)
		let item		= data.get2BytesAtOffset(start + kPokemonItemOffset)
		self.item		= .index(item)
		self.AIRole 	= data.getByteAtOffset(start + kPokemonAIRoleOffset)
		IVs				= data.getByteAtOffset(start + kFirstPokemonIVOffset)
		
		let pid = data.getByteAtOffset(start + kPokemonPIDOffset)
		
		ability		= pid % 2
		
		let gender	= (pid / 2) % 4
		self.gender = XGGenders(rawValue: gender) ?? .genderless
		
		let nature	= pid / 8
		self.nature	= XGNatures(rawValue: nature) ?? .hardy
		
		self.EVs = data.getByteStreamFromOffset(start + kFirstPokemonEVOffset, length: kNumberOfEVs)
		
		for i in 0 ..< kNumberOfPokemonMoves {
			let index = data.get2BytesAtOffset(start + kFirstPokemonMoveOffset + (i * 2))
			self.moves[i] = .index(index)
		}
		
		if isShadowPokemon {
			
			shadowBoostLevel = data.getByteAtOffset(start + kPokemonLevelOffset)
			
			let data = XGDecks.DeckDarkPokemon.data
			let start = self.shadowStartOffset
			
			shadowCatchRate = data.getByteAtOffset(start + kShadowCatchRateOFfset)
			shadowCounter	= data.get2BytesAtOffset(start + kShadowCounterOffset)
			shadowFleeValue = data.getByteAtOffset(start + kFleeAfterBattleOffset)
			ShadowDataInUse	= data.getByteAtOffset(start + kShadowInUseFlagOffset) == 0x80
			
			shadowAggression = XGShadowAggression(rawValue: data.getByteAtOffset(start + kShadowAggressionOffset)) ?? .none
			shadowAlwaysFlee = data.getByteAtOffset(start + kShadowAlwaysFleeOffset)
			
			
			for i in 0 ..< kNumberOfPokemonMoves {
				let index = data.get2BytesAtOffset(start + kFirstShadowMoveOFfset + (i * 2) )
				self.shadowMoves[i] = .index(index)
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
		
		if self.isShadowPokemon {
			
			self.shinyness = .random
			
			let data = XGDecks.DeckDarkPokemon.data
			
			data.replaceByteAtOffset(shadowStartOffset + kShadowCatchRateOFfset, withByte: shadowCatchRate)
			data.replaceByteAtOffset(shadowStartOffset + kShadowLevelOffset, withByte: level)
			data.replace2BytesAtOffset(shadowStartOffset + kShadowCounterOffset, withBytes: shadowCounter)
			data.replaceByteAtOffset(shadowStartOffset + kFleeAfterBattleOffset, withByte: shadowFleeValue)
			data.replaceByteAtOffset(shadowStartOffset + kShadowAggressionOffset, withByte: shadowAggression.rawValue)
			data.replaceByteAtOffset(shadowStartOffset + kShadowInUseFlagOffset, withByte: ShadowDataInUse ? 0x80 : 0x00)
			data.replaceByteAtOffset(shadowStartOffset + kShadowAlwaysFleeOffset, withByte: shadowAlwaysFlee)
			
			for i in 0 ..< kNumberOfPokemonMoves {
				data.replace2BytesAtOffset(shadowStartOffset + kFirstShadowMoveOFfset + (i * 2), withBytes: self.shadowMoves[i].index)
			}
			
			data.save()
			
		}
		
		let data = self.deckData.pokemonDeck.data
		let start = startOffset
		
		data.replace2BytesAtOffset(start + kPokemonIndexOffset, withBytes: species.index)
		data.replace2BytesAtOffset(start + kPokemonItemOffset, withBytes: item.index)
		data.replaceByteAtOffset(start + kPokemonAIRoleOffset, withByte: AIRole)
		data.replaceByteAtOffset(start + kPokemonHappinessOffset, withByte: happiness)
		data.replaceByteAtOffset(start + kPokemonLevelOffset, withByte: isShadowPokemon ? shadowBoostLevel : level)
		// The shadow pokemon's level is often increased here to make shadow pokemon more powerful (hence the + by their level)
		
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
		species		= XGPokemon.index(0)
		level		= 0
		happiness	= 0
		ability		= 0
		item		= XGItems.index(0)
		nature		= XGNatures.hardy
		gender		= XGGenders.male
		IVs			= 0
		EVs			= [Int](repeating: 0, count: 6)
		moves		= [XGMoves](repeating: XGMoves.index(0), count: kNumberOfPokemonMoves)
		
		shadowCatchRate = 0
		shadowCounter	= 0
		shadowMoves		= [XGMoves](repeating: XGMoves.index(0), count: kNumberOfPokemonMoves)
	}


}

extension XGTrainerPokemon: XGEnumerable {
	var enumerableName: String {
		return deckData.enumerableName
	}
	
	var enumerableValue: String? {
		return deckData.enumerableValue
	}
	
	static var className: String {
		return XGDeckPokemon.className
	}
	
	static var allValues: [XGTrainerPokemon] {
		return XGDeckPokemon.allValues.map({ (dpkm) -> XGTrainerPokemon in
			return dpkm.data
		})
	}
	
	
}

extension XGTrainerPokemon: XGDocumentable {
	
	var documentableName: String {
		return (enumerableValue ?? "") + " - " + enumerableName
	}
	
	static var DocumentableKeys: [String] {
		return ["index", "name", "level", "gender", "nature", "shininess", "moves"]
	}
	
	func documentableValue(for key: String) -> String {
		switch key {
		case "index":
			return deckData.index.string
		case "name":
			return species.name.string
		case "level":
			return level.string
		case "gender":
			return gender.string
		case "nature":
			return nature.string
		case "shininess":
			return shinyness.string
		case "moves":
			var text = ""
			text += "\n" + moves[0].name.string
			text += "\n" + moves[1].name.string
			text += "\n" + moves[2].name.string
			text += "\n" + moves[3].name.string
			return text
		default:
			return ""
		}
	}
}


















