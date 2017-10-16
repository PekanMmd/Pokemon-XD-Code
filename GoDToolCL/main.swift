//
//  main.swift
//  XGCommandLineTools
//
//  Created by StarsMmd on 13/11/2015.
//  Copyright © 2015 StarsMmd. All rights reserved.
//



//XGUtility.compileCommonRel()
//XGUtility.compileDol()

//let dragonTailRoutine = XGAssembly.routineRegularHitOpenEnded() + [
//	// roar
//	0x00, 0x1f, 0x12, 0x15, 0x80, 0x41, 0x7a, 0x7f, 0x90, 0x80, 0x41, 0x5c, 0xb4,
//]
//
//let uturnRoutine = XGAssembly.routineRegularHitOpenEnded() + [
//	// baton pass
//	0x77, 0x11, 0x07, 0x51, 0x11, 0x80, 0x41, 0x5c, 0xb4, 0xe1, 0x11, 0x3b, 0x52, 0x11, 0x02, 0x59, 0x11, 0x4d, 0x11, 0x4e, 0x11, 0x02, 0x74, 0x11, 0x14, 0x80, 0x2f, 0x90, 0xe0, 0x4f, 0x11, 0x01, 0x13, 0x00, 0x00, 0x3b, 0x53, 0x11, 0x29, 0x80, 0x41, 0x41, 0x0f,
//]
//
//let shadowGiftRoutine = [0x00, 0x02, 0x04, 0x50, 0x11, 0x80, 0x41, 0x5c, 0x93, 0x00, 0x0a, 0x0b, 0x04, 0x77, 0x11, 0x07, 0x51, 0x11, 0x80, 0x41, 0x5c, 0x93, 0xe1, 0x11, 0x3b, 0x52, 0x11, 0x02, 0x59, 0x11, 0x4d, 0x11, 0x4e, 0x11, 0x01, 0x74, 0x11, 0x14, 0x80, 0x2f, 0x90, 0xe0, 0x4f, 0x11, 0x01, 0x13, 0x00, 0x00, 0x3b, 0x53, 0x11, 
//// branch cosmic power boosts
//0x29, 0x80, 0x41, 0x66, 0xa6,]
//
//let skillSwap = [0x00, 0x02, 0x04, 0x01, 0x80, 0x41, 0x5c, 0x93, 0xff, 0xff, 0xd9, 0x80, 0x41, 0x5c, 0x93, 0x0a, 0x0b, 0x04, 0x0a, 0x0b, 0x00, 0x11, 0x00, 0x00, 0x4e, 0xd2, 0x13, 0x00, 0x60, 0x0b, 0x04, 0x53, 0x11, 0x53, 0x12, 0x29, 0x80, 0x41, 0x41, 0x0f,]
//
//let shadowAnalysisRoutine = XGAssembly.routineRegularHitOpenEnded() + [0xa4, 0x80, 0x41, 0x5c, 0xb4, 0x11, 0x00, 0x00, 0x4e, 0xa0, 0x13, 0x00, 0x60, 0x0b, 0x04, 0x29, 0x80, 0x41, 0x41, 0x0f,]
//

//let shadowFreezeRoutine =  [0x00, 0x02, 0x04, 0x1e, 0x12, 0x00, 0x00, 0x00, 0x14, 0x80, 0x41, 0x5c, 0x93, 0x1d, 0x12, 0x00, 0x00, 0x00, 0x07, 0x80, 0x41, 0x5e, 0xb9, 0x23, 0x12, 0x0f, 0x80, 0x41, 0x5c, 0xc6, 0x1f, 0x12, 0x28, 0x80, 0x41, 0x5e, 0x81, 0x1f, 0x12, 0x2f, 0x80, 0x41, 0x5e, 0x81, 0x1f, 0x12, 0x31, 0x80, 0x41, 0x5e, 0x81, 0x1d, 0x12, 0x00, 0x00, 0x00, 0x01, 0x80, 0x41, 0x5c, 0x93, 0x01, 0x80, 0x41, 0x5c, 0x93, 0x00, 0x00, 0x20, 0x12, 0x00, 0x4b, 0x80, 0x41, 0x6d, 0xb2, 0x0a, 0x0b, 0x04, 0x2f, 0x80, 0x4e, 0x85, 0xc3, 0x04, 0x17, 0x0b, 0x04, 0x29, 0x80, 0x41, 0x41, 0x0f,]

