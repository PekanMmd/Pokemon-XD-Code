//
//  main.swift
//  Revolution Tool
//
//  Created by The Steez on 24/12/2018.
//

import Foundation

//let moves = PBRDataTable.moves

// Expand pokemon tables

let icons = PBRDataTable.pokemonIcons
let models = PBRDataTable.pokemonModels
let baseStats = PBRDataTable.pokemonBaseStats
let bodies = PBRDataTable.pokemonBodies
let faces = PBRDataTable.pokemonFaces
let levelUpMoves = PBRDataTable.levelUpMoves
let evolutions = PBRDataTable.evolutions

let model = XGFiles.nameAndFolder("tr_dpgirl_10.sdr", .ISOExport("tr_dpgirl_10"))

//for table in [icons, models, baseStats, bodies, faces, levelUpMoves, evolutions] {
//	print(table.numberOfEntries.hexString())
//}

//let charizard = pokemon("charizard")
//
//for _ in 1 ... 1500 {
//	let newSpeciesIndex = baseStats.numberOfEntries
//	let newModelIndex = models.numberOfEntries
//	let newIconsIndex = icons.numberOfEntries
//
//	let charizardIcons = icons.entryWithIndex(charizard.baseIndex - 1)!.data.duplicated()
//
//	let charizardModels = models.entryWithIndex(charizard.stats.firstModelIndex)!.data.duplicated()
//	charizardModels.replace2BytesAtOffset(20, withBytes: newSpeciesIndex)
//
//	let charizardStats = baseStats.entryWithIndex(charizard.baseIndex)!.data.duplicated()
//	charizardStats.replace2BytesAtOffset(28, withBytes: newModelIndex)
//
//	let charizardFaces = faces.entryWithIndex(charizard.baseIndex)!.data.duplicated()
//	charizardFaces.replace2BytesAtOffset(2, withBytes: newSpeciesIndex)
//	charizardFaces.replace2BytesAtOffset(4, withBytes: newIconsIndex)
//
//	let charizardBodies = bodies.entryWithIndex(charizard.baseIndex)!.data.duplicated()
//	charizardBodies.replace2BytesAtOffset(2, withBytes: newSpeciesIndex)
//	charizardBodies.replace2BytesAtOffset(4, withBytes: newIconsIndex)
//
//	let charizardMoves = levelUpMoves.entryWithIndex(charizard.baseIndex)!.data.duplicated()
//	let charizardEvos = evolutions.entryWithIndex(charizard.baseIndex)!.data.duplicated()
//
//	icons.addEntry(data: charizardIcons)
//	models.addEntry(data: charizardModels)
//	baseStats.addEntry(data: charizardStats)
//	faces.addEntry(data: charizardFaces)
//	bodies.addEntry(data: charizardBodies)
//	levelUpMoves.addEntry(data: charizardMoves)
//	evolutions.addEntry(data: charizardEvos)
//}
//
//icons.save()
//models.save()
//baseStats.save()
//faces.save()
//bodies.save()
//levelUpMoves.save()
//evolutions.save()


//// replace rental pass mons with pokemon 1234
//let deck = XGDecks.rentalpasses
//for mon in deck.pokemon {
//	let data = mon.data
//	data.species = .pokemon(1234)
//	data.save()
//}

//XGDolPatcher.overrideHardcodedPokemonCount(newCount: PBRDataTable.pokemonBaseStats.numberOfEntries)
//XGDolPatcher.disableRentalPassChecksums()
//XGUtility.compileMainFiles()
//XGUtility.compileISO()



