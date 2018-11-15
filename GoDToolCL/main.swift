//
//  main.swift
//  XGCommandLineTools
//
//  Created by StarsMmd on 13/11/2015.
//  Copyright © 2015 StarsMmd. All rights reserved.
//
//

XGUtility.deleteSuperfluousFiles()
XGUtility.compileAllFiles()

for i in 0 ..< ISO.filesOrdered.count {
	let file = ISO.filesOrdered[i]
	let start = ISO.locationForFile(file)!
	let end = start + ISO.sizeForFile(file)!
	let next = i == ISO.filesOrdered.count - 1 ? ISO.data.length : ISO.locationForFile(ISO.filesOrdered[i + 1])!
	printg(file.spaceToLength(40), start.hexString(), end.hexString(), end > next ? "bruh" : "", ISO.sizeForFile(file)! <= 0x60 ? "deleted" : "" )
}


XGAssembly.ASMfreeSpacePointer().hexString().println()



//XGScriptClass.classes(43).RAMOffset!.hexString().println()
//XGAssembly.getWordAtRamOffsetFromR13(offset: -0x74b0).hexString().println() //number battle types

//let cd = item("Battle CD 01")
//let locations = XGUtility.getItemLocations()
//for i in 1 ... 50 {
//	let cd = XGBattleCD(index: i)
//	let location = locations[cd.getItem().index]
//	printg(i, location.count > 0 ? location[0] : "-", "\n", cd.cdDescription, "\n", cd.conditions, "\n")
//}


