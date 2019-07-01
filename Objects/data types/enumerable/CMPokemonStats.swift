//
//  CMPokemonStats.swift
//  Colosseum Tool
//
//  Created by The Steez on 06/06/2018.
//

import Foundation

let kNumberOfPokemon		= 0x19D
let kSizeOfPokemonStats		= 0x11C
//let kFirstPokemonOffset		= 0x29DA8

let kEXPRateOffset			= 0x00
let kCatchRateOffset		= 0x01
let kGenderRatioOffset		= 0x02
let kBaseEXPOffset			= 0x07
let kBaseHappinessOffset	= 0x09
let kNationalIndexOffset	= 0x0E

let kType1Offset			= 0x30
let kType2Offset			= 0x31

let kAbility1Offset			= 0x32
let kAbility2Offset			= 0x33

let kFirstTMOffset			= 0x34
let kFirstEVYieldOffset		= 0x90 // 1 byte between each one.
let kFirstEvolutionOffset	= 0x9C
let kFirstLevelUpMoveOffset	= 0xBA

let kHeldItem1Offset		= 0x70
let kHeldItem2Offset		= 0x72

let kHPOffset				= 0x85
let kAttackOffset			= 0x87
let kDefenseOffset			= 0x89
let kSpecialAttackOffset	= 0x8B
let kSpecialDefenseOffset	= 0x8D
let kSpeedOffset			= 0x8F

let kNameIDOffset			= 0x18
let kPokemonCryIndexOffset	= 0x0E
let kSpeciesNameIDOffset	= 0x1C

let kPokemonModelIndexOffset = 0x2E // Same as pokemon's index
let kPokemonFaceIndexOffset	 = 0x10E // Same as Pokemon's national dex index

let kModelDictionaryModelOffset = 0x4

class XGPokemonStats: NSObject, Codable {
	
	var index			= 0x0
	var startOffset		= 0x0
	
	var nameID			= 0x0
	var speciesNameID	= 0x0
	var cryIndex		= 0x0
	var modelIndex		= 0x0
	var faceIndex		= 0x0
	
	var levelUpRate		= XGExpRate.standard
	var genderRatio     = XGGenderRatios.maleOnly
	
	var catchRate		= 0x0
	var baseExp			= 0x0
	var baseHappiness	= 0x0
	
	var type1			= XGMoveTypes.normal
	var type2			= XGMoveTypes.normal
	
	var ability1		= XGAbilities.ability(0)
	var ability2		= XGAbilities.ability(0)
	
	var heldItem1		= XGItems.item(0)
	var heldItem2		= XGItems.item(0)
	
	var hp				= 0x0
	var speed			= 0x0
	var attack			= 0x0
	var defense			= 0x0
	var specialAttack	= 0x0
	var specialDefense	= 0x0
	
	var levelUpMoves	= [XGLevelUpMove]()
	var learnableTMs	= [Bool]()
	var tutorMoves		= [Bool]()
	var evolutions		= [XGEvolution]()
	
	var nationalIndex	= 0
	
	var hpYield				= 0x0
	var speedYield			= 0x0
	var attackYield			= 0x0
	var defenseYield		= 0x0
	var specialAttackYield	= 0x0
	var specialDefenseYield	= 0x0

	
	var name : XGString {
		get {
			return XGFiles.common_rel.stringTable.stringSafelyWithID(self.nameID)
		}
	}
	
	var species : XGString {
		get {
			let file = XGFiles.msg("pda_menu")
			return XGStringTable(file: file, startOffset: 0, fileSize: file.fileSize).stringSafelyWithID(self.speciesNameID)
		}
	}
	
	var numberOfTMs : Int {
		get {
			return learnableTMs.filter{ $0 }.count
		}
	}
	
	var numberOfTutorMoves : Int {
		get {
			return tutorMoves.filter{ $0 }.count
		}
	}
	
	var numberOfLevelUpMoves : Int {
		get {
			return levelUpMoves.filter{ $0.isSet() }.count
		}
	}
	
	var numberOfEvolutions : Int {
		get {
			return evolutions.filter{ $0.isSet() }.count
		}
	}
	
	var face : Int {
		return XGFiles.common_rel.data!.getWordAtOffset(CommonIndexes.PokefaceTextures.startOffset + (faceIndex * 8) + 4).int
	}
	
	
	
