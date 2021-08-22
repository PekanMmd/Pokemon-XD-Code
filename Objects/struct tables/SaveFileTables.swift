//
//  SaveFileTables.swift
//  GoD Tool
//
//  Created by Stars Momodu on 11/04/2021.
//

import Foundation

class SaveFilePokemonStructTable: GoDStructTableFormattable {
	enum PokemonStorage {
		case party, pcBox(index: Int)
	}

	var file: XGFiles
	var properties: GoDStruct
	var storage: PokemonStorage
	var startOffsetForFirstEntryInFile: ((XGFiles) -> Int) {
		switch storage {
		case .party:
			return { (_) -> Int in
				return kSaveFilePartyPokemonStartOffset
			}
		case .pcBox(let index):
			return { (_) -> Int in
				return kSaveFilePCBoxesStartOffset + kSizeOfBoxHeader + (index * ((pokemonStruct.length * kNumberOfPokemonPerPCBox) + kSizeOfBoxHeader))
			}
		}
	}
	var numberOfEntriesInFile: ((XGFiles) -> Int) {
		switch storage {
		case .party: return {(XGFiles) -> Int in return kNumberOfPokemonPerParty }
		case .pcBox: return {(XGFiles) -> Int in return kNumberOfPokemonPerPCBox }
		}
	}
	var nameForEntry: ((Int, GoDStructData) -> String?)?
	var fileVaries: Bool = true

	init(file: XGFiles, storage: PokemonStorage) {
		self.file = file
		self.storage = storage

		nameForEntry = { (index, data) in
			let nameString: String? = data.get("Name")
			if let name = nameString, !name.isEmpty {
				return name
			}
			switch storage {
			case .party: return "Party Pokemon \(index)"
			case .pcBox(let boxIndex):return "PC Box \(boxIndex + 1) Pokemon \(index)"
			}
		}

		let structName: String
		switch storage {
		case .party: structName = "Party Pokemon"
		case .pcBox(let index): structName = "PC Box \(index + 1) Pokemon"
		}

		properties = GoDStruct(name: structName, format: pokemonStruct.format)
	}
}

let contestStatsStruct = GoDStruct(name: "Contest Stats", format: [
	.byte(name: "Cool", description: "", type: .uint),
	.byte(name: "Beauty", description: "", type: .uint),
	.byte(name: "Cute", description: "", type: .uint),
	.byte(name: "Smart", description: "", type: .uint),
	.byte(name: "Tough", description: "", type: .uint)
])

