//
//  XGMoves.swift
//  XG Tool
//
//  Created by StarsMmd on 01/06/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

enum PBRRandomMoveStyle : Int {
	case offensive = 0
	case defensive = 1
	
	var string : String {
		return self.rawValue == 0 ? "Offensive" : "Defensive"
	}
}

enum PBRRandomMoveType : Int {
	case levelup = 0
	// not sure of the difference yet
	case tm = 1
	case tm2 = 2
	case tm3 = 3
	case tm4 = 4
	
	var string : String {
		return self.rawValue == 0 ? "Level-up Move" : "TM \(self.rawValue)"
	}
}

enum XGMoves: XGIndexedValue {
	
	case move(Int)
	case randomMove(PBRRandomMoveStyle, PBRRandomMoveType)
	
	var index : Int {
		switch self {
		case .move(let i): return i
		case .randomMove(let s, let t): return 0x8000 + (s.rawValue << 4) + t.rawValue
			
		}
	}
	
	var nameID : Int {
		switch self {
		case .move:
			return data.nameID
		default:
			return 0
		}
	}
	
	var name : XGString {
		switch self {
		case .move:
			return getStringSafelyWithID(id: nameID)
		case .randomMove(let s, let t):
			let text = "Random " + s.string + " " + t.string
			return XGString(string: text, file: nil, sid: nil)
		}
	}
	
	var type : XGMoveTypes {
		return data.type
	}
	
	var data : XGMove {
		return XGMove(index: self.index)
	}
	
	var isShadowMove: Bool {
		return false
	}
	
	static func allMoves() -> [XGMoves] {
		var moves = [XGMoves]()
		for i in -1 ..< kNumberOfMoves {
			moves.append(.move(i))
		}
		return moves
	}
	
	static func random() -> XGMoves {
		var rand = 0
		while (XGMoves.move(rand).data.descriptionID == 0) {
			rand = Int(arc4random_uniform(UInt32(kNumberOfMoves - 2))) + 1
		}
		return XGMoves.move(rand)
	}
	
	static func randomMoveset() -> [XGMoves] {
		return [XGMoves.random(),XGMoves.random(),XGMoves.random(),XGMoves.random()]
	}
	
}

func allMoves() -> [String : XGMoves] {
	
	var dic = [String : XGMoves]()
	
	for i in 0 ..< kNumberOfMoves {
		let a = XGMoves.move(i)
		dic[a.name.unformattedString.simplified] = a
	}
	
	return dic
}

let moves = allMoves()

func move(_ name: String) -> XGMoves {
	if moves[name.simplified] == nil { printg("couldn't find: " + name) }
	return moves[name.simplified] ?? .move(0)
}


func allMovesArray() -> [XGMoves] {
	var moves: [XGMoves] = []
	for i in 0 ..< kNumberOfMoves {
		moves.append(XGMoves.move(i))
	}
	return moves
}


extension XGMoves: Codable {
	enum CodingKeys: String, CodingKey {
		case index, name
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		let index = try container.decode(Int.self, forKey: .index)
		self = .move(index)
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(self.index, forKey: .index)
		try container.encode(self.name.string, forKey: .name)
	}
}

extension XGMoves: XGEnumerable {
	var enumerableName: String {
		return name.unformattedString.spaceToLength(20)
	}
	
	var enumerableValue: String? {
		return index.string
	}
	
	static var enumerableClassName: String {
		return "Moves"
	}
	
	static var allValues: [XGMoves] {
		return XGMoves.allMoves()
	}
}



























