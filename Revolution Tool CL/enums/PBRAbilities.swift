//
//  XGAbilities.swift
//  XG Tool
//
//  Created by StarsMmd on 01/06/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

let kFirstAbilityNameID = 0xbad
let kFirstAbilityDescriptionID = 0xc29

let kNumberOfAbilities			= 124

enum XGAbilities : XGDictionaryRepresentable {
	
	case ability(Int)
	
	var index : Int {
		get {
			switch self {
				case .ability(let i):
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
	
	static func allAbilities() -> [XGAbilities] {
		var abs = [XGAbilities]()
		for i in 0 ... kNumberOfAbilities {
			abs.append(.ability(i))
		}
		return abs
	}
	
	static func random() -> XGAbilities {
		let rand = Int(arc4random_uniform(UInt32(kNumberOfAbilities - 1))) + 1
		return XGAbilities.ability(rand)
	}
	
}

func allAbilities() -> [String : XGAbilities] {
	
	var dic = [String : XGAbilities]()
	
	for i in 0 ... kNumberOfAbilities {
		
		let a = XGAbilities.ability(i)
		
		dic[a.name.string.simplified] = a
		
	}
	
	return dic
}

let abilities = allAbilities()

func ability(_ name: String) -> XGAbilities {
	if abilities[name.simplified] == nil { printg("couldn't find: " + name) }
	return abilities[name.simplified] ?? .ability(0)
}





