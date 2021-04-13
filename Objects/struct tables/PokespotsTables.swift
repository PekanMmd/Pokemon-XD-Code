//
//  File.swift
//  GoD Tool
//
//  Created by Stars Momodu on 22/03/2021.
//

import Foundation

let pokespotPokemonStructFormat: [GoDStructProperties] = [
	.byte(name: "Min Level", description: "", type: .uint),
	.byte(name: "Max Level", description: "", type: .uint),
	.short(name: "Species", description: "", type: .pokemonID),
	.word(name: "Encounter Percentage", description: "", type: .percentage),
	.word(name: "Steps per snack", description: "How many steps it takes for the pokemon to eat 1 snack", type: .uint)
]

let oasisPokespotTable = CommonStructTable(index: .PokespotOasis, properties: GoDStruct(name: "Pokespot Oasis", format: pokespotPokemonStructFormat))
let rockPokespotTable = CommonStructTable(index: .PokespotRock, properties: GoDStruct(name: "Pokespot Rock", format: pokespotPokemonStructFormat))
let cavePokespotTable = CommonStructTable(index: .PokespotCave, properties: GoDStruct(name: "Pokespot Cave", format: pokespotPokemonStructFormat))
let allPokespotsTable = CommonStructTable(index: .PokespotAll, properties: GoDStruct(name: "Pokespot All", format: pokespotPokemonStructFormat))

let pokespotStruct = GoDStruct(name: "Pokespot", format: [
	.word(name: "Unknown Flag 1", description: "", type: .flagID),
	.word(name: "Unknown Flag 2", description: "", type: .flagID),
	.word(name: "Unknown Flag 3", description: "", type: .flagID),
	.word(name: "Unknown Flag 4", description: "", type: .flagID),
	.word(name: "Unknown Flag 5", description: "", type: .flagID),
	.word(name: "Unknown Flag 6", description: "", type: .flagID),
	.word(name: "Unknown Flag 7", description: "", type: .flagID),
	.word(name: "Unknown Pointer", description: "Filled in at run time, 0 in the ROM data", type: .pointer),
])

let pokespotsTable = CommonStructTable(index: .pokespots, properties: pokespotStruct)
