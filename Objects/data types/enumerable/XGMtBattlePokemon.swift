//
//  XGMtBattlePrizePokemon.swift
//  XG Tool
//
//  Created by StarsMmd on 09/06/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

let kChikoritaOffset: Int = {
	switch region {
	case .US: return 0x1C5974
	case .JP: return 0x1C0E08
	case .EU: return 0x1C7270
	case .OtherGame: return 0
	}
}()
let kCyndaquilOffset: Int = {
	switch region {
	case .US: return 0x1C59A0
	case .JP: return 0x1C0E34
	case .EU: return 0x1C729C
	case .OtherGame: return 0
	}
}()
let kTotodileOffset: Int = {
	switch region {
	case .US: return 0x1C59CC
	case .JP: return 0x1C0E60
	case .EU: return 0x1C72C8
	case .OtherGame: return 0
	}
}()

let kMtBattlePokemonLevelOffset: Int = {
	switch region {
	case .US: return 0x1C56E8
	case .JP: return 0x1C0BF8
	case .EU: return 0x1C6FE4
	case .OtherGame: return 0
	}
}()

let kMtBattlePokemonSpeciesOffset	=  0x02
let kMtBattlePokemonMove1Offset		=  0x06
let kMtBattlePokemonMove2Offset		=  0x0A
let kMtBattlePokemonMove3Offset		=  0x0E
let kMtBattlePokemonMove4Offset		=  0x12

final class XGMtBattlePrizePokemon: NSObject, XGGiftPokemon, Codable {
	
	var index			= 0
	
	var species			= XGPokemon.index(0)
	var move1			= XGMoves.index(0)
	var move2			= XGMoves.index(0)
	var move3			= XGMoves.index(0)
	var move4			= XGMoves.index(0)
	
	var giftType		= "Mt. Battle Prize"
	
	// unused
	var shinyValue				= XGShinyValues.random
	var exp				= -1
	var level				= 0
	private(set) var gender	= XGGenders.random
	private(set) var nature	= XGNatures.random
	
	var startOffset : Int {
		get {
			switch index {
				case 0 : return kChikoritaOffset
				case 1 : return kCyndaquilOffset
				default: return kTotodileOffset
			}
		}
	}
	
	init(index: Int) {
		super.init()
		
		let dol			= XGFiles.dol.data!
		self.index		= index
		
		let start = startOffset
		
		let species = dol.get2BytesAtOffset(start + kMtBattlePokemonSpeciesOffset)
		self.species = .index(species)
		self.level = dol.getByteAtOffset(kMtBattlePokemonLevelOffset + 3)
		
		var moveIndex = dol.get2BytesAtOffset(start + kMtBattlePokemonMove1Offset)
		move1 = .index(moveIndex)
		moveIndex = dol.get2BytesAtOffset(start + kMtBattlePokemonMove2Offset)
		move2 = .index(moveIndex)
		moveIndex = dol.get2BytesAtOffset(start + kMtBattlePokemonMove3Offset)
		move3 = .index(moveIndex)
		moveIndex = dol.get2BytesAtOffset(start + kMtBattlePokemonMove4Offset)
		move4 = .index(moveIndex)
		
	}
	
	func save() {
		
		let dol = XGFiles.dol.data!
		let start = startOffset
		
		dol.replace2BytesAtOffset(start + kMtBattlePokemonSpeciesOffset, withBytes: species.index)
		dol.replaceByteAtOffset(kMtBattlePokemonLevelOffset + 3, withByte: level)
		dol.replace2BytesAtOffset(start + kMtBattlePokemonMove1Offset, withBytes: move1.index)
		dol.replace2BytesAtOffset(start + kMtBattlePokemonMove2Offset, withBytes: move2.index)
		dol.replace2BytesAtOffset(start + kMtBattlePokemonMove3Offset, withBytes: move3.index)
		dol.replace2BytesAtOffset(start + kMtBattlePokemonMove4Offset, withBytes: move4.index)
		
		
		dol.save()
	}
   
}

extension XGMtBattlePrizePokemon: XGEnumerable {
	var enumerableName: String {
		return species.name.string
	}
	
	var enumerableValue: String? {
		return String(format: "%03d", index)
	}
	
	static var enumerableClassName: String {
		return "Mt. Battle Prize Pokemon"
	}
	
	static var allValues: [XGMtBattlePrizePokemon] {
		var values = [XGMtBattlePrizePokemon]()
		for i in 0 ..< 3 {
			values.append(XGMtBattlePrizePokemon(index: i))
		}
		return values
	}
}


extension XGMtBattlePrizePokemon: XGDocumentable {
	
	static var documentableClassName: String {
		return "Mt. Battle Prize Pokemon"
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





