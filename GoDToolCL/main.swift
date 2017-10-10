//
//  main.swift
//  XGCommandLineTools
//
//  Created by StarsMmd on 13/11/2015.
//  Copyright © 2015 StarsMmd. All rights reserved.
//

//XGUtility.replaceMartItemAtOffset(1108, withItem: .item(0xdc))

//// spiky shield 1 (replaces endure effect)
//XGAssembly.replaceASM(startOffset: 0x223514 - kDOLtoRAMOffsetDifference, newASM: [0x28000113])
//XGAssembly.replaceASM(startOffset: 0x223570 - kDOLtoRAMOffsetDifference, newASM: [kNopInstruction])
//XGAssembly.replaceASM(startOffset: 0x2235dc - kDOLtoRAMOffsetDifference, newASM: [kNopInstruction,kNopInstruction])
//let endureRemove = 0x21607c - kDOLtoRAMOffsetDifference
//XGAssembly.replaceASM(startOffset: endureRemove, newASM: [kNopInstruction,kNopInstruction,kNopInstruction,kNopInstruction,kNopInstruction])
//XGAssembly.replaceASM(startOffset: 0x2160d8 - kDOLtoRAMOffsetDifference, newASM: [0x48000030])
//
////rocky helmet & spiky shield 2
//let rockyBranch = 0x2250bc
//let rockyStart = 0xb993cc
//
//let checkStatus = 0x2025f0
//let getMoveEffectiveness = 0x1f0684
//let getItem = 0x20384c
//
//let getHPFraction = 0x203688
//let storeHP = 0x13e094
//let animSoundCallBack = 0x2236a8
//let clearEffectiveness = 0x1f06d8
//
//let rockyCode : ASM = [
//	
//	// check contact
//	0x28190001, // cmpwi r25, 1
//	XGAssembly.powerPCBranchEqualFromOffset(from: 0x0, to: 0x8), // beq 8
//	XGAssembly.createBranchFrom(offset: 0x8, toOffset: 0x88),
//	
//	// check spiky shield (status 44)
//	0x7fe3fb78, // mr	r3, r31 (defending mon)
//	0x3880002c, // li   r4, spiky shield (originally endure flag)
//	XGAssembly.createBranchAndLinkFrom(offset: rockyStart + 0x14, toOffset: checkStatus),
//	0x28030001, // cmpwi r3, 1
//	XGAssembly.powerPCBranchNotEqualFromOffset(from: 0x1c, to: 0x48),
//	
//	// check protected
//	0x7e439378, // mr	r3, r18 move routine pointer
//	0x38800040, // li	r4, 64 (protected)
//	XGAssembly.createBranchAndLinkFrom(offset: rockyStart + 0x28, toOffset: getMoveEffectiveness),
//	0x28030001, // cmpwi r3, 1
//	XGAssembly.powerPCBranchEqualFromOffset(from: 0x0, to: 0x8),
//	XGAssembly.createBranchFrom(offset: 0x0, toOffset: 0x14),
//	0x7e439378, // mr	r3, r18 move routine pointer
//	0x38800040, // li r4, failed (rough skin won't work if the move failed)
//	XGAssembly.createBranchAndLinkFrom(offset: rockyStart + 0x40, toOffset: clearEffectiveness),
//	XGAssembly.createBranchFrom(offset: 0x44, toOffset: 0x64),
//	
//	// check failed
//	0x281a0001, // cmpwi r26, 1
//	XGAssembly.powerPCBranchEqualFromOffset(from: 0x0, to: 0x8),
//	XGAssembly.createBranchFrom(offset: 0x50, toOffset: 0x88),
//	
//	// check item rocky helmet (hold item id 77)
//	0x7fe3fb78, // mr	r3, r31 (defending mon)
//	XGAssembly.createBranchAndLinkFrom(offset: rockyStart + 0x58, toOffset: getItem),
//	0x2803004d, // cmplwi	r3, rocky helmet
//	XGAssembly.powerPCBranchNotEqualFromOffset(from: 0x60, to: 0x88),
//	
//	// rough skin code
//	0x7fc3f378, // mr	r3, r30 (attacking mon)
//	0x38800006, // li r4, 6
//	XGAssembly.createBranchAndLinkFrom(offset: rockyStart + 0x6c, toOffset: getHPFraction),
//	0x5464043e, // rlwinm	r4, r3, 0, 16, 31 (0000ffff)
//	0x7e439378, // mr	r3, r18
//	XGAssembly.createBranchAndLinkFrom(offset: rockyStart + 0x78, toOffset: storeHP),
//	0x3c608041, // lis	r3, 0x8041
//	0x38637be1, // addi	r3, r3, 31713
//	XGAssembly.createBranchAndLinkFrom(offset: rockyStart + 0x84, toOffset: animSoundCallBack),
//	
//	0x7fc3f378, // mr	r3, r30 (overwritten code)
//	XGAssembly.createBranchFrom(offset: rockyStart + 0x8c, toOffset: rockyBranch + 0x4),
//]
//XGAssembly.replaceASM(startOffset: rockyBranch - kDOLtoRAMOffsetDifference, newASM: [XGAssembly.createBranchFrom(offset: rockyBranch, toOffset: rockyStart)])
//XGAssembly.replaceRELASM(startOffset: rockyStart - kRELtoRAMOffsetDifference, newASM: rockyCode)
//

