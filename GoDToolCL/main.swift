//
//  main.swift
//  XGCommandLineTools
//
//  Created by StarsMmd on 13/11/2015.
//  Copyright © 2015 StarsMmd. All rights reserved.
//
//


////let updated = XGFolders.nameAndFolder("updated scripts", .Documents)
////for filename in updated.filenames {
//for filename in ["M3_out.xds"] {
//	let name = filename.removeFileExtensions()
//	XDSScriptCompiler.setFlags(disassemble: false, decompile: false, updateStrings: false, increaseMSG: true)
//	if XDSScriptCompiler.compile(textFile: .xds(name)) {
//		printg("success: ", filename)
//		let fsys = XGFiles.fsys(name)
//		fsys.compileMapFsys()
//		ISO.importFiles([fsys])
//	} else {
//		printg("\nCompilation error: \(filename)\n\(XDSScriptCompiler.error)\n")
//	}
//}

//XGUtility.compileMainFiles()
//XGUtility.compileAllFiles()

//XGAssembly.ASMfreeSpacePointer().hexString().println()



//XGScriptClass.classes(43).RAMOffset!.hexString().println()
//XGAssembly.getWordAtRamOffsetFromR13(offset: -0x74b0).hexString().println() //number battle types

//let cd = item("Battle CD 01")
//let locations = XGUtility.getItemLocations()
//for i in 1 ... 50 {
//	let cd = XGBattleCD(index: i)
//	let location = locations[cd.getItem().index]
//	printg(i, location.count > 0 ? location[0] : "-", "\n", cd.cdDescription, "\n", cd.conditions, "\n")
//}


