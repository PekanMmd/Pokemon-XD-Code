//
//  StructTablesList.swift
//  GoD Tool
//
//  Created by Stars Momodu on 18/03/2021.
//

import Foundation

var structTablesList: [GoDStructTableFormattable] {
	var tables: [GoDStructTableFormattable] = [
		abilitiesTable,
		texturesTable,
		TMsTable,
		pkxTrainerModelsTable,
		pkxPokemonModelsTable,
	]

	#if GAME_XD
	tables += [
		wzxTable,
	]
	#else
	tables += [
		validItemsTable,
		itemsTable,
		typesTable,
	]
	#endif

	return tables.sorted { (t1, t2) -> Bool in
		t1.properties.name < t2.properties.name
	}
}

var otherTableFormatsList: [GoDCodable.Type] {
	var tables: [GoDCodable.Type] = [
		XGDemoStarterPokemon.self
	]

	#if GAME_XD
	tables += [
		XGStarterPokemon.self
	]
	#endif

	return tables.sorted { (t1, t2) -> Bool in
		t1.className < t2.className
	}
}

var commonStructTablesList: [GoDStructTableFormattable] {
	var tables: [GoDStructTableFormattable] = [
		treasureTable,
		battlesTable,
		battlefieldsTable,
		characterModelsTable,
		interactionPointsTable,
		movesTable,
		naturesTable,
		trainerClassesTable,
		peopleTable,
		multipliersTable,
		doorsTable,
		roomsTable,
		pokemonTable,
		pokeFacesTable
	]

	#if GAME_COLO
	let coloTables: [GoDStructTableFormattable] = [

	]
	tables += coloTables
	#elseif GAME_XD
	let xdTables: [GoDStructTableFormattable] = [
		battleBingoTable,
		typesTable,
		oasisPokespotTable,
		rockPokespotTable,
		cavePokespotTable,
		allPokespotsTable,
		battleCDsTable,
		battleLayoutsTable,
		itemsTable,
		flagsTable,
//		SoundsMetaDataTable,
		SoundsTable,
		tutorMovesTable,
	]
	tables += xdTables
	#endif

	return tables.sorted { (t1, t2) -> Bool in
		t1.properties.name < t2.properties.name
	}
}

var deckTrainerStructList: [GoDStructTableFormattable] {
	#if GAME_XD
	let deckFsys = XGFiles.fsys("deck_archive")
	if !deckFsys.exists {
		XGUtility.exportFileFromISO(deckFsys, extractFsysContents: true, decode: false, overwrite: false)
	}
	return TrainerDecksArray.map {
		return DeckTrainerStructTable(deck: $0)
	}
	#else
	return [
		trainersTable
	]
	#endif
}

var deckPokemonStructList: [GoDStructTableFormattable] {
	#if GAME_XD
	let deckFsys = XGFiles.fsys("deck_archive")
	if !deckFsys.exists {
		XGUtility.exportFileFromISO(deckFsys, extractFsysContents: true, decode: false, overwrite: false)
	}
	return TrainerDecksArray.map {
		return DeckPokemonStructTable(deck: $0)
	} + [shadowPokemonTable]
	#else
	return [
		trainerPokemonTable
	]
	#endif
}

var deckAIStructList: [GoDStructTableFormattable] {
	#if GAME_XD
	let deckFsys = XGFiles.fsys("deck_archive")
	if !deckFsys.exists {
		XGUtility.exportFileFromISO(deckFsys, extractFsysContents: true, decode: false, overwrite: false)
	}
	return TrainerDecksArray.map {
		return DeckAIStructTable(deck: $0)
	}
	#else
	return []
	#endif
}
