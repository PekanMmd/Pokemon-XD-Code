//
//  XGStarterViewController.swift
//  XG Tool
//
//  Created by StarsMmd on 11/06/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

let kEeveeStartOffset			= game == .XD ? 0x1CBC50 : 0x0

let kStarterSpeciesOffset		= 0x02
let kStarterLevelOffset			= 0x0B
let kStarterMove1Offset			= 0x12
let kStarterMove2Offset			= 0x16
let kStarterMove3Offset			= 0x1A
let kStarterMove4Offset			= 0x1E
let kStarterExpValueOffset		= 0x66

final class XGStarterPokemon: NSObject, XGGiftPokemon, Codable {
	
	@objc var level		= 0
	@objc var exp		= 0
	var species			= XGPokemon.pokemon(0)
	var move1			= XGMoves.move(0)
	var move2			= XGMoves.move(0)
	var move3			= XGMoves.move(0)
	var move4			= XGMoves.move(0)
	
	@objc var giftType		= "Starter Pokemon"
	
	// unused
	@objc var index			= 0
	var shinyValue			= XGShinyValues.random
	private(set) var gender	= XGGenders.random
	private(set) var nature	= XGNatures.random
		
	@objc var startOffset : Int {
		get {
			return kEeveeStartOffset
		}
	}
	
	override init() {
		super.init()
		
		if game == .XD {
			let dol			= XGFiles.dol.data!
			
			let start = startOffset
			
			level = dol.getByteAtOffset(start + kStarterLevelOffset)
			exp	  = dol.get2BytesAtOffset(start + kStarterExpValueOffset)
			
			let species = dol.get2BytesAtOffset(start + kStarterSpeciesOffset)
			self.species = .pokemon(species)
			
			var moveIndex = dol.get2BytesAtOffset(start + kStarterMove1Offset)
			move1 = .move(moveIndex)
			moveIndex = dol.get2BytesAtOffset(start + kStarterMove2Offset)
			move2 = .move(moveIndex)
			moveIndex = dol.get2BytesAtOffset(start + kStarterMove3Offset)
			move3 = .move(moveIndex)
			moveIndex = dol.get2BytesAtOffset(start + kStarterMove4Offset)
			move4 = .move(moveIndex)
		}
	}
	
	@objc func save() {
		
		if game == .XD {
			let dol = XGFiles.dol.data!
			let start = startOffset
			
			dol.replaceByteAtOffset(start + kStarterLevelOffset, withByte: level)
			dol.replace2BytesAtOffset(start + kStarterExpValueOffset, withBytes: exp)
			dol.replace2BytesAtOffset(start + kStarterSpeciesOffset, withBytes: species.index)
			dol.replace2BytesAtOffset(start + kStarterMove1Offset, withBytes: move1.index)
			dol.replace2BytesAtOffset(start + kStarterMove2Offset, withBytes: move2.index)
			dol.replace2BytesAtOffset(start + kStarterMove3Offset, withBytes: move3.index)
			dol.replace2BytesAtOffset(start + kStarterMove4Offset, withBytes: move4.index)
			
			dol.save()
		}
	}
	
}

extension XGStarterPokemon: XGEnumerable {
	var enumerableName: String {
		return species.name.string
	}
	
	var enumerableValue: String? {
		return nil
	}
	
	static var enumerableClassName: String {
		return "Starter Pokemon"
	}
	
	static var allValues: [XGStarterPokemon] {
		return [XGStarterPokemon()]
	}
}


extension XGStarterPokemon: XGDocumentable {
	
	static var documentableClassName: String {
		return "Starter Pokemon"
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






















