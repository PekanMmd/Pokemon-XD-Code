//
//  XGMoves.swift
//  XG Tool
//
//  Created by The Steez on 01/06/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//

import Foundation

let kFirstShadowMoveIndex	= 0x164
let kLastShadowMoveIndex	= 0x176

let shadowMovesUseHMFlag	= XGMove(index: kFirstShadowMoveIndex).HMFlag

enum XGMoves : CustomStringConvertible, XGDictionaryRepresentable {
	
	case move(Int)
	
	var index : Int {
		get {
			switch self {
				case .move(let i): return i
			}
		}
	}
	
	var hex : String {
		get {
			return String(format: "0x%x",self.index)
		}
	}
	
	var startOffset : Int {
		get {
			return kFirstMoveOffset + (index * kSizeOfMoveData)
		}
	}
	
	var nameID : Int {
		get {
			return XGFiles.common_rel.data.get2BytesAtOffset(startOffset + kMoveNameIDOffset)
		}
	}
	
	var name : XGString {
		get {
			return XGFiles.common_rel.stringTable.stringSafelyWithID(nameID)
		}
	}
	
	var descriptionID : Int {
		get {
			return XGFiles.common_rel.data.get2BytesAtOffset(startOffset + kMoveDescriptionIDOffset)
		}
	}
	
	var description : String {
		get {
			return self.name.string
		}
	}
	
	var mdescription : XGString {
		get {
			return XGFiles.dol.stringTable.stringSafelyWithID(descriptionID)
		}
	}
	
	var type : XGMoveTypes {
		get {
			let index = XGFiles.common_rel.data.getByteAtOffset(startOffset + kMoveTypeOffset)
			return XGMoveTypes(rawValue: index) ?? .normal
		}
	}
	
	var category : XGMoveCategories {
		get {
			let index = XGFiles.common_rel.data.getByteAtOffset(startOffset + kMoveCategoryOffset)
			return XGMoveCategories(rawValue: index) ?? .none
		}
	}
	
	var isShadowMove : Bool {
		get {
			return shadowMovesUseHMFlag ? self.data.HMFlag : (self.index >= kFirstShadowMoveIndex) && (self.index <= kLastShadowMoveIndex)
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
		for i in 0 ..< kNumberOfMoves {
			moves.append(.move(i))
		}
		return moves
	}
	
	static func random() -> XGMoves {
		var rand = 0
		while (XGMoves.move(rand).name.length < 2) || (XGMoves.move(rand).isShadowMove) {
			rand = Int(arc4random_uniform(UInt32(kNumberOfMoves - 1))) + 1
		}
		return XGMoves.move(rand)
	}
	
	static func randomShadow() -> XGMoves {
		var rand = 0
		while (!XGMoves.move(rand).isShadowMove) || (XGMoves.move(rand).name.length < 2)  {
			rand = Int(arc4random_uniform(UInt32(kNumberOfMoves - 1))) + 1
		}
		return XGMoves.move(rand)
	}
	
	static func randomMoveset() -> [XGMoves] {
		return [XGMoves.random(),XGMoves.random(),XGMoves.random(),XGMoves.random()]
	}
	
}

enum XGOriginalMoves {
	
	case move(Int)
	
	var index : Int {
		get {
			switch self {
			case .move(let i): return i
			}
		}
	}
	
	var startOffset : Int {
		get {
			return XGMoves.move(index).startOffset
		}
	}
	
	var nameID : Int {
		get {
			return XGFiles.original(.common_rel).data.get2BytesAtOffset(startOffset + kMoveNameIDOffset)
		}
	}
	
	var descriptionID : Int {
		get {
			return XGFiles.original(.common_rel).data.get2BytesAtOffset(startOffset + kMoveDescriptionIDOffset)
		}
	}
	
	var name : XGString {
		get {
			let table = XGFiles.original(.common_rel).stringTable
			return table.stringSafelyWithID(nameID)
		}
	}
	
	var type : XGMoveTypes {
		get {
			let index = XGFiles.original(.common_rel).data.getByteAtOffset(startOffset + kMoveTypeOffset)
			return XGMoveTypes(rawValue: index) ?? .normal
		}
	}
	
	var animation : Int {
		get {
			return XGFiles.original(.common_rel).data.get2BytesAtOffset(startOffset + kAnimationIndexOffset)
		}
	}
	
	var isShadowMove : Bool {
		get {
			return (self.index >= kFirstShadowMoveIndex) && (self.index <= kLastShadowMoveIndex)
		}
	}
	
	static func allMoves() -> [XGOriginalMoves] {
		var moves = [XGOriginalMoves]()
		for i in 0 ..< kNumberOfMoves {
			moves.append(.move(i))
		}
		return moves
	}
	
}

func allMoves() -> [String : XGMoves] {
	
	var dic = [String : XGMoves]()
	
	for i in 0 ..< kNumberOfMoves {
		
		let a = XGMoves.move(i)
		
		dic[a.name.string.simplified] = a
		
	}
	
	return dic
}

let moves = allMoves()

func move(_ name: String) -> XGMoves {
	if moves[name.simplified] == nil { print("couldn't find: " + name) }
	return moves[name.simplified] ?? .move(0)
}


func allMovesArray() -> [XGMoves] {
	var moves: [XGMoves] = []
	for i in 0 ..< kNumberOfMoves {
		moves.append(XGMoves.move(i))
	}
	return moves
}

func allOriginalMovesArray() -> [XGOriginalMoves] {
	
	var moves: [XGOriginalMoves] = []
	for i in 0 ..< kNumberOfMoves {
		moves.append(XGOriginalMoves.move(i))
	}
	return moves
	
}






























