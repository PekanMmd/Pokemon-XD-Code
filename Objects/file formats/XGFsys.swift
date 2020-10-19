//
//  XGFsys.swift
//  XG Tool
//
//  Created by StarsMmd on 01/06/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

let kFSYSGroupIDOffset				= 0x08
let kNumberOfEntriesOffset			= 0x0C
let kFSYSFileSizeOffset				= 0x20
let kFirstFileNamePointerOffset		= 0x44
let kFirstFileOffset				= 0x48
let kFirstFileDetailsPointerOffset	= 0x60
let kFirstFileNameOffset			= 0x70

let kSizeOfArchiveEntry				= game == .Colosseum ? 0x50 : 0x70

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
let kLZSSUnkownOffset				= 0x0C // PBR only, unused in Colo/XD

let kSizeOfLZSSHeader				= 0x10

let kLZSSbytes : UInt32				= 0x4C5A5353
let kTCODbytes : UInt32				= 0x54434F44
let kFSYSbytes : UInt32				= 0x46535953
let kUSbytes						= 0x5553
let kJPbytes						= 0x4A50

final class XGFsys : NSObject {
	
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
	
	var groupID : Int {
		return self.data.get4BytesAtOffset(kFSYSGroupIDOffset)
	}

	func setGroupID(_ id: Int) {
		data.replace4BytesAtOffset(kFSYSGroupIDOffset, withBytes: id)
	}
	
	// some fsys files have 2 filenames per entry with the second containing the file extension
	@objc var usesFileExtensions : Bool {
		return self.data.getByteAtOffset(0x13) == 0x1
	}
	
