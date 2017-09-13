//
//  main.swift
//  XGCommandLineTools
//
//  Created by StarsMmd on 13/11/2015.
//  Copyright © 2015 StarsMmd. All rights reserved.
//

//XGFiles.fsys("fight_common.fsys").fsysData.extractFilesToFolder(folder: .TOC)

XGUtility.exportTextures()

//let deck = XGDecks.DeckStory
//let new = deck.unusedPokemonCount(14)
//
//let species = [12,20,24,40,47,83,108,178,203,206,219,226,289,292,308,312,316,348,349,389]
//
//for i in 0 ... 13 {
//	let dd = XGDeckPokemon.ddpk(108 + i)
//	dd.setDPKMIndexForDDPK(newIndex: new[i].DPKMIndex)
//	let d = dd.data
//	d.shadowAggression = 1
//	d.shadowCounter = 5000
//	d.shadowFleeValue = 0
//	d.level = 60
//	d.shadowCatchRate = 30
//	d.ShadowDataInUse = true
//	d.shadowUnknown2 = XGDeckPokemon.ddpk(80).data.shadowUnknown2
//	d.shadowMoves[0] = move("shadow rush")
//	d.species = .pokemon(species[i])
//	d.moves[0] = move("latent power")
//	d.save()
//}

//let tmList : [[Int]] = [
//	[12,83,178,226,292,312,], // tailwind
//	[20,24,40,108,203,219,289,308,316,349,],	// fire blast
//	[12,20,108,178,203,206,289,292,308,316,348,349,],	// light pulse
//	[12,178,226,292,312,],	// hurricane
//	[12,20,24,47,219,289,389,],	// sludgewave
//	[12,40,108,203,206,292,316,348,349,],	// dazzling gleam
//	[20,24,40,83,108,203,206,289,308,316,],	// foul play
//	[108,203,292,348,349,],	// flash cannon
//	[12,20,24,40,83,108,178,203,206,219,226,289,292,308,312,316,348,349,389,],	// thunder wave
//	[20,40,108,203,206,226,289,308,316,348,],	// ice beam
//	[178,203,219,348,349,],	// will-o-wisp
//	[20,108,203,289,308,316,],	// wild charge
//	[12,178,203,348,349,],	// trick room
//	[226,312,],	// scald
//	[20,24,40,108,203,206,219,289,308,316,349,],	// flamethrower
//	[12,20,24,40,47,83,108,178,203,206,219,289,308,312,316,348,349,389,],	// iron head
//	[20,40,108,203,206,289,308,316,348,349,],	// thunderbolt
//	[316,],	// freeze dry
//	[12,20,24,47,108,206,219,289,292,308,312,316,389,],	// sludgebomb
//	[12,47,108,178,203,206,219,292,312,316,348,349,389,],	// energy ball
//	[12,47,206,292,312,],	// bug buzz
//	[24,206,],	// dragon pulse
//	[20,24,108,289,308,],	// super power
//	[108,203,219,308,348,349,389,],	// earthquake
//	[206,219,348,349,389,],	// earth power
//	[83,178,206,219,349,],	// heat wave
//	[20,40,108,203,206,226,289,308,316,348,],	// blizzard
//	[12,20,24,83,108,203,289,308,316,],	// sucker punch
//	[20,24,47,108,219,289,316,389,],	// gunk shot
//	[12,40,178,203,206,292,312,316,348,349,],	// psyshock
//	[12,20,24,40,108,178,203,206,219,289,308,312,316,348,349,],	// shadow ball
//	[20,108,206,219,289,308,316,348,349,389,],	// rock slide
//	[12,20,40,47,108,203,206,219,289,292,308,316,349,389,],	// solar beam
//	[12,20,40,108,178,203,289,308,316,],	// focus blast
//	[47,83,312,],	// x-scissor
//	[20,40,108,203,206,289,308,316,],	// thunder
//	[12,24,83,178,206,226,289,292,308,312,316,],	// acrobatics
//	[108,226,289,312,316,],	// waterfall
//	[289,],	// dragon claw
//	[],	// toxic all except ditto
//	[20,108,203,219,289,308,316,349,],	// wild flare
//	[12,20,24,47,83,108,206,289,292,308,316,389,],	// poison jab
//	[20,47,83,289,316,],	// night slash
//	[12,40,108,178,203,206,219,226,292,308,312,316,348,349,389,],	// reflect
//	[12,40,108,178,203,206,219,226,292,308,312,316,348,349,389,],	// light screen
//	[40,108,203,226,289,308,312,316,],	// surf
//	[20,219,289,308,348,349,389,],	// stone edge
//	[12,40,108,178,203,206,292,312,316,348,349,],	// psychic
//	[24,108,178,203,289,316,348,349,],	// dark pulse
//
//]
//
//let tutList : [[Int]] = [
//	[], // draco meteor
//	[],	// protect ------------------------------
//	[],	// substitute --------------------------
//	[40,108,308,],	// fire punch
//	[40,108,308,],// thunder punch
//	[40,108,308,],	// ice punch
//	[40,108,203,206,226,289,308,312,348,],	// icy wind
//	[108,203,289,],	// snarl
//	[12,24,40,47,83,108,178,203,219,226,289,292,308,312,348,349,389,],	// taunt
//	[12,24,40,47,83,108,178,203,206,226,289,292,308,312,348,389,], // rain dance
//	[12,24,40,47,83,108,178,203,206,219,289,292,308,312,348,349,389,], // sunny day
//
//]
//
//for i in tmList {
//	for t in i {
//		if t > 415 {
//			print("tm typo: ", i, t)
//		}
//	}
//}
//
//for i in tutList {
//	for t in i {
//		if t > 415 {
//			print("tutor typo: ", i, t)
//		}
//	}
//}
//
//let tmMons = [12,20,24,40,47,83,108,178,203,206,219,226,289,292,308,312,316,348,349,389,]
//
//for tut in 0 ..< tutList.count {
//	for i in tmMons {
//		let mon = XGPokemonStats(index: i)
//
//		if (tut == 2) || (tut == 1) {
//			mon.tutorMoves[tut] = (mon.index != 132) && (mon.index != 398)
//		} else if tut == 0 {
//			mon.tutorMoves[tut] = (mon.type1 == .dragon) || (mon.type2 == .dragon)
//		} else {
//			mon.tutorMoves[tut] = tutList[tut].contains(i)
//		}
//
//		mon.save()
//	}
//}
//
//for tm in 0 ..< tmList.count {
//	for i in tmMons {
//		let mon = XGPokemonStats(index: i)
//
//		if tm == 40 {
//			mon.learnableTMs[tm] = (mon.index != 132) && (mon.index != 398)
//		} else {
//			mon.learnableTMs[tm] = tmList[tm].contains(i)
//		}
//
//		mon.save()
//	}
//}
//
//// copy level up moves
//for (to, from) in [(1,3),(2,3),(7,9),(8,9),(16,18),(17,18),(19,20),(23,24),(30,31),(33,34),(39,40),(41,42),(43,44),(46,47),(50,51),(52,53),(56,57),(58,59),(60,61),(66,67),(74,75),(98,99),(100,101),(109,110),(111,112),(137,233),(152,153),(155,156),(158,159),(163,164),(170,171),(177,178),(179,180),(188,189),(204,205),(209,210),(216,217),(218,219),(288,289),(295,297),(296,297),(309,310),(313,314),(315,316),(318,319),(335,336),(341,343),(342,343),(364,366),(365,366),(370,372),(371,372),(382,384),(383,384),(388,389),(390,391),] {
//	let f = XGPokemonStats(index: from)
//	let t = XGPokemonStats(index: to)
//	t.levelUpMoves = f.levelUpMoves
//	t.learnableTMs = f.learnableTMs
//	t.tutorMoves = f.tutorMoves
//	t.save()
//}


