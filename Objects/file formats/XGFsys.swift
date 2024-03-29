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
let kFSYSDetailsPointersListOffset  = 0x40
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

final class XGFsys {
	
	var file: XGFiles!
	var data: XGMutableData!

	private(set) var filenames: [String]!

	var files: [XGFiles] {
		return filenames.map { XGFiles.nameAndFolder($0, file.folder) }
	}

	var fileDetailsOffsets: [Int] {
		let firstPointerOffset = data.get4BytesAtOffset(kFSYSDetailsPointersListOffset)
		return (0 ..< numberOfEntries).map { (index) -> Int in
			let offset = firstPointerOffset + (index * 4)
			return data.get4BytesAtOffset(offset)
		}
	}
	
	init(file: XGFiles) {
		self.file = file
		self.data = file.data
		setupFilenames()
	}
	
	init(data: XGMutableData) {
		self.data = data
		self.file = data.file
		setupFilenames()
	}

	private func setupFilenames() {
		var names = usesFileExtensions ? rawFullFileNames : rawFileNames

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
				addendum = " " + addendum
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
			var updatedName = names[i]
			if updatedName.fileExtensions == "" {
				updatedName = updatedName + fileTypeForFile(index: i).fileExtension
				names[i] = updatedName
			}

			if updatedName.fileExtensions.lowercased() != updatedName.fileExtensions {
				updatedName = updatedName.replacingOccurrences(of: updatedName.fileExtensions, with: updatedName.fileExtensions.lowercased())
				names[i] = updatedName
			}

			if game == .PBR {
				let updatedName = names[i]
				if updatedName.contains("mes_common"), updatedName.fileExtensions == ".bin" {
					if let data = extractDataForFileWithIndex(index: i), data.length > 4 {
						if data.getWordAtOffset(0) == 0x4D455347 { // MESG magic bytes
							names[i] = updatedName.replacingOccurrences(of: ".bin", with: XGFileTypes.msg.fileExtension)
						}
					}
				}
			}

		}

		// If any files have duplicate names, append an index number
		let hasDuplicates = Array(Set(names)).count != names.count
		if names.count > 0, hasDuplicates {
			for mainIndex in 0 ..< names.count - 1 {
				let currentFilename = names[mainIndex]
				for subIndex in (mainIndex + 1) ..< names.count {
					let comparisonFilename = names[subIndex]
					if comparisonFilename == currentFilename {
						names[subIndex] = currentFilename.removeFileExtensions() + " (\(subIndex))" + currentFilename.fileExtensions
					}
				}
			}
		}

