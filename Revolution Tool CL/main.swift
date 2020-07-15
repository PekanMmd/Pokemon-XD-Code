//
//  main.swift
//  Revolution Tool
//
//  Created by The Steez on 24/12/2018.
//

import Foundation

PBRTypeManager.typeMatchupDataDolOffset?.hexString().println()

XGUtility.extractMainFiles()

//let itemData = item("quick claw").data
//for register: XGRegisters in [.r0, .r3, .r4, .r5, .r6] {
//	let value = itemData.holdItemID
//	XGASM.cmpwi(register, value).code.hexString().println()
//	XGASM.li(register, value).code.hexString().println()
//	XGASM.cmplwi(register, UInt32(value)).code.hexString().println()
//}

//itemData.writeJSON(to: .nameAndFolder("Quick Claw.json", .Documents))

//for item in XGItems.allItems() where item.data.holdItemID > 0 {
//	let data = item.data
//	print(item.name.unformattedString.spaceToLength(20), data.holdItemID)
//}

//XGFiles.msg("mes_common").stringTable.writeJSON(to: .nameAndFolder("mes_common.msg.json", .Documents))

//for m in ["curse", "weather ball", "judgment", ] {
//	let mov = move(m)
//	printg(mov.name, mov.index)
//}

//move("doom desire").data.effect.hexString().println()

//for file in XGFolders.StringTables.files {
//	print("Removing Kanji from:", file.fileName)
//	let table = file.stringTable
//	table.removeKanji()
//	table.save()
//
//	let table2 = file.stringTable
//	table2.writeJSON(to: .nameAndFolder(file.fileName + ".json", .Documents))
//}


//for file in XGFolders.MSG.files {
//	let jsonFile = XGFiles.nameAndFolder(file.fileName + ".json", .Documents)
//	file.stringTable.writeJSON(to: jsonFile)
//}

//let table = try? XGStringTable.fromJSONFile(file: .nameAndFolder("mes_common.msg.json", .Documents))
//if let table = table {
//	table.file = .nameAndFolder("mes_common 0001.bin", .Documents)
//	table.save()
//}

//XGFiles.msg("mes_common").stringTable.writeJSON(to: .nameAndFolder("mes_common.msg.json", .Documents))

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
//
//XGUtility.compileMainFiles()
//XGUtility.compileISO()