//// shadow pokemon can't be battled after being captured
//let checkCaught = 0x14b024 - kDOLtoRAMOffsetDifference
//
//let shadowBattleBranch1 = 0x1fabf0 - kDOLtoRAMOffsetDifference
//let shadowBattleStart1  = 0x220ed0 - kDOLtoRAMOffsetDifference
//// r20 stored shadow data start
////
//replaceASM(startOffset: shadowBattleBranch1, newASM: [
//	XGUtility.createBranchFrom(offset: shadowBattleBranch1, toOffset: shadowBattleStart1),
//])
//replaceASM(startOffset: shadowBattleStart1, newASM: [
//	0x7e83a378, // mr r3, r20
//	XGUtility.createBranchAndLinkFrom(offset: shadowBattleStart1 + 0x4, toOffset: checkCaught),
//	0x5460063f, //rlwinm.	r0, r3, 0, 24, 31 (000000ff)
//	XGUtility.powerPCBranchEqualFromOffset(from: 0x0, to: 0x8),
//	0x3B200000, // li r25, 0
//	0x7f03c378, // mr r3, r24 (overwritten code)
//	XGUtility.createBranchFrom(offset: shadowBattleStart1 + 0x18, toOffset: shadowBattleBranch1 + 0x4)// branch back
//])

//XGUtility.compileMainFiles()

//let diveballfsys = ["wzx_snatch_attack_dive.fsys","wzx_snatch_ball_land_dive.fsys","wzx_snatch_miss_dive.fsys","wzx_snatch_shake_dive.fsys","wzx_throw_dive.fsys","wzx_yasei_ball_land_dive.fsys","wzx_yasei_get_dive.fsys","wzx_yasei_poke_out_dive.fsys","wzx_yasei_shake_dive.fsys"]
//let diveballfdat = ["snatch_attack_dive.fdat","snatch_ball_land_dive.fdat","snatch_miss_dive.fdat","snatch_shake_dive.fdat","throw_dive.fdat","yasei_ball_land_dive.fdat","yasei_get_dive.fdat","yasei_poke_out_dive.fdat","yasei_shake_dive.fdat"]
//for i in 0 ..< diveballfsys.count {
//	let fsys = XGFiles.fsys(diveballfsys[i]).fsysData
//	let fdat = XGFiles.nameAndFolder(diveballfdat[i], .TextureImporter).compress()
//	fsys.replaceFile(file: fdat)
//}

//let a = XGFiles.nameAndFolder("esaba_A.fsys", .AutoFSYS).fsysData
//let b = XGFiles.nameAndFolder("esaba_B.fsys", .AutoFSYS).fsysData
//let c = XGFiles.nameAndFolder("esaba_C.fsys", .AutoFSYS).fsysData
//
////let ta = XGFiles.stringTable("esaba_A.msg").stringTable
////let tb = XGFiles.stringTable("esaba_B.msg").stringTable
////let tc = XGFiles.stringTable("esaba_C.msg").stringTable
////ta.purge()
////tb.purge()
////tc.purge()
//
//let shedinja = XGFiles.nameAndFolder("shedinja.fdat", .TextureImporter).compress()
//for i in [5,6,7,8,9,10] {
//	a.shiftAndReplaceFileWithIndex(i, withFile: shedinja)
//	c.shiftAndReplaceFileWithIndex(i, withFile: shedinja)
//}
//for i in [5,6,7,8] {
//	b.shiftAndReplaceFileWithIndex(i, withFile: shedinja)
//}
//
//let suicune = XGFiles.nameAndFolder("suikun_ow.fdat", .TextureImporter).compress()
//let entei   = XGFiles.nameAndFolder("entei_ow.fdat", .TextureImporter).compress()
//let raikou  = XGFiles.nameAndFolder("raikou_ow.fdat", .TextureImporter).compress()
//a.shiftAndReplaceFileWithIndex(10, withFile: entei)
//b.shiftAndReplaceFileWithIndex(8, withFile: suicune)
//c.shiftAndReplaceFileWithIndex(10, withFile: raikou)
//
//XGUtility.compileAllFiles()

// ---------------
//let a = XGFiles.nameAndFolder("esaba_A.fsys", .AutoFSYS).fsysData
//let b = XGFiles.nameAndFolder("esaba_B.fsys", .AutoFSYS).fsysData
//let c = XGFiles.nameAndFolder("esaba_C.fsys", .AutoFSYS).fsysData
//let shedinja = XGFiles.nameAndFolder("nukenin_ow.fdat", .TextureImporter).compress()
//for i in [5,6,10] {
//	a.replaceFileWithIndex(i, withFile: shedinja)
//	c.replaceFileWithIndex(i, withFile: shedinja)
//}
//for i in [5,6,8] {
//	b.replaceFileWithIndex(i, withFile: shedinja)
//}
//
//for file in [a,b,c] {
//	file.shiftUpFileWithIndex(index: 2)
//}
//for i in 5 ... 10 {
//	a.shiftUpFileWithIndex(index: i)
//	c.shiftUpFileWithIndex(index: i)
//	if i < 9 {
//		b.shiftUpFileWithIndex(index: i)
//	}
//}
//let suicune = XGFiles.nameAndFolder("suikun_ow.fdat", .TextureImporter).compress()
//let entei   = XGFiles.nameAndFolder("entei_ow.fdat", .TextureImporter).compress()
//let raikou  = XGFiles.nameAndFolder("raikou_ow.fdat", .TextureImporter).compress()
//a.replaceFileWithIndex(10, withFile: entei)
//b.replaceFileWithIndex(8, withFile: suicune)
//c.replaceFileWithIndex(10, withFile: raikou)

