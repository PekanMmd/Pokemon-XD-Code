//
//  XGStarterPokemon.swift
//  XG Tool
//
//  Created by StarsMmd on 09/06/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

let kVaporeonStartOffset: Int = {
	if game == .XD {
		switch region {
		case .US: return 0x14F614
		case .EU: return 0x150ED8
		case .JP: return 0x14A93C
		case .OtherGame: return 0
		}
	} else {
		switch region {
		case .US: return 0x12DAC8
		case .EU: return 0x131CF4
		case .JP: return 0x12B198
		case .OtherGame: return 0
		}
	}
}()
let kJolteonStartOffset: Int = {
	if game == .XD {
		switch region {
		case .US: return 0x14F73C
		case .EU: return 0x151000
		case .JP: return 0x14AA64
		case .OtherGame: return 0
		}
	} else {
		switch region {
		case .US: return 0x12DBF0
		case .EU: return 0x131E1C
		case .JP: return 0x12B2C0
		case .OtherGame: return 0
		}
	}
}()

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
	
	var index		= 0
	
	var exp			= 0
	var level		= 0 {
		didSet {
			self.exp = self.species.expRate.expForLevel(level)
		}
	}
	
	var species			= XGPokemon.index(0) {
		didSet {
			self.exp = self.species.expRate.expForLevel(level)
		}
	}
	
	var move1			= XGMoves.index(0)
	var move2			= XGMoves.index(0)
	var move3			= XGMoves.index(0)
	var move4			= XGMoves.index(0)
	var shinyValue		= XGShinyValues.random
	
	var nature			= XGNatures.random
	var gender			= XGGenders.random
	
	var giftType		= game == .XD ? "Demo Starter Pokemon" : "Starter Pokemon"
	
	var startOffset : Int {
		return index == 1 ? kVaporeonStartOffset : kJolteonStartOffset
	}
	
	init(index: Int) {
		super.init()
		
		let dol			= XGFiles.dol.data!
		self.index		= index
		
		let start = startOffset
		
		level = dol.getByteAtOffset(start + kDemoStarterLevelOffset)
		exp	  = dol.get2BytesAtOffset(start + kDemoStarterExpValueOffset)
		
		let species = dol.get2BytesAtOffset(start + kDemoStarterSpeciesOffset)
		self.species = .index(species)
		
		var moveIndex = dol.get2BytesAtOffset(start + kDemoStarterMove1Offset)
		move1 = .index(moveIndex)
		moveIndex = dol.get2BytesAtOffset(start + kDemoStarterMove2Offset)
		move2 = .index(moveIndex)
		moveIndex = dol.get2BytesAtOffset(start + kDemoStarterMove3Offset)
		move3 = .index(moveIndex)
		moveIndex = dol.get2BytesAtOffset(start + kDemoStarterMove4Offset)
		move4 = .index(moveIndex)
		
		let shiny = dol.get2BytesAtOffset(start + kDemoStarterShinyValueOffset)
		self.shinyValue = XGShinyValues(rawValue: shiny) ?? .random
		
		let nat = dol.get2BytesAtOffset(start + kDemoStarterNatureOffset)
		self.nature = XGNatures(rawValue: nat) ?? .random
		let gen = dol.get2BytesAtOffset(start + kDemoStarterGenderOffset)
		self.gender = XGGenders(rawValue: gen) ?? .random
		
	}
	
	func save() {
		if let dol = XGFiles.dol.data {
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
	
}

extension XGDemoStarterPokemon: XGEnumerable {
	var enumerableName: String {
		return species.name.string
 	}
	
	var enumerableValue: String? {
		return index.string
	}
	
	static var enumerableClassName: String {
		return game == .XD ? "Demo Starter Pokemon" : "Starter Pokemon"
	}
	
	static var allValues: [XGDemoStarterPokemon] {
		var values = [XGDemoStarterPokemon]()
		for i in 0 ... 1 {
			values.append(XGDemoStarterPokemon(index: i))
		}
		return values
	}
}

extension XGDemoStarterPokemon: XGDocumentable {
	
	static var documentableClassName: String {
		return game == .XD ? "Demo Starter Pokemon" : "Starter Pokemon"
	}
	
	var documentableName: String {
		return (enumerableValue ?? "") + " - " + enumerableName
	}
	
	static var DocumentableKeys: [String] {
		return ["index", "name", "level", "gender", "nature", "shininess", "moves"]
	}
	
	func documentableValue(for key: String) -> String {
		switch key {
		case "index":
			return index.string
		case "name":
			return species.name.string
		case "level":
			return level.string
		case "gender":
			return gender.string
		case "nature":
			return nature.string
		case "shininess":
			return shinyValue.string
		case "moves":
			var text = ""
			text += "\n" + move1.name.string
			text += "\n" + move2.name.string
			text += "\n" + move3.name.string
			text += "\n" + move4.name.string
			return text
		default:
			return ""
		}
	}
}