	init(index : Int!) {
		super.init()
		
		let rel = XGFiles.common_rel.data!
		
		self.startOffset	= CommonIndexes.PokemonStats.startOffset + ( kSizeOfPokemonStats * index )
		self.index			= index
		
		self.nameID			= rel.getWordAtOffset(startOffset + kNameIDOffset).int
		self.speciesNameID  = rel.getWordAtOffset(startOffset + kSpeciesNameIDOffset).int
		self.cryIndex		= rel.get2BytesAtOffset(startOffset + kPokemonCryIndexOffset)
		self.modelIndex		= rel.get2BytesAtOffset(startOffset + kPokemonModelIndexOffset)
		self.faceIndex		= rel.get2BytesAtOffset(startOffset + kPokemonFaceIndexOffset)
		
		self.levelUpRate	= XGExpRate(rawValue: rel.getByteAtOffset(startOffset + kEXPRateOffset)) ?? .standard
		self.genderRatio	= XGGenderRatios(rawValue: rel.getByteAtOffset(startOffset + kGenderRatioOffset)) ?? .maleOnly
		
		self.catchRate		= rel.getByteAtOffset(startOffset + kCatchRateOffset)
		self.baseExp		= rel.getByteAtOffset(startOffset + kBaseEXPOffset)
		self.baseHappiness	= rel.getByteAtOffset(startOffset + kBaseHappinessOffset)
		
		self.type1			= XGMoveTypes(rawValue: rel.getByteAtOffset(startOffset + kType1Offset)) ?? .normal
		self.type2			= XGMoveTypes(rawValue: rel.getByteAtOffset(startOffset + kType2Offset)) ?? .normal
		
		let a1				= rel.getByteAtOffset(startOffset + kAbility1Offset)
		let a2				= rel.getByteAtOffset(startOffset + kAbility2Offset)
		self.ability1		= .ability(a1)
		self.ability2		= .ability(a2)
		
		let i1				= rel.get2BytesAtOffset(startOffset + kHeldItem1Offset)
		let i2				= rel.get2BytesAtOffset(startOffset + kHeldItem2Offset)
		self.heldItem1		= .item(i1)
		self.heldItem2		= .item(i2)
		
		self.hp				= rel.getByteAtOffset(startOffset + kHPOffset)
		self.attack			= rel.getByteAtOffset(startOffset + kAttackOffset)
		self.defense		= rel.getByteAtOffset(startOffset + kDefenseOffset)
		self.specialAttack	= rel.getByteAtOffset(startOffset + kSpecialAttackOffset)
		self.specialDefense	= rel.getByteAtOffset(startOffset + kSpecialDefenseOffset)
		self.speed			= rel.getByteAtOffset(startOffset + kSpeedOffset)
		
		self.hpYield				= rel.get2BytesAtOffset(startOffset + kFirstEVYieldOffset + 0x0)
		self.attackYield			= rel.get2BytesAtOffset(startOffset + kFirstEVYieldOffset + 0x2)
		self.defenseYield			= rel.get2BytesAtOffset(startOffset + kFirstEVYieldOffset + 0x4)
		self.specialAttackYield		= rel.get2BytesAtOffset(startOffset + kFirstEVYieldOffset + 0x6)
		self.specialDefenseYield	= rel.get2BytesAtOffset(startOffset + kFirstEVYieldOffset + 0x8)
		self.speedYield				= rel.get2BytesAtOffset(startOffset + kFirstEVYieldOffset + 0xa)
		
		self.nationalIndex	= rel.get2BytesAtOffset(startOffset + kNationalIndexOffset)
		
		for i in 0 ..< kNumberOfTMsAndHMs  {
			self.learnableTMs.append(rel.getByteAtOffset(startOffset + kFirstTMOffset + i) == 1)
		}
		
		
		for i in 0 ..< kNumberOfLevelUpMoves {
			
			let currentOffset = startOffset + kFirstLevelUpMoveOffset + (i * kSizeOfLevelUpData)
			
			let level = rel.getByteAtOffset(currentOffset + kLevelUpMoveLevelOffset)
			let move  = rel.get2BytesAtOffset(currentOffset + kLevelUpMoveIndexOffset)
			
			self.levelUpMoves.append(XGLevelUpMove(level: level, move: move))
		}
		
		for i in 0 ..< kNumberOfEvolutions {
			
			let currentOffset = startOffset + kFirstEvolutionOffset + (i * kSizeOfEvolutionData)
			
			let method		= rel.getByteAtOffset(currentOffset + kEvolutionMethodOffset)
			let condition	= rel.get2BytesAtOffset(currentOffset + kEvolutionConditionOffset)
			let evolution	= rel.get2BytesAtOffset(currentOffset + kEvolvedFormOffset)
			
			self.evolutions.append(XGEvolution(evolutionMethod: method, condition: condition, evolvedForm: evolution))
		}
		
	}
	
