//
//  CMTrainerPokemon.swift
//  Colosseum Tool
//
//  Created by The Steez on 06/06/2018.
//

import Foundation

let kNumberOfTrainerPokemonEntries = 5510

let kSizeOfPokemonData		= 0x50
let kNumberOfPokemonMoves	= 0x04
let kNumberOfEVs			= 0x06
let kNumberOfIVs			= 0x06

let kPokemonAbilityOffset	= 0x00
let kPokemonGenderOffset	= 0x01
let kPokemonNatureOffset	= 0x02
let kPokemonShadowIDOffset	= 0x03
let kPokemonLevelOffset		= 0x04
let kPokemonPriorityOffset	= 0x05
let kPokemonHappinessOffset	= 0x09
let kPokemonSpeciesOffset	= 0x0A
let kPokemonPokeballOffset	= 0x0D
let kPokemonItemOffset		= 0x12
let kPokemonNameIDOffset	= 0x14
let kFirstPokemonIVOffset	= 0x1C
let kFirstPokemonEVOffset	= 0x23

let kPokemonMove1Offset		= 0x36
let kPokemonMove2Offset		= 0x3E
let kPokemonMove3Offset		= 0x46
let kPokemonMove4Offset		= 0x4E

let kFFOffsets				= [0,1,2,8,9,0x10,0x11,0x10,0x13,0x1C,0x1D,0x1E,0x1F,0x20,0x21,0x22,0x23,0x24,0x25,0x26,0x27,0x28,0x29,0x2A,0x2B,0x2C,0x2D]

let kSizeOfShadowData			= 0x38

let kShadowCatchRateOffset		= 0x00 // overrides species' catch rate
let kShadowSpeciesOffset		= 0x02
let kShadowTIDOffset			= 0x04 // trainer index of the first time the shadow pokemon is encountered
let kShadowTID2Offset			= 0x06 // trainer index of an alternate possibility for first encounter
let kShadowCounterOffset		= 0x08
let kShadowIDOffset				= 0x0B
let kShadowCaughtFlagOffset		= 0x12 // flag is set automatically when the shadow pokemon is caught
let kShadowJapaneseMSGOffset	= 0x22

class XGTrainerPokemon : NSObject, Codable {
	
	var shadowID	= 0
	var index		= 0
	
	var species		= XGPokemon.index(0) {
		didSet {
			self.nameID = self.species.nameID
		}
	}
	var nameID		= 0
	var level		= 0
	var happiness	= 0
	var pokeball	= XGItems.index(0)
	var item		= XGItems.index(0)
	var nature		= XGNatures.hardy
	var gender		= XGGenders.male
	var IVs			= 0x0 // All IVs will be the same. Not much point in varying them.
	var EVs			= [Int]()
	var moves		= [XGMoves](repeating: XGMoves.index(0), count: kNumberOfPokemonMoves)

	var ability		= 0x0 {
		didSet {
			if ![0,1].contains(ability) {
				ability = 0xFF // set to random in colosseum
			}
		}
	}
	
	// not in colosseum but user for compatibility with GoD tool
	var shinyness = XGShinyValues.never
	var priority  = 0
	
	var shadowCatchRate = 0x0
	var shadowCounter	= 0x0
	var shadowFirstTID  = 0x0
	var shadowAlternateFirstTID = 0x0
	
	var startOffset : Int {
		return CommonIndexes.TrainerPokemonData.startOffset + (index * kSizeOfPokemonData)
	}
	
	var shadowStartOffset: Int {
		return CommonIndexes.ShadowData.startOffset + (self.shadowID * kSizeOfShadowData)
	}
	
	var isShadowPokemon: Bool {
		return self.shadowID > 0
	}
	
	var isSet: Bool {
		return self.species.index > 0
	}
	
