//
//  Pokemon.swift
//  Mausoleum Stats Tool
//
//  Created by StarsMmd on 26/12/2014.
//  Copyright (c) 2014 StarsMmd. All rights reserved.
// 

import Foundation

var kNumberOfPokemon: Int {
	return GoDDataTable.pokemonBaseStats.numberOfEntries // 501 in vanilla
}
let kNumberOfTMs = 92
let kNumberOfTMsAndHMs = 100
let kNumberOfTutorMoves = 0 // for XD compatibility
let kSizeOfEvolution = 6
let kSizeOfLevelUpMove = 4

final class XGPokemonStats: NSObject, XGIndexedValue {
	
	var index			= 0
	var baseIndex: Int {
		return XGPokemon.index(index).baseIndex
	}
	var startOffset		= 0
	
	var nameID			= 0
	var speciesNameID	= 0
	var jpNameID		= 0
	var firstModelIndex = 0
	
	var type1			= XGMoveTypes.index(0)
	var type2			= XGMoveTypes.index(0)
	
	var ability1		= XGAbilities.index(0)
	var ability2		= XGAbilities.index(0)
	
	var heldItem1		= XGItems.index(0)
	var heldItem2		= XGItems.index(0)
	
	var eggGroup1 		= 0
	var eggGroup2		= 0
	
	var hp				= 0
	var speed			= 0
	var attack			= 0
	var defense			= 0
	var specialAttack	= 0
	var specialDefense	= 0
	
	var hpYield 			= 0
	var speedYield			= 0
	var attackYield			= 0
	var defenseYield		= 0
	var specialAttackYield	= 0
	var specialDefenseYield	= 0
	
	var height = 0.0 // meters
	var weight = 0.0 // kg
	
	var catchRate = 0
	var baseExp = 0
	var levelUpRate = XGExpRate.standard
	var genderRatio = XGGenderRatios.genderless
	var eggCycles = 0
	var baseHappiness = 0
	var colourID = 0
	
	var unknown  = 0
	
	var learnableTMs = [Bool]()
	var tutorMoves: [Bool]! // Just for XD compatibility
	
	var evolutions = [XGEvolution]()
	var levelUpMoves = [XGLevelUpMove]()

	var baseStatTotal: Int {
		return hp + attack + defense + specialAttack + specialDefense + speed
	}

	var facesEntry: GoDDataTableEntry {
		return GoDDataTableEntry.pokemonFaces(index: baseIndex)
	}

	var faces : [PBRPokemonImage] {
		let formesData = facesEntry
		let numberOfFormes = formesData.getByte(7) / 2 // unevolved pokemon that can evolve seem to have 3 for this value for some reason. least significant bit is read separately but don't know what it's used for atm
		var formes = [PBRPokemonImage]()
		let firstAlternate = formesData.getShort(4)
		for i in 0 ..< numberOfFormes {
			formes.append(.face(firstAlternate + i))
		}
		return formes
	}

	var bodiesEntry: GoDDataTableEntry {
		return GoDDataTableEntry.pokemonBodies(index: baseIndex)
	}
	
	var bodies : [PBRPokemonImage] {
		let formesData = bodiesEntry
		let numberOfFormes = formesData.getByte(7)
		var formes = [PBRPokemonImage]()
		let firstAlternate = formesData.getShort(4)
		for i in 0 ..< numberOfFormes {
			formes.append(.body(firstAlternate + i))
		}
		return formes
	}
	
