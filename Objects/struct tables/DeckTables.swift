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

	let canExpand = true

	private let deck: XGDecks

	init(deck: XGDecks) {
		file = deck.file
		self.deck = deck
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
			.array(name: "Combo IDs", description: "", property:
				.short(name: "Combo ID", description: "", type: .uintHex), count: 4),
			.array(name: "Active Combos", description: "", property:
				.byte(name: "Combo", description: "", type: .uintHex), count: 4)
		])
	}

	func addEntries(count: Int) {
		deck.addTrainerEntries(count: count)
	}
}

class DeckPokemonStructTable: GoDStructTableFormattable {
	var file: XGFiles
	var properties: GoDStruct
	var startOffsetForFirstEntryInFile: ((XGFiles) -> Int)
	var numberOfEntriesInFile: ((XGFiles) -> Int)
	var nameForEntry: ((Int, GoDStructData) -> String?)?
	var fileVaries: Bool = true

	let canExpand = true

	private let deck: XGDecks

	init(deck: XGDecks) {
		file = deck.file
		self.deck = deck
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
				.bitArray(name: "Combo Partner", description: "Which pokemon should be used as a combo", bitFieldNames: [
					"Can Fill Combo A Role 1",
					"Can Fill Combo A Role 2",
					"Can Fill Combo B Role 1",
					"Can Fill Combo B Role 2",
					nil,
					nil,
					nil,
					nil
				]),
			] : [
				.byte(name: "Unused", description: "", type: .null),
				.bitArray(name: "Combo Partner", description: "Which pokemon should be used as a combo", bitFieldNames: [
					"Can Fill Combo A Role 1",
					"Can Fill Combo A Role 2",
					"Can Fill Combo B Role 1",
					"Can Fill Combo B Role 2",
					nil,
					nil,
					nil,
					nil
				]),
				.bitMask(name: "Mini PID", description: "", length: .char, values: [
					(name: "Use species second ability", type: .bool, numberOfBits: 1, firstBitIndexLittleEndian: 0, mod: nil, div: nil, scale: nil),
					(name: "Gender", type: .genderID, numberOfBits: 2, firstBitIndexLittleEndian: 1, mod: nil, div: nil, scale: nil),
					(name: "Nature", type: .natureID, numberOfBits: 5, firstBitIndexLittleEndian: 3, mod: nil, div: nil, scale: nil),
				]),
				.bitMask(name: "Settings", description: "", length: .char, values: [
					(name: "Use Random Nature and Gender", type: .bool, numberOfBits: 1, firstBitIndexLittleEndian: 7, mod: nil, div: nil, scale: nil)
				]),
				.byte(name: "Use Random Nature and Gender", description: "", type: .bool)
			]

		properties = GoDStruct(name: "Trainer Pokemon", format: [
			.short(name: "Species", description: "", type: .pokemonID),
			.byte(name: "Level", description: "", type: .uint),
			.byte(name: "Happiness", description: "", type: .uint),
			.short(name: "Item", description: "", type: .itemID),
			.byte(name: "AI Role", description: "", type: .indexOfEntryInTable(table: pokemonAIRolesTable, nameProperty: nil)),
			.byte(name: "Is Key Strategic Pokemon", description: "", type: .uint),
			.subStruct(name: "IVs", description: "", property: statsStructByte),
			.subStruct(name: "EVs", description: "", property: statsStructByte),
			.array(name: "Moves", description: "", property:
				.short(name: "Move", description: "", type: .moveID), count: 4),
		] + propertiesEnding)
	}

	func addEntries(count: Int) {
		deck.addPokemonEntries(count: count)
	}
}

