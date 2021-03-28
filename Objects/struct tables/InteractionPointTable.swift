//
//  InteractionPointTable.swift
//  GoD Tool
//
//  Created by Stars Momodu on 24/03/2021.
//

import Foundation

let interactionPointStruct = GoDStruct(name: "Interaction Point", format: [
	.byte(name: "Interaction Method", description: "", type: .interactionMethod),
	.short(name: "Room ID", description: "", type: .roomID),
	.word(name: "Collision Region Index", description: "The index of the region in the .ccd collision file for this interaction", type: .uint),
	.short(name: "Script Marker", description: "Determines if the script function will be the current script or common script", type: .scriptMarker),
	.short(name: "Script Function Index", description: "The index of the function in the script file to trigger", type: .uint),
	.array(name: "Parameters", description: "The parameters that are passed to the script function", property: .word(name: "Parameter", description: "", type: .uintHex), count: 4)
])

let interactionPointsTable = CommonStructTable(index: .InteractionPoints, properties: interactionPointStruct)
