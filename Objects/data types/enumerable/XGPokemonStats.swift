//
//  Pokemon.swift
//  Mausoleum Stats Tool
//
//  Created by StarsMmd on 26/12/2014.
//  Copyright (c) 2014 StarsMmd. All rights reserved.
// 

import Foundation

let kNumberOfPokemon		= CommonIndexes.NumberOfPokemon.value //0x19F
let kSizeOfPokemonStats		= 0x124
//let kFirstPokemonOffset		= 0x29DA8

let kEXPRateOffset			= 0x00
let kCatchRateOffset		= 0x01
let kGenderRatioOffset		= 0x02
let kBaseEXPOffset			= 0x05
let kBaseHappinessOffset	= 0x07

let kHeightOffset			= 0x08
let kWeightOffset			= 0x0A

let kNationalIndexOffset	= 0x0E

let kType1Offset			= 0x30
let kType2Offset			= 0x31

let kAbility1Offset			= 0x32
let kAbility2Offset			= 0x33

let kFirstTMOffset			= 0x34
let kFirstTutorMoveOffset	= 0x6E
let kFirstEVYieldOffset		= 0x9A
let kFirstEvolutionOffset	= 0xA6
let kFirstLevelUpMoveOffset	= 0xC4
let kFirstEggMoveOffset		= 0x7E

// This table is pointed to by function 0x801d8e20 in RAM if you want to repoint to a larger
// table at some point
let kFirstPokemonPKXIdentifierOffset = 0x40A0A8 // in start.dol
let kModelDictionaryModelOffset = 0x4

/* Tutor moves order:
 *
 * Use the appropriate dol patcher function to set them to the correct order
 *
 *  1: body slam			tm8
 *  2: double edge			tm11
 *  3: seismic toss			tm3
 *  4: mimic				tm1
 *  5: dream eater			tm6
 *  6: thunderwave			tm2
 *  7: substitute			tm5
 *  8: icy wind				tm4
 *  9: swagger				tm7
 * 10: sky attack			tm10
 * 11: self destruct		tm12
 * 12: nightmare			tm9
 */

let kHeldItem1Offset		= 0x7A
let kHeldItem2Offset		= 0x7C

let kHPOffset				= 0x8F
let kAttackOffset			= 0x91
let kDefenseOffset			= 0x93
let kSpecialAttackOffset	= 0x95
let kSpecialDefenseOffset	= 0x97
let kSpeedOffset			= 0x99

let kNameIDOffset			= 0x18
let kPokemonCryIndexOffset	= 0x0C
let kSpeciesNameIDOffset	= 0x1C

let kPokemonModelIndexOffset = 0x2E // Same as pokemon's index
let kPokemonBodyOffset		 = 0x118
let kPokemonBodyShinyOffset	 = 0x120
let kPokemonFaceIndexOffset	 = 0x116

final class XGPokemonStats: NSObject, Codable {
	
	var index			= 0x0
	var startOffset		= 0x0
	
	var nameID			= 0x0
	var speciesNameID	= 0x0
	var cryIndex		= 0x0
	var modelIndex		= 0x0
	var faceIndex		= 0x0
	
	var bodyID: UInt32 		= 0x0
	var bodyShinyID: UInt32 = 0x0
	
	var bodyName: String? {
		let dance =  XGFiles.fsys("poke_dance").fsysData
		if let index = dance.indexForIdentifier(identifier: bodyID.int) {
			return dance.fileNameForFileWithIndex(index: index)
		}
		return nil
	}
	
	var levelUpRate	= XGExpRate.standard
	var genderRatio = XGGenderRatios.maleOnly
	
	var catchRate		= 0x0
	var baseExp		= 0x0
	var baseHappiness	= 0x0
	
	var type1			= XGMoveTypes.normal
	var type2			= XGMoveTypes.normal
	
	var ability1		= XGAbilities.index(0)
	var ability2		= XGAbilities.index(0)
	
	var heldItem1		= XGItems.index(0)
	var heldItem2		= XGItems.index(0)
	
	var hp				= 0x0
	var speed				= 0x0
	var attack			= 0x0
	var defense			= 0x0
	var specialAttack		= 0x0
	var specialDefense	= 0x0
	
	var levelUpMoves	= [XGLevelUpMove]()
	var learnableTMs	= [Bool]()
	var tutorMoves	= [Bool]()
	var evolutions	= [XGEvolution]()
	
	var nationalIndex	= 0
	
	var hpYield				= 0x0
	var speedYield			= 0x0
	var attackYield			= 0x0
	var defenseYield			= 0x0
	var specialAttackYield	= 0x0
	var specialDefenseYield	= 0x0

	var height = 0.0 // meters
	var weight = 0.0 // kg

	var baseStatTotal: Int {
		return hp + attack + defense + specialAttack + specialDefense + speed
	}
	
