//
//  GoDCommonStructTable.swift
//  GoD Tool
//
//  Created by Stars Momodu on 17/03/2021.
//

import Foundation

class CommonStructTable: GoDStructTableFormattable {
	let file: XGFiles = .common_rel
	let properties: GoDStruct
	let startOffsetForFirstEntryInFile: ((XGFiles) -> Int)
	let numberOfEntriesInFile: ((XGFiles) -> Int)
	var nameForEntry: ((Int, GoDStructData) -> String)?

	let commonIndex: Int

	convenience init(index: CommonIndexes, properties: GoDStruct, nameForEntry: ((Int, GoDStructData) -> String)? = nil) {
		self.init(index: index.rawValue, properties: properties, nameForEntry: nameForEntry)
	}

	init(index: Int, properties: GoDStruct, nameForEntry: ((Int, GoDStructData) -> String)? = nil) {
		self.commonIndex = index
		self.properties = properties
		startOffsetForFirstEntryInFile = { (file) in
			common.getPointer(index: index)
		}
		numberOfEntriesInFile = { (file) in
			common.getValueAtPointer(index: index + 1)
		}

		self.nameForEntry = nameForEntry
	}
}