let trainerAIStruct = GoDStruct(name: "Trainer AI", format: [
	.bitMask(name: "Pokemon Selection Flags", description: "", length: .char, values: [
		(name: "Randomly selects next pokemon", type: .bool, numberOfBits: 1, firstBitIndexLittleEndian: 7, mod: nil, div: nil, scale: nil),
		(name: "Avoids pokemon with same weaknesses", type: .bool, numberOfBits: 1, firstBitIndexLittleEndian: 6, mod: nil, div: nil, scale: nil),
		(name: "Sends pokemon out in order", type: .bool, numberOfBits: 1, firstBitIndexLittleEndian: 5, mod: nil, div: nil, scale: nil),
		(name: "Sends boss pokemon out last", type: .bool, numberOfBits: 1, firstBitIndexLittleEndian: 4, mod: nil, div: nil, scale: nil),
		(name: "Factors in ace pokemon flag", type: .bool, numberOfBits: 1, firstBitIndexLittleEndian: 3, mod: nil, div: nil, scale: nil),
		(name: "Factors in types", type: .bool, numberOfBits: 1, firstBitIndexLittleEndian: 2, mod: nil, div: nil, scale: nil),
		(name: "Factors in abilities", type: .bool, numberOfBits: 1, firstBitIndexLittleEndian: 1, mod: nil, div: nil, scale: nil),
		(name: "Factors in damage calc", type: .bool, numberOfBits: 1, firstBitIndexLittleEndian: 0, mod: nil, div: nil, scale: nil)
	]),
	.bitMask(name: "Move Selection Flags", description: "", length: .char, values: [
		(name: "Selects random defence", type: .bool, numberOfBits: 1, firstBitIndexLittleEndian: 7, mod: nil, div: nil, scale: nil),
		(name: "Selects moves randomly", type: .bool, numberOfBits: 1, firstBitIndexLittleEndian: 6, mod: nil, div: nil, scale: nil),
		(name: "Factors in move weighting", type: .bool, numberOfBits: 1, firstBitIndexLittleEndian: 5, mod: nil, div: nil, scale: nil),
		(name: "Factors in pokemon role", type: .bool, numberOfBits: 1, firstBitIndexLittleEndian: 4, mod: nil, div: nil, scale: nil),
		(name: "Factors move accuracy", type: .bool, numberOfBits: 1, firstBitIndexLittleEndian: 3, mod: nil, div: nil, scale: nil),
		(name: "Factors in move's risk flag", type: .bool, numberOfBits: 1, firstBitIndexLittleEndian: 2, mod: nil, div: nil, scale: nil),
		(name: "Factors in pokemon's status conditions", type: .bool, numberOfBits: 1, firstBitIndexLittleEndian: 1, mod: nil, div: nil, scale: nil)
	]),
	.short(name: "Padding", description: "", type: .null),
	.bitMask(name: "Atk Stat Stages", description: "6 is neutral, 12 is +6, 0 is -6", length: .char, values: [
		(name: "Max Atk Stages", type: .shiftedInt(midPoint: 6), numberOfBits: 4, firstBitIndexLittleEndian: 4, mod: nil, div: nil, scale: nil),
		(name: "Min Atk Stages", type: .shiftedInt(midPoint: 6), numberOfBits: 4, firstBitIndexLittleEndian: 0, mod: nil, div: nil, scale: nil)
	]),
	.bitMask(name: "Def Stat Stages", description: "6 is neutral, 12 is +6, 0 is -6", length: .char, values: [
		(name: "Max Def Stages", type: .shiftedInt(midPoint: 6), numberOfBits: 4, firstBitIndexLittleEndian: 4, mod: nil, div: nil, scale: nil),
		(name: "Min Def Stages", type: .shiftedInt(midPoint: 6), numberOfBits: 4, firstBitIndexLittleEndian: 0, mod: nil, div: nil, scale: nil)
	]),
	.bitMask(name: "Sp.Atk Stat Stages", description: "6 is neutral, 12 is +6, 0 is -6", length: .char, values: [
		(name: "Max Sp.Atk Stages", type: .shiftedInt(midPoint: 6), numberOfBits: 4, firstBitIndexLittleEndian: 4, mod: nil, div: nil, scale: nil),
		(name: "Min Sp.Atk Stages", type: .shiftedInt(midPoint: 6), numberOfBits: 4, firstBitIndexLittleEndian: 0, mod: nil, div: nil, scale: nil)
	]),
	.bitMask(name: "Sp.Def Stat Stages", description: "6 is neutral, 12 is +6, 0 is -6", length: .char, values: [
		(name: "Max Sp.Def Stages", type: .shiftedInt(midPoint: 6), numberOfBits: 4, firstBitIndexLittleEndian: 4, mod: nil, div: nil, scale: nil),
		(name: "Min Sp.Def Stages", type: .shiftedInt(midPoint: 6), numberOfBits: 4, firstBitIndexLittleEndian: 0, mod: nil, div: nil, scale: nil)
	]),
	.bitMask(name: "Speed Stat Stages", description: "6 is neutral, 12 is +6, 0 is -6", length: .char, values: [
		(name: "Max Speed Stages", type: .shiftedInt(midPoint: 6), numberOfBits: 4, firstBitIndexLittleEndian: 4, mod: nil, div: nil, scale: nil),
		(name: "Min Speed Stages", type: .shiftedInt(midPoint: 6), numberOfBits: 4, firstBitIndexLittleEndian: 0, mod: nil, div: nil, scale: nil)
	]),
	.bitMask(name: "Accuracy Stat Stages", description: "6 is neutral, 12 is +6, 0 is -6 (unused)", length: .char, values: [
		(name: "Max Accuracy Stages", type: .shiftedInt(midPoint: 6), numberOfBits: 4, firstBitIndexLittleEndian: 4, mod: nil, div: nil, scale: nil),
		(name: "Min Accuracy Stages", type: .shiftedInt(midPoint: 6), numberOfBits: 4, firstBitIndexLittleEndian: 0, mod: nil, div: nil, scale: nil)
	]),
	.bitMask(name: "Evasion Stat Stages", description: "6 is neutral, 12 is +6, 0 is -6", length: .char, values: [
		(name: "Max Evasion Stages", type: .shiftedInt(midPoint: 6), numberOfBits: 4, firstBitIndexLittleEndian: 4, mod: nil, div: nil, scale: nil),
		(name: "Min Evasion Stages", type: .shiftedInt(midPoint: 6), numberOfBits: 4, firstBitIndexLittleEndian: 0, mod: nil, div: nil, scale: nil)
	]),
	.byte(name: "Padding", description: "", type: .null),
	.byte(name: "Max Stat stages", description: "", type: .shiftedInt(midPoint: 42)),
	.byte(name: "Min Stat stages", description: "", type: .shiftedInt(midPoint: 42)),
	.byte(name: "Switch rate", description: "", type: .percentage),
	.byte(name: "Item use rate", description: "", type: .percentage),
	.byte(name: "Attacking move rate", description: "", type: .percentage),
	.byte(name: "KO rate", description: "", type: .percentage),
	.byte(name: "Low HP rate", description: "", type: .percentage),
	.byte(name: "Last PP rate", description: "", type: .percentage),
	.byte(name: "Speciality pokemon type 1", description: "", type: .typeID),
	.byte(name: "Speciality pokemon type 2", description: "", type: .typeID),
	.byte(name: "Speciality pokemon type 1 rate", description: "", type: .percentage),
	.byte(name: "Speciality pokemon type 2 rate", description: "", type: .percentage),
	.short(name: "Speciality move type 1", description: "", type: .typeID),
	.short(name: "Speciality move type 2", description: "", type: .typeID),
	.byte(name: "Speciality move type 1 rate", description: "", type: .percentage),
	.byte(name: "Speciality move type 2 rate", description: "", type: .percentage),
	.byte(name: "Correction Value", description: "", type: .uint)
	
])

