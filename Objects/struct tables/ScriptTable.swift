//
//  ScriptTable.swift
//  GoD Tool
//
//  Created by Stars Momodu on 12/02/2023.
//

import Foundation

#if GAME_COLO
let scriptBuiltInFunctionsStruct = GoDStruct(name: "Script Functions", format: [
	.word(name: "Function Pointer", description: "", type: .uintHex),
	.array(name: "Flags", description: "", property: .byte(name: "Unknown Flag", description: "", type: .uint), count: 4),
	.word(name: "Unknown", description: "", type: .uintHex)
])

let scriptBuiltInFunctionsTable = GoDStructTable(
	file: .dol,
	properties: scriptBuiltInFunctionsStruct)
	{ _ in
		switch region {
		case .US: return 0x2e1cf0 - kDolTableToRAMOffsetDifference
		default: return -1
		}
	} numberOfEntriesInFile: { _ in
		return 242 // TODO: confirm last script function id
	} nameForEntry: { index, _ in
		return ScriptBuiltInFunctions[index]?.name
	}
#endif