//let x = a.sizeForFile(index: 10)
//let y = a.startOffsetForFile(10)
//x.string.println()
//y.string.println()
//print(x + y)
//a.startOffsetForFile(11).string.println()
//print(suicune.fileSize + y)


//// shadow shake
//let shakeBranch = 0x80216d94 - kDOLtoRAMOffsetDifference
//let shakeStart = 0x8021fe38 - kDOLtoRAMOffsetDifference
//let groundTrue = 0x80216e10 - kDOLtoRAMOffsetDifference
//let groundFalse = shakeBranch + 0x4
//let setEffect = 0x801f057c - kDOLtoRAMOffsetDifference
//let checkForType = 0x802054fc - kDOLtoRAMOffsetDifference
//replaceASM(startOffset: shakeBranch, newASM: [createBranchFrom(offset: shakeBranch, toOffset: shakeStart)])
//replaceASM(startOffset: shakeStart, newASM: [
//	0x7f43d378, // mr	r3, r26 (move)
//	0x28030084, // cmpwi r3, shadow shake
//	0x7f63db78, // mr	r3, r27 (defending pokemon)
//	powerPCBranchEqualFromOffset(from: 0x0, to: 0x8),
//	createBranchFrom(offset: shakeStart + 0x10, toOffset: groundFalse),
//	0xa063080c, // lhz	r3, 0x080C (r3) get ability
//	0x2803001a, // cmpwi r3, levitate
//	powerPCBranchEqualFromOffset(from: 0x0, to: 0x18),
//	0x7f63db78, // mr	r3, r27 (defending pokemon)
//	0x38800002, // li r4, flying type
//	createBranchAndLinkFrom(offset: shakeStart + 0x28, toOffset: checkForType),
//	0x28030001, // cmpwi r3, 1
//	powerPCBranchNotEqualFromOffset(from: 0x0, to: 0x18),
//	0x7fe3fb78, // mr	r3, r31
//	0x38800043, // li	r4, 67 (doesn't affect the target)
//	0x38a00000, // li r5, 0
//	createBranchAndLinkFrom(offset: shakeStart + 0x40, toOffset: setEffect),
//	createBranchFrom(offset: shakeStart + 0x44, toOffset: groundTrue),
//	0x7f63db78, // mr	r3, r27 (overwritten code)
//	createBranchFrom(offset: shakeStart + 0x4c, toOffset: groundFalse),
//])

//// sucker punch
//let suckerBranch = 0x80216e10 - kDOLtoRAMOffsetDifference
//let suckerStart = 0x8021fe88 - kDOLtoRAMOffsetDifference
//let suckerEnd = suckerBranch + 0x4
//let setEffect = 0x801f057c - kDOLtoRAMOffsetDifference
//let getCurrentMove = 0x80148d64 - kDOLtoRAMOffsetDifference
//let getMovePower = 0x8013e71c - kDOLtoRAMOffsetDifference
//let getMoveOrder = 0x801f4300 - kDOLtoRAMOffsetDifference
//replaceASM(startOffset: suckerBranch, newASM: [createBranchFrom(offset: suckerBranch, toOffset: suckerStart)])
//replaceASM(startOffset: suckerStart, newASM: [
//	0x7f43d378, // mr	r3, r26 (move)
//	0x28030015, // cmpwi r3, sucker punch
//	powerPCBranchEqualFromOffset(from: 0x0, to: 0xc),
//	0x7fe3fb78, // mr	r3, r31 (overwritten code)
//	createBranchFrom(offset: suckerStart + 0x10, toOffset: suckerEnd),
//	0x7f63db78, // mr	r3, r27 (defending pokemon)
//	createBranchAndLinkFrom(offset: suckerStart + 0x18, toOffset: getCurrentMove),
//	createBranchAndLinkFrom(offset: suckerStart + 0x1c, toOffset: getMovePower),
//	0x28030000, // cmpwi r3, 0
//	powerPCBranchEqualFromOffset(from: 0x0, to: 0x28),
//	0x38600000, // li r3, 0
//	0x38c00000, // li r6, 0
//	0x7f64dB78, // mr r4, r27 (defending pokemon)
//	0x7f85e378, // mr r5, r28 (attacking pokemon)
//	createBranchAndLinkFrom(offset: suckerStart + 0x38, toOffset: getMoveOrder),
//	0x28030001, // cmpwi r3, 1
//	powerPCBranchEqualFromOffset(from: 0x0, to: 0xc),
//	0x7fe3fb78, // mr	r3, r31 (overwritten code)
//	createBranchFrom(offset: suckerStart + 0x48, toOffset: suckerEnd),
//	0x7fe3fb78, // mr	r3, r31 (overwritten code)
//	0x38800045, // li	r4, 69 (the move failed)
//	0x38a00000, // li r5, 0
//	createBranchAndLinkFrom(offset: suckerStart + 0x58, toOffset: setEffect),
//	0x7fe3fb78, // mr	r3, r31 (overwritten code)
//	createBranchFrom(offset: suckerStart + 0x60, toOffset: suckerEnd)
//])

//// skill link
//let skillBranch1 = 0x80221d70 - kDOLtoRAMOffsetDifference
//let skillBranch2 = 0x80221d98 - kDOLtoRAMOffsetDifference
//let skillStart = 0x80152548 - kDOLtoRAMOffsetDifference
//replaceASM(startOffset: skillBranch1, newASM: [createBranchAndLinkFrom(offset: skillBranch1, toOffset: skillStart)])
//replaceASM(startOffset: skillBranch2, newASM: [createBranchAndLinkFrom(offset: skillBranch2, toOffset: skillStart)])
//replaceASM(startOffset: skillStart, newASM: [
//0x5404063e, // rlwinm	r4, r0, 0, 24, 31 (replaced code)
//0x387FF9B8, // subi	r3, r31, 1608 (turns move routine pointer back to battle pokemon pointer)
//0xa063080c, // lhz	r3, 0x080C (r3) get ability
//0x28030066, // cmpwi r3, 102 (skill link)
//0x41820008, // beq 0x8
//0x4e800020, // blr
//0x38800005, // li r4, 5
//0x4e800020, // blr
//])


