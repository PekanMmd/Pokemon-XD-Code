//
//  DeckStructTable.swift
//  GoD Tool
//
//  Created by Stars Momodu on 19/03/2021.
//

import Foundation

let trainerMessageStruct = GoDStruct(name: "Messages", format: [
	.word(name: "Variant 1", description: "", type: .msgID(file: nil)),
	.word(name: "Variant 2", description: "", type: .msgID(file: nil)),
	.word(name: "Variant 3", description: "", type: .msgID(file: nil)),
	.word(name: "Variant 4", description: "", type: .msgID(file: nil))
])

let trainerPokemonPoolStruct = GoDStruct(name: "Pokemon Pool Selector", format: [
	.byte(name: "Unknown Flag 1", description: "", type: .bool),
	.byte(name: "Unknown Flag 2", description: "", type: .bool),
	.byte(name: "Number of Pokemon", description: "", type: .uint),
	.short(name: "Pokemon Pool Start", description: "The first index in the pokemon deck to create this trainer's pool", type: .int),
	.short(name: "Pokemon Pool End", description: "The last index in the pokemon deck to create this trainer's pool", type: .int),
])

let trainerAppearanceStruct = GoDStruct(name: "Trainer Customisation", format: [
	.short(name: "Body", description: "", type: .trainerModelID),
	.byte(name: "Head", description: "", type: .int),
	.byte(name: "Hair", description: "", type: .int),
	.byte(name: "Face", description: "", type: .int),
	.byte(name: "Top", description: "", type: .int),
	.byte(name: "Bottom", description: "", type: .int),
	.byte(name: "Shoes", description: "", type: .int),
	.byte(name: "Hands", description: "", type: .int),
	.byte(name: "Bag", description: "", type: .int),
	.byte(name: "Glasses", description: "", type: .int),
	.byte(name: "Badge", description: "", type: .int),
])

let deckTrainerStruct = GoDStruct(name: "Trainer Deck", format: [
	.short(name: "Index", description: "", type: .uint),
	.short(name: "Battle Pass Background", description: "", type: .uint),
	.short(name: "Padding", description: "", type: .null),
	.short(name: "Name ID", description: "", type: .msgID(file: nil)),
	.short(name: "Padding 2", description: "", type: .null),
	.short(name: "Title", description: "", type: .msgID(file: nil)),
	.byte(name: "Unknown 3", description: "", type: .uint),
	.byte(name: "Unknown 4", description: "", type: .uint),
	.byte(name: "Unknown 5", description: "", type: .uint),
	.byte(name: "Unknown 6", description: "", type: .uint),
	.subStruct(name: "Appearance", description: "", property: trainerAppearanceStruct),
	.subStruct(name: "Before Battle", description: "", property: trainerMessageStruct),
	.subStruct(name: "Battle Start", description: "", property: trainerMessageStruct),
	.subStruct(name: "Defeated", description: "", property: trainerMessageStruct),
	.subStruct(name: "Victory", description: "", property: trainerMessageStruct),
	.bitMask(name: "Skin Tone", description: "", length: .char, values: [
		("Skin Tone", .skinTone, 2, 3, nil, nil, nil)
	]),
	.array(name: "Unknown value lists", description: "", property:
			.byte(name: "Unknown byte", description: "", type: .int),
		count: 3),
	.array(name: "Pokemon Themes", description: "4 values which create a theme for the team. Depending on how many are set and which ones are set to random or not they may affect the types of specific pokemon positions or all the pokemon in the party.",
		   property: .byte(name: "Theme", description: "", type: .typeID),
		count: 4),
	.array(name: "Pokemon Pools", description: "", property:
			.subStruct(name: "", description: "Pokemon Pool Selector", property: trainerPokemonPoolStruct),
		count: 4),
	.array(name: "Unknown values", description: "", property: .byte(name: "Unknown byte", description: "", type: .uint), count: 4),
	.short(name: "Singles AI", description: "Index of the AI entry in the AI deck", type: .uint),
	.short(name: "Doubles AI", description: "Index of the AI entry in the AI deck", type: .uint),
	.array(name: "Unknown values", description: "", property: .byte(name: "Unknown byte", description: "", type: .uint), count: 12)
])

let deckPokemonStruct = GoDStruct(name: "Pokemon Deck", format: [
	.short(name: "ID", description: "", type: .int),
	.bitArray(name: "Flags", description: "", bitFieldNames: [
		"unknown 1", "unknown 2", "unknown 3", "unknown 4",
		"Use second ability slot", "unknown 6", "unknown 7", "unknown 8",
		"unknown 9", "Use Random IVs", "Use random form", "Use Random Nature",
		"Use random gender", "unknown 14", "unknown 15", "unknown 16",
	]),
	.short(name: "Minimum Level", description: "", type: .int),
	.short(name: "Species", description: "", type: .pokemonID),
	.array(name: "Pokemon Types", description: "", property: .byte(name: "Type", description: "", type: .typeID), count: 2),
	.byte(name: "Pokeball", description: "The pokeball the pokemon was caught in", type: .itemID),
	.byte(name: "Gender", description: "", type: .genderID),
	.byte(name: "Nature", description: "", type: .natureID),
	.byte(name: "Forme ID", description: "The id for alternate forms for Deoxys, Burmy and Wormadam", type: .uint),
	.byte(name: "Average Rank", description: "", type: .int),
	.byte(name: "Unknown 4", description: "", type: .int),
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
	.short(name: "Unknown 5", description: "", type: .uint),
	.array(name: "Moves", description: "", property: .short(name: "Move", description: "", type: .moveID), count: 4),
	.array(name: "Items", description: "Potential items the pokemon may hold", property: .short(name: "Item", description: "", type: .itemID), count: 4),
	.byte(name: "Unknown 6", description: "", type: .uint),
	.word(name: "Unknown 7", description: "", type: .uint)
])

let deckAIStruct = GoDStruct(name: "AI Deck", format: [
	.array(name: "Parameters", description: "", property: .byte(name: "Unknown", description: "", type: .uint), count: 0x4),
	.array(name: "Parameters", description: "", property: .byte(name: "Unknown", description: "", type: .int), count: 0x20)
])

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
			let entryCount = numberOfEntries
			data.insertRepeatedByte(byte: 0, count: count * properties.length, atOffset: startOffsetForEntry(numberOfEntries - 1) + properties.length)
			data.replace4BytesAtOffset(4, withBytes: data.length)
			data.replace4BytesAtOffset(8, withBytes: entryCount + count)
			data.save()
		}
	}
}