	var models: [PBRPokemonModel] {
		if baseIndex != index {
			return XGPokemonStats(index: baseIndex).models
		}

		let totalNumberOfModels = GoDDataTable.pokemonModels.numberOfEntries
		var currentIndex = firstModelIndex
		var done = false
		var list = [PBRPokemonModel]()
		while !done && currentIndex < totalNumberOfModels {
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
	
	var name : XGString {
		get {
			return getStringSafelyWithID(id: nameID)
		}
	}
	
	var species : XGString {
		get {
			return getStringSafelyWithID(id: speciesNameID)
		}
	}
	
	
	init(index : Int) {
		super.init()
		
		self.index = index
		let data = GoDDataTableEntry.baseStats(index: index)
		startOffset = GoDDataTable.pokemonBaseStats.offsetForEntryWithIndex(index)
		
		// each bit of the first 12 bytes represents one tm
		// stored in 32 bit chunks with the least significant bit
		// being the firt tm in that chunk
		// i.e. bit 31 is tm01, bit 0 is tm32 and bit 31 of the next word is tm 33
		let flags = data.getWordStream(0, count: 4)
		learnableTMs = [Bool]()
		for mask in flags {
			learnableTMs += mask.bitArray()
		}
		
		heldItem1 = .index(data.getShort(16))
		heldItem2 = .index(data.getShort(18))
		height = Double(data.getShort(20)) / 10 // m
		weight = Double(data.getShort(22)) / 10 // kg
		nameID = data.getShort(24)
		jpNameID = region == .JP ? 0 : data.getShort(26)
		firstModelIndex = data.getShort(region == .JP ? 26 : 28)
		hp = data.getByte(region == .JP ? 28 : 30)
		attack = data.getByte(region == .JP ? 29 : 31)
		defense = data.getByte(region == .JP ? 30 : 32)
		speed = data.getByte(region == .JP ? 31 : 33)
		specialAttack = data.getByte(region == .JP ? 32 : 34)
		specialDefense = data.getByte(region == .JP ? 33 : 35)
		type1 = .index(data.getByte(region == .JP ? 34 : 36))
		type2 = .index(data.getByte(region == .JP ? 35 : 37))
		catchRate = data.getByte(region == .JP ? 36 : 38)
		baseExp = data.getByte(region == .JP ? 37 : 39)
		genderRatio = XGGenderRatios(rawValue: data.getByte(region == .JP ? 40 : 42)) ?? .genderless
		eggCycles = data.getByte(region == .JP ? 41 : 43)
		baseHappiness = data.getByte(region == .JP ? 42 : 44)
		levelUpRate = XGExpRate(rawValue: data.getByte(region == .JP ? 43 : 45)) ?? .standard
		eggGroup1 = data.getByte(region == .JP ? 44 : 46)
		eggGroup2 = data.getByte(region == .JP ? 45 : 47)
		ability1 = .index(data.getByte(region == .JP ? 46 : 48))
		ability2 = .index(data.getByte(region == .JP ? 47 : 49))
		unknown = data.getByte(region == .JP ? 48 : 50)
		// let unknownValue = data.getByte(region == .JP ? 49 : 51) & 0x1
		colourID = (data.getByte(region == .JP ? 49 : 51) & 0xfe) >> 1
		
		let EVs = data.getShort(region == .JP ? 38 : 40).bitArray(count: 16)
		// bit mask of EV yields. Each stat is 2 bits starting from the most significant bit being hp.
		if EVs[15] { hpYield += 2 }
		if EVs[14] { hpYield += 1 }
		if EVs[13] { attackYield += 2 }
		if EVs[12] { attackYield += 1 }
		if EVs[11] { defenseYield += 2 }
		if EVs[10] { defenseYield += 1 }
		if EVs[9]  { speedYield += 2 }
		if EVs[8]  { speedYield += 1 }
		if EVs[7]  { specialAttackYield += 2 }
		if EVs[6]  { specialAttackYield += 1 }
		if EVs[5]  { specialDefenseYield += 2 }
		if EVs[4]  { specialDefenseYield += 1 }
		
		let evoData = GoDDataTableEntry.evolutions(index: self.index)
		let moveData = GoDDataTableEntry.levelUpMoves(index: self.index)
		
		let numberOfEvolutions = GoDDataTable.evolutions.entrySize / kSizeOfEvolution
		for i in 0 ..< numberOfEvolutions {
			let offset = i * kSizeOfEvolution
			let method = evoData.getShort(offset + 0)
			let condition = evoData.getShort(offset + 2)
			let evolution = evoData.getShort(offset + 4)
			let evo = XGEvolution(evolutionMethod: method, condition: condition, evolvedForm: evolution)
			evolutions.append(evo)
		}
		
		let numberOfMoves = GoDDataTable.levelUpMoves.entrySize / kSizeOfLevelUpMove
		for i in 0 ..< numberOfMoves {
			let offset = i * kSizeOfLevelUpMove
			let move = moveData.getShort(offset + 0)
			let level = moveData.getByte(offset + 2)
			let lum = XGLevelUpMove(level: level, move: move)
			levelUpMoves.append(lum)
		}
	}
	
	func save() {
		
		let data = GoDDataTableEntry.baseStats(index: self.index)
		
		for i in 0 ... 3 {
			let start = i * 32
			var bits = [Bool]()
			for b in 0 ..< 32 {
				let bit = learnableTMs[start + b]
				bits.append(bit)
			}

			let offset = i * 4
			data.setWord(offset, to: bits.binaryBitsToUInt32())
		}
		
		data.setShort(16, to: heldItem1.index)
		data.setShort(18, to: heldItem2.index)
		data.setShort(20, to: Int(height * 10))
		data.setShort(22, to: Int(weight * 10))
		data.setShort(24, to: nameID)
		if region != .JP {
			data.setShort(26, to: jpNameID)
		}
		data.setShort(region == .JP ? 26 : 28, to: firstModelIndex)
		data.setByte(region == .JP ? 28 : 30, to: hp)
		data.setByte(region == .JP ? 29 : 31, to: attack)
		data.setByte(region == .JP ? 30 : 32, to: defense)
		data.setByte(region == .JP ? 31 : 33, to: speed)
		data.setByte(region == .JP ? 32 : 34, to: specialAttack)
		data.setByte(region == .JP ? 33 : 35, to: specialDefense)
		data.setByte(region == .JP ? 34 : 36, to: type1.index)
		data.setByte(region == .JP ? 35 : 37, to: type2.index)
		data.setByte(region == .JP ? 36 : 38, to: catchRate)
		data.setByte(region == .JP ? 37 : 39, to: baseExp)
		data.setByte(region == .JP ? 40 : 42, to: genderRatio.rawValue)
		data.setByte(region == .JP ? 41 : 43, to: eggCycles)
		data.setByte(region == .JP ? 42 : 44, to: baseHappiness)
		data.setByte(region == .JP ? 43 : 45, to: levelUpRate.rawValue)
		data.setByte(region == .JP ? 44 : 46, to: eggGroup1)
		data.setByte(region == .JP ? 45 : 47, to: eggGroup2)
		data.setByte(region == .JP ? 46 : 48, to: ability1.index)
		data.setByte(region == .JP ? 47 : 49, to: ability2.index)
		data.setByte(region == .JP ? 48 : 50, to: unknown)
//		data.setByte(region == .JP ? 49 : 51, to: colourID)

		var EVs = 0
		for evYield in [hpYield, attackYield, defenseYield, speedYield, specialAttackYield, specialDefenseYield] {
			EVs = EVs << 1
			EVs += evYield & 0x2
			EVs = EVs << 1
			EVs += evYield & 0x1
		}
		EVs = EVs << 4
		data.setShort(region == .JP ? 38 : 40, to: EVs)
		
		data.save()
		
		
		let evoData = GoDDataTableEntry.evolutions(index: self.index)
		let moveData = GoDDataTableEntry.levelUpMoves(index: self.index)
		
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

extension XGPokemonStats: XGEnumerable {
	var enumerableName: String {
		return name.unformattedString.spaceToLength(20)
	}

	var enumerableValue: String? {
		return index.string
	}

	static var className: String {
		return "Pokemon"
	}

	static var allValues: [XGPokemonStats] {
		return XGPokemon.allPokemon().map { $0.stats }
	}
}

extension XGPokemonStats: XGDocumentable {

	var isDocumentable: Bool {
		return nameID != 0
	}

	var documentableName: String {
		return enumerableName + " - " + (enumerableValue ?? "")
	}

	static var DocumentableKeys: [String] {
		return ["index", "name", "type 1", "type 2", "ability 1", "ability 2", "base HP", "base attack", "base defense", "base special attack", "base special defense", "base speed", "species", "level up rate", "gender ratio", "catch rate", "exp yield", "base happiness", "wild item 1", "wild item 2", "HP yield", "attack yield", "defense yield", "special attack yield", "special defense yield", "speed yield", "height", "weight", "evolutions", "learnable TMs", "level up moves"]
	}

	func documentableValue(for key: String) -> String {
		switch key {
		case "index":
			return index.string
		case "hex index":
			return index.hexString()
		case "name":
			return name.unformattedString
		case "type 1":
			return type1.name
		case "type 2":
			return type2.name
		case "ability 1":
			return ability1.name.unformattedString
		case "ability 2":
			return ability2.name.unformattedString
		case "base attack":
			return attack.string
		case "base HP":
			return hp.string
		case "base defense":
			return defense.string
		case "base special attack":
			return specialAttack.string
		case "base special defense":
			return specialDefense.string
		case "base speed":
			return speed.string
		case "species":
			return species.string
		case "level up rate":
			return levelUpRate.string
		case "gender ratio":
			return genderRatio.string
		case "catch rate":
			return catchRate.string
		case "exp yield":
			return baseExp.string
		case "base happiness":
			return baseHappiness.string
		case "wild item 1":
			return heldItem1.name.string
		case "wild item 2":
			return heldItem2.name.string
		case "attack yield":
			return attackYield.string
		case "defense yield":
			return defenseYield.string
		case "HP yield":
			return hpYield.string
		case "special attack yield":
			return specialAttackYield.string
		case "special defense yield":
			return specialDefenseYield.string
		case "speed yield":
			return speedYield.string
		case "height":
			return String(format: "%2.1f m", height)
		case "weight":
			return String(format: "%2.1f kg", weight)
		case "evolutions":
			var evolutionString = ""
			for evolution in evolutions where evolution.evolutionMethod != .none {
				evolutionString += "\n" + evolution.documentableFields
			}
			return evolutionString
		case "learnable TMs":
			var tmString = ""
			for i in 0 ..< kNumberOfTMsAndHMs {
				tmString += "\n" + XGTMs.tm(i + 1).move.name.unformattedString + ": " + learnableTMs[i].string
			}
			return tmString
		case "level up moves":
			var movesString = ""
			for lum in levelUpMoves where lum.move.index != 0 {
				movesString += "\n" + lum.documentableFields
			}
			return movesString
		default:
			return ""
		}
	}
}