		filenames = names
	}
	
	var description: String {
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
		return data.get4BytesAtOffset(kNumberOfEntriesOffset)
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
		guard filenames != nil else { return nil }
		return index < filenames.count ? filenames[index] : nil
	}

	func fileNameForFileWithIdentifier(_ identifier: Int) -> String? {
		guard let index = indexForIdentifier(identifier: identifier) else { return nil }
		return fileNameForFileWithIndex(index: index)
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
		// .rdat models use the last byte as the animation index so we ignore it here
		// just to compare the file identifier itself
		return identifiers.firstIndex(where: { ($0 & 0xFFFFFF00) == (identifier & 0xFFFFFF00)})
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

	func setIdentifier(_ identifier: Int, fileType: XGFileTypes, forFileWithIndex index: Int) {
		let start = startOffsetForFileDetails(index) + kFileIdentifierOffset
		data.replace2BytesAtOffset(start, withBytes: identifier)
		data.replaceByteAtOffset(start + 2, withByte: fileType.rawValue)
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
				if XGSettings.current.verbose {
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
				if XGSettings.current.verbose {
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
		
		var filename = fileNameForFileWithIndex(index: index) ?? "none.bin" // Used when file is required while loading fsys
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
		
		let filename = fileNameForFileWithIndex(index: index) ?? "none.bin"
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
			shiftAndReplaceFileWithIndex(index, withFile: newFile.compress(), save: save)
		} else {
			shiftAndReplaceFileWithIndex(index, withFile: newFile, save: save)
		}
	}
	
	func replaceFile(file: XGFiles, save: Bool = true) {
		replaceFileWithName(name: file.fileName, withFile: file, save: save)
	}
	
	func shiftAndReplaceFileWithIndex(_ index: Int, withFile newFile: XGFiles, save: Bool) {
		guard index < self.numberOfEntries else {
			printg("skipping fsys import: \(newFile.fileName) to \(self.fileName)\nindex doesn't exist:", index)
			return
		}
		
		guard let newFileData = newFile.data, newFileData.length > 3 else {
			printg("skipping fsys import: \(newFile.fileName) to \(self.fileName)\nInsufficient data.")
			return
		}
		
		shiftAndReplaceFileWithIndex(index, withData: newFileData, save: save)
	}

	func shiftAndReplaceFileWithIndex(_ index: Int, withData newData: XGMutableData, save: Bool) {
		var newFileData = newData
		if isFileCompressed(index: index) && (newFileData.getWordAtOffset(0) != kLZSSbytes) {
			newFileData = XGLZSS.encode(data: newFileData)
		}
		
		var fileEnd = startOffsetForFile(index) + newFileData.length
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
			
			fileEnd = startOffsetForFile(index) + newFileData.length
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
		
		replaceFileWithIndex(index, withData: newFileData, saveWhenDone: save)
	}
	
	func replaceFileWithIndex(_ index: Int, withFile newFile: XGFiles, saveWhenDone: Bool) {
		guard newFile.exists, let data = newFile.data else {
			printg("file doesn't exist: ", newFile.path)
			return
		}

		replaceFileWithIndex(index, withData: data, saveWhenDone: saveWhenDone)
	}

	func replaceFileWithIndex(_ index: Int, withData newData: XGMutableData, saveWhenDone: Bool, allowExpansion: Bool = false) {
		guard index < self.numberOfEntries else {
			printg("skipping fsys import: \(data.file.fileName) to \(self.file.path)\nindex doesn't exist:", index)
			return
		}

		var unknownLZSSBytes: UInt32?
		if game == .PBR, isFileCompressed(index: index) {
			unknownLZSSBytes = getUnknownLZSSForFileWithIndex(index)
		}
		
		let fileStart = startOffsetForFile(index)
		let fileEnd = fileStart + newData.length
		let nextStart = index < self.numberOfEntries - 1 ? startOffsetForFile(index + 1) : dataEnd
		
		if allowExpansion {
			var expansionRequired = 0
			if fileEnd > nextStart {
				expansionRequired = fileEnd - nextStart
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
				data.insertRepeatedByte(byte: 0, count: expansionRequired, atOffset: nextStart)
				setFilesize(data.length)
			}
		} else {
			if index < self.numberOfEntries - 1, fileEnd > startOffsetForFile(index + 1) {
				printg(file.fileName)
				printg("file too large to replace: ", newData.file.path)
				return
			}
			
			if fileEnd > self.dataEnd {
				printg(file.fileName)
				printg("file too large to replace: ", newData.file.path)
				return
			}
		}
		
		eraseDataForFile(index: index)
		
		let fileSize = UInt32(newData.length)
		
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
		guard file.exists, let data = file.data else { return }
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
	
	func extractFilesToFolder(folder: XGFolders, extract: Bool = true, decode: Bool, overwrite: Bool = false) {
		if extract {
			for i in 0 ..< self.numberOfEntries {
				if XGSettings.current.verbose, let filename = fileNameForFileWithIndex(index: i) {
					printg("extracting file: \(filename) from \(self.file.path)")
				}
				if let fileData = extractDataForFileWithIndex(index: i) {
					fileData.file = .nameAndFolder(fileData.file.fileName, folder)
					if !fileData.file.exists || overwrite {
						fileData.save()
					}
				}
			}
		}
		
		// decode certain file types
		if decode {
			for file in folder.files where filenames.contains(file.fileName)  {
				if XGSettings.current.verbose {
					printg("decoding file: \(file.fileName)")
				}

				if file.fileType == .pkx {
					let datFile = XGFiles.nameAndFolder(file.fileName + XGFileTypes.dat.fileExtension, file.folder)
					if !datFile.exists || overwrite, let pkxData = file.data {
						let dat = XGUtility.exportDatFromPKX(pkx: pkxData)
						dat.file = datFile
						dat.save()
					}
				}

				#if !GAME_PBR
				if file.fileType == .wzx {
					if let wzxData = file.data {
						let wzx = WZXModel(data: wzxData)
						for modelData in wzx.models {
							if !modelData.file.exists {
								modelData.save()
							}
						}
					}
				}
				#endif

				if file.fileType == .msg, !XGFiles.nameAndFolder(file.fileName.removeFileExtensions() + XGFileTypes.scd.fileExtension, folder).exists || game == .Colosseum {
					let msgFile = XGFiles.nameAndFolder(file.fileName + XGFileTypes.json.fileExtension, file.folder)
					if !msgFile.exists || overwrite {
						let msg = XGStringTable(file: file, startOffset: 0, fileSize: file.fileSize)
						msg.writeJSON(to: msgFile)
					}
				}

				#if !GAME_PBR
				let fileContainsScript = (file.fileType == .scd || file == .common_rel)
				#else
				let fileContainsScript = file.fileType == .scd
				#endif

				if fileContainsScript, (game != .Colosseum || XGSettings.current.enableExperimentalFeatures)  { // TODO allow colosseum scripts once less buggy
					let xdsFile = XGFiles.nameAndFolder(file.fileName + XGFileTypes.xds.fileExtension, folder)
					if !xdsFile.exists || overwrite {
						let scriptText = file.scriptData.getXDSScript()
						XGUtility.saveString(scriptText, toFile: xdsFile)
					}
				}

				#if !GAME_PBR
				if file == .common_rel || file == .tableres2 || file == .dol {
					let msgFile = XGFiles.nameAndFolder(file.fileName + XGFileTypes.json.fileExtension, file.folder)
					if !msgFile.exists {
						let table = file.stringTable
						table.writeJSON(to: msgFile)
					}
					if file == .common_rel && game == .Colosseum && region != .JP && XGSettings.current.enableExperimentalFeatures {
						let msgFile2 = XGFiles.nameAndFolder("common2.json", file.folder)
						if !msgFile2.exists {
							let table = XGStringTable.common_rel2()
							table.writeJSON(to: msgFile2)
						}
						let msgFile3 = XGFiles.nameAndFolder("common3.json", file.folder)
						if !msgFile3.exists {
							let table = XGStringTable.common_rel3()
							table.writeJSON(to: msgFile3)
						}
					}
					if file == .dol && game == .XD && region != .JP && XGSettings.current.enableExperimentalFeatures {
						let msgFile2 = XGFiles.nameAndFolder("Start2.json", file.folder)
						if !msgFile2.exists {
							let table = XGStringTable.dol2()
							table.writeJSON(to: msgFile2)
						}
						let msgFile3 = XGFiles.nameAndFolder("Start3.json", file.folder)
						if !msgFile3.exists {
							let table = XGStringTable.dol3()
							table.writeJSON(to: msgFile3)
						}
					}
				}
				#endif

				if file.fileType == .thh {
					let thpFile = XGFiles.nameAndFolder(file.fileName.removeFileExtensions() + XGFileTypes.thp.fileExtension, folder)
					if (!thpFile.exists || overwrite), let thpData = folder.files.first(where: { $0.fileType == .thd && $0.fileName.removeFileExtensions() == file.fileName.removeFileExtensions() })?.data {
						if let thpHeader = file.data {
							let thp = XGTHP(header: thpHeader, body: thpData)
							thp.thpData.save()
						}
					}
				}
			}
			for file in folder.files {
				#if !GAME_PBR
				// skip pkx textures since the .dat inside should already have been exported and the textures will be dumped from that
				if file.fileType == .pkx { continue }
				#endif
				for texture in file.textures {
					if !texture.file.exists || overwrite {
						texture.save()
					}
					let pngFile = XGFiles.nameAndFolder(texture.file.fileName + XGFileTypes.png.fileExtension, file.folder)
					if !pngFile.exists || overwrite {
						texture.writePNGData(toFile: pngFile)
					}
				}
			}
		}
	}
	
}

extension XGFsys: XGEnumerable {
	var enumerableName: String {
		return file.path
	}

	var enumerableValue: String? {
		return nil
	}

	static var className: String {
		return "Fsys"
	}

	static var allValues: [XGFsys] {
		return XGISO.current.allFileNames
			.filter{$0.fileExtensions == XGFileTypes.fsys.fileExtension}
			.map{XGFiles.fsys($0.removeFileExtensions())}
			.filter{$0.exists}
			.map{$0.fsysData}
	}
}





















