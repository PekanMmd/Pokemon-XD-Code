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
	let documentByIndex: Bool

	init(file: XGFiles, properties: GoDStruct, documentByIndex: Bool = true, startOffsetForFirstEntryInFile: @escaping ((XGFiles) -> Int), numberOfEntriesInFile: @escaping ((XGFiles) -> Int), nameForEntry: ((Int, GoDStructData) -> String?)? = nil) {
		self.file = file
		self.properties = properties
		self.startOffsetForFirstEntryInFile = startOffsetForFirstEntryInFile
		self.numberOfEntriesInFile = numberOfEntriesInFile
		self.nameForEntry = nameForEntry
		self.documentByIndex = documentByIndex
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
	var documentByIndex: Bool { get }
}

extension GoDStructTableFormattable {

	var fileVaries: Bool { false }

	var entryLength: Int {
		properties.length
	}

	var documentByIndex: Bool { true }

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

		func removeRawValue(from: String) -> String {
			var parts = from.split(separator: "(")
			if parts.count > 1 {
				parts.removeLast()
			}
			return parts.joined(separator: "(")
		}

		if let name = nameForEntry?(index, data) {
			return removeRawValue(from: name)
		}
		if let name: GoDStructValues = data.valueForPropertyWithName("Name ID") {
			// remove raw value by assuming it is at the end and surrounded by "()"
			return removeRawValue(from: name.description)
		}
		if let name: GoDStructValues = data.valueForPropertyWithName("Name") {
			// remove raw value by assuming it is at the end and surrounded by "()"
			return removeRawValue(from: name.description)
		}
		if let name: GoDStructValues = data.valueForPropertyWithName("Species") {
			// remove raw value by assuming it is at the end and surrounded by "()"
			return removeRawValue(from: name.description)
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
			var filename = documentByIndex ?
				String(format: "%03d ", index) + assumedNameForEntry(index: index) + ".txt" :
				assumedNameForEntry(index: index) + String(format: " %03d", index) + ".txt"
			filename = filename.replacingOccurrences(of: ":", with: "").replacingOccurrences(of: "\"", with: "")
			filename = filename.replacingOccurrences(of: ":", with: "").replacingOccurrences(of: "\"", with: "")
			filename = filename.replacingOccurrences(of: "\0", with: "")
			let file = XGFiles.nameAndFolder(filename, folder)
			XGUtility.saveString(entry.description, toFile: file)
		}
	}

	@discardableResult
	func getEnumerationData() -> String {
		var text = "\(properties.name) - count: \(numberOfEntries)\n"
		allEntries.forEachIndexed { (index, entry) in
			text += ("\n" + "\(index) - " + assumedNameForEntry(index: index)).spaceToLength(20)
		}

		return text
	}

	func documentEnumerationData(write: Bool = true) {
		let folder = XGFolders.nameAndFolder("Enumerations", .Reference)
		let filename = properties.name + (fileVaries ? " " + file.fileName : "") + ".txt"
		let file = XGFiles.nameAndFolder(filename, folder)
		if write {
			printg("Documenting \(properties.name) list to:", file.path)
		}

		XGUtility.saveString(getEnumerationData(), toFile: file)
	}

	func encodeData() {
		let foldername = properties.name + (fileVaries ? " " + file.fileName.removeFileExtensions() : "")
		let folder = XGFolders.nameAndFolder(foldername, .nameAndFolder("JSON Data", .Reference))
		printg("Encoding \(properties.name) table from game files to:", folder.path)
		allEntries.forEachIndexed { (index, entry) in
			let filename = properties.name + "_" + String(format: "%03d", index) + ".json"
			let file = XGFiles.nameAndFolder(filename, folder)
			XGUtility.saveString(entry.JSONString(), toFile: file)
		}
	}

	func decodeData() {
		let foldername = properties.name + (fileVaries ? " " + file.fileName.removeFileExtensions() : "")
		let folder = XGFolders.nameAndFolder(foldername, .nameAndFolder("JSON Data", .Reference))
		printg("Decoding table \(properties.name) to game files table from:", folder.path)
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
		// As seen in \(self.file.fileName) from \(XGFiles.iso.fileName.removeFileExtensions()) region: \(region.name)
		// At offset: \(firstEntryStartOffset.hexString()) (\(firstEntryStartOffset))
		// Struct length: \(properties.length.hexString()) (\(properties.length)) bytes
		// -----------------------------------------


		"""
		XGUtility.saveString(text + properties.CStruct, toFile: file)
	}

	func encodeCSVData() {
		let folder = XGFolders.nameAndFolder("CSV Data", .Reference)
		let filename = properties.name + (fileVaries ? " " + file.fileName : "") + ".csv"
		let csvFile = XGFiles.nameAndFolder(filename, folder)
		printg("Encoding \(properties.name) table to:", csvFile.path)

		var csv = ""
		func appendFieldNames(property: GoDStructProperties) {
			if case .null = property.type {
				return
			}
			switch property {
			case .bitArray(_, _, let names):
				names.forEach { name in
					if let fieldName = name {
						appendFieldNames(property: .byte(name: fieldName, description: "", type: .bool))
					}
				}
			case .bitMask(_, _, _, let fields):
				fields.forEach { field in
					if case .null = field.type {} else {
						appendFieldNames(property: .byte(name: field.name, description: "", type: field.type))
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
							}
						}
					}
				case .bitMask:
					var fields = [(name: String, type: GoDStructPropertyTypes, numberOfBits: Int, firstBitIndexLittleEndian: Int, mod: Int?, div: Int?, scale: Int?)]()
					if case .bitMask(_, _, _, let bitFields) = propertyValue.property {
						fields = bitFields
					}
					if let bitFieldValues: [Int] = propertyValue.value() {
						bitFieldValues.forEachIndexed { (index, fieldValue) in
							if index < fields.count {
								let field = fields[index]
								let value = GoDStructValues.value(property: .byte(name: "", description: "", type: field.type), rawValue: fieldValue).description
								if case .null = fields[index].type {}
								else {
									csv += "\(value),"
								}
							}
						}
					}
				default:
					csv += "\(propertyValue.description),"
				}
			}
		}
		allEntries.forEachIndexed { (index, entry) in
			// Add the entries name to start for convenience
			// This will be ignored when redecoding
			// put quotes around string in case it contains a comma so it doesn't affect the csv alignment
			let entryName = assumedNameForEntry(index: index) + " - \(index)"
			csv += "\(entryName),"
			appendFieldValues(data: entry.flattenedValues)
			csv.removeLast()
			csv += "\n"
		}

		XGUtility.saveString(csv, toFile: csvFile)
	}

	func decodeCSVData() {
		let folder = XGFolders.nameAndFolder("CSV Data", .Reference)
		let filename = properties.name + (fileVaries ? " " + file.fileName : "") + ".csv"
		let csvFile = XGFiles.nameAndFolder(filename, folder)
		printg("Decoding \(properties.name) table from:", csvFile.path)

		guard let fileData = file.data else {
			printg("Couldn't load data for file:", csvFile.path)
			return
		}

		#if GAME_PBR
		if self.properties.name == "Type Matchups" {
			for i in 0 ..< numberOfEntriesInFile(file) {
				let startOffset = firstEntryStartOffset + (i * properties.length)
				if i < kNumberOfTypes, let structData = GoDStructData.fromCSV(properties: properties, fileData: fileData, startOffset: startOffset, csvFile: csvFile, row: i) {

					let typeData = XGType(index: i)
					structData.values.forEachIndexed { (index, value) in
						guard index < kNumberOfTypes else {
							return
						}
						let effectiveness = XGEffectivenessValues(rawValue: value.rawValue() ?? 0) ?? .neutral
						typeData.setEffectiveness(effectiveness, againstType: .index(index))
					}
					typeData.save()
				}
			}
			return
		}
		#endif

		for i in 0 ..< numberOfEntriesInFile(file) {
			let startOffset = firstEntryStartOffset + (i * properties.length)
			if let structData = GoDStructData.fromCSV(properties: properties, fileData: fileData, startOffset: startOffset, csvFile: csvFile, row: i) {
				structData.save()
			}
		}
	}
}
