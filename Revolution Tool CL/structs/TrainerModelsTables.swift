//
//  TrainerModelsTables.swift
//  GoD Tool
//
//  Created by Stars Momodu on 06/11/2021.
//

import Foundation

var trainerModelFiles: [String] {
	return XGISO.current.allFileNames.filter { filename in
		return filename.contains("_tr_")
	}
}

let trainerCustomisationsStruct = GoDStruct(name: "Trainer Customisations", format: [
	.array(name: "Models", description: "", property: .word(name: "Model", description: "", type: .fsysFileIdentifierSearch(fsysNames: trainerModelFiles)), count: 10),
	.short(name: "Name", description: "", type: .msgID(file: nil)),
	.short(name: "Description", description: "", type: .msgID(file: nil)),
	.short(name: "Unknown 1", description: "", type: .uint),
	.byte(name: "Unknown 2", description: "", type: .uint),
	.array(name: "Unknown Flags", description: "", property: .byte(name: "Unknown", description: "", type: .bitMask), count: 10),
	.array(name: "Unknown Values", description: "Filler?", property: .byte(name: "Unknown", description: "", type: .uintHex), count: 3)
])

let trainerCustomisationsTable = CommonStructTable(file: .indexAndFsysName(region == .JP ? 18 : 24, "common"), properties: trainerCustomisationsStruct, documentByIndex: false)


let trainerModelsStruct = GoDStruct(name: "Trainer Models", format: [
	.bitMask(name: "Flags", description: "", length: .char, values: [
		(name: "Is Customizable", type: .int, numberOfBits: 1, firstBitIndexLittleEndian: 7, mod: nil, div: nil, scale: nil),
		(name: "Custom Table ID", type: .int, numberOfBits: 3, firstBitIndexLittleEndian: 4, mod: nil, div: nil, scale: nil),
	]),
	.array(name: "Padding", description: "", property: .byte(name: "padding", description: "", type: .uintHex), count: 3),
	.word(name: "Low Quality Model Fsys ID", description: "", type: .fsysID),
	.word(name: "Low Quality Model File ID", description: "", type: .fsysFileIdentifierSearch(fsysNames: trainerModelFiles)),
	.word(name: "High Quality Model Fsys ID", description: "", type: .fsysID),
	.word(name: "High Quality Model File ID", description: "", type: .fsysFileIdentifierSearch(fsysNames: trainerModelFiles)),
	.array(name: "Unknown Values", description: "", property: .byte(name: "Unknown", description: "", type: .uintHex), count: 0x40)

])

let trainerModelsTable = CommonStructTable(file: .indexAndFsysName(region == .JP ? 21 : 27, "common"), properties: trainerModelsStruct, documentByIndex: false)
