//
//  BattleBingoStruct.swift
//  GoD Tool
//
//  Created by Stars Momodu on 18/03/2021.
//

import Foundation

let mysteryPanelsStruct = GoDStruct(name: "MysteryPanel", format: [
	.byte(name: "Panel Type", description: "", type: .battleBingoMysteryPanelType),
	.byte(name: "Position Index", description: "Which position on the board this panel is inserted between the pokemon", type: .uint)
])

let bingoPokemonStruct = GoDStruct(name: "BattleBingoPokemon", format: [
	.byte(name: "Shows Secondary Type on Card", description: "Whether to show the pokemon's second type instead of the first type", type: .bool),
	.byte(name: "Use Secondary Ability", description: "Where the pokemon has its first ability slot or second", type: .bool),
	.byte(name: "Nature", description: "The pokemon's nature", type: .natureID),
	.byte(name: "Gender", description: "The pokemon's gender", type: .genderID),
	.short(name: "Species", description: "The pokemon species", type: .pokemonID),
	.short(name: "Move", description: "The one move the pokemon will know", type: .moveID),
	.byte(name: "Unknown 3", description: "", type: .uint),
	.byte(name: "Unknown 4", description: "", type: .uint),
])

let battleBingoCardStruct = GoDStruct(name: "BattleBingoCard", format: [
	.byte(name: "Index", description: "", type: .uint),
	.byte(name: "Difficulty", description: "", type: .uint),
	.byte(name: "Sub index", description: "Index within difficulty level", type: .uint),
	.byte(name: "Pokemon Level", description: "All pokemon will be set to this level for this card", type: .uint),
	.byte(name: "Unknown 1", description: "", type: .uint),
	.byte(name: "Unknown 2", description: "", type: .uint),
	.byte(name: "Pokemon Count", description: "Number of Pokemon on Card, including starter", type: .uint),
	.byte(name: "Myster Panel Count", description: "Number of Mystery Panels on card", type: .uint),
	.word(name: "Name", description: "Msg ID of card's name", type: .msgID(file: .typeAndFsysName(.msg, "D4_tower_1F_2"))),
	.word(name: "Description", description: "Msg ID of description for card", type: .msgID(file: .typeAndFsysName(.msg, "D4_tower_1F_2"))),
	.array(name: "Rewards", description: "The number of coupons for each number of bingo lines completed", property: .short(name: "Reward", description: "", type: .uint), count: 10),
	.array(name: "Bingo Pokemon", description: "Data for each pokemon available on the card in order of position", property: .subStruct(name: "Bingo Pokemon", description: "", property: bingoPokemonStruct), count: 14),
	.array(name: "Mystery Panels", description: "The locations for each type of mystery panel", property: .subStruct(name: "Mystery Panel", description: "", property: mysteryPanelsStruct), count: 3),
	.short(name: "Padding", description: "Unused padding bytes", type: .null)
])

let battleBingoTable = CommonStructTable(index: 0, properties: battleBingoCardStruct)

