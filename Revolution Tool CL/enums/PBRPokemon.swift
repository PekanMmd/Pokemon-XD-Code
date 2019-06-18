//
//  XGPokemon.swift
//  XG Tool
//
//  Created by StarsMmd on 01/06/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
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

enum XGPokemon: XGIndexedValue {
	
	case pokemon(Int)
	case deoxys(XGDeoxysFormes)
	case burmy(XGWormadamCloaks)
	case wormadam(XGWormadamCloaks)
	
	var description : String {
		get {
			return self.name.string
		}
	}
	
	var index : Int {
		get {
			switch self {
			case .pokemon(let i):
				if (i > kNumberOfPokemon) || (i < 0) {
					return 0
				}
				return i
			case .deoxys(let f):
				switch f {
				case .normal:
					return 386
				default:
					return 495 + f.rawValue
				}
			case .burmy: return 412
			case .wormadam(let c):
				switch c {
				case .plant:
					return 413
				default:
					return 498 + c.rawValue
				}
			}
		}
	}
	
	var baseIndex : Int {
		switch self {
		case .pokemon:
			switch self.index {
			case 496: fallthrough
			case 497: fallthrough
			case 498: return 386
				
			case 499: fallthrough
			case 500: return 413
				
			default: return self.index
			}
		case .deoxys: return 386
		case .burmy: return 412
		case .wormadam: return 413
		}
	}
	
	var nameID : Int {
		get {
			return stats.nameID
		}
	}
	
	var name : XGString {
		get {
			return getStringSafelyWithID(id: nameID)
		}
	}
	
	var formeName : String {
		var forme = ""
		switch self {
		case .burmy(let c):
			forme = " (\(c.name))"
		case .wormadam(let c):
			forme = " (\(c.name))"
		case .deoxys(let f):
			forme = " (\(f.name))"
		default: break
		}
		return self.name.unformattedString + forme
	}
	
	var type1 : XGMoveTypes {
		get {
			return stats.type1
		}
	}
	
	var type2 : XGMoveTypes {
		get {
			return stats.type2
		}
	}
	
	func hasType(type: XGMoveTypes) -> Bool {
		return (self.type1 == type) || (self.type2 == type)
	}
	
	var stats : XGPokemonStats {
		get {
			return XGPokemonStats(index: self.index)
		}
	}
	
	func movesForLevel(_ pokeLevel: Int) -> [XGMoves] {
		// Returns the last 4 moves a pokemon would have learned at a level. Gives default move sets like in the GBA games.
		
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
			if (move.level <= pokeLevel) && (move.move.index > 0) {
				
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
		while (rand == 0) || (XGPokemon.pokemon(rand).nameID == 0) {
			rand = Int(arc4random_uniform(UInt32(kNumberOfPokemon - 1))) + 1
		}
		return XGPokemon.pokemon(rand)
	}
	
	static func allPokemon() -> [XGPokemon] {
		var mons = [XGPokemon]()
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
		
		dic[a.name.unformattedString.lowercased()] = a
		
	}
	
	return dic
}

let pokemons = allPokemon()

func pokemon(_ name: String) -> XGPokemon {
	if pokemons[name.lowercased()] == nil { printg("couldn't find: " + name) }
	return pokemons[name.lowercased()] ?? .pokemon(0)
}

func allPokemonArray() -> [XGPokemon] {
	var pokes: [XGPokemon] = []
	for i in 0 ..< kNumberOfPokemon {
		pokes.append(XGPokemon.pokemon(i))
	}
	return pokes
}











