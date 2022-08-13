//
//  FlagStructTables.swift
//  GoD Tool
//
//  Created by Stars Momodu on 18/04/2022.
//

import Foundation

let storyProgressionFlagStruct = GoDStruct(name: "Story Progression Flag", format: [
	.word(name: "Unknown 1", description: "", type: .uintHex),
	.word(name: "Unknown 2", description: "", type: .uintHex),
	.word(name: "Progress Value", description: "The value the story progress flag is set to at this point in the story", type: .uint),
	.short(name: "Script Marker", description: "Determines if the script function will be the current script or common script", type: .scriptMarker),
	.short(name: "Script Function Index", description: "The index of the function in the script file to trigger", type: .uint),
	.float(name: "Unknown 3", description: ""),
	.float(name: "Unknown 4", description: ""),
	.float(name: "Unknown 5", description: ""),
	.word(name: "Name ID", description: "", type: .msgID(file: .dol))
])
let storyProgressionFlagTable = CommonStructTable(index: .StoryProgressFlags, properties: storyProgressionFlagStruct)