#if GAME_COLO
let pokemonMoveStruct = GoDStruct(name: "Pokemon Move", format: [
	.short(name: "Move", description: "", type: .moveID),
	.byte(name: "Remaining PP", description: "", type: .uint),
	.byte(name: "PP Ups Used", description: "", type: .uint)
])
let pokemonStruct = GoDStruct(name: "Pokemon", format: [
	.short(name: "Species", description: "", type: .pokemonID),
	.short(name: "Padding", description: "", type: .null),
	.bitMask(name: "PID Determinant Values", description: "", length: .word, values: [
		(name: "PID First 3 bytes", type: .uintHex, numberOfBits: 24, firstBitIndexLittleEndian: 8, mod: nil, div: nil, scale: nil),
		(name: "PID Gender Determinant", type: .uintHex, numberOfBits: 8, firstBitIndexLittleEndian: 0, mod: nil, div: 25, scale: nil),
		(name: "PID Nature", type: .natureID, numberOfBits: 32, firstBitIndexLittleEndian: 0, mod: 25, div: nil, scale: nil)
	]),
	.byte(name: "Game ID", description: "", type: .gameID),
	.byte(name: "Current Game Region", description: "", type: .regionID),
	.byte(name: "Original Game Region", description: "", type: .regionID),
	.byte(name: "Original Language", description: "", type: .languageID),
	.short(name: "Unknown 1", description: "unused?", type: .uintHex),
	.byte(name: "Level Met", description: "unused?", type: .uintHex),
	.byte(name: "Pokeball Caught In", description: "", type: .itemID),
	.byte(name: "Original Trainer Gender", description: "", type: .genderID),
	.array(name: "Unknown Values", description: "Unused?", property:
		.byte(name: "", description: "", type: .uint), count: 3),
	.bitMask(name: "OT SID and TID", description: "", length: .word, values: [
		(name: "Original Trainer SID", type: .uintHex, numberOfBits: 16, firstBitIndexLittleEndian: 16, mod: nil, div: nil, scale: nil),
		(name: "Original Trainer TID", type: .uintHex, numberOfBits: 16, firstBitIndexLittleEndian: 0, mod: nil, div: nil, scale: nil)
	]),
	.string(name: "Original Trainer Name", description: "", maxCharacterCount: 10, charLength: .short),
	.short(name: "Padding", description: "", type: .null),
	.string(name: "Name", description: "", maxCharacterCount: 10, charLength: .short),
	.short(name: "Padding 2", description: "", type: .null),
	.string(name: "Name 2", description: "", maxCharacterCount: 10, charLength: .short),
	.word(name: "Padding 3", description: "", type: .null),
	.word(name: "EXP", description: "", type: .uint),
	.byte(name: "Level", description: "", type: .uint),
	.short(name: "Unknown 3", description: "Unused?", type: .uintHex),
	.byte(name: "Unknown 4", description: "Unused?", type: .uintHex),
	.byte(name: "Status", description: "", type: .statusEffect),
	.short(name: "Unknown 5", description: "Unused?", type: .uintHex),
	.byte(name: "Unknown 6", description: "Unused?", type: .uintHex),
	.byte(name: "Sleep Turns Remaining", description: "", type: .int),
	.byte(name: "Unknown 7 ", description: "Unused?", type: .uintHex),
	.byte(name: "Bad Poison Turns", description: "", type: .int),
	.word(name: "Unknown 8", description: "Unused?", type: .uintHex),
	.word(name: "Unknown 9", description: "Unused?", type: .uintHex),
	.word(name: "Status Bit Field", description: "", type: .bitMask),
	.array(name: "Moves", description: "", property:
		.subStruct(name: "Pokemon Move", description: "", property: pokemonMoveStruct), count: 4),
	.short(name: "Held Item", description: "", type: .itemID),
	.short(name: "Current HP", description: "", type: .uint),
	.subStruct(name: "Stats", description: "", property: statsStructShort),
	.subStruct(name: "EVs", description: "", property: statsStructShort),
	.subStruct(name: "IVs", description: "", property: statsStructShort),
	.short(name: "Happiness", description: "", type: .uint),
	.subStruct(name: "Contest Stats", description: "", property: contestStatsStruct),
	.subStruct(name: "Contest Achievements", description: "", property: contestStatsStruct),
	.byte(name: "Contest Luster", description: "", type: .uint),
	.array(name: "Ribbons", description: "", property:
		.byte(name: "", description: "", type: .uint), count: 13),
	.byte(name: "Pokerus Status", description: "", type: .uint),
	.bitArray(name: "Flags", description: "", bitFieldNames: [
		"Is Egg",
		"Has Second Ability",
		"Is Bad Egg"
	]),
	.byte(name: "Unknown 10", description: "Unused?", type: .uintHex),
	.byte(name: "Unknown 11", description: "Unused?", type: .uintHex),
	.byte(name: "Unknown GC Flags", description: "", type: .bitMask),
	.byte(name: "Marks", description: "", type: .bitMask),
	.byte(name: "Pokerus Days Remaining", description: "", type: .int),
	.short(name: "Unknown 12", description: "", type: .uintHex),
	.short(name: "Unknown 13", description: "", type: .uintHex),
	.short(name: "Unknown 14", description: "", type: .uintHex),
	.short(name: "Shadow ID", description: "", type: .uint),
	.word(name: "Heart Gauge", description: "", type: .int),
	.word(name: "Stored Experience", description: "", type: .uint),
	.short(name: "Unknown 15", description: "", type: .uintHex),
	.short(name: "Unknown 16", description: "", type: .uintHex),
	.array(name: "Unknowns", description: "", property:
		.byte(name: "Unknown", description: "", type: .uintHex), count: 16),
	.byte(name: "Obedience", description: "", type: .uint),
	.short(name: "Encounter Type", description: "", type: .uint),
	.array(name: "Unknowns 2", description: "Unused?", property:
		.byte(name: "Unknown", description: "", type: .uintHex), count: 60)
])

let dayCareStruct = GoDStruct(name: "Day Care", format: [
	.byte(name: "Day Care Status", description: "", type: .dayCareStatus),
	.byte(name: "Deposited At Level", description: "", type: .uint),
	.word(name: "Heart Gauge When Deposited", description: "", type: .uint),
	.subStruct(name: "Day Care Pokemon", description: "", property: pokemonStruct)
])
#else
let pokemonMoveStruct = GoDStruct(name: "Pokemon Move", format: [
	.short(name: "Move", description: "", type: .moveID),
	.byte(name: "Remaining PP", description: "", type: .uint),
	.byte(name: "PP Ups Used", description: "", type: .uint)
])

