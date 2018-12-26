//
//  Pokemon.swift
//  Mausoleum Stats Tool
//
//  Created by StarsMmd on 26/12/2014.
//  Copyright (c) 2014 StarsMmd. All rights reserved.
// 

import Foundation

let kNumberOfPokemon		= 501
let kSizeOfPokemonStats		= 0
//let kFirstPokemonOffset		= 0x29DA8

let kEXPRateOffset			= 0x00
let kCatchRateOffset		= 0x00
let kGenderRatioOffset		= 0x00
let kBaseEXPOffset			= 0x00
let kBaseHappinessOffset	= 0x00

let kType1Offset			= 0x00
let kType2Offset			= 0x00

let kAbility1Offset			= 0x00
let kAbility2Offset			= 0x00

let kWeightOffset 			= 0x00
let kHeightOffset			= 0x00

let kHPOffset				= 0x00
let kAttackOffset			= 0x00
let kDefenseOffset			= 0x00
let kSpecialAttackOffset	= 0x00
let kSpecialDefenseOffset	= 0x00
let kSpeedOffset			= 0x00

let kNameIDOffset			= 0x00
let kPokemonCryIndexOffset	= 0x00
let kSpeciesNameIDOffset	= 0x00

let kPokemonModelIndexOffset = 0x00

class XGPokemonStats: NSObject {
	
	@objc var index			= 0x0
	@objc var startOffset		= 0x0
	
	@objc var nameID			= 0x0
	@objc var speciesNameID		= 0x0
	@objc var cryIndex			= 0x0
	@objc var modelIndex		= 0x0
	
	var type1			= XGMoveTypes.normal
	var type2			= XGMoveTypes.normal
	
	var ability1		= XGAbilities.ability(0)
	var ability2		= XGAbilities.ability(0)
	
	@objc var hp				= 0x0
	@objc var speed				= 0x0
	@objc var attack			= 0x0
	@objc var defense			= 0x0
	@objc var specialAttack		= 0x0
	@objc var specialDefense	= 0x0
	
	@objc var name : XGString {
		get {
			return XGString(string: "", file: nil, sid: nil)
		}
	}
	
	@objc var species : XGString {
		get {
			return XGString(string: "", file: nil, sid: nil)
		}
	}
	
	
	init(index : Int!) {
		super.init()
		
		let rel = XGMutableData()
		
		self.startOffset	= ( kSizeOfPokemonStats * index )
		self.index			= index
		
		self.nameID			= rel.getWordAtOffset(startOffset + kNameIDOffset).int
		self.speciesNameID  = rel.getWordAtOffset(startOffset + kSpeciesNameIDOffset).int
		self.cryIndex		= rel.get2BytesAtOffset(startOffset + kPokemonCryIndexOffset)
		self.modelIndex		= rel.get2BytesAtOffset(startOffset + kPokemonModelIndexOffset)
		self.type1			= XGMoveTypes(rawValue: rel.getByteAtOffset(startOffset + kType1Offset)) ?? .normal
		self.type2			= XGMoveTypes(rawValue: rel.getByteAtOffset(startOffset + kType2Offset)) ?? .normal
		
		let a1				= rel.getByteAtOffset(startOffset + kAbility1Offset)
		let a2				= rel.getByteAtOffset(startOffset + kAbility2Offset)
		self.ability1		= .ability(a1)
		self.ability2		= .ability(a2)
		self.hp				= rel.getByteAtOffset(startOffset + kHPOffset)
		self.attack			= rel.getByteAtOffset(startOffset + kAttackOffset)
		self.defense		= rel.getByteAtOffset(startOffset + kDefenseOffset)
		self.specialAttack	= rel.getByteAtOffset(startOffset + kSpecialAttackOffset)
		self.specialDefense	= rel.getByteAtOffset(startOffset + kSpecialDefenseOffset)
		self.speed			= rel.getByteAtOffset(startOffset + kSpeedOffset)
		
	}
	
