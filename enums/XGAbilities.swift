//
//  XGAbilities.swift
//  XG Tool
//
//  Created by StarsMmd on 01/06/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

let kAbilityNameIDOffset		= kSizeOfAbilityEntry == 8 ? 0 : 4
let kAbilityDescriptionIDOffset = kSizeOfAbilityEntry == 8 ? 4 : 8

var kSizeOfAbilityEntry: Int {
	return XGFiles.dol.data?.get2BytesAtOffset(abilityDataFunctionOffset + 26) ?? 0
}

var abilityDataFunctionOffset: Int {
	// In Start.dol
	if game == .XD {
		switch region {
		case .US: return 0x1411f8
		case .EU: return 0x142abc
		case .JP: return 0x13c5a8
		case .OtherGame: return -1
		}
	} else {
		switch region {
		case .US: return 0x119b6c
		case .EU: return 0x11db48
		case .JP: return 0x117354
		case .OtherGame: return -1
		}
	}
}

var numberOfAbilitiesOffset: Int {
	if game == .XD {
		switch region {
		case .US: return 0x41db38
		case .EU: return 0x458538
		case .JP: return 0x3fb1d0
		case .OtherGame: return -1
		}
	} else {
		switch region {
		case .US: return 0x397a28
		case .EU: return 0x3e4ec8
		case .JP: return 0x384198
		case .OtherGame: return -1
		}
	}
}

var kAbilitiesStartRAMOffset: Int = {
	guard let offsetPart1 = XGFiles.dol.data?.get2BytesAtOffset(abilityDataFunctionOffset + 30),
		  let offsetPart2 = XGFiles.dol.data?.get2BytesAtOffset(abilityDataFunctionOffset + 34) else {
		return -1
	}
	let p1 = (offsetPart1 & 0xFFF) << 16
	let p2 = UInt16(offsetPart2).signed()
	return p1 + p2
	// default offsets in start.dol
//	if game == .XD {
//		switch region {
//		case .US: return 0x3FCC50
//		case .EU: return 0x437530
//		case .JP: return 0x3DA310
//		case .OtherGame: return 0
//		}
//	} else {
//		switch region {
//		case .US: return 0x35C5E0
//		case .EU: return 0x3A9688
//		case .JP: return 0x348D20
//		case .OtherGame: return 0
//		}
//	}
}()

var abilitiesDataFile: XGFiles {
	return kAbilitiesStartRAMOffset < XGFiles.dol.fileSize + kDolTableToRAMOffsetDifference ? XGFiles.dol : XGFiles.common_rel
}

var kNumberOfAbilities: Int {
	guard region != .OtherGame else { return 0 }
	return XGFiles.dol.data?.get4BytesAtOffset(numberOfAbilitiesOffset) ?? 0
}

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
		let abilityFileOffset = abilitiesDataFile == .dol ? kDolTableToRAMOffsetDifference : kRELtoRAMOffsetDifference
		return kAbilitiesStartRAMOffset - abilityFileOffset + (index * kSizeOfAbilityEntry) + kAbilityNameIDOffset
	}
	
	var nameID: Int {
		return abilitiesDataFile.data?.get4BytesAtOffset(nameIDOffset) ?? 0
	}
	
	var name: XGString {
		return XGFiles.common_rel.stringTable.stringSafelyWithID(nameID)
	}
	
	var descriptionIDOffset: Int {
		let abilityFileOffset = abilitiesDataFile == .dol ? kDolTableToRAMOffsetDifference : kRELtoRAMOffsetDifference
		return kAbilitiesStartRAMOffset - abilityFileOffset + (index * kSizeOfAbilityEntry) + kAbilityDescriptionIDOffset
	}
	
	var descriptionID: Int {
		return abilitiesDataFile.data?.get4BytesAtOffset(descriptionIDOffset) ?? 0
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

	static func setNumberOfAbilities(to: Int) {
		if let dol = XGFiles.dol.data {
			dol.replace4BytesAtOffset(numberOfAbilitiesOffset, withBytes: to)
			dol.save()
		}
	}

	static func setAbilitiesDataTableRAMOffset(to offset: UInt32) {
		if game != .XD || region != .US {
			guard offset.int < XGFiles.dol.fileSize + kDolTableToRAMOffsetDifference else {
				printg("Couldn't set abilities RAM offset to be outside of Start.dol in RAM")
				return
			}
		}
		let (i1, i2) = XGASM.loadImmediateShifted32bit(register: .r3, value: offset, moveToRegister: .r0)
		XGAssembly.replaceASM(startOffset: abilityDataFunctionOffset + 28, newASM: [i1, i2])
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
	if XGSettings.current.verbose && (abilities[name.simplified] == nil) { printg("couldn't find: " + name) }
	return abilities[name.simplified] ?? .index(0)
}