//let routines : [(effect: Int, routine: [Int], offset: Int)] = [
//	
//	(28,dragonTailRoutine, 0x0),
//	(57, uturnRoutine, 0x0),
//	(213, shadowGiftRoutine, 0x0),
//	(191, skillSwap, 0x0),
//	(122, shadowAnalysisRoutine, 0x0),
//	
//	(55, XGAssembly.routineForMultipleStatBoosts(RAMOffset: 0x0, boosts: [(stat: XGStats.accuracy, stages: XGStatStages.plus_1), (stat: XGStats.attack, stages: XGStatStages.plus_1)], animate: true), 0x0), // hone claws
//	
//	(56, XGAssembly.routineForMultipleStatBoosts(RAMOffset: 0x0, boosts: [(stat: XGStats.special_attack, stages: XGStatStages.plus_1), (stat: XGStats.special_defense, stages: XGStatStages.plus_1), (stat: XGStats.speed, stages: XGStatStages.plus_1)], animate: true), 0x0), // quiver dance
//	
//	(61, XGAssembly.routineForMultipleStatBoosts(RAMOffset: 0x0, boosts: [(stat: XGStats.attack, stages: XGStatStages.plus_1), (stat: XGStats.defense, stages: XGStatStages.plus_1), (stat: XGStats.accuracy, stages: XGStatStages.plus_1)], animate: true), 0x0), // coil
//	
//	(135, XGAssembly.routineForMultipleStatBoosts(RAMOffset: 0x0, boosts: [(stat: XGStats.speed, stages: XGStatStages.plus_1), (stat: XGStats.evasion, stages: XGStatStages.plus_1),], animate: true), 0x0), // shadow haste
//	
//	(203, XGAssembly.routineForMultipleStatBoosts(RAMOffset: 0x0, boosts: [(stat: XGStats.attack, stages: XGStatStages.plus_1), (stat: XGStats.speed, stages: XGStatStages.plus_2),], animate: true), 0x0), // shift gear
//	
//	(154, XGAssembly.routineForMultipleStatBoosts(RAMOffset: 0x0, boosts: [(stat: XGStats.attack, stages: XGStatStages.plus_1), (stat: XGStats.accuracy, stages: XGStatStages.plus_2),], animate: true), 0x0), // shadow focus
//	
//	(74, XGAssembly.routineForMultipleStatBoosts(RAMOffset: 0x0, boosts: [(stat: XGStats.attack, stages: XGStatStages.plus_2), (stat: XGStats.special_attack, stages: XGStatStages.plus_2), (stat: XGStats.speed, stages: XGStatStages.plus_2), (stat: XGStats.defense, stages: XGStatStages.minus_1), (stat: XGStats.special_defense, stages: XGStatStages.minus_1)], animate: true), 0x0), // shell smash
//	
//	(163, XGAssembly.routineForMultipleStatBoosts(RAMOffset: 0x0, boosts: [(stat: XGStats.attack, stages: XGStatStages.plus_1), (stat: XGStats.defense, stages: XGStatStages.plus_1), (stat: XGStats.speed, stages: XGStatStages.plus_1), (stat: XGStats.special_attack, stages: XGStatStages.plus_1), (stat: XGStats.special_defense, stages: XGStatStages.plus_1)], animate: true), 0x0), // latent power
//	
//	(145, XGAssembly.routineForMultipleStatBoosts(RAMOffset: 0x0, boosts: [(stat: XGStats.evasion, stages: XGStatStages.minus_1), (stat: XGStats.special_defense, stages: XGStatStages.plus_3)], animate: true), 0x0), // shadow barrier
//	
//	(63, XGAssembly.routineForSingleStatBoost(stat: .defense, stages: .plus_3), 0x0), // cotton guard
//	
//	(64, XGAssembly.routineForSingleStatBoost(stat: .special_attack, stages: .plus_3), 0x0), // tail glow
//	
//	(96, XGAssembly.routineHitWithSecondaryEffect(effect: 0x51), 0x0), // flame charge
//	
//	(110, XGAssembly.routineHitWithSecondaryEffect(effect: 0xd8), 0x0), // hammer arm
//	
//	(131, XGAssembly.routineHitAndStatChange(routineOffsetRAM: 0x0, boosts: [(stat: XGStats.defense, stages: XGStatStages.minus_1), (stat: XGStats.special_defense, stages: XGStatStages.minus_1)]), 0x0), // close combat
//	
//	(184, XGAssembly.routineHitAndStatChange(routineOffsetRAM: 0x0, boosts: [(stat: XGStats.defense, stages: XGStatStages.minus_1), (stat: XGStats.special_defense, stages: XGStatStages.minus_1), (stat: XGStats.speed, stages: XGStatStages.minus_1)]), 0x0), // v-create
//	
//	(141, XGAssembly.routineHitWithSecondaryEffect(effect: 0x53), 0x0), // charge beam
//	
//	(93, XGAssembly.routineHitAllWithSecondaryEffect(effect: 0x18), 0x0), // bulldoze
//	
//	(34, XGAssembly.routineHitAllWithSecondaryEffect(effect: 0x03), 0x0), // lava plume
//	
//	(81, XGAssembly.routineHitAllWithSecondaryEffect(effect: 0x05), 0x0), // discharge
//	
//	(88, XGAssembly.routineHitAllWithSecondaryEffect(effect: 0x02), 0x0), // sludge wave
//	
//	(162, shadowFreezeRoutine, 0x0), // shadow freeze
//	
//	
//	
//]
//
//var currentOffset = XGAssembly.ASMfreeSpacePointer()
//for routine in routines {
//	
//	// run firs to generate offsets
//	print("effect \(routine.effect) - \(currentOffset.hexString())")
//	currentOffset += routine.routine.count
//	
////	// fill in offsets then run this to actually add them
////	XGAssembly.setMoveEffectRoutine(effect: routine.effect, fileOffset: routine.offset - kRELtoRAMOffsetDifference, moveToREL: true, newRoutine: routine.routine)
//	
//	
//}



//XGUtility.compileMainFiles()
//XGUtility.compileForRelease(XG: true)


//XGUtility.compileMainFiles()

//XGUtility.importTextures()
//XGUtility.exportTextures()

//let bingotex = XGFiles.texture("uv_str_bingo_00.fdat")
//XGFiles.nameAndFolder("bingo_menu.fsys", .MenuFSYS).fsysData.replaceFile(file: bingotex.compress())


//XGUtility.compileForRelease(XG: true)
