	init(index: Int) {
		super.init()
		
		self.index = index
		
		let data = XGFiles.common_rel.data!
		let start = self.startOffset
		
		let spec		= data.get2BytesAtOffset(start + kPokemonSpeciesOffset)
		species			= XGPokemon.index(spec)
		level			= data.getByteAtOffset(start + kPokemonLevelOffset)
		nameID			= data.getWordAtOffset(start + kPokemonNameIDOffset).int
		
		shadowID		= data.getByteAtOffset(start + kPokemonShadowIDOffset)
		
		happiness		= data.getByteAtOffset(start + kPokemonHappinessOffset)
		let it			= data.get2BytesAtOffset(start + kPokemonItemOffset)
		item			= XGItems.index(it)
		IVs				= data.getByteAtOffset(start + kFirstPokemonIVOffset)
		
		ability		= data.getByteAtOffset(start + kPokemonAbilityOffset)
		
		let gender	= data.getByteAtOffset(start + kPokemonGenderOffset)
		self.gender = XGGenders(rawValue: gender) ?? .female
		
		let nature	= data.getByteAtOffset(start + kPokemonNatureOffset)
		self.nature	= XGNatures(rawValue: nature) ?? .hardy
		
		let ball = data.getByteAtOffset(start + kPokemonPokeballOffset)
		self.pokeball = XGItems.index(ball)
		
		for i in 0 ..< kNumberOfEVs {
			self.EVs.append(data.getByteAtOffset(start + kFirstPokemonEVOffset + (2 * i)))
		}
		
		moves[0] = XGMoves.index(data.get2BytesAtOffset(start + kPokemonMove1Offset))
		moves[1] = XGMoves.index(data.get2BytesAtOffset(start + kPokemonMove2Offset))
		moves[2] = XGMoves.index(data.get2BytesAtOffset(start + kPokemonMove3Offset))
		moves[3] = XGMoves.index(data.get2BytesAtOffset(start + kPokemonMove4Offset))
		
		if isShadowPokemon {
			let start = shadowStartOffset
			shadowCatchRate 	= data.getByteAtOffset(start + kShadowCatchRateOffset)
			shadowCounter		= data.get2BytesAtOffset(start + kShadowCounterOffset)
			shadowFirstTID		= data.get2BytesAtOffset(start + kShadowTIDOffset)
			shadowAlternateFirstTID = data.get2BytesAtOffset(start + kShadowTID2Offset)
		}
		
	}
	
	
	func save(writeRelOnCompletion: Bool = true) {
		
		if shadowID > 0, shadowID < CommonIndexes.NumberOfShadowPokemon.value {
			
			let data = XGFiles.common_rel.data!
			let start = shadowStartOffset
			
			data.replaceByteAtOffset(start + kShadowCatchRateOffset, withByte: shadowCatchRate)
			data.replace2BytesAtOffset(start + kShadowCounterOffset, withBytes: shadowCounter)
			data.replace2BytesAtOffset(start + kShadowTIDOffset, withBytes: shadowFirstTID)
			data.replace2BytesAtOffset(start + kShadowTID2Offset, withBytes: shadowAlternateFirstTID)
			data.replace2BytesAtOffset(start + kShadowSpeciesOffset, withBytes: self.species.index)

			if writeRelOnCompletion {
				data.save()
			}
			
		}
		
		let data = XGFiles.common_rel.data!
		let start = startOffset
		
		if self.species.index > 0 {
			data.replaceByteAtOffset(start + kPokemonPokeballOffset, withByte: self.pokeball.index)
			for offset in kFFOffsets {
				data.replaceByteAtOffset(start + offset, withByte: 0x00)
			}
		}
		data.replaceByteAtOffset(start + kPokemonShadowIDOffset, withByte: shadowID)
		data.replace2BytesAtOffset(start + kPokemonSpeciesOffset, withBytes: species.index)
		data.replaceWordAtOffset(start + kPokemonNameIDOffset, withBytes: UInt32(species.nameID))
		data.replace2BytesAtOffset(start + kPokemonItemOffset, withBytes: item.index)
		data.replaceByteAtOffset(start + kPokemonHappinessOffset - 1, withByte: 0)
		data.replaceByteAtOffset(start + kPokemonHappinessOffset, withByte: happiness)
		data.replaceByteAtOffset(start + kPokemonLevelOffset, withByte: level)
		
		data.replaceByteAtOffset(start + kPokemonAbilityOffset, withByte: ability)
		data.replaceByteAtOffset(start + kPokemonNatureOffset, withByte: nature.rawValue & 0xFF)
		data.replaceByteAtOffset(start + kPokemonGenderOffset, withByte: gender.rawValue & 0xFF)
		
		let IVs = [Int](repeating: self.IVs, count: kNumberOfIVs)
		data.replaceBytesFromOffset(start + kFirstPokemonIVOffset, withByteStream: IVs)
		
		for i in 0 ..< kNumberOfEVs {
			data.replaceByteAtOffset(start + kFirstPokemonEVOffset + (2 * i), withByte: EVs[i])
		}
		
		data.replace2BytesAtOffset(start + kPokemonMove1Offset, withBytes: moves[0].index)
		data.replace2BytesAtOffset(start + kPokemonMove2Offset, withBytes: moves[1].index)
		data.replace2BytesAtOffset(start + kPokemonMove3Offset, withBytes: moves[2].index)
		data.replace2BytesAtOffset(start + kPokemonMove4Offset, withBytes: moves[3].index)
		
		if self.species.index == 0 {
			data.replaceByteAtOffset(start + kPokemonPokeballOffset, withByte: 0x0)
			for offset in kFFOffsets {
				data.replaceByteAtOffset(start + offset, withByte: 0xFF)
			}
			self.purge()
		}
		
		if writeRelOnCompletion {
			data.save()
		}
	}
	
