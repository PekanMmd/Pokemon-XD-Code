//
//  CommonStructTables.swift
//  GoD Tool
//
//  Created by Stars Momodu on 19/03/2021.
//

import Foundation

class CommonStructTable: GoDStructTableFormattable {
	let file: XGFiles
	let properties: GoDStruct
	let startOffsetForFirstEntryInFile: ((XGFiles) -> Int)
	let numberOfEntriesInFile: ((XGFiles) -> Int)
	var nameForEntry: ((Int, GoDStructData) -> String?)?
	let documentByIndex: Bool

	convenience init(index: Int, properties: GoDStruct, documentByIndex: Bool = true, nameForEntry: ((Int, GoDStructData) -> String?)? = nil) {
		self.init(file: .indexAndFsysName(index, "common"), properties: properties, documentByIndex: documentByIndex, nameForEntry: nameForEntry)
	}

	init(file: XGFiles, properties: GoDStruct, documentByIndex: Bool = true, nameForEntry: ((Int, GoDStructData) -> String?)? = nil) {
		self.file = file
		self.properties = properties

		startOffsetForFirstEntryInFile = { (file) in
			return file.data?.get4BytesAtOffset(16) ?? 0
		}
		numberOfEntriesInFile = { (file) in
			return file.data?.get4BytesAtOffset(0) ?? 0
		}

		self.nameForEntry = nameForEntry
		self.documentByIndex = documentByIndex
	}
}
