//
//  main.swift
//  Revolution Tool
//
//  Created by The Steez on 24/12/2018.
//

import Foundation

//XGFolders.setUpFolderFormat()

//XGFiles.fsys("common").fsysData.extractFilesToFolder(folder: .Common, decode: true)
////XGFiles.fsys("common").fsysData.extractFilesToFolder(folder: .Common, decode: true)
//let msg = XGFiles.fsys("mes_common").fsysData.decompressedDataForFileWithIndex(index: 1)!
//msg.file = .msg("mes_common")
//msg.save()
//for file in XGFolders.FSYS.files where file.fileType == .fsys {
//	let fsys = file.fsysData
//	if let msg = fsys.decompressedDataForFileWithFiletype(type: .msg) {
//		msg.file = .msg(msg.file.fileName.removeFileExtensions())
//		msg.save()
//	}
//}
//move("surf").nameID.hexString().println()
//for move in allMovesArray() {
//	let data  = PBRDataTableEntry(index: move.index + 1, tableId: 30)
//	printg(move.name.unformattedString.spaceToLength(15), data.getByte(19).binary(), data.getByte(22))
//}
//XGFiles.fsys("wzx_waza_001").fsysData.extractFilesToFolder(folder: .Documents, decode: true)
XGFiles.nameAndFolder("wzx_waza_001 0000.scd", .Documents).writeScriptData()

//for i in 0 ... 0x1f4 {
//	let entry = PBRDataTableEntry(index: i, tableId: 9)
//	for j in 0 ... 6 {
//		let start = j * 6
//		let method = entry.getShort(start)
//		let condition = entry.getShort(start + 2)
//		let newspec = entry.getShort(start + 4)
//		let oldspec = i
//
//		if newspec > 0 {
//
//			let oldname = getStringSafelyWithID(id: oldspec + 9).string
//			let newname = getStringSafelyWithID(id: newspec + 9).string
//
//			printg(i, sanitise(oldname), sanitise(newname), method, condition)
//		}
//
//	}
//}



//for file in XGFolders.Common.files.sorted(by: { $0.fileName < $1.fileName }) where file.fileType == .dta {
//	let table = PBRDataTable(file: file)
//	printg(table, "\n\n")
//}