	func purge() {
		
		shadowID 	= 0
		species		= .index(0)
		nameID		= 0
		pokeball	= .index(0)
		level		= 1
		happiness	= 0
		ability		= 0
		item		= .index(0)
		nature		= .random
		gender		= .random
		IVs			= 0
		EVs			= [Int](repeating: 0, count: 6)
		moves		= [XGMoves](repeating: .index(0), count: kNumberOfPokemonMoves)
	}
	
}

final class CMShadowData {

	var index = 0

	var catchRate = 0
	var purificationCounter = 0
	var firstTID = 0
	var alternateTID = 0
	var shadowID = 0
	var nameID = 0 // Japanese text of the pokemon's name
	var captureFlag = 0

	var species = XGPokemon.index(0)
	var name: XGString {
		return getStringSafelyWithID(id: nameID)
	}

	var startOffset: Int {
		return CommonIndexes.ShadowData.startOffset + (self.index * kSizeOfShadowData)
	}

	init(index: Int) {
		self.index = index

		if let data = XGFiles.common_rel.data {
			let start = self.startOffset

			catchRate 	= data.getByteAtOffset(start + kShadowCatchRateOffset)
			purificationCounter		= data.get2BytesAtOffset(start + kShadowCounterOffset)
			firstTID		= data.get2BytesAtOffset(start + kShadowTIDOffset)
			alternateTID = data.get2BytesAtOffset(start + kShadowTID2Offset)
			shadowID = data.getByteAtOffset(start + kShadowIDOffset)
			nameID = data.get2BytesAtOffset(start + kShadowJapaneseMSGOffset)
			captureFlag = data.get2BytesAtOffset(start + kShadowCaughtFlagOffset)
			let speciesID = data.get2BytesAtOffset(start + kShadowSpeciesOffset)
			species = .index(speciesID)
		}
	}

	func save() {
		if let data = XGFiles.common_rel.data {
			let start = startOffset

			data.replaceByteAtOffset(start + kShadowCatchRateOffset, withByte: catchRate)
			data.replace2BytesAtOffset(start + kShadowCounterOffset, withBytes: purificationCounter)
			data.replace2BytesAtOffset(start + kShadowTIDOffset, withBytes: firstTID)
			data.replace2BytesAtOffset(start + kShadowTID2Offset, withBytes: alternateTID)
			data.replaceByteAtOffset(start + kShadowIDOffset, withByte: shadowID)
			data.replace2BytesAtOffset(start + kShadowJapaneseMSGOffset, withBytes: nameID)
			data.replace2BytesAtOffset(start + kShadowSpeciesOffset, withBytes: species.index)
			data.replace2BytesAtOffset(start + kShadowCaughtFlagOffset, withBytes: captureFlag)

			data.save()
		}
	}
}

extension CMShadowData: XGEnumerable {
	var enumerableName: String {
		return species.name.unformattedString
	}

	var enumerableValue: String? {
		return index.string
	}

	static var className: String {
		return "Shadow Data"
	}

	static var allValues: [CMShadowData] {
		return (0 ..< CommonIndexes.NumberOfShadowPokemon.value).map {
			CMShadowData(index: $0)
		}
	}
}

