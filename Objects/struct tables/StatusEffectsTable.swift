//
//  StatusEffectsTable.swift
//  GoD Tool
//
//  Created by Stars Momodu on 07/04/2021.
//

import Foundation

let statusEffectsStruct = GoDStruct(name: "Status Effects", format: [
	.byte(name: "Effect Type", description: "", type: .uint),
	.byte(name: "Sub Index", description: "", type: .uint),
	.byte(name: "Unknown 1", description: "", type: .uint),
	.byte(name: "Unknown 2", description: "", type: .uint),
	.byte(name: "Number Of Turns", description: "0 for infinite", type: .uint),
	.array(name: "Unknown Flags", description: "", property:
		.byte(name: "Unknown Flag", description: "", type: .bool), count: 3),
	.short(name: "Unknown 3", description: "", type: .uint),
	.short(name: "Base Weather ID", description: "The status effect for the non permanent version of this weather", type: .uint),
	.word(name: "Padding", description: "Probably filled in dynamically in RAM while game is running", type: .null),
	.word(name: "Name ID", description: "", type: .msgID(file: .nameAndFsysName("fight.msg", "fight_common")))
])

let statusEffectsTable = GoDStructTable(file: .dol, properties: statusEffectsStruct, startOffsetForFirstEntryInFile: { (_) -> Int in
	return kFirstStatusEffectOffset
}, numberOfEntriesInFile: { (_) -> Int in
	return kNumberOfStatusEffects
}, nameForEntry: { (index, _) -> String? in
	return XGStatusEffects(rawValue: index)?.string ?? "Status Effect \(index)"
})