	var pkxModelIdentifier: UInt32 {
		let dol = XGFiles.dol.data!
		return dol.getWordAtOffset(kFirstPokemonPKXIdentifierOffset + (self.modelIndex * 8) + kModelDictionaryModelOffset)
	}
	
	var pkxFSYS: XGFsys? {
		return XGISO.current.getPKXModelWithIdentifier(id: self.pkxModelIdentifier)
	}
	
	var pkxData: XGMutableData? {
		let fsys = self.pkxFSYS
		
		if fsys != nil {
			return fsys!.decompressedDataForFileWithIndex(index: 0)
		}
		
		return nil
	}
	
	var name: XGString {
		return XGFiles.common_rel.stringTable.stringSafelyWithID(self.nameID)
	}
	
	var species: XGString {
		let file = XGFiles.typeAndFsysName(.msg, "pda_menu")
		return XGStringTable(file: file, startOffset: 0, fileSize: file.fileSize).stringSafelyWithID(self.speciesNameID)
	}
	
	var numberOfTMs: Int {
		return learnableTMs.filter{ $0 }.count
	}
	
	var numberOfTutorMoves: Int {
		return tutorMoves.filter{ $0 }.count
	}
	
	var numberOfLevelUpMoves: Int {
		return levelUpMoves.filter{ $0.isSet() }.count
	}
	
	var numberOfEvolutions: Int {
		return evolutions.filter{ $0.isSet() }.count
	}
	
	init(index: Int) {
		super.init()
		
		let rel = XGFiles.common_rel.data!
		
		startOffset	= CommonIndexes.PokemonStats.startOffset + ( kSizeOfPokemonStats * index )
		self.index			= index
		
		nameID			= rel.getWordAtOffset(startOffset + kNameIDOffset).int
		speciesNameID   = rel.getWordAtOffset(startOffset + kSpeciesNameIDOffset).int
		cryIndex		= rel.get2BytesAtOffset(startOffset + kPokemonCryIndexOffset)
		modelIndex		= rel.get2BytesAtOffset(startOffset + kPokemonModelIndexOffset)
		faceIndex		= game == .XD ? rel.get2BytesAtOffset(startOffset + kPokemonFaceIndexOffset) : rel.getWordAtOffset(CommonIndexes.PokefaceTextures.startOffset + (index * 8) + 4).int
		bodyID		    = rel.getWordAtOffset(startOffset + kPokemonBodyOffset)
		bodyShinyID		= rel.getWordAtOffset(startOffset + kPokemonBodyShinyOffset)

		height = Double(rel.get2BytesAtOffset(startOffset + kHeightOffset)) / 10
		weight = Double(rel.get2BytesAtOffset(startOffset + kWeightOffset)) / 10
		
		levelUpRate	= XGExpRate(rawValue: rel.getByteAtOffset(startOffset + kEXPRateOffset)) ?? .standard
		genderRatio	= XGGenderRatios(rawValue: rel.getByteAtOffset(startOffset + kGenderRatioOffset)) ?? .maleOnly
		
		catchRate		= rel.getByteAtOffset(startOffset + kCatchRateOffset)
		baseExp			= rel.getByteAtOffset(startOffset + kBaseEXPOffset)
		baseHappiness	= rel.getByteAtOffset(startOffset + kBaseHappinessOffset)
		
		type1			= XGMoveTypes.index(rel.getByteAtOffset(startOffset + kType1Offset))
		type2			= XGMoveTypes.index(rel.getByteAtOffset(startOffset + kType2Offset))
		
		let a1			= rel.getByteAtOffset(startOffset + kAbility1Offset)
		let a2			= rel.getByteAtOffset(startOffset + kAbility2Offset)
		ability1		= .index(a1)
		ability2		= .index(a2)
		
		let i1			= rel.get2BytesAtOffset(startOffset + kHeldItem1Offset)
		let i2			= rel.get2BytesAtOffset(startOffset + kHeldItem2Offset)
		heldItem1		= .index(i1)
		heldItem2		= .index(i2)
		
		hp				= rel.getByteAtOffset(startOffset + kHPOffset)
		attack			= rel.getByteAtOffset(startOffset + kAttackOffset)
		defense			= rel.getByteAtOffset(startOffset + kDefenseOffset)
		specialAttack	= rel.getByteAtOffset(startOffset + kSpecialAttackOffset)
		specialDefense	= rel.getByteAtOffset(startOffset + kSpecialDefenseOffset)
		speed			= rel.getByteAtOffset(startOffset + kSpeedOffset)
		
		hpYield				= rel.get2BytesAtOffset(startOffset + kFirstEVYieldOffset + 0x0)
		attackYield			= rel.get2BytesAtOffset(startOffset + kFirstEVYieldOffset + 0x2)
		defenseYield		= rel.get2BytesAtOffset(startOffset + kFirstEVYieldOffset + 0x4)
		specialAttackYield	= rel.get2BytesAtOffset(startOffset + kFirstEVYieldOffset + 0x6)
		specialDefenseYield	= rel.get2BytesAtOffset(startOffset + kFirstEVYieldOffset + 0x8)
		speedYield			= rel.get2BytesAtOffset(startOffset + kFirstEVYieldOffset + 0xa)
		
		self.nationalIndex	= rel.get2BytesAtOffset(startOffset + kNationalIndexOffset)
		
		for i in 0 ..< kNumberOfTMsAndHMs  {
			self.learnableTMs.append(rel.getByteAtOffset(startOffset + kFirstTMOffset + i) == 1)
		}
		
		for i in 0 ..< kNumberOfTutorMoves  {
			self.tutorMoves.append(rel.getByteAtOffset(startOffset + kFirstTutorMoveOffset + i) == 1)
		}
		
		for i in 0 ..< kNumberOfLevelUpMoves {
			
			let currentOffset = startOffset + kFirstLevelUpMoveOffset + (i * kSizeOfLevelUpData)
			
			let level = rel.getByteAtOffset(currentOffset + kLevelUpMoveLevelOffset)
			let move  = rel.get2BytesAtOffset(currentOffset + kLevelUpMoveIndexOffset)
			
			self.levelUpMoves.append(XGLevelUpMove(level: level, move: move))
		}
		
		for i in 0 ..< kNumberOfEvolutions {
			
			let currentOffset = startOffset + kFirstEvolutionOffset + (i * kSizeOfEvolutionData)
			
			let method	  = rel.getByteAtOffset(currentOffset + kEvolutionMethodOffset)
			let condition = rel.get2BytesAtOffset(currentOffset + kEvolutionConditionOffset)
			let evolution = rel.get2BytesAtOffset(currentOffset + kEvolvedFormOffset)
			
			evolutions.append(XGEvolution(evolutionMethod: method, condition: condition, evolvedForm: evolution))
		}
	}
	
