//
//  main.swift
//  ColosseumToolCL
//
//  Created by The Steez on 27/08/2018.
//
//

loadISO(exitOnFailure: true)

func fixShinyGlitch() {
	guard let getPlayerTrainerDataFunctionPointer = XGAssembly.ASMfreeSpaceRAMPointer() else {
		printg("Couldn't find free space in Start.dol")
		return
	}
	let coloShinyGlitchSetTrainerIDRAMOffset = 0x1f9e1c // colo us
	let getTrainerDataForTrainerFunction = 0x129280 // colo us
	let setPokemonTIDOffset = 0x80123f78 // colo us
	let trainerGetValueWithIndexFunction = 0x8012a5b0 // colo us

	// Creates a function which returns a pointer to the player's trainer data
	// so we can get it any time with 1 bl instruction
	XGAssembly.replaceRamASM(RAMOffset: getPlayerTrainerDataFunctionPointer, newASM: [
		.stwu(.sp, .sp, -0x10),
		.mflr(.r0),
		.stw(.r0, .sp, 0x14),

		.li(.r3, 0),
		.li(.r4, 2),
		.bl(getTrainerDataForTrainerFunction),
		
		.lwz(.r0, .sp, 0x14),
		.mtlr(.r0),
		.addi(.sp, .sp, 0x10),
		.blr
	])
	// Get the player's trainer data where it would normally have got the opponent's
	XGAssembly.replaceRamASM(RAMOffset: coloShinyGlitchSetTrainerIDRAMOffset, newASM: [
		.bl(getPlayerTrainerDataFunctionPointer)
	])

	// extend the function which sets the TID for generated trainer pokemon
	// so it gets the player's TID instead of the NPC's
	guard let setTIDUpdateOffset = XGAssembly.ASMfreeSpaceRAMPointer() else {
		printg("Couldn't find free space in Start.dol. The shiny glitch fix implementation was only partly complete so there may be some issues.")
		return
	}
	XGAssembly.replaceRamASM(RAMOffset: setPokemonTIDOffset, newASM: [
		.b(setTIDUpdateOffset)
	])
	XGAssembly.replaceRamASM(RAMOffset: setTIDUpdateOffset, newASM: [
		.bl(getPlayerTrainerDataFunctionPointer), // get player trainer data
		// get trainer id
		.li(.r4, 2),
		.li(.r5, 0),
		.bl(trainerGetValueWithIndexFunction),
		.mr(.r30, .r3), // put tid in register that will be used later for setting TID

		// instruction that was overwritten by branch
		.mr(.r3, .r26),
		// branch back
		.b(setPokemonTIDOffset + 4)
	])

	XGISO.current.importFiles([.dol])
}

func setNPCPokemonShininess(to: XGShinyValues, shadowsOnly: Bool = true) {
	let shinyLockRAMOffset = 0x801fa3e8 // colo us
	let shadowsOnlyLockRAMOffset = 0x801fa3d8 // colo us
	let battlePokemonCheckIfShadowFunctionTAMPointer = 0x8011fc74 // colo us
	if shadowsOnly {
		guard let branchToOffset = XGAssembly.ASMfreeSpaceRAMPointer() else {
			printg("Couldn't find free space in Start.dol")
			return
		}
		XGAssembly.replaceRamASM(RAMOffset: shadowsOnlyLockRAMOffset, newASM: [
			.b(branchToOffset),
			.mr(.r3, .r31),
			.mr(.r4, .r29),
			.mr(.r5, .r28),
			.mr(.r7, .r25)
		])
		XGAssembly.replaceRamASM(RAMOffset: branchToOffset, newASM: [
			// pokemon data pointer in r31. check if shadow pokemon and set r6 to shininess value only if shadow, otherwise 0

		])
	} else {
		XGAssembly.replaceRamASM(RAMOffset: shinyLockRAMOffset, newASM: [
			.li(.r6, to.rawValue)
		])
	}
}

fixShinyGlitch()
setNPCPokemonShininess(to: .always)


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




