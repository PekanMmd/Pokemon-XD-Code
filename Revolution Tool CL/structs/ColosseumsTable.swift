//
//  ColosseumsTable.swift
//  GoD Tool
//
//  Created by Stars Momodu on 03/11/2021.
//

import Foundation

let colosseumTrainerDeckStruct = GoDStruct(name: "Colosseum Trainer Deck", format: [
	.array(name: "Unused", description: "", property:
				.byte(name: "Unused", description: "", type: .null), count: 3),
	.byte(name: "First Trainer Index", description: "The index in this deck of the first trainer, subsequent round trainers are consecutive", type: .int),
	.word(name: "Deck ID", description: "", type: .fsysFileIdentifier(fsysName: "deck")),
	.word(name: "AI deck", description: "", type: .fsysFileIdentifier(fsysName: "deck")),
	.byte(name: "Unknown 2", description: "", type: .uint),
	.array(name: "Unknowns 3", description: "", property:
		.byte(name: "Unknown", description: "", type: .uint), count: 3)
])

let colosseumPokemonDecksStruct = GoDStruct(name: "Colosseum Pokemon Decks", format: [
	.word(name: "Main Deck", description: "", type: .fsysFileIdentifier(fsysName: "deck")),
	.word(name: "Boss Deck", description: "", type: .fsysFileIdentifier(fsysName: "deck")),
])

let colosseumStruct = GoDStruct(name: "Colosseums", format: [
	.subStruct(name: "Boss Trainer Deck", description: "", property: colosseumTrainerDeckStruct),
	.subStruct(name: "Main Trainer Deck", description: "", property: colosseumTrainerDeckStruct),
	.subStruct(name: "Singles Pokemon Decks", description: "", property: colosseumPokemonDecksStruct),
	.subStruct(name: "Doubles Pokemon Decks", description: "", property: colosseumPokemonDecksStruct),
	.short(name: "Unknown 1", description: "Unknown 1", type: .uint),
	.short(name: "Unknown 2", description: "Unknown 1", type: .uint),
	.short(name: "Unknown 3", description: "Unknown 1", type: .uint),
	.short(name: "Unknown 4", description: "Unknown 1", type: .uint),
	.short(name: "Unknown 5", description: "Unknown 1", type: .uint),
	.short(name: "Unknown 6", description: "Unknown 1", type: .uint),
	.short(name: "Unknown 7", description: "Unknown 1", type: .uint),
	.short(name: "Padding", description: "Unused", type: .null),
	.byte(name: "Unknown 8", description: "", type: .int),
	.byte(name: "Unknown 9", description: "", type: .int),
	.short(name: "Unknown 10", description: "Unknown 1", type: .uint),
	.short(name: "Padding", description: "Unused", type: .null),
	.byte(name: "Unknown 11", description: "", type: .int),
	.byte(name: "Unknown 12", description: "", type: .int),
	.short(name: "Rules", description: "", type: .msgID(file: nil)),
	.array(name: "Unknowns", description: "", property:
				.byte(name: "Unknown", description: "", type: .uint), count: 18)

])

let colosseumsTable = CommonStructTable(file: .indexAndFsysName(region == .JP ? 24 : 11, "common"), properties: colosseumStruct)
