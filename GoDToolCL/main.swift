//
//  main.swift
//  XGCommandLineTools
//
//  Created by StarsMmd on 13/11/2015.
//  Copyright © 2015 StarsMmd. All rights reserved.
//


//// wide guard
//let wideGuardBranchLinks = [0x218204, 0x218184]
//let wideGuardStart = 0xb99ba0
//
//for offset in wideGuardBranchLinks {
//	XGAssembly.replaceASM(startOffset: offset - kDOLtoRAMOffsetDifference, newASM: [XGAssembly.createBranchAndLinkFrom(offset: offset, toOffset: wideGuardStart), 0x28030001])
//}
//
//let getPokemonPointer = 0x1efcac
//let getFieldEffect = 0x1f84e0
//let getCurrentMove = 0x148d64
//let getMoveTargets = 0x13e784
//
//let wideEndOffset = 0x78
//
//XGAssembly.replaceRELASM(startOffset: wideGuardStart - kRELtoRAMOffsetDifference, newASM: [
//	// allow blr
//	0x9421ffe0, // stwu	sp, -0x0020 (sp)
//	0x7c0802a6, // mflr	r0
//	0x90010024, // stw	r0, 0x0024 (sp)
//	0xbfa10014, // stmw	r29, 0x0014 (sp) (just in case I wanted to use r29 for something)
//
//	// check regular protect
//	0x28030001, // cmpwi r3, 1
//	XGAssembly.powerPCBranchNotEqualFromOffset(from: 0x0, to: 0xc),
//
//	// regular protect so go to end
//	0x38600001, // li r3, 1
//	XGAssembly.createBranchFrom(offset: 0x1c, toOffset: wideEndOffset),
//
//	// no regular protect so check wide guard
//
//	// get field pointer
//	0x7fc3f378, // mr	r3, r30
//	0x7c641b78, // mr	r4, r3
//	0x38600002, // li r3, 2
//	XGAssembly.createBranchAndLinkFrom(offset: wideGuardStart + 0x2c, toOffset: getPokemonPointer),
//
//	// check wide guard
//	0x3880004d, // li r4, 77
//	XGAssembly.createBranchAndLinkFrom(offset: wideGuardStart + 0x34, toOffset: getFieldEffect),
//	0x28030001, // cmpwi r3, 1
//	XGAssembly.powerPCBranchEqualFromOffset(from: 0x0, to: 0xc),
//	0x38600000, // li r3, 0
//	XGAssembly.createBranchFrom(offset: 0x44, toOffset: wideEndOffset),
//
//	// check current move target
//	0x38600011, // li r3, 17
//	0x38800000, // li r4, 0
//	XGAssembly.createBranchAndLinkFrom(offset: wideGuardStart + 0x50, toOffset: getPokemonPointer),
//	XGAssembly.createBranchAndLinkFrom(offset: wideGuardStart + 0x54, toOffset: getCurrentMove),
//	XGAssembly.createBranchAndLinkFrom(offset: wideGuardStart + 0x58, toOffset: getMoveTargets),
//	0x28030006, // cmpwi r3, both foes and ally
//	XGAssembly.powerPCBranchEqualFromOffset(from: 0x0, to: 0xc),
//	0x28030004, // cmpwi r3, both foes
//	XGAssembly.powerPCBranchNotEqualFromOffset(from: 0x0, to: 0xc),
//	0x38600001, // li r3, 1
//	XGAssembly.createBranchFrom(offset: 0x0, toOffset: 0x8),
//	0x38600000, // li r3, 0
//
//	// wide end 0x78
//	0xbba10014, // lmw	r29, 0x0014 (sp)
//	0x80010024, // lwz	r0, 0x0024 (sp)
//	0x7c0803a6, // mtlr	r0
//	0x38210020, // addi	sp, sp, 32
//	XGAssembly.powerPCBranchLinkReturn()
//
//])




//XGFiles.nameAndFolder("M1_out.fsys", .AutoFSYS).fsysData.extractFilesToFolder(folder: .Documents)


for file in XGFolders.Rels.files where file.fileName.contains("M1_out.rel") {
	file.fileName.println()
	let map = file.mapData
	for warp in map.warps {
		let w = warp.warp
		print(warp.sortedIndex, warp.warpType.name.spaceToLength(20), warp.xCoordinate.string.spaceToLength(10), warp.yCoordinate.string.spaceToLength(10), warp.zCoordinate.string.spaceToLength(10), w ?? "-")
		
	}
	print("")
}

