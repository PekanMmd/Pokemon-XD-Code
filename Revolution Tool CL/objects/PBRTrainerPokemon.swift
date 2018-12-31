//
//  Pokemon.swift
//  Mausoleum Tool
//
//  Created by StarsMmd on 03/10/2014.
//  Copyright (c) 2014 Steezy. All rights reserved.
//

import Foundation

let kSizeOfPokemonData		= 0x38

let kNumberOfPokemonMoves	= 0x04
let kNumberOfEVs			= 0x06
let kNumberOfIVs			= 0x06

class XGTrainerPokemon : NSObject, XGDictionaryRepresentable {
	
	var deckData		= XGDeckPokemon.deck(0, XGDecks.null)
	
	var id				= 0
	var species			= XGPokemon.pokemon(0)
//	var happiness		= 0x0 can't find it. I can only assume return and frustration are always max power?
	var nature			= XGNatures.hardy
	var gender			= XGGenders.male
	var IVs				= [Int]()
	var EVTotal			= 0
	var EVs				= [Int]() // a weighted distibution of total evs
	var moves			= [XGMoves]()
	var items			= [XGItems]() // pokemon can have up to 4 options for item
	var abilityIndex	= 0x0
	var pokeball		= XGItems.item(4)
	var rank 			= 0 // colosseum rank
	var formeID			= 0
	var minLevel		= 0
	var flags			= [Bool]()
	
	var unknown2		= 0
	var unknown3		= 0
	
	var ability : XGAbilities {
		return abilityIndex == 0 ? self.species.stats.ability1 : self.species.stats.ability2
	}
	
	
	init(deckData: XGDeckPokemon) {
		super.init()
		
		self.deckData = deckData
		let data = PBRDataTableEntry(index: deckData.index, deck: deckData.deck)
		
		id = data.getShort(0)
		flags = data.getShort(2).bitArray(count: 16)
		abilityIndex = flags[11] ? 1 : 0
		
		minLevel 		= data.getByte(5)
		let speciesID  	= data.getShort(6)
		formeID			= data.getByte(13)
		
		let deoxysID   = XGPokemon.deoxys(.normal).baseIndex
		let burmyID    = XGPokemon.burmy(.plant).baseIndex
		let wormadamID = XGPokemon.wormadam(.plant).baseIndex
		
		switch speciesID {
		case deoxysID:
			species = .deoxys(XGDeoxysFormes(rawValue: formeID)!)
		case burmyID:
			species = .burmy(XGWormadamCloaks(rawValue: formeID)!)
		case wormadamID:
			species = .wormadam(XGWormadamCloaks(rawValue: formeID)!)
		default:
			species = .pokemon(speciesID)
		}
		
		
		pokeball 		= .item(data.getByte(10))
		gender		  	= XGGenders(rawValue: data.getByte(11))!
		nature			= XGNatures(rawValue: data.getByte(12))!
		rank 		 	= data.getByte(14)
		unknown2		= data.getByte(15)
		EVTotal			= data.getShort(22)
		unknown3		= data.getByte(48)
		
		
		for i in 0 ..< kNumberOfPokemonMoves {
			let moveIndex = data.getShort(32 + (i * 2))
			if moveIndex >= 0x8000 {
				 // Will be replaced by a random move either from it's level-up learnset or learnable TMs
				let type = PBRRandomMoveType(rawValue: moveIndex & 0xf)!
				let style = PBRRandomMoveStyle(rawValue: (moveIndex >> 4) & 0xf)!
				moves.append(.randomMove(style, type))
			} else {
				moves.append(.move(moveIndex))
			}
		}
		for i in 0 ..< 4 {
			items.append(.item(data.getShort(40 + (i * 2))))
		}
		for i in 0 ..< kNumberOfEVs {
			IVs.append(data.getByte(16 + i))
		}
		for i in 0 ..< kNumberOfEVs {
			EVs.append(data.getByte(24 + i))
		}
	}
	
	
	@objc func save() {
		
		let data = PBRDataTableEntry(index: deckData.index, deck: deckData.deck)
		
		data.setShort(0, to: id)
		
		let stats = self.species.stats
		data.setByte(8, to: stats.type1.index)
		data.setByte(9, to: stats.type2.index)
		
		
	}
	
	@objc func purge() {
		species			= XGPokemon.pokemon(0)
		abilityIndex	= 0
		nature			= XGNatures.hardy
		gender			= XGGenders.male
		IVs				= [Int](repeating: 0, count: 6)
		EVs				= [Int](repeating: 0, count: 6)
		items			= [XGItems](repeating: .item(0), count: 4)
		moves			= [XGMoves](repeating: .move(0), count: kNumberOfPokemonMoves)
		
	}


	@objc var dictionaryRepresentation : [String : AnyObject] {
		get {
			var dictRep = [String : AnyObject]()
			dictRep["ability"] = self.ability as AnyObject?
			dictRep["IVs"] = self.IVs as AnyObject?
			
			dictRep["species"] = self.species.dictionaryRepresentation as AnyObject?
			dictRep["nature"] = self.nature.dictionaryRepresentation as AnyObject?
			dictRep["gender"] = self.gender.dictionaryRepresentation as AnyObject?
			
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
			
			return dictRep
		}
	}
	
	@objc var readableDictionaryRepresentation : [String : AnyObject] {
		get {
			var dictRep = [String : AnyObject]()
			
			dictRep["ability"] = (self.ability == 0 ? self.species.stats.ability1.name.string : self.species.stats.ability2.name.string ) as AnyObject?
			dictRep["IVs"] = self.IVs as AnyObject?
			
			dictRep["nature"] = self.nature.string as AnyObject?
			dictRep["gender"] = self.gender.string as AnyObject?
			
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
			
			return [self.species.name.string : dictRep as AnyObject]
		}
	}
	
}





