//// shade ball
//let shadeStart = 0x80219380 - kDOLtoRAMOffsetDifference
//let checkShadow = 0x8013efec - kDOLtoRAMOffsetDifference
//replaceASM(startOffset: shadeStart, newASM: [
//	0x7f43d378, // mr r3, r26 defending pokemon stats
//	createBranchAndLinkFrom(offset: shadeStart + 0x4, toOffset: checkShadow),
//	0x28030001, // cmpwi r3, 1
//	powerPCBranchNotEqualFromOffset(from: 0x0, to: 0x14),
//	kNopInstruction,
//	kNopInstruction,
//	0x3b800032, // li r28, 50
//])
//
//// net ball buff
//replaceASM(startOffset: 0x80219370 - kDOLtoRAMOffsetDifference, newASM: [0x3b800023])

//// magic bounce 2
//let setStatus = 0x802024a4 - kDOLtoRAMOffsetDifference
//let getMove = 0x80148d64 - kDOLtoRAMOffsetDifference
//let coatBranch = 0x80218590 - kDOLtoRAMOffsetDifference
//let coatReturn = coatBranch + 0x4
//let coatStart = 0x8021ea68 - kDOLtoRAMOffsetDifference
//replaceASM(startOffset: coatBranch, newASM: [createBranchFrom(offset: coatBranch, toOffset: coatStart)])
//replaceASM(startOffset: coatStart, newASM: [
//	0x38a00000, // li r5, 0
//	createBranchAndLinkFrom(offset: coatStart + 0x4, toOffset: setStatus),
//	0x7f83e378, // mr r3, r28 (defending pokemon)
//	createBranchAndLinkFrom(offset: coatStart + 0xc, toOffset: getMove),
//	0x7C641B78,	// mr r4, r3
//	0x7f83e378, // mr r3, r28 (defending pokemon)
//	0xb0830008, // sth	r4, 0x0008 (r3)
//	createBranchFrom(offset: coatStart + 0x1c, toOffset: coatReturn)
//])
//let coatCheckBranch = 0x8020e3c4 - kDOLtoRAMOffsetDifference
//let coatCheckReturn = coatCheckBranch + 0x4
//let coatCheckStart = 0x8021dc10 - kDOLtoRAMOffsetDifference
//let checkStatus = 0x802025f0 - kDOLtoRAMOffsetDifference
//let getPokemon = 0x801efcac - kDOLtoRAMOffsetDifference
//let setMove = 0x8014774c - kDOLtoRAMOffsetDifference
//replaceASM(startOffset: coatCheckBranch, newASM: [createBranchFrom(offset: coatCheckBranch, toOffset: coatCheckStart)])
//replaceASM(startOffset: coatCheckStart, newASM: [
//	0x38600011, // li r3, 17
//	0x38800000, // li r4, 0
//	createBranchAndLinkFrom(offset: coatCheckStart + 0x8, toOffset: getPokemon),
//	0x38800037, // li r4, magic coat (set after magic bounce activates)
//	createBranchAndLinkFrom(offset: coatCheckStart + 0x10, toOffset: checkStatus),
//	0x28030001, // cmpwi r3, 1
//	powerPCBranchNotEqualFromOffset(from: 0x18, to: 0x30),
//	0x38600011, // li r3, 17
//	0x38800000, // li r4, 0
//	createBranchAndLinkFrom(offset: coatCheckStart + 0x24, toOffset: getPokemon),
//	0xa0830008, // lhz	r4, 0x0008 (r3)
//	createBranchAndLinkFrom(offset: coatCheckStart + 0x2c, toOffset: setMove),
//	0xbb410008, // lmw	r26, 0x0008 (sp)
//	createBranchFrom(offset: coatCheckStart + 0x34, toOffset: coatCheckReturn),
//
//])
//let coatChangeBranch = 0x80209bac - kDOLtoRAMOffsetDifference
//let coatChangeReturn = coatChangeBranch + 0x4
//let coatNopOffset = 0x80209bb4 - kDOLtoRAMOffsetDifference
//let coatChangeStart = 0x8021bc80 - kDOLtoRAMOffsetDifference
//replaceASM(startOffset: coatNopOffset, newASM: [kNopInstruction])
//replaceASM(startOffset: coatChangeBranch, newASM: [createBranchFrom(offset: coatChangeBranch, toOffset: coatChangeStart)])
//replaceASM(startOffset: coatChangeStart, newASM: [
//	0x7C7A1B78, // mr r26, r3
//	0x7f83e378, // mr r3, r28 (attacking pokemon)
//	0x38800037, // li r4, magic coat (set after magic bounce activates)
//	createBranchAndLinkFrom(offset: coatChangeStart + 0xc, toOffset: checkStatus),
//	0x28030001, // cmpwi r3, 1
//	powerPCBranchNotEqualFromOffset(from: 0x0, to: 0x10),
//	0x7f83e378, // mr r3, r28 (attacking pokemon)
//	0xa0630008, // lhz	r3, 0x0008 (r3)
//	0x7C7A1B78, // mr r26, r3
//	createBranchFrom(offset: coatChangeStart + 0x24, toOffset: coatChangeReturn)
//])

//// sand rush/force immune to sandstorm
//let sarfissBranch = 0x80221238 - kDOLtoRAMOffsetDifference
//let sarfissStart = 0x80221998 - kDOLtoRAMOffsetDifference
//let sarfissReturn = sarfissBranch + 0x8
//let sarfissNoDamage = 0x8022127c - kDOLtoRAMOffsetDifference
//replaceASM(startOffset: sarfissBranch, newASM: [createBranchFrom(offset: sarfissBranch, toOffset: sarfissStart)])
//replaceASM(startOffset: sarfissStart, newASM: [
//	0x28000008, // cmpwi r0, sand veil
//	powerPCBranchEqualFromOffset(from: 0x4, to: 0x18),
//	0x2800005a, // cmpwi r0, sand force
//	powerPCBranchEqualFromOffset(from: 0xc, to: 0x18),
//	0x2800005b, // cmpwi r0, sand rush
//	powerPCBranchNotEqualFromOffset(from: 0x14, to: 0x1c),
//	createBranchFrom(offset: sarfissStart + 0x18, toOffset: sarfissNoDamage),
//	createBranchFrom(offset: sarfissStart + 0x1c, toOffset: sarfissReturn)
//])

