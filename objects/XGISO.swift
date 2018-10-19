//
//  XGISO.swift
//  XGCommandLineTools
//
//  Created by StarsMmd on 15/04/2016.
//  Copyright © 2016 StarsMmd. All rights reserved.
//

import Foundation

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
	
	@objc var data = XGFiles.iso.data
	
	@objc let TOCFirstStringOffset = Int(XGFiles.toc.data.get4BytesAtOffset(kTOCNumberEntriesOffset)) * kTOCEntrySize
	
	override init() {
		super.init()
		
		printg("Initialising ISO...")
		
		if !self.data.file.exists {
			printg("ISO file doesn't exist. Please place your \(game == .XD ? "Pokemon XD" : "Pokemon Colosseum") file in the folder \(XGFolders.ISO.path) and name it \(self.data.file.fileName)")
		}
		
		printg("ISO size: \(self.data.length.hexString())")
		
		let DOLStart = Int(self.data.get4BytesAtOffset(kDOLStartOffsetLocation))
		let TOCStart = Int(self.data.get4BytesAtOffset(kTOCStartOffsetLocation))
		let TOCLength = Int(self.data.get4BytesAtOffset(kTOCFileSizeLocation))
		
		printg("DOL start: \(DOLStart.hexString()), TOC start: \(TOCStart.hexString()), TOC size: \(TOCLength.hexString())")
		
		fileLocations["Start.dol"] = DOLStart
		fileLocations["Game.toc"] = TOCStart
		fileSizes["Game.toc"] = TOCLength
		
		let kDolSectionSizesStart = 0x90
		let kDolSectionSizesCount = 18
		let kDolHeaderSize = 0x100
		
		var size = kDolHeaderSize
		for i in 0 ..< kDolSectionSizesCount {
			let offset = DOLStart + (i * 4) + kDolSectionSizesStart
			size += Int(self.data.get4BytesAtOffset(offset))
		}
		fileSizes["Start.dol"] = size
		printg("DOL size: \(size.hexString())")
		
		var i = 0x0
		
		while (i < TOCFirstStringOffset) {
			
			let folder = tocData.getByteAtOffset(i) == 1
			
			if !folder {
				
				let nameOffset = Int(tocData.get4BytesAtOffset(i))
				let fileOffset = Int(tocData.get4BytesAtOffset(i + 4))
				let fileSize   = Int(tocData.get4BytesAtOffset(i + 8))
				
				let fileName = getStringAtOffset(nameOffset).string
				
				allFileNames.append(fileName)
				fileLocations[fileName] = fileOffset
				fileSizes[fileName]     = fileSize
				fileDataOffsets[fileName] = i
				
			}
			
			i += 0xC
		}
		
		self.filesOrdered = allFileNames.sorted { (s1, s2) -> Bool in
			return locationForFile(s1)! < locationForFile(s2)!
		}
		
		if verbose {
			for file in filesOrdered {
				printg("found file \(file) @offset \(locationForFile(file)!.hexString())")
			}
		}
		
		printg("ISO initialised.")
	}
	
	@objc func updateISO() {
		
		var files = XGFolders.FSYS.files ?? [XGFiles]()
		files.append(.dol)
		importFiles(files)
		
	}
	
	@objc func importRandomiserFiles() {
		var files = XGFolders.FSYS.files ?? [XGFiles]()
		files.append(.dol)
		importFiles(files)
	}
	
	@objc func importAllFiles() {
		var files = XGFolders.FSYS.files ?? [XGFiles]()
		files += XGFolders.AutoFSYS.files ?? [XGFiles]()
		files += XGFolders.MenuFSYS.files ?? [XGFiles]()
		files.append(.dol)
		importFiles(files)
//		importToc(saveWhenDone: true)
	}
	
	@objc func importDol() {
		importFiles([.dol])
	}
	
	@objc func importToc(saveWhenDone save: Bool) {
		
		let TOCStart = Int(self.data.get4BytesAtOffset(kTOCStartOffsetLocation))
		let toc = XGFiles.toc.data.byteStream
		self.data.replaceBytesFromOffset(TOCStart, withByteStream: toc)
		if save {
			self.data.save()
		}
		
	}

	func importFiles(_ fileList: [XGFiles]) {
		
		let isodata = self.data
		
		for file in fileList {
			
			let filename = file.fileName
			let data = file.data
			
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
				continue
			}
			
			var byteStream = data.byteStream
			if newsize < oldsize! {
				byteStream += [Int](repeatElement(0, count: oldsize! - newsize))
			}
			
			isodata.replaceBytesFromOffset(start!, withByteStream: byteStream)
		}
		
		isodata.save()
	}
	
	fileprivate func getStringAtOffset(_ offset: Int) -> XGString {
		
		var currentOffset = offset + TOCFirstStringOffset
		
		var currChar = 0x0
		var nextChar = 0x1
		
		let string = XGString(string: "", file: nil, sid: nil)
		
		while (nextChar != 0x00) {
			
			currChar = tocData.getByteAtOffset(currentOffset)
			currentOffset += 1
			
			string.append(.unicode(currChar))
			
			nextChar = tocData.getByteAtOffset(currentOffset)
			
		}
		
		return string
		
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
	
	@objc func replaceDataForFile(filename: String, withData data: XGMutableData) {
		
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
			return
		}
		
		self.setSize(size: newsize, forFile: filename)
		
		let isodata = self.data
		isodata.replaceBytesFromOffset(start!, withByteStream: data.byteStream)
		isodata.save()
		
	}
	
	func shiftAndReplaceFile(_ file: XGFiles) {
		printg("shift and replacing file:", file.fileName)
		if self.allFileNames.contains(file.fileName) {
			self.shiftAndReplaceFile(name: file.fileName, withData: file.data)
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
		
		self.replaceDataForFile(filename: name, withData: newData)
		
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
	
	@objc func eraseData(start: Int, length: Int) {
		self.data.nullBytes(start: start, length: length)
	}
	
	@objc func deleteFile(name: String, save: Bool) {
		eraseDataForFile(name: name)
		setSize(size: 0, forFile: name)
		if save {
			self.data.save()
		}
		printg("deleted iso file:", name)
	}
	
	@objc func deleteFileAndPreserve(name: String, save: Bool) {
		// replaces file with a dummy fsys container
		eraseDataForFile(name: name)
		setSize(size: NullFSYS.length, forFile: name)
		if locationForFile(name) != nil {
			self.data.replaceBytesFromOffset(locationForFile(name)!, withByteStream: NullFSYS.byteStream)
		}
		if save {
			self.data.save()
		}
		printg("deleted iso file:", name)
	}
	
	@objc func setSize(size: Int, forFile name: String) {
		let start = fileDataOffsets[name]
		if start != nil {
			let toc = XGFiles.toc.data
			toc.replaceWordAtOffset(start! + 8, withBytes: UInt32(size))
			self.importToc(saveWhenDone: false)
		}
		fileSizes[name] = size
	}
	
	@objc func setStartOffset(offset: Int, forFile name: String) {
		let start = fileDataOffsets[name]
		if start != nil {
			let toc = XGFiles.toc.data
			toc.replaceWordAtOffset(start! + 4, withBytes: UInt32(offset))
			self.importToc(saveWhenDone: false)
			fileLocations[name] = offset
		} else {
			printg("couldn't find toc data for file:", name)
		}
		
	}
	
	@objc func orderedIndexForFile(name: String) -> Int {
		for i in 0 ..< allFileNames.count {
			if filesOrdered[i] == name {
				return i
			}
		}
		return -1
	}
	
	@objc func shiftUpFile(name: String) {
		// used to push a file closer to the file above it and create more space for other files
		var previousEnd = 0x0
		let index = orderedIndexForFile(name: name)
		
		if orderedIndexForFile(name: "bg2thumbcode.bin") >= index || orderedIndexForFile(name: "stm_bgm_00seaside32.fsys") <= index {
			return
		}
		
		if index == 0 {
			previousEnd = self.data.get4BytesAtOffset(kISOFirstFileOffsetLocation).int
		} else {
			let previous = filesOrdered[index - 1]
			previousEnd = self.locationForFile(previous)! + sizeForFile(previous)!
		}
		
		if locationForFile(name)! - previousEnd > 0x20 {
			while previousEnd % 16 != 0 {
				previousEnd += 1 // byte alignment is required or game doesn't load
			}
			self.moveFile(name: name, toOffset: previousEnd)
		}
		
	}
	
	@objc func shiftDownFile(name: String) {
		// used to push a file closer to the file below it and create more space for other files
		let size  = sizeForFile(name)!
		let index = orderedIndexForFile(name: name)
		
		if orderedIndexForFile(name: "bg2thumbcode.bin") >= index || orderedIndexForFile(name: "stm_bgm_00seaside32.fsys") <= index {
			return
		}
		
		let nextStart = index == allFileNames.count - 1 ? self.data.length : locationForFile(filesOrdered[index + 1])!
		
		var start = nextStart - size
		
		if start - locationForFile(name)! > 0x20 {
			
			while start % 16 != 0 {
				start -= 1 // byte alignment is required or game doesn't load
			}
			
			self.moveFile(name: name, toOffset: start)
		}
		
	}
	
	@objc func moveFile(name: String, toOffset startOffset: Int) {
		
		if startOffset == locationForFile(name)! {
			return
		}
		
		printg("Moving iso file:", name, "to:", startOffset.hexString())
		
		let bytes = self.dataForFile(filename: name)!.byteStream
		
		self.eraseData(start: locationForFile(name)!, length: sizeForFile(name)!)
		self.setStartOffset(offset: startOffset, forFile: name)
		
		self.data.replaceBytesFromOffset(startOffset, withByteStream: bytes)
	}
	
	@objc func save() {
		printg("saving iso...")
		self.data.save()
	}
	
	@objc class func extractTOC() -> XGMutableData {
		let iso = XGFiles.iso.data

		// US
		//let TOCStart = 0x442100
		//let TOCLength = 0x15958
		
		let TOCStart = Int(iso.get4BytesAtOffset(kTOCStartOffsetLocation))
		let TOCLength = Int(iso.get4BytesAtOffset(kTOCFileSizeLocation))
		
		let bytes = iso.getCharStreamFromOffset(TOCStart, length: TOCLength)
		
		return XGMutableData(byteStream: bytes, file: .toc)
		
	}
	
	@objc func getPKXModelWithIdentifier(id: UInt32) -> XGFsys? {
		for file in self.allFileNames where file.contains("pkx") {
			let start = self.locationForFile(file)!
			
			let details = self.data.get4BytesAtOffset(start + 0x60) // first fsys file details pointer
			let identifier = self.data.get4BytesAtOffset(start + Int(details))
			
			if identifier == id {
				return self.dataForFile(filename: file)!.fsysData
			}
			
		}
		return nil
	}
	
	@objc func extractAutoFSYS() {
		
		if region != .EU {
			for file in self.autoFsysList {
				let xgf = XGFiles.nameAndFolder(file, .AutoFSYS)
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
	}
	
	@objc func extractMenuFSYS() {
		for file in self.menuFsysList {
			let xgf = XGFiles.nameAndFolder(file, .MenuFSYS)
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
		if !XGFiles.common_rel.exists {
			let rel = XGFiles.fsys("common.fsys").fsysData.decompressedDataForFileWithIndex(index: 0)!
			rel.file = .common_rel
			rel.save()
		}
		
		if game == .XD {
			if !XGFiles.tableres2.exists {
				let tableres2 = XGFiles.fsys("common_dvdeth.fsys").fsysData.decompressedDataForFileWithIndex(index: 0)!
				tableres2.file = .tableres2
				tableres2.save()
			}
		}
		
		if !XGFiles.nameAndFolder("pocket_menu.rel", .Common).exists {
			let pocket = XGFiles.nameAndFolder("pocket_menu.fsys",.MenuFSYS).fsysData.decompressedDataForFileWithIndex(index: 0)!
			pocket.file = .nameAndFolder("pocket_menu.rel", .Common)
			pocket.save()
		}
		
	}
	
	@objc func extractAutoStringTables() {
		
		if region != .EU {
			
			for file in XGFolders.AutoFSYS.filenames where file.fileExtensions == ".fsys" {
				let msg = XGFiles.stringTable(file.replacingOccurrences(of: ".fsys", with: ".msg"))
				if !msg.exists {
					if verbose {
						printg("extracting msg: \(msg.fileName)")
					}
					let fsys = XGFiles.nameAndFolder(file, .AutoFSYS).fsysData
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
		for file in XGFolders.AutoFSYS.files where autoFsysList.contains(file.fileName) {
			let scd = XGFiles.script(file.fileName.replacingOccurrences(of: ".fsys", with: ".scd"))
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
		for file in XGFolders.AutoFSYS.files where autoFsysList.contains(file.fileName) {
			let rel = XGFiles.rel(file.fileName.replacingOccurrences(of: ".fsys", with: ".rel"))
			if !rel.exists {
				if verbose {
					printg("extracting rel: \(rel.fileName)")
				}
				let fsys = file.fsysData
				let data = fsys.decompressedDataForFileWithFiletype(type: .rel)
				if let d = data {
					d.file = rel
					d.save()
				}
			}
		}
	}
	
	@objc func extractCols() {
		for file in XGFolders.AutoFSYS.files where autoFsysList.contains(file.fileName) {
			let col = XGFiles.col(file.fileName.replacingOccurrences(of: ".fsys", with: ".col"))
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
		if !XGFiles.dol.exists {
			let dol = dataForFile(filename: "Start.dol")!
			dol.file = .dol
			dol.save()
		}
	}
	
	@objc class func extractRandomiserFiles() {
		extractTOC()
		let iso = XGISO()
		iso.extractDOL()
		iso.extractFSYS()
		iso.extractMenuFSYS()
		iso.extractDecks()
		iso.extractSpecificStringTables()
		
		if !XGFiles.common_rel.exists {
			iso.extractCommon()
			
			if XGFiles.common_rel.data.get4BytesAtOffset(0x7e764) != 0x002d0000 {
				XGDolPatcher.zeroForeignStringTables()
			}
			
		}
		
		// for pokespots
		for name in ["M2_guild_1F_2.fsys"] {
			let file = XGFiles.nameAndFolder(name, .AutoFSYS)
			if !file.exists {
				let data = iso.dataForFile(filename: name)!
				data.file = file
				data.save()
			}
		}
		
		iso.extractScripts()
	}
	
	 @objc class func extractAllFiles() {
		let iso = XGISO()
		printg("extracting: Start.dol")
		iso.extractDOL()
		printg("extracting: FSYS archives")
		iso.extractAllFSYS()
		printg("extracting: common")
		iso.extractCommon()
		printg("extracting: decks")
		iso.extractDecks()
		printg("extracting: string tables")
		iso.extractStringTables()
		printg("extracting: scripts")
		iso.extractScripts()
		printg("extracting: relocatable files")
		iso.extractRels()
		printg("extracting: collision data")
		iso.extractCols()
	}
	
}



























































