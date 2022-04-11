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
var battleStruct: GoDStruct {
	return GoDStruct(name: "Battle", format: [
		.byte(name: "Battle Type", description: "", type: .battleType),
		.byte(name: "Trainers per side", description: "", type: .uint),
		.byte(name: "Battle Style", description: "", type: .battleStyle),
		.byte(name: "Pokemon Per Player", description: "", type: .uint),
		.byte(name: "Is Story Battle", description: "", type: .bool),
		.short(name: "Battle Field ID", description: "", type: .battleFieldID),
		.short(name: "Battle CD ID", description: "Set programmatically at run time so is always set to 0 in the game files", type: .uint),
		.word(name: "Battle Identifier String", description: "", type: .msgID(file: .dol)),
		.word(name: "BGM ID", description: "", type: .uintHex),
		.word(name: "Unknown 2", description: "", type: .uintHex)
		]
	+ (region == .EU ? [.array(name: "Unknown Values", description: "Only exist in the PAL version", property: .word(name: "", description: "", type: .uintHex), count: 4)] : [])
	+ [
		.word(name: "Colosseum Round", description: "wzx id for intro text", type: .colosseumRound),
		.array(name: "Players", description: "", property: .subStruct(name: "Battle Player", description: "", property: GoDStruct(name: "Battle Player", format: [
			.short(name: "Deck ID", description: "", type: .deckID),
			.short(name: "Trainer ID", description: "Use deck 0, id 5000 for the player's team", type: .uint),
			.word(name: "Controller Index", description: "0 for AI", type: .playerController),
		]
		)), count: 4)
	])
}
#else
let battleStruct = GoDStruct(name: "Battle", format: [
	.byte(name: "Battle Type", description: "", type: .battleType),
	.byte(name: "Battle Style", description: "", type: .battleStyle),
	.byte(name: "Unknown Flag", description: "", type: .bool),
	.short(name: "Battle Field ID", description: "", type: .battleFieldID),
	.word(name: "Name ID", description: "", type: .msgID(file: .common_rel)),
	.word(name: "BGM ID", description: "", type: .uintHex),
	.word(name: "Unknown 3", description: "", type: .uintHex),
	.word(name: "Colosseum Round", description: "", type: .colosseumRound),
	.array(name: "Players", description: "", property: .subStruct(name: "Battle Player", description: "", property: GoDStruct(name: "Battle Player", format: [
		.short(name: "Trainer ID", description: "id 1 is the player", type: .indexOfEntryInTable(table: trainersTable, nameProperty: nil)),
		.word(name: "Controller Index", description: "0 for AI", type: .playerController),
	])), count: 4)
])
#endif
var battlesTable: CommonStructTable {
	return CommonStructTable(index: .Battles, properties: battleStruct)
}

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

let battleTypesStruct = GoDStruct(name: "Battle Types", format: [
	.byte(name: "Flag 1", description: "", type: .bool),
	.byte(name: "Flag 2", description: "", type: .bool),
	.byte(name: "Flag 3", description: "", type: .bool),
	.byte(name: "Flag 4", description: "", type: .bool),
	.byte(name: "Can Use Items", description: "", type: .bool),
	.byte(name: "Flag 6", description: "", type: .bool),
	.byte(name: "Flag 7", description: "", type: .bool),
	.byte(name: "Flag 8", description: "", type: .bool),
	.byte(name: "Flag 9", description: "", type: .bool),
	.byte(name: "Flag 10", description: "", type: .bool),
	.byte(name: "Flag 11", description: "", type: .bool),
	.byte(name: "Flag 12", description: "", type: .bool),
	.byte(name: "Flag 13", description: "", type: .bool),
	.byte(name: "Flag 14", description: "", type: .bool),
	.byte(name: "Flag 15", description: "", type: .bool),
	.byte(name: "Flag 16", description: "", type: .bool),
	.byte(name: "Flag 17", description: "", type: .bool),
	.byte(name: "Flag 18", description: "", type: .bool),
	.byte(name: "Flag 19", description: "", type: .bool),
	.byte(name: "Flag 20", description: "", type: .bool),
	.byte(name: "Flag 21", description: "", type: .bool),
	.byte(name: "Flag 22", description: "", type: .bool),
	.byte(name: "Flag 23", description: "", type: .bool),
	.byte(name: "Flag 24", description: "", type: .bool),
	.byte(name: "Flag 25", description: "", type: .bool),
	.word(name: "Name ID", description: "", type: .msgID(file: .common_rel))
])

let battleTypesTable = CommonStructTable(index: .BattleTypes, properties: battleTypesStruct) { (index, data) -> String? in
	if let type = XGBattleTypes(rawValue: index) {
		return type.name
	}
	return "Battle Type \(index)"
}
#endif
