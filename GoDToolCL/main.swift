//
//  main.swift
//  XGCommandLineTools
//
//  Created by StarsMmd on 13/11/2015.
//  Copyright © 2015 StarsMmd. All rights reserved.
//

//// sitrus berry
//let sitrusBranch = 0x223efc
//let sitrusStart = 0xb99648
//
//let getHPFraction = 0x203688
//let sitrusCode : ASM = [
//	
//	0x281b00fd, // cmpwi r27, 0xfd
//	XGAssembly.powerPCBranchNotEqualFromOffset(from: 0x0, to: 0x1c),
//	0x7fe3fb78, // mr	r3, r31
//	0x38800004, // li	r4, 4
//	XGAssembly.createBranchAndLinkFrom(offset: sitrusStart + 0x10, toOffset: getHPFraction),
//	0x7c601b78, // mr	r0, r3
//	0x7c1b0378, // mr	r27, r0
//	XGAssembly.createBranchFrom(offset: 0x0, toOffset: 0x20),
//	0x281b00fe, // cmpwi r27, 0xfe
//	XGAssembly.powerPCBranchNotEqualFromOffset(from: 0x0, to: 0x18),
//	0x7fe3fb78, // mr	r3, r31
//	0x38800002, // li	r4, 2
//	XGAssembly.createBranchAndLinkFrom(offset: sitrusStart + 0x30, toOffset: getHPFraction),
//	0x7c601b78, // mr	r0, r3
//	0x7c1b0378, // mr	r27, r0
//	
//	0x57a3043e, // rlwinm	r3, r29, 0, 16, 31 (0000ffff) overwritten code
//	XGAssembly.createBranchFrom(offset: sitrusStart + 0x40, toOffset: sitrusBranch + 0x4)
//]
//
//XGAssembly.replaceASM(startOffset: sitrusBranch - kDOLtoRAMOffsetDifference, newASM: [XGAssembly.createBranchFrom(offset: sitrusBranch, toOffset: sitrusStart)])
//XGAssembly.replaceRELASM(startOffset: sitrusStart - kRELtoRAMOffsetDifference, newASM: sitrusCode)



//let sb = item("sitrus berry").data
//sb.parameter = 0xfd
//sb.save()

//XGUtility.compileAllFiles()

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
















