//
//  PokemonStatsTable.swift
//  GoD Tool
//
//  Created by Stars Momodu on 20/03/2021.
//

import Foundation

let TMHMFieldNames: [String?] = {
	var TMNames = [String?]()
	for i in 0 ..< 4 {
		let startIndexForChunk = i * 32
		let tmsIndexesForChunk = (startIndexForChunk ..< startIndexForChunk + 32).reversed()
		tmsIndexesForChunk.forEach { index in
			let name: String?
			if index < kNumberOfTMs {
				name = "TM " + XGTMs.tm(index + 1).move.name.unformattedString
			} else if index < kNumberOfTMsAndHMs {
				name = "HM " + XGTMs.tm(index + 1).move.name.unformattedString
			} else {
				name = nil
			}
			TMNames.append(name)
		}
	}
	return TMNames
}()


let pokemonStatsTable = CommonStructTable(index: region == .JP ? 14 : 8, properties: GoDStruct(name: "Pokemon Stats", format: [
	.bitArray(name: "TMs and HMs", description: "Need to confirm how these are ordered", bitFieldNames: TMHMFieldNames),
	.array(name: "Items", description: "The Items the pokemon may carry when caught in the wild", property: .short(name: "Item", description: "", type: .itemID), count: 2),
	.subStruct(name: "Proportions", description: "Physical dimensions of the species", property: GoDStruct(name: "Height and Weight", format: [
		.short(name: "Height", description: "The pokemon's height in meters, multiplied by 10", type: .uint),
		.short(name: "Weight", description: "The pokemon's weight in kilograms, multiplied by 10", type: .uint)
	])),
	.short(name: "Name ID", description: "", type: .msgID(file: nil)),
	.short(name: "Cry ID", description: "", type: .uint),
	.short(name: "Model Index", description: "The index of the pokemon's first model", type: .uint),
	.subStruct(name: "Base Stats", description: "", property: GoDStruct(name: "Stats", format: [
		.byte(name: "HP", description: "", type: .uint),
		.byte(name: "Attack", description: "", type: .uint),
		.byte(name: "Defense", description: "", type: .uint),
		.byte(name: "Speed", description: "", type: .uint),
		.byte(name: "Sp.Atk", description: "", type: .uint),
		.byte(name: "sp.Def", description: "", type: .uint)
	])),
	.array(name: "Types", description: "", property: .byte(name: "Type", description: "", type: .typeID), count: 2),
	.byte(name: "Catch Rate", description: "", type: .uint),
	.byte(name: "Base EXP", description: "Determines how much exp you get for defeating this species", type: .uint),
	.array(name: "Unknown 1", description: "", property: .byte(name: "", description: "", type: .uint), count: 2),
	.byte(name: "Gender Ratio", description: "", type: .genderRatio),
	.byte(name: "Egg Cycles", description: "The number of cycles of steps to hatch from an egg", type: .uint),
	.byte(name: "Base Happiness", description: "", type: .uint),
	.byte(name: "Level Up Rate", description: "Determines how much exp it takes for each level up", type: .expRate),
	.array(name: "Egg Groups", description: "Can breed with any pokemon with a matching group", property: .byte(name: "Egg Group", description: "", type: .eggGroup), count: 2),
	.array(name: "Abilities", description: "", property: .byte(name: "Ability", description: "", type: .abilityID), count: 2),
	.byte(name: "Unknown 2", description: "", type: .uint),
	.byte(name: "Colour Data", description: "Determines colour category in the pokedex. Lowest bit of this value is used for something unknown.", type: .uint)

]))

let evolutionsTable = CommonStructTable(index: region == .JP ? 15 : 9, properties: GoDStruct(name: "Evolutions", format: [
	.array(name: "Evolutions", description: "", property:
		.subStruct(name: "Evolution", description: "", property: GoDStruct(name: "Evolution Entry", format: [
			.short(name: "Evolution Method", description: "", type: .evolutionMethod),
			.short(name: "Evolution Condition", description: "Based on the evolution method, e.g. for level up this is the level, for evolution items this is the item id", type: .uint),
			.short(name: "Evolved Pokemon", description: "The Pokemon it evolves into", type: .pokemonID)
		])), count: 7)
	]))
{ (index, entry) -> String? in
	return pokemonStatsTable.assumedNameForEntry(index: index)
}

let levelUpMovesTable = CommonStructTable(index: region == .JP ? 16 : 32, properties: GoDStruct(name: "Level Up Moves", format: [
	.array(name: "Level Up Moves", description: "", property:
		.subStruct(name: "", description: "", property: GoDStruct(name: "Level Up Move Entry", format: [
			.short(name: "Move", description: "", type: .moveID),
			.byte(name: "Level", description: "", type: .uint),
			.byte(name: "Unknown", description: "", type: .uint)
		])), count: 20)
	]))
{ (index, entry) -> String? in
	return pokemonStatsTable.assumedNameForEntry(index: index)
}
