//
//  DeckStructTable.swift
//  GoD Tool
//
//  Created by Stars Momodu on 19/03/2021.
//

import Foundation

let deckTrainerStruct = GoDStruct(name: "Trainer Deck", format: [
	.short(name: "ID", description: "", type: .uint),
	.short(name: "Unknown", description: "", type: .uint),
	.short(name: "Padding", description: "", type: .null),
	.short(name: "Name ID", description: "", type: .msgID(file: nil)),
	.short(name: "Padding 2", description: "", type: .null),
	.short(name: "Unknown 2", description: "", type: .uint),
	.byte(name: "Unknown 3", description: "", type: .uint),
	.byte(name: "Unknown 4", description: "", type: .uint),
	.byte(name: "Unknown 5", description: "", type: .uint),
	.byte(name: "Unknown 6", description: "", type: .uint),
	.short(name: "Unknown 7", description: "", type: .uint),
	.byte(name: "Unknown 8", description: "", type: .uint),
	.byte(name: "Unknown 9", description: "", type: .uint),
	.byte(name: "Unknown 10", description: "", type: .uint),
	.array(name: "Unknowns", description: "types?", property: .byte(name: "", description: "", type: .uint), count: 2),
	.byte(name: "Unknown 11", description: "", type: .uint),
	.byte(name: "Unknown 12", description: "", type: .uint),
	.byte(name: "Unknown 13", description: "", type: .uint),
	.byte(name: "Unknown 14", description: "", type: .uint),
	.byte(name: "Unknown 15", description: "", type: .uint),
	.array(name: "Unknown lists", description: "", property:
			.array(name: "Unknowns", description: "", property:
					.word(name: "Unknown word", description: "", type: .uint), count: 4), count: 4),
	.array(name: "Unknown value lists", description: "", property:
			.array(name: "Unknown values", description: "", property:
					.byte(name: "Unknown byte", description: "", type: .int), count: 8), count: 2),
	.array(name: "Unknown values", description: "", property: .byte(name: "Unknown byte", description: "", type: .uint), count: 0x2c)
])

let deckPokemonStruct = GoDStruct(name: "Pokemon Deck", format: [
	.short(name: "ID", description: "", type: .int),
	.bitArray(name: "Flags", description: "The 12th flag determines if the pokemon uses its second ability id or not", bitFieldNames: [
		"unknown 1", "unknown 2", "unknown 3", "unknown 4",
		"Use second ability slot", "unknown 6", "unknown 7", "unknown 8",
		"unknown 9", "unknown 10", "unknown 11", "Unknown 12",
		"unknown 13", "unknown 14", "unknown 15", "unknown 16",
	]),
	.byte(name: "Unknown 1", description: "", type: .uint),
	.byte(name: "Minimum Level", description: "", type: .int),
	.short(name: "Species", description: "", type: .pokemonID),
	.array(name: "Pokemon Types", description: "", property: .byte(name: "Type", description: "", type: .typeID), count: 2),
	.byte(name: "Pokeball", description: "The pokeball the pokemon was caught in", type: .itemID),
	.byte(name: "Unknown 2", description: "", type: .uint),
	.byte(name: "Forme ID", description: "The id for alternate forms for Deoxys, Burmy and Wormadam", type: .int),
	.byte(name: "Unknown 3", description: "The rank this pokemon is used from", type: .int),
	.byte(name: "Minimum Rank", description: "", type: .int),
	.subStruct(name: "IVs", description: "", property: GoDStruct(name: "IV Values", format: [
		.byte(name: "HP", description: "", type: .uint),
		.byte(name: "Attack", description: "", type: .uint),
		.byte(name: "Defense", description: "", type: .uint),
		.byte(name: "Speed", description: "", type: .uint),
		.byte(name: "Sp.Atk", description: "", type: .uint),
		.byte(name: "Sp.Def", description: "", type: .uint),
	])),
	.subStruct(name: "EVs", description: "", property: GoDStruct(name: "EV Data", format: [
		.short(name: "EV Total", description: "The total number of EVs to distribute", type: .int),
		.subStruct(name: "EV Ratios", description: "The EV total is divided into each stat by these relative proportions", property: GoDStruct(name: "EVs", format: [
			.byte(name: "HP", description: "", type: .uint),
			.byte(name: "Attack", description: "", type: .uint),
			.byte(name: "Defense", description: "", type: .uint),
			.byte(name: "Speed", description: "", type: .uint),
			.byte(name: "Sp.Atk", description: "", type: .uint),
			.byte(name: "Sp.Def", description: "", type: .uint),
		]))
	])),
	.short(name: "Unknown 4", description: "", type: .uint),
	.array(name: "Moves", description: "", property: .short(name: "Move", description: "", type: .moveID), count: 4),
	.array(name: "Items", description: "Potential items the pokemon may hold", property: .short(name: "Item", description: "", type: .itemID), count: 4),
	.word(name: "Unknown 5", description: "", type: .uint),
	.word(name: "Unknown 6", description: "", type: .uint)
])

let deckAIStruct = GoDStruct(name: "AI Deck", format: [])

class DeckStructTable: GoDStructTableFormattable {
	let file: XGFiles
	let properties: GoDStruct
	let startOffsetForFirstEntryInFile: ((XGFiles) -> Int)
	let numberOfEntriesInFile: ((XGFiles) -> Int)
	var nameForEntry: ((Int, GoDStructData) -> String?)?

	let canExpand = true

	var fileVaries: Bool {
		return true
	}

	init(file: XGFiles) {
		self.file = file

		startOffsetForFirstEntryInFile = { (file) in
			return 0x10
		}
		numberOfEntriesInFile = { (file) in
			return file.data?.get4BytesAtOffset(8) ?? 0
		}

		self.nameForEntry = { (index, data) -> String? in
			data.valueForPropertyWithName("Species")?.description
		}

		switch file.fileType {
		case .dckt: properties = deckTrainerStruct
		case .dckp: properties = deckPokemonStruct
		case .dcka: properties = deckAIStruct
		default: properties = GoDStruct(name: "Dummy", format: [])
		}
	}

	func addEntries(count: Int) {
		if let data = file.data {
			data.insertRepeatedByte(byte: 0, count: count * properties.length, atOffset: startOffsetForEntry(numberOfEntries - 1) + properties.length)
			data.save()
		}
	}
}
