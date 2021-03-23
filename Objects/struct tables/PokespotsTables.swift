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
