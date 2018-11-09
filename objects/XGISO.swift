//
//  XGISO.swift
//  XGCommandLineTools
//
//  Created by StarsMmd on 15/04/2016.
//  Copyright © 2016 StarsMmd. All rights reserved.
//

import Foundation

var filesTooLargeForReplacement : [XGFiles]?

//let fileLocations = [
//	"Start.dol"				: 0x20258,
//	"common.fsys"			: 0x16A8C0A0,
//	"common_dvdeth.fsys"	: 0x16AEE5E0,
//	"deck_archive.fsys"		: 0x1BFA28DC,
//	"field_common.fsys"		: 0x1D9D183C,
//	"fight_common.fsys"		: 0x1DBC50BC,
//	"title.fsys"			: 0x4FE18C00,
//	"M3_cave_1F_2.fsys"		: 0x2087323C,
//	"M2_guild_1F_2.fsys"	: 0x1FE3A8DC,
//]

let kDOLStartOffsetLocation = 0x420
let kTOCStartOffsetLocation = 0x424
let kTOCFileSizeLocation    = 0x428
let kTOCNumberEntriesOffset = 0x8
let kTOCEntrySize			= 0xc
let kISOFirstFileOffsetLocation = 0x434

// US
//let kTOCFirstStringOffset = 0x783C

enum XGGame {
	case Colosseum
	case XD
}

var tocData = XGISO.extractTOC()
var ISO = XGISO()
class XGISO: NSObject {
	
	fileprivate var fileLocations = [String : Int]()
//	fileprivate var fileLocations = ["Start.dol" : 131840]
//	fileprivate var fileLocations = ["Start.dol" : 0x1EC00] colosseum
	
	fileprivate var fileSizes = [String : Int]()
//	fileprivate var fileSizes = ["Start.dol" : 0x39AD00] colosseum
	
	fileprivate var fileDataOffsets = [String : Int]() // in toc
	
	@objc var allFileNames = [String]()
	@objc var filesOrdered = [String]()
	
	@objc var data : XGMutableData {
		if let d = XGFiles.iso.data {
			return d
		}
		return XGMutableData(byteStream: [], file: .iso)
	}
	
	@objc var TOCFirstStringOffset : Int {
		return XGFiles.toc.data!.get4BytesAtOffset(kTOCNumberEntriesOffset) * kTOCEntrySize
	}
	
	override init() {
		super.init()
		
		printg("Initialising ISO...")
		
		if !XGFiles.iso.exists {
			printg("ISO file doesn't exist. Please place your \(game == .XD ? "Pokemon XD" : "Pokemon Colosseum") file in the folder \(XGFolders.ISO.path) and name it \(XGFiles.iso.fileName)")
		}
		
		printg("ISO size: \(self.data.length.hexString())")
		
		let DOLStart  = self.data.get4BytesAtOffset(kDOLStartOffsetLocation)
		let TOCStart  = self.data.get4BytesAtOffset(kTOCStartOffsetLocation)
		let TOCLength = self.data.get4BytesAtOffset(kTOCFileSizeLocation)
		
		if verbose {
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
				
				if verbose {
					printg("index \(i): found file \(fileName) @offset \(o.hexString())")
				}
				
			}
			
			i += 1
		}
		
		self.filesOrdered = allFileNames.sorted { (s1, s2) -> Bool in
			return locationForFile(s1)! < locationForFile(s2)!
		}
		
