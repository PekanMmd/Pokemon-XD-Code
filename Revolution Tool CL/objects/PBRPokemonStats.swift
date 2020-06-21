//
//  Pokemon.swift
//  Mausoleum Stats Tool
//
//  Created by StarsMmd on 26/12/2014.
//  Copyright (c) 2014 StarsMmd. All rights reserved.
// 

import Foundation

let kNumberOfPokemon = PBRDataTable.pokemonBaseStats.numberOfEntries // 501
let kNumberOfTMsAndHMs = 100
let kSizeOfEvolution = 6
let kSizeOfLevelUpMove = 4

class XGPokemonStats: NSObject, XGIndexedValue {
	
	var index			= 0
	var startOffset		= 0
	
	var nameID			= 0
	var speciesNameID	= 0
	var cryFileIndex	= 0
	var firstModelIndex = 0
	
	var type1			= XGMoveTypes.type(0)
	var type2			= XGMoveTypes.type(0)
	
	var ability1		= XGAbilities.ability(0)
	var ability2		= XGAbilities.ability(0)
	
	var wildItem1		= XGItems.item(0)
	var wildItem2		= XGItems.item(0)
	
	var eggGroup1 = 0
	var eggGroup2 = 0
	
	var hp				= 0
	var speed			= 0
	var attack			= 0
	var defense			= 0
	var specialAttack	= 0
	var specialDefense	= 0
	
	var hpEV 				= 0
	var speedEV				= 0
	var attackEV			= 0
	var defenseEV			= 0
	var specialAttackEV		= 0
	var specialDefenseEV	= 0
	
	var height = 0.0 // meters
	var weight = 0.0 // kg
	
	var catchRate = 0
	var expYield = 0
	var expRate = XGExpRate.standard
	var genderRatio = XGGenderRatios.genderless
	var eggCycles = 0
	var baseHappiness = 0
	var colourID = 0
	
	var unknown  = 0
	
	var TMFlags = [Bool]()
	
	var evolutions = [XGEvolution]()
	var levelUpMoves = [XGLevelUpMove]()
	
	var faces : [PBRPokemonImage] {
		let baseIndex = XGPokemon.pokemon(self.index).baseIndex
		let formesData = PBRDataTableEntry.pokemonFaces(index: baseIndex)
		let numberOfFormes = formesData.getByte(7)
		var formes = [PBRPokemonImage]()
		let firstAlternate = formesData.getShort(4)
		for i in 0 ..< numberOfFormes {
			formes.append(.face(firstAlternate + i))
		}
		return formes
	}
	
	var bodies : [PBRPokemonImage] {
		let baseIndex = XGPokemon.pokemon(self.index).baseIndex
		let formesData = PBRDataTableEntry.pokemonBodies(index: baseIndex)
		let numberOfFormes = formesData.getByte(7)
		var formes = [PBRPokemonImage]()
		let firstAlternate = formesData.getShort(4)
		for i in 0 ..< numberOfFormes {
			formes.append(.body(firstAlternate + i))
		}
		return formes
	}
	
	var models : [PBRPokemonModel] {
		let baseIndex = XGPokemon.pokemon(self.index).baseIndex
		if baseIndex != self.index {
			return XGPokemonStats(index: baseIndex).models
		}
		
		var currentIndex = self.firstModelIndex
		var done = false
		var list = [PBRPokemonModel]()
		while !done {
			let model = PBRPokemonModel.regular(currentIndex)
			if model.speciesID == self {
				list += [.regular(currentIndex), .shiny(currentIndex)]
				currentIndex += 1
			} else {
				done = true
			}
		}
		return list
	}
	
	@objc var name : XGString {
		get {
			return getStringSafelyWithID(id: nameID)
		}
	}
	
