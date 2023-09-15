//
//  MenuDataTable.swift
//  GoD Tool
//
//  Created by Stars Momodu on 11/09/2023.
//

import Foundation

let menuDataStruct =  GoDStruct(name: "Menu Data", format: [
	.byte(name: "Unknown 1", description: "", type: .uintHex),
	.byte(name: "Unknown 2", description: "", type: .uintHex),
	.byte(name: "Unknown 3", description: "", type: .uintHex),
	.byte(name: "Display Max", description: "", type: .uintHex),
	.byte(name: "Unknown 4", description: "", type: .uintHex),
	.byte(name: "Unknown 5", description: "", type: .uintHex),
	.byte(name: "Unknown 6", description: "", type: .uintHex),
	.byte(name: "Unknown 7", description: "", type: .uintHex),
	.short(name: "X Position", description: "", type: .uint),
	.short(name: "Y Position", description: "", type: .uint),
	.array(name: "Callbacks", description: "", property:
			.word(name: "Callback function", description: "", type: .uintHex),
		   count: 4)
])

let menuDataTable = GoDStructTable(file: .dol, properties: menuDataStruct) { (file) -> Int in
	switch region {
	case .US:
		return 0x2F98F0
	case .EU:
		return 0x2FAFB0
	case .JP:
		return 0x2F3E1C
	case .OtherGame:
		return 0
	}
} numberOfEntriesInFile: { (_) -> Int in
	return 0x120
} canExpand: { (file) -> Bool in
	return false
}
