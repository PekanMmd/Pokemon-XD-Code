//
//  main.swift
//  XGCommandLineTools
//
//  Created by StarsMmd on 13/11/2015.
//  Copyright © 2015 StarsMmd. All rights reserved.
//


//let iso = XGISO()
//
//for file in iso.allFileNames where file.contains("ex_") || file.contains("M2_cave") || file.contains("Script_t") || file.contains("waza_view") || file.contains("tv_test") || file.contains("_fr.") || file.contains("_ge.") || file.contains("_it.") {
//	iso.deleteFileAndPreserve(name: file, save: false)
//}
//iso.importToc()


//for i in 0 ..< CommonIndexes.NumberOfCharacterModels.value {
//	print(i, XGCharacterModels(index: i).name)
//}


//let iso = XGISO()
//let indices = 1 ..< iso.allFileNames.count
//for i in indices {
//	iso.shiftUpFile(name: iso.filesOrdered[i])
//}
//iso.save()
//iso.importToc()


//let iso = XGISO()
//let indices = 1 ..< iso.allFileNames.count
//for i in indices.reversed() {
//	iso.shiftDownFile(name: iso.filesOrdered[i])
//}
//iso.save()
//iso.importToc()


let archive = XGFiles.fsys("people_archive.fsys")
XGISO().shiftAndReplaceFile(archive)

//XGISO().importFiles([archive])



//for i in 0 ..< models.count {
//	let model = XGFiles.nameAndFolder(models[i] + "_ow.dat", .TextureImporter).compress()
//	archive.shiftAndReplaceFileWithIndex(indices[i], withFile: model)
//}
//archive.save()

//let mewtwo = XGFiles.nameAndFolder("mewtwo_ow.pkx", .TextureImporter).compress()
//file.shiftAndReplaceFileWithIndex(85, withFile: mewtwo)


//XGUtility.importTextures()
//XGUtility.exportTextures()

//let bingotex = XGFiles.texture("uv_str_bingo_00.fdat")
//XGFiles.nameAndFolder("bingo_menu.fsys", .MenuFSYS).fsysData.replaceFile(file: bingotex.compress())

//XGUtility.compileForRelease(XG: true)
















