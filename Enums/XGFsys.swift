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
	
	case Fsys(XGFiles)
	
	var file : XGFiles {
		get{
			switch self {
				case .Fsys(let file) : return file
			}
		}
	}
	
	var data : XGMutableData {
		get {
			return file.data
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
			
			for var i = 0; i < numberOfEntries; i++ {
			
				var currentChar = 0x1
				var string = ""
				
				while currentChar != 0x0 {
					
					currentChar = data.getByteAtOffset(currentOffset)
				
					let char = UInt32(currentChar)
					
					var unicode = "_"
					
					unicode = String(UnicodeScalar(char))
					
					string = string.stringByAppendingString(unicode)
					
					currentOffset++
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
	
	func startOffsetForFileDetails(index : Int) -> Int {
		return firstEntryDetailOffset + (index * kSizeOfArchiveEntry)
	}
	
	func startOffsetForFile(index: Int) -> Int {
		let start = startOffsetForFile(index) + kFileStartPointerOffset
		return Int(data.get4BytesAtOffset(start))
	}
	
	func replaceFileWithIndex(index: Int, withFile newFile : XGFiles) {
		
		var data = self.data
		
		let detailsStart = startOffsetForFileDetails(index)
		data.replace4BytesAtOffset(detailsStart + kCompressedSizeOffset, withBytes: UInt32(newFile.data.length + kSizeOfLZSSHeader))
		
		let fileStart = startOffsetForFile(index)
		data.replace4BytesAtOffset(fileStart  + kLZSSCompressedSizeOffset, withBytes: UInt32(newFile.data.length + kSizeOfLZSSHeader))
		data.replaceBytesFromOffset(fileStart + kSizeOfLZSSHeader, withByteStream: newFile.data.byteStream)
		
		data.save()
		
	}
	
}

























