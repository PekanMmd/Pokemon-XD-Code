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

var allPokemonDeckFileIndexes: [Int] = {
	Array(26 ... 33) + Array(35 ... 40) + Array(43 ... 44)
}()
var allPokemonDeckFiles: [XGFiles] = {
	allPokemonDeckFileIndexes.map {
		XGFiles.indexAndFsysName($0, "deck")
	}
}()
let rentalPassDeckIndex = 33
let rentalPassDeck = XGFiles.indexAndFsysName(rentalPassDeckIndex, "deck")

class XGTrainerPokemon {
	
	var index			= 0
	var file: XGFiles!
	
	var id				= 0
	var species			= XGPokemon.index(0)
	var nature			= XGNatures.hardy
	var gender			= XGGenders.male
	var IVs				= [Int]()
	var EVs				= [Int]()
	var moves			= [XGMoves]()
	var items			= [XGItems]() // pokemon can have up to 4 options for item
	var pokeball		= XGItems.index(4)
	var rank 			= 0 // average colosseum rank it can be chosen in. Between one rank below and one rank above this value.
	var formeID			= 0
	var minLevel		= 0
	var flags			= [Bool]()

	var usesSecondAbility: Bool {
		get { return flags[11] }
		set { flags[11] = newValue }
	}

	var ability : XGAbilities {
		return usesSecondAbility ? self.species.stats.ability2 : self.species.stats.ability1
	}
	
	init(index: Int, file: XGFiles) {
		
		self.index = index
		self.file = file
		let table = GoDDataTable.tableForFile(file)
		guard let data =  table.entryWithIndex(index) else {
			printg("Failed to load trainer pokemon:", file.path, "\nindex:", index)
			return
		}
		
		id = data.getShort(0)
		flags = data.getShort(2).bitArray(count: 16)
		
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
			species = .index(speciesID)
		}
		
		
		pokeball 		= .index(data.getByte(10))
		gender		  	= XGGenders(rawValue: data.getByte(11)) ?? .genderless
		nature			= XGNatures(rawValue: data.getByte(12)) ?? .hardy
		rank 		 	= data.getByte(14)
		
		for i in 0 ..< kNumberOfPokemonMoves {
			let moveIndex = data.getShort(32 + (i * 2))
			if moveIndex >= 0x8000 {
				 // Will be replaced by a random move either from it's level-up learnset or learnable TMs
				let type = PBRRandomMoveType(rawValue: moveIndex & 0xf)!
				let style = PBRRandomMoveStyle(rawValue: (moveIndex >> 4) & 0xf)!
				moves.append(.randomMove(style, type))
			} else {
				moves.append(.index(moveIndex))
			}
		}
		for i in 0 ..< 4 {
			items.append(.index(data.getShort(40 + (i * 2))))
		}
		for i in 0 ..< kNumberOfIVs {
			IVs.append(data.getByte(16 + i))
		}

		let EVTotal	= data.getShort(22)
		var EVProportionsTotal = 0
		for i in 0 ..< kNumberOfEVs {
			EVProportionsTotal += data.getByte(24 + i)
		}
		var EVsArray = [Int]()
		for i in 0 ..< kNumberOfEVs {
			let proportion = data.getByte(24 + i)
			let weighted = (EVTotal * proportion) / max(EVProportionsTotal, 1)
			EVsArray.append(weighted)
		}
		EVs = EVsArray
	}
	
	
	func save() {
		
		let table = GoDDataTable.tableForFile(file)
		guard let data = table.entryWithIndex(index) else {
			printg("Failed to load trainer pokemon:", file.path, "\nindex:", index)
			return
		}
		
		data.setShort(0, to: id)
		data.setShort(2, to: flags.binaryBitsToInt())
		data.setByte(5, to: minLevel)

		data.setShort(6, to: species.index)
		data.setByte(13, to: species.formeID)
		
		let stats = species.stats
		data.setByte(8, to: stats.type1.index)
		data.setByte(9, to: stats.type2.index)

		data.setByte(10, to: pokeball.index)
		data.setByte(11, to: gender.rawValue)
		data.setByte(12, to: nature.rawValue)

		data.setByte(14, to: rank)



		data.save()

		pokeball 		= .index(data.getByte(10))
		gender		  	= XGGenders(rawValue: data.getByte(11))!
		nature			= XGNatures(rawValue: data.getByte(12))!
		rank 		 	= data.getByte(14)

		for i in 0 ..< min(kNumberOfPokemonMoves, moves.count) {
			data.setShort(32 + (i * 2), to: moves[i].index)
		}
		for i in 0 ..< min(4, items.count) {
			data.setShort(40 + (i * 2), to: items[i].index)
		}
		for i in 0 ..< kNumberOfIVs {
			data.setByte(16 + i, to: IVs[i])
		}
		let EVTotal	= EVs.sum
		data.setShort(22, to: EVTotal)
		for i in 0 ..< min(kNumberOfEVs, EVs.count) {
			data.setByte(24 + i, to: EVs[i])
		}
	}
}





