	func save() {
		
		let rel	= XGFiles.common_rel.data!
		
		rel.replaceWordAtOffset(startOffset + kNameIDOffset, withBytes: UInt32(nameID))
		rel.replaceWordAtOffset(startOffset + kSpeciesNameIDOffset, withBytes: UInt32(speciesNameID))
		rel.replace2BytesAtOffset(startOffset + kPokemonCryIndexOffset, withBytes: cryIndex)
		rel.replace2BytesAtOffset(startOffset + kPokemonModelIndexOffset, withBytes: modelIndex)
		rel.replace2BytesAtOffset(startOffset + kPokemonFaceIndexOffset, withBytes: faceIndex)
		
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
		
		rel.replace2BytesAtOffset(startOffset + kFirstEVYieldOffset + 0x0, withBytes: self.hpYield)
		rel.replace2BytesAtOffset(startOffset + kFirstEVYieldOffset + 0x2, withBytes: self.attackYield)
		rel.replace2BytesAtOffset(startOffset + kFirstEVYieldOffset + 0x4, withBytes: self.defenseYield)
		rel.replace2BytesAtOffset(startOffset + kFirstEVYieldOffset + 0x6, withBytes: self.specialAttackYield)
		rel.replace2BytesAtOffset(startOffset + kFirstEVYieldOffset + 0x8, withBytes: self.specialDefenseYield)
		rel.replace2BytesAtOffset(startOffset + kFirstEVYieldOffset + 0xa, withBytes: self.speedYield)
		
		
		var currentOffset = startOffset + kFirstTMOffset
		
		for i in 0 ..< kNumberOfTMsAndHMs {
			
			rel.replaceByteAtOffset(currentOffset + i, withByte: learnableTMs[i] ? 1 : 0)
			
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
	
	
	var dictionaryRepresentation : [String : AnyObject] {
		get {
			var dictRep = [String : AnyObject]()
			dictRep["name"] = self.name.string as AnyObject?
			dictRep["species"] = self.species.string as AnyObject?
			dictRep["cry"] = self.cryIndex as AnyObject?
			dictRep["model"] = self.modelIndex as AnyObject?
			dictRep["face"] = self.faceIndex as AnyObject?
			dictRep["levelUpRate"] = self.levelUpRate.dictionaryRepresentation as AnyObject?
			dictRep["genderRatio"] = self.genderRatio.dictionaryRepresentation as AnyObject?
			dictRep["catchRate"] = self.catchRate as AnyObject?
			dictRep["baseExp"] = self.baseExp as AnyObject?
			dictRep["baseHappiness"] = self.baseHappiness as AnyObject?
			dictRep["type1"] = self.type1.dictionaryRepresentation as AnyObject?
			dictRep["type2"] = self.type2.dictionaryRepresentation as AnyObject?
			dictRep["ability1"] = self.ability1.dictionaryRepresentation as AnyObject?
			dictRep["ability2"] = self.ability2.dictionaryRepresentation as AnyObject?
			dictRep["heldItem1"] = self.heldItem1.dictionaryRepresentation as AnyObject?
			dictRep["heldItem2"] = self.heldItem2.dictionaryRepresentation as AnyObject?
			dictRep["hp"] = self.hp as AnyObject?
			dictRep["attack"] = self.attack as AnyObject?
			dictRep["defense"] = self.defense as AnyObject?
			dictRep["sp.attack"] = self.specialAttack as AnyObject?
			dictRep["sp.defense"] = self.specialDefense as AnyObject?
			dictRep["speed"] = self.speed as AnyObject?
			dictRep["hpEV"] = self.hpYield as AnyObject?
			dictRep["attackEV"] = self.attackYield as AnyObject?
			dictRep["defenseEV"] = self.defenseYield as AnyObject?
			dictRep["sp.attackEV"] = self.specialAttackYield as AnyObject?
			dictRep["sp.defenseEV"] = self.specialDefenseYield as AnyObject?
			dictRep["speedEV"] = self.speedYield as AnyObject?
			
			var levelUpMovesArray = [AnyObject]()
			for a in levelUpMoves {
				levelUpMovesArray.append(a.dictionaryRepresentation as AnyObject)
			}
			dictRep["levelUpMoves"] = levelUpMovesArray as AnyObject?
			
			var evolutionsArray = [AnyObject]()
			for a in evolutions {
				evolutionsArray.append(a.dictionaryRepresentation as AnyObject)
			}
			dictRep["evolutions"] = evolutionsArray as AnyObject?
			
			dictRep["learnableTMs"] = self.learnableTMs as AnyObject?
			dictRep["learnableTutorMoves"] = self.tutorMoves as AnyObject?
			
			return dictRep
		}
	}
	
	var readableDictionaryRepresentation : [String : AnyObject] {
		get {
			var dictRep = [String : AnyObject]()
			
			dictRep["species"] = self.species.string as AnyObject?
			dictRep["cry"] = self.cryIndex as AnyObject?
			dictRep["model"] = self.modelIndex as AnyObject?
			dictRep["face"] = self.faceIndex as AnyObject?
			dictRep["levelUpRate"] = self.levelUpRate.readableDictionaryRepresentation as AnyObject?
			dictRep["genderRatio"] = self.genderRatio.readableDictionaryRepresentation as AnyObject?
			dictRep["catchRate"] = self.catchRate as AnyObject?
			dictRep["baseExp"] = self.baseExp as AnyObject?
			dictRep["baseHappiness"] = self.baseHappiness as AnyObject?
			
			var types = [String : AnyObject]()
			types["type1"] = self.type1.readableDictionaryRepresentation as AnyObject?
			types["type2"] = self.type2.readableDictionaryRepresentation as AnyObject?
			dictRep["Types"] = types as AnyObject?
			
			var abilities = [String : AnyObject]()
			abilities["ability1"] = self.ability1.readableDictionaryRepresentation as AnyObject?
			abilities["ability2"] = self.ability2.readableDictionaryRepresentation as AnyObject?
			dictRep["Abilities"] = abilities as AnyObject?
			
			var items = [String : AnyObject]()
			items["heldItem1"] = self.heldItem1.readableDictionaryRepresentation as AnyObject?
			items["heldItem2"] = self.heldItem2.readableDictionaryRepresentation as AnyObject?
			dictRep["WildHoldItems"] = items as AnyObject?
			
			var stats = [String : AnyObject]()
			stats["hp"] = self.hp as AnyObject?
			stats["attack"] = self.attack as AnyObject?
			stats["defense"] = self.defense as AnyObject?
			stats["sp.attack"] = self.specialAttack as AnyObject?
			stats["sp.defense"] = self.specialDefense as AnyObject?
			stats["speed"] = self.speed as AnyObject?
			dictRep["BaseStats"] = stats as AnyObject?
			
			var EVYields = [String : AnyObject]()
			EVYields["hp"] = self.hpYield as AnyObject?
			EVYields["attack"] = self.attackYield as AnyObject?
			EVYields["defense"] = self.defenseYield as AnyObject?
			EVYields["sp.attack"] = self.specialAttackYield as AnyObject?
			EVYields["sp.defense"] = self.specialDefenseYield as AnyObject?
			EVYields["speed"] = self.speedYield as AnyObject?
			dictRep["EVYields"] = EVYields as AnyObject?
			
			
			
			var levelUpMovesArray = [AnyObject]()
			for a in levelUpMoves {
				levelUpMovesArray.append(a.readableDictionaryRepresentation as AnyObject)
			}
			dictRep["levelUpMoves"] = levelUpMovesArray as AnyObject?
			
			var evolutionsArray = [AnyObject]()
			for a in evolutions {
				evolutionsArray.append(a.readableDictionaryRepresentation as AnyObject)
			}
			dictRep["evolutions"] = evolutionsArray as AnyObject?
			
			var learnableTMsArray = [String]()
			for i in 1...50 {
				if self.learnableTMs[i - 1] {
					learnableTMsArray.append(XGTMs.tm(i).move.name.string)
				}
			}
			dictRep["learnableTMs"] = learnableTMsArray as AnyObject?
			
			
			return ["\(self.index) " + self.name.string : dictRep as AnyObject]
		}
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
