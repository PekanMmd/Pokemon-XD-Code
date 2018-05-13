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

enum XGRegions : UInt32 {
	
	case US = 0x47585845
	case EU = 0x47585850
	case JP = 0x4758584A
	
}

enum XGGame {
	case Colosseum
	case XD
}

var tocData = XGISO.extractTOC()
class XGISO: NSObject {
	
	fileprivate var fileLocations = [String : Int]()
//	fileprivate var fileLocations = ["Start.dol" : 131840]
//	fileprivate var fileLocations = ["Start.dol" : 0x1EC00] colosseum
	
	fileprivate var fileSizes = [String : Int]()
//	fileprivate var fileSizes = ["Start.dol" : 0x39AD00] colosseum
	
	fileprivate var fileDataOffsets = [String : Int]() // in toc
	
	var allFileNames = [String]()
	var filesOrdered = [String]()
	
	var data = XGFiles.iso.data
	
	let TOCFirstStringOffset = Int(XGFiles.toc.data.get4BytesAtOffset(kTOCNumberEntriesOffset)) * kTOCEntrySize
	
	override init() {
		super.init()
		
		
		let DOLStart = Int(self.data.get4BytesAtOffset(kDOLStartOffsetLocation))
		let TOCStart = Int(self.data.get4BytesAtOffset(kTOCStartOffsetLocation))
		let TOCLength = Int(self.data.get4BytesAtOffset(kTOCFileSizeLocation))
		
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
	}
	
	func updateISO() {
		
		var files = XGFolders.FSYS.files ?? [XGFiles]()
		files.append(.dol)
		importFiles(files)
		
	}
	
	func importRandomiserFiles() {
		var files = XGFolders.FSYS.files ?? [XGFiles]()
		files.append(.dol)
		importFiles(files)
	}
	
	func importAllFiles() {
		var files = XGFolders.FSYS.files ?? [XGFiles]()
		files += XGFolders.AutoFSYS.files ?? [XGFiles]()
		files += XGFolders.MenuFSYS.files ?? [XGFiles]()
		files.append(.dol)
		importFiles(files)
		importToc(saveWhenDone: true)
	}
	
	func importDol() {
		importFiles([.dol])
	}
	
	func importToc(saveWhenDone save: Bool) {
		
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
		
		let data = self.data
		let bytes = data.getCharStreamFromOffset(start!, length: size!)
		
		return XGMutableData(byteStream: bytes, file: XGFiles.nameAndFolder(filename, .Documents))
		
	}
	
