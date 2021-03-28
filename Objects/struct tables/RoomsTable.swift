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
	.byte(name: "Unknown", description: "", type: .uintHex),
	.short(name: "Room ID", description: "", type: .uintHex),
	.array(name: "Unused Values", description: "", property:
		.word(name: "Unused", description: "", type: .null), count: 5),
	.word(name: "Name ID", description: "", type: .msgID(file: .common_rel)),
	.array(name: "Unused Values 2", description: "", property:
		.word(name: "Unused", description: "", type: .null), count: 4),
	.array(name: "Fsys IDs", description: "One entry for each language, though they all use the same fsys id anyway.", property:
		.word(name: "Fsys ID", description: "", type: .fsysID), count: 5)
])

let roomStructSingleLanguage = GoDStruct(name: "Room", format: [
	.byte(name: "Area ID", description: "", type: .uintHex),
	.byte(name: "Unknown", description: "", type: .uintHex),
	.short(name: "Room ID", description: "", type: .uintHex),
	.word(name: "Fsys ID", description: "", type: .fsysID),
	.array(name: "Unused Values", description: "", property:
		.word(name: "Unused", description: "", type: .null), count: 5),
	.word(name: "Name ID", description: "", type: .msgID(file: .common_rel)),
	.array(name: "Unused Values 2", description: "", property:
		.word(name: "Unused", description: "", type: .null), count: 4)
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
