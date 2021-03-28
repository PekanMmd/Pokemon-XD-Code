//
//  AbilitiesTable.swift
//  GoD Tool
//
//  Created by Stars Momodu on 26/03/2021.
//

import Foundation

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

var abilityListUpdated: Bool {
	return (XGFiles.dol.data?.getWordAtOffset(kAbilitiesStartOffset + 8) ?? 0) != 0
}

var kNumberOfAbilities: Int {
	return abilityListUpdated ? (0x3A8 / 8) : 0x4E
}

var abilityStruct: GoDStruct {
	var properties: [GoDStructProperties] = []
	if !abilityListUpdated {
		properties.append(.word(name: "Unused", description: "", type: .null))
	}
	properties += [
		.word(name: "Name ID", description: "", type: .msgID(file: .common_rel)),
		.word(name: "Description ID", description: "", type: .msgID(file: .common_rel))
	]
	return GoDStruct(name: "Ability", format: properties)
}

var abilitiesTable: GoDStructTable {
	return GoDStructTable(file: .dol, properties: abilityStruct) { (_) -> Int in
		return kAbilitiesStartOffset
	} numberOfEntriesInFile: { (_) -> Int in
		return kNumberOfAbilities
	}
}
