//
//  XGMoves.swift
//  XG Tool
//
//  Created by StarsMmd on 01/06/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

let kFirstShadowMoveIndex	= game == .XD ? 0x164 : 0x164
let kLastShadowMoveIndex	= game == .XD ? 0x176 : 0x164

let shadowMovesUseHMFlag	= XGMove(index: kFirstShadowMoveIndex).HMFlag

enum XGMoves : CustomStringConvertible {
	
	case index(Int)
	
	var index : Int {
		get {
			switch self {
				case .index(let i):
					if i > CommonIndexes.NumberOfMoves.value || i < 0 {
						return 0
					}
					return i
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
			let safeIndex = index < kNumberOfMoves ? index : 0
			return CommonIndexes.Moves.startOffset + (safeIndex * kSizeOfMoveData)
		}
	}
	
	var nameID : Int {
		get {
			return Int(XGFiles.common_rel.data!.getWordAtOffset(startOffset + kMoveNameIDOffset))
		}
	}
	
	var name : XGString {
		get {
			return XGFiles.common_rel.stringTable.stringSafelyWithID(nameID)
		}
	}
	
	var descriptionID : Int {
		get {
			return Int(XGFiles.common_rel.data!.getWordAtOffset(startOffset + kMoveDescriptionIDOffset))
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
			let index = XGFiles.common_rel.data!.getByteAtOffset(startOffset + kMoveTypeOffset)
			return XGMoveTypes.index(index)
		}
	}
	
	var category : XGMoveCategories {
		get {
			let index = XGFiles.common_rel.data!.getByteAtOffset(startOffset + kMoveCategoryOffset)
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
	
	static func allMoves() -> [XGMoves] {
		var moves = [XGMoves]()
		for i in 0 ..< kNumberOfMoves {
			moves.append(.index(i))
		}
		return moves
	}
	
	static func random() -> XGMoves {
		var rand = 0
		while (XGMoves.index(rand).isShadowMove) || (XGMoves.index(rand).descriptionID == 0) || rand == 0 || rand == 355 {
			rand = Int.random(in: 1 ..< kNumberOfMoves)
		}
		return XGMoves.index(rand)
	}
	
	static func randomShadow() -> XGMoves {
		var rand = 0
		while (!XGMoves.index(rand).isShadowMove) || (XGMoves.index(rand).descriptionID == 0) || rand == 0 || rand == 355 {
			rand = Int.random(in: 1 ..< kNumberOfMoves)
		}
		return XGMoves.index(rand)
	}

	static func randomDamaging() -> XGMoves {
		var rand = XGMoves.random()
		while (rand.data.basePower == 0) || (rand.descriptionID == 0)  {
			rand = XGMoves.random()
		}
		return rand
	}
	
	static func randomMoveset(count: Int = 4) -> [XGMoves] {
		var set = [Int]()
		while set.count < count {
			if set.count == 0 {
				set.addUnique(XGMoves.randomDamaging().index)
			} else {
				set.addUnique(XGMoves.random().index)
			}
		}
		while set.count < 4 {
			set.append(0)
		}
		return set.map({ (i) -> XGMoves in
			return .index(i)
		})
	}
	
	static func randomShadowMoveset(count: Int = 4) -> [XGMoves] {
		var set = [Int]()
		while set.count < count {
			set.addUnique(XGMoves.randomShadow().index)
		}
		while set.count < 4 {
			set.append(0)
		}
		return set.map({ (i) -> XGMoves in
			return .index(i)
		})
	}
	
}


func allMoves() -> [String : XGMoves] {
	
	var dic = [String : XGMoves]()
	
	for i in 0 ..< kNumberOfMoves {
		
		let a = XGMoves.index(i)
		
		dic[a.name.string.simplified] = a
		
	}
	
	return dic
}

let moves = allMoves()

func move(_ name: String) -> XGMoves {
	if moves[name.simplified] == nil { printg("couldn't find: " + name) }
	return moves[name.simplified] ?? .index(0)
}


func allMovesArray() -> [XGMoves] {
	var moves: [XGMoves] = []
	for i in 0 ..< kNumberOfMoves {
		moves.append(XGMoves.index(i))
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
		self = .index(index)
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(self.index, forKey: .index)
		try container.encode(self.name.string, forKey: .name)
	}
}

extension XGMoves: XGEnumerable {
	var enumerableName: String {
		return name.string.spaceToLength(20)
	}
	
	var enumerableValue: String? {
		return index.string
	}
	
	static var className: String {
		return "Moves"
	}
	
	static var allValues: [XGMoves] {
		return XGMoves.allMoves()
	}
}


























