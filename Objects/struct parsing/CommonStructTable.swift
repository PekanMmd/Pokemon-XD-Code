//
//  CommonStructTable.swift
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
	var nameForEntry: ((Int, GoDStructData) -> String?)?
	let documentByIndex: Bool

	let commonIndex: Int
	let canExpand = true

	convenience init(index: CommonIndexes, properties: GoDStruct, documentByIndex: Bool = true, nameForEntry: ((Int, GoDStructData) -> String?)? = nil) {
		self.init(index: index.rawValue, properties: properties, documentByIndex: documentByIndex, nameForEntry: nameForEntry)
	}

	init(index: Int, properties: GoDStruct, documentByIndex: Bool = true, nameForEntry: ((Int, GoDStructData) -> String?)? = nil) {
		self.commonIndex = index
		self.properties = properties
		startOffsetForFirstEntryInFile = { (file) in
			common.getPointer(index: index)
		}
		numberOfEntriesInFile = { (file) in
			common.getValueAtPointer(index: index + 1)
		}

		self.nameForEntry = nameForEntry
		self.documentByIndex = documentByIndex
	}

	func addEntries(count: Int) {
		common.expandSymbolWithIndex(commonIndex, by: count * properties.length)
		common.setValueAtPointer(index: commonIndex + 1, newValue: numberOfEntries + count)
	}
}
