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

class XGTrainerPokemon {
	
	var deckData		= XGDeckPokemon.deck(0, XGDecks.null)
	
	var id				= 0
	var species			= XGPokemon.pokemon(0)
//	var happiness		= 0x0 can't find it. Not sure how this is determined
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
		
		self.deckData = deckData
		let table = PBRDataTable.tableForFile(deckData.deck.file)
		guard let data =  table.entryWithIndex(deckData.index) else {
			printg("Failed to load trainer pokemon:", deckData.deck.file.path, "\nindex:", deckData.index)
			return
		}
		
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
	
	
	func save() {
		
		let table = PBRDataTable.tableForFile(deckData.deck.file)
		guard let data =  table.entryWithIndex(deckData.index) else {
			printg("Failed to load trainer pokemon:", deckData.deck.file.path, "\nindex:", deckData.index)
			return
		}
		
		data.setShort(0, to: id)

		data.setShort(6, to: species.index)
		data.setByte(13, to: species.formeID)
		
		let stats = species.stats
		data.setByte(8, to: stats.type1.index)
		data.setByte(9, to: stats.type2.index)
		data.save()
	}
}





