let pokemonStruct = GoDStruct(name: "Pokemon", format: [
	.short(name: "Species", description: "", type: .pokemonID),
	.short(name: "Item", description: "", type: .itemID),
	.short(name: "Current HP", description: "", type: .uint),
	.short(name: "Friendship", description: "", type: .uint),
	.short(name: "Location Caught", description: "", type: .uint),
	.short(name: "Unknown 1", description: "", type: .uint),
	.short(name: "Unknown 2", description: "", type: .uint),
	.byte(name: "Level Met", description: "", type: .uint),
	.byte(name: "Pokeball Caught In", description: "", type: .itemID),
	.byte(name: "Original Trainer Gender", description: "", type: .genderID),
	.byte(name: "Level", description: "", type: .uint),
	.byte(name: "Contest Luster", description: "", type: .uint),
	.byte(name: "Pokerus Status", description: "", type: .uint),
	.byte(name: "Marks", description: "", type: .bitMask),
	.byte(name: "Pokerus days remaining", description: "", type: .int),
	.byte(name: "Status", description: "", type: .statusEffect),
	.byte(name: "Bad Poison Turns", description: "", type: .int),
	.byte(name: "Sleep Turns Remaining", description: "", type: .int),
	.byte(name: "Unknown 3", description: "", type: .uintHex),
	.byte(name: "GC Unknown", description: "", type: .uint),
	.byte(name: "Unknown 4", description: "", type: .uintHex),
	.byte(name: "Unknown 5", description: "", type: .uintHex),
	.bitArray(name: "Flags", description: "", bitFieldNames: [
		"Is Egg",
		"Has Second Ability",
		"Is Bad Egg",
		"Tradeable",
		"Unknown",
		"Caught"
	]),
	.byte(name: "Unknown 6", description: "", type: .uintHex),
	.byte(name: "Unknown 7", description: "", type: .uintHex),
	.word(name: "Experience", description: "", type: .uint),
	.short(name: "Original Trainer SID", description: "", type: .uintHex),
	.short(name: "Original Trainer TID", description: "", type: .uintHex),
	.short(name: "PID First Half", description: "", type: .uintHex),
	.byte(name: "PID Third Byte", description: "", type: .uintHex),
	.bitMask(name: "PID Determinant Values", description: "", length: .word, values: [
		(name: "PID First 3 bytes", type: .uintHex, numberOfBits: 24, firstBitIndexLittleEndian: 8, mod: nil, div: nil, scale: nil),
		(name: "PID Gender Determinant", type: .uintHex, numberOfBits: 8, firstBitIndexLittleEndian: 0, mod: nil, div: 25, scale: nil),
		(name: "PID Nature", type: .natureID, numberOfBits: 32, firstBitIndexLittleEndian: 0, mod: 25, div: nil, scale: nil)
	]),
	.word(name: "Status Bit Fields", description: "", type: .bitMask),
	.byte(name: "Obedience", description: "", type: .uint),
	.byte(name: "Unknown 8", description: "", type: .uintHex),
	.byte(name: "Unknown 9", description: "", type: .uintHex),
	.byte(name: "Encounter Type", description: "", type: .uint),
	.byte(name: "Game ID", description: "", type: .gameID),
	.byte(name: "Current Game Region", description: "", type: .regionID),
	.byte(name: "Original Game Region", description: "", type: .regionID),
	.byte(name: "Original Language", description: "", type: .languageID),
	.string(name: "Original Trainer Name", description: "", maxCharacterCount: 10, charLength: .short),
	.short(name: "Padding", description: "", type: .null),
	.string(name: "Name", description: "", maxCharacterCount: 10, charLength: .short),
	.short(name: "Padding", description: "", type: .null),
	.string(name: "Name 2", description: "", maxCharacterCount: 10, charLength: .short),
	.short(name: "Padding", description: "", type: .null),
	.byte(name: "Unknown 10", description: "", type: .uintHex),
	.byte(name: "Unknown 11", description: "", type: .uintHex),
	.short(name: "Special Ribbons", description: "", type: .bitMask),
	.byte(name: "Unknown 12", description: "", type: .uintHex),
	.byte(name: "Unknown 13", description: "", type: .uintHex),
	.array(name: "Moves", description: "", property:
		.subStruct(name: "Pokemon Move", description: "", property: pokemonMoveStruct), count: 4),
	.subStruct(name: "Stats", description: "", property: statsStructShort),
	.subStruct(name: "EVs", description: "", property: statsStructShort),
	.subStruct(name: "IVs", description: "", property: statsStructByte),
	.subStruct(name: "Contest Stats", description: "", property: contestStatsStruct),
	.subStruct(name: "Contest Achievements", description: "", property: contestStatsStruct),
	.short(name: "Unknown 14", description: "", type: .uintHex),
	.short(name: "Shadow ID", description: "", type: .uint),
	.word(name: "Unknown", description: "", type: .uintHex),
	.word(name: "Padding", description: "", type: .null)
])

let dayCareStruct = GoDStruct(name: "Day Care", format: [
	.word(name: "Unknown 1", description: "", type: .uint),
	.word(name: "Unknown 2", description: "", type: .uint),
	.subStruct(name: "Day Care Pokemon", description: "", property: pokemonStruct)
])

let purificationChamberStruct = GoDStruct(name: "Purification Chamber Set", format: [
	.array(name: "Regular Pokemon", description: "", property:
		.subStruct(name: "Pokemon", description: "", property: pokemonStruct), count: 4),
	.subStruct(name: "Shadow Pokemon", description: "", property: pokemonStruct),
	.word(name: "Padding", description: "", type: .null)
])
#endif

let itemStorageStruct = GoDStruct(name: "PC Item Storage", format: [
	.short(name: "Item", description: "", type: .itemID),
	.short(name: "Count", description: "", type: .uint)
])