//// aura filter immune to shadow sky
//let afissBranch = 0x802212e4 - kDOLtoRAMOffsetDifference
//let afissReturn = afissBranch + 0x4
//let afissNoDamage = 0x80221330 - kDOLtoRAMOffsetDifference
//let afissStart = 0x802219b8 - kDOLtoRAMOffsetDifference
//replaceASM(startOffset: afissBranch, newASM: [createBranchFrom(offset: afissBranch, toOffset: afissStart)])
//replaceASM(startOffset: afissStart, newASM: [
//	0x7f43d378, // defending pokemon stats pointer
//	0xa0630002, // lhz r3, 0x0002(r3) get item
//	0x2803003c, // cmpwi r3, aura filter
//	powerPCBranchEqualFromOffset(from: 0x0, to: 0xc),
//	0x7f43d378, // overwritten by branch
//	createBranchFrom(offset: afissStart + 0x14, toOffset: afissReturn),
//	createBranchFrom(offset: afissStart + 0x18, toOffset: afissNoDamage),
//])


//// shadow hunter/slayer
//let hunterStart = 0x8022a6a4 - kDOLtoRAMOffsetDifference
//let checkShadowPokemon = 0x80149014 - kDOLtoRAMOffsetDifference
//replaceASM(startOffset: hunterStart, newASM: [
//	0x7e038378, // mr r3, r16 (defending mon)
//	0x80630000, // lw r3, 0 (r3)
//	0x38630004, // addi r3, 4
//	createBranchAndLinkFrom(offset: hunterStart + 0xc, toOffset: checkShadowPokemon),
//	0x28030001, // cmpwi r3, 1
//	powerPCBranchNotEqualFromOffset(from: 0x0, to: 0x28),
//	0x7e238b78, // mr r3, r17
//	0xa063001c, // lhz 0x001c(r3)     (get move effect)
//	0x28030015, // cmpwi r3, shadow hunter/slayer
//	powerPCBranchNotEqualFromOffset(from: 0x0, to: 0x18),
//	// boost 50%
//	0x56c3043e, // rlwinm r3, r22
//	0x38000064, // li r0, 100
//	0x1c630096, // mulli r3, 150
//	0x7c0303d6, // div r0, r3, r0
//	0x5416043e, // rlwinm r22, r0
//])


//for offset in stride(from: 770, through: 800, by: 2) {
//	replaceMartItemAtOffset(offset, withItem: getMartItemAtOffset(offset + 2))
//}
//replaceMartItemAtOffset(800, withItem: .item(333))


//// rage mode boost
//let checkStatus = 0x802025f0 - kDOLtoRAMOffsetDifference
//let rageStart = 0x8022a67c - kDOLtoRAMOffsetDifference
//replaceASM(startOffset: rageStart, newASM: [
//	0x7de37b78, // mr r3, r15
//	0x3880003e, // li r4, reverse mode
//	createBranchAndLinkFrom(offset: rageStart + 0x8, toOffset: checkStatus),
//	0x28030001, // cmpwi r3, 1
//	powerPCBranchNotEqualFromOffset(from: 0x0, to: 0x18),
//	0x7ec3b378,	// mr r3, r22
//	0x38000064, // li r0, 100
//	0x1c630082, // mulli r3, 130
//	0x7c0303d6, // div r0, r3, r0
//	0x5416043e, // rlwinm r22, r0
//	])

//// hex
//let hexStart = 0x8022a6e0 - kDOLtoRAMOffsetDifference
//let checkNoStatus = 0x80203744 - kDOLtoRAMOffsetDifference
//replaceASM(startOffset: hexStart, newASM: [
//	0x7e038378, // mr r3, r16 (defending pokemon)
//	createBranchAndLinkFrom(offset: hexStart + 0x4, toOffset: checkNoStatus),
//	0x28030001, // if has no status effect
//	powerPCBranchEqualFromOffset(from: 0x0, to: 0x28),
//	0x7e238b78, // mr r3, r17
//	// get move data pointer
//	0x1c030038,
//	0x806d89d4,
//	0x7c630214,
//	0xa063001c, // lhz 0x001c(r3)     (get move effect)
//	0x2803000c, // cmpwi r3, move effect 12 (hex)
//	powerPCBranchNotEqualFromOffset(from: 0x0, to: 0xc),
//	0x38600002, // li r3, 2
//	0x7ED619D6, // mullw r22, r22, r3
//])


//let tmList : [[Int]] = [
//	[], // tailwind
//	[],	// fire blast
//	[],	// light pulse
//	[],	// hurricane
//	[],	// sludgewave
//	[],	// dazzling gleam
//	[],	// foul play
//	[],	// flash cannon
//	[286],	// thunder wave
//	[],	// ice beam
//	[],	// will-o-wisp
//	[],	// wild charge
//	[],	// trick room
//	[],	// scald
//	[],	// flamethrower
//	[],	// iron head
//	[],	// thunderbolt
//	[],	// freeze dry
//	[],	// sludgebomb
//	[],	// energy ball
//	[],	// zen headbutt
//	[],	// bug buzz
//	[],	// dragon pulse
//	[142],	// super power
//	[279],	// earthquake
//	[],	// earth power
//	[],	// heat wave
//	[],	// blizzard
//	[],	// sucker punch
//	[],	// gunk shot
//	[],	// psyshock
//	[],	// shadow ball
//	[279],	// rock slide
//	[],	// solar beam
//	[279],	// focus blast
//	[],	// x-scissor
//	[],	// thunder
//	[],	// acrobatics
//	[],	// waterfall
//	[],	// dragon claw
//	[],	// toxic all except ditto
//	[],	// wild flare
//	[],	// poison jab
//	[],	// night slash
//	[245],	// reflect
//	[245],	// light screen
//	[],	// surf
//	[],	// stone edge
//	[],	// psychic
//	[],	// dark pulse
//
//]
//
//for i in tmList {
//	for t in i {
//		if t > 415 {
//			print("tm typo: ", i, t)
//		}
//	}
//}
//
//for tm in 0 ..< tmList.count {
//	if tmList[tm].count > 0 {
//		let mon = XGPokemon.pokemon(tmList[tm][0]).stats
//		mon.learnableTMs[tm] = true
//		mon.save()
//	}
//}


