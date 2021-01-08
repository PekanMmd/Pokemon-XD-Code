//
//  XGISO.swift
//  XGCommandLineTools
//
//  Created by StarsMmd on 15/04/2016.
//  Copyright © 2016 StarsMmd. All rights reserved.
//

import Foundation

var filesTooLargeForReplacement : [XGFiles]?

let kDOLStartOffsetLocation = 0x420
let kTOCStartOffsetLocation = 0x424
let kTOCFileSizeLocation    = 0x428
let kTOCMaxFileSizeLocation = 0x42C
let kTOCNumberEntriesOffset = 0x8
let kTOCEntrySize			= 0xc
let kISOFirstFileOffsetLocation = 0x434 // The "user data" start offset. Basically all the game specific files
let kISOFilesTotalSizeLocation = 0x438 // The size of the game specific files, so everything after dol and toc

var tocData = XGISO.extractTOC()
var ISO = XGISO()
class XGISO: NSObject {
	
	fileprivate var fileLocations = [String : Int]()
	
	fileprivate var fileSizes = [String : Int]()
	
	fileprivate var fileDataOffsets = [String : Int]() // in toc
	
	var allFileNames = [String]()
	var filesOrdered = [String]()
	
	var data : XGMutableData {
		if let d = XGFiles.iso.data {
			return d
		}
		return XGMutableData(byteStream: [Int](), file: .iso)
	}
	
	var TOCFirstStringOffset : Int {
		return tocData.get4BytesAtOffset(kTOCNumberEntriesOffset) * kTOCEntrySize
	}
	
	override init() {
		super.init()

		loadFST()
	}

	func loadFST() {
		printg("Reading FST from ISO...")

		if !XGFiles.iso.exists {
			printg("ISO file doesn't exist. Please place your \(game == .XD ? "Pokemon XD" : "Pokemon Colosseum") file in the folder \(XGFolders.ISO.path) and name it \(XGFiles.iso.fileName)")
		}

		printg("ISO size: \(self.data.length.hexString())")

		let DOLStart  = self.data.get4BytesAtOffset(kDOLStartOffsetLocation)
		let TOCStart  = self.data.get4BytesAtOffset(kTOCStartOffsetLocation)
		let TOCLength = self.data.get4BytesAtOffset(kTOCFileSizeLocation)

		if settings.verbose {
			printg("DOL start: \(DOLStart.hexString()), TOC start: \(TOCStart.hexString()), TOC size: \(TOCLength.hexString())")
		}

		fileLocations["Start.dol"] = DOLStart
		fileLocations["Game.toc"] = TOCStart
		fileSizes["Game.toc"] = TOCLength

		let kDolSectionSizesStart = 0x90
		let kDolSectionSizesCount = 18
		let kDolHeaderSize = 0x100

		var size = kDolHeaderSize
		for i in 0 ..< kDolSectionSizesCount {
			let offset = DOLStart + (i * 4) + kDolSectionSizesStart
			size += Int(self.data.getWordAtOffset(offset))
		}
		fileSizes["Start.dol"] = size
		allFileNames = ["Start.dol", "Game.toc"]
		printg("DOL size: \(size.hexString())")

		var i = 0x0

		while (i * 12 < TOCFirstStringOffset) {

			let o = i * 12
			let folder = tocData.getByteAtOffset(o) == 1

			if !folder {

				let nameOffset = Int(tocData.getWordAtOffset(o))
				let fileOffset = Int(tocData.getWordAtOffset(o + 4))
				let fileSize   = Int(tocData.getWordAtOffset(o + 8))

				let fileName = getStringAtOffset(nameOffset)

				allFileNames.append(fileName)
				fileLocations[fileName] = fileOffset
				fileSizes[fileName]     = fileSize
				fileDataOffsets[fileName] = o

			}

			i += 1
		}

		self.filesOrdered = allFileNames.sorted { (s1, s2) -> Bool in
			return locationForFile(s1)! < locationForFile(s2)!
		}

		printg("FST was read.")
	}

	func importAllFiles() {
		var files = XGFolders.FSYS.files
		files += XGFolders.AutoFSYS.files
		files += XGFolders.MenuFSYS.files
		files = files.filter { (f) -> Bool in
			return f.fileType == .fsys
		}
		files.append(.dol)
		importFiles(files)
	}
	
	func importDol() {
		importFiles([.dol])
	}

