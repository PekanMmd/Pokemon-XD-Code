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
}()

let commonStructTablesList: [GoDStructTableFormattable] = {
	var tables: [GoDStructTableFormattable] = [

	]

	#if GAME_XD
	let xdTables = [
		battleBingoTable,
		trainerClassesTable,
		oasisPokespotTable,
		rockPokespotTable,
		cavePokespotTable,
		allPokespotsTable
	] as? [GoDStructTableFormattable]
	tables += xdTables ?? []
	#endif

	return tables.sorted { (t1, t2) -> Bool in
		t1.properties.name < t2.properties.name
	}
}()
