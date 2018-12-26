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

enum XGPokemon: XGDictionaryRepresentable {
	
	
	case pokemon(Int)
	
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
			}
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
	
	static func random() -> XGPokemon {
		var rand = 0
		while (rand == 0) || (XGPokemon.pokemon(rand).nameID == 0) {
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











