//
//  PokemonTable.swift
//  GoD Tool
//
//  Created by Stars Momodu on 25/03/2021.
//

import Foundation

let TMProperties = (1 ... 50).map {
	return GoDStructProperties.byte(name: "TM\(String(format: "%02d", $0)) " +  XGTMs.tm($0).move.name.unformattedString, description: "", type: .bool)
}

let HMProperties = (1 ... 8).map {
	return GoDStructProperties.byte(name: "HM\(String(format: "%02d", $0)) " +  XGTMs.tm($0 + 50).move.name.unformattedString, description: "", type: .bool)
}

#if GAME_XD
let tutorProperties = (1 ... 12).map {
	return GoDStructProperties.byte(name: "TutorMove\(String(format: "%02d", $0)) " +  XGTMs.tutor($0).move.name.unformattedString, description: "", type: .bool)
}
#endif

let statsStructShort = GoDStruct(name: "Stats", format: [
	.short(name: "HP", description: "", type: .uint),
	.short(name: "Attack", description: "", type: .uint),
	.short(name: "Defense", description: "", type: .uint),
	.short(name: "Sp.Atk", description: "", type: .uint),
	.short(name: "Sp.Def", description: "", type: .uint),
	.short(name: "Speed", description: "", type: .uint)
])
let statsStructByte = GoDStruct(name: "Byte Stats", format: [
	.byte(name: "HP", description: "", type: .uint),
	.byte(name: "Attack", description: "", type: .uint),
	.byte(name: "Defense", description: "", type: .uint),
	.byte(name: "Sp.Atk", description: "", type: .uint),
	.byte(name: "Sp.Def", description: "", type: .uint),
	.byte(name: "Speed", description: "", type: .uint)
])

let evolutionStruct = GoDStruct(name: "Evolution", format: [
	.byte(name: "Evolution Method", description: "", type: .evolutionMethod),
	.short(name: "Evolution Condition", description: "", type: .uintHex),
	.short(name: "Evolved Form", description: "", type: .pokemonID)
])

let levelUpMoveStruct = GoDStruct(name: "Level Up Move", format: [
	.byte(name: "Level", description: "", type: .uint),
	.short(name: "Move", description: "", type: .moveID)
])

let spritesStruct = GoDStruct(name: "Pokemon Sprites", format: [
	.byte(name: "Pokeon Dex Colour ID", description: "", type: .uintHex),
	.short(name: "Face ID", description: "The index of the image for the pokemon's face", type: .indexOfEntryInTable(table: pokeFacesTable, nameProperty: nil)),
	.word(name: "Purify Chamber Image ID", description: "File identifier for the animated texture", type: .fsysFileIdentifier(fsysName: nil))
])