//let ludicolo  = XGTrainer(index: 221, deck:     .DeckStory).pokemon[1].data
//let gyarados  = XGTrainer(index: 199, deck:     .DeckStory).pokemon[1].data
//let ludicolo2 = XGTrainer(index:  59, deck: .DeckColosseum).pokemon[5].data
//let gyarados2 = XGTrainer(index:  67, deck: .DeckColosseum).pokemon[3].data
//for mon in [ludicolo, gyarados, ludicolo2, gyarados2] {
//	mon.shinyness = .always
//	mon.save()
//}


//for move in XGOriginalMoves.allMoves() {
//	let desc = getStringSafelyWithID(id: move.descriptionID)
//	if desc.length < 5 {
//		print(move.name)
//	}
//}


// make taunt last 4 turns
//let dol = XGFiles.dol.data
//dol.replaceByteAtOffset(0x3f93e0 + (48 * 0x14) + 4, withByte: 4)

// make tail wind last 4 turns
//let dol = XGFiles.dol.data
//dol.replaceByteAtOffset(0x3f93e0 + (75 * 0x14) + 4, withByte: 4)

//for tm in XGTMs.allTMs() {
//
//	tm.updateItemDescription()
//
//}


//var bingoMons = [XGBattleBingoPokemon]()
//for i in 0 ..< kNumberOfBingoCards {
//	let card = XGBattleBingoCard(index: i)
//
//	bingoMons.append(card.startingPokemon)
//	for p in card.panels {
//		switch p {
//		case .pokemon(let poke):
//			bingoMons.append(poke)
//		default:
//			break
//		}
//	}
//}
//
//
//
//let bingo : [ (XGPokemon,XGMoves,XGNatures,XGMoveTypes,Int) ] = [
//	//card 1
//		(pokemon("bagon"),move("dragonbreath"),.modest,.dragon,0),
//		(pokemon("bulbasaur"),move("absorb"),.hardy,.grass,0),
//		(pokemon("mudkip"),move("water gun"),.hardy,.water,0),
//		(pokemon("chikorita"),move("absorb"),.hardy,.grass,0),
//		(pokemon("cyndaquil"),move("ember"),.hardy,.fire,0),
//		(pokemon("sunkern"),move("leech seed"),.hardy,.grass,0),
//		(pokemon("totodile"),move("water gun"),.hardy,.water,0),
//		(pokemon("charmander"),move("ember"),.adamant,.fire,0),
//		(pokemon("marill"),move("play fair"),.hardy,.water,0),
//		(pokemon("magby"),move("will-o-wisp"),.hardy,.fire,0),
//		(pokemon("squirtle"),move("water gun"),.hardy,.water,0),
//		(pokemon("treecko"),move("absorb"),.hardy,.grass,0),
//		(pokemon("goldeen"),move("baby doll eyes"),.hardy,.water,0),
//		(pokemon("torchic"),move("ember"),.hardy,.fire,0),
//	//card 2
//		(pokemon("magnemite"),move("shockwave"),.modest,.electric,0),
//		(pokemon("machop"),move("bullet punch"),.hardy,.fighting,0),
//		(pokemon("pidgey"),move("air slash"),.hardy,.flying,0),
//		(pokemon("gligar"),move("bulldoze"),.hardy,.flying,0),
//		(pokemon("nosepass"),move("rock tomb"),.hardy,.rock,0),
//		(pokemon("makuhita"),move("ice punch"),.hardy,.fighting,0),
//		(pokemon("swablu"),move("dragonbreath"),.hardy,.flying,0),
//		(pokemon("anorith"),move("aerial ace"),.hardy,.rock,0),
//		(pokemon("meditite"),move("zen headbutt"),.hardy,.fighting,0),
//		(pokemon("lunatone"),move("psybeam"),.hardy,.rock,0),
//		(pokemon("larvitar"),move("rock slide"),.hardy,.rock,0),
//		(pokemon("zubat"),move("aerial ace"),.hardy,.flying,0),
//		(pokemon("mankey"),move("power up punch"),.hardy,.fighting,0),
//		(pokemon("rhyhorn"),move("bulldoze"),.hardy,.rock,0),
//	//card 3
//		(pokemon("nuzleaf"),move("mega drain"),.modest,.grass,0),
//		(pokemon("lanturn"),move("scald"),.hardy,.water,0), // ability 0 for volt absorb
//		(pokemon("steelix"),move("iron head"),.hardy,.ground,0),
//		(pokemon("magneton"),move("flash cannon"),.hardy,.electric,0),
//		(pokemon("graveler"),move("bulldoze"),.hardy,.ground,0),
//		(pokemon("spheal"),move("ice beam"),.hardy,.water,0),
//		(pokemon("flaaffy"),move("thunderbolt"),.hardy,.electric,0),
//		(pokemon("marshtomp"),move("earth power"),.hardy,.water,0),
//		(pokemon("pupitar"),move("rock slide"),.hardy,.ground,0),
//		(pokemon("pikachu"),move("volt tackle"),.hardy,.electric,0),
//		(pokemon("manectric"),move("overheat"),.hardy,.electric,0),
//		(pokemon("gyarados"),move("bounce"),.hardy,.water,0),
//		(pokemon("piloswine"),move("icicle crash"),.hardy,.ground,0),
//		(pokemon("lombre"),move("giga drain"),.hardy,.water,0),
//	//card 4
//		(pokemon("alakazam"),move("psychic"),.modest,.psychic,0),
//		(pokemon("claydol"),move("psychic"),.hardy,.psychic,0),
//		(pokemon("grumpig"),move("psychic"),.modest,.psychic,0),
//		(pokemon("muk"),move("gunk shot"),.hardy,.poison,0),
//		(pokemon("shiftry"),move("sucker punch"),.hardy,.dark,0),
//		(pokemon("sharpedo"),move("crunch"),.hardy,.dark,0),
//		(pokemon("medicham"),move("drain punch"),.hardy,.psychic,0),
//		(pokemon("victreebel"),move("leaf storm"),.hardy,.poison,0),
//		(pokemon("metang"),move("meteor mash"),.hardy,.psychic,0),
//		(pokemon("seviper"),move("sucker punch"),.adamant,.poison,0),
//		(pokemon("gardevoir"),move("moonblast"),.hardy,.psychic,0),
//		(pokemon("crobat"),move("brave bird"),.adamant,.poison,0),
//		(pokemon("absol"),move("dark pulse"),.hardy,.dark,0),
//		(pokemon("sneasel"),move("ice punch"),.hardy,.dark,0),
//	//card 5
//		(pokemon("sableye"),move("will-o-wisp"),.brave,.ghost,0),
//		(pokemon("wigglytuff"),move("play rough"),.adamant,.normal,0),
//		(pokemon("gengar"),move("sludge bomb"),.adamant,.ghost,0),
//		(pokemon("misdreavus"),move("shadow ball"),.modest,.ghost,0),
//		(pokemon("blaziken"),move("blaze kick"),.hardy,.fighting,0),
//		(pokemon("pidgeot"),move("hurricane"),.hardy,.normal,0),
//		(pokemon("machamp"),move("cross chop"),.hardy,.fighting,0),
//		(pokemon("banette"),move("sucker punch"),.adamant,.ghost,0),
//		(pokemon("slaking"),move("giga impact"),.brave,.normal,0),
//		(pokemon("exploud"),move("boomburst"),.hardy,.normal,0),
//		(pokemon("breloom"),move("sky uppercut"),.jolly,.fighting,0),
//		(pokemon("dusclops"),move("destiny bond"),.hardy,.ghost,0),
//		(pokemon("hariyama"),move("knock off"),.adamant,.fighting,0),
//		(pokemon("zangoose"),move("night slash"),.jolly,.normal,0),
//	//card 6
//		(pokemon("butterfree"),move("bug buzz"),.modest,.bug,0),
//		(pokemon("armaldo"),move("stone edge"),.hardy,.bug,0),
//		(pokemon("beedrill"),move("poison jab"),.hardy,.bug,0),
//		(pokemon("scizor"),move("bullet punch"),.timid,.bug,0),
//		(pokemon("scyther"),move("air slash"),.hardy,.bug,0),
//		(pokemon("heracross"),move("rock blast"),.jolly,.bug,0),
//		(pokemon("parasect"),move("seed bomb"),.hardy,.bug,0),
//		(pokemon("ninjask"),move("aerial ace"),.hardy,.bug,0),
//		(pokemon("shedinja"),move("shadow claw"),.hardy,.bug,0),
//		(pokemon("ariados"),move("sucker punch"),.adamant,.bug,0),
//		(pokemon("beautifly"),move("hurricane"),.hardy,.bug,0),
//		(pokemon("masquerain"),move("scald"),.hardy,.bug,0),
//		(pokemon("pinsir"),move("seismic toss"),.bold,.bug,0),
//		(pokemon("shuckle"),move("toxic"),.hardy,.bug,0),
//	//card 7
//		(pokemon("pidgeot"),move("hurricane"),.modest,.flying,0),
//		(pokemon("aggron"),move("iron tail"),.hardy,.steel,0),
//		(pokemon("tyranitar"),move("stone edge"),.hardy,.rock,0),
//		(pokemon("steelix"),move("earthquake"),.adamant,.steel,0),
//		(pokemon("sneasel"),move("brick break"),.adamant,.ice,0),
//		(pokemon("regirock"),move("stone edge"),.hardy,.rock,0),
//		(pokemon("golem"),move("earthquake"),.relaxed,.rock,0),
//		(pokemon("skarmory"),move("iron head"),.hardy,.steel,0),
//		(pokemon("glalie"),move("ice beam"),.hardy,.ice,0),
//		(pokemon("rhydon"),move("drill run"),.hardy,.rock,0),
//		(pokemon("regice"),move("blizzard"),.hardy,.ice,0),
//		(pokemon("registeel"),move("super power"),.hardy,.steel,0),
//		(pokemon("omastar"),move("scald"),.hardy,.rock,0),
//		(pokemon("lapras"),move("hydro pump"),.hardy,.ice,0),
//	//card 8
//		(pokemon("dragonite"),move("dragon claw"),.jolly,.dragon,0),
//		(pokemon("ampharos"),move("thunderbolt"),.modest,.dragon,0),
//		(pokemon("dragonite"),move("iron tail"),.adamant,.flying,0),
//		(pokemon("tyranitar"),move("stone edge"),.adamant,.rock,0),
//		(pokemon("altaria"),move("play fair"),.hardy,.dragon,0),
//		(pokemon("flygon"),move("iron tail"),.jolly,.dragon,0),
//		(pokemon("sceptile"),move("dragon pulse"),.adamant,.dragon,0),
//		(pokemon("latias"),move("ice beam"),.adamant,.dragon,0),
//		(pokemon("feraligatr"),move("ice punch"),.adamant,.water,0),
//		(pokemon("salamence"),move("aerial ace"),.adamant,.flying,0),
//		(pokemon("kingdra"),move("hydro pump"),.timid,.water,0),
//		(pokemon("aerodactyl"),move("stone edge"),.timid,.rock,0),
//		(pokemon("latios"),move("thunderbolt"),.brave,.dragon,0),
//		(pokemon("charizard"),move("dragon claw"),.adamant,.flying,0),
//	//card 9
//		(pokemon("slaking"),move("body slam"),.brave,.normal,0),
//		(pokemon("suicune"),move("hydro pump"),.bold,.water,0),
//		(pokemon("regice"),move("blizzard"),.modest,.ice,0),
//		(pokemon("zapdos"),move("thunder"),.relaxed,.electric,0),
//		(pokemon("entei"),move("flare blitz"),.adamant,.fire,0),
//		(pokemon("metagross"),move("meteor mash"),.adamant,.steel,0),
//		(pokemon("regirock"),move("stone edge"),.adamant,.rock,0),
//		(pokemon("registeel"),move("iron head"),.adamant,.steel,0),
//		(pokemon("moltres"),move("fire blast"),.timid,.fire,0),
//		(pokemon("raikou"),move("thunder"),.jolly,.normal,0),
//		(pokemon("salamence"),move("outrage"),.brave,.dragon,0),
//		(pokemon("tyranitar"),move("stone edge"),.impish,.rock,0),
//		(pokemon("dragonite"),move("dragon claw"),.jolly,.dragon,0),
//		(pokemon("articuno"),move("blizzard"),.timid,.ice,0),
//	//card 10
//		(pokemon("mew"),move("psychic"),.modest,.psychic,0),
//		(pokemon("kyogre"),move("surf"),.modest,.water,0),
//		(pokemon("mew"),move("sucker punch"),.adamant,.psychic,0),
//		(pokemon("latias"),move("draco meteor"),.modest,.dragon,0),
//		(pokemon("lugia"),move("aeroblast"),.hasty,.flying,0),
//		(pokemon("groudon"),move("stone edge"),.adamant,.ground,0),
//		(pokemon("mew"),move("ice beam"),.modest,.psychic,0),
//		(pokemon("celebi"),move("leaf storm"),.modest,.psychic,0),
//		(pokemon("latios"),move("dracometeor"),.modest,.dragon,0),
//		(pokemon("jirachi"),move("iron head"),.adamant,.psychic,0),
//		(pokemon("ho-oh"),move("sacred fire"),.hasty,.flying,0),
//		(pokemon("rayquaza"),move("outrage"),.adamant,.dragon,0),
//		(pokemon("mewtwo"),move("psystrike"),.modest,.psychic,0),
//		(pokemon("deoxys"),move("psychoboost"),.modest,.psychic,0),
//	//card 11
//		(pokemon("bonsly"),move("stone edge"),.adamant,.rock,0),
//		(pokemon("vulpix"),move("fire blast"),.modest,.fire,0),
//		(pokemon("shroomish"),move("wood hammer"),.adamant,.grass,0),
//		(pokemon("poliwag"),move("hydro pump"),.modest,.water,0),
//		(pokemon("dratini"),move("draco meteor"),.modest,.dragon,0),
//		(pokemon("mareep"),move("thunder"),.modest,.electric,0),
//		(pokemon("snorunt"),move("blizzard"),.modest,.ice,0),
//		(pokemon("phanpy"),move("earthquake"),.adamant,.ground,0),
//		(pokemon("poochyena"),move("sucker punch"),.adamant,.dark,0),
//		(pokemon("taillow"),move("brave bird"),.adamant,.flying,0),
//		(pokemon("whismur"),move("boomburst"),.modest,.normal,0),
//		(pokemon("tyrogue"),move("superpower"),.adamant,.fighting,0),
//		(pokemon("grimer"),move("gunk shot"),.adamant,.poison,0),
//		(pokemon("abra"),move("psychic"),.modest,.psychic,0)
//
//]
//
//for j in 0 ..< bingo.count {
//	let mon = bingoMons[j]
//	let nw = bingo[j]
//
//	mon.species = nw.0
//	mon.move = nw.1
//	mon.nature = nw.2
//	mon.typeOnCard = nw.3 == mon.species.type1 ? 0 : 1
//	mon.ability = nw.4
//
//	mon.save()
//}

