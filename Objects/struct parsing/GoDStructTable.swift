//
//  GoDStructTable.swift
//  GoD Tool
//
//  Created by Stars Momodu on 18/02/2021.
//

import Foundation

class GoDStructTable: GoDStructTableFormattable {
	let file: XGFiles
	let properties: GoDStruct
	let startOffsetForFirstEntryInFile: ((XGFiles) -> Int)
	let numberOfEntriesInFile: ((XGFiles) -> Int)
	let nameForEntry: ((Int, GoDStructData) -> String?)?

	init(file: XGFiles, properties: GoDStruct, startOffsetForFirstEntryInFile: @escaping ((XGFiles) -> Int), numberOfEntriesInFile: @escaping ((XGFiles) -> Int), nameForEntry: ((Int, GoDStructData) -> String?)? = nil) {
		self.file = file
		self.properties = properties
		self.startOffsetForFirstEntryInFile = startOffsetForFirstEntryInFile
		self.numberOfEntriesInFile = numberOfEntriesInFile
		self.nameForEntry = nameForEntry
	}

	static var dummy: GoDStructTable {
		return .init(file: .nameAndFolder("", .Documents), properties: .dummy, startOffsetForFirstEntryInFile: {_ in 0}, numberOfEntriesInFile: {_ in 0})
	}
}

protocol GoDStructTableFormattable {
	var file: XGFiles { get }
	var properties: GoDStruct { get }
	var startOffsetForFirstEntryInFile: ((XGFiles) -> Int) { get }
	var numberOfEntriesInFile: ((XGFiles) -> Int) { get }
	var nameForEntry: ((Int, GoDStructData) -> String?)? { get }
	var fileVaries: Bool { get }
}

extension GoDStructTableFormattable {

	var fileVaries: Bool { false }

	var entryLength: Int {
		properties.length
	}

	var numberOfEntries: Int {
		return numberOfEntriesInFile(file)
	}

	var firstEntryStartOffset: Int {
		startOffsetForFirstEntryInFile(file)
	}

	var allEntries: [GoDStructData] {
		var success = true
		let entries = (0 ..< numberOfEntriesInFile(file)).map { index  -> GoDStructData in
			if let data = dataForEntry(index) {
				return data
			} else {
				success = false
				return properties.dummyValues()
			}
		}
		if !success {
			printg("ERROR: Incorrect entry size for data table: \(properties.name)\nSize: \(properties.length)\nIn file: \(file.path)")
		}
		return entries
	}

	func assumedNameForEntry(index: Int) -> String {

		guard let data = dataForEntry(index) else {
			return properties.name
		}

		if let name = nameForEntry?(index, data) {
			return name
		}
		if let name: GoDStructValues = data.valueForPropertyWithName("Name ID") {
			// remove raw value by assuming it is at the end and surrounded by "()"
			let nameAndRawValue = name.description
			var parts = nameAndRawValue.split(separator: "(")
			if parts.count > 0 {
				parts.removeLast()
			}
			return parts.joined(separator: "(")
		}

		return properties.name
	}

	func startOffsetForEntry(_ index: Int) -> Int {
		return firstEntryStartOffset + (index * entryLength)
	}

	func dataForEntry(_ index: Int) -> GoDStructData? {
		guard index < numberOfEntriesInFile(file) else {
			return nil
		}
		let startOffset = startOffsetForEntry(index)
		guard startOffset + entryLength <= file.fileSize, file.exists, let data = file.data else {
			return nil
		}
		return GoDStructData(properties: properties, fileData: data, startOffset: startOffset)
	}

	func documentData() {
		let foldername = properties.name + (fileVaries ? " " + file.fileName.removeFileExtensions() : "")
		let folder = XGFolders.nameAndFolder(foldername, .nameAndFolder("Documented Data", .Reference))
		printg("Documenting \(properties.name) table to:", folder.path)
		allEntries.forEachIndexed { (index, entry) in
			let filename = assumedNameForEntry(index: index) + " " + String(format: "%03d", index)  + ".yaml"
			let file = XGFiles.nameAndFolder(filename, folder)
			XGUtility.saveString(entry.description, toFile: file)
		}
	}

	func documentEnumerationData() {
		let folder = XGFolders.nameAndFolder("Enumerations", .Reference)
		let filename = properties.name + (fileVaries ? " " + file.fileName : "") + ".txt"
		let file = XGFiles.nameAndFolder(filename, folder)
		printg("Documenting \(properties.name) list to:", file.path)

		var text = "\(properties.name) - count: \(numberOfEntries)\n"
		allEntries.forEachIndexed { (index, entry) in
			text += ("\n" + assumedNameForEntry(index: index)).spaceToLength(20) + " - \(index)"
		}
		XGUtility.saveString(text, toFile: file)
	}

	func decodeData() {
		let foldername = properties.name + (fileVaries ? " " + file.fileName.removeFileExtensions() : "")
		let folder = XGFolders.nameAndFolder(foldername, .nameAndFolder("JSON Data", .Reference))
		printg("Decoding \(properties.name) table from game files to:", folder.path)
		allEntries.forEachIndexed { (index, entry) in
			let filename = properties.name + "_" + String(format: "%03d", index) + ".json"
			let file = XGFiles.nameAndFolder(filename, folder)
			XGUtility.saveString(entry.JSONString(), toFile: file)
		}
	}

