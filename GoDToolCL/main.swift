//
//  main.swift
//  XGCommandLineTools
//
//  Created by StarsMmd on 13/11/2015.
//  Copyright © 2015 StarsMmd. All rights reserved.
//
//

let itemslist = XGUtility.documentItemsByLocation()
XGUtility.saveString(itemslist, toFile: .nameAndFolder("XG Items by location.txt", .Documents))

//XGUtility.saveMewTutorMovePairs()
//print((XGDemoStarterPokemon(index: 1).startOffset + kDolToRAMOffsetDifference + 0x92).hexString())

//XGDecks.DeckDarkPokemon.allDeckPokemon.forEach { (mon) in
//    if mon.data.species.catchRate != mon.data.shadowCatchRate {
//        print(mon.data.species.name, mon.data.species.catchRate, mon.data.shadowCatchRate)
//    }
//}
//XGUtility.documentISO()

//XGTrainerClasses.documentEnumerationData()
//XGUtility.encodeISO()
//
//var shouldEnd = false
//while !shouldEnd {
//	if let input = readLine(), input.contains("c") {
//		XGUtility.cancelEncoding()
//		shouldEnd = true
//	}
//}
//
//for id in [20, 83, 18] {
//	let mon = XGTrainerPokemon(DeckData: .ddpk(id))
//	mon.shadowAlwaysFlee = 0
//	mon.save()
//}
//
//for id in [31, 16, 22] {
//	let mon = XGTrainerPokemon(DeckData: .ddpk(id))
//	mon.shadowAlwaysFlee = 1
//	mon.save()
//}
//XGUtility.compileAllFiles()
//
//for mon in XGDecks.DeckDarkPokemon.allPokemon {
//	print(mon.deckData.index,mon.species.name, mon.shadowAlwaysFlee)
//}

//XGUtility.printOccurencesOfMove(search: move("bounce"))
//XGUtility.documentISO()

//let imageFile = XGFiles.nameAndFolder("uv_icn_type_big_00.gtx.png", .Import)
//let image = imageFile.image
//for texture in GoDTextureImporter.getMultiFormatTextureData(image: image) {
//	let fileName = imageFile.fileName.removeFileExtensions() + "_" + texture.format.name + ".gtx"
//	texture.file = .nameAndFolder(fileName, .Documents)
//	texture.save()
//	texture.saveImage(file: .nameAndFolder(fileName + ".png", .Documents))
//}

//XGUtility.exportTextures()
//
//let filename = "types"
//let image = XGFiles.nameAndFolder(filename + ".png", .Import).image
//let t = GoDTextureImporter.getTextureData(image: image)
//t.file = .nameAndFolder(filename + ".gtx", .TextureImporter)
//t.save()
//t.saveImage(file: .nameAndFolder(filename + ".png", .TextureImporter))


//for image in XGFolders.Import.files where image.fileType == .png {
//	let texture = GoDTextureImporter.getTextureData(image: image.image)
//	let filename = image.fileName + "_" + texture.format.name
//	texture.file = .nameAndFolder(filename + ".gtx", .TextureImporter)
//	texture.save()
//	texture.saveImage(file: .nameAndFolder(filename + ".png", .TextureImporter))
//}


//let count = CommonIndexes.NumberBGM.value
//let start = CommonIndexes.BGM.startOffset
////let rel = XGFiles.common_rel.data!
//
//printg(count)
//for i in 0 ..< count {
//	let offset = start + (i * 12)
//	let fsysID = rel.get2BytesAtOffset(offset + 2)
//	if let fsys = ISO.getFSYSNameWithGroupID(fsysID) {
//		printg(i, fsys)
//	}
//}

//let p = common.allPointers()
//for i in 0 ..< p.count {
//	printg(i, p[i].hexString())
//}

//for i in 0 ..< CommonIndexes.NumberOfInteractionPoints.value {
//	let p = XGInteractionPointData(index: i)
//	switch p.info {
//	case .Script(let scriptIndex, let parameter):
//		if parameter != 0 {
//			printg(i, p.roomID, scriptIndex)
//		}
//	default: break
//	}
//}


//let folder = XGFolders.ISOExport("pkx_usohachi")
//let bonsly = XGFiles.nameAndFolder("usohachi.pkx", folder).data!
//let munchlax = XGFiles.nameAndFolder("gonbe_0100.fdat", folder).data!
//
//let munchSize = munchlax.get4BytesAtOffset(0)
//let bonSize = bonsly.get4BytesAtOffset(0)
//
//var paddedMunchSize = munchSize
//paddedMunchSize += (16 - paddedMunchSize % 16)
//
//bonsly.replace4BytesAtOffset(0, withBytes: munchSize)
//bonsly.replaceBytesFromOffset(0xE60, withByteStream: [Int](repeating: 0, count: paddedMunchSize))
//bonsly.replaceData(data: munchlax, atOffset: 0xE60)
//bonsly.deleteBytes(start: paddedMunchSize + 0xe60, count: bonSize - paddedMunchSize - 0xe60)
//
//bonsly.save()

//XGUtility.compileCommonRel()
//CommonIndexes.Doors.startOffset.hexString().println()

//let cd = item("Battle CD 01")
//let locations = XGUtility.getItemLocations()
//for i in 1 ... 50 {
//	let cd = XGBattleCD(index: i)
//	let location = locations[cd.getItem().index]
//	printg(i, location.count > 0 ? location[0] : "-", "\n", cd.cdDescription, "\n", cd.conditions, "\n")
//}