	@discardableResult
	func importToc(saveWhenDone save: Bool) -> Bool {
		let success = shiftAndReplaceFileEfficiently(name: "Game.toc", withData: tocData, save: false)
		let firstFileInUserSection = game == .XD ? "B1_1.fsys" : "D1_garage_1F.fsys"
		if success {
			if let firstFileOffset = locationForFile(firstFileInUserSection) {
				data.replace4BytesAtOffset(kISOFirstFileOffsetLocation, withBytes: firstFileOffset)
				let userDataSize = data.length - firstFileOffset
				data.replace4BytesAtOffset(kISOFilesTotalSizeLocation, withBytes: userDataSize)
			} else {
				printg("Can't find first file to set its location in ISO header but may not be an issue.")
			}
			if save {
				data.save()
			}
		}
		return success
	}
	
	func importFiles(_ fileList: [XGFiles]) {
		
		if settings.increaseFileSizes {
			for file in fileList {
				printg("importing file to ISO: " + file.fileName)
				self.shiftAndReplaceFileEfficiently(file)
			}
			self.save()
		} else {
			
			let isodata = self.data
			
			for file in fileList {
				
				let filename = file.fileName
				let data = file.data!
				
				
				printg("importing file to ISO: " + filename)
				
				let start = self.locationForFile(filename)
				let oldsize  = self.sizeForFile(filename)
				let newsize = data.length
				
				if (start == nil) || (oldsize == nil) {
					printg("file not found in ISO's .toc: " + filename)
					continue
				}
				
				if oldsize! < newsize {
					printg("file too large: " + filename)
					printg("Skipping file. In order to include this file, enable file size increases.")
					if filesTooLargeForReplacement == nil {
						filesTooLargeForReplacement = [XGFiles]()
					}
					filesTooLargeForReplacement! += [file]
					continue
				}
				
				self.replaceDataForFile(filename: file.fileName, withData: data, saveWhenDone: false)
			}
			
			isodata.save()
		}
	}
	
	fileprivate func getStringAtOffset(_ offset: Int) -> String {
		return tocData.getStringAtOffset(offset + TOCFirstStringOffset)
	}
	
	func locationForFile(_ fileName: String) -> Int? {
		return fileLocations[fileName]
	}
	
	func printFileLocations() {
		for k in fileLocations.keys.sorted() {
			printg(k,"\t:\t\(fileLocations[k]!)")
		}
	}
	
	func sizeForFile(_ fileName: String) -> Int? {
		return fileSizes[fileName]
	}
	
	func dataForFile(filename: String) -> XGMutableData? {
		
		let start = self.locationForFile(filename)
		let size  = self.sizeForFile(filename)
		
		if (start == nil) || (size == nil) {
			return nil
		}
		
		if settings.verbose {
			printg("\(filename) - start: \(start!.hexString()) size: \(size!.hexString())")
		}
		
		let data = self.data
		let bytes = data.getCharStreamFromOffset(start!, length: size!)
		
		if settings.verbose {
			printg("\(filename): read \(bytes.count) bytes")
		}
		
		return XGMutableData(byteStream: bytes, file: XGFiles.nameAndFolder(filename, .Documents))
		
	}
	
	func replaceDataForFile(filename: String, withData data: XGMutableData, saveWhenDone save: Bool) {
		
		let start   = self.locationForFile(filename)
		let oldsize = self.sizeForFile(filename)
		let newsize = data.length
		
		if (start == nil) || (oldsize == nil) {
			printg("file not found:", filename)
			return
		}
		
		let index = orderedIndexForFile(name: filename)
		if index < 0 {
			return
		}
		
		let nextStart = index == allFileNames.count - 1 ? self.data.length : locationForFile(filesOrdered[index + 1])!
		if start! + newsize > nextStart {
			printg("file too large:", filename)
			if filesTooLargeForReplacement == nil {
				filesTooLargeForReplacement = [XGFiles]()
			}
			filesTooLargeForReplacement! += [data.file]
			return
		}
		
		let isodata = self.data
		if oldsize! > newsize {
			self.eraseDataForFile(name: filename)
		}
		isodata.replaceData(data: data, atOffset: start!)
		
		self.setSize(size: newsize, forFile: filename)
		
		if save {
			isodata.save()
		}
		
	}
	
	func shiftAndReplaceFileEfficiently(_ file: XGFiles, save: Bool = false) {
		if settings.verbose {
			printg("shifting files and replacing file:", file.fileName)
		}
		if file.fileName == XGFiles.dol.fileName || file.fileName == XGFiles.toc.fileName {
			self.replaceDataForFile(filename: file.fileName, withData: file.data!, saveWhenDone: save)
		} else if self.allFileNames.contains(file.fileName) && file.exists {
			self.shiftAndReplaceFileEfficiently(name: file.fileName, withData: file.data!, save: save)
		} else {
			printg("file not found:", file.fileName)
		}
	}

