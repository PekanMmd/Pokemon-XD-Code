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
let kFirstFileOffset				= 0x48
let kFirstFileDetailsPointerOffset	= 0x60
let kFirstFileNameOffset			= 0x70

let kSizeOfArchiveEntry				= game == .XD ? 0x70 : 0x50

let kFileIdentifierOffset			= 0x00 // 3rd byte is the file format, 1st half is an arbitrary identifier
let kFileFormatOffset				= 0x02
let kFileStartPointerOffset			= 0x04
let kUncompressedSizeOffset			= 0x08
let kCompressedSizeOffset			= 0x14
let kFileDetailsFullFilenameOffset	= 0x1C // includes file extension. Not always used.
let kFileFormatIndexOffset			= 0x20 // half of value in byte 3
let kFileDetailsFilenameOffset		= 0x24

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
	@objc var data : XGMutableData!
	
	init(file: XGFiles) {
		super.init()
		
		self.file = file
		self.data = self.file.data
	}
	
	@objc init(data: XGMutableData) {
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
	
	@objc var fileName : String {
		get {
			return file.fileName
		}
	}
	
	@objc var path : String {
		get {
			return file.path
		}
	}
	
	// some fsys files have 2 filenames per entry with the second containing the file extension
	@objc var usesFileExtensions : Bool {
		return self.data.getByteAtOffset(0x13) == 0x1
	}
	
	@objc var numberOfEntries : Int {
		get {
			return Int(data.get4BytesAtOffset(kNumberOfEntriesOffset))
		}
	}
	
	@objc func setNumberOfEntries(_ newEntries: Int) {
		self.data.replaceWordAtOffset(kNumberOfEntriesOffset, withBytes: UInt32(newEntries))
	}
	
	@objc func setFilesize(_ newSize: Int) {
		self.data.replaceWordAtOffset(kFSYSFileSizeOffset, withBytes: UInt32(newSize))
	}
	
	@objc func getStringAtOffset(offset: Int) -> String {
		
		var currentOffset = offset
		
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
		return string
	}
	
	@objc func fileNameForFileWithIndex(index: Int) -> String {
		let offset = Int(self.data.get4BytesAtOffset(startOffsetForFileDetails(index) + kFileDetailsFilenameOffset))
		return getStringAtOffset(offset:offset)
	}
	
	@objc func fullFileNameForFileWithIndex(index: Int) -> String {
		if !self.usesFileExtensions {
			return fileNameForFileWithIndex(index:index)
		}
		
		let offset = Int(self.data.get4BytesAtOffset(startOffsetForFileDetails(index) + kFileDetailsFullFilenameOffset))
		return getStringAtOffset(offset:offset)
	}
	
	@objc var firstFileNameOffset : Int {
		get {
			return Int(data.get4BytesAtOffset(kFirstFileNamePointerOffset))
		}
	}
	
	@objc func setFirstFilenameOffset(_ newOffset: Int) {
		self.data.replaceWordAtOffset(kFirstFileNamePointerOffset, withBytes: UInt32(newOffset))
	}
	
	@objc var fileNames : [String] {
		get {
			
			var names = [String]()
			
			for i in 0 ..< self.numberOfEntries {
				names.append(fileNameForFileWithIndex(index: i))
			}
			
			return names
		}
	}
	
	@objc var fullFileNames : [String] {
		get {
			
			var names = [String]()
			
			if self.usesFileExtensions {
				for i in 0 ..< self.numberOfEntries {
					names.append(fullFileNameForFileWithIndex(index: i))
				}
			}
			
			return names
		}
	}
	
	@objc var identifiers : [Int] {
		var ids = [Int]()
		for i in 0 ..< self.numberOfEntries {
			ids.append(identifierForFile(index: i))
		}
		return ids
	}
	
	@objc func indexForIdentifier(identifier: Int) -> Int {
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
	
	func indexForFileType(type: XGFileTypes) -> Int {
		
		for i in 0 ..< numberOfEntries {
			if fileTypeForFile(index: i).rawValue == type.rawValue {
				return i
			}
		}
		
		return -1
	}
	
	@objc var firstEntryDetailOffset : Int {
		get {
			return Int(data.get4BytesAtOffset(kFirstFileDetailsPointerOffset))
		}
	}
	
	@objc func setFirstEntryDetailOffset(_ newOffset: Int) {
		self.data.replaceWordAtOffset(kFirstFileDetailsPointerOffset, withBytes: UInt32(newOffset))
	}
	
	@objc var dataEnd : Int {
		return self.data.length - 0x4
	}
	
	@objc func startOffsetForFileDetails(_ index : Int) -> Int {
		return Int(data.get4BytesAtOffset(kFirstFileDetailsPointerOffset + (index * 4)))
		
	}
	
	@objc func startOffsetForFile(_ index: Int) -> Int {
		let start = startOffsetForFileDetails(index) + kFileStartPointerOffset
		return Int(data.get4BytesAtOffset(start))
	}
	
	@objc func setStartOffsetForFile(index: Int, newStart: Int) {
		let start = startOffsetForFileDetails(index) + kFileStartPointerOffset
		data.replaceWordAtOffset(start, withBytes: UInt32(newStart))
	}
	
	@objc func sizeForFile(index: Int) -> Int {
		let start = startOffsetForFileDetails(index) + kCompressedSizeOffset
		return Int(data.get4BytesAtOffset(start))
	}
	
	@objc func setSizeForFile(index: Int, newSize: Int) {
		let start = startOffsetForFileDetails(index) + kCompressedSizeOffset
		data.replaceWordAtOffset(start, withBytes: UInt32(newSize))
	}
	
	@objc func uncompressedSizeForFile(index: Int) -> Int {
		let start = startOffsetForFileDetails(index) + kUncompressedSizeOffset
		return Int(data.get4BytesAtOffset(start))
	}
	
	@objc func setUncompressedSizeForFile(index: Int, newSize: Int) {
		let start = startOffsetForFileDetails(index) + kUncompressedSizeOffset
		data.replaceWordAtOffset(start, withBytes: UInt32(newSize))
	}
	
	@objc func identifierForFile(index: Int) -> Int {
		let start = startOffsetForFileDetails(index) + kFileIdentifierOffset
		return Int(data.get4BytesAtOffset(start))
	}
	
	func fileTypeForFile(index: Int) -> XGFileTypes {
		return XGFileTypes(rawValue: (identifierForFile(index: index) & 0xFF00) >> 8) ?? .none
	}
	
	@objc func dataForFileWithName(name: String) -> XGMutableData? {
		let index = self.indexForFile(filename: name)
		if index == nil {
			printg("file doesn't exist: ", name)
			return nil
		}
		return dataForFileWithIndex(index: index!)
	}
	
	@objc func decompressedDataForFileWithName(name: String) -> XGMutableData? {
		let index = self.indexForFile(filename: name)
		if index == nil {
			printg("file doesn't exist: ", name)
			return nil
		}
		return decompressedDataForFileWithIndex(index: index!)
	}
	
	func decompressedDataForFileWithFiletype(type: XGFileTypes) -> XGMutableData? {
		let index = indexForFileType(type: type)
		if index < 0 || index > self.numberOfEntries {
			printg(self.fileName + " - file type: " + type.fileExtension + " doesn't exists.")
			return nil
		}
		return decompressedDataForFileWithIndex(index: index)
	}
	
	func decompressedDataForFilesWithFiletype(type: XGFileTypes) -> [XGMutableData] {
		var filesData = [XGMutableData]()
		for index in 0 ..< self.numberOfEntries {
			if fileTypeForFile(index: index) == type {
				if let file = decompressedDataForFileWithIndex(index: index) {
					filesData.append(file)
				}
			}
		}
		return filesData
	}
	
	@objc func dataForFileWithIndex(index: Int) -> XGMutableData? {
		
		let start = self.startOffsetForFile(index)
		let length = self.sizeForFile(index: index)
		
		let filename = self.fileNames[index]
		var ext = fileTypeForFile(index: index).fileExtension
		
		if self.data.get4BytesAtOffset(start) == kLZSSbytes {
			ext += ".lzss"
		}
		
		let fileData = data.getCharStreamFromOffset(start, length: length)
		
		return XGMutableData(byteStream: fileData, file: .nameAndFolder(filename.removeFileExtensions() + ext, .Documents))
	}
	
	@objc func decompressedDataForFileWithIndex(index: Int) -> XGMutableData? {
		
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
		
		var filename = self.usesFileExtensions ? fullFileNameForFileWithIndex(index: index) : fileNameForFileWithIndex(index: index)
		if !self.usesFileExtensions {
			filename += fileTypeForFile(index: index).fileExtension
		}
		
		
		decompressedData.file = .nameAndFolder(filename, .Documents)
		
		return decompressedData
		
	}
	
	@objc func isFileCompressed(index: Int) -> Bool {
		return self.data.get4BytesAtOffset(startOffsetForFile(index)) == kLZSSbytes
	}
	
	@objc func extractDataForFileWithIndex(index: Int) -> XGMutableData? {
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
	
	func shiftAndReplaceFileWithType(_ type: XGFileTypes, withFile newFile: XGFiles) {
		let index = indexForFileType(type: type)
		if index >= 0 {
			shiftAndReplaceFileWithIndex(index, withFile: newFile)
		}
	}
	
	func shiftAndReplaceFileWithIndex(_ index: Int, withFile newFile: XGFiles) {
		if !(index < self.numberOfEntries) {
			printg("index doesn't exist:", index)
			return
		}
		
		
		let oldSize = sizeForFile(index: index)
		let shift = (newFile.fileSize > oldSize) && (self.numberOfEntries > 1)
		
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
			var expansionRequired = 0
			
			if index < self.numberOfEntries - 1 {
				if fileEnd > startOffsetForFile(index + 1) {
					printg("file too large to replace: ", newFile.fileName, self.file.fileName, "adding space")
					expansionRequired = fileEnd - startOffsetForFile(index + 1)
				}
			}
			
			if fileEnd > self.dataEnd {
				printg("file too large to replace: ", newFile.fileName, self.file.fileName, "adding space")
				expansionRequired = fileEnd - dataEnd
			}
			
			if expansionRequired > 0 {
				
				self.increaseDataLength(by: expansionRequired)
				
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
			printg("file doesn't exist: ", self.file.path)
			return
		}
		if !newFile.exists {
			printg("file doesn't exist: ", newFile.path)
			return
		}
		
		if !(index < self.numberOfEntries) {
			printg("index doesn't exist:", index)
			return
		}
		
		let fileStart = startOffsetForFile(index)
		let fileEnd = fileStart + newFile.fileSize
		
		if index < self.numberOfEntries - 1 {
			if fileEnd > startOffsetForFile(index + 1) {
				printg("file too large to replace: ", newFile.fileName, self.file.fileName)
				compressionTooLarge = true
				return
			}
		}
		
		if fileEnd > self.dataEnd {
			printg("file too large to replace: ", newFile.fileName, self.file.fileName)
			compressionTooLarge = true
			return
		}
		
		eraseDataForFile(index: index)
		
		
		let fileSize = UInt32(newFile.data.length)
		let newData = newFile.data
		
		let detailsStart = startOffsetForFileDetails(index)
		data.replaceWordAtOffset(detailsStart + kCompressedSizeOffset, withBytes: fileSize)
		
		let lzssCheck = newData.get4BytesAtOffset(0) == kLZSSbytes
		if lzssCheck {
			data.replaceWordAtOffset(detailsStart + kUncompressedSizeOffset, withBytes: newData.get4BytesAtOffset(kLZSSUncompressedSizeOffset))
		} else {
			data.replaceWordAtOffset(detailsStart + kUncompressedSizeOffset, withBytes: fileSize)
		}
		
		data.replaceBytesFromOffset(fileStart, withByteStream: newData.byteStream)
		
		if saveWhenDone {
			save()
		}
	}
	
	@objc func eraseDataForFile(index: Int) {
		
		let start = startOffsetForFile(index)
		let size = sizeForFile(index: index)
		
		eraseData(start: start, length: size)
	}
	
	@objc func eraseData(start: Int, length: Int) {
		data.nullBytes(start: start, length: length)
	}
	
	@objc func deleteFile(index: Int) {
		eraseDataForFile(index: index)
		setSizeForFile(index: index, newSize: 0)
	}
	
	@objc func deleteFileAndPreserve(index: Int) {
		eraseDataForFile(index: index)
		setSizeForFile(index: index, newSize: 4)
		data.replaceBytesFromOffset(startOffsetForFile(index), withByteStream: [0xDE, 0x1E, 0x7E, 0xD0])
	}
	
	@objc func increaseDataLength(by bytes: Int) {
		var expansionRequired = bytes + 0x14
		while (expansionRequired % 16) != 0 { // byte alignment is required by the iso
			expansionRequired += 1
		}
		
		self.data.increaseLength(by: expansionRequired)
		self.setFilesize(self.data.length)
		self.data.replaceWordAtOffset(dataEnd, withBytes: kFSYSbytes)
	}
	
	func addFile(file: XGFiles, fileType: XGFileTypes, compress: Bool, shortID: Int) {
		self.addFile(file.data, fileType: fileType, compress: compress, shortID: shortID)
	}
	
	func addFile(_ fileData: XGMutableData, fileType: XGFileTypes, compress: Bool, shortID: Int) {
		// not considered fsys with alternate filename data. might change things, might not.
		let file = fileData.file
		let name = file.fileName.removeFileExtensions()
		
		var bytesAdded = 0
		let names = self.fileNames
		let fullnames = self.fullFileNames
		
		let fileDetailsPointerOffset = kFirstFileDetailsPointerOffset + (4 * self.numberOfEntries)
		if self.numberOfEntries % 4 == 0 {
			self.data.insertRepeatedByte(byte: 0, count: 16, atOffset: fileDetailsPointerOffset)
			bytesAdded += 16
		}
		
		let filenamesShift = bytesAdded
		let fullfilenamesShift = filenamesShift + name.count + 1
		setFirstFilenameOffset(self.firstFileNameOffset + bytesAdded)
		
		let allnames = self.usesFileExtensions ? names + fullnames : names
		
		var filenamesSize = 0
		for file in allnames {
			filenamesSize += file.count + 1
		}
		var padding = 16 - (filenamesSize % 16)
		padding = padding == 16 ? 0 : padding
		
		var extraNameBytes = self.usesFileExtensions ? file.fileName.count + name.count + 2 : name.count + 1
		if extraNameBytes <= padding {
			extraNameBytes = 0
		} else {
			extraNameBytes -= padding
		}
		while (filenamesSize + padding + extraNameBytes) % 16 != 0 {
			extraNameBytes += 1
		}
		
		bytesAdded += extraNameBytes
		self.data.insertRepeatedByte(byte: 0, count: extraNameBytes, atOffset: firstFileNameOffset)
		
		var currentOffset = self.firstFileNameOffset
		for n in names {
			for i in 0 ..< n.count {
				self.data.replaceByteAtOffset(currentOffset, withByte: Int(n.substring(from: i, to: i + 1).unicodeScalars.first!.value))
				currentOffset += 1
			}
			self.data.replaceByteAtOffset(currentOffset, withByte: 0)
			currentOffset += 1
		}
		
		let filenameStart = currentOffset
		
		for i in 0 ..< name.count {
			self.data.replaceByteAtOffset(currentOffset, withByte: Int(name.substring(from: i, to: i + 1).unicodeScalars.first!.value))
			currentOffset += 1
		}
		self.data.replaceByteAtOffset(currentOffset, withByte: 0)
		currentOffset += 1
		
		if self.usesFileExtensions {
			for n in fullnames {
				for i in 0 ..< n.count {
					self.data.replaceByteAtOffset(currentOffset, withByte: Int(n.substring(from: i, to: i + 1).unicodeScalars.first!.value))
					currentOffset += 1
				}
				self.data.replaceByteAtOffset(currentOffset, withByte: 0)
				currentOffset += 1
			}
		}
		let fullFilenameStart = currentOffset
		
		if self.usesFileExtensions {
			for i in 0 ..< file.fileName.count {
				self.data.replaceByteAtOffset(currentOffset, withByte: Int(file.fileName.substring(from: i, to: i + 1).unicodeScalars.first!.value))
				currentOffset += 1
			}
			self.data.replaceByteAtOffset(currentOffset, withByte: 0)
			currentOffset += 1
		}
		
		while currentOffset % 16 != 0 {
			self.data.replaceByteAtOffset(currentOffset, withByte: 0)
			currentOffset += 1
		}
		
		let entryShift = bytesAdded
		
		for i in 0 ..< self.numberOfEntries {
			let detailsPointer = kFirstFileDetailsPointerOffset + (4 * i)
			let newPointer = self.data.get4BytesAtOffset(detailsPointer) + UInt32(entryShift)
			self.data.replaceWordAtOffset(detailsPointer, withBytes: newPointer)
		}
		
		let entryStart = self.firstEntryDetailOffset + (0x70 * self.numberOfEntries)
		self.data.insertRepeatedByte(byte: 0, count: 0x70, atOffset: entryStart)
		bytesAdded += 0x70
		
		let fileStartShift = bytesAdded
		let newFirstFileOffset = self.data.get4BytesAtOffset(kFirstFileOffset) + UInt32(fileStartShift)
		self.data.replaceWordAtOffset(kFirstFileOffset, withBytes: newFirstFileOffset)
		
		
		var fileStart = self.startOffsetForFile(self.numberOfEntries - 1) + sizeForFile(index: self.numberOfEntries - 1) + bytesAdded
		
		while (fileStart % 16) != 0 {
			fileStart += 1
		}
		
		
		for i in 0 ..< self.numberOfEntries {
			
			let dets = self.firstEntryDetailOffset + (i * 0x70)
			let fileStart = self.data.get4BytesAtOffset(dets + kFileStartPointerOffset) + UInt32(fileStartShift)
			let nameStart = self.data.get4BytesAtOffset(dets + kFileDetailsFilenameOffset) + UInt32(filenamesShift)
			self.data.replaceWordAtOffset(dets + kFileStartPointerOffset, withBytes: fileStart)
			self.data.replaceWordAtOffset(dets + kFileDetailsFilenameOffset, withBytes: nameStart)
			
			if self.usesFileExtensions {
				let fullnameStart = self.data.get4BytesAtOffset(dets + kFileDetailsFullFilenameOffset) + UInt32(fullfilenamesShift)
				self.data.replaceWordAtOffset(dets + kFileDetailsFullFilenameOffset, withBytes: fullnameStart)
			}
			
		}
		
		let data = compress ? XGLZSS.InputData(fileData).compressedData : fileData
		
		var newFileSize = data.length
		while newFileSize % 16 != 0 {
			self.data.insertByte(byte: 0, atOffset: fileStart)
			newFileSize += 1
		}
		
		self.data.insertData(data: data, atOffset: fileStart)
		
		self.data.replaceWordAtOffset(fileDetailsPointerOffset, withBytes: UInt32(entryStart))
		self.data.replaceWordAtOffset(kFSYSFileSizeOffset, withBytes: UInt32(self.data.length))
		self.data.replaceWordAtOffset(kNumberOfEntriesOffset, withBytes: UInt32(self.numberOfEntries + 1))
		
		let isCompressed = data.get4BytesAtOffset(0) == kLZSSbytes
		let uncompressedSize = isCompressed ? data.get4BytesAtOffset(kLZSSUncompressedSizeOffset) : UInt32(data.length)
		let compressedSize = isCompressed ? data.get4BytesAtOffset(kLZSSCompressedSizeOffset) : UInt32(data.length)
		self.data.replaceWordAtOffset(entryStart + kUncompressedSizeOffset, withBytes: uncompressedSize)
		self.data.replaceWordAtOffset(entryStart + kCompressedSizeOffset, withBytes: compressedSize)
		self.data.replace2BytesAtOffset(entryStart + kFileIdentifierOffset, withBytes: shortID)
		self.data.replaceByteAtOffset(entryStart + kFileFormatOffset, withByte: fileType.rawValue)
		self.data.replaceWordAtOffset(entryStart + kFileStartPointerOffset, withBytes: UInt32(fileStart))
		self.data.replaceWordAtOffset(entryStart + 0xc, withBytes: 0x80000000)
		self.data.replaceWordAtOffset(entryStart + kFileFormatIndexOffset, withBytes: UInt32(fileType.index))
		self.data.replaceWordAtOffset(entryStart + kFileDetailsFilenameOffset, withBytes: UInt32(filenameStart))
		if self.usesFileExtensions {
			self.data.replaceWordAtOffset(entryStart + kFileDetailsFullFilenameOffset, withBytes: UInt32(fullFilenameStart))
		}
		self.data.replaceWordAtOffset(0x1c, withBytes: self.data.get4BytesAtOffset(0x48))
		
	}
	
	@objc func shiftUpFileWithIndex(index: Int) {
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
	
	@objc func shiftDownFileWithIndex(index: Int) {
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
	
	@objc func moveFile(index: Int, toOffset startOffset: Int) {
		let bytes = self.dataForFileWithIndex(index: index)!.byteStream
		
		self.eraseData(start: startOffsetForFile(index), length: sizeForFile(index: index))
		self.setStartOffsetForFile(index: index, newStart: startOffset)
		
		data.replaceBytesFromOffset(startOffset, withByteStream: bytes)
	}
	
	@objc func save() {
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
			
			// save .rel file first in case it's needed for script data
			if data[i].file.fileName.fileExtensions.contains(".rel") {
				data[i].save()
			}
		}
		
		for i in 0 ..< data.count {
			data[i].save()
			
			if data[i].file.fileName.fileExtensions.contains(".gtx") || data[i].file.fileName.fileExtensions.contains(".atx") {
				data[i].file.texture.saveImage(file: .nameAndFolder(updatedNames[i] + ".png", folder))
			}
			
			if data[i].file.fileName.fileExtensions.contains(".msg") {
				XGUtility.saveJSON(data[i].file.stringTable.readableDictionaryRepresentation as AnyObject, toFile: .nameAndFolder(updatedNames[i] + ".json", folder))
				
			}
			
			if data[i].file.fileName.fileExtensions.contains(".scd") && game == .XD {
				data[i].file.writeScriptData()
			}
			
		}
		
	}
	
}