	func save() {
		
		let rel	= XGFiles.common_rel.data!

		rel.replaceWordAtOffset(startOffset + kNameIDOffset, withBytes: UInt32(nameID))
		rel.replaceWordAtOffset(startOffset + kSpeciesNameIDOffset, withBytes: UInt32(speciesNameID))
		rel.replace2BytesAtOffset(startOffset + kPokemonCryIndexOffset, withBytes: cryIndex)
		rel.replace2BytesAtOffset(startOffset + kPokemonModelIndexOffset, withBytes: modelIndex)
		rel.replace2BytesAtOffset(startOffset + kPokemonFaceIndexOffset, withBytes: faceIndex)
		rel.replaceWordAtOffset(startOffset + kPokemonBodyOffset, withBytes: bodyID)
		rel.replaceWordAtOffset(startOffset + kPokemonBodyShinyOffset, withBytes: bodyShinyID)

		rel.replace2BytesAtOffset(startOffset + kHeightOffset, withBytes: Int(height * 10))
		rel.replace2BytesAtOffset(startOffset + kWeightOffset, withBytes: Int(weight * 10))
		
		rel.replaceByteAtOffset(startOffset + kEXPRateOffset, withByte: levelUpRate.rawValue)
		rel.replaceByteAtOffset(startOffset + kGenderRatioOffset, withByte: genderRatio.rawValue)
		
		rel.replaceByteAtOffset(startOffset + kCatchRateOffset, withByte: catchRate)
		rel.replaceByteAtOffset(startOffset + kBaseEXPOffset, withByte: baseExp)
		rel.replaceByteAtOffset(startOffset + kBaseHappinessOffset, withByte: baseHappiness)
		
		rel.replaceByteAtOffset(startOffset + kType1Offset, withByte: type1.rawValue)
		rel.replaceByteAtOffset(startOffset + kType2Offset, withByte: type2.rawValue)
		
		rel.replaceByteAtOffset(startOffset + kAbility1Offset, withByte: ability1.index)
		rel.replaceByteAtOffset(startOffset + kAbility2Offset, withByte: ability2.index)
		
		rel.replace2BytesAtOffset(startOffset + kHeldItem1Offset, withBytes: heldItem1.index)
		rel.replace2BytesAtOffset(startOffset + kHeldItem2Offset, withBytes: heldItem2.index)
		
		rel.replaceByteAtOffset(startOffset + kHPOffset, withByte: hp)
		rel.replaceByteAtOffset(startOffset + kAttackOffset, withByte: attack)
		rel.replaceByteAtOffset(startOffset + kDefenseOffset, withByte: defense)
		rel.replaceByteAtOffset(startOffset + kSpecialAttackOffset, withByte: specialAttack)
		rel.replaceByteAtOffset(startOffset + kSpecialDefenseOffset, withByte: specialDefense)
		rel.replaceByteAtOffset(startOffset + kSpeedOffset, withByte: speed)
		
		rel.replace2BytesAtOffset(startOffset + kFirstEVYieldOffset + 0x0, withBytes: hpYield)
		rel.replace2BytesAtOffset(startOffset + kFirstEVYieldOffset + 0x2, withBytes: attackYield)
		rel.replace2BytesAtOffset(startOffset + kFirstEVYieldOffset + 0x4, withBytes: defenseYield)
		rel.replace2BytesAtOffset(startOffset + kFirstEVYieldOffset + 0x6, withBytes: specialAttackYield)
		rel.replace2BytesAtOffset(startOffset + kFirstEVYieldOffset + 0x8, withBytes: specialDefenseYield)
		rel.replace2BytesAtOffset(startOffset + kFirstEVYieldOffset + 0xa, withBytes: speedYield)
		
		
		var currentOffset = startOffset + kFirstTMOffset
		
		for i in 0 ..< kNumberOfTMsAndHMs {
			rel.replaceByteAtOffset(currentOffset + i, withByte: learnableTMs[i] ? 1 : 0)
		}
		
		currentOffset = startOffset + kFirstTutorMoveOffset
		
		for i in 0 ..< kNumberOfTutorMoves {
			rel.replaceByteAtOffset(currentOffset + i, withByte: tutorMoves[i] ? 1 : 0)
		}
		
		for i in 0 ..< kNumberOfLevelUpMoves {
			
			let currentOffset = startOffset + kFirstLevelUpMoveOffset + (i * kSizeOfLevelUpData)
			let (lev, mov) = levelUpMoves[i].toInts()
			
			rel.replaceByteAtOffset(currentOffset + kLevelUpMoveLevelOffset, withByte: lev)
			rel.replace2BytesAtOffset(currentOffset + kLevelUpMoveIndexOffset, withBytes: mov)
		}
		
		for i in 0 ..< kNumberOfEvolutions {
			
			let currentOffset = startOffset + kFirstEvolutionOffset + (i * kSizeOfEvolutionData)
			let (method, condition, evolution) = evolutions[i].toInts()
			
			rel.replaceByteAtOffset(currentOffset + kEvolutionMethodOffset, withByte: method)
			rel.replace2BytesAtOffset(currentOffset + kEvolutionConditionOffset, withBytes: condition)
			rel.replace2BytesAtOffset(currentOffset + kEvolvedFormOffset, withBytes: evolution)
		}
		
		rel.save()
	}
	
}

