//
//  ItemStatsTable.swift
//  GoD Tool
//
//  Created by Stars Momodu on 20/03/2021.
//

import Foundation

let itemStatsTable = CommonStructTable(index: region == .JP ? 2 : 19, properties: GoDStruct(name: "Items", format: [
	.short(name: "Price", description: "", type: .uint),
	.short(name: "Name ID", description: "", type: .msgID(file: nil)),
	.short(name: "Description", description: "", type: .msgID(file: nil)),
	.short(name: "Unknown 1", description: "", type: .uint),
	.byte(name: "Hold Item ID", description: "Identifier used for item type. Referenced by the Assembly code.", type: .uint),
	.byte(name: "Parameter", description: "Determines how effective the item is. Referenced by the Assembly code.", type: .int),
	.array(name: "Unknown Values", description: "", property: .byte(name: "Unknown Value", description: "", type: .uint), count: 2),
	.byte(name: "Fling Base Power", description: "The base power of the move fling when holding this item", type: .uint),
	.byte(name: "Unknown 2", description: "", type: .uint),
	.byte(name: "Unknown 3", description: "", type: .uint),
	.byte(name: "Unknown 4", description: "", type: .uint),
	.byte(name: "Field ID", description: "Identifier used for the item in the overworld", type: .uint),
	.byte(name: "Battle ID", description: "Identifier used for item type in battle. Reference by the Assembly code.", type: .uint),
	.byte(name: "Unknown Flag", description: "", type: .bool),
	.byte(name: "Padding", description: "", type: .null),
	.byte(name: "Sub Parameter", description: "A secondary parameter referenced by the Assembly code.", type: .uint),
	.byte(name: "Unknown 5", description: "", type: .uint),
	.short(name: "Padding 2", description: "", type: .null),
	.byte(name: "Unknown 6", description: "", type: .uint),
	.byte(name: "Sub ID", description: "Another id referenced by the Assembly code", type: .uint),
	.word(name: "Padding 3", description: "", type: .null),
	.byte(name: "Unknown 7", description: "", type: .uint),
	.byte(name: "Healing parameter", description: "Determines how effective a healing item is", type: .uint),
	.byte(name: "PP Parameter", description: "Determines how effective a PP boosting item is", type: .uint),
	.array(name: "Happiness effects", description: "How much using the item affects the pokemon's happiness", property:
		.byte(name: "", description: "", type: .int), count: 3),
	.short(name: "Padding", description: "", type: .null)
]))