		printg("ISO initialised.")
	}
	
	@objc func importAllFiles() {
		var files = XGFolders.FSYS.files ?? [XGFiles]()
		files += XGFolders.AutoFSYS.files ?? [XGFiles]()
		files += XGFolders.MenuFSYS.files ?? [XGFiles]()
		files = files.filter { (f) -> Bool in
			return f.fileType == .fsys
		}
		files.append(.dol)
		importFiles(files)
	}
	
	@objc func importDol() {
		importFiles([.dol])
	}
	
	@objc func importToc(saveWhenDone save: Bool) {
		
		let TOCStart = self.data.get4BytesAtOffset(kTOCStartOffsetLocation)
		let toc = XGFiles.toc.data!.byteStream
		self.data.replaceBytesFromOffset(TOCStart, withByteStream: toc)
		if save {
			self.data.save()
		}
		
	}
	
	func importFiles(_ fileList: [XGFiles]) {
		
		if increaseFileSizes {
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
	
	@objc func printFileLocations() {
		for k in fileLocations.keys.sorted() {
			printg(k,"\t:\t\(fileLocations[k]!)")
		}
	}
	
	func sizeForFile(_ fileName: String) -> Int? {
		return fileSizes[fileName]
	}
	
	@objc func dataForFile(filename: String) -> XGMutableData? {
		
		let start = self.locationForFile(filename)
		let size  = self.sizeForFile(filename)
		
		if (start == nil) || (size == nil) {
			return nil
		}
		
		if verbose {
			printg("\(filename) - start: \(start!.hexString()) size: \(size!.hexString())")
		}
		
		let data = self.data
		let bytes = data.getCharStreamFromOffset(start!, length: size!)
		
		if verbose {
			printg("\(filename): read \(bytes.count) bytes")
		}
		
		return XGMutableData(byteStream: bytes, file: XGFiles.nameAndFolder(filename, .Documents))
		
	}
	
	@objc func replaceDataForFile(filename: String, withData data: XGMutableData, saveWhenDone save: Bool) {
		
		let start = self.locationForFile(filename)
		let oldsize  = self.sizeForFile(filename)
		let newsize = data.length
		
		if (start == nil) || (oldsize == nil) {
			printg("file not found:", filename)
			return
		}
		
		let index = orderedIndexForFile(name: filename)
		if index < 0 {
			return
		}
		
		let nextStart = index == allFileNames.count - 1 ? data.length : locationForFile(filesOrdered[index + 1])!
		if start! + newsize > nextStart {
			printg("file too large:", filename)
			if filesTooLargeForReplacement == nil {
				filesTooLargeForReplacement = [XGFiles]()
			}
			filesTooLargeForReplacement! += [data.file]
			return
		}
		
		self.setSize(size: newsize, forFile: filename)
		
		let isodata = self.data
		if oldsize! > newsize {
			self.eraseDataForFile(name: filename)
		}
		isodata.replaceBytesFromOffset(start!, withByteStream: data.byteStream)
		
		if save {
			isodata.save()
		}
		
	}
	
	func shiftAndReplaceFileEfficiently(_ file: XGFiles) {
		if verbose {
			printg("shifting files and replacing file:", file.fileName)
		}
		if file.fileName == XGFiles.dol.fileName || file.fileName == XGFiles.toc.fileName {
			self.replaceDataForFile(filename: file.fileName, withData: file.data!, saveWhenDone: false)
		} else if self.allFileNames.contains(file.fileName) && file.exists {
			self.shiftAndReplaceFileEfficiently(name: file.fileName, withData: file.data!)
		} else {
			printg("file not found:", file.fileName)
		}
	}
	
	@objc func shiftAndReplaceFileEfficiently(name: String, withData newData: XGMutableData) {
		
		let oldSize = sizeForFile(name)!
		
		var shift = newData.length - oldSize
		while shift % 0x10 != 0 {
			shift += 1
		}
		
		var done = false
		if shift > 0 {
			
			var deletedBytes = 0
			var switchToShiftUp = false
			var shiftUpFiles = [String]()
			for file in filesOrdered.reversed() {
				if orderedIndexForFile(name: "bg2thumbcode.bin") >= orderedIndexForFile(name: file) || orderedIndexForFile(name: "movie_auto_demo.fsys") <= orderedIndexForFile(name: file) {
					continue
				}
				
				let location = locationForFile(file)!
				if !done {
					
					let size = sizeForFile(file)!
					var end = location + size
					while end % 0x10 != 0 {
						end += 1
					}
					
					let index = orderedIndexForFile(name: file)
					let nextStart = index == filesOrdered.count - 1 ? self.data.length : locationForFile(filesOrdered[index + 1])!
					let difference = nextStart - end
					
					if difference > 0 {
						deletedBytes += difference
						self.data.deleteBytes(start: end, count: difference)
						
						if switchToShiftUp {
							
							for previous in shiftUpFiles {
								self.setStartOffset(offset: locationForFile(previous)! - difference, forFile: previous, saveToc: false)
							}
							shiftUpFiles = [file] + shiftUpFiles
							
						}
					}
					
					
				}
				
				if file == name {
					switchToShiftUp = true
					shiftUpFiles = [file]
				}
				
				if !switchToShiftUp {
					self.setStartOffset(offset: location + deletedBytes, forFile: file, saveToc: false)
				}
				
				if deletedBytes >= shift  {
					done = true
				}
			}
			
			let size = sizeForFile(name)!
			let location = locationForFile(name)!
			let end = location + size
			self.data.insertRepeatedByte(byte: 0, count: deletedBytes, atOffset: end)
			
		}
		
		if done || shift <= 0 {
			self.replaceDataForFile(filename: name, withData: newData, saveWhenDone: false)
		} else {
			printg("Couldn't replace file \(name) as it is too large and ISO is full. Try deleting some files and trying again.")
		}
		
		if shift > 0 {
			self.importToc(saveWhenDone: false)
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
	
	@objc func shiftAndReplaceFile(name: String, withData newData: XGMutableData) {
		
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
	
	
	@objc func eraseDataForFile(name: String) {
		
		let start = self.locationForFile(name)
		let size = self.sizeForFile(name)
		
		if start == nil || size == nil {
			printg("file not found:", name)
			return
		}
		
		eraseData(start: start!, length: size!)
	}
	
	@objc private func eraseData(start: Int, length: Int) {
		self.data.nullBytes(start: start, length: length)
	}
	
	@objc func deleteFile(name: String, save: Bool) {
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
	
	@objc func deleteFileAndPreserve(name: String, save: Bool) {
		// replaces file with a dummy fsys container
		if name == XGFiles.toc.fileName || name == XGFiles.dol.fileName {
			printg("\(name) cannot be deleted")
			return
		}
		printg("deleting ISO file: \(name)")
		
		if locationForFile(name) != nil {
			eraseDataForFile(name: name)
			if let size = sizeForFile(name) {
				if name.fileExtensions == ".fsys" {
					if size >= NullFSYS.length {
						// prevents crashes when querying fsys data
//						self.data.replaceBytesFromOffset(locationForFile(name)!, withByteStream: NullFSYS.byteStream)
//						setSize(size: NullFSYS.length, forFile: name)
						self.shiftAndReplaceFileEfficiently(name: name, withData: NullFSYS)
					}
				} else {
					if size >= 16 {
						setSize(size: 16, forFile: name)
					}
				}
			}
		}
		if save {
			self.data.save()
		}
		printg("deleted ISO file:", name)
	}
	
	@objc private func setSize(size: Int, forFile name: String) {
		let start = fileDataOffsets[name]
		if start != nil {
			let toc = XGFiles.toc.data!
			toc.replaceWordAtOffset(start! + 8, withBytes: UInt32(size))
			self.importToc(saveWhenDone: false)
		}
		fileSizes[name] = size
	}
	
	@objc private func setStartOffset(offset: Int, forFile name: String) {
		self.setStartOffset(offset: offset, forFile: name, saveToc: true)
		
	}
	
	@objc private func setStartOffset(offset: Int, forFile name: String, saveToc: Bool) {
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
	
	
	
	@objc private func orderedIndexForFile(name: String) -> Int {
		for i in 0 ..< filesOrdered.count {
			if filesOrdered[i] == name {
				return i
			}
		}
		return -1
	}
	
	@objc private func shiftUpFile(name: String) {
		// used to push a file closer to the file above it and create more space for other files
		var previousEnd = 0x0
		let index = orderedIndexForFile(name: name)
		
		if orderedIndexForFile(name: "bg2thumbcode.bin") >= index || orderedIndexForFile(name: "stm_bgm_00seaside32.fsys") <= index {
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
	
	@objc private func shiftDownFile(name: String) {
		// used to push a file closer to the file below it and create more space for other files
		let size  = sizeForFile(name)!
		let index = orderedIndexForFile(name: name)
		
		if orderedIndexForFile(name: "bg2thumbcode.bin") >= index || orderedIndexForFile(name: "stm_bgm_00seaside32.fsys") <= index {
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
	
	@objc private func shiftDownFile(name: String, byOffset by: Int) -> Bool {
		// used to push a file closer to the file below it and create more space for other files
		let size  = sizeForFile(name)!
		let index = orderedIndexForFile(name: name)
		
		if orderedIndexForFile(name: "bg2thumbcode.bin") >= index || orderedIndexForFile(name: "stm_bgm_00seaside32.fsys") <= index {
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
	
	@objc func moveFile(name: String, toOffset startOffset: Int) {
		
		if startOffset == locationForFile(name)! {
			return
		}
		
		if verbose {
			printg("Moving iso file:", name, "to:", startOffset.hexString())
		}
		
		let bytes = self.dataForFile(filename: name)!.byteStream
		
		self.eraseData(start: locationForFile(name)!, length: sizeForFile(name)!)
		self.setStartOffset(offset: startOffset, forFile: name)
		
		self.data.replaceBytesFromOffset(startOffset, withByteStream: bytes)
	}
	
	@objc func shiftFileByDeletion(name: String, byOffset offset: Int) {
		// shifts file by deleting empty bytes before/after and inserting empty bytes after/before the file
		
		if offset == 0 {
			return
		}
		
		if verbose {
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
	
	@objc func save() {
		if verbose {
			printg("saving iso...")
		}
		self.data.save()
		if verbose {
			printg("saved iso")
		}
	}
	
	@objc class func extractTOC() -> XGMutableData {
		let iso = XGFiles.iso.data!

		// US
		//let TOCStart = 0x442100
		//let TOCLength = 0x15958
		
		let TOCStart = Int(iso.getWordAtOffset(kTOCStartOffsetLocation))
		let TOCLength = Int(iso.getWordAtOffset(kTOCFileSizeLocation))
		
		let bytes = iso.getCharStreamFromOffset(TOCStart, length: TOCLength)
		
		return XGMutableData(byteStream: bytes, file: .toc)
		
	}
	
	func getFSYSNameWithGroupID(_ id: Int) -> String? {
		for file in self.allFileNames where file.fileExtensions == ".fsys" {
			let start = locationForFile(file)!
			let groupID = self.data.get4BytesAtOffset(start + kFSYSGroupIDOffset)
			if groupID == id {
				return file
			}
		}
		return nil
	}
	
	func getFSYSDataWithGroupID(_ id: Int) -> XGFsys? {
		let name = getFSYSNameWithGroupID(id)
		return name == nil ? nil : dataForFile(filename: name!)!.fsysData
	}
	
	@objc func getPKXModelWithIdentifier(id: UInt32) -> XGFsys? {
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
	
	@objc func getFSYSForIdentifier(id: UInt32) -> XGFsys? {
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
	
	@objc func extractAutoFSYS() {
		
		if region != .EU { // errrr... why did I write this?! leaving in for now just in case.
			for file in ISO.allFileNames where XGMaps(rawValue: file.substring(from: 0, to: 2)) != nil {
				let xgf = XGFiles.nameAndFolder(file, .AutoFSYS)
				if !xgf.exists {
					if verbose {
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
	
	@objc func extractMenuFSYS() {
		let menus = self.allFileNames.filter { (s) -> Bool in
			return s.contains("menu") && s.contains(".fsys") && !["ex_","Script_t","test","TEST","carde", "debug", "DNA", "keydisc","_fr.","_ge.","_it.", "_sp."].contains(where: { (str) -> Bool in
				return s.contains(str)
			})
		}
		
		for file in self.menuFsysList + menus {
			let xgf = XGFiles.nameAndFolder(file, .MenuFSYS)
			if !xgf.exists {
				if verbose {
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
	
	@objc func extractFSYS() {
		for file in self.fsysList {
			let xgf = XGFiles.nameAndFolder(file, .FSYS)
			if !xgf.exists {
				if verbose {
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
	
	@objc func extractAllFSYS() {
		if verbose {
			printg("extracting: AutoFSYS")
		}
		extractAutoFSYS()
		if verbose {
			printg("extracting: MenuFSYS")
		}
		extractMenuFSYS()
		if verbose {
			printg("extracting: FSYS")
		}
		extractFSYS()
	}
	
	@objc func extractCommon() {
		stringsLoaded = false
		if verbose {
			printg("extracting: \(XGFiles.common_rel.fileName)")
		}
		if !XGFiles.fsys("common").exists {
			extractFSYS()
		}
		if !XGFiles.common_rel.exists {
			let rel = XGFiles.fsys("common").fsysData.decompressedDataForFileWithIndex(index: 0)!
			rel.file = .common_rel
			rel.save()
		}
		
		if verbose {
			printg("extracting: \(XGFiles.tableres2.fileName)")
		}
		if game == .XD {
			if !XGFiles.fsys("common_dvdeth").exists {
				extractFSYS()
			}
			if !XGFiles.tableres2.exists {
				let tableres2 = XGFiles.fsys("common_dvdeth").fsysData.decompressedDataForFileWithIndex(index: 0)!
				tableres2.file = .tableres2
				tableres2.save()
			}
		}
		
		if verbose {
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
		
	}
	
	@objc func extractAutoStringTables() {
		stringsLoaded = false
		
		if region != .EU { // umm... why did I write this? Will leave it for now just in case.
			
			for file in XGFolders.AutoFSYS.files where file.fileType == .fsys {
				let msg = XGFiles.msg(file.fileName.removeFileExtensions())
				if !msg.exists {
					if verbose {
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
	
	@objc func extractStringTables() {
		extractAutoStringTables()
		extractSpecificStringTables()
	}
	
	@objc func extractScripts() {
		for file in XGFolders.AutoFSYS.files + XGFolders.MenuFSYS.files where file.fileType == .fsys {
			let scd = XGFiles.scd(file.fileName.removeFileExtensions())
			if !scd.exists {
				if verbose {
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
	
	@objc func extractRels() {
		for file in XGFolders.AutoFSYS.files + XGFolders.MenuFSYS.files where file.fileType == .fsys {
			let rel = XGFiles.rel(file.fileName.removeFileExtensions())
			if !rel.exists {
				if verbose {
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
	
	@objc func extractCols() {
		for file in XGFolders.AutoFSYS.files + XGFolders.MenuFSYS.files where file.fileType == .fsys {
			let col = XGFiles.col(file.fileName.removeFileExtensions())
			if !col.exists {
				if verbose {
					printg("extracting col: \(col.fileName)")
				}
				let fsys = file.fsysData
				let data = fsys.decompressedDataForFileWithFiletype(type: .col)
				if let d = data {
					d.file = col
					d.save()
				}
			}
		}
	}
	
	@objc func extractDOL() {
		stringsLoaded = false
		if !XGFiles.dol.exists {
			let dol = dataForFile(filename: XGFiles.dol.fileName)!
			dol.file = .dol
			dol.save()
		}
	}
	
	 @objc class func extractAllFiles() {
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
		printg("extraction complete")
	}
	
}



























































