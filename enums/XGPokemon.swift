//
//  XGPokemon.swift
//  XG Tool
//
//  Created by The Steez on 01/06/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//

import Foundation

infix operator ==
func == (m1: XGMoves, m2: XGMoves) -> Bool {
	return m1.index == m2.index
}

infix operator <
func < (p1: XGPokemon, p2: XGPokemon) -> Bool {
	return p1.index < p2.index
}

enum XGPokemon: CustomStringConvertible, XGDictionaryRepresentable {
	
	case pokemon(Int)
	
	var description : String {
		get {
			return name.string
		}
	}
	
	var index : Int {
		get {
			switch self {
			case .pokemon(let i): return i
			}
		}
	}
	
	var hex : String {
		get {
			return String(format: "0x%x",self.index)
		}
	}
	
	var startOffset : Int {
		get{
			return kFirstPokemonOffset + (index * kSizeOfPokemonStats)
		}
	}
	
	var nameID : Int {
		get {
			return XGFiles.common_rel.data.get2BytesAtOffset(startOffset + kNameIDOffset)
		}
	}
	
	var name : XGString {
		get {
			let table = XGFiles.common_rel.stringTable
			return table.stringSafelyWithID(nameID)
		}
	}
	
	var ability1 : String {
		get {
			let a1 = XGFiles.common_rel.data.getByteAtOffset(startOffset + kAbility1Offset)
			return XGAbilities.ability(a1).name.string
		}
	}
	var ability2 : String {
		get {
			let a2 = XGFiles.common_rel.data.getByteAtOffset(startOffset + kAbility2Offset)
			return XGAbilities.ability(a2).name.string
		}
	}
	
	var type1 : XGMoveTypes {
		get {
			let type = XGFiles.common_rel.data.getByteAtOffset(startOffset + kType1Offset)
			return XGMoveTypes(rawValue: type) ?? XGMoveTypes.normal
		}
	}
	
	var type2 : XGMoveTypes {
		get {
			let type = XGFiles.common_rel.data.getByteAtOffset(startOffset + kType2Offset)
			return XGMoveTypes(rawValue: type) ?? XGMoveTypes.normal
		}
	}
	
	func hasType(type: XGMoveTypes) -> Bool {
		return (self.type1 == type) || (self.type2 == type)
	}
	
	var catchRate : Int {
		get {
			return XGFiles.common_rel.data.getByteAtOffset(startOffset + kCatchRateOffset)
		}
	}
	
	var expRate : XGExpRate {
		get {
			let rate = XGFiles.common_rel.data.getByteAtOffset(startOffset + kEXPRateOffset)
			return XGExpRate(rawValue: rate) ?? .slow
		}
	}
	
	var stats : XGPokemonStats {
		get {
			return XGPokemonStats(index: self.index)
		}
	}
	
	func movesForLevel(_ pokeLevel: Int) -> [XGMoves] {
		// Returns the last 4 moves a pokemon would have learned at a level. Gives automatic move sets like in the GBA games.
		
		var moves = [XGMoves](repeating: XGMoves.move(0), count: 4)
		
		func hasMove(_ move: XGMoves) -> Bool {
			for aMove in moves {
				if move == aMove {
					return true
				}
			}
			return false
		}
		
		let levelUpMoves = XGPokemonStats(index: self.index).levelUpMoves
		
		var moveSlot = 0
		for move in levelUpMoves {
			if (move.level < pokeLevel) && (move.move.index > 0) {
				
				if hasMove(move.move) {
					continue
				}
				
				moves[(moveSlot % 4)] = move.move
				
			} else {
				return moves
			}
			moveSlot += 1
		}
		
		return moves
	}
	
	static func random() -> XGPokemon {
		var rand = 0
		while (rand == 0) || ((rand > 251) && (rand < 277)) || (rand > 411) {
			rand = Int(arc4random_uniform(UInt32(kNumberOfPokemon - 1))) + 1
		}
		return XGPokemon.pokemon(rand)
	}
	
	var dictionaryRepresentation: [String : AnyObject] {
		get {
			return ["Value" : self.index as AnyObject]
		}
	}
	
	var readableDictionaryRepresentation: [String : AnyObject] {
		get {
			return ["Value" : self.name.string as AnyObject]
		}
	}
	
	static func allPokemon() -> [XGPokemon] {
		var mons = [XGPokemon]()
		for i in 0 ..< kNumberOfPokemon {
			mons.append(.pokemon(i))
		}
		return mons
	}
}


enum XGOriginalPokemon {
	
	case pokemon(Int)
	
	var index : Int {
		get {
			switch self {
				case .pokemon(let i): return i
			}
		}
	}
	
	var startOffset : Int {
		get{
			return kFirstPokemonOffset + (index * kSizeOfPokemonStats)
		}
	}
	
	var nameID : Int {
		get {
			return XGFiles.original(.common_rel).data.get2BytesAtOffset(startOffset + kNameIDOffset)
		}
	}
	
	var name : String {
		get {
			let table = XGFiles.original(.common_rel).stringTable
			return table.stringSafelyWithID(nameID).string
		}
	}
	
	var type1 : XGMoveTypes {
		get {
			let type = XGFiles.original(.common_rel).data.getByteAtOffset(startOffset + kType1Offset)
			return XGMoveTypes(rawValue: type) ?? XGMoveTypes.normal
		}
	}
	
	var type2 : XGMoveTypes {
		get {
			let type = XGFiles.original(.common_rel).data.getByteAtOffset(startOffset + kType2Offset)
			return XGMoveTypes(rawValue: type) ?? XGMoveTypes.normal
		}
	}
	
	func hasType(type: XGMoveTypes) -> Bool {
		return (self.type1 == type) || (self.type2 == type)
	}
	
	static func allPokemon() -> [XGOriginalPokemon] {
		var mons = [XGOriginalPokemon]()
		for i in 0 ..< kNumberOfPokemon {
			mons.append(.pokemon(i))
		}
		return mons
	}
	
}

func allPokemon() -> [String : XGPokemon] {
	
	var dic = [String : XGPokemon]()
	
	for i in 0 ..< kNumberOfPokemon {
		
		let a = XGPokemon.pokemon(i)
		
		dic[a.name.string.lowercased()] = a
		
	}
	
	return dic
}

let pokemons = allPokemon()

func pokemon(_ name: String) -> XGPokemon {
	if pokemons[name.lowercased()] == nil { print("couldn't find: " + name) }
	return pokemons[name.lowercased()] ?? .pokemon(0)
}

func allPokemonArray() -> [XGPokemon] {
	var pokes: [XGPokemon] = []
	for i in 0 ..< kNumberOfPokemon {
		pokes.append(XGPokemon.pokemon(i))
	}
	return pokes
}

func allOriginalPokemonArray() -> [XGOriginalPokemon] {
	var pokes: [XGOriginalPokemon] = []
	for i in 0 ..< kNumberOfPokemon {
		pokes.append(XGOriginalPokemon.pokemon(i))
	}
	return pokes
}










