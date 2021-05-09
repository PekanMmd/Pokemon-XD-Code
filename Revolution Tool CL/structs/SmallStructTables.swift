//
//  SmallStructTables.swift
//  GoD Tool
//
//  Created by Stars Momodu on 03/05/2021.
//

import Foundation

let iconsStruct = GoDStruct(name: "Pokemon Icons", format: [
	.word(name: "Male Face ID", description: "", type: .fsysFileIdentifier(fsysName: "menu_face")),
	.word(name: "Male Body ID", description: "", type: .fsysFileIdentifier(fsysName: "menu_pokemon")),
	.word(name: "Female Face ID", description: "", type: .fsysFileIdentifier(fsysName: "menu_face")),
	.word(name: "female Body ID", description: "", type: .fsysFileIdentifier(fsysName: "menu_pokemon"))
])

let iconsTable = CommonStructTable(file: .indexAndFsysName(region == .JP ? 6 : 0, "common"), properties: iconsStruct, documentByIndex: false)

let pokemonFacesStruct = GoDStruct(name: "Pokemon Faces", format: [
	.word(name: "Species", description: "", type: .pokemonID),
	.short(name: "Icons Index", description: "", type: .indexOfEntryInTable(table: iconsTable, nameProperty: nil)),
	.bitMask(name: "Forms", description: "Divide by 2 for form count, last bit is unknown but seems set for NFE pokemon?", length: .short, values: [
		(name: "Form Count", type: .uint, numberOfBits: 15, firstBitIndexLittleEndian: 1, mod: nil, div: nil),
		(name: "Has an Evolution", type: .bool, numberOfBits: 1, firstBitIndexLittleEndian: 0, mod: nil, div: nil),
	]),
])
let pokemonFacesTable = CommonStructTable(file: .indexAndFsysName(region == .JP ? 5 : 22, "common"), properties: pokemonFacesStruct) { (index, entry) -> String? in
	if let species: Int = entry.get("Species") {
		return XGPokemon.index(species).name.unformattedString
	}
	return nil
}

let pokemonBodiesStruct = GoDStruct(name: "Pokemon Bodies", format: [
	.word(name: "Species", description: "", type: .pokemonID),
	.short(name: "Icons Index", description: "", type: .indexOfEntryInTable(table: iconsTable, nameProperty: nil)),
	.short(name: "Forms Count", description: "", type: .uint),
	.array(name: "Unknowns", description: "", property:
		.byte(name: "", description: "", type: .uintHex), count: 4)
])
let pokemonBodiesTable = CommonStructTable(file: .indexAndFsysName(region == .JP ? 5 : 22, "common"), properties: pokemonBodiesStruct) { (index, entry) -> String? in
	if let species: Int = entry.get("Species") {
		return XGPokemon.index(species).name.unformattedString
	}
	return nil
}

let pokecouponShopStruct = GoDStruct(name: "Pokecoupon Rewards", format: [
	.short(name: "Coupon Price (in thousands)", description: "Multiply this by 1000 to get the price", type: .int),
	.short(name: "Pokemon or Item ID", description: "Meaning depends on the 'Is Pokemon' flag", type: .uintHex),
	.short(name: "Name ID", description: "", type: .msgID(file: nil)),
	.short(name: "Description ID", description: "", type: .msgID(file: nil)),
	.short(name: "Unknown ID", description: "", type: .uintHex),
	.bitArray(name: "Flags", description: "", bitFieldNames: ["Is Pokemon"])
])

let pokecouponShopTable = CommonStructTable(file: .indexAndFsysName(region == .JP ? 8 : 2, "common"), properties: pokecouponShopStruct)

let experienceStruct = GoDStruct(name: "Experience Table", format: [
	.word(name: "Experience For Level 0", description: "", type: .uint),
	.array(name: "Experience For Level", description: "", property:
		.word(name: "", description: "", type: .uint), count: 100),
])

let experienceTable = CommonStructTable(file: .indexAndFsysName(region == .JP ? 11 : 5, "common"), properties: experienceStruct) { (index, data) -> String? in
	return XGExpRate(rawValue: index)?.string ?? "Experience Rate \(index)"
}
