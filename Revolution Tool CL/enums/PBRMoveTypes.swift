//
//  MoveTypes.swift
//  Mausoleum Move Tool
//
//  Created by StarsMmd on 28/12/2014.
//  Copyright (c) 2014 StarsMmd. All rights reserved.
//

import Foundation

enum XGMoveTypes : XGIndexedValue {
	
	case type(Int)
	
	var index : Int {
		switch self {
			case .type(let i): return i
		}
	}
	
	var rawValue : Int {
		return self.index
	}
	
	var name : String {
		get {
			return data.name.string
		}
	}
	
	var data : XGType {
		return XGType(index: index)
	}
	
	static var allTypes : [XGMoveTypes] {
		get {
			var t = [XGMoveTypes]()
			for i in 0 ..< kNumberOfTypes {
				t.append(XGMoveTypes.type(i))
			}
			return t
		}
	}
	
	static func random() -> XGMoveTypes {
		let rand = Int(arc4random_uniform(UInt32(kNumberOfTypes)))
		return XGMoveTypes.type(rand)
	}
	
	static var normal: XGMoveTypes {
		return .type(0)
	}
	static var fighting: XGMoveTypes {
		return .type(1)
	}
	static var flying: XGMoveTypes {
		return .type(2)
	}
	static var poison: XGMoveTypes {
		return .type(3)
	}
	static var ground: XGMoveTypes {
		return .type(4)
	}
	static var rock: XGMoveTypes {
		return .type(5)
	}
	static var bug: XGMoveTypes {
		return .type(6)
	}
	static var ghost: XGMoveTypes {
		return .type(7)
	}
	static var steel: XGMoveTypes {
		return .type(8)
	}
	static var none: XGMoveTypes {
		return .type(9)
	}
	static var fire: XGMoveTypes {
		return .type(10)
	}
	static var water: XGMoveTypes {
		return .type(11)
	}
	static var grass: XGMoveTypes {
		return .type(12)
	}
	static var electric: XGMoveTypes {
		return .type(13)
	}
	static var psychic: XGMoveTypes {
		return .type(14)
	}
	static var ice: XGMoveTypes {
		return .type(15)
	}
	static var dragon: XGMoveTypes {
		return .type(16)
	}
	static var dark: XGMoveTypes {
		return .type(17)
	}
	
}

extension XGMoveTypes: XGEnumerable {
	var enumerableName: String {
		return data.name.unformattedString
	}
	
	var enumerableValue: String? {
		return rawValue.string
	}
	
	static var enumerableClassName: String {
		return "Types"
	}
	
	static var allValues: [XGMoveTypes] {
		return allTypes
	}
}







