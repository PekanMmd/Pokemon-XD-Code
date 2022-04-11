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
		statusEffectsTable
	]

	#if GAME_XD
	tables += [
		wzxTable
	]
	#else
	tables += [
		validItemsTable,
		validItemsTable2,
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
		XGDemoStarterPokemon.self,
		CMGiftPokemon.self
	]

	#if GAME_XD
	tables += [
		XGStarterPokemon.self,
		XGTradePokemon.self,
		XGTradeShadowPokemon.self,
		XGMtBattlePrizePokemon.self,
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
		SoundsTable,
		pokemonStatsTable,
		pokeFacesTable

	]

	#if GAME_COLO
	let coloTables: [GoDStructTableFormattable] = [
		shadowPokemonTable,
		battleStylesTable,
		trainerAITable,
		battleTypesTable,
		aiWeightEffectsTable,
		pokemonAIRolesTable
	]
	tables += coloTables
	#elseif GAME_XD
	let xdTables: [GoDStructTableFormattable] = [
		battleBingoTable,
		oasisPokespotTable,
		rockPokespotTable,
		cavePokespotTable,
		pokespotsTable,
		allPokespotsTable,
		battleCDsTable,
		battleLayoutsTable,
		itemsTable,
		flagsTable,
		tutorMovesTable,
		mirorBDataTable,
		typesTable,
		SoundsMetaDataTable,
		worldMapLocationsTable,
		msgPalettesTable
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

var saveFileStructList: [GoDStructTableFormattable] {
//	guard game == .Colosseum else { return  [] }
	XGFolders.SaveFiles.files.forEach { (file) in
		if file.fileType == .gci {
			if !XGFolders.SaveFiles.contains(.nameAndFolder(file.fileName + ".raw", XGFolders.SaveFiles)) {
				_ = XGSaveManager(file: file, saveType: .gciSaveData)
			}
		}
	}
	var tables = [GoDStructTableFormattable]()
	XGFolders.SaveFiles.files.filter({$0.fileType == .raw}).sorted(by: {$0.fileName < $1.fileName}).forEach { (file) in
		if let saveData = XGSaveManager(file: file, saveType: .decryptedSaveSlot).latestSaveSlot {
			tables.append(saveData.partyPokemonTable())
			tables += saveData.pcBoxPokemonTables()
			#if GAME_XD
			tables += saveData.purifyChamberxPokemonTables()
			#endif
			tables.append(saveData.pcItemStorageTable())
		}
	}
	return tables
}

#if GAME_COLO
var eReaderStructList: [GoDStructTableFormattable] {
	guard game == .Colosseum else { return  [] }
	XGFolders.Decrypted.files.forEach { (file) in
		if file.fileType == .bin {
			let decodedFile = XGFiles.nameAndFolder(file.fileName, XGFolders.Decoded)
			if !XGFolders.Decoded.contains(decodedFile) {
				EcardCoder.decode(file: file)?.writeToFile(decodedFile)
			}
		}
	}
	var tables = [GoDStructTableFormattable]()
	XGFolders.Decoded.files.filter({$0.fileType == .bin}).sorted(by: {$0.fileName < $1.fileName}).forEach { (file) in
		if let data = file.data, data.getByteAtOffset(3) == 0 {
			tables.append(EreaderStructTable(type: .pokemon, inFile: file))
			tables.append(EreaderStructTable(type: .trainers, inFile: file))
		}
	}
	return tables
}
#endif
