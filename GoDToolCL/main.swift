//
//  main.swift
//  XGCommandLineTools
//
//  Created by StarsMmd on 13/11/2015.
//  Copyright © 2015 StarsMmd. All rights reserved.
//
//

for i in 0 ..< CommonIndexes.NumberOfBattles.value {
	let battle = XGBattle(index: i)
	printg(battle.BGMusicID, battle.BGMusicID.hexString(), battle.p2Trainer != nil ? battle.p2Trainer!.name.string : "-")
}

//XGUtility.documentXDS()


//let name = "M5_apart_1F"
//XDSScriptCompiler.compile(textFile: .xds(name), toFile: .nameAndFolder(name + ".scd", .Documents))

//XGScriptClass.classes(43).RAMOffset!.hexString().println()

//XGAssembly.ASMfreeSpacePointer().hexString().println()


//XGUtility.compileDol()
//XGUtility.compileCommonRel()
//XGUtility.compileMainFiles()
//XGUtility.compileAllFiles()
//XGUtility.compileForRelease(XG: true)
//XGUtility.documentISO(forXG: true)

//XGUtility.documentXDS()


//XGAssembly.getWordAtRamOffsetFromR13(offset: -0x74b0).hexString().println() //number battle types

//let cd = item("Battle CD 01")
//let locations = XGUtility.getItemLocations()
//for i in 1 ... 50 {
//	let cd = XGBattleCD(index: i)
//	let location = locations[cd.getItem().index]
//	printg(i, location.count > 0 ? location[0] : "-", "\n", cd.cdDescription, "\n", cd.conditions, "\n")
//}


