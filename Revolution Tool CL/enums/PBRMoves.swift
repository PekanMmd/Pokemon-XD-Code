//
//  XGMoves.swift
//  XG Tool
//
//  Created by StarsMmd on 01/06/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

enum XGMoves : XGDictionaryRepresentable {
	
	case move(Int)
	
	var index : Int {
		get {
			switch self {
				case .move(let i): return i
			}
		}
	}
	
	var nameID : Int {
		get {
			return data.nameID
		}
	}
	
	var name : XGString {
		get {
			return getStringSafelyWithID(id: nameID)
		}
	}
	
	var type : XGMoveTypes {
		get {
			return data.type
		}
	}
	
	var data : XGMove {
		get {
			return XGMove(index: self.index)
		}
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
	
	static func allMoves() -> [XGMoves] {
		var moves = [XGMoves]()
		for i in -1 ..< kNumberOfMoves - 1 {
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
	
	for i in -1 ..< kNumberOfMoves - 1 {
		
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
	for i in -1 ..< kNumberOfMoves - 1 {
		moves.append(XGMoves.move(i))
	}
	return moves
}






























