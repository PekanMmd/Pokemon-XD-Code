//
//  XGEnumerable.swift
//  GoD Tool
//
//  Created by Stars Momodu on 17/06/2019.
//

import Foundation

protocol GoDCodable: Codable {
	static func encodeData()
	static func decodeData()
	static func documentData()
	static func getEnumerationData() -> String
	static func documentEnumerationData()
	func save()

	static var className: String {get}
	static var numberOfValues: Int {get}
}

protocol XGEnumerable {
	var enumerableName: String {get}
	var enumerableValue: String? {get}
	static var className: String {get}
	static var allValues: [Self] {get}
}

extension XGEnumerable {

	@discardableResult
	static func getEnumerationData() -> String {
		var text = "\(className) - count: \(allValues.count)\n"
		allValues.forEach { (value) in
			text += "\n\(value.enumerableName.spaceToLength(20))"
			if let rawValue = value.enumerableValue {
				text += " - \(rawValue)"
			}
		}

		return text
	}

	static func documentEnumerationData() {
		let folder = XGFolders.nameAndFolder("Enumerations", .Reference)
		folder.createDirectory()
		let file = XGFiles.nameAndFolder(className + ".txt", folder)

		XGUtility.saveString(getEnumerationData(), toFile: file)
	}
}

protocol XGDocumentable {
	static var className: String {get}
	var documentableName: String {get}
	var isDocumentable: Bool {get}
	static var DocumentableKeys: [String] {get}
	func documentableValue(for key: String) -> String
}

extension XGDocumentable {
	var isDocumentable: Bool {
		// This is checked for each value to see if it should be included
		return true
	}
	
	var documentableFields: String {
		var text = ""
		for key in Self.DocumentableKeys {
			text += "\n\(key): \(documentableValue(for: key))"
		}
		return text
	}
	
	var documentableData: String {
		return "\(documentableName)\n" + documentableFields
	}
	
	func saveDocumentedData() {
		let documentationFolder = XGFolders.nameAndFolder("Documented Data", .Reference)
		let folder = XGFolders.nameAndFolder(Self.className, documentationFolder)
		folder.createDirectory()
		
		let file = XGFiles.nameAndFolder(documentableName + XGFileTypes.txt.fileExtension, folder)
		XGUtility.saveString(documentableData, toFile: file)
	}
}

extension XGEnumerable where Self: XGDocumentable {
	static var documentableValues: [XGDocumentable] {
		allValues.filter { $0.isDocumentable }
	}
	
	static func documentData() {
		documentableValues.forEach { $0.saveDocumentedData() }
	}
}

extension XGEnumerable {
	static var numberOfValues: Int {
		return allValues.count
	}
	
	static func encodedDataFolder() -> XGFolders {
		let encodingFolder = XGFolders.nameAndFolder("JSON Data", .Reference)
		return XGFolders.nameAndFolder(className, encodingFolder)
	}
	
	static func decodedJSONFiles() -> [XGFiles] {
		return encodedDataFolder().files.filter { $0.fileType == .json }
	}
	
	static var encodableValues: [Encodable] {
		return (allValues as? [Encodable]) ?? []
	}
	
	static func encodeData() {
		let folder = encodedDataFolder()
		folder.createDirectory()
		
		encodableValues.forEachIndexed() { (index, value) in
			let file = XGFiles.nameAndFolder(String(format: "%03d", index) + XGFileTypes.json.fileExtension, folder)
			value.writeJSON(to: file)
		}
	}
	
	static var encodedData: [XGFiles] {
		guard encodedDataFolder().exists else { return [] }
		
		return encodedDataFolder().files.filter({ (file) -> Bool in
			return file.fileType == .json
		})
	}
}

extension GoDCodable where Self: XGEnumerable  {
	static func decodeData() {
		for file in decodedJSONFiles() {
			do {
				try Self.fromJSON(file: file).save()
			} catch {
				printg("Failed to decode file:", file.path)
			}
		}
	}
	
}