#if GAME_XD
let pokemonStatsStruct = GoDStruct(name: "Pokemon Stats", format: [
	.byte(name: "Level up Rate", description: "Determines how much exp it takes for the pokemon to level up", type: .expRate),
	.byte(name: "Catch Rate", description: "", type: .uint),
	.byte(name: "Gender Ratio", description: "", type: .genderRatio),
	.short(name: "Exp yield", description: "Determines how much exp you get for defeating this pokemon species", type: .uint),
	.short(name: "Base Happiness", description: "Default happiness when this pokemon is caught", type: .uintHex),
	.short(name: "Height", description: "Height in meters x10", type: .int),
	.short(name: "Weight", description: "Weight in kg x10", type: .int),
	.short(name: "Cry ID", description: "", type: .uintHex),
	.short(name: "National Dex Index", description: "", type: .uint),
	.short(name: "Unknown 1", description: "Something sound related", type: .uintHex),
	.short(name: "Unknown 2", description: "Same as national id?", type: .uintHex),
	.short(name: "Unknown 3", description: "", type: .uintHex),
	.word(name: "Name ID", description: "", type: .msgID(file: .common_rel)),
	.word(name: "Species Name ID", description: "The species name used in the pokedex entry", type: .msgID(file: .typeAndFsysName(.msg, "pda_menu"))),
	.word(name: "Unknown 2", description: "unused?", type: .uintHex),
	.word(name: "Unknown 3", description: "", type: .uintHex),
	.word(name: "Unknown 4", description: "", type: .uintHex),
//	.word(name: "Model ID", description: "", type: .indexOfEntryInTable(table: pkxFsysIdentifiers, nameProperty: nil))
	.word(name: "Model ID", description: "", type: .pkxPokemonID),
	.array(name: "Types", description: "", property:
			.byte(name: "Type", description: "", type: .typeID), count: 2),
	.array(name: "Abilities", description: "", property:
			.byte(name: "Ability", description: "", type: .abilityID), count: 2),
	]
	+ TMProperties + HMProperties + tutorProperties
	+ [
		.array(name: "Wild Items", description: "The Items pokemon of this species may hold when encountered in the wild", property:
			.short(name: "Wild Item", description: "", type: .itemID), count: 2),
		.array(name: "Egg Moves", description: "", property:
			.short(name: "Egg Move", description: "", type: .moveID), count: 8),
		.subStruct(name: "Base Stats", description: "", property: statsStructShort),
		.subStruct(name: "EV Yields", description: "The EVs given for defeating this pokemon species", property: statsStructShort),
		.array(name: "Evolutions", description: "", property:
			.subStruct(name: "Evolution", description: "", property: evolutionStruct), count: 5),
		.array(name: "Level Up Moves", description: "", property:
			.subStruct(name: "Level Up Move", description: "", property: levelUpMoveStruct), count: 19),
		.word(name: "Padding", description: "", type: .null),
		.subStruct(name: "Regular Sprites", description: "", property: spritesStruct),
		.subStruct(name: "Shiny Sprites", description: "", property: spritesStruct)
	]
)
#else
let pokemonStatsStruct = GoDStruct(name: "Pokemon Stats", format: [
	.byte(name: "Level up Rate", description: "Determines how much exp it takes for the pokemon to level up", type: .expRate),
	.byte(name: "Catch Rate", description: "", type: .uint),
	.byte(name: "Gender Ratio", description: "", type: .genderRatio),
	.byte(name: "Unknown", description: "", type: .uint),
	.byte(name: "Unknown Value", description: "", type: .uintHex),
	.short(name: "Exp yield", description: "Determines how much exp you get for defeating this pokemon species", type: .uint),
	.short(name: "Base Happiness", description: "Default happiness when this pokemon is caught", type: .uintHex),
	.short(name: "Height", description: "Height in meters x10", type: .int),
	.short(name: "Weight", description: "Weight in kg x10", type: .int),
	.short(name: "Cry ID", description: "", type: .uintHex),
	.short(name: "National Dex Index", description: "", type: .uint),
	.short(name: "Unknown 2", description: "Same as national id?", type: .uintHex),
	.short(name: "Unknown 3", description: "", type: .uintHex),
	.short(name: "Unknown 4", description: "", type: .uintHex),
	.word(name: "Name ID", description: "", type: .msgID(file: .common_rel)),
	.word(name: "Species Name ID", description: "The species name used in the pokedex entry", type: .msgID(file: .typeAndFsysName(.msg, "pda_menu"))),
	.word(name: "Unknown 2", description: "unused?", type: .uintHex),
	.word(name: "Unknown 3", description: "", type: .uintHex),
	.word(name: "Unknown 4", description: "", type: .uintHex),
	.word(name: "Model ID", description: "", type: .pkxPokemonID),
	.array(name: "Types", description: "", property:
			.byte(name: "Type", description: "", type: .typeID), count: 2),
	.array(name: "Abilities", description: "", property:
			.byte(name: "Ability", description: "", type: .abilityID), count: 2),
	]
	+ TMProperties + HMProperties
	+ [
		.array(name: "Egg Groups", description: "", property:
				.byte(name: "Egg Group", description: "", type: .eggGroup), count: 2),
		.array(name: "Wild Items", description: "The Items pokemon of this species may hold when encountered in the wild", property:
			.short(name: "Wild Item", description: "", type: .itemID), count: 2),
		.array(name: "Egg Moves", description: "", property:
			.short(name: "Egg Move", description: "", type: .moveID), count: 8),
		.subStruct(name: "Base Stats", description: "", property: statsStructShort),
		.subStruct(name: "EV Yields", description: "The EVs given for defeating this pokemon species", property: statsStructShort),
		.array(name: "Evolutions", description: "", property:
			.subStruct(name: "Evolution", description: "", property: evolutionStruct), count: 5),
		.array(name: "Level Up Moves", description: "", property:
			.subStruct(name: "Level Up Move", description: "", property: levelUpMoveStruct), count: 19),
		.word(name: "Padding", description: "", type: .null),
		.subStruct(name: "Regular Sprites", description: "", property: spritesStruct),
		.subStruct(name: "Shiny Sprites", description: "", property: spritesStruct)
	]
)
#endif

let pokemonTable = CommonStructTable(index: .PokemonStats, properties: pokemonStatsStruct)
