//
//  XGAbilities.swift
//  XG Tool
//
//  Created by The Steez on 01/06/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//

import Foundation

let kFirstAbilityNameID = 0xC1D
let kFirstAbilityDescriptionID = 0xCE5

let abilityListUpdated = XGFiles.dol.data.get4BytesAtOffset(kAbilitiesStartOffset + 8) != 0

let kNumberOfAbilities			= abilityListUpdated ? (0x3A8 / 8) : 0x4E
let kAbilityNameIDOffset		= abilityListUpdated ? 0 : 4
let kAbilityDescriptionIDOffset = abilityListUpdated ? 4 : 8
let kSizeOfAbilityEntry			= abilityListUpdated ? 8 : 12

let kAbilitiesStartOffset = 0x3FCC50

enum XGAbilities : XGDictionaryRepresentable {
	
	case ability(Int)
	
	var index : Int {
		get {
			switch self {
				case .ability(let i): return i
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
			return XGStringTable.common_rel().stringSafelyWithID(nameID)
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
			return XGStringTable.common_rel().stringSafelyWithID(descriptionID)
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
	if abilities[name.simplified] == nil { print("couldn't find: " + name) }
	return abilities[name.simplified] ?? .ability(0)
}





