//
//  TreasureTable.swift
//  GoD Tool
//
//  Created by Stars Momodu on 24/03/2021.
//

import Foundation

let treasureStruct = GoDStruct(name: "Treasure", format: [
	.byte(name: "Model ID", description: "", type: .uintHex),
	.byte(name: "Quantity", description: "", type: .uint),
	.short(name: "Angle", description: "", type: .angle),
	.short(name: "Room ID", description: "", type: .roomID),
	.short(name: "Flag ID", description: "The flag that determines if the item has been received already", type: .uintHex),
	.word(name: "Padding", description: "", type: .null),
	.word(name: "Item ID", description: "", type: .itemID),
	.subStruct(name: "Coordinates", description: "", property: GoDStruct(name: "Coordinates", format: [
		.float(name: "Position X", description: ""),
		.float(name: "Position Y", description: ""),
		.float(name: "Position Z", description: ""),
	]))
])

let treasureTable = CommonStructTable(index: .TreasureBoxData, properties: treasureStruct)
