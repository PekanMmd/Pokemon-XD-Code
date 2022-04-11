//
//  MovesTable.swift
//  GoD Tool
//
//  Created by Stars Momodu on 26/03/2021.
//

import Foundation

#if GAME_XD
let moveStruct = GoDStruct(name: "Move", format: [
	.byte(name: "Priority", description: "", type: .int),
	.byte(name: "Base PP", description: "", type: .uint),
	.byte(name: "Type", description: "", type: .typeID),
	.byte(name: "Targets", description: "", type: .moveTarget),
	.byte(name: "Base Accuracy", description: "", type: .uint),
	.byte(name: "Effect Accuracy", description: "How likely it is for the secondary effect to activate", type: .uint),
	.subStruct(name: "Flags", description: "", property: GoDStruct(name: "Move Flags", format: [
		.byte(name: "Makes Contact", description: "", type: .bool),
		.byte(name: "Can Be Protected Against", description: "", type: .bool),
		.byte(name: "Can Be Reflected By Magic Coat", description: "", type: .bool),
		.byte(name: "Can Be Stolen By Snatch", description: "", type: .bool),
		.byte(name: "Can Be Copied By Mirror Move", description: "", type: .bool),
		.byte(name: "Gains Flinch Chance With King's Rock", description: "", type: .bool),
		.byte(name: "Callable by Metronome", description: "", type: .bool),
		.byte(name: "Copyable by Mimic", description: "", type: .bool),
		.byte(name: "Callable by Assist", description: "", type: .bool),
		.byte(name: "Callable by Sleep Talk", description: "", type: .bool),
		.byte(name: "Is Sound Based", description: "", type: .bool),
		.byte(name: "Has unspecified target", description: "", type: .bool),
		.byte(name: "Is HM Move", description: "", type: .bool)
	])),
	.byte(name: "Category", description: "Physical, Special or Status", type: .moveCategory),
	.byte(name: "Has Risk Flag", description: "Marks that the move negatively imapcts the user", type: .bool),
	.byte(name: "Match Up Chart Type", description: "Determines how the type match up chart appears in the summary screen", type: .uintHex),
	.byte(name: "Contest Appeal Jam Index", description: "", type: .uint),
	.byte(name: "Contest Appeal Type", description: "", type: .contestAppeal),
	.short(name: "Base Power", description: "", type: .uint),
	.short(name: "Padding", description: "", type: .null),
	.short(name: "Effect", description: "", type: .moveEffectID),
	.short(name: "Animation ID", description: "", type: .uintHex),
	.word(name: "Name ID", description: "", type: .msgID(file: .common_rel)),
	.word(name: "Unused String ID", description: "", type: .msgID(file: nil)),
	.word(name: "Exclamation String ID", description: "", type: .msgID(file: .typeAndFsysName(.msg, "fight_common"))),
	.word(name: "Description ID", description: "", type: .msgID(file: .dol)),
	.word(name: "Animation ID 2", description: "", type: .uintHex),
	.byte(name: "Move Effect Type", description: "", type: .moveEffectType)
])
#else
var moveStruct: GoDStruct {
	return GoDStruct(name: "Move", format: [
		.byte(name: "Priority", description: "", type: .int),
		.byte(name: "Base PP", description: "", type: .uint),
		.byte(name: "Type", description: "", type: .typeID),
		.byte(name: "Targets", description: "", type: .moveTarget),
		.byte(name: "Base Accuracy", description: "", type: .uint),
		.byte(name: "Effect Accuracy", description: "How likely it is for the secondary effect to activate", type: .uint),
		.subStruct(name: "Flags", description: "", property: GoDStruct(name: "Move Flags", format: [
			.byte(name: "Makes Contact", description: "", type: .bool),
			.byte(name: "Can Be Protected Against", description: "", type: .bool),
			.byte(name: "Can Be Reflected By Magic Coat", description: "", type: .bool),
			.byte(name: "Can Be Stolen By Snatch", description: "", type: .bool),
			.byte(name: "Can Be Copied By Mirror Move", description: "", type: .bool),
			.byte(name: "Gains Flinch Chance With King's Rock", description: "", type: .bool),
			.byte(name: "Callable by Metronome", description: "", type: .bool),
			.byte(name: "Copyable by Mimic", description: "", type: .bool),
			.byte(name: "Callable by Assist", description: "", type: .bool),
			.byte(name: "Callable by Sleep Talk", description: "", type: .bool),
			.byte(name: "Is Sound Based", description: "", type: .bool),
			.byte(name: "Has unspecified target", description: "", type: .bool),
			.byte(name: "Is HM Move", description: "", type: .bool),
			.byte(name: "Has Risk Flag", description: "Marks that the move negatively imapcts the user", type: .bool)
		])),
		.byte(name: "Contest Appeal Jam Index", description: "", type: .uint),
		.byte(name: "Contest Appeal Type", description: "", type: .contestAppeal),
		.short(name: "Base Power", description: "", type: .uint),
		.word(name: "Effect", description: "", type: .moveEffectID),
		.short(name: "Animation ID", description: "", type: .uintHex)]
		+ (XGPatcher.isClassSplitImplemented()
			? [
				.byte(name: "Unused", description: "Padding", type: .int),
				.byte(name: "Category", description: "Physical or Special", type: .moveCategory)
			]
		: [])
		+ [
		.word(name: "Name ID", description: "", type: .msgID(file: .common_rel)),
		.word(name: "Unused String ID", description: "", type: .msgID(file: .nameAndFsysName("fight.msg", "fight_common"))),
		.word(name: "Exclamation String ID", description: "", type: .msgID(file: .nameAndFsysName("fight.msg", "fight_common"))),
		.word(name: "Description ID", description: "", type: .msgID(file: .dol)),
		.short(name: "Padding 2", description: "", type: .null),
		.short(name: "Animation ID 2", description: "", type: .uintHex),
		.byte(name: "Move Effect Type", description: "", type: .moveEffectType),
		.byte(name: "Secondary Effect Type", description: "", type: .moveEffectType)
	])
}
#endif

var movesTable: CommonStructTable {
	return CommonStructTable(index: .Moves, properties: moveStruct, documentByIndex: false)
}
