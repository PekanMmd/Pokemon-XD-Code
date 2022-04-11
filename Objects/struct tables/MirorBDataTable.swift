//
//  MirorBDataTable.swift
//  GoD Tool
//
//  Created by Stars Momodu on 12/04/2021.
//

import Foundation

let mirorBLocationStruct = GoDStruct(name: "Miror B Location", format: [
	.short(name: "Unknown", description: "", type: .uint),
	.short(name: "Room ID", description: "Room ID for the area's outside map.", type: .roomID),
	.word(name: "Name ID", description: "MSG ID for the town/location", type: .msgID(file: .typeAndFsysName(.msg, "pocket_menu")))
])

let mirorBDataStruct = GoDStruct(name: "Miror B Data", format: [
	.short(name: "Steps Per Cycle", description: "", type: .uint),
	// these values are used to determine the probability of something
	.short(name: "Unknown 2", description: "", type: .uint),
	.short(name: "Unknown 3", description: "", type: .uint),
	.short(name: "Unknown 4", description: "", type: .uint),
	.short(name: "Unknown 5", description: "", type: .uint),
	.short(name: "Unknown 6", description: "", type: .uint),
	.word(name: "Has Encountered Miror B Flag", description: "", type: .flagID),
	.word(name: "Steps Walked Flag", description: "", type: .flagID),
	.word(name: "Radar Status Flag", description: "Flag for the current signal strength", type: .flagID),
	.word(name: "Current Location Flag", description: "", type: .flagID),
	.word(name: "Unknown Flag ID 5", description: "", type: .flagID),
	.word(name: "Don't Lose Signal Flag", description: "", type: .flagID),
	.word(name: "Unknown Flag ID 7", description: "", type: .flagID),
	.word(name: "Unknown 7", description: "", type: .uintHex),
	.word(name: "Unknown 8", description: "", type: .uintHex),
	.word(name: "Unknown 9", description: "", type: .uintHex),
	.array(name: "Encounter Locations", description: "", property:
		.subStruct(name: "Miror B Location", description: "", property: mirorBLocationStruct),
		count: 7)
])

let mirorBDataTable = CommonStructTable(index: .MirorBData, properties: mirorBDataStruct)
