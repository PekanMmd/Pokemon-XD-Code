//
//  StructTablesList.swift
//  GoD Tool
//
//  Created by Stars Momodu on 18/03/2021.
//

import Foundation

let structTablesList: [GoDStructTableFormattable] = {
	var tables: [GoDStructTableFormattable] = [

	]

	return tables.sorted { (t1, t2) -> Bool in
		t1.properties.name < t2.properties.name
	}
}()

let otherTableFormatsList: [GoDCodable.Type] = {
	var tables: [GoDCodable.Type] = [

	]

	return tables.sorted { (t1, t2) -> Bool in
		t1.className < t2.className
	}
}()

var deckTrainerStructList: [GoDStructTableFormattable] {
	let deckFsys = XGFiles.fsys("deck")
	if !deckFsys.exists {
		XGUtility.exportFileFromISO(deckFsys, extractFsysContents: true, decode: false, overwrite: false)
	}
	return deckFsys.folder.files.filter { $0.fileType == .dckt }.sorted(by: {$0.fileName < $1.fileName}).map { $0.structTable }
}

var deckPokemonStructList: [GoDStructTableFormattable] {
	let deckFsys = XGFiles.fsys("deck")
	if !deckFsys.exists {
		XGUtility.exportFileFromISO(deckFsys, extractFsysContents: true, decode: false, overwrite: false)
	}
	return deckFsys.folder.files.filter { $0.fileType == .dckp }.sorted(by: {$0.fileName < $1.fileName}).map { $0.structTable }
}

var deckAIStructList: [GoDStructTableFormattable] {
	return []
//	let deckFsys = XGFiles.fsys("deck")
//	if !deckFsys.exists {
//		XGUtility.exportFileFromISO(deckFsys, extractFsysContents: true, decode: false, overwrite: false)
//	}
//	return deckFsys.folder.files.filter { $0.fileType == .dcka }.sorted(by: {$0.fileName < $1.fileName}).map { $0.structTable }
}

var commonStructTablesList: [GoDStructTableFormattable] = {
	return [
		pokemonStatsTable,
		levelUpMovesTable,
		evolutionsTable,
		moveStatsTable,
		itemStatsTable,
		pokecouponShopTable,
		pokemonModelsTable,
		experienceTable,
		iconsTable,
		pokemonFacesTable,
		pokemonBodiesTable
	].sorted { (t1, t2) -> Bool in
		return t1.properties.name < t2.properties.name
	}
}()