class DeckAIStructTable: GoDStructTableFormattable {
	var file: XGFiles
	var properties: GoDStruct
	var startOffsetForFirstEntryInFile: ((XGFiles) -> Int)
	var numberOfEntriesInFile: ((XGFiles) -> Int)
	var nameForEntry: ((Int, GoDStructData) -> String?)?
	var fileVaries: Bool = true

	let canExpand = true

	private let deck: XGDecks

	init(deck: XGDecks) {
		file = deck.file
		self.deck = deck
		startOffsetForFirstEntryInFile = { _ -> Int in
			return deck.DTAIDataOffset
		}
		numberOfEntriesInFile = { _ -> Int in
			return deck.DTAIEntries
		}
		
		

		properties = trainerAIStruct
	}

	func addEntries(count: Int) {
		deck.addAIEntries(count: count)
	}
}

let shadowPokemonStruct = GoDStruct(name: "Shadow Pokemon", format: [
	.byte(name: "Miror B weighting", description: "Determines how likely this pokemon is to appear when encountering Miror B. Set to 0 for it to never trigger nor appear with Miror B.", type: .uintHex),
	.byte(name: "Catch Rate", description: "Overrides the base catch rate for the species", type: .uint),
	.byte(name: "Level", description: "The level the shadow pokemon will be once caught", type: .uint),
	.bitArray(name: "Status Flags", description: "", bitFieldNames: [
		"Shadow ID Is Being Used",
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil
	]),
	.word(name: "Pokemon Index In Story Deck", description: "The ID in Deck Story for the pokemon that this shadow ID is attached to", type: .indexOfEntryInTable(table: DeckPokemonStructTable(deck: .DeckStory), nameProperty: "Species")),
	.short(name: "Heart Guage", description: "Determines how long it takes to purify the pokemon", type: .uint),
	.short(name: "Bonus Exp", description: "Set in game as exp accumulates", type: .null),
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
