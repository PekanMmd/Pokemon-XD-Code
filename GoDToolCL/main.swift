//
//  main.swift
//  XGCommandLineTools
//
//  Created by StarsMmd on 13/11/2015.
//  Copyright © 2015 StarsMmd. All rights reserved.
//



//for file in XGFolders.Rels.files where file.fileName.contains(".rel") {
//	file.fileName.println()
//	let map = file.mapData
//	for warp in map.warps {
//		print(warp.index, warp.warpType.name.spaceToLength(15), warp.xCoordinate.string.spaceToLength(10), warp.yCoordinate.string.spaceToLength(10), warp.zCoordinate.string.spaceToLength(10))
//	}
//	print("")
//}

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
















