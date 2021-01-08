//
//  XGISO.swift
//  GoD Tool
//
//  Created by Stars Momodu on 28/03/2020.
//

import Foundation

var ISO = XGISO()
class XGISO: NSObject {

	var allFileNames: [String] {
		XGFolders.FSYS.filenames.filter { $0.contains(".fsys") }
	}

	func importFiles(_ files: [XGFiles]) {
		for file in files where file.fileType == .fsys {
			if let data = file.data {
				data.file = .nameAndFolder(file.fileName, .FSYS)
				data.save()
			}
		}
	}

	func dataForFile(filename: String) -> XGMutableData? {
		return XGFiles.nameAndFolder(filename, .FSYS).data
	}

	func deleteFileAndPreserve(name: String, save: Bool) {
		let file = XGFiles.nameAndFolder(name, .FSYS)
		let null = XGMutableData(byteStream: NullFSYS.byteStream, file: file)
		null.save()
	}

	func save() { }

}
