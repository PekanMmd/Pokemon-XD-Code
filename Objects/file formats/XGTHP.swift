//
//  XGTHP.swift
//  GoD Tool
//
//  Created by Stars Momodu on 09/01/2021.
//

import Foundation

class XGTHP {

	enum ComponentTypes: Int {
		case video = 0
		case audio = 1
		case none  = -1

		var length: Int {
			switch self {
			case .video: return 12
			case .audio: return 16
			case .none : return 0
			}
		}
	}

	var headerData: XGMutableData
	var bodyData: XGMutableData

	var thpData: XGMutableData {
		let headerFile = headerData.file
		let thpFile = XGFiles.nameAndFolder(headerFile.fileName.removeFileExtensions() + XGFileTypes.thp.fileExtension, headerFile.folder)

		let data = XGMutableData(byteStream: headerData.rawBytes + bodyData.rawBytes, file: thpFile)
		data.replaceWordAtOffset(0x28, withBytes: data.getWordAtOffset(0x28) + UInt32(headerData.length))
		data.replaceWordAtOffset(0x2C, withBytes: data.getWordAtOffset(0x2C) + UInt32(headerData.length))
		return data
	}

	init(header: XGMutableData, body: XGMutableData) {
		headerData = header
		bodyData = body
	}

	init(thpData: XGMutableData) {
		let componentsOffset = thpData.get4BytesAtOffset(0x20)
//		let componentsCount = thpData.get4BytesAtOffset(componentsOffset)
		let componentTypes = thpData.getByteStreamFromOffset(componentsOffset + 4, length: 16).map { (id) -> ComponentTypes in
			return ComponentTypes(rawValue: id) ?? .none
		}
		let componentsLength = componentTypes.map {$0.length}.reduce(0, +)
		let headerLength = componentsOffset + 20 + componentsLength

		let header = XGMutableData(byteStream: thpData.getByteStreamFromOffset(0, length: headerLength))
		let body = thpData.duplicated()
		body.deleteBytes(start: 0, count: headerLength)
		header.replaceWordAtOffset(0x28, withBytes: header.getWordAtOffset(0x28) - UInt32(header.length))
		header.replaceWordAtOffset(0x2C, withBytes: header.getWordAtOffset(0x2C) - UInt32(header.length))

		let baseFileName = thpData.file.fileName.removeFileExtensions()
		header.file = XGFiles.nameAndFolder(baseFileName + XGFileTypes.thh.fileExtension, thpData.file.folder)
		body.file = XGFiles.nameAndFolder(baseFileName + XGFileTypes.thd.fileExtension, thpData.file.folder)

		headerData = header
		bodyData = body
	}
}
