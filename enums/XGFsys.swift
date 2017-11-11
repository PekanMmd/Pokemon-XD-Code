//
//  XGFsys.swift
//  XG Tool
//
//  Created by StarsMmd on 01/06/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

let kNumberOfEntriesOffset			= 0x0C
let kFSYSFileSizeOffset				= 0x20
let kFirstFileNamePointerOffset		= 0x44
let kFirstFileDetailsPointerOffset	= 0x60
let kSizeOfArchiveEntry				= 0x70

let kFileIdentifierOffset			= 0x00 // 3rd byte is the file format, 1st half is an arbitrary identifier
let kFileStartPointerOffset			= 0x04
let kUncompressedSizeOffset			= 0x08
let kCompressedSizeOffset			= 0x14

let kLZSSUncompressedSizeOffset		= 0x04
let kLZSSCompressedSizeOffset		= 0x08

let kSizeOfLZSSHeader				= 0x10

let kLZSSbytes : UInt32				= 0x4C5A5353
let kTCODbytes : UInt32				= 0x54434F44
let kFSYSbytes : UInt32				= 0x46535953
let kUSbytes						= 0x5553
let kJPbytes						= 0x4A50

class XGFsys : NSObject {
	
	var file : XGFiles!
	var data : XGMutableData!
	
	init(file: XGFiles) {
		super.init()
		
		self.file = file
		self.data = self.file.data
	}
	
	init(data: XGMutableData) {
		super.init()
		
		self.data = data
		self.file = self.data.file
	}
	
