//
//  PBRNArchive.swift
//  GoD Tool
//
//  Created by Stars Momodu on 09/05/2022.
//

import Foundation

class PBRNArchive {
	
	var files = [XGMutableData]()
	
	convenience init?(file: XGFiles) {
		guard let data = file.data else {
			return nil
		}
		self.init(data: data)
	}
	
	init?(data: XGMutableData) {
		// NARC header
		guard data.length > 16,
			  data.getStringAtOffset(0, charLength: .char, maxCharacters: 4) == "CRAN" else {
			return nil
		}
		
		// File Allocation Table
		let fatbOffset = 0x10
		guard data.length > fatbOffset + 4,
			  data.getStringAtOffset(fatbOffset, charLength: .char, maxCharacters: 4) == "FATB" else {
			return nil
		}
		let fatbSize = data.get4BytesAtOffset(fatbOffset + 4)
		let fileCount = data.get2BytesAtOffset(fatbOffset + 8)
		var allocations = [(start: Int, end: Int)]()
		for i in 0 ..< fileCount {
			let offset = fatbOffset + 12 + (i * 8)
			let start = data.get4BytesAtOffset(offset)
			let end = data.get4BytesAtOffset(offset + 4)
			allocations.append((start, end))
		}
		
		// File Name Table
		let fntbOffset = fatbOffset + fatbSize
		guard data.length > fntbOffset + 4,
			  data.getStringAtOffset(fntbOffset, charLength: .char, maxCharacters: 4) == "FNTB" else {
			return nil
		}
		let fntbSize = data.get4BytesAtOffset(fntbOffset + 4)
		
		// File Image
		let fimgOffset = fntbOffset + fntbSize
		guard data.length > fimgOffset + 4,
			  data.getStringAtOffset(fimgOffset, charLength: .char, maxCharacters: 4) == "FIMG" else {
			return nil
		}
		for (start, end) in allocations {
			let offset = fimgOffset + 8 + start
			let length = end - start
			let fileData = data.getSubDataFromOffset(offset, length: length)
			fileData.file = .nameAndFolder(data.file.fileName.removeFileExtensions() + String(format: "%03d", files.count) + ".bin", data.file.folder)
			files.append(fileData)
		}
		
	}
	
	init(files: [XGMutableData]) {
		self.files = files
	}
	
	func build() -> XGMutableData {
		// NARC header
		let data = XGMutableData(string: "CRAN")
		data.appendBytes(0xFFFE0100.byteArray)
		data.appendBytes(0x00000000.byteArray) // reserve for file size to be replaced at the end
		data.appendBytes(0x00100003.byteArray)
		
		// File Allocation Table
		let allocationData = XGMutableData(string: "FATB")
		let fatbSize = 12 + (files.count * 8)
		allocationData.appendBytes(fatbSize.byteArray)
		let fileCount = files.count
		allocationData.appendBytes(fileCount.byteArrayU16 + [0, 0])
		
		var currentFileOffset = 0
		for file in files {
			allocationData.appendBytes(currentFileOffset.byteArray)
			currentFileOffset += file.length
			allocationData.appendBytes(currentFileOffset.byteArray)
			while currentFileOffset % 4 != 0 {
				currentFileOffset += 1
			}
			
		}
		data.appendData(allocationData)
		
		// File Name Table
		let filenameData = XGMutableData(string: "FNTB")
		filenameData.appendBytes(0x00000010.byteArray)
		filenameData.appendBytes(0x00000004.byteArray)
		filenameData.appendBytes(0x00010000.byteArray)
		data.appendData(filenameData)
		
		// File Image
		let imageData = XGMutableData(string: "FIMG")
		let fimgSize = 8 + currentFileOffset
		imageData.appendBytes(fimgSize.byteArray)
		
		for file in files {
			imageData.appendData(file)
			while imageData.length % 4 != 0 {
				imageData.appendBytes([0])
			}
		}
		data.appendData(imageData)
		
		data.replace4BytesAtOffset(8, withBytes: data.length)
		return data
	}
}
