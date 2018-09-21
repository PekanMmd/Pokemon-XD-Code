//
//  XGAbilities.swift
//  XG Tool
//
//  Created by StarsMmd on 01/06/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

let kFirstAbilityNameID = 0xC1D
let kFirstAbilityDescriptionID = 0xCE5

let abilityListUpdated = game == .Colosseum ? false : XGFiles.dol.data.get4BytesAtOffset(kAbilitiesStartOffset + 8) != 0

let kNumberOfAbilities			= abilityListUpdated ? (0x3A8 / 8) : 0x4E
let kAbilityNameIDOffset		= abilityListUpdated ? 0 : 4
let kAbilityDescriptionIDOffset = abilityListUpdated ? 4 : 8
let kSizeOfAbilityEntry			= abilityListUpdated ? 8 : 12

let kAbilitiesStartOffset = game == .XD ? 0x3FCC50 : (region == .JP ? 0x348D20 : 0x35C5E0)

enum XGAbilities : XGDictionaryRepresentable {
	
	case ability(Int)
	
	var index : Int {
		get {
			switch self {
				case .ability(let i):
					if i > kNumberOfAbilities || i < 0 {
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
	
	var nameIDOffset : Int {
		return kAbilitiesStartOffset + (index * kSizeOfAbilityEntry) + kAbilityNameIDOffset
	}
	
	var nameID : Int {
		get {
			let dol = XGFiles.dol.data
			return Int(dol.get4BytesAtOffset(nameIDOffset))
		}
	}
	
	var name : XGString {
		get {
			return XGFiles.common_rel.stringTable.stringSafelyWithID(nameID)
		}
	}
	
	var descriptionIDOffset : Int {
		return kAbilitiesStartOffset + (index * kSizeOfAbilityEntry) + kAbilityDescriptionIDOffset
	}
	
	var descriptionID : Int {
		get {
			let dol = XGFiles.dol.data
			return Int(dol.get4BytesAtOffset(descriptionIDOffset))
		}
	}
	
	var adescription : XGString {
		get {
			return XGFiles.common_rel.stringTable.stringSafelyWithID(descriptionID)
		}
	}
	
	func replaceNameID(newID: Int) {
		let dol = XGFiles.dol.data
		dol.replace4BytesAtOffset(nameIDOffset, withBytes: UInt32(newID))
		dol.save()
	}
	
	func replaceDescriptionID(newID: Int) {
		let dol = XGFiles.dol.data
		dol.replace4BytesAtOffset(descriptionIDOffset, withBytes: UInt32(newID))
		dol.save()
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
		for i in 0 ..< kNumberOfAbilities {
			abs.append(.ability(i))
		}
		return abs
	}
	
	static func random() -> XGAbilities {
		var rand = 0
		while (XGAbilities.ability(rand).nameID == 0) || (XGAbilities.ability(rand).name.string.length < 2) {
			rand = Int(arc4random_uniform(UInt32(kNumberOfAbilities - 1))) + 1
		}
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





