//
//  CharacterModelTable.swift
//  GoD Tool
//
//  Created by Stars Momodu on 25/03/2021.
//

import Foundation

#if GAME_XD
let characterModelStruct = GoDStruct(name: "Character Model", format: [
	.bitMask(name: "Flags", description: "", length: .char, values: [
		(name: "Talking Sound Effect Type", type: .bool, numberOfBits: 6, firstBitIndexLittleEndian: 2, mod: nil, div: nil, scale: nil),
		(name: "Should Check Collisions Flag", type: .bool, numberOfBits: 5, firstBitIndexLittleEndian: 1, mod: nil, div: nil, scale: nil),
		(name: "Unknown Flag 3", type: .bool, numberOfBits: 4, firstBitIndexLittleEndian: 1, mod: nil, div: nil, scale: nil),
		(name: "Collision Type", type: .int, numberOfBits: 2, firstBitIndexLittleEndian: 2, mod: nil, div: nil, scale: nil),
		(name: "Unknown Flag 5", type: .bool, numberOfBits: 1, firstBitIndexLittleEndian: 1, mod: nil, div: nil, scale: nil),
		(name: "Unknown Flag 6", type: .bool, numberOfBits: 0, firstBitIndexLittleEndian: 1, mod: nil, div: nil, scale: nil),
	]),
	.byte(name: "Neck Bone Id", description: "", type: .int),
	.byte(name: "Chest Bone Id", description: "The id of the chest bone", type: .int),
	.word(name: ".dat File Identifier", description: "", type: .fsysFileIdentifier(fsysName: "people_archive")),
	.float(name: "Walking Animation Frame Count", description: ""),
	.float(name: "Running Animation Frame Count", description: ""),
	.float(name: "Collision Radius", description: "The radius of the bounding sphere for collisions with the model"),
	.float(name: "Neck Bone Left X Translation Limit", description: "How far left the neck bone can move"),
	.float(name: "Neck Bone Right X Translation Limit", description: "How far right the neck bone can move"),
	.float(name: "Neck Bone Upward Y Translation Limit", description: "How far upwards the neck bone can move"),
	.float(name: "Neck Bone Downward Y Translation Limit", description: " How far downwards the neck bone can move"),
	.float(name: "Interaction Radius", description: "The radius of the bounding sphere for talking to this model"),
	.array(name: "Unknown IDs", description: "Possibly indexes of the animation id on the model for some predefined animation type", property: .byte(name: "", description: "", type: .int), count: 12)
])
#else
let characterModelStruct = GoDStruct(name: "Character Model", format: [
	.bitMask(name: "Flags", description: "", length: .char, values: [
		(name: "Talking Sound Effect Type", type: .bool, numberOfBits: 6, firstBitIndexLittleEndian: 2, mod: nil, div: nil, scale: nil),
		(name: "Should Check Collisions Flag", type: .bool, numberOfBits: 5, firstBitIndexLittleEndian: 1, mod: nil, div: nil, scale: nil),
		(name: "Unknown Flag 3", type: .bool, numberOfBits: 4, firstBitIndexLittleEndian: 1, mod: nil, div: nil, scale: nil),
		(name: "Collision Type", type: .int, numberOfBits: 2, firstBitIndexLittleEndian: 2, mod: nil, div: nil, scale: nil),
		(name: "Unknown Flag 5", type: .bool, numberOfBits: 1, firstBitIndexLittleEndian: 1, mod: nil, div: nil, scale: nil),
		(name: "Unknown Flag 6", type: .bool, numberOfBits: 0, firstBitIndexLittleEndian: 1, mod: nil, div: nil, scale: nil),
	]),
	.byte(name: "Unknown 1", description: "", type: .uintHex),
	.byte(name: "Unknown 2", description: "", type: .uintHex),
	.byte(name: "Unknown 3", description: "", type: .uintHex),
	.array(name: "Unknown IDs", description: "Possibly indexes of the animation id on the model for some predefined animation type", property: .byte(name: "", description: "", type: .int), count: 6),
	.word(name: ".dat File Identifier", description: "", type: .fsysFileIdentifier(fsysName: "people_archive")),
	.float(name: "Walking Animation Frame Count", description: ""),
	.float(name: "Running Animation Frame Count", description: ""),
	.float(name: "Collision Radius", description: "The radius of the bounding sphere for collisions with the model"),
	.float(name: "Neck Bone Left X Translation Limit", description: "How far left the neck bone can move"),
	.float(name: "Neck Bone Right X Translation Limit", description: "How far right the neck bone can move"),
	.float(name: "Neck Bone Upward Y Translation Limit", description: "How far upwards the neck bone can move"),
	.float(name: "Neck Bone Downward Y Translation Limit", description: " How far downwards the neck bone can move"),
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
