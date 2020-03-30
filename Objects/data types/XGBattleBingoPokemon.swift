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

class XGBattleBingoPokemon: NSObject, Codable {
	
	@objc var typeOnCard	= 0x0
	var species				= XGPokemon.pokemon(0)
	@objc var ability		= 0x0
	var nature		= XGNatures.hardy
	var gender		= XGGenders.male
	var move		= XGMoves.move(0)
	
	@objc var startOffset : Int = 0
	
	override var description : String {
		get {
			return self.species.name.string + " (" + self.move.name.string + ")"
		}
	}
	
	override init() {
		super.init()
	}
	
	@objc init(startOffset: Int) {
		super.init()
		
		self.startOffset = startOffset
		let rel = XGFiles.common_rel.data!
		
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
	
	@objc func save() {
		
		guard self.startOffset > 0 else {
			return
		}
		
		let rel = XGFiles.common_rel.data!
		
		rel.replaceByteAtOffset(startOffset + kBattleBingoPokemonPanelTypeOffset, withByte: self.typeOnCard > 0 ? 1 : 0)
		rel.replace2BytesAtOffset(startOffset + kBattleBingoPokemonSpeciesOffset, withBytes: self.species.index)
		rel.replaceByteAtOffset(startOffset + kBattleBingoPokemonAbilityOffset, withByte: self.ability > 0 ? 1 : 0)
		rel.replaceByteAtOffset(startOffset + kBattleBingoPokemonGenderOffset, withByte: self.gender.rawValue)
		rel.replaceByteAtOffset(startOffset + kBattleBingoPokemonNatureOffset, withByte: self.nature.rawValue)
		rel.replace2BytesAtOffset(startOffset + kBattleBingoPokemonMoveOffset, withBytes: self.move.index)
		
		rel.save()
		
	}
   
}

extension XGBattleBingoPokemon: XGDocumentable {
	
	static var documentableClassName: String {
		return "Battle Bingo Pokemon"
	}
	
	var documentableName: String {
		return species.name.string
	}
	
	static var DocumentableKeys: [String] {
		return ["name", "type", "ability", "nature", "gender", "move"]
	}
	
	func documentableValue(for key: String) -> String {
		switch key {
		case "name":
			return species.name.string
		case "type":
			return typeOnCard == 0 ? species.type1.name : species.type2.name
		case "ability":
			return ability == 0 ? species.ability1 : species.ability2
		case "nature":
			return nature.string
		case "gender":
			return gender.string
		case "move":
			return move.name.string
		default:
			return ""
		}
	}
}





