//let aurora = move("aurora veil").data
//aurora.pp = 10
//aurora.save()
//
//let omanyte = pokemon("omanyte").stats
//omanyte.levelUpMoves[0].move = move("rock throw")
//omanyte.save()

//let rest = move("rest").data
//rest.effect = 37
//rest.save()
//
//let veil = move("shadow veil").data
//veil.pp = 5
//veil.save()
//
//let feebas = pokemon("feebas").stats
//feebas.evolutions[0].evolutionMethod = .levelUp
//feebas.evolutions[0].condition = 20
//feebas.save()
//feebas.evolutions[0].evolutionMethod.string.println()
//
//compileForRelease()


//let iso = XGISO()
//
//var movefiles = iso.allFileNames.filter { (name) -> Bool in
//	return name.contains("godbird")
//	}.map { (move) -> (name: String, filesize: Int) in
//	return (move, iso.sizeForFile(move)!)
//}
//movefiles = movefiles.sorted { (m1:(name: String, filesize: Int), m2:(name: String, filesize: Int)) -> Bool in
//	return m1.filesize > m2.filesize
//}
//for move in movefiles {
//	print(move.name.spaceToLength(25),move.filesize.string.spaceToLength(10))
//}

//let fileName = "B1_1.fsys"
////let fileName = "D3_ship_B2_2.fsys"
//let new = iso.dataForFile(filename: fileName)!
//let fsys = iso.fsysForFile(filename: fileName)!
//new.file = .fsys("S1_out.fsys")
//new.save()
//
//iso.importFiles([new.file])
//
//for i in 0 ..< fsys.numberOfEntries {
//	let data = fsys.decompressedDataForFileWithIndex(index: i)!
//	data.file = .nameAndFolder(fsys.fileNames[i], .Documents)
//	data.save()
//}

