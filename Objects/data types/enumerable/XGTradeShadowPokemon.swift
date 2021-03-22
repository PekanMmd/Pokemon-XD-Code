//
//  XGTradeShadowPokemon.swift
//  XG Tool
//
//  Created by StarsMmd on 11/06/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

let kTogepiOffset: Int = {
	switch region {
	case .US: return 0x1C5760
	case .JP: return 0x1C0C70
	case .EU: return 0x1C705C
	case .OtherGame: return 0
	}
}()

let kTradeShadowPokemonSpeciesOffset	=  0x02
let kTradeShadowDDPKIDOffset			=  0x06
let kTradeShadowPokemonLevelOffset		=  0x0B
let kTradeShadowPokemonMove1Offset		=  0x0E
let kTradeShadowPokemonMove2Offset		=  0x12
let kTradeShadowPokemonMove3Offset		=  0x16
let kTradeShadowPokemonMove4Offset		=  0x1A

var tradeShadowPokemonShininessRAMOffset: Int {
	switch region {
	case .US: return 0x152bfe - kDolToRAMOffsetDifference
	case .EU: return 0x1544c2 - kDolToRAMOffsetDifference
	case .JP: return 0x14AE86 - kDolToRAMOffsetDifference
	case .OtherGame: return 0
	}
}

final class XGTradeShadowPokemon: NSObject, XGGiftPokemon, Codable {
	
	var level			= 0x0
	var species			= XGPokemon.index(0)
	var move1			= XGMoves.index(0)
	var move2			= XGMoves.index(0)
	var move3			= XGMoves.index(0)
	var move4			= XGMoves.index(0)
	
	var giftType		= "Shadow Pokemon Gift"
	
	// unused
	var index			= 0
	var exp				= -1
	var shinyValue		= XGShinyValues.never
	private(set) var gender	= XGGenders.random
	private(set) var nature	= XGNatures.random

	var shadowID = 0
	
	var startOffset : Int {
		return kTogepiOffset
	}
	
	override init() {
		super.init()
		
		let dol = XGFiles.dol.data!
		
		let start = startOffset
		
		let species = dol.get2BytesAtOffset(start + kTradeShadowPokemonSpeciesOffset)
		self.species = .index(species)
		
		level = dol.getByteAtOffset(start + kTradeShadowPokemonLevelOffset)
		shadowID = dol.get2BytesAtOffset(start + kTradeShadowDDPKIDOffset)
		
		var moveIndex = dol.get2BytesAtOffset(start + kTradeShadowPokemonMove1Offset)
		move1 = .index(moveIndex)
		moveIndex = dol.get2BytesAtOffset(start + kTradeShadowPokemonMove2Offset)
		move2 = .index(moveIndex)
		moveIndex = dol.get2BytesAtOffset(start + kTradeShadowPokemonMove3Offset)
		move3 = .index(moveIndex)
		moveIndex = dol.get2BytesAtOffset(start + kTradeShadowPokemonMove4Offset)
		move4 = .index(moveIndex)

		shinyValue = XGShinyValues(rawValue:  dol.get2BytesAtOffset(tradeShadowPokemonShininessRAMOffset - kDolToRAMOffsetDifference)) ?? .never
		
	}
	
	func save() {
		
		if let dol = XGFiles.dol.data {
			let start = startOffset

			dol.replace2BytesAtOffset(start + kTradeShadowDDPKIDOffset, withBytes: shadowID)
			dol.replaceByteAtOffset(start + kTradeShadowPokemonLevelOffset, withByte: level)
			dol.replace2BytesAtOffset(start + kTradeShadowPokemonSpeciesOffset, withBytes: species.index)
			dol.replace2BytesAtOffset(start + kTradeShadowPokemonMove1Offset, withBytes: move1.index)
			dol.replace2BytesAtOffset(start + kTradeShadowPokemonMove2Offset, withBytes: move2.index)
			dol.replace2BytesAtOffset(start + kTradeShadowPokemonMove3Offset, withBytes: move3.index)
			dol.replace2BytesAtOffset(start + kTradeShadowPokemonMove4Offset, withBytes: move4.index)

			dol.replace2BytesAtOffset(tradeShadowPokemonShininessRAMOffset - kDolToRAMOffsetDifference, withBytes: shinyValue.rawValue)

			dol.save()

		}
	}
	
}

extension XGTradeShadowPokemon: XGEnumerable {
	var enumerableName: String {
		return species.name.string
	}
	
	var enumerableValue: String? {
		return nil
	}
	
	static var className: String {
		return "Gift Shadow Pokemon"
	}
	
	static var allValues: [XGTradeShadowPokemon] {
		return [XGTradeShadowPokemon()]
	}
}

extension XGTradeShadowPokemon: XGDocumentable {
	
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
