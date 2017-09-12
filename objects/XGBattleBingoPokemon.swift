//
//  XGBattleBingoPokemon.swift
//  XG Tool
//
//  Created by StarsMmd on 11/06/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

let kSizeOfBattleBingoPokemonData		= 0x0A

let kBattleBingoPokemonPanelTypeOffset	= 0x00
let kBattleBingoPokemonAbilityOffset	= 0x01
let kBattleBingoPokemonNatureOffset		= 0x02
let kBattleBingoPokemonGenderOffset		= 0x03
let kBattleBingoPokemonSpeciesOffset	= 0x04
let kBattleBingoPokemonMoveOffset		= 0x06

class XGBattleBingoPokemon: NSObject, XGDictionaryRepresentable {
	
	var typeOnCard	= 0x0
	var species		= XGPokemon.pokemon(0)
	var ability		= 0x0
	var nature		= XGNatures.hardy
	var gender		= XGGenders.male
	var move		= XGMoves.move(0)
	
	var startOffset : Int = 0
	
	override var description : String {
		get {
			return self.species.name.string + " (" + self.move.name.string + ")"
		}
	}
	
	init(startOffset: Int) {
		super.init()
		
		self.startOffset = startOffset
		let rel = XGFiles.common_rel.data
		
		self.typeOnCard = rel.getByteAtOffset(startOffset + kBattleBingoPokemonPanelTypeOffset)
		
		let species  = rel.get2BytesAtOffset(startOffset + kBattleBingoPokemonSpeciesOffset)
		self.species = XGPokemon.pokemon(species)
		
		self.ability = rel.getByteAtOffset(startOffset + kBattleBingoPokemonAbilityOffset)
		
		let gender	= rel.getByteAtOffset(startOffset + kBattleBingoPokemonGenderOffset)
		self.gender = XGGenders(rawValue: gender) ?? .male
		
		let nature	= rel.getByteAtOffset(startOffset + kBattleBingoPokemonNatureOffset)
		self.nature	= XGNatures(rawValue: nature) ?? .hardy
		
		let move = rel.get2BytesAtOffset(startOffset + kBattleBingoPokemonMoveOffset)
	    self.move = .move(move)
		
	}
	
	func save() {
		
		let rel = XGFiles.common_rel.data
		
		rel.replaceByteAtOffset(startOffset + kBattleBingoPokemonPanelTypeOffset, withByte: self.typeOnCard > 0 ? 1 : 0)
		rel.replace2BytesAtOffset(startOffset + kBattleBingoPokemonSpeciesOffset, withBytes: self.species.index)
		rel.replaceByteAtOffset(startOffset + kBattleBingoPokemonAbilityOffset, withByte: self.ability > 0 ? 1 : 0)
		rel.replaceByteAtOffset(startOffset + kBattleBingoPokemonGenderOffset, withByte: self.gender.rawValue)
		rel.replaceByteAtOffset(startOffset + kBattleBingoPokemonNatureOffset, withByte: self.nature.rawValue)
		rel.replace2BytesAtOffset(startOffset + kBattleBingoPokemonMoveOffset, withBytes: self.move.index)
		
		rel.save()
		
	}
	
	
	var dictionaryRepresentation : [String : AnyObject] {
		get {
			var dictRep = [String : AnyObject]()
			dictRep["typeOnCard"] = self.typeOnCard as AnyObject?
			dictRep["ability"] = self.ability as AnyObject?
			
			dictRep["species"] = self.species.dictionaryRepresentation as AnyObject?
			dictRep["nature"] = self.nature.dictionaryRepresentation as AnyObject?
			dictRep["gender"] = self.gender.dictionaryRepresentation as AnyObject?
			dictRep["move"] = self.move.dictionaryRepresentation as AnyObject?
			
			return dictRep
		}
	}
	
	var readableDictionaryRepresentation : [String : AnyObject] {
		get {
			var dictRep = [String : AnyObject]()
			dictRep["typeOnCard"] = (self.typeOnCard == 0 ? self.species.type1.name : self.species.type2.name) as AnyObject?
			dictRep["ability"] = self.ability as AnyObject?
			
			dictRep["nature"] = self.nature.string as AnyObject?
			dictRep["gender"] = self.gender.string as AnyObject?
			dictRep["move"] = self.move.name.string as AnyObject?
			
			return [self.species.name.string : dictRep as AnyObject]
		}
	}

   
}























