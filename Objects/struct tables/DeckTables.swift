//
//  DeckTables.swift
//  GoD Tool
//
//  Created by Stars Momodu on 26/03/2021.
//

import Foundation

class DeckTrainerStructTable: GoDStructTableFormattable {
	var file: XGFiles
	var properties: GoDStruct
	var startOffsetForFirstEntryInFile: ((XGFiles) -> Int)
	var numberOfEntriesInFile: ((XGFiles) -> Int)
	var nameForEntry: ((Int, GoDStructData) -> String?)?
	var fileVaries: Bool = true

	init(deck: XGDecks) {
		file = deck.file
		startOffsetForFirstEntryInFile = { _ -> Int in
			return deck.DTNRDataOffset
		}
		numberOfEntriesInFile = { _ -> Int in
			return deck.DTNREntries
		}

		properties = GoDStruct(name: "Trainer", format: [
			.pointer(property: .string(name: "ID String Pointer", description: "", maxCharacterCount: nil, charLength: .char),
					 offsetBy: deck.DSTRDataOffset, isShort: true),
			.short(name: "Padding", description: "", type: .null),
			.bitArray(name: "Shadow Flags", description: "Determines which of the trainer's pokemon ids are shadow ids, rather than ids of regular pokemon in the deck", bitFieldNames: [
				nil,
				nil,
				"Pokemon 6 is shadow id",
				"Pokemon 5 is shadow id",
				"Pokemon 4 is shadow id",
				"Pokemon 3 is shadow id",
				"Pokemon 2 is shadow id",
				"Pokemon 1 is shadow id",
			]),
			.byte(name: "Trainer Class ID", description: "", type: .trainerClassID),
			.short(name: "Name ID", description: "", type: .msgID(file: .common_rel)),
			.word(name: "Padding 2", description: "", type: .null),
			.word(name: "Padding 3", description: "", type: .null),
			.short(name: "Model ID", description: "", type: .pkxTrainerID),
			.short(name: "Camera Effect ID", description: "Used for characters who need a special camera motion for their intro", type: .uintHex),
			.short(name: "Pre Battle Text Id", description: "Text the trainer says before the battle", type: .msgID(file: .typeAndFsysName(.msg, "fight_common"))),
			.short(name: "Victory Text Id", description: "Text the trainer says if they win", type: .msgID(file: .typeAndFsysName(.msg, "fight_common"))),
			.short(name: "Loss Text Id", description: "Text the trainer says if they lose", type: .msgID(file: .typeAndFsysName(.msg, "fight_common"))),
			.short(name: "Padding 4", description: "", type: .null),
			.array(name: "Pokemon", description: "", property:
					.short(name: "Pokemon Index", description: "", type: .uintHex), count: 6),
			.short(name: "AI Index", description: "", type:
				.indexOfEntryInTable(table: DeckAIStructTable(deck: deck), nameProperty: nil)),
			.short(name: "Padding 4", description: "", type: .null),
			.array(name: "Unknown Values", description: "", property:
				.short(name: "", description: "", type: .uintHex), count: 4),
			.array(name: "Unknown Values 2", description: "", property:
				.byte(name: "", description: "", type: .uintHex), count: 4)
		])
	}
}

class DeckPokemonStructTable: GoDStructTableFormattable {
	var file: XGFiles
	var properties: GoDStruct
	var startOffsetForFirstEntryInFile: ((XGFiles) -> Int)
	var numberOfEntriesInFile: ((XGFiles) -> Int)
	var nameForEntry: ((Int, GoDStructData) -> String?)?
	var fileVaries: Bool = true