	@discardableResult
	func shiftAndReplaceFileEfficiently(name: String, withData newData: XGMutableData, save: Bool = false) -> Bool {
		guard let fileLocation = locationForFile(name) else {
			printg("Couldn't find file with name '" + name + "' in the ISO.")
			return false
		}
		let oldSize = sizeForFile(name)!
		let fileIndex = orderedIndexForFile(name: name)
		let nextFileStart = fileIndex == filesOrdered.count - 1 ? data.length : locationForFile(filesOrdered[fileIndex + 1])!
		
		var shift = (newData.length - oldSize) - (nextFileStart - (fileLocation + oldSize))
		while shift % 0x10 != 0 {
			shift += 1
		}
		
		var done = false
		if shift > 0 {
			
			var deletedBytes = 0
			var switchToShiftUp = false
			var shiftUpFiles = [String]()
			
			for file in filesOrdered.reversed() {
				guard fileIsShiftable(filename: file) else {
					continue
				}
				
				let location = locationForFile(file)!
				let size = sizeForFile(file)!
				var end = location + size
				while end % 0x10 != 0 {
					end += 1
				}
				
				let index = orderedIndexForFile(name: file)
				let nextStart = index == filesOrdered.count - 1 ? self.data.length : locationForFile(filesOrdered[index + 1])!
				var difference = nextStart - end
				if !switchToShiftUp {
					difference -= deletedBytes
				}
				
				if !done {
					
					if difference > 0 {
						deletedBytes += difference
						if file != name {
							self.data.deleteBytes(start: end, count: difference)
						}
						
						if switchToShiftUp {
							for previous in shiftUpFiles {
								self.setStartOffset(offset: locationForFile(previous)! - difference, forFile: previous, saveToc: false)
							}
						}
					}
				}
				
				if switchToShiftUp && !done {
					shiftUpFiles = [file] + shiftUpFiles
				}
				
				if file == name {
					switchToShiftUp = true
					shiftUpFiles = [file]
				}
				
				if !switchToShiftUp {
					self.setStartOffset(offset: location + deletedBytes, forFile: file, saveToc: false)
				}
				
				if deletedBytes >= shift && !done  {
					done = true
				}
			}
			
			let size = sizeForFile(name)!
			let location = locationForFile(name)!
			let end = location + size
			self.data.insertRepeatedByte(byte: 0, count: deletedBytes, atOffset: end)
			
		}
		
		if done || shift <= 0 {
			self.replaceDataForFile(filename: name, withData: newData, saveWhenDone: save)
			return true
		} else {
			printg("Couldn't replace file \(name) as it is too large and ISO is full. Try deleting some files or increasing the ISO size.")
			return false
		}
		
	}
	
	func shiftAndReplaceFile(_ file: XGFiles) {
		printg("shifting files and replacing file:", file.fileName)
		if self.allFileNames.contains(file.fileName) {
			self.shiftAndReplaceFile(name: file.fileName, withData: file.data!)
		} else {
			printg("file not found:", file.fileName)
		}
	}
	
	func shiftAndReplaceFile(name: String, withData newData: XGMutableData) {
		
		let oldSize = sizeForFile(name)!
		let shift = newData.length > oldSize
		let index = orderedIndexForFile(name: name)
		
		if shift {
			for file in filesOrdered {
				self.shiftUpFile(name: file)
			}
			
			let rev = (index + 1) ..< allFileNames.count
			for i in rev.reversed() {
				let file = filesOrdered[i]
				self.shiftDownFile(name: file)
			}
		}
		
		if index < allFileNames.count - 1 {
			let nextFile = filesOrdered[index + 1]
			if let availableEnd = self.locationForFile(nextFile) {
				if availableEnd - self.locationForFile(name)! < 16 {
					printg("ISO doesn't have enough space for file: \(name). Aborting replacement. Try deleting unnecessary files from the ISO.")
					return
				}
			} else {
				printg("Unable to calculate free space for file shift and replacement. Aborting replacement.")
				return
			}
		} else {
			printg("This file cannot be shift replaced as it is too risky. \(name) is the last file in the ISO.")
			return
		}
		
		self.replaceDataForFile(filename: name, withData: newData, saveWhenDone: false)
		
		if shift {
			for i in 0 ..< self.allFileNames.count {
				let file = filesOrdered[i]
				self.shiftUpFile(name: file)
			}
			self.importToc(saveWhenDone: false)
		}
		
		self.data.save()
	}
	
	
	func eraseDataForFile(name: String) {
		
		let start = self.locationForFile(name)
		let size = self.sizeForFile(name)
		
		if start == nil || size == nil {
			printg("file not found:", name)
			return
		}
		
		eraseData(start: start!, length: size!)
	}
	
