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
	var documentableName: String {get}
	var isDocumentable: Bool {get}
	static var DocumentableKeys: [String] {get}
	func documentableValue(for key: String) -> String
}

extension XGDocumentable {
	var isDocumentable: Bool {
		return true
	}
	
	var documentableData: String {
		var text = "\(self.documentableName)\n"
		for key in type(of: self).DocumentableKeys {
			text += "\n\(key): \(self.documentableValue(for: key))"
		}
		return text
	}
}

extension XGEnumerable {
	static var documentableValues: [XGDocumentable] {
		let documentable = (allValues as? [XGDocumentable]) ?? []
		return documentable.filter { $0.isDocumentable }
	}
	
	static func documentData() {
		let documentationFolder = XGFolders.nameAndFolder("Documentation", .Reference)
		let folder = XGFolders.nameAndFolder(enumerableClassName, documentationFolder)
		folder.createDirectory()
		
		documentableValues.forEach { (value) in
			let file = XGFiles.nameAndFolder(value.documentableName + ".txt", folder)
			XGUtility.saveString(value.documentableData, toFile: file)
		}
	}
}

extension XGEnumerable {
	static func encodedDataFolder() -> XGFolders {
		let encodingFolder = XGFolders.nameAndFolder("Raw Data", .Reference)
		return XGFolders.nameAndFolder(enumerableClassName, encodingFolder)
	}
	
	static var encodableValues: [Encodable] {
		return (allValues as? [Encodable]) ?? []
	}
	
	static func encodeData(filename: (Encodable) -> String) {
		let folder = encodedDataFolder()
		folder.createDirectory()
		
		for value in encodableValues {
			let file = XGFiles.nameAndFolder(filename(value) + ".json", folder)
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
