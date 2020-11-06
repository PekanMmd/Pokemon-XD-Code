//
//  Code snippets.swft.swift
//  GoD Tool
//
//  Created by Stars Momodu on 28/10/2020.
//

// Add fairy type
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