	private func eraseData(start: Int, length: Int) {
		self.data.nullBytes(start: start, length: length)
	}
	
	func deleteFile(name: String, save: Bool) {
		if name == "Game.toc" || name == "Start.dol" {
			printg("\(name) cannot be deleted")
			return
		}
		eraseDataForFile(name: name)
		setSize(size: 0, forFile: name)
		if save {
			self.data.save()
		}
		printg("deleted iso file:", name)
	}
	
	func deleteFileAndPreserve(name: String, save: Bool) {
		// replaces file with a dummy fsys container
		if name == XGFiles.toc.fileName || name == XGFiles.dol.fileName {
			printg("\(name) cannot be deleted")
			return
		}
		printg("deleting ISO file: \(name)...")
		
		if let start = locationForFile(name) {
			if let size = sizeForFile(name) {
				eraseDataForFile(name: name)
				if name.fileExtensions == ".fsys" {
					// prevents crashes when querying fsys data
					self.shiftAndReplaceFileEfficiently(name: name, withData: NullFSYS)
					printg("deleted ISO file:", name)
				} else {
					if size >= 16 {
						// hex for string "DELETED DELETED "
						let deleted = [0x44, 0x45, 0x4C, 0x45, 0x54, 0x45, 0x44, 0x20, 0x44, 0x45, 0x4C, 0x45, 0x54, 0x45, 0x44, 0x00]
						self.data.replaceBytesFromOffset(start, withByteStream: deleted)
						setSize(size: deleted.count, forFile: name)
						printg("deleted ISO file:", name)
					}
				}
				if save {
					self.data.save()
				}
			} else {
				printg("Couldn't delete ISO file:", name, ". It doesn't exist!")
			}
		} else {
			printg("Couldn't delete ISO file:", name, ". It doesn't exist!")
		}
		
	}
	
	private func setSize(size: Int, forFile name: String) {
		guard name != "Game.toc" else {
			data.replace4BytesAtOffset(kTOCFileSizeLocation, withBytes: size)
			data.replace4BytesAtOffset(kTOCMaxFileSizeLocation, withBytes: size)
			fileSizes[name] = size
			return
		}
		let start = fileDataOffsets[name]
		if start != nil {
			let toc = XGFiles.toc.data!
			toc.replaceWordAtOffset(start! + 8, withBytes: UInt32(size))
			self.importToc(saveWhenDone: false)
		}
		fileSizes[name] = size
	}
	
	private func setStartOffset(offset: Int, forFile name: String, saveToc: Bool = true) {
		guard name != "Game.toc" else {
			data.replace4BytesAtOffset(kTOCStartOffsetLocation, withBytes: offset)
			fileLocations[name] = offset
			return
		}
		let start = fileDataOffsets[name]
		if start != nil {
			let toc = XGFiles.toc.data!
			toc.replaceWordAtOffset(start! + 4, withBytes: UInt32(offset))
			if saveToc {
				self.importToc(saveWhenDone: true)
			}
			fileLocations[name] = offset
		} else {
			printg("couldn't find toc data for file:", name)
		}
		
	}
	
	func fileIsShiftable(filename: String) -> Bool {
		// There's a large chunk of unused data between TEST004.fsys and bg0thumbcode.bin
		// This data isn't listed in game.toc so my code ignores it
		// If this turns out to be necessary then only allow shifting of files
		// after "bg0thumbcode.bin"
		let index = orderedIndexForFile(name: filename)
		return orderedIndexForFile(name: "Game.toc") < index
	}
	
	private func orderedIndexForFile(name: String) -> Int {
		for i in 0 ..< filesOrdered.count {
			if filesOrdered[i] == name {
				return i
			}
		}
		return -1
	}
	
	private func shiftUpFile(name: String) {
		// used to push a file closer to the file above it and create more space for other files
		var previousEnd = 0x0
		let index = orderedIndexForFile(name: name)

		guard fileIsShiftable(filename: name) else {
			return
		}
		
		if index == 0 {
			previousEnd = self.data.get4BytesAtOffset(kISOFirstFileOffsetLocation)
		} else {
			let previous = filesOrdered[index - 1]
			previousEnd = self.locationForFile(previous)! + sizeForFile(previous)!
		}
		
		if locationForFile(name)! - previousEnd >= 0x10 {
			while previousEnd % 16 != 0 {
				previousEnd += 1 // byte alignment is required or game doesn't load
			}
			self.shiftFileByDeletion(name: name, byOffset: previousEnd - locationForFile(name)!)
		}
		
	}
	
