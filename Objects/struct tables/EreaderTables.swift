//
//  EreaderTables.swift
//  GoD Tool
//
//  Created by Stars Momodu on 23/08/2021.
//

import Foundation

class EreaderStructTable: GoDStructTableFormattable {
	enum EreaderTableType {
		case pokemon, trainers
	}

	let file: XGFiles
	let properties: GoDStruct
	let startOffsetForFirstEntryInFile: ((XGFiles) -> Int)
	let numberOfEntriesInFile: ((XGFiles) -> Int)
	var nameForEntry: ((Int, GoDStructData) -> String?)?
	let documentByIndex: Bool
	var fileVaries: Bool {
		return true
	}

	init(type: EreaderTableType, inFile file: XGFiles) {
		self.file = file
		switch type {
		case .pokemon:
			properties = ecardTrainerPokemonStruct
			startOffsetForFirstEntryInFile = { (file) in
				return 0x510
			}
			numberOfEntriesInFile = { (file) in
				return 36
			}
			nameForEntry = { (index, data) -> String? in
				if let monIndex: Int = data.get("Species") {
					return XGPokemon.index(monIndex).name.unformattedString
				}
				return "Pokemon_\(index)"
			}
		case .trainers:
			properties = ecardTrainerStruct
			startOffsetForFirstEntryInFile = { (file) in
				return 0x3A8
			}
			numberOfEntriesInFile = { (file) in
				return 9
			}
			nameForEntry = { (index, data) -> String? in
				if let name: String = data.get("Name") {
					return name
				}
				return "Trainer_\(index)"
			}
		}

		self.documentByIndex = true
	}
}

let ecardTrainerPokemonStruct = GoDStruct(name: "Ecard Pokemon", format: [
	.short(name: "Species", description: "", type: .pokemonID),
	.byte(name: "Shadow ID", description: "", type: .uint),
	.byte(name: "Level", description: "", type: .uint),
	.array(name: "Moves", description: "", property:
		.short(name: "Move", description: "", type: .moveID), count: 4),
	.short(name: "Unknown", description: "", type: .uintHex),
	.byte(name: "Ability Slot", description: "", type: .uint),
	.subStruct(name: "IVs", description: "", property: statsStructByte),
	.subStruct(name: "EVs", description: "", property: statsStructShort),
	.short(name: "Happiness", description: "", type: .uint),
	.byte(name: "Gender", description: "", type: .genderID),
	.byte(name: "Nature", description: "", type: .natureID),
	.byte(name: "Unknown 1", description: "", type: .uintHex),
	.byte(name: "Unknown 2", description: "", type: .uintHex),
	.byte(name: "Heart Gauge", description: "", type: .uintHex)
])

let ecardTrainerStruct = GoDStruct(name: "Ecard Trainer", format: [
	.string(name: "Name", description: "", maxCharacterCount: 6, charLength: .short),
	.byte(name: "Gender", description: "", type: .genderID),
	.array(name: "Pokemon Slots", description: "Index into the pokemon entries on the card", property:
			.byte(name: "Index", description: "", type: .uint), count: 4), // update this to be index into ecardTrainerPokemonTable in same file once implemented
	.array(name: "Items", description: "", property:
			.short(name: "Item", description: "", type: .itemID), count: 4),
	.word(name: "Unknown", description: "", type: .bool),
	.short(name: "AI Index", description: "", type: .uint),
	.short(name: "Trainer ID", description: "", type: .uint),
	.byte(name: "Model ID", description: "", type: .pkxTrainerID)

])
