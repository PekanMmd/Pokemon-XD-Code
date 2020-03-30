//
//  main.swift
//  Revolution Tool
//
//  Created by The Steez on 24/12/2018.
//

import Foundation

let mon = pokemon("omastar")
mon.name.println()
mon.nameID.hexString().println()

//let string = XGString(string: "カイオーガ", file: nil, sid: 1)
//print(string.chars)

//XGMoves.allMoves().map{$0.data}.sorted(by: { (m1, m2) -> Bool in
//	m1.target.rawValue < m2.target.rawValue
//}).forEach { (move) in
//	printg("\(move.name.unformattedString) - \(move.target)")
//}

//GoDShellManager.run(.wit, args: "-h")
//settings.verbose = true
//XGUtility.decompileISO()
//XGUtility.compileISO()


//XGUtility.extractAllFiles()
//let fsysData = XGFiles.fsys("mes_common").fsysData
//let folder = XGFolders.ISOExport("mes_common")
//for i in 0 ..< fsysData.numberOfEntries {
//	let filename = fsysData.numberedFileNames[i].removeFileExtensions() + fsysData.fileTypeForFile(index: i).fileExtension
//	for file in folder.files {
//		if file.fileName == filename {
//			if fsysData.isFileCompressed(index: i){
//				fsysData.shiftAndReplaceFileWithIndexEfficiently(i, withFile: file.compress(), save: false)
//			} else {
//				fsysData.shiftAndReplaceFileWithIndexEfficiently(i, withFile: file, save: false)
//			}
//		}
//	}
//}
//fsysData.save()

//for i in 0 ..< kNumberOfTypes {
//	let type = XGMoveTypes.type(i).data
//	print(i, type.nameID, type.name)
//}
//
//let fairy = XGMoveTypes.type(9).data
//fairy.name.duplicateWithString("[0xF001][0xF101]Fairy").replace()
//for type in XGMoveTypes.allTypes {
//	fairy.setEffectiveness(.neutral, againstType: type)
//}
//for type: XGMoveTypes in [.fighting, .dragon, .dark] {
//	fairy.setEffectiveness(.superEffective, againstType: type)
//}
//for type: XGMoveTypes in [.poison, .steel, .fire] {
//	fairy.setEffectiveness(.notVeryEffective, againstType: type)
//}
//fairy.save()
//for type: XGMoveTypes in [.poison, .steel] {
//	let data = type.data
//	data.setEffectiveness(.superEffective, againstType: .type(9))
//	data.save()
//}
//for type: XGMoveTypes in [.fighting, .bug, .dark] {
//	let data = type.data
//	data.setEffectiveness(.notVeryEffective, againstType: .type(9))
//	data.save()
//}
//for type: XGMoveTypes in [.dragon] {
//	let data = type.data
//	data.setEffectiveness(.ineffective, againstType: .type(9))
//	data.save()
//}
//
//for i in 0 ..< kNumberOfTypes {
//	let type = XGMoveTypes.type(i).data
//	print(i, type.nameID, type.name)
//}
//
//for name in ["clefairy", "clefable", "cleffa", "togepi", "togetic", "snubbull", "granbull", "mime jr.", "togekiss"] {
//	let mon = pokemon(name).stats
//	mon.type1 = .type(fairy.index)
//	mon.save()
//}
//
//for name in ["azurill", "marill", "azumarill", "clefairy", "clefable", "jigglypuff", "wigglytuff", "mr. mime", "cleffa", "igglybuff", "togepi", "snubbull", "granbull", "mawile", "ralts", "kirlia", "gardevoir"] {
//	let mon = pokemon(name).stats
//	mon.type2 = .type(fairy.index)
//	mon.save()
//}

