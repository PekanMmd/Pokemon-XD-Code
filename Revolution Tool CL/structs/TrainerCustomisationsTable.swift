//
//  TrainerCustomisationsTable.swift
//  GoD Tool
//
//  Created by Stars Momodu on 06/11/2021.
//

import Foundation

var trainerCustomisationFiles: [String] {
	return XGISO.current.allFileNames.filter { filename in
		return filename.contains("_tr_")
	}
}

let trainerCustomisationsStruct = GoDStruct(name: "Trainer Customisations", format: [
	.array(name: "Models", description: "", property: .word(name: "Model", description: "", type: .fsysFileIdentifierSearch(fsysNames: trainerCustomisationFiles)), count: 10),
	.short(name: "Name", description: "", type: .msgID(file: nil)),
	.short(name: "Description", description: "", type: .msgID(file: nil)),
	.short(name: "Unknown 1", description: "", type: .uint),
	.byte(name: "Unknown 2", description: "", type: .uint),
	.array(name: "Unknown Flags", description: "", property: .byte(name: "Unknown", description: "", type: .bitMask), count: 10),
	.array(name: "Unknown Values", description: "Filler?", property: .byte(name: "Unknown", description: "", type: .uintHex), count: 3)
])

let trainerCustomisationsTable = CommonStructTable(file: .indexAndFsysName(region == .JP ? 18 : 24, "common"), properties: trainerCustomisationsStruct, documentByIndex: false)
