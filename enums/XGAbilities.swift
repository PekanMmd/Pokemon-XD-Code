//
//  XGAbilities.swift
//  XG Tool
//
//  Created by StarsMmd on 01/06/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

let abilityListUpdated = XGFiles.dol.data!.getWordAtOffset(kAbilitiesStartOffset + 8) != 0

let kNumberOfAbilities		= abilityListUpdated ? (0x3A8 / 8) : 0x4E
let kAbilityNameIDOffset		= abilityListUpdated ? 0 : 4
let kAbilityDescriptionIDOffset = abilityListUpdated ? 4 : 8
let kSizeOfAbilityEntry			= abilityListUpdated ? 8 : 12

var kAbilitiesStartOffset: Int = {
	if game == .XD {
		switch region {
		case .US: return 0x3FCC50
		case .EU: return 0x437530
		case .JP: return 0x3DA310
		case .OtherGame: return 0
		}
	} else {
		switch region {
		case .US: return 0x35C5E0
		case .EU: return 0x3A9688
		case .JP: return 0x348D20
		case .OtherGame: return 0
		}
	}
}()

enum XGAbilities {
	
	case index(Int)
	
	var index: Int {
		switch self {
		case .index(let i):
			if i > kNumberOfAbilities || i < 0 {
				return 0
			}
			return i
		}
	}
	
	var hex: String {
		return String(format: "0x%x",self.index)
	}
	
	var nameIDOffset: Int {
		return kAbilitiesStartOffset + (index * kSizeOfAbilityEntry) + kAbilityNameIDOffset
	}
	
	var nameID: Int {
		let dol = XGFiles.dol.data!
		return Int(dol.getWordAtOffset(nameIDOffset))
	}
	
	var name: XGString {
		return XGFiles.common_rel.stringTable.stringSafelyWithID(nameID)
	}
	
	var descriptionIDOffset: Int {
		return kAbilitiesStartOffset + (index * kSizeOfAbilityEntry) + kAbilityDescriptionIDOffset
	}
	
	var descriptionID: Int {
		let dol = XGFiles.dol.data!
		return Int(dol.getWordAtOffset(descriptionIDOffset))
	}
	
	var adescription: XGString {
		return XGFiles.common_rel.stringTable.stringSafelyWithID(descriptionID)
	}
	
	func replaceNameID(newID: Int) {
		if let dol = XGFiles.dol.data {
			dol.replace4BytesAtOffset(nameIDOffset, withBytes: newID)
			dol.save()
		}
	}
	
	func replaceDescriptionID(newID: Int) {
		if let dol = XGFiles.dol.data {
			dol.replace4BytesAtOffset(descriptionIDOffset, withBytes: newID)
			dol.save()
		}
	}
	
	static func random() -> XGAbilities {
		var rand = 0
		while (XGAbilities.index(rand).nameID == 0) || (XGAbilities.index(rand).name.string.length < 2) {
			rand = Int.random(in: 1 ..< kNumberOfAbilities)
		}
		return XGAbilities.index(rand)
	}
	
}

extension XGAbilities: Codable {
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

extension XGAbilities: XGEnumerable {
	var enumerableName: String {
		return name.string.spaceToLength(20)
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

extension XGAbilities: XGDocumentable {
	
	var documentableName: String {
		return name.string + "(\(index))"
	}
	
	static var DocumentableKeys: [String] {
		return ["index", "hex index", "name", "description"]
	}
	
	func documentableValue(for key: String) -> String {
		switch key {
		case "index":
			return index.string
		case "hex index":
			return index.hexString()
		case "name":
			return name.string
		case "description":
			return adescription.string
		default:
			return ""
		}
	}
}

func allAbilities() -> [String : XGAbilities] {
	var dic = [String : XGAbilities]()
	
	for i in 0 ..< kNumberOfAbilities {
		
		let a = XGAbilities.index(i)
		dic[a.name.string.simplified] = a
		
	}
	
	return dic
}

let abilities = allAbilities()

func ability(_ name: String) -> XGAbilities {
	if abilities[name.simplified] == nil { printg("couldn't find: " + name) }
	return abilities[name.simplified] ?? .index(0)
}