	private func shiftDownFile(name: String) {
		// used to push a file closer to the file below it and create more space for other files
		let size  = sizeForFile(name)!
		let index = orderedIndexForFile(name: name)
		
		guard fileIsShiftable(filename: name) else {
			return
		}
		
		let nextStart = index == allFileNames.count - 1 ? self.data.length : locationForFile(filesOrdered[index + 1])!
		
		var start = nextStart - size
		
		if start - locationForFile(name)! >= 0x10 {
			
			while start % 16 != 0 {
				start -= 1 // byte alignment is required or game doesn't load
			}
			self.shiftFileByDeletion(name: name, byOffset: start - locationForFile(name)!)
		}
		
	}
	
	private func shiftDownFile(name: String, byOffset by: Int) -> Bool {
		// used to push a file closer to the file below it and create more space for other files
		let size  = sizeForFile(name)!
		let index = orderedIndexForFile(name: name)
		
		guard fileIsShiftable(filename: name) else {
			return false
		}
		
		if by % 16 != 0 {
			printg("Attempted to shift down file \(name) by \(by) bytes but offset must be a multiple of 16 for alignment.")
			return false
		}
		
		let nextStart = index == allFileNames.count - 1 ? self.data.length : locationForFile(filesOrdered[index + 1])!
		let start = locationForFile(name)! + by
		
		if nextStart > start + size + 0x10 {
			self.shiftFileByDeletion(name: name, byOffset: by)
		} else {
			printg("couldn't shift down file \(name) as there is insufficient room.")
			return false
		}
		return true
	}
	
	func moveFile(name: String, toOffset startOffset: Int) {
		
		if startOffset == locationForFile(name)! {
			return
		}
		
		if settings.verbose {
			printg("Moving iso file:", name, "to:", startOffset.hexString())
		}
		
		let bytes = self.dataForFile(filename: name)!.byteStream
		
		self.eraseData(start: locationForFile(name)!, length: sizeForFile(name)!)
		self.setStartOffset(offset: startOffset, forFile: name)
		
		self.data.replaceBytesFromOffset(startOffset, withByteStream: bytes)
	}
	
	func shiftFileByDeletion(name: String, byOffset offset: Int) {
		// shifts file by deleting empty bytes before/after and inserting empty bytes after/before the file
		
		if offset == 0 {
			return
		}
		
		if settings.verbose {
			printg("shifting iso file:", name, "by:", offset.hexString(), " bytes")
		}
		
		let oldOffset = locationForFile(name)!
		
		if offset < 0 {
			let zeroes = [Int](repeating: 0, count: -offset)
			self.data.insertBytes(bytes: zeroes, atOffset: oldOffset + sizeForFile(name)!)
			self.data.deleteBytes(start: oldOffset + offset, count: -offset)
		} else {
			self.data.deleteBytes(start: oldOffset + sizeForFile(name)!, count: offset)
			let zeroes = [Int](repeating: 0, count: offset)
			self.data.insertBytes(bytes: zeroes, atOffset: oldOffset)
		}
		
		self.setStartOffset(offset: oldOffset + offset, forFile: name)
	}

	private func insertBytes(count: Int, at offset: Int) {
		for file in filesOrdered.reversed() {
			guard let fileOffset = locationForFile(file) else {
				continue
			}
			if fileOffset >= offset {
				setStartOffset(offset: fileOffset + count, forFile: file, saveToc: false)
			} else {
				break
			}
		}
		importToc(saveWhenDone: false)
		data.insertRepeatedByte(byte: 0, count: count, atOffset: offset)
		data.save()
	}

	func increaseISOSize(by bytes: Int) {
		printg("Increasing ISO size by \(bytes) bytes. New size will be \(bytes.hexString()) (\(bytes)) bytes")
		guard (data.length +  bytes) % 16 == 0 else {
			printg("Couldn't increase ISO size. The resulting size should be a multiple of 16.")
			return
		}
		insertBytes(count: bytes, at: data.length)

		if let firstFileOffset = locationForFile("B1_1.fsys") {
			let userDataSize = data.length - firstFileOffset
			data.replace4BytesAtOffset(kISOFilesTotalSizeLocation, withBytes: userDataSize)
		}
	}

