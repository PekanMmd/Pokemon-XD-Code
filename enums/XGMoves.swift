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

enum XGMoves: CustomStringConvertible, Equatable {
	
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
		let discludedMoves = [0, 355, game == .Colosseum ? 357 : 374]
		while (XGMoves.index(rand).isShadowMove) || (XGMoves.index(rand).descriptionID == 0) || discludedMoves.contains(rand) {
			rand = Int.random(in: 1 ..< kNumberOfMoves)
		}
		return XGMoves.index(rand)
	}
	
	static func randomShadow() -> XGMoves {
		var rand = 0
		let discludedMoves = [0, 355, game == .Colosseum ? 357 : 374]
		while (!XGMoves.index(rand).isShadowMove) || (XGMoves.index(rand).descriptionID == 0) || discludedMoves.contains(rand) {
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
	if XGSettings.current.verbose && (moves[name.simplified] == nil) { printg("couldn't find: " + name) }
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

enum XGMewTutorMoveSlot {
	case move(XGMoves)
	case any
	case physical
	case special
	case offensive
	case consistent
	case inconsistent
	case risky
	case invalid(id: Int)
	
	var string: String {
		switch self {
		case .move(let move):
			return move.name.string
		case .any:
			return "ANY"
		case .physical:
			return "PHYSICAL"
		case .special:
			return "SPECIAL"
		case .offensive:
			return "OFFENSIVE"
		case .consistent:
			return "CONSISTENT"
		case .inconsistent:
			return "INCONSISTENT"
		case .risky:
			return "RISKY"
		case .invalid(let id):
			return "INVALID_\(id.hexString())"
		}
	}
	
	static func from(index: Int) -> XGMewTutorMoveSlot {
		guard index < 0x8000 else {
			switch index {
			case 0x8001:
				return .risky
			case 0x8002:
				return .consistent
			case 0x8004:
				return .special
			case 0x8008:
				return .physical
			case 0x800C:
				return .offensive
			case 0x800F:
				return .any
			case 0x8102:
				return .inconsistent
			default:
				return .invalid(id: index)
			}
		}
		
		return .move(.index(index))
	}
}

struct XGMewTutorMoveFlags {
	let physical: Bool
	let special: Bool
	let consistent: Bool
	let punch: Bool
	
	var string: String {
		guard physical || special || consistent || punch else {
			return "NONE"
		}
		var flags = [String]()
		if physical { flags.append("PHYS")}
		if special { flags.append("SPEC")}
		if consistent { flags.append("CONS")}
		if punch { flags.append("PUNCH")}
		return flags.joined(separator: "|")
	}
	
	init(physical: Bool, special: Bool, consistent: Bool, punch: Bool) {
		self.physical = physical
		self.special = special
		self.consistent = consistent
		self.punch = punch
	}
	
	static func from(id: Int) -> XGMewTutorMoveFlags {
		return .init(
			physical: (id & 0x8).boolean,
			special: (id & 0x4).boolean,
			consistent: (id & 0x2).boolean,
			punch: (id & 0x1).boolean
		)
	}
}
























