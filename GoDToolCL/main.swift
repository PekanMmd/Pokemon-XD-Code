//
//  main.swift
//  XGCommandLineTools
//
//  Created by StarsMmd on 13/11/2015.
//  Copyright © 2015 StarsMmd. All rights reserved.
//
//

let folder = XGFolders.nameAndFolder("updated scripts", .Documents)
let file = XGFiles.nameAndFolder("M1_pc_B1.xds", folder)
XDSScriptCompiler.setFlags(disassemble: true, decompile: true, updateStrings: true, increaseMSG: true)
if !XDSScriptCompiler.compile(textFile: file) {
	printg(file.fileName, XDSScriptCompiler.error)
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