	func addFile(_ file: XGFiles, save: Bool = true) {

		printg("Adding new file to ISO: " + file.path)

		let filename = file.fileName

		guard file.fileName.length < 50 else {
			// I don't know if there's an actual limit but this should be more than enough
			printg("Please choose a shorter filename: " + file.fileName)
			return
		}

		guard !allFileNames.contains(filename) else {
			printg("Could not add file: " + file.path + "\nA file with that name already exists.")
			return
		}

		guard file.exists, file.data != nil else {
			printg("Could not add file: " + file.path + "\nFile not found.")
			return
		}

		let tocBackup = XGMutableData(byteStream: tocData.byteStream, file: .toc)
		let lastFile = filesOrdered.last!

		var newFileStart = locationForFile(lastFile)! + sizeForFile(lastFile)!
		while newFileStart % 16 != 0 {
			newFileStart += 1
		}

		let newTOCEntryOffset = TOCFirstStringOffset
		tocData.insertRepeatedByte(byte: 0, count: kTOCEntrySize, atOffset: newTOCEntryOffset)
		let oldCount = tocData.get4BytesAtOffset(kTOCNumberEntriesOffset)
		tocData.replace4BytesAtOffset(kTOCNumberEntriesOffset, withBytes: oldCount + 1)

		var lastStringOffset = tocData.length
		while tocData.get2BytesAtOffset(lastStringOffset - 2) == 0 {
			lastStringOffset -= 1
		}
		let relativeStringOffset = lastStringOffset - TOCFirstStringOffset
		tocData.replace4BytesAtOffset(newTOCEntryOffset, withBytes: relativeStringOffset)
		tocData.replace4BytesAtOffset(newTOCEntryOffset + 4, withBytes: newFileStart)
		tocData.replace4BytesAtOffset(newTOCEntryOffset + 8, withBytes: 0)

		let newStringLength = filename.count + 1
		var requiredBytes = newStringLength
		while requiredBytes % 16 != 0 {
			requiredBytes += 1
		}
		if lastStringOffset + newStringLength > tocData.length {
			tocData.insertRepeatedByte(byte: 0, count: requiredBytes, atOffset: tocData.length)
		}


		let string = XGString(string: filename, file: nil, sid: nil)
		let bytes = string.chars.map({ (char) -> UInt8 in
			char.unicode
		}) + [0]
		tocData.replaceBytesFromOffset(lastStringOffset, withByteStream: bytes)

		guard importToc(saveWhenDone: false) else {
			tocData = tocBackup
			printg("Could not add file: " + file.path + "\nThere was no room for the extra TOCEntry")
			return
		}

		loadFST()

		shiftAndReplaceFileEfficiently(file, save: save)
	}
	
	func save() {
		if settings.verbose {
			printg("saving iso...")
		}
		self.importToc(saveWhenDone: false)
		self.data.save()
		if settings.verbose {
			printg("saved iso")
		}
	}
	
	class func extractTOC() -> XGMutableData {
		let iso = XGFiles.iso.data!
		
		let TOCStart = Int(iso.getWordAtOffset(kTOCStartOffsetLocation))
		let TOCLength = Int(iso.getWordAtOffset(kTOCFileSizeLocation))
		
		let bytes = iso.getCharStreamFromOffset(TOCStart, length: TOCLength)
		
		return XGMutableData(byteStream: bytes, file: .toc)
		
	}
	
	var fsysGroupIDs = [Int : String]()
	var fsysGroupIDsData = [Int : XGFsys]()
	
	func getFSYSNameWithGroupID(_ id: Int) -> String? {
		
		if let name = fsysGroupIDs[id] {
			return name == "n/a" ? nil : name
		}
		
		for file in self.allFileNames where file.fileExtensions == ".fsys" {
			let start = locationForFile(file)!
			let groupID = self.data.get4BytesAtOffset(start + kFSYSGroupIDOffset)
			if groupID == id {
				fsysGroupIDs[id] = file
				return file
			}
		}
		
		fsysGroupIDs[id] = "n/a"
		return nil
	}
	
	func getFSYSDataWithGroupID(_ id: Int) -> XGFsys? {
		if let data = fsysGroupIDsData[id] {
			return data
		}
		
		if let name = getFSYSNameWithGroupID(id) {
			let data = dataForFile(filename: name)!.fsysData
			if name.contains("stm_se_nakigoe_archive") {
				fsysGroupIDsData[id] = data
			}
			return data
		}
		return nil
	}
	
