//
//  main.swift
//  XGCommandLineTools
//
//  Created by StarsMmd on 13/11/2015.
//  Copyright © 2015 StarsMmd. All rights reserved.
//
//

XGBattle.allValues.forEachIndexed({ (index, battle) in
	printg("\(index):")
	printg(battle.description)
})

//var csv = "Spot,Index,Species,Percentage,Min Level,Max Level"
//for i in 0 ..< XGPokeSpots.allCases.count {
//	let spot = XGPokeSpots(rawValue: i)!
//	for j in 0 ..< spot.numberOfEntries {
//		let mon = XGPokeSpotPokemon(index: j, pokespot: spot)
//		csv += ",\n\(spot.enumerableName),\(j),\(mon.pokemon.name.unformattedString),\(mon.encounterPercentage),\(mon.minLevel),\(mon.maxLevel)"
//	}
//}
//XGUtility.saveString(csv, toFile: .nameAndFolder("XG Pokespots.csv", .Documents))

//XGUtility.extractAllTextures()


//ISO.allFileNames.count.hexString().println()


////let m1_out = XGFiles.fsys("M1_out")
//let m4_out = XGFiles.nameAndFolder("M4_out.fsys", .AutoFSYS)
////let m4_outData = m1_out.data!
////m4_outData.file = m4_out
////m4_outData.save()
////ISO.addFile(m4_out, save: true)
//
////let m4fsys = m4_out.fsysData
////m4fsys.setGroupID(0xF001)
////m4fsys.save()
//
//CommonIndexes.Rooms.startOffset.hexString().println()
//ISO.getFSYSNameWithGroupID(0xf001)?.println()
////ISO.getFSYSNameWithGroupID(0xa3)?.println()
////XGRoom


//CommonIndexes.BGM.startOffset.hexString().println()
//ISO.getFSYSForIdentifier(id: 0x14EC2800)?.fileName.println()
//ISO.getFSYSDataWithGroupID(0x7b0)?.fileName.println()
//let start = CommonIndexes.BGM.startOffset
//printg(start.hexString())
//XGASM.loadImmediateShifted32bit(register: .r3, value: 0x80B65104).0.code.hexString().println()
//XGASM.loadImmediateShifted32bit(register: .r3, value: 0x80B65104).1.code.hexString().println()

//(0x4efe20 - 0x4e8844).hexString().println()
//XGASM.lwz(.r3, .r13, -0x75dc).code.hexString().println()


//for (functionIndex, codeOffset) in [(0,0xb99790),(1,0xb997c4),(2,0xb997f8)] {
//
//	XGScriptClass.addASMFunctionToCustomClass(jumpTableRAMOffset: 0xb99390, functionIndex: functionIndex, codeOffsetInRAM: codeOffset, code: [])
//}
//XGScriptClass.classes(34).repointToRAMOffset(0xb99350)
//XGUtility.compileMainFiles()



//for file in XGFolders.XDS.files where file.fileType == .xds {
//	printg("Compiling script:", file.fileName)
//	XDSScriptCompiler.compile(textFile: file, toFile: .scd(file.fileName.removeFileExtensions()))
//}
//
//XGUtility.compileAllMapFsys()





//XGUtility.saveMewTutorMovePairs()
//print((XGDemoStarterPokemon(index: 1).startOffset + kDolToRAMOffsetDifference + 0x92).hexString())



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

//XGUtility.compileCommonRel()
//CommonIndexes.Doors.startOffset.hexString().println()



