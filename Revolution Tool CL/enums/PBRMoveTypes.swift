//
//  MoveTypes.swift
//  Mausoleum Move Tool
//
//  Created by StarsMmd on 28/12/2014.
//  Copyright (c) 2014 StarsMmd. All rights reserved.
//

import Foundation

enum XGMoveTypes : XGIndexedValue {
	
	case index(Int)
	
	var index : Int {
		switch self {
			case .index(let i): return i
		}
	}
	
	var rawValue : Int {
		return self.index
	}
	
	var name : String {
		get {
			return data.name.unformattedString
		}
	}
	
	var data : XGType {
		return XGType(index: index)
	}

	var category: XGMoveCategories {
		return .none
	}
	
	static var allTypes : [XGMoveTypes] {
		get {
			var t = [XGMoveTypes]()
			for i in 0 ..< kNumberOfTypes {
				t.append(XGMoveTypes.index(i))
			}
			return t
		}
	}
	
	static func random() -> XGMoveTypes {
		let rand = Int.random(in: 0 ..< kNumberOfTypes)
		return XGMoveTypes.index(rand)
	}
	
	static var normal: XGMoveTypes {
		return .index(0)
	}
	static var fighting: XGMoveTypes {
		return .index(1)
	}
	static var flying: XGMoveTypes {
		return .index(2)
	}
	static var poison: XGMoveTypes {
		return .index(3)
	}
	static var ground: XGMoveTypes {
		return .index(4)
	}
	static var rock: XGMoveTypes {
		return .index(5)
	}
	static var bug: XGMoveTypes {
		return .index(6)
	}
	static var ghost: XGMoveTypes {
		return .index(7)
	}
	static var steel: XGMoveTypes {
		return .index(8)
	}
	static var none: XGMoveTypes {
		return .index(9)
	}
	static var fire: XGMoveTypes {
		return .index(10)
	}
	static var water: XGMoveTypes {
		return .index(11)
	}
	static var grass: XGMoveTypes {
		return .index(12)
	}
	static var electric: XGMoveTypes {
		return .index(13)
	}
	static var psychic: XGMoveTypes {
		return .index(14)
	}
	static var ice: XGMoveTypes {
		return .index(15)
	}
	static var dragon: XGMoveTypes {
		return .index(16)
	}
	static var dark: XGMoveTypes {
		return .index(17)
	}
	
}

extension XGMoveTypes: XGEnumerable {
	var enumerableName: String {
		return data.name.unformattedString
	}
	
	var enumerableValue: String? {
		return rawValue.string
	}
	
	static var className: String {
		return "Types"
	}
	
	static var allValues: [XGMoveTypes] {
		return allTypes
	}
}







