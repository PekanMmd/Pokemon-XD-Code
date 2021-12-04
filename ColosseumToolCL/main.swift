//
//  main.swift
//  ColosseumToolCL
//
//  Created by The Steez on 27/08/2018.
//
//

import Foundation

ToolProcess.loadISO(exitOnFailure: true)

//var documentedText = "- Unused text in Pokemon Colosseum (US) - \n\n"
//
//let interactionPoints = XGInteractionPointData.allValues
//var interactionIDs = interactionPoints.map { (point) -> Int? in
//	switch point.info {
//	case .Text(let msgID): return msgID
//	default: return nil
//	}
//}
//
//for folder in XGFolders.ISOExport("").subfolders {
//	if let _ = XGMaps(rawValue: folder.name.substring(from: 0, to: 2)) {
//		printg(folder.path)
//		let script = XGFiles.nameAndFolder(folder.name + ".scd", folder).scriptData.getXDSScript()
//		let msg = XGFiles.nameAndFolder(folder.name + ".msg", folder).stringTable
//
//		let usedIDs = script.subStringsMatching("\\$:([0-9]+):".regex()!).map { $0.replacingOccurrences(of: "$", with: "").replacingOccurrences(of: ":", with: "").integerValue }
//		for msgID in msg.stringIDs {
//			if !usedIDs.contains(msgID) && !interactionIDs.contains(msgID) {
//				documentedText +=  msg.stringSafelyWithID(msgID).stringPlusIDAndFile + "\n\n"
//			}
//		}
//	}
//}
//
//documentedText.save(toFile: .nameAndFolder("Colosseum Unused Text.txt", .Documents))

//let editedCommon = XGFiles.nameAndFolder("common.rel", .Documents).data!
//let originalCommon = XGFiles.common_rel.data!
//for pokemon in XGPokemonStats.allValues {
//	let startOffset = pokemon.startOffset
//	let evolutionData = originalCommon.getSubDataFromOffset(startOffset + kFirstEvolutionOffset, length: kSizeOfEvolutionData * 5)
//	editedCommon.replaceData(data: evolutionData, atOffset: startOffset + kFirstEvolutionOffset)
//}
//editedCommon.save()

//PDADumper.dumpData()
//PDADumper.dumpFiles(writeTextures: false)
//PDADumper.dumpMSG()

//let ecardFile = XGFiles.nameAndFolder("13-A005-decoded.bin", .Documents)
//let ePokemonTable = EreaderStructTable(type: .pokemon, inFile: ecardFile)
//let eTrainersTable = EreaderStructTable(type: .trainers, inFile: ecardFile)
//
//for table in [ePokemonTable, eTrainersTable] {
//	table.documentCStruct()
//	table.documentData()
//	table.encodeCSVData()
//}

//let baseName = "kamikudaku_damage"
//let fsys = XGFiles.fsys("wzx_" + baseName)
////XGUtility.exportFileFromISO(fsys)
//let wzx = XGFiles.nameAndFsysName(baseName + ".wzx", fsys.fileName)
////let wzxData = WZXModel(file: wzx)
////wzxData?.datModelOffsets.forEach {
////	printg($0)
////}
//let dat = XGFiles.nameAndFolder(wzx.fileName.removeFileExtensions() + "_0.wzx.dat", wzx.folder)
//if let datData = DATModel(file: dat) {
////	datData.description.println()
//	datData.nodes?.vertexColours.keys.forEach({ (k) in
//		let v = datData.nodes!.vertexColours[k]!
//		printg(v.hexString)
//	})
//	let profile = datData.nodes!.vertexColourProfile
//	profile.writePNGData(toFile: .nameAndFolder("kamikudaku_profile.png", .Documents))
//	GoDFiltersManager.Filters.shiftRedMinor.apply(to: profile)
//	profile.writePNGData(toFile: .nameAndFolder("kamikudaku_profile red.png", .Documents))
//}

//let numberOfPokemon = CommonIndexes.NumberOfPokemon.value
//CommonIndexes.NumberOfPokemon.setValue(1000)
//common.expandSymbolWithIndex(CommonIndexes.PokemonStats.index, by: (1000 - numberOfPokemon) * kSizeOfPokemonStats)
//common.data.save()
//XGUtility.importFileToISO(.fsys("common"))
//XGUtility.exportFileFromISO(.fsys("common"))


//pokemonStatsTable.encodeCSVData()
//movesTable.encodeCSVData()
//naturesTable.encodeCSVData()
//shadowPokemonTable.encodeCSVData()

//printg("-- Expansion --")
//rel.expandSymbolWithIndex(100, by: 0x30, save: true)
//printPointersInfo()

