//
//  main.swift
//  XGCommandLineTools
//
//  Created by StarsMmd on 13/11/2015.
//  Copyright © 2015 StarsMmd. All rights reserved.
//
//

XGAssembly.ASMfreeSpacePointer().hexString().println()











// sound moves through substitute
//let subJumpBranch = 0x2135ac
////let subJumpStart = 0x0
//let getPokemonPointer = 0x1efcac
//let getCurrentMove = 0x148d64
//let moveGetSoundFlag = 0x13e548
//XGAssembly.replaceASM(startOffset: subJumpBranch - kDOLtoRAMOffsetDifference, newASM: [
//	.b(subJumpStart),
//	.cmpwi(.r3, 1)
//])
//XGAssembly.replaceRELASM(startOffset: subJumpStart - kRELtoRAMOffsetDifference, newASM: [
//	.cmpwi(.r3, 1),
//	.beq_f(0, 8),
//	.b(subJumpBranch + 4),
//	.lwz(.r0, .r31, 2),
//	.cmpwi(.r0, XGStatusEffects.substitute.rawValue),
//	.beq_f(0, 8),
//	.b(subJumpBranch + 4),
//	.li(.r3, 17), // attacking pokemon
//	.li(.r4, 0),
//	.bl(getPokemonPointer),
//	.bl(getCurrentMove),
//	.bl(moveGetSoundFlag),
//	.cmpwi(.r3, 1),
//	.beq_f(0, 0xc),
//	.li(.r3, 1),
//	.b(subJumpBranch + 4),
//	.li(.r3, 0),
//	.b(subJumpBranch + 4),
//
//])
//let subDamageBranch = 0x216054
//let subDamageStart = 0x0
//// current move r28
//
//// set to 0 if sound move
//let subReduceHPBranch = 0x215868
//let subReduceHPStart = 0x0










//XGScriptClass.classes(43).RAMOffset!.hexString().println()
//XGAssembly.getWordAtRamOffsetFromR13(offset: -0x74b0).hexString().println() //number battle types

//let cd = item("Battle CD 01")
//let locations = XGUtility.getItemLocations()
//for i in 1 ... 50 {
//	let cd = XGBattleCD(index: i)
//	let location = locations[cd.getItem().index]
//	printg(i, location.count > 0 ? location[0] : "-", "\n", cd.cdDescription, "\n", cd.conditions, "\n")
//}


