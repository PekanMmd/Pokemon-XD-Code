//
//  XGAbilities.swift
//  XG Tool
//
//  Created by StarsMmd on 01/06/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

var kNumberOfAbilities: Int {
	return PBRAbilitiesManager.shared.entries?.count ?? 0
} // 124 in vanilla

enum XGAbilities : XGIndexedValue {
	
	case index(Int)
	
	var index : Int {
		switch self {
		case .index(let i):
			return i
		}
	}

	var data: PBRAbilityData? {
		return PBRAbilitiesManager.shared.getAbility(index)
	}
	
	var nameID : Int {
		return data?.nameStringID ?? 0
	}
	
	var name : XGString {
		get {
			return getStringSafelyWithID(id: nameID)
		}
	}
	
	var descriptionID : Int {
		return data?.descriptionStringID ?? 0
	}
	
	var adescription : XGString {
		get {
			return getStringSafelyWithID(id: descriptionID)
		}
	}
	
	static func allAbilities() -> [XGAbilities] {
		return (0 ..< kNumberOfAbilities).map { XGAbilities.index($0) }
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
		return allAbilities()
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





