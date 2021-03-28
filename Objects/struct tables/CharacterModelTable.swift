//
//  CharacterModelTable.swift
//  GoD Tool
//
//  Created by Stars Momodu on 25/03/2021.
//

import Foundation

#if GAME_XD
let characterModelStruct = GoDStruct(name: "Character Model", format: [
	.bitArray(name: "Unknown Flags", description: "", bitFieldNames: [
		"Unknown Flag 1",
		"Unknown Flag 2",
		"Unknown Flag 3",
		"Unknown Flag 4",
		"Unknown Flag 5",
		"Unknown Flag 6",
		"Unknown Flag 7",
		"Unknown Flag 8"
	]),
	.byte(name: "Unknown 1", description: "", type: .int),
	.byte(name: "Unknown 2", description: "", type: .int),
	.word(name: ".dat File Identifier", description: "", type: .fsysFileIdentifier(fsysName: "people_archive")),
	.array(name: "Unknown Values", description: "", property:
			.float(name: "", description: ""), count: 8),
	.array(name: "Unknown IDs", description: "Possibly indexes of the animation id on the model for some predefined animation type", property: .byte(name: "", description: "", type: .int), count: 12)
])
#else
let characterModelStruct = GoDStruct(name: "Character Model", format: [
	.bitArray(name: "Unknown Flags", description: "", bitFieldNames: [
		"Unknown Flag 1",
		"Unknown Flag 2",
		"Unknown Flag 3",
		"Unknown Flag 4",
		"Unknown Flag 5",
		"Unknown Flag 6",
		"Unknown Flag 7",
		"Unknown Flag 8"
	]),
	.byte(name: "Unknown 1", description: "", type: .uintHex),
	.byte(name: "Unknown 2", description: "", type: .uintHex),
	.byte(name: "Unknown 3", description: "", type: .uintHex),
	.array(name: "Unknown IDs", description: "Possibly indexes of the animation id on the model for some predefined animation type", property: .byte(name: "", description: "", type: .int), count: 6),
	.word(name: ".dat File Identifier", description: "", type: .fsysFileIdentifier(fsysName: "people_archive")),
	.array(name: "Unknown Values", description: "", property:
			.float(name: "", description: ""), count: 7),
])
#endif
let characterModelsTable = CommonStructTable(index: .CharacterModels, properties: characterModelStruct) { (index, data) -> String? in
	if let fileID: Int = data.get(".dat File Identifier") {
		let peopleArchive = XGFiles.fsys("people_archive").fsysData
		if let index = peopleArchive.indexForIdentifier(identifier: fileID) {
			return peopleArchive.fileNameForFileWithIndex(index: index)
		}
	}
	return nil
}