	func encodeData() {
		let foldername = properties.name + (fileVaries ? " " + file.fileName.removeFileExtensions() : "")
		let folder = XGFolders.nameAndFolder(foldername, .nameAndFolder("JSON Data", .Reference))
		printg("Encoding table \(properties.name) to game files table from:", folder.path)
		(0 ..< numberOfEntriesInFile(file)).forEach { index in
			let filename = properties.name + "_" + String(format: "%03d", index) + ".json"
			let jsonFile = XGFiles.nameAndFolder(filename, folder)
			if jsonFile.exists, let data = self.file.data ,
			let entry = GoDStructData.fromJSON(properties: properties, fileData: data, startOffset: startOffsetForEntry(index), jsonFile: jsonFile) {
				entry.save(writeData: true)
			}
		}
	}

	func documentCStruct() {
		let filename = properties.name + ".c"
		let file = XGFiles.nameAndFolder(filename, .nameAndFolder("C Structs", .Reference))
		printg("Documenting struct: \(properties.CStructName) to", file.path)
		let text = """
		// -----------------------------------------
		// \(properties.name + ".c")
		//
		// As seen in \(self.file.fileName) from \(XGFiles.iso.fileName.removeFileExtensions())
		// At offset: \(firstEntryStartOffset.hexString()) (\(firstEntryStartOffset))
		// Struct length: \(properties.length.hexString()) (\(properties.length)) bytes
		// -----------------------------------------


		"""
		XGUtility.saveString(text + properties.CStruct, toFile: file)
	}

	func decodeCSVData() {
		let folder = XGFolders.nameAndFolder("CSV Data", .Reference)
		let filename = properties.name + (fileVaries ? " " + file.fileName : "") + ".csv"
		let csvFile = XGFiles.nameAndFolder(filename, folder)
		printg("Decoding \(properties.name) table to:", csvFile.path)

		var csv = ""
		func appendFieldNames(property: GoDStructProperties) {
			if case .null = property.type {
				return
			}
			switch property {
			case .bitArray(_, _, let names):
				names.forEachIndexed { (index, name) in
					if let fieldName = name {
						appendFieldNames(property: .byte(name: fieldName, description: "", type: .bool))
					}
				}
			case .array:
				assertionFailure("Arrays should have been flattened first")
			case .subStruct:
				assertionFailure("Structs should have been flattened first")
			default:
				csv += property.name + ","
			}
		}

		csv += "Entry Name,"
		properties.flattened.format.forEach { (property) in
			appendFieldNames(property: property)
		}
		csv.removeLast()
		csv += "\n"

		func appendFieldValues(data: [GoDStructValues]) {
			data.forEach { (propertyValue) in
				if case .null = propertyValue.property.type {
					return
				}
				switch propertyValue {
				case .bitArray:
					var names = [String?]()
					if case .bitArray(_, _, let bitFieldNames) = propertyValue.property {
						names = bitFieldNames
					}
					if let bits: [Bool] = propertyValue.value() {
						bits.forEachIndexed { (index, bit) in
							if index < names.count, names[index] != nil {
								csv += "\(bit),"
							} else if names.count == 0 {
								csv += "\(bit),"
							}
						}
					}
				default:
					if case .msgID = propertyValue.property.type,
					   propertyValue.description.contains(",") {
						let fullText = propertyValue.description
						let parts = fullText.split(separator: " ")

						// put quotes around all but last part
						if parts.count > 1, let last = parts.last {
							var quotedText = "\""
							for i in 0 ..< parts.count - 1 {
								quotedText += parts[i] + " "
							}
							quotedText.removeLast() // remove extra space
							quotedText += "\""
							quotedText += " " + last
							csv += "\(quotedText),"
						} else {
							assertionFailure("MSG ID should have the string text followed by the id in brackets after a space: \(fullText)")
							csv += "\(propertyValue.description),"
						}
					} else {
						csv += "\(propertyValue.description),"
					}
				}
			}
		}
		allEntries.forEachIndexed { (index, entry) in
			// Add the entries name to start for convenience
			// This will be ignored when reencoding
			csv += "\(assumedNameForEntry(index: index)),"
			appendFieldValues(data: entry.flattened)
			csv.removeLast()
			csv += "\n"
		}

		XGUtility.saveString(csv, toFile: csvFile)
	}

	func encodeCSVData() {
		let folder = XGFolders.nameAndFolder("CSV Data", .Reference)
		let filename = properties.name + (fileVaries ? " " + file.fileName : "") + ".csv"
		let csvFile = XGFiles.nameAndFolder(filename, folder)
		printg("Encoding \(properties.name) table from:", csvFile.path)

		guard let fileData = file.data else {
			printg("Couldn't load data for file:", csvFile.path)
			return
		}

		for i in 0 ..< numberOfEntriesInFile(file) {
			let startOffset = firstEntryStartOffset + (i * properties.length)
			if let structData = GoDStructData.fromCSV(properties: properties, fileData: fileData, startOffset: startOffset, csvFile: csvFile, row: i) {
				structData.save()
			}
		}
	}
}
