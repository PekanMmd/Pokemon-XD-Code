//
//  XGAbilities.swift
//  XG Tool
//
//  Created by StarsMmd on 01/06/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

let kFirstAbilityNameID = 0xbae
let kFirstAbilityDescriptionID = 0xc2a

let kNumberOfAbilities	= 124

enum XGAbilities : XGIndexedValue {
	
	case index(Int)
	
	var index : Int {
		get {
			switch self {
				case .index(let i):
					if i >= kNumberOfAbilities || i < 0 {
						return 0
					}
					return i
			}
		}
	}
	
	
	var nameID : Int {
		get {
			return self.index + kFirstAbilityNameID
		}
	}
	
	var name : XGString {
		get {
			return getStringSafelyWithID(id: nameID)
		}
	}
	
	var descriptionID : Int {
		get {
			return self.index + kFirstAbilityDescriptionID
		}
	}
	
	var adescription : XGString {
		get {
			return getStringSafelyWithID(id: descriptionID)
		}
	}
	
	static func allAbilities() -> [XGAbilities] {
		var abs = [XGAbilities]()
		for i in 0 ..< kNumberOfAbilities {
			abs.append(.index(i))
		}
		return abs
	}
	
	static func random() -> XGAbilities {
		let rand = Int.random(in: 1 ..< kNumberOfAbilities)
		return XGAbilities.index(rand)
	}
	
}

extension XGAbilities: XGEnumerable {
	var enumerableName: String {
		return name.unformattedString
	}
	
	var enumerableValue: String? {
		return index.string
	}
	
	static var className: String {
		return "Abilities"
	}
	
	static var allValues: [XGAbilities] {
		var values = [XGAbilities]()
		
		for i in 0 ..< kNumberOfAbilities {
			values.append(.index(i))
		}
		
		return values
	}
}

func allAbilities() -> [String : XGAbilities] {
	
	var dic = [String : XGAbilities]()
	
	for i in 0 ..< kNumberOfAbilities {
		
		let a = XGAbilities.index(i)
		
		dic[a.name.unformattedString.simplified] = a
		
	}
	
	return dic
}

let abilities = allAbilities()

func ability(_ name: String) -> XGAbilities {
	if abilities[name.simplified] == nil { printg("couldn't find: " + name) }
	return abilities[name.simplified] ?? .index(0)
}





