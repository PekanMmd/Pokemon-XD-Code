//
//  RoomsTable.swift
//  GoD Tool
//
//  Created by Stars Momodu on 25/03/2021.
//

import Foundation

#if GAME_XD
let roomStructMultiLanguage = GoDStruct(name: "Room", format: [
	.byte(name: "Area ID", description: "", type: .uintHex),
	.byte(name: "Room Type", description: "", type: .uintHex),
	.short(name: "Room ID", description: "", type: .uintHex),
	.word(name: "Map File ID", description: "Set at runtime while it's the current room.", type: .fsysFileIdentifier(fsysName: nil)),
	.word(name: "Render Data", description: "Pointer to data for things like lighting and shadows. Set at runtime.", type: .pointer),
	.word(name: "Character Data", description: "Pointer to data for characters. Set at runtime.", type: .pointer),
	.word(name: "Warp Point Data", description: "Pointer to data for warp points. Set at runtime.", type: .pointer),
	.word(name: "Camera Data", description: "Pointer to data for cameras. Set at runtime.", type: .pointer),
	.word(name: "Name ID", description: "", type: .msgID(file: .common_rel)),
	.word(name: "Preprocess Script Function ID", description: "ID of preprocess function called before the player loads into the room. Seems unused.", type: .uintHex),
	.word(name: "Main Script Function ID", description: "ID of hero_main function called every frame while in that room. Seems unused.", type: .uintHex),
	.word(name: "Postprocess Script Function ID", description: "ID of postprocess function called after the player loads into the room. Seems unused.", type: .uintHex),
	.word(name: "Unused", description: "unused", type: .null),
	.array(name: "Fsys IDs", description: "One entry for each language, though they all use the same fsys id anyway.", property:
		.word(name: "Fsys ID", description: "", type: .fsysID), count: 5)
])

let roomStructSingleLanguage = GoDStruct(name: "Room", format: [
	.byte(name: "Area ID", description: "", type: .uintHex),
	.byte(name: "Room Type", description: "", type: .uintHex),
	.short(name: "Room ID", description: "", type: .uintHex),
	.word(name: "Fsys ID", description: "", type: .fsysID),
	.word(name: "Map File ID", description: "Set at runtime while it's the current room.", type: .fsysFileIdentifier(fsysName: nil)),
	.word(name: "Render Data", description: "Pointer to data for things like lighting and shadows. Set at runtime.", type: .pointer),
	.word(name: "Character Data", description: "Pointer to data for characters. Set at runtime.", type: .pointer),
	.word(name: "Warp Point Data", description: "Pointer to data for warp points. Set at runtime.", type: .pointer),
	.word(name: "Camera Data", description: "Pointer to data for cameras. Set at runtime.", type: .pointer),
	.word(name: "Name ID", description: "", type: .msgID(file: .common_rel)),
	.word(name: "Preprocess Script Function ID", description: "ID of preprocess function called before the player loads into the room. Seems unused.", type: .uintHex),
	.word(name: "Main Script Function ID", description: "ID of hero_main function called every frame while in that room. Seems unused.", type: .uintHex),
	.word(name: "Postprocess Script Function ID", description: "ID of postprocess function called after the player loads into the room. Seems unused.", type: .uintHex),
	.word(name: "Unused", description: "unused", type: .null)
])
#else
let roomStructMultiLanguage = GoDStruct(name: "Room", format: [
	.bitArray(name: "Unknown Flags", description: "", bitFieldNames: [
		"Unknown 1",
		"Unknown 2",
		"Unknown 3",
		"Unknown 4"
	]),
	.byte(name: "Area ID", description: "", type: .uintHex),
	.word(name: "Padding", description: "", type: .null),
	.word(name: "Room ID", description: "", type: .uintHex),
	.array(name: "Unused Values", description: "", property:
		.word(name: "Unused", description: "", type: .null), count: 5),
	.word(name: "Name ID", description: "", type: .msgID(file: .common_rel)),
	.array(name: "Unknown Script Functions", description: "", property:
		.subStruct(name: "Script Function", description: "", property: GoDStruct(name: "Script Function", format: [
			.short(name: "Script", description: "", type: .scriptMarker),
			.short(name: "Function Index", description: "", type: .uint)
		])), count: 5),
	.array(name: "Unused Values 2", description: "", property:
		.word(name: "Unused", description: "", type: .null), count: 4),
	.array(name: "Fsys IDs", description: "", property:
		.word(name: "FsysID", description: "", type: .fsysID), count: 5)
])