	func getPKXModelWithIdentifier(id: UInt32) -> XGFsys? {
		for file in self.allFileNames where file.contains("pkx") {
			let start = self.locationForFile(file)!
			
			let details = self.data.get4BytesAtOffset(start + 0x60) // first fsys file details pointer
			let identifier = self.data.getWordAtOffset(start + details)
			
			if identifier == id {
				return self.dataForFile(filename: file)!.fsysData
			}
			
		}
		return nil
	}
	
	func getFSYSForIdentifier(id: UInt32) -> XGFsys? {
		for file in self.allFileNames where file.contains(".fsys") {
			let start = self.locationForFile(file)!
			let entries = self.data.get4BytesAtOffset(start + kNumberOfEntriesOffset)
			
			for i in 0 ..< entries {
				let details = self.data.get4BytesAtOffset(start + 0x60)
				let identifier = self.data.getWordAtOffset(start + details + (i * kSizeOfArchiveEntry))
				if identifier == id {
					return self.dataForFile(filename: file)!.fsysData
				}
			}
			
		}
		return nil
	}
	
	func extractAutoFSYS() {
		
		if region != .EU { // errrr... why did I write this?! leaving in for now just in case.
			for file in ISO.allFileNames where XGMaps(rawValue: file.substring(from: 0, to: 2)) != nil {
				let xgf = XGFiles.nameAndFolder(file, .AutoFSYS)
				if !xgf.exists {
					if settings.verbose {
						printg("extracting auto fsys file: \(xgf.fileName)")
					}
					if let data = dataForFile(filename: file) {
						data.file = xgf
						data.save()
					} else {
						printg("Couldn't extract data for file: \(xgf.fileName)")
					}
				}
			}
		}
	}
	
	func extractMenuFSYS() {
		let menus = self.allFileNames.filter { (s) -> Bool in
			return s.contains("menu") && s.contains(".fsys") && !["ex_","Script_t","test","TEST","carde", "debug", "DNA", "keydisc","_fr.","_ge.","_it.", "_sp."].contains(where: { (str) -> Bool in
				return s.contains(str)
			})
		}
		
		for file in self.menuFsysList + menus {
			let xgf = XGFiles.nameAndFolder(file, .MenuFSYS)
			if !xgf.exists {
				if settings.verbose {
					printg("extracting menu fsys file: \(xgf.fileName)")
				}
				if let data = dataForFile(filename: file) {
					data.file = xgf
					data.save()
				} else {
					printg("Couldn't extract data for file: \(xgf.fileName)")
				}
			}
		}
	}
	
	func extractFSYS() {
		for file in self.fsysList {
			let xgf = XGFiles.nameAndFolder(file, .FSYS)
			if !xgf.exists {
				if settings.verbose {
					printg("extracting common file: \(xgf.fileName)")
				}
				if let data = dataForFile(filename: file) {
					data.file = xgf
					data.save()
				} else {
					printg("Couldn't extract data for file: \(xgf.fileName)")
				}
			}
		}
	}
	
	func extractAllFSYS() {
		if settings.verbose {
			printg("extracting: AutoFSYS")
		}
		extractAutoFSYS()
		if settings.verbose {
			printg("extracting: MenuFSYS")
		}
		extractMenuFSYS()
		if settings.verbose {
			printg("extracting: FSYS")
		}
		extractFSYS()
	}
	
	func extractCommon() {
		stringsLoaded = false
		if settings.verbose {
			printg("extracting: \(XGFiles.common_rel.fileName)")
		}
		if !XGFiles.fsys("common").exists {
			extractFSYS()
		}
		if !XGFiles.common_rel.exists {
			let relIndex = game == .XD && region == .JP ? 1 : 0
			let rel = XGFiles.fsys("common").fsysData.decompressedDataForFileWithIndex(index: relIndex)!
			rel.file = .common_rel
			rel.save()
		}

		if game == .XD && !isDemo && region != .JP {
			if settings.verbose {
				printg("extracting: \(XGFiles.tableres2.fileName)")
			}
			if !XGFiles.fsys("common_dvdeth").exists {
				extractFSYS()
			}
			if !XGFiles.tableres2.exists && XGFiles.fsys("common_dvdeth").exists {
				let tableres2 = XGFiles.fsys("common_dvdeth").fsysData.decompressedDataForFileWithIndex(index: 0)!
				tableres2.file = .tableres2
				tableres2.save()
			}
		}
		
		if settings.verbose {
			printg("extracting: \(XGFiles.pocket_menu.fileName)")
		}
		if !XGFiles.fsys("pocket_menu").exists {
			extractMenuFSYS()
		}
		if !XGFiles.pocket_menu.exists {
			let pocket = XGFiles.fsys("pocket_menu").fsysData.decompressedDataForFileWithIndex(index: 0)!
			pocket.file = .pocket_menu
			pocket.save()
		}

		if !XGFiles.pocket_menu.exists {
			let pocket = XGFiles.fsys("pocket_menu").fsysData.decompressedDataForFileWithIndex(index: 0)!
			pocket.file = .pocket_menu
			pocket.save()
		}

		for file in XGFolders.MenuFSYS.files where file.fileType == .fsys {
			let fsys = file.fsysData
			let msgs = fsys.decompressedDataForFilesWithFiletype(type: .msg)
			for msg in msgs {
				msg.file = .nameAndFolder(msg.file.fileName, .StringTables)
				if !msg.file.exists {
					msg.save()
				}
			}
		}
		
	}
	
