//
//  main.swift
//  Revolution Tool
//
//  Created by The Steez on 24/12/2018.
//

import Foundation

//let moves = PBRDataTable.moves

// Expand pokemon tables

//let icons = PBRDataTable.pokemonIcons
//let models = PBRDataTable.pokemonModels
//let baseStats = PBRDataTable.pokemonBaseStats
//let bodies = PBRDataTable.pokemonBodies
//let faces = PBRDataTable.pokemonFaces
//let levelUpMoves = PBRDataTable.levelUpMoves
//let evolutions = PBRDataTable.evolutions


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


//let stats = XGPokemon.pokemon(1234).stats
//let face = stats.faces[0]
//let data = face.entry
//let newFid = stats.index * 2 + 0x3000
//let newMid = stats.index * 2 + 0x3001
//data.setShort(8, to: newFid)
//data.setShort(0, to: newMid)
//data.save()
//
//let menu_face = XGFiles.fsys("menu_face").fsysData
//let image = XGFiles.nameAndFolder("menu_face 0006.gtx", .Resources)
//menu_face.addFile(image, fileType: .gtx, compress: true, shortID: newMid)
//menu_face.addFile(image, fileType: .gtx, compress: true, shortID: newFid)
//menu_face.save()
//
//XGUtility.compileMainFiles()
//XGUtility.compileISO()