	@objc func save() {
		
		let rel	= XGMutableData()

		rel.replaceWordAtOffset(startOffset + kNameIDOffset, withBytes: UInt32(nameID))
		rel.replaceWordAtOffset(startOffset + kSpeciesNameIDOffset, withBytes: UInt32(speciesNameID))
		rel.replace2BytesAtOffset(startOffset + kPokemonCryIndexOffset, withBytes: cryIndex)
		rel.replace2BytesAtOffset(startOffset + kPokemonModelIndexOffset, withBytes: modelIndex)
		rel.replaceByteAtOffset(startOffset + kType1Offset, withByte: type1.rawValue)
		rel.replaceByteAtOffset(startOffset + kType2Offset, withByte: type2.rawValue)
		
		rel.replaceByteAtOffset(startOffset + kAbility1Offset, withByte: ability1.index)
		rel.replaceByteAtOffset(startOffset + kAbility2Offset, withByte: ability2.index)
		
		
		rel.replaceByteAtOffset(startOffset + kHPOffset, withByte: hp)
		rel.replaceByteAtOffset(startOffset + kAttackOffset, withByte: attack)
		rel.replaceByteAtOffset(startOffset + kDefenseOffset, withByte: defense)
		rel.replaceByteAtOffset(startOffset + kSpecialAttackOffset, withByte: specialAttack)
		rel.replaceByteAtOffset(startOffset + kSpecialDefenseOffset, withByte: specialDefense)
		rel.replaceByteAtOffset(startOffset + kSpeedOffset, withByte: speed)
		
		
		rel.save()
		
	}
	
	
	@objc var dictionaryRepresentation : [String : AnyObject] {
		get {
			var dictRep = [String : AnyObject]()
			dictRep["name"] = self.name.string as AnyObject?
			dictRep["species"] = self.species.string as AnyObject?
			dictRep["cry"] = self.cryIndex as AnyObject?
			dictRep["model"] = self.modelIndex as AnyObject?
			dictRep["type1"] = self.type1.dictionaryRepresentation as AnyObject?
			dictRep["type2"] = self.type2.dictionaryRepresentation as AnyObject?
			dictRep["ability1"] = self.ability1.dictionaryRepresentation as AnyObject?
			dictRep["ability2"] = self.ability2.dictionaryRepresentation as AnyObject?
			dictRep["hp"] = self.hp as AnyObject?
			dictRep["attack"] = self.attack as AnyObject?
			dictRep["defense"] = self.defense as AnyObject?
			dictRep["sp.attack"] = self.specialAttack as AnyObject?
			dictRep["sp.defense"] = self.specialDefense as AnyObject?
			dictRep["speed"] = self.speed as AnyObject?
			return dictRep
		}
	}
	
	@objc var readableDictionaryRepresentation : [String : AnyObject] {
		get {
			var dictRep = [String : AnyObject]()
			
			dictRep["species"] = self.species.string as AnyObject?
			dictRep["cry"] = self.cryIndex as AnyObject?
			dictRep["model"] = self.modelIndex as AnyObject?
			
			var types = [String : AnyObject]()
			types["type1"] = self.type1.readableDictionaryRepresentation as AnyObject?
			types["type2"] = self.type2.readableDictionaryRepresentation as AnyObject?
			dictRep["Types"] = types as AnyObject?
			
			var abilities = [String : AnyObject]()
			abilities["ability1"] = self.ability1.readableDictionaryRepresentation as AnyObject?
			abilities["ability2"] = self.ability2.readableDictionaryRepresentation as AnyObject?
			dictRep["Abilities"] = abilities as AnyObject?
			
			var stats = [String : AnyObject]()
			stats["hp"] = self.hp as AnyObject?
			stats["attack"] = self.attack as AnyObject?
			stats["defense"] = self.defense as AnyObject?
			stats["sp.attack"] = self.specialAttack as AnyObject?
			stats["sp.defense"] = self.specialDefense as AnyObject?
			stats["speed"] = self.speed as AnyObject?
			dictRep["BaseStats"] = stats as AnyObject?
			
			
			return ["\(self.index) " + self.name.string : dictRep as AnyObject]
		}
	}
	
	
}


