	override var description : String {
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
	
	func setFilesize(_ newSize: Int) {
		self.data.replace4BytesAtOffset(kFSYSFileSizeOffset, withBytes: UInt32(newSize))
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
	
	var identifiers : [Int] {
		var ids = [Int]()
		for i in 0 ..< self.numberOfEntries {
			ids.append(identifierForFile(index: i))
		}
		return ids
	}
	
	func indexForIdentifier(identifier: Int) -> Int {
		var index = -1
		
		let idents = identifiers
		
		for id in 0 ..< idents.count {
			if idents[id] == identifier {
				index = id
				break
			}
		}
		
		return index
	}
	
	var firstEntryDetailOffset : Int {
		get {
			return Int(data.get4BytesAtOffset(kFirstFileDetailsPointerOffset))
		}
	}
	
	var dataEnd : Int {
		return self.data.length - 0x4
	}
	
	func startOffsetForFileDetails(_ index : Int) -> Int {
		return Int(data.get4BytesAtOffset(kFirstFileDetailsPointerOffset + (index * 4)))
		
	}
	
	func startOffsetForFile(_ index: Int) -> Int {
		let start = startOffsetForFileDetails(index) + kFileStartPointerOffset
		return Int(data.get4BytesAtOffset(start))
	}
	
	func setStartOffsetForFile(index: Int, newStart: Int) {
		let start = startOffsetForFileDetails(index) + kFileStartPointerOffset
		data.replace4BytesAtOffset(start, withBytes: UInt32(newStart))
	}
	
	func sizeForFile(index: Int) -> Int {
		let start = startOffsetForFileDetails(index) + kCompressedSizeOffset
		return Int(data.get4BytesAtOffset(start))
	}
	
	func setSizeForFile(index: Int, newSize: Int) {
		let start = startOffsetForFileDetails(index) + kCompressedSizeOffset
		data.replace4BytesAtOffset(start, withBytes: UInt32(newSize))
	}
	
	func uncompressedSizeForFile(index: Int) -> Int {
		let start = startOffsetForFileDetails(index) + kUncompressedSizeOffset
		return Int(data.get4BytesAtOffset(start))
	}
	
	func setUncompressedSizeForFile(index: Int, newSize: Int) {
		let start = startOffsetForFileDetails(index) + kUncompressedSizeOffset
		data.replace4BytesAtOffset(start, withBytes: UInt32(newSize))
	}
	
	func identifierForFile(index: Int) -> Int {
		let start = startOffsetForFileDetails(index) + kFileIdentifierOffset
		return Int(data.get4BytesAtOffset(start))
	}
	
	func fileTypeForFile(index: Int) -> Int {
		return (identifierForFile(index: index) & 0xFF00) >> 8
	}
	
	func dataForFileWithName(name: String) -> XGMutableData? {
		let index = self.indexForFile(filename: name)
		if index == nil {
			print("file doesn't exist: ", name)
			return nil
		}
		return dataForFileWithIndex(index: index!)
	}
	
	func decompressedDataForFileWithName(name: String) -> XGMutableData? {
		let index = self.indexForFile(filename: name)
		if index == nil {
			print("file doesn't exist: ", name)
			return nil
		}
		return decompressedDataForFileWithIndex(index: index!)
	}
	
	func dataForFileWithIndex(index: Int) -> XGMutableData? {
		
		if !file.exists {
			print("file doesn't exist: ", self.file.path, "index", index)
			return nil
		}
		
		let start = self.startOffsetForFile(index)
		let length = self.sizeForFile(index: index)
		
		let filename = self.fileNames[index]
		var ext = filename.removeFileExtensions() == filename ? ".fdat" : ""
		
		if self.data.get4BytesAtOffset(start) == kLZSSbytes {
			ext = ".lzss"
		}
		
		let fileData = data.getCharStreamFromOffset(start, length: length)
		
		return XGMutableData(byteStream: fileData, file: .nameAndFolder(filename + ext, .Documents))
	}
	
	func decompressedDataForFileWithIndex(index: Int) -> XGMutableData? {
		
		if !file.exists {
			print("file doesn't exist: ", self.file.path)
			return nil
		}
		
		
		let fileData = dataForFileWithIndex(index: index)!
		let decompressedSize = Int32(fileData.get4BytesAtOffset(kLZSSUncompressedSizeOffset))
		
		
		var stream = fileData.getCharStreamFromOffset(kSizeOfLZSSHeader, length: fileData.length - kSizeOfLZSSHeader)
		let compressor = XGLZSSWrapper()
		let bytes = compressor.decompressFile(&stream, ofSize: Int32(stream.count), decompressedSize: decompressedSize)!
		var decompressedStream = [UInt8]()
		for i : Int32 in 0 ..< decompressedSize {
			decompressedStream.append((bytes[Int(i)]))
		}
		let decompressedData = XGMutableData(byteStream: decompressedStream, file: .nameAndFolder("", .Documents))
		
		let filename = self.fileNames[index]
		var ext = filename.removeFileExtensions() == filename ? ".fdat" : ""
		
//		if decompressedData.get4BytesAtOffset(0) == kTCODbytes {
//			ext = ".scd"
//		}
//		
//		if (decompressedData.get4BytesAtOffset(0) == 0x0) && (decompressedData.get2BytesAtOffset(0x6) == kUSbytes) {
//			ext = ".msg"
//		}
//		
//		if (decompressedData.get4BytesAtOffset(0) == 0x0) && (decompressedData.get2BytesAtOffset(0x6) == kJPbytes) {
//			ext = ".msg"
//		}
		
		let fileTypes = [(".dat", 0x04), // character model in hal dat format
						 (".msg", 0x0a), // string table
						 (".fnt", 0x0c), // font
						 (".scd", 0x0e), // script data
						 (".gtx", 0x12), // texture
						 (".cam", 0x18), // camera data
						 (".rel", 0x1c), // relocation table
		                 (".pkx", 0x1e), // character battle model
		                 (".wzx", 0x20), // move animation
		                 (".atx", 0x32), // animated texture
		                 (".bin", 0x34), // binary
			
		                 ]
		for t in fileTypes {
			if fileTypeForFile(index: index) == t.1 {
				ext = t.0
			}
		}
		
		
		decompressedData.file = .nameAndFolder(filename + ext, .Documents)
		
		return decompressedData
		
	}
	
	func isFileCompressed(index: Int) -> Bool {
		return self.data.get4BytesAtOffset(startOffsetForFile(index)) == kLZSSbytes
	}
	
	func extractDataForFileWithIndex(index: Int) -> XGMutableData? {
		// checks if the file is compressed or not and returns the appropriate data
		if !(index < self.numberOfEntries) {
			return nil
		}
		
		return isFileCompressed(index: index) ? decompressedDataForFileWithIndex(index: index) : dataForFileWithIndex(index: index)
	}
	
	func indexForFile(filename: String) -> Int? {
		return self.fileNames.index(of: filename)
	}
	
	func replaceFileWithName(name: String, withFile newFile: XGFiles) {
		let index = self.indexForFile(filename: name)
		if !newFile.exists {
			printg("file doesn't exist:", newFile.path)
			return
		}
		
		if index != nil {
			if isFileCompressed(index: index!) && !newFile.fileName.contains(".lzss") {
				self.shiftAndReplaceFileWithIndex(index!, withFile: newFile.compress())
			} else {
				self.shiftAndReplaceFileWithIndex(index!, withFile: newFile)
			}
		} else {
			printg("file with name '",name,"' doesn't exist in ",self.fileName)
		}
	}
	
	func replaceFile(file: XGFiles, removeFileExtension: Bool) {
		let filename = removeFileExtension ? file.fileName.removeFileExtensions() : file.fileName
		self.replaceFileWithName(name: filename, withFile: file)
	}
	
	func replaceFile(file: XGFiles) {
		// only use if filename in fsys doesn't have any '.' characters (and no file extension)
		self.replaceFile(file: file, removeFileExtension: true)
	}
	
	func shiftAndReplaceFileWithIndex(_ index: Int, withFile newFile: XGFiles) {
		if !(index < self.numberOfEntries) {
			print("index doesn't exist:", index)
			return
		}
		
		
		let oldSize = sizeForFile(index: index)
		let shift = (newFile.fileSize != oldSize) && (self.numberOfEntries > 1)
		
		if shift {
			for i in 0 ..< self.numberOfEntries {
				self.shiftUpFileWithIndex(index: i)
			}
			
			var rev = [Int]()
			for i in (index + 1) ..< self.numberOfEntries {
				rev.append(i)
			}
			for i in rev.reversed() {
				self.shiftDownFileWithIndex(index: i)
			}
			
			let fileEnd = startOffsetForFile(index) + newFile.fileSize
			var exapansionRequired = 0
			
			if index < self.numberOfEntries - 1 {
				if fileEnd > startOffsetForFile(index + 1) {
					print("file too large to replace: ", newFile.fileName, self.file.fileName, "adding space")
					exapansionRequired = fileEnd - startOffsetForFile(index + 1)
				}
			}
			
			if fileEnd > self.dataEnd {
				print("file too large to replace: ", newFile.fileName, self.file.fileName, "adding space")
				exapansionRequired = fileEnd - dataEnd
			}
			
			if exapansionRequired > 0 {
				
				self.data.increaseLength(by: exapansionRequired + 0x14)
				self.setFilesize(self.data.length)
				self.data.replace4BytesAtOffset(dataEnd, withBytes: kFSYSbytes)
				for i in rev.reversed() {
					self.shiftDownFileWithIndex(index: i)
				}
			}
			
			
		}
		
		self.replaceFileWithIndex(index, withFile: newFile, saveWhenDone: false)
		
		if shift {
			for i in 0 ..< self.numberOfEntries {
				self.shiftUpFileWithIndex(index: i)
			}
		}
	
		self.save()
	}
	
	func replaceFileWithIndex(_ index: Int, withFile newFile: XGFiles, saveWhenDone: Bool) {
		if !self.file.exists {
			print("file doesn't exist: ", self.file.path)
			return
		}
		if !newFile.exists {
			print("file doesn't exist: ", newFile.path)
			return
		}
		
		if !(index < self.numberOfEntries) {
			print("index doesn't exist:", index)
			return
		}
		
		let fileStart = startOffsetForFile(index)
		let fileEnd = fileStart + newFile.fileSize
		
		if index < self.numberOfEntries - 1 {
			if fileEnd > startOffsetForFile(index + 1) {
				print("file too large to replace: ", newFile.fileName, self.file.fileName)
				return
			}
		}
		
		if fileEnd > self.dataEnd {
			print("file too large to replace: ", newFile.fileName, self.file.fileName)
			return
		}
		
		eraseDataForFile(index: index)
		
		
		let fileSize = UInt32(newFile.data.length)
		let newData = newFile.data
		
		let detailsStart = startOffsetForFileDetails(index)
		data.replace4BytesAtOffset(detailsStart + kCompressedSizeOffset, withBytes: fileSize)
		
		let lzssCheck = newData.get4BytesAtOffset(0) == kLZSSbytes
		if lzssCheck {
			data.replace4BytesAtOffset(detailsStart + kUncompressedSizeOffset, withBytes: newData.get4BytesAtOffset(kLZSSUncompressedSizeOffset))
		} else {
			data.replace4BytesAtOffset(detailsStart + kUncompressedSizeOffset, withBytes: fileSize)
		}
		
		data.replaceBytesFromOffset(fileStart, withByteStream: newData.byteStream)
		
		if saveWhenDone {
			save()
		}
	}
	
	func eraseDataForFile(index: Int) {
		
		let start = startOffsetForFile(index)
		let size = sizeForFile(index: index)
		
		eraseData(start: start, length: size)
	}
	
	func eraseData(start: Int, length: Int) {
		data.nullBytes(start: start, length: length)
	}
	
	func deleteFile(index: Int) {
		eraseDataForFile(index: index)
		setSizeForFile(index: index, newSize: 0)
	}
	
	func deleteFileAndPreserve(index: Int) {
		eraseDataForFile(index: index)
		setSizeForFile(index: index, newSize: 4)
		data.replaceBytesFromOffset(startOffsetForFile(index), withByteStream: [0xDE, 0x1E, 0x7E, 0xD0])
	}
	
	func shiftUpFileWithIndex(index: Int) {
		// used to push a file closer to the file above it and create more space for other files
		if !(index < self.numberOfEntries) { return }
		
		var previousEnd = 0x0
		if index == 0 {
			previousEnd = self.startOffsetForFileDetails(self.numberOfEntries - 1) + kSizeOfArchiveEntry
		} else {
			previousEnd = self.startOffsetForFile(index - 1) + sizeForFile(index: index - 1)
		}
		
		while (previousEnd % 16) != 0 {
			previousEnd += 1
		}
		
		self.moveFile(index: index, toOffset: previousEnd)
		
	}
	
	func shiftDownFileWithIndex(index: Int) {
		// used to push a file closer to the file above it and create more space for other files
		if !(index < self.numberOfEntries) { return }
		
		let size = sizeForFile(index: index)
		
		var nextStart = 0x0
		
		if index == self.numberOfEntries - 1 {
			nextStart = self.dataEnd
		} else {
			nextStart = startOffsetForFile(index + 1)
		}
		
		var start = nextStart - size
		while (start % 16) != 0 {
			start -= 1
		}
		self.moveFile(index: index, toOffset: start)
		
	}
	
	func moveFile(index: Int, toOffset startOffset: Int) {
		let bytes = self.dataForFileWithIndex(index: index)!.byteStream
		
		self.eraseData(start: startOffsetForFile(index), length: sizeForFile(index: index))
		self.setStartOffsetForFile(index: index, newStart: startOffset)
		
		data.replaceBytesFromOffset(startOffset, withByteStream: bytes)
	}
	
	func save() {
		self.data.save()
	}
	
	func extractFilesToFolder(folder: XGFolders) {
		
		var data = [XGMutableData]()
		for i in 0 ..< self.numberOfEntries {
			data.append(extractDataForFileWithIndex(index: i)!)
		}
		
		let filenames = data.map { (d) -> String in
			return d.file.fileName
		}
		var repeats = [Int]()
		for i in 0 ..< filenames.count {
			let current = filenames[i]
			var counter = 0
			for j in 0 ..< i {
				if filenames[j] == current {
					counter += 1
				}
			}
			repeats.append(counter)
		}
		
		var updatedNames = [String]()
		for i in 0 ..< filenames.count {
			var addendum = ""
			if repeats[i] > 0 {
				addendum = "\(repeats[i])"
				while addendum.characters.count < 4 {
					addendum = "0" + addendum
				}
				addendum = " " + addendum
			}
			
			updatedNames.append(filenames[i].removeFileExtensions() + addendum + filenames[i].fileExtensions)
		}
		
		for i in 0 ..< data.count {
			data[i].file = .nameAndFolder(updatedNames[i], folder)
			data[i].save()
			
			if data[i].file.fileName.fileExtensions.contains(".gtx") || data[i].file.fileName.fileExtensions.contains(".atx") {
				data[i].file.texture.saveImage(file: .nameAndFolder(updatedNames[i] + ".png", folder))
			}
			
			if data[i].file.fileName.fileExtensions.contains(".msg") {
				XGUtility.saveJSON(data[i].file.stringTable.readableDictionaryRepresentation as AnyObject, toFile: .nameAndFolder(updatedNames[i] + ".json", folder))
				
			}
			
			if data[i].file.fileName.fileExtensions.contains(".scd") {
				XGUtility.saveString(data[i].file.scriptData.description, toFile: .nameAndFolder(updatedNames[i] + ".txt", folder))
			}
			
		}
		
	}
	
}