	func replaceDataForFile(filename: String, withData data: XGMutableData) {
		
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
		print("shift and replacing file:", file.fileName)
		if self.allFileNames.contains(file.fileName) {
			self.shiftAndReplaceFile(name: file.fileName, withData: file.data)
		} else {
			print("file not found:", file.fileName)
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
	
	
	func eraseDataForFile(name: String) {
		
		let start = self.locationForFile(name)
		let size = self.sizeForFile(name)
		
		if start == nil || size == nil {
			printg("file not found:", name)
			return
		}
		
		eraseData(start: start!, length: size!)
	}
	
	func eraseData(start: Int, length: Int) {
		self.data.nullBytes(start: start, length: length)
	}
	
	func deleteFile(name: String, save: Bool) {
		eraseDataForFile(name: name)
		setSize(size: 0, forFile: name)
		if save {
			self.data.save()
		}
		printg("deleted iso file:", name)
	}
	
	func deleteFileAndPreserve(name: String, save: Bool) {
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
	
	func setSize(size: Int, forFile name: String) {
		let start = fileDataOffsets[name]
		if start != nil {
			let toc = XGFiles.toc.data
			toc.replace4BytesAtOffset(start! + 8, withBytes: UInt32(size))
			self.importToc(saveWhenDone: false)
		}
		fileSizes[name] = size
	}
	
	func setStartOffset(offset: Int, forFile name: String) {
		let start = fileDataOffsets[name]
		if start != nil {
			let toc = XGFiles.toc.data
			toc.replace4BytesAtOffset(start! + 4, withBytes: UInt32(offset))
			self.importToc(saveWhenDone: false)
			fileLocations[name] = offset
		} else {
			print("couldn't find toc data for file:", name)
		}
		
	}
	
	func orderedIndexForFile(name: String) -> Int {
		for i in 0 ..< allFileNames.count {
			if filesOrdered[i] == name {
				return i
			}
		}
		return -1
	}
	
	func shiftUpFile(name: String) {
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
	
	func shiftDownFile(name: String) {
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
	
	func moveFile(name: String, toOffset startOffset: Int) {
		
		if startOffset == locationForFile(name)! {
			return
		}
		
		printg("Moving iso file:", name, "to:", startOffset.hexString())
		
		let bytes = self.dataForFile(filename: name)!.byteStream
		
		self.eraseData(start: locationForFile(name)!, length: sizeForFile(name)!)
		self.setStartOffset(offset: startOffset, forFile: name)
		
		self.data.replaceBytesFromOffset(startOffset, withByteStream: bytes)
	}
	
	func save() {
		printg("saving iso...")
		self.data.save()
	}
	
	class func extractTOC() -> XGMutableData {
		let iso = XGFiles.iso.data

		// US
//		let TOCStart = 0x442100
//		let TOCLength = 0x15958
		
		let TOCStart = Int(iso.get4BytesAtOffset(kTOCStartOffsetLocation))
		let TOCLength = Int(iso.get4BytesAtOffset(kTOCFileSizeLocation))
		
		let bytes = iso.getCharStreamFromOffset(TOCStart, length: TOCLength)
		
		return XGMutableData(byteStream: bytes, file: .toc)
		
	}
	
	func getPKXModelWithIdentifier(id: UInt32) -> XGFsys? {
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
	
	var autoFsysList : [String] {
		return [
			"D1_labo_1F.fsys",
			"D1_labo_B1.fsys",
			"D1_labo_B2.fsys",
			"D1_labo_B3.fsys",
			"D1_out.fsys",
			"D2_cloud_1.fsys",
			"D2_cloud_2.fsys",
			"D2_cloud_3.fsys",
			"D2_cloud_4.fsys",
			"D2_crater_colo.fsys",
			"D2_magma_1.fsys",
			"D2_magma_2.fsys",
			"D2_magma_3.fsys",
			"D2_out.fsys",
			"D2_pc_1F.fsys",
			"D2_rest_1.fsys",
			"D2_rest_2.fsys",
			"D2_rest_3.fsys",
			"D2_rest_4.fsys",
			"D2_rest_5.fsys",
			"D2_rest_6.fsys",
			"D2_rest_7.fsys",
			"D2_rest_8.fsys",
			"D2_rest_9.fsys",
			"D2_valley_1.fsys",
			"D2_valley_2.fsys",
			"D2_valley_3.fsys",
			"D3_out.fsys",
			"D3_ship_B1_1.fsys",
			"D3_ship_B1_2.fsys",
			"D3_ship_B1_3.fsys",
			"D3_ship_B2_1.fsys",
			"D3_ship_B2_2.fsys",
			"D3_ship_B2_3.fsys",
			"D3_ship_bridge.fsys",
			"D3_ship_cabine.fsys",
			"D3_ship_deck.fsys",
			"D4_dome_3.fsys",
			"D4_dome_4.fsys",
			"D4_out.fsys",
			"D4_out_2.fsys",
			"D4_tower_1F_1.fsys",
			"D4_tower_1F_2.fsys",
			"D4_tower_1F_3.fsys",
			"D5_factory_1F.fsys",
			"D5_factory_2F.fsys",
			"D5_factory_3F.fsys",
			"D5_factory_4F.fsys",
			"D5_factory_B1.fsys",
			"D5_factory_hat.fsys",
			"D5_factory_top.fsys",
			"D5_out.fsys",
			"D6_cruiser.fsys",
			"D6_dome_1F.fsys",
			"D6_dome_2F.fsys",
			"D6_dome_B1.fsys",
			"D6_fort_1F.fsys",
			"D6_fort_2F_1.fsys",
			"D6_fort_2F_2.fsys",
			"D6_fort_2F_3.fsys",
			"D6_fort_3F_1.fsys",
			"D6_fort_3F_2.fsys",
			"D6_fort_4F.fsys",
			"D6_fort_5F.fsys",
			"D6_fort_6F.fsys",
			"D6_fort_B1.fsys",
			"D6_out_all.fsys",
			"D6_out_dome.fsys",
			"D6_out_foot.fsys",
			"D7_out.fsys",
			"esaba_A.fsys",
			"esaba_B.fsys",
			"esaba_C.fsys",
			"M1_carde_1.fsys",
			"M1_gym_1F.fsys",
			"M1_gym_B1.fsys",
			"M1_houseA_1F.fsys",
			"M1_houseA_2F.fsys",
			"M1_houseB_1F.fsys",
			"M1_houseC_1F.fsys",
			"M1_out.fsys",
			"M1_pc_1F.fsys",
			"M1_pc_B1.fsys",
			"M1_shop_1F.fsys",
			"M1_shop_2F.fsys",
			"M1_water_colo_field.fsys",
			"M2_building_1F.fsys",
			"M2_building_2F.fsys",
			"M2_building_3F.fsys",
			"M2_building_4F.fsys",
			"M2_enter_1F.fsys",
			"M2_enter_1F_2.fsys",
			"M2_guild_1F_1.fsys",
			"M2_guild_1F_2.fsys",
			"M2_hotel_1F.fsys",
			"M2_houseA_1F.fsys",
			"M2_out.fsys",
			"M2_police_1F.fsys",
			"M2_shop_1F.fsys",
			"M2_uranai_1F.fsys",
			"M2_windmill_1F.fsys",
			"M3_cave_1F_1.fsys",
			"M3_cave_1F_2.fsys",
			"M3_houseA_1F.fsys",
			"M3_houseB_1F.fsys",
			"M3_houseC_1F.fsys",
			"M3_houseC_2F.fsys",
			"M3_houseD_1F.fsys",
			"M3_out.fsys",
			"M3_pc_1F.fsys",
			"M3_shop_1F.fsys",
			"M3_shrine_1F.fsys",
			"M5_apart_1F.fsys",
			"M5_apart_2F.fsys",
			"M5_labo_1F.fsys",
			"M5_labo_2F.fsys",
			"M5_labo_B1.fsys",
			"M5_out.fsys",
			"M6_crab_1F.fsys",
			"M6_crab_2F.fsys",
			"M6_crab_B1.fsys",
			"M6_houseA.fsys",
			"M6_houseB.fsys",
			"M6_houseC.fsys",
			"M6_houseD.fsys",
			"M6_junk_1F.fsys",
			"M6_junk_2F.fsys",
			"M6_out.fsys",
			"M6_pc_1F.fsys",
			"M6_pc_2F.fsys",
			"M6_shop_1F.fsys",
			"M6_shop_2F.fsys",
			"M6_tower_1F.fsys",
			"M6_tower_2F.fsys",
			"M6_tower_4F.fsys",
			"M6_tower_top.fsys",
			"S1_out.fsys",
			"S1_shop_1F.fsys",
			"S2_bossroom_1.fsys",
			"S2_building_1F_2.fsys",
			"S2_building_2F_2.fsys",
			"S2_building_3F_2.fsys",
			"S2_hallway_1.fsys",
			"S2_out_1.fsys",
			"S2_out_2.fsys",
			"S2_out_3.fsys",
			"S2_snatchroom_1.fsys",
			"S3_labo_1F.fsys",
			"S3_labo_B1low.fsys",
			"S3_labo_B1up.fsys",
			"S3_out.fsys"
		]
	}
	
	var fsysList : [String] {
		return [
			"common.fsys",
			"common_dvdeth.fsys",
			"deck_archive.fsys",
			"field_common.fsys",
			"fight_common.fsys",
			"people_archive.fsys"
		]
	}
	
	var menuFsysList : [String] {
		return [
			"battle_disk.fsys",
			"bingo_menu.fsys",
			"carde_menu.fsys",
			"colosseumbattle_menu.fsys",
			"D2_present_room.fsys",
			"hologram_menu.fsys",
			"mailopen_menu.fsys",
			"mewwaza.fsys",
			"name_entry_menu.fsys",
			"orre_menu.fsys",
			"pcbox_menu.fsys",
			"pcbox_name_entry_menu.fsys",
			"pcbox_pocket_menu.fsys",
			"pda_menu.fsys",
			"pocket_menu.fsys",
			"pokemonchange_menu.fsys",
			"relivehall_menu.fsys",
			"title.fsys",
			"topmenu.fsys",
			"waza_menu.fsys",
			"worldmap.fsys"
		]
	}
	
	var deckList : [String] {
		return [
			"DeckData_DarkPokemon.bin",
			"DeckData_Story.bin",
			"DeckData_Bingo.bin",
			"DeckData_Colosseum.bin",
			"DeckData_Hundred.bin",
			"DeckData_Imasugu.bin",
			"DeckData_Sample.bin",
			"DeckData_Virtual.bin"
		]
	}
	
	func extractAutoFSYS() {
		
		if region != .EU {
			for file in self.autoFsysList {
				let xgf = XGFiles.nameAndFolder(file, .AutoFSYS)
				if !xgf.exists {
					let data = dataForFile(filename: file)!
					data.file = xgf
					data.save()
				}
			}
		}
	}
	
	func extractMenuFSYS() {
		for file in self.menuFsysList {
			let xgf = XGFiles.nameAndFolder(file, .MenuFSYS)
			if !xgf.exists {
				let data = dataForFile(filename: file)!
				data.file = xgf
				data.save()
			}
		}
	}
	
	func extractFSYS() {
		for file in self.fsysList {
			let xgf = XGFiles.nameAndFolder(file, .FSYS)
			if !xgf.exists {
				let data = dataForFile(filename: file)!
				data.file = xgf
				data.save()
			}
		}
	}
	
	func extractAllFSYS() {
		extractAutoFSYS()
		extractMenuFSYS()
		extractFSYS()
	}
	
	func extractCommon() {
		if !XGFiles.common_rel.exists {
			let rel = XGFiles.fsys("common.fsys").fsysData.decompressedDataForFileWithIndex(index: 0)!
			rel.file = .common_rel
			rel.save()
		}
		if !XGFiles.tableres2.exists {
			let tableres2 = XGFiles.fsys("common_dvdeth.fsys").fsysData.decompressedDataForFileWithIndex(index: 0)!
			tableres2.file = .tableres2
			tableres2.save()
		}
		if !XGFiles.nameAndFolder("pocket_menu.fdat", .Common).exists {
			let pocket = XGFiles.nameAndFolder("pocket_menu.fsys",.MenuFSYS).fsysData.decompressedDataForFileWithIndex(index: 0)!
			pocket.file = .nameAndFolder("pocket_menu.fdat", .Common)
			pocket.save()
		}
		
	}
	
	func extractDecks() {
		let deck = XGFiles.fsys("deck_archive.fsys").fsysData
		let deckFiles : [XGFiles] = [.deck(.DeckColosseum), .deck(.DeckDarkPokemon), .deck(.DeckHundred), .deck(.DeckStory), .deck(.DeckVirtual), .deck(.DeckImasugu), .deck(.DeckSample), .deck(.DeckBingo)]
		
		if !deckFiles[0].exists {
			let deckFile = deck.decompressedDataForFileWithIndex(index: 2)!
			deckFile.file = deckFiles[0]
			deckFile.save()
		}
		
		if !deckFiles[1].exists {
			let deckFile = deck.decompressedDataForFileWithIndex(index: 4)!
			deckFile.file = deckFiles[1]
			deckFile.save()
		}
		
		if !deckFiles[2].exists {
			let deckFile = deck.decompressedDataForFileWithIndex(index: 6)!
			deckFile.file = deckFiles[2]
			deckFile.save()
		}
		
		if !deckFiles[3].exists {
			let deckFile = deck.decompressedDataForFileWithIndex(index: 12)!
			deckFile.file = deckFiles[3]
			deckFile.save()
		}
		
		if !deckFiles[4].exists {
			let deckFile = deck.decompressedDataForFileWithIndex(index: 14)!
			deckFile.file = deckFiles[4]
			deckFile.save()
		}
		
		if !deckFiles[5].exists {
			let deckFile = deck.decompressedDataForFileWithIndex(index: 8)!
			deckFile.file = deckFiles[5]
			deckFile.save()
		}
		
		if !deckFiles[6].exists {
			let deckFile = deck.decompressedDataForFileWithIndex(index: 10)!
			deckFile.file = deckFiles[6]
			deckFile.save()
		}
		
		if !deckFiles[7].exists {
			let deckFile = deck.decompressedDataForFileWithIndex(index: 0)!
			deckFile.file = deckFiles[7]
			deckFile.save()
		}
		
	}
	
	func extractAutoStringTables() {
		
		if region != .EU {
			
			for file in XGFolders.AutoFSYS.filenames where file.fileExtensions == ".fsys" {
				let msg = file.replacingOccurrences(of: ".fsys", with: ".msg")
				if !XGFiles.stringTable(msg).exists {
					let fsys = XGFiles.nameAndFolder(file, .AutoFSYS).fsysData
					let data = fsys.decompressedDataForFileWithIndex(index: 2)!
					data.file = .stringTable(msg)
					data.save()
				}
			}
		}
	}
	
	func extractSpecificStringTables() {
		
		let fightFile = XGFiles.stringTable("fight.msg")
		if !fightFile.exists {
			let fight = XGFiles.fsys("fight_common.fsys").fsysData.decompressedDataForFileWithIndex(index: 0)!
			fight.file = fightFile
			fight.save()
		}
		
		
		let pocket_menu = XGFiles.stringTable("pocket_menu.msg")
		let nameentrymenu = XGFiles.stringTable("name_entry_menu.msg")
		let system_tool = XGFiles.stringTable("system_tool.msg")
		let m3shrine1frl = XGFiles.stringTable("M3_shrine_1F_rl.msg")
		let relivehall_menu = XGFiles.stringTable("relivehall_menu.msg")
		let pda_menu = XGFiles.stringTable("pda_menu.msg")
		let p_exchange = XGFiles.stringTable("p_exchange.msg")
		let world_map = XGFiles.stringTable("world_map.msg")
		
		if !pocket_menu.exists {
			let pm = XGFiles.nameAndFolder("pcbox_pocket_menu.fsys",.MenuFSYS).fsysData.decompressedDataForFileWithIndex(index: 0)!
			pm.file = pocket_menu
			pm.save()
		}
		
		if !nameentrymenu.exists {
			let nem = XGFiles.nameAndFolder("pcbox_name_entry_menu.fsys",.MenuFSYS).fsysData.decompressedDataForFileWithIndex(index: 0)!
			nem.file = nameentrymenu
			nem.save()
		}
		
		if !system_tool.exists {
			let st = XGFiles.nameAndFolder("pcbox_menu.fsys",.MenuFSYS).fsysData.decompressedDataForFileWithIndex(index: 0)!
			st.file = system_tool
			st.save()
		}
		
		if !m3shrine1frl.exists {
			let m3rl = XGFiles.nameAndFolder("hologram_menu.fsys",.MenuFSYS).fsysData.decompressedDataForFileWithIndex(index: 0)!
			m3rl.file = m3shrine1frl
			m3rl.save()
		}
		
		if !relivehall_menu.exists {
			let rh = XGFiles.nameAndFolder("relivehall_menu.fsys",.MenuFSYS).fsysData.decompressedDataForFileWithIndex(index: 0)!
			rh.file = relivehall_menu
			rh.save()
		}
		
		if !pda_menu.exists {
			let pda = XGFiles.nameAndFolder("pda_menu.fsys",.MenuFSYS).fsysData.decompressedDataForFileWithIndex(index: 2)!
			pda.file = pda_menu
			pda.save()
		}
		
		if !p_exchange.exists {
			let pex = XGFiles.nameAndFolder("pokemonchange_menu.fsys",.MenuFSYS).fsysData.decompressedDataForFileWithIndex(index: 2)!
			pex.file = p_exchange
			pex.save()
		}
		
		if !world_map.exists {
			let wm = XGFiles.nameAndFolder("worldmap.fsys",.MenuFSYS).fsysData.decompressedDataForFileWithIndex(index: 1)!
			wm.file = world_map
			wm.save()
		}
	}
	
	func extractStringTables() {
		extractAutoStringTables()
		extractSpecificStringTables()
		
	}
	
	func extractScripts() {
		for file in XGFolders.AutoFSYS.files where autoFsysList.contains(file.fileName) {
			let scd = XGFiles.script(file.fileName.replacingOccurrences(of: ".fsys", with: ".scd"))
			if !scd.exists {
				let fsys = file.fsysData
				let data = fsys.decompressedDataForFileWithIndex(index: 1)!
				data.file = scd
				data.save()
			}
		}
	}
	
	func extractRels() {
		for file in XGFolders.AutoFSYS.files where autoFsysList.contains(file.fileName) {
			let rel = XGFiles.rel(file.fileName.replacingOccurrences(of: ".fsys", with: ".rel"))
			if !rel.exists {
				let fsys = file.fsysData
				let data = fsys.decompressedDataForFileWithIndex(index: 0)!
				data.file = rel
				data.save()
			}
		}
	}
	
	func extractDOL() {
		if !XGFiles.dol.exists {
			let dol = dataForFile(filename: "Start.dol")!
			dol.file = .dol
			dol.save()
		}
	}
	
	class func extractRandomiserFiles() {
		extractTOC()
		let iso = XGISO()
		iso.extractDOL()
		iso.extractFSYS()
		iso.extractMenuFSYS()
		iso.extractDecks()
		iso.extractSpecificStringTables()
		
		if !XGFiles.common_rel.exists {
			iso.extractCommon()
			
			if region == .US {
				// purges a foreign string table for compression size, 3 more are available but shouldn't be necessary
				XGStringTable(file: .common_rel, startOffset: 0x9533C, fileSize: 0xD334).purge()
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
	
	 class func extractAllFiles() {
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
	}
	
}



























