let roomStructSingleLanguage = GoDStruct(name: "Room", format: [
	.bitArray(name: "Unknown Flags", description: "", bitFieldNames: [
		"Unknown 1",
		"Unknown 2",
		"Unknown 3",
		"Unknown 4"
	]),
	.byte(name: "Area ID", description: "", type: .uintHex),
	.word(name: "FsysID", description: "", type: .fsysID),
	.word(name: "Padding", description: "", type: .null),
	.word(name: "Room ID", description: "", type: .uintHex),
	.array(name: "Unused Values", description: "", property:
		.word(name: "Unused", description: "", type: .null), count: 5),
	.word(name: "Name ID", description: "", type: .msgID(file: .common_rel)),
	.array(name: "Unknown Script Functions", description: "", property:
		.subStruct(name: "Script Function", description: "", property: GoDStruct(name: "Script Function", format: [
			.short(name: "Script", description: "", type: .scriptMarker),
			.short(name: "Function Index", description: "", type: .uint)
		])), count: 5),
	.array(name: "Unused Values 2", description: "", property:
		.word(name: "Unused", description: "", type: .null), count: 4),
])
#endif

var roomsTable: CommonStructTable {
	#if GAME_XD
	let properties = region == .JP ? roomStructSingleLanguage : roomStructMultiLanguage
	#else
	let properties = region == .EU ? roomStructMultiLanguage : roomStructSingleLanguage
	#endif
	return CommonStructTable(index: .Rooms, properties: properties)
}

let doorStruct = GoDStruct(name: "Door", format: [
	.array(name: "Unknown Values", description: "", property: .byte(name: "Unknown", description: "", type: .int), count: 8),
	.byte(name: "Unknown 2", description: "", type: .uintHex),
	.short(name: "Door Index", description: "", type: .int),
	.short(name: "Room ID", description: "", type: .roomID),
	.short(name: "Unknown 3", description: "", type: .uintHex),
	.short(name: "Unknown 4", description: "", type: .uintHex),
	.word(name: "Room Dat ID", description: "File identifier for the .rdat model, last byte is the index for the door animation in that model", type: .fsysFileIdentifier(fsysName: nil))
])

let doorsTable = CommonStructTable(index: .Doors, properties: doorStruct)


#if GAME_XD
let worldMapLocationStruct = GoDStruct(name: "World Map Location", format: [
	.short(name: "Camera ID", description: "", type: .uint), // index of world map camera table
	.short(name: "Character ID", description: "", type: .uintHex),
	.word(name: "Availability Flag", description: "Is available once this flag is set", type: .flagID),
	.word(name: "Unknown ID", description: "", type: .uintHex),
	.word(name: "Mini Model Identifier", description: "", type: .uintHex),
	.word(name: "Image Texture ID", description: "", type: .uintHex),
	.word(name: "Move Demo Model", description: "", type: .uintHex),
	.word(name: "Name ID", description: "", type: .msgID(file: .dol)),
	.word(name: "Room ID", description: "The room to warp to", type: .roomID),
	.word(name: "Unused Text ID", description: "", type: .msgID(file: .nameAndFsysName("world_map.msg", "world_map"))),
])

let worldMapLocationsTable = CommonStructTable(index: .WorldMapLocations, properties: doorStruct)
#endif

let roomCharactersStruct = GoDStruct(name: "Room Character", format: [
	.bitArray(name: "Flags", description: "", bitFieldNames: [
		"Is Visible",
		"Load Init?",
		"Is Collision Enabled",
		"Is Head Tracking enabled",
		"Is Interactable Through Walls",
		nil,
		nil,
		nil,
	]),
	.bitMask(name: "Parameters", description: "", length: .char, values: [
		(name: "Movement Type", type: .uintHex, numberOfBits: 3, firstBitIndexLittleEndian: 6, mod: nil, div: nil, scale: nil),
		(name: "Dialog Start Type", type: .uintHex, numberOfBits: 2, firstBitIndexLittleEndian: 3, mod: nil, div: nil, scale: nil),
		(name: "Dialog End Type", type: .uintHex, numberOfBits: 2, firstBitIndexLittleEndian: 1, mod: nil, div: nil, scale: nil),
	]),
	.short(name: "Unused", description: "", type: .null),
	.short(name: "Rotation", description: "", type: .angle),
	.short(name: "Model ID", description: "", type: .uintHex),
	.short(name: "Character ID", description: "", type: .uintHex),
	.word(name: "Unknown", description: "", type: .uintHex),
	.subStruct(name: "Passive Script", description: "", property: scriptFunctionStruct),
	.subStruct(name: "Script", description: "", property: scriptFunctionStruct),
	.vector(name: "Position", description: "")
])
