//
//  XGEnumerable.swift
//  GoD Tool
//
//  Created by Stars Momodu on 17/06/2019.
//

import Foundation

protocol XGEnumerable {
	var enumerableName: String {get}
	var enumerableValue: String? {get}
	static var enumerableClassName: String {get}
	static var allValues: [Self] {get}
}

extension XGEnumerable {
	
	static func documentEnumerationData() {
		let folder = XGFolders.nameAndFolder("Enumerations", .Reference)
		folder.createDirectory()
		let file = XGFiles.nameAndFolder(enumerableClassName + ".txt", folder)
		
		var text = "\(enumerableClassName) - count: \(allValues.count)\n"
		allValues.forEach { (value) in
			text += "\n\(value.enumerableName)"
			if let rawValue = value.enumerableValue {
				text += " - \(rawValue)"
			}
		}
		
		XGUtility.saveString(text, toFile: file)
	}
}

protocol XGDocumentable {
	static var documentableClassName: String {get}
	var documentableName: String {get}
	var isDocumentable: Bool {get}
	static var DocumentableKeys: [String] {get}
	func documentableValue(for key: String) -> String
}

extension XGDocumentable {
	var isDocumentable: Bool {
		return true
	}
	
	var documentableFields: String {
		var text = ""
		for key in type(of: self).DocumentableKeys {
			text += "\n\(key): \(documentableValue(for: key))"
		}
		return text
	}
	
	var documentableData: String {
		return "\(documentableName)\n" + documentableFields
	}
	
	func saveDocumentedData() {
		let documentationFolder = XGFolders.nameAndFolder("Documentation", .Reference)
		let folder = XGFolders.nameAndFolder(type(of: self).documentableClassName, documentationFolder)
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
	static func encodedDataFolder() -> XGFolders {
		let encodingFolder = XGFolders.nameAndFolder("Raw Data", .Reference)
		return XGFolders.nameAndFolder(enumerableClassName, encodingFolder)
	}
	
	static func encodedJSONFiles() -> [XGFiles] {
		return encodedDataFolder().files.filter { $0.fileType == .json }
	}
	
	static var encodableValues: [Encodable] {
		return (allValues as? [Encodable]) ?? []
	}
	
	static func encodeData(filename: (Encodable) -> String) {
		let folder = encodedDataFolder()
		folder.createDirectory()
		
		for value in encodableValues {
			let file = XGFiles.nameAndFolder(filename(value) + XGFileTypes.json.fileExtension, folder)
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