//PDADumper.dumpAll()

//let table = try? XGStringTable.fromJSONFile(file: .nameAndFolder("common3.json", .Documents))
//let allShadows = CMShadowData.allValues.map { (data) -> String in
//	return table!.stringSafelyWithID(data.nameID).string
//}
//table?.allStrings().forEach { (string) in
//	if string.string.substring(from: 0, to: 2) == "DP" && !string.string.contains("エクストラ") && string.string.length > 4 {
//		let monName = string.string
//		if !allShadows.contains(monName) {
//			printg(monName)
//		}
//	}
//}

// Create shadow pokemon table data for bulbapedia
//for mon in CMShadowData.allValues where mon.species.index > 0 {
//	let firstTID = mon.firstTID
//	let trainer = XGTrainer(index: firstTID)
//	let data = trainer.pokemon.first { (data) -> Bool in
//		mon.species.index == data.species.index
//	}!
//	let battle = trainer.battleData!
//	printg("{{lop/shadow|\(mon.species.stats.nationalIndex)|\(mon.species.name.unformattedString.capitalized)|\(data.level)|-|\(data.shadowCatchRate)|\(mon.purificationCounter/10),000|Shadow Rush|XD|\(data.moves[1].name.unformattedString.titleCased)|\(data.moves[1].type.originalName)|\(data.moves[2].name.unformattedString.titleCased)|\(data.moves[2].type.originalName)|\(data.moves[3].name.unformattedString.titleCased)|\(data.moves[3].type.originalName)|Colo|\(trainer.trainerClass.name.unformattedString.titleCased)|\(trainer.name.unformattedString.titleCased)|[[\(battle.battleField.room!.mapName.titleCased)]]|pure1=\(data.moves[0].name.unformattedString.titleCased)|pure1t=\(data.moves[0].type.originalName)|link=\(trainer.name.unformattedString.titleCased)}}")
//}
//printg("{{lop/shadow|175|Togepi|20|-|N/A|N/A|Shadow Rush|XD|Charm|Normal|Sweet Kiss|Normal|Yawn|Normal|Colo|Chaser|ボデス|[[Card e Room]] (Japanese games only)|pure1=Metronome|pure1t=Normal}}")
//printg("{{lop/shadow|179|Mareep|37|-|N/A|N/A|???|Shadow Rush|XD|ThunderShock|Electric|Thunder Wave|Electric|Cotton Spore|Grass|Colo|Hunter|ホル|[[Card e Room]] (Japanese games only)|pure1=Thunder|pure1t=Electric}}")
//printg("{{lop/shadow|212|Scizor|50|-|N/A|N/A|???|Shadow Rush|XD|Metal Claw|Steel|Swords Dance|Normal|Slash|Normal|Colo|Bodybuilder|ワーバン|[[Card e Room]] (Japanese games only)|pure1=Fury Cutter|pure1t=Bug}}")

//CommonIndexes.TrainerAIData.startOffset.hexString().println()

//XGUtility.documentMacrosXDS()

//let file = XGFiles.common_rel //XGFiles.typeAndFsysName(.scd, "M1_out")
//let script = file.scriptData
//script.getXDSScript().save(toFile: .nameAndFolder(file.fileName + ".cms", .nameAndFolder("Scripts", .Documents)))

//XGMaps.allCases.reversed().forEach { (map) in
//	if case .Pokespot = map {
//		return
//	}
//	let files = XGISO.current.allFileNames.filter { (name) -> Bool in
//		name.contains(map.code)
//	}
//	files.forEach { (filename) in
//		if let fileData = XGISO.current.dataForFile(filename: filename) {
//			let fsys = XGFsys(data: fileData)
//			let folder = XGFolders.ISOExport(filename.removeFileExtensions())
//			fsys.extractFilesToFolder(folder: folder, decode: false)
//			let scriptFile = XGFiles.typeAndFolder(.scd, folder)
//			if scriptFile.exists {
//				scriptFile.scriptData.getXDSScript().save(toFile: .nameAndFolder(scriptFile.fileName + ".cms", .nameAndFolder("Scripts", .Documents)))
//			}
//		}
//	}
//}

//CommonIndexes.TrainerPokemonData.startOffset.hexString().println()

