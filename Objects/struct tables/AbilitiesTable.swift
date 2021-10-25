//
//  AbilitiesTable.swift
//  GoD Tool
//
//  Created by Stars Momodu on 26/03/2021.
//

import Foundation

var abilityStruct: GoDStruct {
	var properties: [GoDStructProperties] = []
	if kSizeOfAbilityEntry == 12 {
		properties.append(.word(name: "Unused", description: "", type: .null))
	}
	properties += [
		.word(name: "Name ID", description: "", type: .msgID(file: .common_rel)),
		.word(name: "Description ID", description: "", type: .msgID(file: .common_rel))
	]
	return GoDStruct(name: "Ability", format: properties)
}

var abilitiesTable: GoDStructTable {
	return GoDStructTable(file: abilitiesDataFile, properties: abilityStruct, documentByIndex: false) { (file) -> Int in
		let offset = file == .common_rel ? kRELtoRAMOffsetDifference : kDolTableToRAMOffsetDifference
		return kAbilitiesStartRAMOffset - offset
	} numberOfEntriesInFile: { (_) -> Int in
		return kNumberOfAbilities
	} canExpand: { (file) -> Bool in
		return game == .XD && region == .US && kSizeOfAbilityEntry == 12
	} addEntries: { (count) in
		XGAssembly.reduceSizeOfAbilityData()
	}
}
