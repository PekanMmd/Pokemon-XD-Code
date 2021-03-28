//
//  CMGiftPokemon.swift
//  Colosseum Tool
//
//  Created by The Steez on 16/08/2018.
//

import Foundation

var kPlusleOffset: Int {
	if game == .XD {
		switch region {
		case .US: return 0x14F514
		case .JP: return 0x14A83C
		case .EU: return 0x150DD8
		case .OtherGame: return 0
		}
	} else {
		switch region {
		case .US: return 0x12D9C8
		case .JP: return 0x12B098
		case .EU: return 0x131BF4
		case .OtherGame: return 0
		}
	}
}
var kHoohOffset: Int {
	if game == .XD {
		switch region {
		case .US: return 0x14F430
		case .JP: return 0x14A758
		case .EU: return 0x150CF4
		case .OtherGame: return 0
		}
	} else {
		switch region {
		case .US: return 0x12D8E4
		case .JP: return 0x12AFB8
		case .EU: return 0x131B10
		case .OtherGame: return 0
		}
	}
}
var kCelebiOffset: Int {
	if game == .XD {
		switch region {
		case .US: return 0x14F200
		case .JP: return 0x14A528
		case .EU: return 0x150AC4
		case .OtherGame: return 0
		}
	} else {
		switch region {
		case .US: return 0x12D6B4
		case .JP: return 0x12ADD0
		case .EU: return 0x1318E0
		case .OtherGame: return 0
		}
	}
}
var kPikachuOffset: Int {
	if game == .XD {
		switch region {
		case .US: return 0x14F310
		case .JP: return 0x14A638
		case .EU: return 0x150BD4
		case .OtherGame: return 0
		}
	} else {
		switch region {
		case .US: return 0x12D7C4
		case .JP: return 0x12AEBC
		case .EU: return 0x1319F0
		case .OtherGame: return 0
		}
	}
}

let kDistroPokemonSpeciesOffset		= 0x02
let kDistroPokemonLevelOffset		= 0x07
let kDistroPokemonShininessOffset	= 0x5e

let kNumberOfDistroPokemon = 4

final class CMGiftPokemon: NSObject, XGGiftPokemon, Codable {
	
	var index			= 0
	
	var level			= 0x0
	var species			= XGPokemon.index(0)
	var move1			= XGMoves.index(0)
	var move2			= XGMoves.index(0)
	var move3			= XGMoves.index(0)
	var move4			= XGMoves.index(0)
	
	var giftType		= ""
	
	// unused
	var exp						= -1
	var shinyValue				= XGShinyValues.random
	private(set) var gender 	= XGGenders.random
	private(set) var nature 	= XGNatures.random

	var usesLevelUpMoves = true
	
	var startOffset : Int {
		get {
			switch index {
			case 0 : return kPlusleOffset
			case 1 : return kHoohOffset
			case 2 : return kCelebiOffset
			default: return kPikachuOffset
			}
		}
	}
	
	init(index: Int) {
		super.init()
		
		let dol			= XGFiles.dol.data!
		self.index		= index
		
		let start = startOffset
		
		let species = dol.get2BytesAtOffset(start + kDistroPokemonSpeciesOffset)
		self.species = .index(species)
		
		level = dol.getByteAtOffset(start + kDistroPokemonLevelOffset)
		
		let shiny = dol.get2BytesAtOffset(start + kDistroPokemonShininessOffset)
		self.shinyValue = XGShinyValues(rawValue: shiny) ?? .random
		
		let moves = self.species.movesForLevel(level)
		self.move1 = moves[0]
		self.move2 = moves[1]
		self.move3 = moves[2]
		self.move4 = moves[3]
		
		switch index {
		case 0  : self.giftType = "Duking's Plusle"
		case 1  : self.giftType = "Mt.Battle Ho-oh"
		case 2  : self.giftType = "Agate Celebi"
		default : self.giftType = "Agate Pikachu"
		}
		
	}
	
	func save() {
		
		let dol = XGFiles.dol.data!
		let start = startOffset
		
		dol.replaceByteAtOffset(start + kDistroPokemonLevelOffset, withByte: level)
		dol.replace2BytesAtOffset(start + kDistroPokemonSpeciesOffset, withBytes: species.index)
		dol.replace2BytesAtOffset(start + kDistroPokemonShininessOffset, withBytes: shinyValue.rawValue)
		
		dol.save()
	}
	
}

extension CMGiftPokemon: XGEnumerable {
	var enumerableName: String {
		return species.name.string
	}
	
	var enumerableValue: String? {
		return index.string
	}
	
	static var className: String {
		return game == .XD ? "Colosseum Gift Pokemon" : "Gift Pokemon"
	}
	
	static var allValues: [CMGiftPokemon] {
		var values = [CMGiftPokemon]()
		for i in 0 ... 3 {
			values.append(CMGiftPokemon(index: i))
		}
		return values
	}
}

extension CMGiftPokemon: XGDocumentable {
	
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
