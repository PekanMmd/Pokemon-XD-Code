//
//  Battles.swift
//  GoD Tool
//
//  Created by Stars Momodu on 23/03/2021.
//

import Foundation

#if GAME_XD
let battleTrainerStruct = GoDStruct(name: "Battle CD Trainer", format: [
	.short(name: "Deck ID", description: "", type: .deckID),
	.short(name: "Trainer ID", description: "", type: .uintHex)
])

let BattleCDStruct = GoDStruct(name: "Battle CD", format: [
	.byte(name: "Unknown", description: "", type: .uintHex),
	.byte(name: "Turn Limit", description: "Set to 0 for no limit", type: .uint),
	.byte(name: "Battle Style", description: "Single or Double", type: .battleStyle),
	.short(name: "Battle Field", description: "", type: .battleFieldID),
	.short(name: "Padding", description: "", type: .null),
	.subStruct(name: "Player Deck", description: "", property: battleTrainerStruct),
	.subStruct(name: "Opponent Deck", description: "", property: battleTrainerStruct),
	.word(name: "Name ID", description: "", type: .msgID(file: .dol)),
	.word(name: "Description ID", description: "", type: .msgID(file: .dol)),
	.word(name: "Condition Text ID", description: "", type: .msgID(file: .dol)),
	.word(name: "Unknown 4", description: "", type: .uintHex),
	.array(name: "Unknowns", description: "", property: .byte(name: "Unknown", description: "", type: .uintHex), count: 0x1c),

])

let battleCDsTable = CommonStructTable(index: .BattleCDs, properties: BattleCDStruct)

let battleLayoutsStruct = GoDStruct(name: "Battle Layout", format: [
	.byte(name: "Active pokemon per player", description: "", type: .uint),
	.byte(name: "Unknown 1", description: "", type: .uintHex),
	.byte(name: "Unknown 2", description: "", type: .uintHex),
	.word(name: "Unknown", description: "", type: .uintHex)
])

let battleLayoutsTable = CommonStructTable(index: .BattleLayouts, properties: battleLayoutsStruct)
#endif

let battlefieldsStruct = GoDStruct(name: "Battlefield", format: [
	.byte(name: "Unknown 1", description: "", type: .uintHex),
	.short(name: "Unknown 2", description: "", type: .uintHex),
	.word(name: "Name ID", description: "", type: .msgID(file: .common_rel)),
	.word(name: "Unknown 4", description: "", type: .uintHex),
	.word(name: "Unknown 5", description: "", type: .uintHex),
	.word(name: "Unknown 6", description: "", type: .uintHex),
	.short(name: "Unknown 7", description: "", type: .uintHex),
	.short(name: "Unknown 8", description: "", type: .uintHex)
])

let battlefieldsTable = CommonStructTable(index: .BattleFields, properties: battlefieldsStruct)

#if GAME_XD
let battleStruct = GoDStruct(name: "Battle", format: [
	.byte(name: "Battle Type", description: "", type: .battleType),
	.byte(name: "Trainers per side", description: "", type: .uint),
	.byte(name: "Battle Style", description: "", type: .battleStyle),
	.byte(name: "Pokemon Per Player", description: "", type: .uint),
	.byte(name: "Is Story Battle", description: "", type: .bool),
	.short(name: "Battle Field ID", description: "", type: .battleFieldID),
	.short(name: "Battle CD ID", description: "Set programmatically at run time so is always set to 0 in the game files", type: .uint),
	.word(name: "Unknown 1", description: "", type: .uintHex),
	.word(name: "BGM ID", description: "", type: .uintHex),
	.word(name: "Unknown 2", description: "", type: .uintHex),
	.word(name: "Colosseum Round", description: "", type: .colosseumRound),
	.array(name: "Players", description: "", property: .subStruct(name: "Battle Player", description: "", property: GoDStruct(name: "Battle Player", format: [
		.short(name: "Deck ID", description: "", type: .deckID),
		.short(name: "Trainer ID", description: "Use deck 0, id 5000 for the player's team", type: .uint),
		.word(name: "Controller Index", description: "0 for AI", type: .playerController),
	])), count: 4)
])
#else
let battleStruct = GoDStruct(name: "Battle", format: [
	.byte(name: "Battle Type", description: "", type: .battleType),
	.byte(name: "Battle Style", description: "", type: .battleStyle),
	.byte(name: "Unknown Flag", description: "", type: .bool),
	.short(name: "Unknown 1", description: "", type: .uintHex),
	.word(name: "Name ID", description: "", type: .msgID(file: .common_rel)),
	.word(name: "Unknown 2", description: "", type: .uintHex),
	.word(name: "Unknown 3", description: "", type: .uintHex),
	.word(name: "Unknown 4", description: "", type: .uintHex),
	.array(name: "Players", description: "", property: .subStruct(name: "Battle Player", description: "", property: GoDStruct(name: "Battle Player", format: [
		.short(name: "Trainer ID", description: "id 1 is the player", type: .indexOfEntryInTable(table: trainersTable, nameProperty: nil)),
		.word(name: "Controller Index", description: "0 for AI", type: .playerController),
	])), count: 4)
])
#endif
let battlesTable = CommonStructTable(index: .Battles, properties: battleStruct)


#if GAME_COLO
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

let trainersTable = CommonStructTable(index: .Trainers, properties: trainerStruct)

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
	.short(name: "Held Item", description: "", type: .itemID),
	.byte(name: "Unknown 3", description: "", type: .int),
	.byte(name: "Unknown 4", description: "", type: .int),
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
#endif

#if GAME_COLO
let battleStyleStruct = GoDStruct(name: "Battle Styles", format: [
	.byte(name: "Trainers per side", description: "", type: .uint),
	.byte(name: "Pokemon per trainer", description: "", type: .uint),
	.byte(name: "Active pokemon per trainer", description: "", type: .uint),
	.word(name: "Name ID", description: "", type: .msgID(file: .common_rel))
])

let battleStylesTable = CommonStructTable(index: .BattleStyles, properties: battleStyleStruct) { (index, data) -> String? in
	if let trainersPerSide: Int = data.get("Trainers per side"),
	let pokemonPerTrainer: Int = data.get("Pokemon per trainer"),
	let activePokemonPerTrainer: Int = data.get("Active pokemon per trainer") {
		let battleTypeName: String
		if trainersPerSide > 1 {
			battleTypeName = "Multi"
		} else {
			battleTypeName = activePokemonPerTrainer == 1 ? "Single" : "Double"
		}
		return "\(battleTypeName) Battle - \(pokemonPerTrainer) Pokemon Each"
	}
	return "Battle Style \(index)"
}
#endif
