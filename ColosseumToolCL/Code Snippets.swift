//
//  Code Snippets.swift
//  GoD Tool
//
//  Created by Stars Momodu on 22/01/2022.
//

//// AR Code for
//// Pokemon colosseum US, pokemon evolve every to a random species every level
//
//// return level 1 for all evolution conditions
//let evolutionConditionLookup = 0x11e3b4
//var code = XGAssembly.geckoCode(RAMOffset: evolutionConditionLookup, asm: [
//	.li(.r3, 1),
//	.blr
//])
//
//// return level up for all evolution methods
//let evolutionMethodLookup = 0x11e3fc
//code += XGAssembly.geckoCode(RAMOffset: evolutionMethodLookup, asm: [
//	.li(.r3, XGEvolutionMethods.levelUp.rawValue),
//	.blr
//])
//
//// return random result for evolution target species
//let speciesGetStats = 0x11e778
//let statsGetCatchRate = 0x11e508
//let rollRNG = 0x0e0c54
//let evolutionSpeciesLookup = 0x11e36c
//code += XGAssembly.geckoCode(RAMOffset: evolutionSpeciesLookup, asm: [
//
//	.stwu(.sp, .sp, -32),
//	.mflr(.r0),
//	.stw(.r0, .sp, 36),
//	.stmw(.r30, .sp, 20),
//
//	// get species count - 1 in r31 (-1 so we can remove entry 0 from the rolls by adding 1 later)
//	.lwz(.r31, .r13, -0x7890),
//	.lwz(.r31, .r31, 0),
//	.subi(.r31, .r31, 1),
//
//	.label("loop start"),
//
//	// get rng
//	.bl(rollRNG),
//	] +
//	// mod rng by species count
//	XGASM.mod(.r30, .r3, .r31)
//	+ [
//
//	// add 1 to result to exclude entry 0
//	.addi(.r30, .r30, 1),
//
//	// preserve rng roll in r30
//	.mr(.r3, .r30),
//
//	// get species catch rate
//	.bl(speciesGetStats),
//	.bl(statsGetCatchRate),
//
//	// if catch rate == 0 then loop
//	.cmpwi(.r3, 0),
//	.beq_l("loop start"),
//	.b(evolutionConditionLookup + 8)
//])
//
//code += XGAssembly.geckoCode(RAMOffset: evolutionConditionLookup + 8, asm: [
//	.mr(.r3, .r30),
//
//	.lmw(.r30, .sp, 20),
//	.lwz(.r0, .sp, 36),
//	.mtlr(.r0),
//	.addi(.sp, .sp, 32),
//	.blr
//])
//
//print(code)


// Expand symbol
//let numberOfPokemon = CommonIndexes.NumberOfPokemon.value
//CommonIndexes.NumberOfPokemon.setValue(1000)
//common.expandSymbolWithIndex(CommonIndexes.PokemonStats.index, by: (1000 - numberOfPokemon) * kSizeOfPokemonStats)
//common.data.save()
//XGUtility.importFileToISO(.fsys("common"))
//XGUtility.exportFileFromISO(.fsys("common"))

//printg("-- Expansion --")
//rel.expandSymbolWithIndex(100, by: 0x30, save: true)
//printPointersInfo()

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

// Move animation recolouring

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