	func extractAutoStringTables() {
		stringsLoaded = false
		
		if region != .EU { // umm... why did I write this? Will leave it for now just in case.
			
			for file in XGFolders.AutoFSYS.files where file.fileType == .fsys {
				let msg = XGFiles.msg(file.fileName.removeFileExtensions())
				if !msg.exists {
					if settings.verbose {
						printg("extracting msg: \(msg.fileName)")
					}
					let fsys = file.fsysData
					let data = fsys.decompressedDataForFileWithFiletype(type: .msg)
					if let d = data {
						d.file = msg
						d.save()
					}
				}
			}
		}
	}
	
	func extractStringTables() {
		extractAutoStringTables()
		extractSpecificStringTables()
	}
	
	func extractScripts() {
		for file in XGFolders.AutoFSYS.files + XGFolders.MenuFSYS.files where file.fileType == .fsys {
			let scd = XGFiles.scd(file.fileName.removeFileExtensions())
			if !scd.exists {
				if settings.verbose {
					printg("extracting scd: \(scd.fileName)")
				}
				let fsys = file.fsysData
				let data = fsys.decompressedDataForFileWithFiletype(type: .scd)
				if let d = data {
					d.file = scd
					d.save()
				}
			}
		}
	}
	
	func extractRels() {
		for file in XGFolders.AutoFSYS.files + XGFolders.MenuFSYS.files where file.fileType == .fsys {
			let rel = XGFiles.rel(file.fileName.removeFileExtensions())
			if !rel.exists {
				if settings.verbose {
					printg("extracting rel: \(rel.fileName)")
				}
				let fsys = file.fsysData
				if let data = fsys.decompressedDataForFileWithFiletype(type: .rel) {
					data.file = rel
					data.save()
				}
			}
		}
	}
	
	func extractCols() {
		for file in XGFolders.AutoFSYS.files + XGFolders.MenuFSYS.files where file.fileType == .fsys {
			let col = XGFiles.ccd(file.fileName.removeFileExtensions())
			if !col.exists {
				if settings.verbose {
					printg("extracting col: \(col.fileName)")
				}
				let fsys = file.fsysData
				let data = fsys.decompressedDataForFileWithFiletype(type: .ccd)
				if let d = data {
					d.file = col
					d.save()
				}
			}
		}
	}
	
	func extractDOL() {
		stringsLoaded = false
		if !XGFiles.dol.exists {
			let dol = dataForFile(filename: XGFiles.dol.fileName)!
			dol.file = .dol
			dol.save()
		}
	}
	
	 class func extractAllFiles() {
		printg("extracting: Start.dol")
		ISO.extractDOL()
		printg("extracting: FSYS archives")
		ISO.extractAllFSYS()
		printg("extracting: common")
		ISO.extractCommon()
		printg("extracting: decks")
		ISO.extractDecks()
		printg("extracting: string tables")
		ISO.extractStringTables()
		printg("extracting: scripts")
		ISO.extractScripts()
		printg("extracting: relocatable files")
		ISO.extractRels()
		printg("extracting: collision data")
		ISO.extractCols()
		printg("extracted all files.")
	}

	class func extractMainFiles() {
		printg("extracting: Start.dol")
		ISO.extractDOL()
		printg("extracting: FSYS archives")
		ISO.extractFSYS()
		ISO.extractMenuFSYS()
		printg("extracting: common")
		ISO.extractCommon()
		printg("extracting: main string tables")
		ISO.extractSpecificStringTables()
		if game == .XD {
			printg("extracting: decks")
			ISO.extractDecks()
		}
		printg("extracted main files.")
	}
	
}



























































