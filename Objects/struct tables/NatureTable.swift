//
//  NatureTable.swift
//  GoD Tool
//
//  Created by Stars Momodu on 25/03/2021.
//

import Foundation

let natureStruct = GoDStruct(name: "Nature", format: [
	.byte(name: "Battle Purification Multiplier", description: "Determines how effective battling is for purifying a pokemon with this nature", type: .indexOfEntryInTable(table: multipliersTable, nameProperty: nil)),
	.byte(name: "Walking Purification Multiplier", description: "Determines how effective walking is for purifying a pokemon with this nature", type: .indexOfEntryInTable(table: multipliersTable, nameProperty: nil)),
	.byte(name: "Call Purification Multiplier", description: "Determines how effective calling out of reverse mode is for purifying a pokemon with this nature", type: .indexOfEntryInTable(table: multipliersTable, nameProperty: nil)),
	.byte(name: "Day Care Purification Multiplier", description: "Determines how effective leaving the pokemon in the day care is for purifying a pokemon with this nature", type: .indexOfEntryInTable(table: multipliersTable, nameProperty: nil)),
	.byte(name: "Cologn Massage Purification Multiplier", description: "Determines how effective Cologn Massaging is for purifying a pokemon with this nature", type: .indexOfEntryInTable(table: multipliersTable, nameProperty: nil)),
	.byte(name: "Attack Multiplier", description: "", type: .indexOfEntryInTable(table: multipliersTable, nameProperty: nil)),
	.byte(name: "Defense Multiplier", description: "", type: .indexOfEntryInTable(table: multipliersTable, nameProperty: nil)),
	.byte(name: "Sp.Atk Multiplier", description: "", type: .indexOfEntryInTable(table: multipliersTable, nameProperty: nil)),
	.byte(name: "Sp.Def Multiplier", description: "", type: .indexOfEntryInTable(table: multipliersTable, nameProperty: nil)),
	.byte(name: "Speed Multiplier", description: "", type: .indexOfEntryInTable(table: multipliersTable, nameProperty: nil)),
	.byte(name: "Unknown", description: "Set to 100 for all natures by default", type: .uintHex),
	.array(name: "Unknown Values", description: "", property:
		.byte(name: "Unknown Value", description: "", type: .uintHex), count: 8),
	.word(name: "Name ID", description: "", type: .msgID(file: .common_rel)),
	.array(name: "Unknown Values 2", description: "", property:
		.byte(name: "Unknown Value", description: "", type: .uintHex), count: 14)
])

let naturesTable = CommonStructTable(index: .Natures, properties: natureStruct)
