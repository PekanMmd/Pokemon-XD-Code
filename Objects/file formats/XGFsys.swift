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

let kLZSSbytes: UInt32				= 0x4C5A5353
let kTCODbytes: UInt32				= 0x54434F44
let kFSYSbytes: UInt32				= 0x46535953
let kUSbytes						= 0x5553
let kJPbytes						= 0x4A50

final class XGFsys : NSObject {
	
	var file: XGFiles!
	var data: XGMutableData!

	private(set) var filenames: [String]!

	var files: [XGFiles] {
		return filenames.map { XGFiles.nameAndFolder($0, file.folder) }
	}
	
	init(file: XGFiles) {
		super.init()
		
		self.file = file
		self.data = file.data
		setupFilenames()
	}
	
	init(data: XGMutableData) {
		super.init()
		
		self.data = data
		self.file = data.file
		setupFilenames()
	}

	private func setupFilenames() {
		var names = usesFileExtensions ? rawFileNames : rawFullFileNames

		for i in 0 ..< names.count {
			let name = names[i]
			if name == "(null)" {
				// In non JP versions of PBR it is common for filenames to be scrubbed
				// and replaced with (null)
				// This names those files the same as the fsys file with an index appended
				// just to differentiate between the filenames
				var addendum = "\(i)"
				while addendum.length < 4 {
					addendum = "0" + addendum
				}
				addendum = "_" + addendum
				names[i] = fileName.removeFileExtensions() + addendum
			} else {
				// some files are named things like "common_rel" instead of "common.rel"
				// this checks to see if the end of the filename is a file extension preceded by _
				// and if so will replace the _ with .
				let underscoreReplaced = name.replacingOccurrences(of: "_", with: ".")
				let replacedExtension = XGFiles.nameAndFolder(underscoreReplaced, .Documents).fileExtension
				if let filetype = XGFileTypes.fileTypeForExtension(replacedExtension) {
					let dotExtension = filetype.fileExtension
					let underscoreExtension = dotExtension.replacingOccurrences(of: ".", with: "_")
					names[i] = name.replacingOccurrences(of: underscoreExtension, with: dotExtension)
				}
			}

			// Each file has an identifier which has a byte indicating the file type.
			// If the name doesn't already have a file extension then add the extension for its type.
			let updatedName = names[i]
			if updatedName.fileExtensions == "" {
				names[i] = updatedName + fileTypeForFile(index: i).fileExtension
			}
		}

		// If any files have duplicate names, append an index number
		for mainIndex in 0 ..< names.count - 1 {
			let currentFilename = names[mainIndex]
			for subIndex in (mainIndex + 1) ..< names.count {
				let comparisonFilename = names[subIndex]
				if comparisonFilename == currentFilename {
					names[subIndex] = currentFilename.removeFileExtensions() + " (\(subIndex))" + currentFilename.fileExtensions
				}
			}
		}

		filenames = names
	}
	
	override var description: String {
		var s = "\(self.fileName) - contains \(self.numberOfEntries) files\n"
		for i in 0 ..< self.numberOfEntries {
			let offset = String(format: "0x%x", self.startOffsetForFile(i))
			let filename = i < filenames.count ? filenames[i] : "-"
			s += "\(i):\t\(offset)\t\t\(filename)\n"
		}
		return s
	}
	
	var fileName: String {
		return file.fileName
	}
	
	var groupID: Int {
		return data.get4BytesAtOffset(kFSYSGroupIDOffset)
	}

	func setGroupID(_ id: Int) {
		data.replace4BytesAtOffset(kFSYSGroupIDOffset, withBytes: id)
	}
	
	// some fsys files have 2 filenames per entry with the second containing the file extension
	var usesFileExtensions: Bool {
		return data.getByteAtOffset(0x13) == 0x1
	}
	
	var numberOfEntries: Int {
		return Int(data.getWordAtOffset(kNumberOfEntriesOffset))
	}

	func setNumberOfEntries(_ newEntries: Int) {
		data.replaceWordAtOffset(kNumberOfEntriesOffset, withBytes: UInt32(newEntries))
	}
	
	func setFilesize(_ newSize: Int) {
		data.replaceWordAtOffset(kFSYSFileSizeOffset, withBytes: UInt32(newSize))
	}
	
