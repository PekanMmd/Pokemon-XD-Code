//
//  main.swift
//  XGCommandLineTools
//
//  Created by StarsMmd on 13/11/2015.
//  Copyright © 2015 StarsMmd. All rights reserved.
//
//

//XGFiles.nameAndFolder("esaba_A.fsys", .AutoFSYS).fsysData.extractFilesToFolder(folder: .Reference)

//item("XG000 Photo").name.duplicateWithString("Photo").replace()

//// added battle cds to selection string
//getStringSafelyWithID(id: 0x8105).duplicateWithString("Welcome back!").replace()
//getStringSafelyWithID(id: 0x8106).duplicateWithString("Welcom back!").replace()

//XGFolders.Scripts.map { (file) in
//	printg("saving script:", file.fileName)
//	XGUtility.saveString(file.scriptData.description, toFile: .nameAndFolder(file.fileName + ".txt", .Reference))
//}


//let cd = item("Battle CD 01")
//let locations = XGUtility.getItemLocations()
//for i in 1 ... 50 {
//	let cd = XGBattleCD(index: i)
//	let location = locations[cd.getItem().index]
//	printg(i, location.count > 0 ? location[0] : "-", "\n", cd.cdDescription, "\n", cd.conditions, "\n")
//}





//XGUtility.compileForRelease(XG: true)
//XGUtility.documentISO(forXG: true)

//// repeat ball catch rate to 3.5x
//XGAssembly.replaceASM(startOffset: 0x21942c - kDOLtoRAMOffsetDifference, newASM: [0x3b800023])
//
////// timer ball update to gen V+ mechanics (maxes in 12 turns)
////XGAssembly.replaceASM(startOffset: 0x219444 - kDOLtoRAMOffsetDifference, newASM: [
////	0x0, // r28 = r3 * 3
////	0x0, // r28 = r28 / 2
////	0x0, // addi r28, r28, 10
////	])
//
//// nest ball start = 0x802193a8
//


//XGUtility.compileAllFiles()