extension XGPokemonStats: XGEnumerable {
	var enumerableName: String {
		return name.string
	}
	
	var enumerableValue: String? {
		return String(format: "%03d", index)
	}
	
	static var enumerableClassName: String {
		return "Pokemon"
	}
	
	static var allValues: [XGPokemonStats] {
		var values = [XGPokemonStats]()
		for i in 0 ..< CommonIndexes.NumberOfPokemon.value {
			values.append(XGPokemonStats(index: i))
		}
		return values
	}
}

extension XGPokemonStats: XGDocumentable {
	
	static var documentableClassName: String {
		return "Pokemon Stats"
	}
	
	var isDocumentable: Bool {
		return catchRate != 0
	}
	
	var documentableName: String {
		return enumerableName + " - " + (enumerableValue ?? "")
	}
	
	static var DocumentableKeys: [String] {
		return ["index", "hex index", "national index", "name", "type 1", "type 2", "ability 1", "ability 2", "base HP", "base attack", "base defense", "base special attack", "base special defense", "base speed", "species", "level up rate", "gender ratio", "catch rate", "exp yield", "base happiness", "wild item 1", "wild item 2", "HP yield", "attack yield", "defense yield", "special attack yield", "special defense yield", "speed yield", "height", "weight", "evolutions", "learnable tutor moves", "learnable TMs", "level up moves"]
	}
	
	func documentableValue(for key: String) -> String {
		switch key {
		case "index":
			return index.string
		case "hex index":
			return index.hexString()
		case "name":
			return name.string
		case "national index":
			return nationalIndex.string
		case "type 1":
			return type1.name
		case "type 2":
			return type2.name
		case "ability 1":
			return ability1.name.string
		case "ability 2":
			return ability2.name.string
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
		case "learnable tutor moves":
			var tutorString = ""
			for i in 0 ..< tutorMoves.count {
				tutorString += "\n" + XGTMs.tutor(i).move.name.string + ": " + tutorMoves[i].string
			}
			return tutorString
		case "learnable TMs":
			var tmString = ""
			for i in 0 ..< kNumberOfTMsAndHMs {
				tmString += "\n" + XGTMs.tm(i + 1).move.name.string + ": " + learnableTMs[i].string
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














