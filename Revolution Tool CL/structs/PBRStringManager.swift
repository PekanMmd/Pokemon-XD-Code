//
//  MessageDataTable.swift
//  GoD Tool
//
//  Created by Stars Momodu on 26/03/2021.
//

import Foundation

class PBRStringManager {

	static var messageDataTableFile: XGFiles {
		return .indexAndFsysName(region == .JP ? 119 : 91, "common")
	}

	static var messageDataTable: GoDStructTable {
		return GoDStructTable(file: messageDataTableFile, properties: GoDStruct(name: "Message Data Table", format: [
			.short(name: "String Table ID", description: "The id for the string table that contains this string", type: .uint),
			.short(name: "String Index", description: "The index of this string within its string table", type: .uint)
		])) { (file) -> Int in
			return 8
		} numberOfEntriesInFile: { (file) -> Int in
			if let data = file.data {
				return data.get4BytesAtOffset(4)
			}
			return 0
		}
	}

	static func tableIDAndIndexForStringWithID(_ id: Int) -> (tableId: Int, index: Int)? {
		guard id != 0 else { return nil }
		let table = messageDataTable
		if let entry = table.dataForEntry(id - 1) {
			if let tableID: Int = entry.get("String Table ID"),
			   let stringIndex: Int = entry.get("String Index") {
				return (tableID, stringIndex)
			}
		}
		return nil
	}

	/// Returns the ID of the new string if successful
	static func addString(_ string: String, toTableWithID id: Int = 1, save: Bool = true) -> Int? {
		if let table = getStringTableWithId(id), let messageTableData = messageDataTableFile.data {
			if table.addString(XGString(string: string, file: table.file, sid: table.numberOfEntries + 1), increaseSize: true, save: save) {
				let newID = messageDataTable.numberOfEntries + 1
				messageTableData.replace4BytesAtOffset(4, withBytes: messageDataTable.numberOfEntries + 1)
				messageTableData.appendBytes(.init(repeating: 0, count: 4))
				messageTableData.replace2BytesAtOffset(messageTableData.length - 4, withBytes: id)
				messageTableData.replace2BytesAtOffset(messageTableData.length - 2, withBytes: table.numberOfEntries)
				if save {
					messageTableData.save()
				}
				return newID
			}
		}
		return nil
	}

}