//
//func fixShinyGlitch() {
//	guard let getPlayerTrainerDataFunctionPointer = XGAssembly.ASMfreeSpaceRAMPointer() else {
//		printg("Couldn't find free space in Start.dol")
//		return
//	}
//	let coloShinyGlitchSetTrainerIDRAMOffset = 0x1f9e1c // colo us
//	let getTrainerDataForTrainerFunction = 0x129280 // colo us
//	let setPokemonTIDOffset = 0x80123f78 // colo us
//	let trainerGetValueWithIndexFunction = 0x8012a5b0 // colo us
//
//	// Creates a function which returns a pointer to the player's trainer data
//	// so we can get it any time with 1 bl instruction
//	XGAssembly.replaceRamASM(RAMOffset: getPlayerTrainerDataFunctionPointer, newASM: [
//		.stwu(.sp, .sp, -0x10),
//		.mflr(.r0),
//		.stw(.r0, .sp, 0x14),
//
//		.li(.r3, 0),
//		.li(.r4, 2),
//		.bl(getTrainerDataForTrainerFunction),
//		
//		.lwz(.r0, .sp, 0x14),
//		.mtlr(.r0),
//		.addi(.sp, .sp, 0x10),
//		.blr
//	])
//	// Get the player's trainer data where it would normally have got the opponent's
//	XGAssembly.replaceRamASM(RAMOffset: coloShinyGlitchSetTrainerIDRAMOffset, newASM: [
//		.bl(getPlayerTrainerDataFunctionPointer)
//	])
//
//	// extend the function which sets the TID for generated trainer pokemon
//	// so it gets the player's TID instead of the NPC's
//	guard let setTIDUpdateOffset = XGAssembly.ASMfreeSpaceRAMPointer() else {
//		printg("Couldn't find free space in Start.dol. The shiny glitch fix implementation was only partly complete so there may be some issues.")
//		return
//	}
//	XGAssembly.replaceRamASM(RAMOffset: setPokemonTIDOffset, newASM: [
//		.b(setTIDUpdateOffset)
//	])
//	XGAssembly.replaceRamASM(RAMOffset: setTIDUpdateOffset, newASM: [
//		.bl(getPlayerTrainerDataFunctionPointer), // get player trainer data
//		// get trainer id
//		.li(.r4, 2),
//		.li(.r5, 0),
//		.bl(trainerGetValueWithIndexFunction),
//		.mr(.r30, .r3), // put tid in register that will be used later for setting TID
//
//		// instruction that was overwritten by branch
//		.mr(.r3, .r26),
//		// branch back
//		.b(setPokemonTIDOffset + 4)
//	])
//
//	XGISO.current.importFiles([.dol])
//}
//
//func setNPCPokemonShininess(to: XGShinyValues, shadowsOnly: Bool = true) {
//	let shinyLockRAMOffset = 0x801fa3e8 // colo us
//	let shadowsOnlyLockRAMOffset = 0x801fa3d8 // colo us
//	let battlePokemonCheckIfShadowFunctionTAMPointer = 0x8011fc74 // colo us
//	if shadowsOnly {
//		guard let branchToOffset = XGAssembly.ASMfreeSpaceRAMPointer() else {
//			printg("Couldn't find free space in Start.dol")
//			return
//		}
//		XGAssembly.replaceRamASM(RAMOffset: shadowsOnlyLockRAMOffset, newASM: [
//			.b(branchToOffset),
//			.mr(.r3, .r31),
//			.mr(.r4, .r29),
//			.mr(.r5, .r28),
//			.mr(.r7, .r25)
//		])
//		XGAssembly.replaceRamASM(RAMOffset: branchToOffset, newASM: [
//			// pokemon data pointer in r31. check if shadow pokemon and set r6 to shininess value only if shadow, otherwise 0
//
//		])
//	} else {
//		XGAssembly.replaceRamASM(RAMOffset: shinyLockRAMOffset, newASM: [
//			.li(.r6, to.rawValue)
//		])
//	}
//}
//
//fixShinyGlitch()
//setNPCPokemonShininess(to: .always)


//XGAssembly.replaceRamASM(RAMOffset: 0x1f9f78, newASM: [
//	.stwu(.sp, .sp, -0x84),
//	.mflr(.r0),
//	.lis(.r7, 0x8028),
//	.lis(.r6, 0x8028),
//	.stw(.r0, .sp, 0x88),
//	.stmw(.r18, .sp, 0x4c)
//])
//
//XGAssembly.replaceRamASM(RAMOffset: 0x1fa4a0, newASM: [
//	.lmw(.r18, .sp, 0x4c),
//	.lwz(.r0, .sp, 0x88),
//	.mtlr(.r0),
//	.addi(.sp, .sp, 132)
//])
//
//XGAssembly.replaceRamASM(RAMOffset: 0x1fa15c, newASM: [
//	.b(0x2446a0)
//])
//
//XGAssembly.replaceRamASM(RAMOffset: 0x1fc928, newASM: [
//	.lha(.r3, .r3, 0x12)
//])
//
//XGAssembly.replaceRamASM(RAMOffset: 0x2446a0, newASM: [
//	.mr(.r29, .r3),
//	.mr(.r3, .r28),
//	.bl(0x1fca2c),
//	.lha(.r18, .r3, 0x10),
//	.b(0x801fa160)
//])
//
//XGAssembly.replaceRamASM(RAMOffset: 0x1fa3e8, newASM: [
//	.mr(.r6, .r18)
//])



