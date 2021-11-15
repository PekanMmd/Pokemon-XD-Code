//
//  PokemonModelsTable.swift
//  GoD Tool
//
//  Created by Stars Momodu on 03/05/2021.
//

import Foundation

let bonesStruct = GoDStruct(name: "Model Bones", format: [
	.byte(name: "Damage 1", description: "The bonoe to use for certain effects when this pokemon takes a hit", type: .uint),
	.byte(name: "Mouth", description: "", type: .uint),
	.byte(name: "Left Eye", description: "", type: .uint),
	.byte(name: "Right Eye", description: "", type: .uint),
	.byte(name: "Root 1", description: "", type: .uint),
	.byte(name: "Left Arm", description: "", type: .uint),
	.byte(name: "Right Arm", description: "", type: .uint),
	.byte(name: "Left Foot", description: "", type: .uint),
	.byte(name: "Right Foot", description: "", type: .uint),
	.byte(name: "Center", description: "", type: .uint),
	.byte(name: "Unknown 1", description: "Usually called 'ct_all_move'", type: .uint),
	.byte(name: "Head", description: "", type: .uint),
	.byte(name: "Right Hand", description: "", type: .uint),
	.byte(name: "Right Foot 2", description: "", type: .uint),
	.byte(name: "Root 2", description: "", type: .uint),
	.byte(name: "Root 3", description: "", type: .uint),
	.byte(name: "Root 4", description: "", type: .uint),
	.byte(name: "Root 5", description: "", type: .uint),
	.byte(name: "Root 6", description: "", type: .uint),
	.byte(name: "Damage 2", description: "", type: .uint),
	.byte(name: "Unknown 2", description: "Usually called 'direct_set'", type: .uint),
	.byte(name: "Unknown 3", description: "Usually called 'ct_move'", type: .uint),
	.byte(name: "Unknown 4", description: "Usually called 'ct_bust_move'", type: .uint),
	.byte(name: "Unknown 5", description: "Usually called 'ct_all'", type: .uint),
	.byte(name: "Unknown 6", description: "Usually called 'ct_all_move'", type: .uint),
])

let animationTypesStruct = GoDStruct(name: "Model Animation Types", format: [
	.byte(name: "Battle Idle", description: "", type: .uint),
	.byte(name: "Special Move", description: "", type: .uint),
	.byte(name: "Physical Move", description: "", type: .uint),
	.byte(name: "Punch 1", description: "", type: .uint),
	.byte(name: "Kick", description: "", type: .uint),
	.byte(name: "Fly Into Air", description: "", type: .uint),
	.byte(name: "Dive From Air", description: "", type: .uint),
	.byte(name: "Punch 2", description: "", type: .uint),
	.byte(name: "Take Damage", description: "", type: .uint),
	.byte(name: "Faint", description: "", type: .uint),
	.byte(name: "Hover In Air", description: "", type: .uint),
	.byte(name: "Unknown Idle 2", description: "", type: .uint),
	.byte(name: "Unknown Idle 3", description: "", type: .uint),
	.byte(name: "Unknown Idle 4", description: "", type: .uint),
	.byte(name: "Unknown Idle 5", description: "", type: .uint),
	.byte(name: "Unknown Idle 6", description: "", type: .uint),
	.byte(name: "Status Move", description: "", type: .uint),
	.byte(name: "Running", description: "", type: .uint),
	.byte(name: "Summary Screen Idle", description: "", type: .uint),
	.byte(name: "Blink", description: "", type: .uint),
	.byte(name: "Sleeping", description: "", type: .uint),
	.byte(name: "Woke up", description: "", type: .uint),

])

let pokemonModelsStruct = GoDStruct(name: "Pokemon Model", format: [
	.bitMask(name: "Parameters", description: "", length: .char, values: [
		(name: "Size", type: .uint, numberOfBits: 11, firstBitIndexLittleEndian: 5, mod: nil, div: nil, scale: nil),
		(name: "Is Female Alt", type: .bool, numberOfBits: 1, firstBitIndexLittleEndian: 2, mod: nil, div: nil, scale: nil),
	]),
	.array(name: "Padding", description: "", property: .byte(name: "", description: "", type: .uintHex), count: 3),
	.word(name: "Fsys ID", description: "", type: .fsysID),
	.word(name: "Model File ID", description: "", type: .uintHex),
	.word(name: "Shiny Model File ID", description: "", type: .uintHex),
	.float(name: "Running Speed", description: ""),
	.short(name: "Pokemon Species", description: "", type: .pokemonID),
	.short(name: "Padding", description: "", type: .null),
	.byte(name: "Form ID", description: "", type: .uint),
	.subStruct(name: "Bones", description: "Determines which of the model's bones are used for certain types of effects like a hand bone to use for eeffects on punching moves. For models which don't have that exact type of body part use the closes approximation.", property: bonesStruct),
	.subStruct(name: "Bones", description: "Determines which of the model's animations to use for different scenarios like its idle animation or its running animation", property: animationTypesStruct),
])

let pokemonModelsTable = CommonStructTable(file: .indexAndFsysName(region == .JP ? 12 : 6, "common"), properties: pokemonModelsStruct, documentByIndex: false) { (index, data) -> String? in
	if let pokemonID: Int = data.get("Pokemon Species") {
		return XGPokemon.index(pokemonID).name.unformattedString
	}
	return "Pokemon Model"
}