	func getStringAtOffset(_ offset: Int) -> String {
		
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
	
	func fileNameForFileWithIndex(index: Int) -> String? {
		return index < filenames.count ? filenames[index] : nil
	}

	func fileTypeForFileWithIndex(index: Int) -> XGFileTypes? {
		return index < files.count ? files[index].fileType : nil
	}
	
	var firstFileNameOffset: Int {
		return Int(data.getWordAtOffset(kFirstFileNamePointerOffset))
	}
	
	func setFirstFilenameOffset(_ newOffset: Int) {
		data.replaceWordAtOffset(kFirstFileNamePointerOffset, withBytes: UInt32(newOffset))
	}

	private var rawFileNames: [String] {
		return (0 ..< numberOfEntries).map { (index) -> String in
			let offset = data.get4BytesAtOffset(startOffsetForFileDetails(index) + kFileDetailsFilenameOffset)
			return getStringAtOffset(offset)
		}
	}

	private var rawFullFileNames: [String] {
		guard usesFileExtensions else { return [] }
		return (0 ..< numberOfEntries).map { (index) -> String in
			let offset = data.get4BytesAtOffset(startOffsetForFileDetails(index) + kFileDetailsFullFilenameOffset)
			return getStringAtOffset(offset)
		}
	}

	var identifiers: [Int] {
		return (0 ..< numberOfEntries).map {identifierForFile(index: $0)}
	}
	
	func indexForIdentifier(identifier: Int) -> Int? {
		return identifiers.firstIndex(where: {$0 == identifier})
	}
	
	func indexForFileType(type: XGFileTypes) -> Int? {
		return files.firstIndex(where: {$0.fileType == type})
	}
	
	var firstEntryDetailOffset: Int {
		return data.get4BytesAtOffset(kFirstFileDetailsPointerOffset)
	}
	
	func setFirstEntryDetailOffset(_ newOffset: Int) {
		data.replaceWordAtOffset(kFirstFileDetailsPointerOffset, withBytes: UInt32(newOffset))
	}
	
	var dataEnd: Int {
		return data.length - 0x4
	}
	
	func startOffsetForFileDetails(_ index: Int) -> Int {
		return data.get4BytesAtOffset(kFirstFileDetailsPointerOffset + (index * 4))
		
	}
	
	func startOffsetForFile(_ index: Int) -> Int {
		let start = startOffsetForFileDetails(index) + kFileStartPointerOffset
		return data.get4BytesAtOffset(start)
	}
	
	func setStartOffsetForFile(index: Int, newStart: Int) {
		let start = startOffsetForFileDetails(index) + kFileStartPointerOffset
		data.replaceWordAtOffset(start, withBytes: UInt32(newStart))
	}
	
	func sizeForFile(index: Int) -> Int {
		let start = startOffsetForFileDetails(index) + kCompressedSizeOffset
		return data.get4BytesAtOffset(start)
	}
	
	func setSizeForFile(index: Int, newSize: Int) {
		let start = startOffsetForFileDetails(index) + kCompressedSizeOffset
		data.replaceWordAtOffset(start, withBytes: UInt32(newSize))
	}
	
	func uncompressedSizeForFile(index: Int) -> Int {
		let start = startOffsetForFileDetails(index) + kUncompressedSizeOffset
		return data.get4BytesAtOffset(start)
	}
	
	func setUncompressedSizeForFile(index: Int, newSize: Int) {
		let start = startOffsetForFileDetails(index) + kUncompressedSizeOffset
		data.replaceWordAtOffset(start, withBytes: UInt32(newSize))
	}
	
	func identifierForFile(index: Int) -> Int {
		let start = startOffsetForFileDetails(index) + kFileIdentifierOffset
		return data.get4BytesAtOffset(start)
	}
	
	private func fileTypeForFile(index: Int) -> XGFileTypes {
		if index >= numberOfEntries || index < 0 {
			return .unknown
		}
		return XGFileTypes(rawValue: (identifierForFile(index: index) & 0xFF00) >> 8) ?? .unknown
	}

	func fileWithIndex(_ index: Int) -> XGFiles? {
		guard index < numberOfEntries else { return nil }
		return files[index]
	}
	
	func dataForFileWithName(name: String) -> XGMutableData? {
		let index = self.indexForFile(filename: name)
		if index == nil {
			printg("file doesn't exist: ", name)
			return nil
		}
		return dataForFileWithIndex(index: index!)
	}
	
	func decompressedDataForFileWithName(name: String) -> XGMutableData? {
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

	func dataForFileWithFiletype(type: XGFileTypes) -> XGMutableData? {
		if let index = indexForFileType(type: type) {
			if index < 0 || index > self.numberOfEntries {
				if settings.verbose {
					printg(self.fileName + " - file type: " + type.fileExtension + " doesn't exists.")
				}
				return nil
			}
			return dataForFileWithIndex(index: index)
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
	
	func dataForFileWithIndex(index: Int) -> XGMutableData? {

		guard index < numberOfEntries else { return nil }
		
		let start = startOffsetForFile(index)
		let length = sizeForFile(index: index)
		
		var filename = fileNameForFileWithIndex(index: index)!
		if isFileCompressed(index: index) {
			filename = filename + XGFileTypes.lzss.fileExtension
		}
		
		let fileData = data.getCharStreamFromOffset(start, length: length)
		
		return XGMutableData(byteStream: fileData, file: .nameAndFolder(filename, .Documents))
	}
	
	func decompressedDataForFileWithIndex(index: Int) -> XGMutableData? {

		guard index < numberOfEntries else { return nil }
		
		let fileData = dataForFileWithIndex(index: index)!
		//let decompressedSize = fileData.getWordAtOffset(kLZSSUncompressedSizeOffset)
		fileData.deleteBytes(start: 0, count: kSizeOfLZSSHeader)

		let decompressedData = XGLZSS.decode(data: fileData)
		
		let filename = fileNameForFileWithIndex(index: index)!
		decompressedData.file = .nameAndFolder(filename, .Documents)
		
		return decompressedData
		
	}
	
	func isFileCompressed(index: Int) -> Bool {
		return data.getWordAtOffset(startOffsetForFile(index)) == kLZSSbytes
	}

	func getUnknownLZSSForFileWithIndex(_ index: Int) -> UInt32 {
		return data.getWordAtOffset(startOffsetForFile(index) + kLZSSUnkownOffset)
	}

	/// checks if the file is compressed or not and returns the appropriate data
	func extractDataForFileWithIndex(index: Int) -> XGMutableData? {
		guard index < numberOfEntries else {
			return nil
		}
		
		return isFileCompressed(index: index) ? decompressedDataForFileWithIndex(index: index) : dataForFileWithIndex(index: index)
	}

	/// checks if the file is compressed or not and returns the appropriate data
	func extractDataForFile(_ file: XGFiles) -> XGMutableData? {
		guard let index = indexForFile(file) else { return nil }
		let data = extractDataForFileWithIndex(index: index)
		data?.file = file
		return data
	}

	func extractDataForFile(filename: String) -> XGMutableData? {
		guard let index = indexForFile(filename: filename) else { return nil }
		let data = extractDataForFileWithIndex(index: index)
		return data
	}

	func indexForFile(_ file: XGFiles) -> Int? {
		return indexForFile(filename: file.fileName)
	}
	
	func indexForFile(filename: String) -> Int? {
		return filenames.firstIndex(of: filename)
	}
	
	func replaceFileWithName(name: String, withFile newFile: XGFiles, save: Bool = true) {

		guard newFile.exists else {
			printg("file doesn't exist:", newFile.path)
			return
		}

		guard let index = indexForFile(filename: name) else {
			printg("file with name '", name ,"' doesn't exist in ", file.path)
			return
		}

		if isFileCompressed(index: index) && (newFile.fileType != .lzss) {
			shiftAndReplaceFileWithIndexEfficiently(index, withFile: newFile.compress(), save: save)
		} else {
			shiftAndReplaceFileWithIndexEfficiently(index, withFile: newFile, save: save)
		}
	}
	
	func replaceFile(file: XGFiles, save: Bool = true) {
		replaceFileWithName(name: file.fileName, withFile: file, save: save)
	}
	
	func shiftAndReplaceFileWithIndexEfficiently(_ index: Int, withFile newFile: XGFiles, save: Bool) {
		guard index < self.numberOfEntries else {
			printg("skipping fsys import: \(newFile.fileName) to \(self.fileName)\nindex doesn't exist:", index)
			return
		}
		
		var newFile = newFile
		guard let newFileData = newFile.data, newFileData.length > 3 else {
			printg("skipping fsys import: \(newFile.fileName) to \(self.fileName)\nInsufficient data.")
			return
		}

		if isFileCompressed(index: index) && (newFileData.getWordAtOffset(0) != kLZSSbytes) {
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
				// add a little extra free space so future size increases can be accounted for if they are small.
				expansionRequired = fileEnd - newNextStart + 0x80
				while expansionRequired % 16 != 0 {
					expansionRequired += 1
				}
			}
			
			if expansionRequired > 0 {
				if index < numberOfEntries - 1 {
					for i in index + 1 ..< numberOfEntries {
						setStartOffsetForFile(index: i, newStart: startOffsetForFile(i) + expansionRequired)
					}
				}
				data.insertRepeatedByte(byte: 0, count: expansionRequired, atOffset: newNextStart)
				setFilesize(data.length)
			}
		}
		
		replaceFileWithIndex(index, withFile: newFile, saveWhenDone: save)
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
		setSizeForFile(index: index, newSize: 4)
		data.replaceBytesFromOffset(startOffsetForFile(index), withByteStream: [0xDE, 0x1E, 0x7E, 0xD0])
	}
	
	func increaseDataLength(by bytes: Int) {
		var expansionRequired = bytes + 0x14
		while (expansionRequired % 16) != 0 { // byte alignment is required by the iso
			expansionRequired += 1
		}
		
		self.data.appendBytes(.init(repeating: 0, count: expansionRequired))
		self.setFilesize(self.data.length)
		self.data.replaceWordAtOffset(dataEnd, withBytes: kFSYSbytes)
	}
	
	func addFile(_ file: XGFiles, fileType: XGFileTypes, compress: Bool, shortID: Int) {
		guard let data = file.data else { return }
		self.addFile(data, fileType: fileType, compress: compress, shortID: shortID)
	}
	
	func addFile(_ fileData: XGMutableData, fileType: XGFileTypes, compress: Bool, shortID: Int) {
		// doesn't considered fsys with alternate filename data. might change things, might not.
		
		let file = fileData.file
		let filename = file.fileName.removeFileExtensions()
		
		var bytesAdded = 0
		let names = rawFileNames
		let fullnames = rawFullFileNames
		
		let fileDetailsPointerOffset = kFirstFileDetailsPointerOffset + (4 * numberOfEntries)
		if numberOfEntries % 4 == 0 {
			data.insertRepeatedByte(byte: 0, count: 16, atOffset: fileDetailsPointerOffset)
			bytesAdded += 16
		}
		
		let filenamesShift = bytesAdded
		let fullfilenamesShift = filenamesShift + filename.count + 1
		setFirstFilenameOffset(firstFileNameOffset + bytesAdded)
		
		let allnames = usesFileExtensions ? names + fullnames : names
		
		var filenamesSize = 0
		for file in allnames {
			filenamesSize += file.count + 1
		}
		var padding = 16 - (filenamesSize % 16)
		padding = padding == 16 ? 0 : padding
		
		var extraNameBytes = usesFileExtensions ? file.fileName.count + filename.count + 2 : filename.count + 1
		if extraNameBytes <= padding {
			extraNameBytes = 0
		} else {
			extraNameBytes -= padding
		}
		while (filenamesSize + padding + extraNameBytes) % 16 != 0 {
			extraNameBytes += 1
		}
		
		bytesAdded += extraNameBytes
		data.insertRepeatedByte(byte: 0, count: extraNameBytes, atOffset: firstFileNameOffset)
		
		var currentOffset = firstFileNameOffset
		for name in names + [filename] {
			data.replaceBytesFromOffset(currentOffset, withByteStream: name.unicodeRepresentation)
			currentOffset += name.unicodeRepresentation.count
		}
		
		let filenameStart = currentOffset - filename.unicodeRepresentation.count
		
		if usesFileExtensions {
			for name in fullnames + [file.fileName] {
				data.replaceBytesFromOffset(currentOffset, withByteStream: name.unicodeRepresentation)
				currentOffset += name.unicodeRepresentation.count
			}
		}

		let fullFilenameStart = usesFileExtensions ? currentOffset - file.fileName.unicodeRepresentation.count : 0
		
		while currentOffset % 16 != 0 {
			data.replaceByteAtOffset(currentOffset, withByte: 0)
			currentOffset += 1
		}
		
		let entryShift = bytesAdded
		
		for i in 0 ..< numberOfEntries {
			let detailsPointer = kFirstFileDetailsPointerOffset + (4 * i)
			let newPointer = data.getWordAtOffset(detailsPointer) + UInt32(entryShift)
			data.replaceWordAtOffset(detailsPointer, withBytes: newPointer)
		}
		
		let entryStart = firstEntryDetailOffset + (kSizeOfArchiveEntry * numberOfEntries)
		data.insertRepeatedByte(byte: 0, count: kSizeOfArchiveEntry, atOffset: entryStart)
		bytesAdded += kSizeOfArchiveEntry
		
		let fileStartShift = bytesAdded
		let newFirstFileOffset = data.getWordAtOffset(kFirstFileOffset) + UInt32(fileStartShift)
		data.replaceWordAtOffset(kFirstFileOffset, withBytes: newFirstFileOffset)
		
		var fileStart = startOffsetForFile(numberOfEntries - 1) + sizeForFile(index: numberOfEntries - 1) + bytesAdded
		
		while (fileStart % 16) != 0 {
			fileStart += 1
		}
		
		
		for i in 0 ..< numberOfEntries {
			
			let dets = firstEntryDetailOffset + (i * kSizeOfArchiveEntry)
			let fileStart = data.getWordAtOffset(dets + kFileStartPointerOffset) + UInt32(fileStartShift)
			let nameStart = data.getWordAtOffset(dets + kFileDetailsFilenameOffset) + UInt32(filenamesShift)
			data.replaceWordAtOffset(dets + kFileStartPointerOffset, withBytes: fileStart)
			data.replaceWordAtOffset(dets + kFileDetailsFilenameOffset, withBytes: nameStart)
			
			if usesFileExtensions {
				let fullnameStart = data.getWordAtOffset(dets + kFileDetailsFullFilenameOffset) + UInt32(fullfilenamesShift)
				data.replaceWordAtOffset(dets + kFileDetailsFullFilenameOffset, withBytes: fullnameStart)
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
		self.data.replaceWordAtOffset(kNumberOfEntriesOffset, withBytes: UInt32(numberOfEntries + 1))
		
		let isCompressed = data.getWordAtOffset(0) == kLZSSbytes
		let uncompressedSize = isCompressed ? data.getWordAtOffset(kLZSSUncompressedSizeOffset) : UInt32(data.length)
		let compressedSize = isCompressed ? data.getWordAtOffset(kLZSSCompressedSizeOffset) : UInt32(data.length)
		self.data.replaceWordAtOffset(entryStart + kUncompressedSizeOffset, withBytes: uncompressedSize)
		self.data.replaceWordAtOffset(entryStart + kCompressedSizeOffset, withBytes: compressedSize)
		self.data.replace2BytesAtOffset(entryStart + kFileIdentifierOffset, withBytes: shortID)
		self.data.replaceByteAtOffset(entryStart + kFileFormatOffset, withByte: fileType.identifier)
		self.data.replaceWordAtOffset(entryStart + kFileStartPointerOffset, withBytes: UInt32(fileStart))
		self.data.replaceWordAtOffset(entryStart + 0xc, withBytes: 0x80000000)
		self.data.replaceWordAtOffset(entryStart + kFileFormatIndexOffset, withBytes: UInt32(fileType.index))
		self.data.replaceWordAtOffset(entryStart + kFileDetailsFilenameOffset, withBytes: UInt32(filenameStart))
		if usesFileExtensions {
			self.data.replaceWordAtOffset(entryStart + kFileDetailsFullFilenameOffset, withBytes: UInt32(fullFilenameStart))
		}
		self.data.replaceWordAtOffset(0x1c, withBytes: self.data.getWordAtOffset(0x48))
		
	}
	
	private func shiftUpFileWithIndex(index: Int) {
		// used to push a file closer to the file above it and create more space for other files
		guard index < self.numberOfEntries else { return }
		
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
	
	private func shiftDownFileWithIndex(index: Int) {
		// used to push a file closer to the file above it and create more space for other files
		guard index < self.numberOfEntries else { return }
		
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
	
	private func shiftDownFileWithIndex(index: Int, byOffset by: Int) {
		// used to push a file closer to the file above it and create more space for other files
		if !(index < self.numberOfEntries && index > 0) { return }
		
		guard by % 16 == 0 else {
			printg("Attempted to shift \(fileName), file '\(index)' by \(by) bytes but the offset must be a multiple of 16.")
			return
		}
		
		let start = startOffsetForFile(index) + by
		let size = sizeForFile(index: index)
		
		let nextStart = index == self.numberOfEntries - 1 ? self.dataEnd : startOffsetForFile(index + 1)
		
		if start + 0x10 + size < nextStart {
			self.moveFile(index: index, toOffset: start)
		}
	}
	
	func moveFile(index: Int, toOffset startOffset: Int) {
		let bytes = self.dataForFileWithIndex(index: index)!.byteStream
		
		self.eraseData(start: startOffsetForFile(index), length: sizeForFile(index: index))
		self.setStartOffsetForFile(index: index, newStart: startOffset)
		
		data.replaceBytesFromOffset(startOffset, withByteStream: bytes)
	}
	
	func save() {
		data.save()
	}
	
	func extractFilesToFolder(folder: XGFolders, decode: Bool, overwrite: Bool = false) {
		
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
			
			if !data[i].file.exists || overwrite {
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
					let datFile = XGFiles.nameAndFolder(file.fileName + XGFileTypes.dat.fileExtension, file.folder)
					if !datFile.exists || overwrite {
						let dat = XGUtility.exportDatFromPKX(pkx: data[i])
						dat.file = datFile
						dat.save()
					}
				}

				if data[i].file.fileType == .msg {
					let file = data[i].file
					let msgFile = XGFiles.nameAndFolder(file.fileName + XGFileTypes.json.fileExtension, file.folder)
					if !msgFile.exists || overwrite {
						let msg = XGStringTable(file: file, startOffset: 0, fileSize: file.fileSize)
						msg.writeJSON(to: msgFile)
					}
				}

				for texture in data[i].file.textures {
					if !texture.file.exists || overwrite {
						texture.save()
					}
					let pngFile = XGFiles.nameAndFolder(texture.file.fileName + XGFileTypes.png.fileExtension, file.folder)
					if !pngFile.exists || overwrite {
						texture.writePNGData(toFile: pngFile)
					}
				}
				
				if data[i].file.fileType == .scd && game != .Colosseum {
					let xdsFile = XGFiles.nameAndFolder(data[i].file.fileName + XGFileTypes.xds.fileExtension, data[i].file.folder)
					if !xdsFile.exists || overwrite {
						data[i].file.writeScriptData()
					}
				}

				if data[i].file.fileType == .thh {
					let thpFile = XGFiles.nameAndFolder(data[i].file.fileName.removeFileExtensions() + XGFileTypes.thp.fileExtension, data[i].file.folder)
					if (!thpFile.exists || overwrite), let thpData = data.first(where: { $0.file.fileType == .thd && $0.file.fileName.removeFileExtensions() == data[i].file.fileName.removeFileExtensions() }) {
						let thpHeader = data[i]

						let thp = XGTHP(header: thpHeader, body: thpData)
						thp.thpData.save()
					}
				}
			}
		}
	}
	
}

extension XGFsys: XGEnumerable {
	var enumerableName: String {
		return path
	}

	var enumerableValue: String? {
		return nil
	}

	static var enumerableClassName: String {
		return "Fsys"
	}

	static var allValues: [XGFsys] {
		return ISO.allFileNames
			.filter{$0.fileExtensions == XGFileTypes.fsys.fileExtension}
			.map{XGFiles.fsys($0.removeFileExtensions())}
			.filter{$0.exists}
			.map{$0.fsysData}
	}
}





