//let iso = XGISO()
//
//var maps = iso.allFileNames.filter { (name) -> Bool in
//	let prefixes = ["B1","D1","D2","D3","D4","D5", "D6", "D7", "M1", "M2", "M3", "M4","M5","S1","S2","S3","T1"]
//
//	return (prefixes.contains(name.substring(from: 0, to: 2)) && !(name.contains("bf"))) || (name.substring(from: 0, to: 4) == "TEST")
//	}.map { (map) -> (name: String, filesize: Int) in
//	return (map, iso.sizeForFile(map)!)
//}
//maps = maps.sorted { (map1:(name: String, filesize: Int), map2:(name: String, filesize: Int)) -> Bool in
//	return map1.filesize > map2.filesize
//}
//for map in maps {
//	print(map.name.spaceToLength(25),map.filesize.string.spaceToLength(10))
//}
//
//let fileName = "B1_1.fsys"
////let fileName = "D3_ship_B2_2.fsys"
//let new = iso.dataForFile(filename: fileName)!
//let fsys = iso.fsysForFile(filename: fileName)!
//new.file = .fsys("S1_out.fsys")
//new.save()
//
//iso.importFiles([new.file])
//
//for i in 0 ..< fsys.numberOfEntries {
//	let data = fsys.decompressedDataForFileWithIndex(index: i)!
//	data.file = .nameAndFolder(fsys.fileNames[i], .Documents)
//	data.save()
//}


//compileForRelease()

//documentISO(forXG: true)





// copy nintendon't save to dolphin gci to import into mem card
//let from = XGFiles.nameAndFolder("GXXE.raw", .Reference).data
//let to = XGFiles.nameAndFolder("GXXE_PokemonXD.gci", .Reference).data
//let fromStart = 0xB2000
//let toStart = 0x40
//let save = from.getByteStreamFromOffset(fromStart, length: 0x56000)
//to.replaceBytesFromOffset(toStart, withByteStream: save)
//to.save()


//printRoutineForMove(move: move("nature power"))
//getFunctionPointerWithIndex(index: 96).hex().println()