	init(deck: XGDecks) {
		file = deck.file
		startOffsetForFirstEntryInFile = { _ -> Int in
			return deck.DPKMDataOffset
		}
		numberOfEntriesInFile = { _ -> Int in
			return deck.DPKMEntries
		}

		nameForEntry = { (index, data) in
			if index == 0 {
				return "None"
			}
			if let monIndex: Int = data.get("Species") {
				return XGPokemon.index(monIndex).name.unformattedString
			}
			return "\(deck.rawValue) \(index)"
		}

		// Struct ending was modified for XG so check for that and choose the appropriate one
		let propertiesEnding: [GoDStructProperties] = isShinyAvailable ?
			[
				.short(name: "Shininess", description: "", type: .shininess),
				.bitMask(name: "Mini PID", description: "", length: .char, values: [
					(name: "Use species second ability", type: .bool, numberOfBits: 1, firstBitIndexLittleEndian: 0, mod: nil, div: nil, scale: nil),
					(name: "Gender", type: .genderID, numberOfBits: 2, firstBitIndexLittleEndian: 1, mod: nil, div: nil, scale: nil),
					(name: "Nature", type: .natureID, numberOfBits: 5, firstBitIndexLittleEndian: 3, mod: nil, div: nil, scale: nil),
				]),
				.byte(name: "Unknown 2", description: "", type: .uintHex),
			] : [
				.byte(name: "Unused", description: "", type: .null),
				.byte(name: "Unknown 2", description: "", type: .uintHex),
				.bitMask(name: "Mini PID", description: "", length: .char, values: [
					(name: "Use species second ability", type: .bool, numberOfBits: 1, firstBitIndexLittleEndian: 0, mod: nil, div: nil, scale: nil),
					(name: "Gender", type: .genderID, numberOfBits: 2, firstBitIndexLittleEndian: 1, mod: nil, div: nil, scale: nil),
					(name: "Nature", type: .natureID, numberOfBits: 5, firstBitIndexLittleEndian: 3, mod: nil, div: nil, scale: nil),
				]),
				.byte(name: "Use Random Nature and Gender", description: "", type: .bool)
			]

		properties = GoDStruct(name: "Trainer Pokemon", format: [
			.short(name: "Species", description: "", type: .pokemonID),
			.byte(name: "Level", description: "", type: .uint),
			.byte(name: "Happiness", description: "", type: .uint),
			.short(name: "Item", description: "", type: .itemID),
			.bitArray(name: "Unknown Flags", description: "", bitFieldNames: [
				"Unknown Flag 1",
				"Unknown Flag 2",
				"Unknown Flag 3",
				"Unknown Flag 4",
				"Unknown Flag 5",
				"Unknown Flag 6",
				"Unknown Flag 7",
				"Unknown Flag 8"
			]),
			.byte(name: "Unknown", description: "", type: .uintHex),
			.subStruct(name: "IVs", description: "", property: statsStructByte),
			.subStruct(name: "EVs", description: "", property: statsStructByte),
			.array(name: "Moves", description: "", property:
				.short(name: "Move", description: "", type: .moveID), count: 4),
		] + propertiesEnding)
	}
}

class DeckAIStructTable: GoDStructTableFormattable {
	var file: XGFiles
	var properties: GoDStruct
	var startOffsetForFirstEntryInFile: ((XGFiles) -> Int)
	var numberOfEntriesInFile: ((XGFiles) -> Int)
	var nameForEntry: ((Int, GoDStructData) -> String?)?
	var fileVaries: Bool = true

	init(deck: XGDecks) {
		file = deck.file
		startOffsetForFirstEntryInFile = { _ -> Int in
			return deck.DTAIDataOffset
		}
		numberOfEntriesInFile = { _ -> Int in
			return deck.DTAIEntries
		}

		properties = GoDStruct(name: "Trainer AI", format: [
			.array(name: "Unknown Values", description: "", property: .byte(name: "Unknown", description: "", type: .uintHex), count: 32)
		])
	}
}

let shadowPokemonStruct = GoDStruct(name: "Shadow Pokemon", format: [
	.byte(name: "Miror B weighting", description: "Determines how likely this pokemon is to appear when encountering Miror B. Set to 0 for it to never trigger nor appear with Miror B.", type: .uintHex),
	.byte(name: "Catch Rate", description: "Overrides the base catch rate for the species", type: .uint),
	.byte(name: "Shadow Boost Level", description: "The hidden level the pokemon has before you catch it", type: .uint),
	.bitArray(name: "Status Flags", description: "", bitFieldNames: [
		"Shadow ID Is Being Used",
		"Unknown Flag 2",
		"Unknown Flag 3",
		"Unknown Flag 4",
		"Unknown Flag 5",
		"Unknown Flag 6",
		"Unknown Flag 7",
		"Unknown Flag 8",
	]),
	.word(name: "Pokemon ID", description: "The ID in Deck Story for the pokemon that this shadow ID is attached to", type: .indexOfEntryInTable(table: DeckPokemonStructTable(deck: .DeckStory), nameProperty: "Species")),
	.short(name: "Heart Guage", description: "Determines how long it takes to purify the pokemon", type: .uint),
	.short(name: "Padding", description: "", type: .null),
	.array(name: "Shadow Moves", description: "", property:
		.short(name: "Move", description: "", type: .moveID), count: 4),
	.byte(name: "Aggression", description: "The lower the value, the more likely it is to enter reverse mode", type: .uintHex),
	.byte(name: "Flees When Player Loses", description: "Determines if the pokemon should go to Miror B even if the player lost the battle", type: .bool)
])

let shadowPokemonTable = GoDStructTable(file: XGDecks.DeckDarkPokemon.file, properties: shadowPokemonStruct) { (_) -> Int in
	return XGDecks.DeckDarkPokemon.DDPKDataOffset
} numberOfEntriesInFile: { (_) -> Int in
	return XGDecks.DeckDarkPokemon.DDPKEntries
}

