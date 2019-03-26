//
//  main.swift
//  XGCommandLineTools
//
//  Created by StarsMmd on 13/11/2015.
//  Copyright © 2015 StarsMmd. All rights reserved.
//
//

//XGUtility.exportTextures()

let filename = "types"
let image = XGFiles.nameAndFolder(filename + ".png", .Import).image
let t = GoDTextureImporter.getTextureData(image: image)
t.file = .nameAndFolder(filename + ".gtx", .TextureImporter)
t.save()
t.saveImage(file: .nameAndFolder(filename + ".png", .TextureImporter))


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