//// learnable SMs
//let lsms = [
//	[0], // shadow rush
//	[0], // shadow pulse
//	[0], // shadow bully
//	[20,31,34,57,62,68,76,83,94,99,101,108,115,125,126,127,143,184,185,210,214,217,289,287,320,321,324,336,340,345,343,347,366,378,391,410,413], // shadow max
//	[413,410,406,380,376,378,347,345,338,337,330,331,322,316,315,312,307,304,305,303,302,301,299,300,289,287,286,283,284,285,282,281,280,279,278,277,264,250,249,241,237,234,232,231,228,229,215,212,207,203,200,198,197,193,190,189,184,183,176,169,168,166,164,150,149,142,141,133,134,135,136,128,127,126,125,124,123,121,120,119,106,107,101,94,93,92,89,88,85,83,77,78,59,57,56,53,51,42,37,38,28,27,26,25,22,20,18,15,12,], // shadow stealth
//	[0], // shadow sky
//	[410,409,408,407,394,386,387,379,378,376,363,362,349,348,347,345,329,322,319,317,312,303,302,292,265,264,249,233,206,203,201,202,200,198,197,196,178,176,175,169,166,164,150,144,137,196,124,122,121,103,94,80,73,65,64,55,49,38,12,], // shadow madness
//	[0], // shadow guard
//]
//
//for i in 1 ..< kNumberOfPokemon {
//	let mon = XGPokemon.pokemon(i).stats
//	
//	for j in [3,4,6]{
//		
//		mon.learnableTMs[50 + j] = lsms[j].contains(i) || (i == 151)
//		
//	}
//	
//	for j in [0,1,2,5,7] {
//		mon.learnableTMs[50 + j] = mon.index != 251
//	}
//	
//	mon.save()
//}


//let sms = ["Shadow Rush","Shadow Pulse","Shadow Bully","Shadow Max","Shadow Stealth","Shadow Sky","Shadow Madness","Shadow Guard"]
//for i in 0 ... 7 {
//	let sm = XGTMs.tm(51 + i)
//	sm.replaceWithMove(move(sms[i]))
//}

//for i in 0 ..< 8 {
//	let cd = XGItem(index: i + 0x164)
//	let sm = XGItem(index: i + 0x153)
//	sm.nameID = cd.nameID
//	sm.friendshipEffects = [129,129,129]
//	sm.save()
//}

//for i in 0x1b4 ... 0x1bb {
//	let item = XGItem(index: i)
//	item.nameID = 0
//	item.save()
//}
//let key = XGItem(index: 0x15e)
//for i in 0x153 ... 0x15a {
//	let sm = XGItem(index: i)
//	sm.descriptionID = key.descriptionID
//	sm.save()
//}
//key.descriptionID = 0
//key.save()


//XGUtility.compileCommonRel()
//XGUtility.compileAllFiles()

// shadow terrain residual healing to 1/10
//XGAssembly.replaceASM(startOffset: 0x227ae8 - kDOLtoRAMOffsetDifference, newASM: [0x3880000A])

// regular moves doe 75% damage in shadow terrain
//XGAssembly.replaceASM(startOffset: 0x22a62c - kDOLtoRAMOffsetDifference, newASM: [
//	0x1C160003, // mulli	r0, r22, 3
//	0x7C001670, // srawi	r0, r0,2
//])

