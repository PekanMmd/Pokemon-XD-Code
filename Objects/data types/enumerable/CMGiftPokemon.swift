//
//  CMGiftPokemon.swift
//  Colosseum Tool
//
//  Created by The Steez on 16/08/2018.
//

import Foundation

let kPlusleOffset			= game == .Colosseum ? 0x12D9C8 : 0x1525b4 - kDolToRAMOffsetDifference
let kHoohOffset				= game == .Colosseum ? 0x12D8E4 : 0x1524d0 - kDolToRAMOffsetDifference
let kCelebiOffset			= game == .Colosseum ? 0x12D6B4 : 0x1522a0 - kDolToRAMOffsetDifference
let kPikachuOffset			= game == .Colosseum ? 0x12D7C4 : 0x1523b0 - kDolToRAMOffsetDifference

let kDistroPokemonSpeciesOffset		=  0x02
let kDistroPokemonLevelOffset		=  0x07

let kNumberOfDistroPokemon = 4

final class CMGiftPokemon: NSObject, XGGiftPokemon, Codable {
	
	var index			= 0
	
	var level			= 0x0
	var species			= XGPokemon.pokemon(0)
	var move1			= XGMoves.move(0)
	var move2			= XGMoves.move(0)
	var move3			= XGMoves.move(0)
	var move4			= XGMoves.move(0)
	
	var giftType		= ""
	
	// unused
	var exp							= -1
	var shinyValue				= XGShinyValues.random
	private(set) var gender 	= XGGenders.random
	private(set) var nature 	= XGNatures.random
	
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
		self.species = .pokemon(species)
		
		level = dol.getByteAtOffset(start + kDistroPokemonLevelOffset)
		
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
	
	static var enumerableClassName: String {
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
	
	static var documentableClassName: String {
		return game == .XD ? "Colosseum Gift Pokemon" : "Gift Pokemon"
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
