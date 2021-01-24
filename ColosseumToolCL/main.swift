//
//  main.swift
//  ColosseumToolCL
//
//  Created by The Steez on 27/08/2018.
//

for i in 0 ..< CommonIndexes.NumberOfShadowPokemon.value {
	let shadowData = CMShadowData(index: i)
	printg(i, shadowData.species.name.string.spaceToLength(12), shadowData.nameID.hexString(), shadowData.firstTID, shadowData.alternateTID)
}

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




