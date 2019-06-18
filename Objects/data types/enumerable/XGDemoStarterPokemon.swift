//
//  XGStarterPokemon.swift
//  XG Tool
//
//  Created by StarsMmd on 09/06/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

let kVaporeonStartOffset = game == .XD ? 0x14F614 : 0x12DAC8
let kJolteonStartOffset	 = game == .XD ? 0x14F73C : 0x12DBF0

let kDemoStarterSpeciesOffset		= 0x02
let kDemoStarterLevelOffset			= 0x07
let kDemoStarterMove1Offset			= 0x16
let kDemoStarterMove2Offset			= 0x26
let kDemoStarterMove3Offset			= 0x36
let kDemoStarterMove4Offset			= 0x46
let kDemoStarterGenderOffset		= 0x56
let kDemoStarterNatureOffset		= 0x5a
let kDemoStarterShinyValueOffset	= 0x5e
let kDemoStarterExpValueOffset		= 0x92

final class XGDemoStarterPokemon: NSObject, XGGiftPokemon, Codable {
	
	@objc var index			= 0
	
	@objc var exp			= 0
	@objc var level			= 0 {
		didSet {
			self.exp = self.species.expRate.expForLevel(level)
		}
	}
	
	var species			= XGPokemon.pokemon(0) {
		didSet {
			self.exp = self.species.expRate.expForLevel(level)
		}
	}
	
	var move1			= XGMoves.move(0)
	var move2			= XGMoves.move(0)
	var move3			= XGMoves.move(0)
	var move4			= XGMoves.move(0)
	var shinyValue		= XGShinyValues.random
	
	var nature			= XGNatures.random
	var gender			= XGGenders.random
	
	@objc var giftType		= game == .XD ? "Demo Starter Pokemon" : "Starter Pokemon"
	
	@objc var startOffset : Int {
		get {
			return index == 1 ? kVaporeonStartOffset : kJolteonStartOffset
		}
	}
	
	@objc init(index: Int) {
		super.init()
		
		let dol			= XGFiles.dol.data!
		self.index		= index
		
		let start = startOffset
		
		level = dol.getByteAtOffset(start + kDemoStarterLevelOffset)
		exp	  = dol.get2BytesAtOffset(start + kDemoStarterExpValueOffset)
		
		let species = dol.get2BytesAtOffset(start + kDemoStarterSpeciesOffset)
		self.species = .pokemon(species)
		
		var moveIndex = dol.get2BytesAtOffset(start + kDemoStarterMove1Offset)
		move1 = .move(moveIndex)
		moveIndex = dol.get2BytesAtOffset(start + kDemoStarterMove2Offset)
		move2 = .move(moveIndex)
		moveIndex = dol.get2BytesAtOffset(start + kDemoStarterMove3Offset)
		move3 = .move(moveIndex)
		moveIndex = dol.get2BytesAtOffset(start + kDemoStarterMove4Offset)
		move4 = .move(moveIndex)
		
		let shiny = dol.get2BytesAtOffset(start + kDemoStarterShinyValueOffset)
		self.shinyValue = XGShinyValues(rawValue: shiny)!
		
		let nat = dol.get2BytesAtOffset(start + kDemoStarterNatureOffset)
		self.nature = XGNatures(rawValue: nat) ?? .random
		let gen = dol.get2BytesAtOffset(start + kDemoStarterGenderOffset)
		self.gender = XGGenders(rawValue: gen) ?? .random
		
	}
	
	@objc func save() {
		
		let dol = XGFiles.dol.data!
		let start = startOffset
		
		dol.replaceByteAtOffset(start + kDemoStarterLevelOffset, withByte: level)
		dol.replace2BytesAtOffset(start + kDemoStarterExpValueOffset, withBytes: exp)
		dol.replace2BytesAtOffset(start + kDemoStarterSpeciesOffset, withBytes: species.index)
		dol.replace2BytesAtOffset(start + kDemoStarterShinyValueOffset, withBytes: shinyValue.rawValue)
		dol.replace2BytesAtOffset(start + kDemoStarterMove1Offset, withBytes: move1.index)
		dol.replace2BytesAtOffset(start + kDemoStarterMove2Offset, withBytes: move2.index)
		dol.replace2BytesAtOffset(start + kDemoStarterMove3Offset, withBytes: move3.index)
		dol.replace2BytesAtOffset(start + kDemoStarterMove4Offset, withBytes: move4.index)
		
		dol.replace2BytesAtOffset(start + kDemoStarterNatureOffset, withBytes: nature.rawValue)
		dol.replace2BytesAtOffset(start + kDemoStarterGenderOffset, withBytes: gender.rawValue)
		
		dol.save()
	}
	
}

extension XGDemoStarterPokemon: XGEnumerable {
	var enumerableName: String {
		return species.name.string
 	}
	
	var enumerableValue: String? {
		return index.string
	}
	
	static var enumerableClassName: String {
		return game == .XD ? "Demo Starters" : "Starter Pokemon"
	}
	
	static var allValues: [XGDemoStarterPokemon] {
		var values = [XGDemoStarterPokemon]()
		for i in 0 ... 1{
			values.append(XGDemoStarterPokemon(index: i))
		}
		return values
	}
}















