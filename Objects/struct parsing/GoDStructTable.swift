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
	let nameForEntry: ((Int, GoDStructData) -> String)?

	init(file: XGFiles, properties: GoDStruct, startOffsetForFirstEntryInFile: @escaping ((XGFiles) -> Int), numberOfEntriesInFile: @escaping ((XGFiles) -> Int), nameForEntry: ((Int, GoDStructData) -> String)? = nil) {
		self.file = file
		self.properties = properties
		self.startOffsetForFirstEntryInFile = startOffsetForFirstEntryInFile
		self.numberOfEntriesInFile = numberOfEntriesInFile
		self.nameForEntry = nameForEntry
	}
}

protocol GoDStructTableFormattable {
	var file: XGFiles { get }
	var properties: GoDStruct { get }
	var startOffsetForFirstEntryInFile: ((XGFiles) -> Int) { get }
	var numberOfEntriesInFile: ((XGFiles) -> Int) { get }
	var nameForEntry: ((Int, GoDStructData) -> String)? { get }
}

extension GoDStructTableFormattable {

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
		return (0 ..< numberOfEntriesInFile(file)).map {
			dataForEntry($0)!
		}
	}

	func assumedNameForEntry(index: Int, data: GoDStructData) -> String {
		if let name = nameForEntry?(index, data) {
			return name
		}
		if let name: GoDStructValues = data.valueForPropertyWithName("Name") {
			return name.description
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
		guard startOffset + entryLength < file.fileSize, file.exists, let data = file.data else {
			return nil
		}
		return GoDStructData(properties: properties, fileData: data, startOffset: startOffset)
	}

	func documentData() {
		let folder = XGFolders.nameAndFolder(properties.name, .nameAndFolder("Documented Data", .Reference))
		printg("Documenting \(properties.name) table to:", folder.path)
		allEntries.forEachIndexed { (index, entry) in
			let filename = assumedNameForEntry(index: index, data: entry) + " " + String(format: "%03d", index)  + ".yaml"
			let file = XGFiles.nameAndFolder(filename, folder)
			XGUtility.saveString(entry.description, toFile: file)
		}
	}

	func documentEnumerationData() {
		let folder = XGFolders.nameAndFolder("Enumerations", .Reference)
		let file = XGFiles.nameAndFolder(properties.name + ".txt", folder)
		printg("Documenting \(properties.name) list to:", file.path)

		var text = "\(properties.name) - count: \(numberOfEntries)\n"
		allEntries.forEachIndexed { (index, entry) in
			text += ("\n" + assumedNameForEntry(index: index, data: entry)).spaceToLength(20) + " - \(index)"
		}
		XGUtility.saveString(text, toFile: file)
	}

	func decodeData() {
		let folder = XGFolders.nameAndFolder(properties.name, .nameAndFolder("Decoded Data", .Reference))
		printg("Decoding \(properties.name) table from game files to:", folder.path)
		allEntries.forEachIndexed { (index, entry) in
			let filename = properties.name + "_" + String(format: "%03d", index) + ".json"
			let file = XGFiles.nameAndFolder(filename, folder)
			XGUtility.saveString(entry.JSONString(), toFile: file)
		}
	}

	func encodeData() {
		let folder = XGFolders.nameAndFolder(properties.name, .nameAndFolder("Decoded Data", .Reference))
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
		let file = XGFiles.nameAndFolder(properties.name + ".c", .nameAndFolder("C Structs", .Reference))
		printg("Documenting struct: \(properties.name) to", file.path)
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
		let filename = properties.name + ".csv"
		let csvFile = XGFiles.nameAndFolder(filename, folder)
		printg("Decoding \(properties.name) table from game files to:", csvFile.path)

		var csv = ""
		func appendFieldNames(property: GoDStructProperties) {
			switch property {
			case .array(let name, _, let property, let count):
				(0 ..< count).forEach { (index) in
					switch property {
					case .byte(_, let description, let type):
						appendFieldNames(property: .byte(name: name + " \(index + 1)", description: description, type: type))
					case .short(_, let description, let type):
						appendFieldNames(property: .short(name: name + " \(index + 1)", description: description, type: type))
					case .word(_, let description, let type):
						appendFieldNames(property: .word(name: name + " \(index + 1)", description: description, type: type))
					case .float(_, let description):
						appendFieldNames(property: .float(name: name + " \(index + 1)", description: description))
					case .string(_, let description, let maxCharacterCount, let charLength):
						appendFieldNames(property: .string(name: name + " \(index + 1)", description: description, maxCharacterCount: maxCharacterCount, charLength: charLength))
					case .array(_, let description, let property, let count):
						appendFieldNames(property: .array(name: name + " \(index + 1)", description: description, property: property, count: count))
					case .subStruct(_, let description, let property):
						appendFieldNames(property: .subStruct(name: name + " \(index + 1)", description: description, property: property))
					}
				}
			case .subStruct(let name, _, let property):
				property.format.forEach { (property) in
					switch property {
					case .byte(_, let description, let type):
						appendFieldNames(property: .byte(name: name + " " + property.name, description: description, type: type))
					case .short(_, let description, let type):
						appendFieldNames(property: .short(name: name + " " + property.name, description: description, type: type))
					case .word(_, let description, let type):
						appendFieldNames(property: .word(name: name + " " + property.name, description: description, type: type))
					case .float(_, let description):
						appendFieldNames(property: .float(name: name + " " + property.name, description: description))
					case .string(_, let description, let maxCharacterCount, let charLength):
						appendFieldNames(property: .string(name: name + " " + property.name, description: description, maxCharacterCount: maxCharacterCount, charLength: charLength))
					case .array(_, let description, let property, let count):
						appendFieldNames(property: .array(name: name + " " + property.name, description: description, property: property, count: count))
					case .subStruct(_, let description, let property):
						appendFieldNames(property: .subStruct(name: name + " " + property.name, description: description, property: property))
					}
				}
			default:
				csv += property.name + ", "
			}
		}
		properties.format.forEach { (property) in
			appendFieldNames(property: property)
		}
		csv.removeLast()
		csv += "\n"

		func appendFieldValues(data: GoDStructData) {
			data.values.forEach { (propertyValue) in
				if let array: [Any] = propertyValue.value() {
					array.forEach { (value) in
						if let subStruct = value as? GoDStructData {
							appendFieldValues(data: subStruct)
							csv.removeLast()
						} else if let _ = value as? [Any] {
							assertionFailure("Nested arrays not supported")
							csv += "#error, "
						} else {
							csv += "\(value), "
						}
					}
				} else if let subStruct: GoDStructData = propertyValue.value() {
					appendFieldValues(data: subStruct)
					csv.removeLast()
				} else if let value: Any = propertyValue.value() {
					if case .bool = propertyValue.property.type {
						csv += "\(propertyValue.value() != 0), "
					} else {
						csv += "\(value), "
					}
				} else {
					csv += "#error, "
				}
			}
			csv.removeLast()
			csv += "\n"
		}
		allEntries.forEach { (entry) in
			appendFieldValues(data: entry)
		}

		XGUtility.saveString(csv, toFile: csvFile)
	}
}
