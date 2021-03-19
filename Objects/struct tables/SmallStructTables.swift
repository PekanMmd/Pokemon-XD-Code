//
//  SmallStructTables.swift
//  GoD Tool
//
//  Created by Stars Momodu on 18/03/2021.
//

import Foundation

let trainerClassesStruct = GoDStruct(name: "TrainerClasses", format: [
	.short(name: "Payout", description: "The multiplier for the prize money", type: .uint),
	.word(name: "Name", description: "The msg ID for the trainer class name", type: .msgID(file: .common_rel)),
	.word(name: "Unknown", description: "Usually 5 but occasionally 8", type: .uint)
])

var trainerClassesTable = {
	CommonStructTable(index: CommonIndexes.TrainerClasses.rawValue, properties: trainerClassesStruct)
}