//let pyrite = XGFiles.rel("M2_out.rel")
//let map = pyrite.mapData
//for c in map.characters {
//	c.model.name.println()
//	c.name.println()
//	if c.hasScript { c.scriptName.println()}
//	for r in c.rawData {
//		print(r.hex().spaceLeftToLength(2), terminator: " ")
//	}
//	print("\n")
//}


//getStringSafelyWithID(id: 0xc5da).println()
//
//for i in 0 ..< 9 {
//	if i % 2 == 0 {
//		print(i, pocket.getPointer(index: i).hexString())
//	} else {
//		print(i, pocket.getPointer(index: i).hexString(), pocket.getValueAtPointer(index: i).hexString())
//	}
//}


//var chars = [Int]()
//let setModel : UInt32 = 0x09230046
//var identifiers = [Int]()
//for file in XGFolders.Rels.files where file.fileName.contains(".rel") {
//	let map = file.mapData
//	for char in map.characters {
//		chars.append(char.model.index)
//	}
//	let script = map.script.code
//	for i in 0 ..< script.count {
//		if script[i] == setModel {
//			identifiers.append(Int(script[i - 2]))
//		}
//	}
//	
//}
//
//
//for i in 0 ..< CommonIndexes.NumberOfCharacterModels.value {
//	if !chars.contains(i) {
//		let model = XGCharacterModels(index: i)
//		if !identifiers.contains(model.identifier) {
//			print(model.name.spaceToLength(20),model.fileSize.hexString().spaceLeftToLength(8))
//		}
//	}
//}


//XGUtility.compileForRelease(XG: true)

//for i in 0 ..< CommonIndexes.NumberOfCharacterModels.value {
//	let model = XGCharacterModels(index: i)
//	
//	print(i.hexString(), model.name, model.startOffset, model.fsysIndex)
//	for i in model.rawData {
//		print(String(format: "%02x", i), terminator: " ")
//	}
//	
//	print("\n")
//}
//
//
//
//let file = XGFiles.fsys("people_archive.fsys").fsysData


//file.extractDataForFileWithIndex(index: 85)!.save()


//for index in [52,54,55,56,84,59,47,160,184,197,199,219,] {
//	file.deleteFile(index: index)
//	file.save()
//}


//let mewtwo = XGFiles.nameAndFolder("mewtwo_ow.pkx", .TextureImporter).compress()
//file.shiftAndReplaceFileWithIndex(85, withFile: mewtwo)


//let lzss = XGFiles.rel("M3_cave_1F_2.rel").compress()
//XGFiles.nameAndFolder("M3_cave_1F_2.fsys", .AutoFSYS).fsysData.replaceFileWithIndex(0, withFile: lzss, saveWhenDone: true)
////XGISO().importFiles([.nameAndFolder("M3_cave_1F_2.fsys", .AutoFSYS)])
//XGUtility.compileCommonRel()
//XGISO().importFiles([.nameAndFolder("M3_cave_1F_2.fsys", .AutoFSYS), .fsys("people_archive.fsys")])



//let pkx = XGISO().dataForFile(filename: "pkx_mewtwo.fsys")!
//pkx.file = .nameAndFolder("pkx_mewtwo.fsys", .FSYS)
//pkx.save()
//let model = pkx.fsysData.decompressedDataForFileWithIndex(index: 0)!
//model.file = .nameAndFolder("mewtwo.pkx", .TextureImporter)
//model.save()
//
//let ow = XGUtility.convertFromPKXToOverWorldModel(pkx: model)
//ow.file = .nameAndFolder("mewtwo_ow.pkx", .Documents)
//ow.save()

//XGUtility.compileMainFiles()
//XGUtility.compileForRelease(XG: true)


//XGUtility.compileMainFiles()

//XGUtility.importTextures()
//XGUtility.exportTextures()

//let bingotex = XGFiles.texture("uv_str_bingo_00.fdat")
//XGFiles.nameAndFolder("bingo_menu.fsys", .MenuFSYS).fsysData.replaceFile(file: bingotex.compress())


//XGUtility.compileForRelease(XG: true)
















