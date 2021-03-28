//
//  TypesTable.swift
//  GoD Tool
//
//  Created by Stars Momodu on 26/03/2021.
//

import Foundation

#if GAME_XD
let typeMatchups = (0 ..< 18).map { (i) -> GoDStructProperties in
	return .short(name: "Effectiveness against Type \(i)", description: "", type: .typeEffectiveness)
}

let typeStruct = GoDStruct(name: "Type", format: [
	.byte(name: "Category", description: "Physical or Special", type: .moveCategory),
	.short(name: "Large Icon Image ID", description: "", type: .indexOfEntryInTable(table: texturesTable, nameProperty: nil)),
	.short(name: "Small Icon Image ID", description: "", type: .indexOfEntryInTable(table: texturesTable, nameProperty: nil)),
	.word(name: "Name ID", description: "", type: .msgID(file: .common_rel))
] + typeMatchups)

let typesTable = CommonStructTable(index: .Types, properties: typeStruct)
#else
let typeMatchups = (0 ..< 18).map { (i) -> GoDStructProperties in
	return .short(name: "Effectiveness against Type \(i)", description: "", type: .typeEffectiveness)
}

let typeStruct = GoDStruct(name: "Type", format: [
	.byte(name: "Category", description: "Physical or Special", type: .moveCategory),
	.short(name: "Icon Image ID", description: "", type: .indexOfEntryInTable(table: texturesTable, nameProperty: nil)),
	.word(name: "Name ID", description: "", type: .msgID(file: .common_rel))
] + typeMatchups)

let typesTable = GoDStructTable(file: .dol, properties: typeStruct) { (_) -> Int in
	return kFirstTypeOffset
} numberOfEntriesInFile: { (_) -> Int in
	return 18
}
#endif
