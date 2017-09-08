//
//  XGFsys.swift
//  XG Tool
//
//  Created by The Steez on 01/06/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//

import Foundation

let kNumberOfEntriesOffset			= 0x0C
let kFirstFileNamePointerOffset		= 0x44
let kFirstFileDetailsPointerOffset	= 0x60
let kSizeOfArchiveEntry				= 0x70

let kFileStartPointerOffset			= 0x04
let kCompressedSizeOffset			= 0x14
let kUncompressedSizeOffset			= 0x08

let kLZSSUncompressedSizeOffset		= 0x04
let kLZSSCompressedSizeOffset		= 0x08

let kSizeOfLZSSHeader				= 0x10

enum XGFsys {
	
	case fsys(XGFiles)
	case nameAndData(String, XGMutableData)
	
	var description : String {
		get {
			var s = "\(self.fileName) - contains \(self.numberOfEntries) files\n"
			let f = self.fileNames
			for i in 0 ..< self.numberOfEntries {
					let offset = String(format: "0x%x", self.startOffsetForFile(i))
					s += "\(i):\t\(offset)\t\t\(f[i])\n"
			}
			return s
		}
	}
	
	var file : XGFiles {
		get{
			switch self {
				case .fsys(let file) : return file
				case .nameAndData(let name, _)    : return XGFiles.nameAndFolder(name, .FSYS)
			}
		}
	}
	
	var data : XGMutableData {
		get {
			switch self {
				case .fsys(let file) : return file.data
				case .nameAndData(_, let d)    : return d
			}
		}
	}
	
	var fileName : String {
		get {
			return file.fileName
		}
	}
	
	var path : String {
		get {
			return file.path
		}
	}
	
	var numberOfEntries : Int {
		get {
			return Int(data.get4BytesAtOffset(kNumberOfEntriesOffset))
		}
	}
	
	var firstFileNameOffset : Int {
		get {
			return Int(data.get4BytesAtOffset(kFirstFileNamePointerOffset))
		}
	}
	
	var fileNames : [String] {
		get {
			
			var names = [String]()
			
			var currentOffset = firstFileNameOffset
			
			for _ in 0 ..< numberOfEntries {
			
				var currentChar = 0x1
				var string = ""
				
				while currentChar != 0x0 {
					
					currentChar = data.getByteAtOffset(currentOffset)
				
					if currentChar != 0x0 {
						let char = UInt32(currentChar)
						
						var unicode = "_"
						
						unicode = String(describing: UnicodeScalar(char)!)
						
						string = string + unicode
						
					}
					currentOffset += 1
				}
				names.append(string)
			}
			return names
		}
	}
	
	var firstEntryDetailOffset : Int {
		get {
			return Int(data.get4BytesAtOffset(kFirstFileDetailsPointerOffset))
		}
	}
	
	func startOffsetForFileDetails(_ index : Int) -> Int {
		return firstEntryDetailOffset + (index * kSizeOfArchiveEntry)
	}
	
	func startOffsetForFile(_ index: Int) -> Int {
		let start = startOffsetForFileDetails(index) + kFileStartPointerOffset
		return Int(data.get4BytesAtOffset(start))
	}
	
	func sizeForFile(index: Int) -> Int {
		let start = startOffsetForFileDetails(index) + kCompressedSizeOffset
		return Int(data.get4BytesAtOffset(start))
	}
	
	func dataForFileWithIndex(index: Int) -> XGMutableData? {
		switch self {
		case .fsys(let file) :
			if !file.exists {
				print("file doesn't exist: ", self.file.path)
				return nil
			}
		default:
			break
			
		}
		
		let data = self.data
		let start = self.startOffsetForFile(index)
		let length = self.sizeForFile(index: index)
		
		let filename = fileNames[index]
		let fileData = data.getCharStreamFromOffset(start, length: length)
		
		return XGMutableData(byteStream: fileData, file: .nameAndFolder(filename, .Documents))
	}
	
	func decompressedDataForFileWithIndex(index: Int) -> XGMutableData? {
		
		switch self {
		case .fsys(let file) :
			if !file.exists {
				print("file doesn't exist: ", self.file.path)
				return nil
			}
		default:
			break

		}
		
		let filename = fileNames[index] + ".fdat"
		let fileData = dataForFileWithIndex(index: index)!
//		let compressedSize = fileData.get4BytesAtOffset(kLZSSCompressedSizeOffset)
		let decompressedSize = Int32(fileData.get4BytesAtOffset(kLZSSUncompressedSizeOffset))
		
		
		var stream = fileData.getCharStreamFromOffset(kSizeOfLZSSHeader, length: fileData.length - kSizeOfLZSSHeader)
		let compressor = XGLZSSWrapper()
		let bytes = compressor.decompressFile(&stream, ofSize: Int32(stream.count), decompressedSize: decompressedSize)
		var decompressedStream = [UInt8]()
		for i : Int32 in 0 ..< decompressedSize {
			decompressedStream.append((bytes?[Int(i)])!)
		}
		let decompressedData = XGMutableData(byteStream: decompressedStream, file: .nameAndFolder(filename, .Documents))
		return decompressedData
		
	}
	
	func indexForFile(filename: String) -> Int? {
		return self.fileNames.index(of: filename)
	}
	
	func replaceFileWithName(name: String, withFile newFile: XGFiles) {
		let index = self.indexForFile(filename: name)
		
		if index != nil {
			self.replaceFileWithIndex(index!, withFile: newFile)
		}
	}
	
	func replaceFile(file: XGFiles) {
		self.replaceFileWithName(name: file.fileName.replacingOccurrences(of: ".lzss", with: ""), withFile: file)
	}
	
	func replaceFileWithIndex(_ index: Int, withFile newFile: XGFiles) {
		if !self.file.exists {
			print("file doesn't exist: ", self.file.path)
			return
		}
		if !newFile.exists {
			print("file doesn't exist: ", newFile.path)
			return
		}
		
		let data = self.data
		let fileSize = UInt32(newFile.data.length + kSizeOfLZSSHeader)
		
		let detailsStart = startOffsetForFileDetails(index)
		data.replace4BytesAtOffset(detailsStart + kCompressedSizeOffset, withBytes: fileSize)
		
		let fileStart = startOffsetForFile(index)
		data.replace4BytesAtOffset(fileStart  + kLZSSCompressedSizeOffset, withBytes: fileSize)
		data.replaceBytesFromOffset(fileStart + kSizeOfLZSSHeader, withByteStream: newFile.data.byteStream)
		
		data.save()
		
	}
	
}