//let gciFile = XGFiles.nameAndFolder("GC6E_pokemon_colosseum.gci", .Documents)
//let saveFile = XGFiles.nameAndFolder("GC6E_pokemon_colosseum.gci.raw", .Documents)
//let saveManager = XGSaveManager(file: gciFile, saveType: .gciSaveData)
//if let save = saveManager.latestSaveSlot {
//	for i in 0 ... 5 {
//		let mon = save.readPokemon(slot: .pc(box: 0, index: i))
//		XGSave.XGSavePokemonSlot.pc(box: 0, index: i).offset.hexString().println()
//		mon.name.println()
//		let copyMon = save.readPokemon(slot: .pc(box: 0, index: i + 12))
//		copyMon.name.println()
//		save.writePokemon(copyMon, to: .pc(box: 0, index: i))
//		save.readPokemon(slot: .pc(box: 0, index: i)).name.println()
//	}
//}
//saveManager.save()

//let gciFile = XGFiles.nameAndFolder("pokemon_colosseum_save.gci", .Documents)
//let saveFile = XGFiles.nameAndFolder("pokemon_colosseum_save.raw", .Documents)
//let saveManager = XGSaveManager(file: saveFile, saveType: .decryptedSaveSlot)
//if let save = saveManager.latestSaveSlot {
//	let registeredParty = (0 ... 5).map { (index) -> XGSavePokemon in
//		return save.readPokemon(slot: .battleMode(partyIndex: 0, index: index))
//	}
//	(10 ... 15).forEach { (boxSlot) in
//		let pcSlot = XGSave.XGSavePokemonSlot.pc(box: 0, index: boxSlot)
//		let registeredSlot = registeredParty[boxSlot - 10]
//		let mon = save.readPokemon(slot: pcSlot)
//		printg(boxSlot)
//		mon.copyFrom(registeredSlot)
//		save.writePokemon(mon, to: pcSlot)
//	}
//}
//saveManager.save()
//GoDShellManager.run(.gcitool, args: "replace \(gciFile.path) \(saveFile.path)", printOutput: true)


//let saveFile = XGFiles.nameAndFolder("pokemon_colosseum_save.raw", .Documents)
//let saveManager = XGSaveManager(saveType: .decryptedSaveSlot(data: saveFile.data!))
//let save = saveManager.saveSlots[0]
//save.playerName.println()
//for i in 0 ..< 6 {
//	print("party",i)
//	let slot = XGSave.XGSavePokemonSlot.party(index: i)
//	save.readPokemon(slot: slot).name.println()
//}
//print("")
//for i in 0 ..< 3 {
//	for j in 0 ..< 30 {
//		print("box",i,"slot",j)
//		let slot = XGSave.XGSavePokemonSlot.pc(box: i, index: j)
//		save.readPokemon(slot: slot).name.println()
//	}
//}
//print("")
//for i in 0 ..< 2 {
//	for j in 0 ..< 6 {
//		print("registered party",i,"slot",j)
//		let slot = XGSave.XGSavePokemonSlot.battleMode(partyIndex: i, index: j)
//		save.readPokemon(slot: slot).name.println()
//	}
//}

//let scdFile = XGFiles.scd("M1_out")
//let script = XGScript(file: scdFile)
//XGUtility.saveString(script.description, toFile: .nameAndFolder(scdFile.fileName + ".txt", .Documents))

//var seenIDs = [Int]()
//for mon in XGDecks.DeckStory.allActivePokemon where mon.isShadow {
//    if !seenIDs.contains(mon.shadowID) {
//        seenIDs.append(mon.shadowID)
//        if mon.species.catchRate != mon.shadowCatchRate {
//            print(mon.species.name, mon.species.catchRate, mon.shadowCatchRate)
//        }
//    }
//}

//let p = common.allPointers()
//for i in 0 ..< p.count {
//	printg(i, p[i].hexString())
//}

//for file in XGFolders.Documents.files where file.fileName.contains("pkx") {
//	file.fsysData.extractFilesToFolder(folder: .Documents)
//}




