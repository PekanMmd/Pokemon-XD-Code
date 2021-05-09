//
//  CMTrainersTable.swift
//  GoD Tool
//
//  Created by Stars Momodu on 08/05/2021.
//

import Foundation

let trainerStruct = GoDStruct(name: "Trainer", format: [
	.byte(name: "Gender", description: "", type: .genderID),
	.short(name: "Trainer Class", description: "", type: .trainerClassID),
	.short(name: "First Pokemon Index", description: "The index of the trainer's first pokemon in the pokemon table", type: .uint),
	.short(name: "AI Index", description: "", type: .uint),
	.word(name: "Name ID", description: "", type: .msgID(file: .common_rel)),
	.word(name: "Battle Transition", description: "Determines the effect used for transitioning to the battle", type: .uint),
	.word(name: "Model ID", description: "", type: .trainerModelID),
	.array(name: "Items", description: "Items the trainer can use in battle", property:
		.short(name: "Item", description: "", type: .itemID), count: 8),
	.word(name: "Pre Battle Text Id", description: "Text the trainer says before the battle", type: .msgID(file: .nameAndFsysName("tool_fight.msg", "fight_common"))),
	.word(name: "Victory Text Id", description: "Text the trainer says if they win", type: .msgID(file: .nameAndFsysName("tool_fight.msg", "fight_common"))),
	.word(name: "Loss Text Id", description: "Text the trainer says if they lose", type: .msgID(file: .nameAndFsysName("tool_fight.msg", "fight_common"))),
	.word(name: "Padding", description: "", type: .null)
])

let trainersTable = TrainerStructTable(index: .Trainers, properties: trainerStruct)

let trainerPokemonStruct = GoDStruct(name: "Trainer Pokemon", format: [
	.byte(name: "Ability Slot", description: "either 0 or 1 for ability slots, -1 for random", type: .int),
	.byte(name: "Gender", description: "", type: .genderID),
	.byte(name: "Nature", description: "", type: .natureID),
	.byte(name: "Shadow ID", description: "", type: .uint),
	.byte(name: "Level", description: "", type: .uint),
	.byte(name: "Unknown 1", description: "Possibly the priority for this pokemon to be sent out", type: .uint),
	.byte(name: "Unknown 2", description: "", type: .uint),
	.byte(name: "Padding", description: "", type: .null),
	.byte(name: "Happiness", description: "", type: .uint),
	.byte(name: "Unknown 3", description: "", type: .int),
	.short(name: "Species", description: "", type: .pokemonID),
	.short(name: "Pokeball", description: "The type of pokeball the pokemon comes out of", type: .itemID),
	.short(name: "Padding", description: "", type: .null),
	.byte(name: "Unknown 3", description: "", type: .int),
	.byte(name: "Unknown 4", description: "", type: .int),
	.short(name: "Held Item", description: "", type: .itemID),
	.word(name: "Name ID", description: "", type: .msgID(file: .common_rel)),
	.word(name: "Unknown 5", description: "", type: .uint),
	.subStruct(name: "IVs", description: "", property: statsStructByte),
	.subStruct(name: "EVs", description: "", property: statsStructShort),
	.short(name: "Padding", description: "", type: .null),
	.array(name: "Moves", description: "", property:
		.subStruct(name: "Trainer Pokemon Move", description: "", property: GoDStruct(name: "Trainer Pokemon Move", format: [
			.word(name: "Padding", description: "Unused?", type: .null),
			.short(name: "PP", description: "Usually left set to 0", type: .int),
			.short(name: "Move", description: "Set this to a negative number for a random move", type: .moveID)
		])), count: 4)
])

let trainerPokemonTable = CommonStructTable(index: .TrainerPokemonData, properties: trainerPokemonStruct) { (index, data) -> String? in
	if index == 0 {
		return "None"
	}
	if let monIndex: Int = data.get("Species") {
		return XGPokemon.index(monIndex).name.unformattedString
	}
	return "Trainer Pokemon \(index)"
}

let shadowPokemonTable = CommonStructTable(index: .ShadowData, properties: GoDStruct(name: "Shadow Pokemon Data", format: [
	.byte(name: "Catch Rate", description: "Overrides the catch rate for the pokemon species", type: .uint),
	.short(name: "Species", description: "The species of the shadow pokemon that uses this id", type: .pokemonID),
	.short(name: "First Trainer Index", description: "The index of the trainer entry of the first time this pokemon is encountered", type: .trainerID),
	.short(name: "Alternative First Trainer Index", description: "The index of the trainer entry of another possibility for the first time this pokemon is encountered", type: .trainerID),
	.short(name: "Heart Guage", description:"Determines how long it takes to purify the pokemon", type: .uint),
	.short(name: "Index", description: "", type: .uint),
	.short(name: "Unknown 1", description: "", type: .uintHex),
	.short(name: "Padding", description: "", type: .null),
	.array(name: "Unknown Values", description: "", property:
		.short(name: "Unknown", description: "", type: .uintHex), count: 4),
	.word(name: "Unknown 2", description: "", type: .uintHex),
	.short(name: "Unknown 3", description: "", type: .uintHex),
	.short(name: "Unknown 4", description: "", type: .uint),
	.word(name: "Debug Name ID", description: "", type: .msgID(file: .common_rel)),
	.array(name: "Unknown Values 2", description: "", property:
		.short(name: "Unknown", description: "", type: .uintHex), count: 6),
	.array(name: "Unknown Values 3", description: "", property:
		.word(name: "Unknown", description: "", type: .uintHex), count: 2)

])) { (index, data) -> String? in
	if let species: Int = data.get("Species"), species < CommonIndexes.NumberOfPokemon.value {
		return XGPokemon.index(species).name.unformattedString
	}
	return "Shadow Pokemon ID \(index)"
}

class TrainerStructTable: CommonStructTable {
	func documentData() {
		let foldername = properties.name + (fileVaries ? " " + file.fileName.removeFileExtensions() : "")
		let folder = XGFolders.nameAndFolder(foldername, .nameAndFolder("Documented Data", .Reference))
		printg("Documenting \(properties.name) table to:", folder.path)
		allEntries.forEachIndexed { (index, entry) in
			var filename = documentByIndex ?
				String(format: "%03d ", index) + assumedNameForEntry(index: index) + ".yaml" :
				assumedNameForEntry(index: index) + String(format: " %03d", index)  + ".yaml"
			filename = filename.replacingOccurrences(of: ":", with: "").replacingOccurrences(of: "\"", with: "")
			filename = filename.replacingOccurrences(of: ":", with: "").replacingOccurrences(of: "\"", with: "")
			var text = entry.description
			if let firstPokemonIndex: Int = entry.get("First Pokemon Index") {
				text += "\nPokemon:"
				(0 ..< 6).forEach { (index) in
					if let pokemon = trainerPokemonTable.dataForEntry(firstPokemonIndex + index),
					   (pokemon.get("Species") ?? 0) != 0 {
						text += "\n" + pokemon.description
					}
				}
			}
			let file = XGFiles.nameAndFolder(filename, folder)
			XGUtility.saveString(text, toFile: file)
		}
	}
}