//// shadow terrain residual hp healing for shadow pokemon
//let terrainBranch = 0x227ac8 //(ram)
//let terrainStart = 0xb99388
//
//let healTrue = 0x227ad4
//let healFalse = 0x227b0c
//
//let checkField = 0x1f3824
//let checkShadow = 0x149014
//
//let terrainCode : ASM = [
// 
//	0x28030001, // cmpwi r3, 1 (overwritten check for ingrain)
//	XGAssembly.powerPCBranchNotEqualFromOffset(from: 0x0, to: 0x8),
//	XGAssembly.createBranchFrom(offset: terrainStart + 0x8, toOffset: healTrue),
//	
//	0x38600000, // li r3, 0
//	0x38800038, // li r4, 56
//	XGAssembly.createBranchAndLinkFrom(offset: terrainStart + 0x14, toOffset: checkField),
//	0x5460043f, // rlwinm.	r0, r3, 0, 16, 31 (0000ffff)
//	XGAssembly.powerPCBranchNotEqualFromOffset(from: 0x0, to: 0x8),
//	XGAssembly.createBranchFrom(offset: terrainStart + 0x20, toOffset: healFalse),
//	
//	0x7fe3fb78, // mr r3, r31 (battle pokemon)
//	// get stats pointer
//	0x80630000, // lwz	r3, 0 (r3)
//	0x38630004, // addi	r3, r3, 4
//	
//	XGAssembly.createBranchAndLinkFrom(offset: terrainStart + 0x30, toOffset: checkShadow),
//	0x28030001, // cmpwi r3, 1
//	XGAssembly.powerPCBranchNotEqualFromOffset(from: 0x0, to: 0x8),
//	XGAssembly.createBranchFrom(offset: terrainStart + 0x3c, toOffset: healTrue),
//	XGAssembly.createBranchFrom(offset: terrainStart + 0x40, toOffset: healFalse),
//	
//]
//
//XGAssembly.replaceASM(startOffset: terrainBranch - kDOLtoRAMOffsetDifference, newASM: [XGAssembly.createBranchFrom(offset: terrainBranch, toOffset: terrainStart),kNopInstruction])
//XGAssembly.replaceRELASM(startOffset: terrainStart - kRELtoRAMOffsetDifference, newASM: terrainCode)

////Sand rush
//let sandstart = 0x2009c0
//let sinstructions : ASM = [
//	0x5464043e, // rlwinm	r4, r3, 0, 16, 31 (0000ffff)
//	0x28170021, // cmpwi r23, swift swim
//	0x41820020, // beq 0x20
//	0x28170022, // cmpwi r23, chlorophyll
//	0x41820024, // beq 0x24
//	0x2817005b, // cmpwi r23, sand rush
//	0x40820028, // bne 0x28
//	0x281C0003, // cmpwi r28, sandstorm
//	0x4182001C, // beq 0x1c
//	0x4800001C, // b 0x1c
//	0x281C0002, // cmpwi r28, rain
//	0x41820010, // beq 0x10
//	0x48000010, // b 0x10
//	0x281C0001, // cmpwi r28, sun
//	0x40820008  // bne 0x8
//]
//XGAssembly.replaceASM(startOffset: sandstart, newASM: sinstructions)


//let espeon = pokemon("espeon").stats
//espeon.learnableTMs[10] = true
//espeon.save()


//let mantine = XGPokemon.pokemon(226).stats
//let tms = [1,4,5,9,10,14,28,38,39,41,45,46,47,49]
//let tut = [2,3,4,8,10,11]
//for i in 1 ... 12 {
//	mantine.tutorMoves[i - 1] = tut.contains(i)
//}
//for i in 1 ... 50 {
//	mantine.tutorMoves[i - 1] = tms.contains(i)
//}
//mantine.save()

//XGUtility.compileMainFiles()
//XGUtility.compileForRelease(XG: true)


//XGUtility.compileMainFiles()

//XGUtility.importTextures()
//XGUtility.exportTextures()

//let bingotex = XGFiles.texture("uv_str_bingo_00.fdat")
//XGFiles.nameAndFolder("bingo_menu.fsys", .MenuFSYS).fsysData.replaceFile(file: bingotex.compress())


//XGUtility.compileForRelease(XG: true)


