	@objc var numberOfEntries : Int {
		get {
			return Int(data.getWordAtOffset(kNumberOfEntriesOffset))
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
		let offset = Int(self.data.getWordAtOffset(startOffsetForFileDetails(index) + kFileDetailsFilenameOffset))
		var name = getStringAtOffset(offset:offset)
		if game == .PBR {
			var addendum = "\(index)"
			while addendum.length < 4 {
				addendum = "0" + addendum
			}
			addendum = " " + addendum
			name = fileName.removeFileExtensions() + addendum
		}
		return name
	}
	
	@objc func fullFileNameForFileWithIndex(index: Int) -> String {
		if !self.usesFileExtensions {
			return fileNameForFileWithIndex(index:index)
		}
		
		let offset = Int(self.data.getWordAtOffset(startOffsetForFileDetails(index) + kFileDetailsFullFilenameOffset))
		return getStringAtOffset(offset:offset)
	}
	
	@objc var firstFileNameOffset : Int {
		get {
			return Int(data.getWordAtOffset(kFirstFileNamePointerOffset))
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
	
	func indexForFileType(type: XGFileTypes) -> Int? {
		
		for i in 0 ..< numberOfEntries {
			if fileTypeForFile(index: i).rawValue == type.rawValue {
				return i
			}
		}
		
		return nil
	}
	
	@objc var firstEntryDetailOffset : Int {
		get {
			return Int(data.getWordAtOffset(kFirstFileDetailsPointerOffset))
		}
	}
	
	@objc func setFirstEntryDetailOffset(_ newOffset: Int) {
		self.data.replaceWordAtOffset(kFirstFileDetailsPointerOffset, withBytes: UInt32(newOffset))
	}
	
	@objc var dataEnd : Int {
		return self.data.length - 0x4
	}
	
	@objc func startOffsetForFileDetails(_ index : Int) -> Int {
		return Int(data.getWordAtOffset(kFirstFileDetailsPointerOffset + (index * 4)))
		
	}
	
	@objc func startOffsetForFile(_ index: Int) -> Int {
		let start = startOffsetForFileDetails(index) + kFileStartPointerOffset
		return Int(data.getWordAtOffset(start))
	}
	
	@objc func setStartOffsetForFile(index: Int, newStart: Int) {
		let start = startOffsetForFileDetails(index) + kFileStartPointerOffset
		data.replaceWordAtOffset(start, withBytes: UInt32(newStart))
	}
	
	@objc func sizeForFile(index: Int) -> Int {
		let start = startOffsetForFileDetails(index) + kCompressedSizeOffset
		return Int(data.getWordAtOffset(start))
	}
	
	@objc func setSizeForFile(index: Int, newSize: Int) {
		let start = startOffsetForFileDetails(index) + kCompressedSizeOffset
		data.replaceWordAtOffset(start, withBytes: UInt32(newSize))
	}
	
	@objc func uncompressedSizeForFile(index: Int) -> Int {
		let start = startOffsetForFileDetails(index) + kUncompressedSizeOffset
		return Int(data.getWordAtOffset(start))
	}
	
	@objc func setUncompressedSizeForFile(index: Int, newSize: Int) {
		let start = startOffsetForFileDetails(index) + kUncompressedSizeOffset
		data.replaceWordAtOffset(start, withBytes: UInt32(newSize))
	}
	
	@objc func identifierForFile(index: Int) -> Int {
		let start = startOffsetForFileDetails(index) + kFileIdentifierOffset
		return Int(data.getWordAtOffset(start))
	}
	
	func fileTypeForFile(index: Int) -> XGFileTypes {
		return XGFileTypes(rawValue: (identifierForFile(index: index) & 0xFF00) >> 8) ?? .unknown
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
		if let index = indexForFileType(type: type) {
			if index < 0 || index > self.numberOfEntries {
				if settings.verbose {
					printg(self.fileName + " - file type: " + type.fileExtension + " doesn't exists.")
				}
				return nil
			}
			return decompressedDataForFileWithIndex(index: index)
		}
		return nil
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
		
		var filename = self.usesFileExtensions ? self.fullFileNames[index] : self.fileNames[index]
		if filename == "common_rel" {
			filename = "common"
		}
		if !self.usesFileExtensions || filename.removeFileExtensions() == filename {
			filename = filename.removeFileExtensions()
			filename += fileTypeForFile(index: index).fileExtension
		}
		if self.data.getWordAtOffset(start) == kLZSSbytes {
			filename += XGFileTypes.lzss.fileExtension
		}
		
		let fileData = data.getCharStreamFromOffset(start, length: length)
		
		return XGMutableData(byteStream: fileData, file: .nameAndFolder(filename, .Documents))
	}
	
	@objc func decompressedDataForFileWithIndex(index: Int) -> XGMutableData? {
		
		let fileData = dataForFileWithIndex(index: index)!
//		let decompressedSize = fileData.getWordAtOffset(kLZSSUncompressedSizeOffset)
		fileData.deleteBytes(start: 0, count: kSizeOfLZSSHeader)

		let decompressedData = XGLZSS.decode(data: fileData)
		
		var filename = self.usesFileExtensions ? fullFileNameForFileWithIndex(index: index) : fileNameForFileWithIndex(index: index)
		if filename == "common_rel" {
			filename = "common"
		}
		if !self.usesFileExtensions || filename.removeFileExtensions() == filename {
			filename = filename.removeFileExtensions()
			filename += fileTypeForFile(index: index).fileExtension
		}

		decompressedData.file = .nameAndFolder(filename, .Documents)
		
		return decompressedData
		
	}
	
	@objc func isFileCompressed(index: Int) -> Bool {
		return self.data.getWordAtOffset(startOffsetForFile(index)) == kLZSSbytes
	}

	@objc func getUnknownLZSSForFileWithIndex(_ index: Int) -> UInt32 {
		return self.data.getWordAtOffset(startOffsetForFile(index) + kLZSSUnkownOffset)
	}
	
	@objc func extractDataForFileWithIndex(index: Int) -> XGMutableData? {
		// checks if the file is compressed or not and returns the appropriate data
		if !(index < self.numberOfEntries) {
			return nil
		}
		
		return isFileCompressed(index: index) ? decompressedDataForFileWithIndex(index: index) : dataForFileWithIndex(index: index)
	}
	
	func indexForFile(filename: String) -> Int? {
		if self.usesFileExtensions {
			return self.fullFileNames.firstIndex(of: filename)
		}
		return self.fileNames.firstIndex(of: filename)
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
	
	func shiftAndReplaceFileWithType(_ type: XGFileTypes, withFile newFile: XGFiles, save: Bool) {
		if let index = indexForFileType(type: type) {
			if index >= 0 {
				shiftAndReplaceFileWithIndexEfficiently(index, withFile: newFile, save: save)
			}
		}
	}
	
	func shiftAndReplaceFileWithIndex(_ index: Int, withFile newFile: XGFiles) {
		if !(index < self.numberOfEntries) {
			printg("skipping fsys import: \(newFile.fileName) to \(self.fileName)\nindex doesn't exist:", index)
			return
		}
		
		var newFile = newFile
		if self.isFileCompressed(index: index) && newFile.data!.getWordAtOffset(0) != kLZSSbytes {
			newFile = newFile.compress()
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
	
	func shiftAndReplaceFileWithIndexEfficiently(_ index: Int, withFile newFile: XGFiles, save: Bool) {
		if !(index < self.numberOfEntries) {
			printg("skipping fsys import: \(newFile.fileName) to \(self.fileName)\nindex doesn't exist:", index)
			return
		}
		
		var newFile = newFile
		if self.isFileCompressed(index: index) && (newFile.data!.getWordAtOffset(0) != kLZSSbytes) {
			newFile = newFile.compress()
		}
		
		var fileEnd = startOffsetForFile(index) + newFile.fileSize
		let nextStart = index < self.numberOfEntries - 1 ? startOffsetForFile(index + 1) : dataEnd
		
		let shift = fileEnd > nextStart
		
		if shift {
			
			for i in 0 ..< self.numberOfEntries {
				self.shiftUpFileWithIndex(index: i)
			}
			
			
			let end = dataEnd
			let lastIndex = self.numberOfEntries - 1
			var lastFileEnd = self.startOffsetForFile(lastIndex) + self.sizeForFile(index: lastIndex)
			while lastFileEnd % 16 != 0 {
				lastFileEnd += 1
			}
			let excess = end - lastFileEnd - 0xc
			if excess > 0x100 {
				self.data.deleteBytes(start: lastFileEnd, count: (excess - 0x100))
				self.setFilesize(self.data.length)
			}
			
			fileEnd = startOffsetForFile(index) + newFile.fileSize
			var expansionRequired = 0
			let newNextStart = index < self.numberOfEntries - 1 ? startOffsetForFile(index + 1) : dataEnd
			
			if fileEnd > newNextStart {
				expansionRequired = fileEnd - newNextStart + 0x80
				while expansionRequired % 16 != 0 {
					expansionRequired += 1
				}
			}
			
			if expansionRequired > 0 {
				// add a little extra free space so future size increases can be accounted for if they are small.
				if index < self.numberOfEntries - 1 {
					for i in index + 1 ..< self.numberOfEntries {
						self.setStartOffsetForFile(index: i, newStart: startOffsetForFile(i) + expansionRequired)
					}
				}
				self.data.insertRepeatedByte(byte: 0, count: expansionRequired, atOffset: newNextStart)
				self.setFilesize(self.data.length)
				
			}
		}
		
		self.replaceFileWithIndex(index, withFile: newFile, saveWhenDone: save)
	}
	
	func replaceFileWithIndex(_ index: Int, withFile newFile: XGFiles, saveWhenDone: Bool) {
		if !newFile.exists {
			printg("file doesn't exist: ", newFile.path)
			return
		}
		
		if !(index < self.numberOfEntries) {
			printg("skipping fsys import: \(newFile.fileName) to \(self.fileName)\nindex doesn't exist:", index)
			return
		}

		var unknownLZSSBytes: UInt32?
		if game == .PBR, isFileCompressed(index: index) {
			unknownLZSSBytes = getUnknownLZSSForFileWithIndex(index)
		}
		
		let fileStart = startOffsetForFile(index)
		let fileEnd = fileStart + newFile.fileSize
		
		if index < self.numberOfEntries - 1 {
			if fileEnd > startOffsetForFile(index + 1) {
				printg("file too large to replace: ", newFile.fileName, self.file.fileName)
				return
			}
		}
		
		if fileEnd > self.dataEnd {
			printg("file too large to replace: ", newFile.fileName, self.file.fileName)
			return
		}
		
		eraseDataForFile(index: index)
		
		let fileSize = UInt32(newFile.data!.length)
		let newData = newFile.data!
		
		let detailsStart = startOffsetForFileDetails(index)
		data.replaceWordAtOffset(detailsStart + kCompressedSizeOffset, withBytes: fileSize)
		
		let lzssCheck = newData.getWordAtOffset(0) == kLZSSbytes
		if lzssCheck {
			if let unknown = unknownLZSSBytes {
				newData.replaceWordAtOffset(kLZSSUnkownOffset, withBytes: unknown)
			}
			data.replaceWordAtOffset(detailsStart + kUncompressedSizeOffset, withBytes: newData.getWordAtOffset(kLZSSUncompressedSizeOffset))
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
		self.addFile(file.data!, fileType: fileType, compress: compress, shortID: shortID)
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
			let newPointer = self.data.getWordAtOffset(detailsPointer) + UInt32(entryShift)
			self.data.replaceWordAtOffset(detailsPointer, withBytes: newPointer)
		}
		
		let entryStart = self.firstEntryDetailOffset + (0x70 * self.numberOfEntries)
		self.data.insertRepeatedByte(byte: 0, count: 0x70, atOffset: entryStart)
		bytesAdded += 0x70
		
		let fileStartShift = bytesAdded
		let newFirstFileOffset = self.data.getWordAtOffset(kFirstFileOffset) + UInt32(fileStartShift)
		self.data.replaceWordAtOffset(kFirstFileOffset, withBytes: newFirstFileOffset)
		
		
		var fileStart = self.startOffsetForFile(self.numberOfEntries - 1) + sizeForFile(index: self.numberOfEntries - 1) + bytesAdded
		
		while (fileStart % 16) != 0 {
			fileStart += 1
		}
		
		
		for i in 0 ..< self.numberOfEntries {
			
			let dets = self.firstEntryDetailOffset + (i * 0x70)
			let fileStart = self.data.getWordAtOffset(dets + kFileStartPointerOffset) + UInt32(fileStartShift)
			let nameStart = self.data.getWordAtOffset(dets + kFileDetailsFilenameOffset) + UInt32(filenamesShift)
			self.data.replaceWordAtOffset(dets + kFileStartPointerOffset, withBytes: fileStart)
			self.data.replaceWordAtOffset(dets + kFileDetailsFilenameOffset, withBytes: nameStart)
			
			if self.usesFileExtensions {
				let fullnameStart = self.data.getWordAtOffset(dets + kFileDetailsFullFilenameOffset) + UInt32(fullfilenamesShift)
				self.data.replaceWordAtOffset(dets + kFileDetailsFullFilenameOffset, withBytes: fullnameStart)
			}
			
		}
		
		let data = compress ? XGLZSS.encode(data: fileData) : fileData
		
		var newFileSize = data.length
		while newFileSize % 16 != 0 {
			self.data.insertByte(byte: 0, atOffset: fileStart)
			newFileSize += 1
		}
		
		self.data.insertData(data: data, atOffset: fileStart)
		
		self.data.replaceWordAtOffset(fileDetailsPointerOffset, withBytes: UInt32(entryStart))
		self.data.replaceWordAtOffset(kFSYSFileSizeOffset, withBytes: UInt32(self.data.length))
		self.data.replaceWordAtOffset(kNumberOfEntriesOffset, withBytes: UInt32(self.numberOfEntries + 1))
		
		let isCompressed = data.getWordAtOffset(0) == kLZSSbytes
		let uncompressedSize = isCompressed ? data.getWordAtOffset(kLZSSUncompressedSizeOffset) : UInt32(data.length)
		let compressedSize = isCompressed ? data.getWordAtOffset(kLZSSCompressedSizeOffset) : UInt32(data.length)
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
		self.data.replaceWordAtOffset(0x1c, withBytes: self.data.getWordAtOffset(0x48))
		
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
	
	@objc func shiftDownFileWithIndex(index: Int, byOffset by: Int) {
		// used to push a file closer to the file above it and create more space for other files
		if !(index < self.numberOfEntries && index > 0) { return }
		
		if by % 16 != 0 {
			printg("Attempted to shift \(self.fileName), file '\(self.fileNames[index])' by \(by) bytes but the offset must be a multiple of 16.")
			return
		}
		
		let start = startOffsetForFile(index) + by
		let size = sizeForFile(index: index)
		
		let nextStart = index == self.numberOfEntries - 1 ? self.dataEnd : startOffsetForFile(index + 1)
		
		if start + 0x10 + size < nextStart {
			self.moveFile(index: index, toOffset: start)
		}
		
		
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
	
	var numberedFileNames: [String] {
		var data = [XGMutableData]()
		for i in 0 ..< self.numberOfEntries {
			data.append(extractDataForFileWithIndex(index: i)!)
		}
		
		let filenames = data.map { (d) -> String in
			let name = d.file.fileName
			return name
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
		var pbrCounter = 0
		for i in 0 ..< filenames.count {
			var addendum = ""
			if game == .PBR && !self.usesFileExtensions {
				addendum = "\(pbrCounter)"
				pbrCounter += 1
			} else {
				if repeats[i] > 0 {
					addendum = "\(repeats[i])"
				}
			}
			
			if addendum.length > 0 {
				while addendum.length < 4 {
					addendum = "0" + addendum
				}
				addendum = " " + addendum
			}
			
			updatedNames.append(filenames[i].removeFileExtensions() + addendum + filenames[i].fileExtensions)
		}
		return updatedNames
	}
	
	func extractFilesToFolder(folder: XGFolders, decode: Bool) {
		
		var data = [XGMutableData]()
		for i in 0 ..< self.numberOfEntries {
			data.append(extractDataForFileWithIndex(index: i)!)
		}
		
		let filenames = data.map { $0.file.fileName }
		
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
			}
			
			if addendum.length > 0 {
				while addendum.length < 4 {
					addendum = "0" + addendum
				}
				addendum = " " + addendum
			}
			
			updatedNames.append(filenames[i].removeFileExtensions() + addendum + filenames[i].fileExtensions)
		}
		
		// save all files before decoding as some require each other
		for i in 0 ..< data.count {
			data[i].file = .nameAndFolder(updatedNames[i], folder)
			
			if !data[i].file.exists {
				if settings.verbose {
					printg("extracting file: \(data[i].file.fileName)")
				}
				data[i].save()
			}
		}
		
		// decode certain file types
		if decode {
			for i in 0 ..< data.count {
				if settings.verbose {
					printg("decoding file: \(data[i].file.fileName)")
				}

				if data[i].file.fileType == .pkx {
					let file = data[i].file
					let dat = XGUtility.exportDatFromPKX(pkx: data[i])
					dat.file = .nameAndFolder(file.fileName.replacingOccurrences(of: ".pkx", with: ".dat"), file.folder)
					dat.save()
				}

				if data[i].file.fileType == .msg {
					let file = data[i].file
					let msg = XGStringTable(file: file, startOffset: 0, fileSize: file.fileSize)
					msg.writeJSON(to: .nameAndFolder(file.fileName + ".json", file.folder))
				}
				
				if data[i].file.fileType == .gsw {
					let gsw = XGGSWTextures(data: data[i])
					let textures = gsw.extractTextureData()
					for texture in textures {
						texture.save()
						
						let imageFilename = texture.file.fileName.removeFileExtensions() + ".png"
						let imageFile = XGFiles.nameAndFolder(imageFilename, folder)
						#if ENV_OSX
						texture.file.texture.saveImage(file: imageFile)
						#endif
					}
				}
				
				if data[i].file.fileType == .gtx || data[i].file.fileType == .atx {
					#if ENV_OSX
					data[i].file.texture.saveImage(file: .nameAndFolder(updatedNames[i] + ".png", folder))
					#endif
				}
				
				if data[i].file.fileType == .msg {
					data[i].file.stringTable.writeJSON(to: .nameAndFolder(updatedNames[i] + ".json", folder))
				}
				
				if data[i].file.fileType == .scd && game != .Colosseum {
					data[i].file.writeScriptData()
				}
			}
		}
	}
	
}























