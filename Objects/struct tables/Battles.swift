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
#endif

let battleTypesStruct = GoDStruct(name: "Battle Types", format: [
	.byte(name: "Revert Changes After Battle", description: "The players teams and items go back to how they were before the battle", type: .bool),
	.byte(name: "Enable Gym Badge Boosts", description: "Enables stat boosts based on gym badges from the GBA games", type: .bool),
	.byte(name: "Count Pokemon As Seen", description: "In the Dex/Strategy Memo", type: .bool),
	.byte(name: "Count Pokemon as Caught", description: "In the Dex/Strategy Memo", type: .bool),
	.byte(name: "Enable Trainer Items", description: "", type: .bool),
	.byte(name: "Can Call Pokemon", description: "", type: .bool),
	.byte(name: "Can Run", description: "", type: .bool),
	.byte(name: "Can Draw", description: "", type: .bool),
	.byte(name: "Pokemon Gain Exp", description: "", type: .bool),
	.byte(name: "Awards Prize Money", description: "", type: .bool),
	.byte(name: "Add prize money to pool", description: "Adds the prize money value to a flag which can be awarded later. Used for colosseum challenges to award all the money at the end.", type: .bool),
	.byte(name: "Pay Day Flag", description: "Whether the move pay day can double the prize money", type: .bool),
	.byte(name: "Enable Friendship Gain", description: "", type: .bool),
	.byte(name: "Can Trigger Pokerus", description: "Unused", type: .bool),
	.byte(name: "Enable Critical Hits", description: "", type: .bool),
	.byte(name: "Enable Rui AI Flag", description: "", type: .bool),
	.byte(name: game == .XD ? "Enable Aura Reader Shadow Pokemon Reveal" : "Enable Rui Shadow Pokemon Reveal", description: "", type: .bool),
	.byte(name: "Enable Soul Dew Effect", description: "", type: .bool),
	.byte(name: "Boost Exp Gain", description: "increases exp gain by 50%", type: .bool),
	.byte(name: "Is Boss Battle", description: "", type: .bool),
	.byte(name: "Can Steal Items", description: "with the move thief", type: .bool),
	.byte(name: "Enable Pickup", description: "", type: .bool),
	.byte(name: game == .XD ? "Enable Reverse Mode" : "Enable Hyper Mode", description: "", type: .bool),
	.byte(name: "Enable Full HUD layout", description: "", type: .bool),
	.byte(name: "Display Opponent Dialog", description: "", type: .bool),
	.byte(name: "Enable Battle Rules", description: "Whether rules like sleep clause and battle timers are checked", type: .bool),
	.word(name: "Name ID", description: "", type: .msgID(file: .common_rel))
])

let battleTypesTable = CommonStructTable(index: .BattleTypes, properties: battleTypesStruct) { (index, data) -> String? in
	if let type = XGBattleTypes(rawValue: index) {
		return type.name
	}
	return "Battle Type \(index)"
}

private let aiRolesEnd: [GoDStructProperties] = game == .Colosseum ? [] : [
	.byte(name: "Misc 3", description: "", type: .byteRange),
	.byte(name: "Misc 4", description: "", type: .byteRange),
]

let pokemonAIRolesStruct = GoDStruct(name: "Pokemon AI Roles", format: [
	.word(name: "Name ID", description: "", type: .msgID(file: nil)),
	.word(name: "Unknown 1", description: "", type: .uint),
	.subStruct(name: "Move Type Weights", description: "How much more/less likely this role is to use a certain type of move", property: GoDStruct(name: "AI Role Weights", format: [
		.byte(name: "No Effect", description: "", type: .byteRange),
		.byte(name: "Attack", description: "", type: .byteRange),
		.byte(name: "Healing", description: "", type: .byteRange),
		.byte(name: "Stat Decrease", description: "", type: .byteRange),
		.byte(name: "Stat Increase", description: "", type: .byteRange),
		.byte(name: "Status", description: "", type: .byteRange),
		.byte(name: "Field", description: "", type: .byteRange),
		.byte(name: "Affect Opponent's Move", description: "", type: .byteRange),
		.byte(name: "OHKO", description: "", type: .byteRange),
		.byte(name: "Multi-turn", description: "", type: .byteRange),
		.byte(name: "Misc", description: "", type: .byteRange),
		.byte(name: "Misc 2", description: "", type: .byteRange)
	] + aiRolesEnd))
])

let pokemonAIRolesTable = CommonStructTable(index: .AIPokemonRoles, properties: pokemonAIRolesStruct)
