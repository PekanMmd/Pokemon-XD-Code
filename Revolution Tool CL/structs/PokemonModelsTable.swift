//
//  PokemonModelsTable.swift
//  GoD Tool
//
//  Created by Stars Momodu on 03/05/2021.
//

import Foundation

let pokemonModelsStruct = GoDStruct(name: "Pokemon Model", format: [
	.byte(name: "Unknown 1", description: "", type: .uintHex),
	.array(name: "Unknown 0xD0s", description: "", property: .byte(name: "", description: "", type: .uintHex), count: 3),
	.word(name: "Fsys ID", description: "", type: .fsysID),
	.word(name: "Model File ID", description: "", type: .uintHex),
	.word(name: "Shiny Model File ID", description: "", type: .uintHex),
	.short(name: "Unknown 2", description: "", type: .uintHex),
	.short(name: "Padding", description: "", type: .null),
	.short(name: "Pokemon Species", description: "", type: .pokemonID),
	.short(name: "Padding 2", description: "", type: .null),
	.array(name: "Unknown Values", description: "", property: .byte(name: "", description: "", type: .uintHex), count: 48)
])

let pokemonModelsTable = CommonStructTable(file: .indexAndFsysName(region == .JP ? 12 : 6, "common"), properties: pokemonModelsStruct, documentByIndex: false) { (index, data) -> String? in
	if let pokemonID: Int = data.get("Pokemon Species") {
		return XGPokemon.index(pokemonID).name.unformattedString
	}
	return "Pokemon Model"
}