	@objc var species : XGString {
		get {
			return getStringSafelyWithID(id: speciesNameID)
		}
	}
	
	
	init(index : Int!) {
		super.init()
		
		self.index = index
		let data = PBRDataTableEntry.baseStats(index: self.index)
		
		// each bit of the first 12 bytes represents one tm
		// stored in 32 bit chunks with the least significant bit
		// being the firt tm in that chunk
		// i.e. bit 31 is tm01, bit 0 is tm32 and bit 32 is tm 33
		let flags = data.getWordStream(0, count: 4)
		TMFlags = [Bool]()
		for mask in flags {
			TMFlags += mask.bitArray()
		}
		
		wildItem1 = .item(data.getShort(16))
		wildItem2 = .item(data.getShort(18))
		height = Double(data.getShort(20)) / 10
		weight = Double(data.getShort(22)) / 10
		nameID = data.getShort(24)
		cryFileIndex = data.getShort(26)
		firstModelIndex = data.getShort(28)
		hp = data.getByte(30)
		attack = data.getByte(31)
		defense = data.getByte(32)
		speed = data.getByte(33)
		specialAttack = data.getByte(34)
		specialDefense = data.getByte(35)
		type1 = .type(data.getByte(36))
		type2 = .type(data.getByte(37))
		catchRate = data.getByte(38)
		expYield = data.getByte(39)
		genderRatio = XGGenderRatios(rawValue: data.getByte(42)) ?? .genderless
		eggCycles = data.getByte(43)
		baseHappiness = data.getByte(44)
		expRate = XGExpRate(rawValue: data.getByte(45)) ?? .standard
		eggGroup1 = data.getByte(46)
		eggGroup2 = data.getByte(47)
		ability1 = .ability(data.getByte(48))
		ability2 = .ability(data.getByte(49))
		unknown = data.getByte(50)
		colourID = data.getByte(51)
		
		let EVs = data.getShort(40).bitArray(count: 16)
		// bit mask of EV yields. Each stat is 2 bits starting from the most significant bit being hp.
		if EVs[15] { hpEV += 2 }
		if EVs[14] { hpEV += 1 }
		if EVs[13] { attackEV += 2 }
		if EVs[12] { attackEV += 1 }
		if EVs[11] { defenseEV += 2 }
		if EVs[10] { defenseEV += 1 }
		if EVs[9]  { speedEV += 2 }
		if EVs[8]  { speedEV += 1 }
		if EVs[7]  { specialAttackEV += 2 }
		if EVs[6]  { specialAttackEV += 1 }
		if EVs[5]  { specialDefense += 2 }
		if EVs[4]  { specialDefenseEV += 1 }
		
		let evoData = PBRDataTableEntry.evolutions(index: self.index)
		let moveData = PBRDataTableEntry.levelUpMoves(index: self.index)
		
		let numberOfEvolutions = PBRDataTable.evolutions.entrySize / kSizeOfEvolution
		for i in 0 ..< numberOfEvolutions {
			let offset = i * kSizeOfEvolution
			let method = evoData.getShort(offset + 0)
			let condition = evoData.getShort(offset + 2)
			let evolution = evoData.getShort(offset + 4)
			let evo = XGEvolution(evolutionMethod: method, condition: condition, evolvedForm: evolution)
			evolutions.append(evo)
		}
		
		let numberOfMoves = PBRDataTable.levelUpMoves.entrySize / kSizeOfLevelUpMove
		for i in 0 ..< numberOfMoves {
			let offset = i * kSizeOfLevelUpMove
			let move = moveData.getShort(offset + 0)
			let level = moveData.getByte(offset + 2)
			let lum = XGLevelUpMove(level: level, move: move)
			levelUpMoves.append(lum)
		}
		
	}
	
	@objc func save() {
		
		let data = PBRDataTableEntry.baseStats(index: self.index)
		
		for i in 0 ... 3 {
			let start = i * 32
			let offset = i * 4
			var bits = [Bool]()
			for b in 0 ..< 32 {
				let bit = TMFlags[start + b]
				bits.append(bit)
			}
			data.setWord(offset, to: bits.binaryBitsToUInt32())
		}
		
		data.setShort(16, to: wildItem1.index)
		data.setShort(18, to: wildItem2.index)
		data.setShort(20, to: Int(height * 10))
		data.setShort(22, to: Int(weight * 10))
		data.setShort(24, to: nameID)
		data.setShort(26, to: cryFileIndex)
		data.setShort(28, to: firstModelIndex)
		data.setByte(30, to: hp)
		data.setByte(31, to: attack)
		data.setByte(32, to: defense)
		data.setByte(33, to: speed)
		data.setByte(34, to: specialAttack)
		data.setByte(35, to: specialDefense)
		data.setByte(36, to: type1.index)
		data.setByte(37, to: type2.index)
		data.setByte(38, to: catchRate)
		data.setByte(39, to: expYield)
		data.setByte(42, to: genderRatio.rawValue)
		data.setByte(43, to: eggCycles)
		data.setByte(44, to: baseHappiness)
		data.setByte(45, to: expRate.rawValue)
		data.setByte(46, to: eggGroup1)
		data.setByte(47, to: eggGroup2)
		data.setByte(48, to: ability1.index)
		data.setByte(49, to: ability2.index)
		data.setByte(50, to: unknown)
		data.setByte(51, to: colourID)
		
		data.save()
		
		
		let evoData = PBRDataTableEntry.evolutions(index: self.index)
		let moveData = PBRDataTableEntry.levelUpMoves(index: self.index)
		
		let numberOfEvolutions = evolutions.count
		for i in 0 ..< numberOfEvolutions {
			let offset = i * kSizeOfEvolution
			let (method, condition, evolution) = evolutions[i].toInts()
			evoData.setShort(offset + 0, to: method)
			evoData.setShort(offset + 2, to: condition)
			evoData.setShort(offset + 4, to: evolution)
		}
		
		let numberOfMoves = levelUpMoves.count
		for i in 0 ..< numberOfMoves {
			let offset = i * kSizeOfLevelUpMove
			let (level, move) = levelUpMoves[i].toInts()
			moveData.setShort(offset + 0, to: move)
			moveData.setByte(offset + 2, to: level)
		}
		
	}
	
}


















