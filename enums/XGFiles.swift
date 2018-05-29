//
//  XGDecks.swift
//  XG Tool
//
//  Created by StarsMmd on 30/05/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

func ==(lhs: XGFiles, rhs: XGFiles) -> Bool {
	return lhs.path == rhs.path
}

var loadedFiles = [String : XGMutableData]()
var loadedStringTables = [String : XGStringTable]()

let loadableFiles = [XGFiles.common_rel.path,XGFiles.dol.path,XGDecks.DeckStory.file.path,XGDecks.DeckDarkPokemon.file.path, XGFiles.iso.path,XGFiles.original(.common_rel).path,XGFiles.original(.dol).path,XGFiles.original(.tableres2).path, XGFiles.fsys("people_archive.fsys").path, XGFiles.pocket_menu.path]
let loadableStringTables = [XGFiles.tableres2.path,XGFiles.stringTable("pocket_menu.msg").path,XGFiles.common_rel.path,XGFiles.dol.path,XGFiles.original(.common_rel).path,XGFiles.original(.dol).path,XGFiles.original(.tableres2).path]

let DeckDataEmptyLZSS = XGMutableData(byteStream: [0x4C, 0x5A, 0x53, 0x53, 0x00, 0x00, 0x01, 0xF4, 0x00, 0x00, 0x00, 0x54, 0x00, 0x00, 0x00, 0x00, 0xAF, 0x44, 0x45, 0x43, 0x4B, 0xEB, 0xF0, 0xD0, 0xEB, 0xF0, 0x02, 0xAE, 0xEA, 0xF2, 0x54, 0x4E, 0x52, 0xEB, 0xF0, 0x48, 0xEB, 0xF0, 0x01, 0x70, 0xDC, 0xFF, 0x1B, 0x0F, 0x2D, 0x0F, 0xE8, 0xF4, 0x50, 0x4B, 0x4D, 0xEB, 0xF0, 0x31, 0x30, 0x06, 0x0F, 0x5F, 0x0F, 0xFA, 0xF3, 0x41, 0x49, 0x4A, 0x0F, 0x8B, 0x0F, 0xD6, 0xE6, 0xF6, 0x53, 0x54, 0x01, 0x01, 0x18, 0xE6, 0xF5, 0x4E, 0x55, 0x03, 0x4C, 0x4C, 0x94, 0x01], file: .lzss("DeckData_Empty.bin.lzss"))

let NullFSYS = XGMutableData(byteStream: [0x46, 0x53, 0x59, 0x53, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                                          0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                                          0x00, 0x00, 0x00, 0x30, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                                          0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                                          0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                                          0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x0D, 0xE1, 0xE7, 0xED, 0x46, 0x53, 0x59, 0x53],
								          file: .fsys("Null.fsys"))

indirect enum XGFiles {
	
	case dol
	case common_rel			
	case tableres2
	case pocket_menu
	case deck(XGDecks)
	case pokeFace(Int)
	case pokeBody(Int)
	case typeImage(Int)
	case trainerFace(Int)
	case stringTable(String)
	case original(XGFiles)
	case fsys(String)
	case lzss(String)
	case script(String)
	case texture(String)
	case rel(String)
	case col(String)
	case iso
	case toc
	case log(Date)
	case nameAndFolder(String, XGFolders)
	
	var path : String {
		get{
			switch self {
				
			case .original:
				return folder.resourcePath + ("/" + self.fileName)
				
			default:
				return folder.path + ("/" + self.fileName)
			}
		}
	}
	
	var fileName : String {
		get {
			switch self {
				
				case .dol					: return "Start.dol"
				case .common_rel			: return "common.rel"
				case .tableres2				: return "tableres2.rel"
				case .pocket_menu			: return "pocket_menu.rel"
				case .deck(let deck)		: return deck.fileName
				case .pokeFace(let id)		: return "face_" + String(format: "%03d", id) + ".png"
				case .pokeBody(let id)		: return "body_" + String(format: "%03d", id) + ".png"
				case .typeImage(let id)		: return "type_" + String(id) + ".png"
				case .trainerFace(let id)	: return "trainer_" + String(id) + ".png"
				case .stringTable(let s)	: return s
				case .original(let o)		: return o.fileName
				case .fsys(let s)			: return s
				case .lzss(let s)			: return s
				case .script(let s)			: return s
				case .texture(let s)		: return s
				case .iso					: return "XD.iso"
				case .toc					: return "Game.toc"
				case .log(let d)			: return d.description
				case .rel(let s)			: return s
				case .col(let s)			: return s
				case .nameAndFolder(let name, _) : return name
				
			}
		}
	}
	
	var folder : XGFolders {
		get {
			var folder = XGFolders.Documents
			
			switch self {
				
				case .dol				: folder = .DOL
				case .common_rel		: folder = .Common
				case .tableres2			: folder = .Common
				case .pocket_menu		: folder = .Common
				case .deck				: folder = .Decks
				case .pokeFace			: folder = .PokeFace
				case .pokeBody			: folder = .PokeBody
				case .typeImage			: folder = .Types
				case .trainerFace		: folder = .Trainers
				case .stringTable		: folder = .StringTables
				case .fsys				: folder = .FSYS
				case .lzss				: folder = .LZSS
				case .script			: folder = .Scripts
				case .texture			: folder = .Textures
				case .iso				: folder = .ISO
				case .toc				: folder = .TOC
				case .log				: folder = .Logs
				case .rel				: folder = .Rels
				case .col				: folder = .Col
				case .original(let f)	: folder = f.folder
				case .nameAndFolder( _, let aFolder) : folder = aFolder
				
			}
			
			return folder
		}
	}

	var data : XGMutableData {
		get {
			if self == .toc {
				return tocData
			}
			
			if !self.exists {
				printg("file doesn't exist:",self.path)
			}
			
			var data : XGMutableData!
			if loadableFiles.contains(self.path) {
				data = loadedFiles[self.path]
				if data != nil {
					return data!
				}
			}
			
			data = XGMutableData(contentsOfXGFile: self)
			
			if loadableFiles.contains(self.path) {
				loadedFiles[self.path] = data
			}
			
			return data
		}
	}
	
	var exists : Bool {
		get {
			let fm = FileManager.default
			return fm.fileExists(atPath: self.path)
		}
	}
	
	var json : AnyObject {
		get {
			return try! JSONSerialization.jsonObject(with: self.data.data as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
		}
	}
	
	var texture : GoDTexture {
		get {
			return GoDTexture(file: self)
		}
	}
	
	var fsysData : XGFsys {
		get {
			return XGFsys(file: self)
		}
	}
	
	var mapData : XGMapRel {
		get {
			return XGMapRel(file: self)
		}
	}
	
	var scriptData : XGScript {
		get {
			return XGScript(file: self)
		}
	}
	
	var stringTable : XGStringTable {
		get {
			
			if loadableStringTables.contains(self.path) {
				if loadedStringTables[self.path] != nil {
					return loadedStringTables[self.path]!
				}
			}
			
			var table : XGStringTable!
			
			switch self {
			case .common_rel : table = XGStringTable.common_rel()
			case .tableres2  : table = XGStringTable.tableres2()
			case .dol		 : table = XGStringTable.dol()
				
			case .original(let f) :
				switch f {
					
				case .common_rel :
					table = XGStringTable.common_relOriginal()
				case .dol :
					table = XGStringTable.dolOriginal()
				case .tableres2 :
					table = XGStringTable.tableres2Original()
				default: table = XGStringTable(file: self, startOffset: 0, fileSize: self.fileSize)
				}
				
			default			 : table = XGStringTable(file: self, startOffset: 0, fileSize: self.fileSize)
			}
			
			if loadableStringTables.contains(self.path) {
				loadedStringTables[self.path] = table
			}
			
			return table
		}
	}
	
	var fileSize : Int {
		get {
			return self.data.length
		}
	}
	
	func rename(_ name: String) {
		let fm = FileManager.default
		
		let newPath = self.folder.path + ("/" + name)
		do {
			try fm.moveItem(atPath: self.path, toPath: newPath)
		} catch _ {
		}
	}
	
	func delete() {
		let fm = FileManager.default
		
		var error : NSError?
		var isDirectory : ObjCBool = false
		let pathExists = fm.fileExists(atPath: self.path, isDirectory: &isDirectory)
		
		if pathExists {
			do {
				try fm.removeItem(atPath: self.path)
			} catch let error1 as NSError {
				error = error1
				print(error)
			}
		}
	}
	
	func compress() -> XGFiles {
		XGLZSS.Input(self).compress()
		return .nameAndFolder(self.fileName + ".lzss", .LZSS)
	}
	
	func compileMapFsys(allowShift shift: Bool) {
		let baseName = self.fileName.removeFileExtensions()
		let fsys = XGFiles.nameAndFolder(baseName + ".fsys", .AutoFSYS).fsysData
		let rel = XGFiles.rel(baseName + ".rel").compress()
		let scd = XGFiles.script(baseName + ".scd").compress()
		let msg = XGFiles.stringTable(baseName + ".msg").compress()
		
		if shift {
			fsys.shiftAndReplaceFileWithIndex(0, withFile: rel)
			fsys.shiftAndReplaceFileWithIndex(1, withFile: scd)
			fsys.shiftAndReplaceFileWithIndex(2, withFile: msg)
		} else {
			fsys.replaceFileWithIndex(0, withFile: rel, saveWhenDone: false)
			fsys.replaceFileWithIndex(1, withFile: scd, saveWhenDone: false)
			fsys.replaceFileWithIndex(2, withFile: msg, saveWhenDone: false)
			fsys.save()
		}
	}
	
}


enum XGFolders : String {
	
	case Documents			= "Documents"
	case Common				= "Common"
	case DOL				= "DOL"
	case Decks				= "Decks"
	case JSON				= "JSON"
	case StringTables		= "String Tables"
	case TextureImporter	= "Texture Importer"
	case Import				= "Import"
	case Export				= "Export"
	case Textures			= "Textures"
	case Images				= "Images"
	case PokeFace			= "PokeFace"
	case PokeBody			= "PokeBody"
	case Trainers			= "Trainers"
	case Types				= "Types"
	case FSYS				= "FSYS"
	case LZSS				= "LZSS"
	case Scripts			= "Scripts"
	case Reference			= "Reference"
	case Resources			= "Resources"
	case ISO				= "ISO"
	case TOC				= "TOC"
	case AutoFSYS			= "AutoFSYS"
	case MenuFSYS			= "MenuFSYS"
	case Logs				= "Logs"
	case Rels				= "Relocation Tables"
	case Col				= "Collision Data"
	
	var name : String {
		get {
			return self.rawValue
		}
	}
	
	var path : String {
		get {
			
			var path = documentsPath
			
			switch self {
				
				case .Documents	: return path
				case .Import	: path = XGFolders.TextureImporter.path
				case .Export	: path = XGFolders.TextureImporter.path
				case .Textures	: path = XGFolders.TextureImporter.path
				case .PokeFace	: path = XGFolders.Images.path
				case .PokeBody	: path = XGFolders.Images.path
				case .Trainers	: path = XGFolders.Images.path
				case .Types		: path = XGFolders.Images.path
				default: break
				
			}
			
			return path + ("/" + self.name)
		}
	}
	
	var resourcePath : String {
		get {
			var path = XGFolders.Documents.path + "/Original"
			
			switch self {
				
			case .Documents	: return path
			case .Import	: path = XGFolders.TextureImporter.resourcePath
			case .Export	: path = XGFolders.TextureImporter.resourcePath
			case .Textures	: path = XGFolders.TextureImporter.resourcePath
			case .PokeFace	: path = XGFolders.Images.resourcePath
			case .PokeBody	: path = XGFolders.Images.resourcePath
			case .Trainers	: path = XGFolders.Images.resourcePath
			case .Types		: path = XGFolders.Images.resourcePath
			default: break
				
			}
			
			return path + ("/" + self.name)
		}
	}
	
	var filenames : [String]! {
		get {
			let names = (try? FileManager.default.contentsOfDirectory(atPath: self.path)) as [String]!
			return names!.filter{ $0.substring( to: $0.characters.index($0.startIndex, offsetBy: 1)) != "." }
		}
	}
	
	var files : [XGFiles]! {
		get {
			let fileNames = self.filenames ?? []
			var xgfs = [XGFiles]()
			
			for file in fileNames {
				let xgf = XGFiles.nameAndFolder(file, self)
				xgfs.append(xgf)
			}
			return xgfs
		}
	}
	
	var exists : Bool {
		get {
			let fm = FileManager.default
			return fm.fileExists(atPath: self.path)
		}
	}
	
	func createDirectory() {
		
		let fm = FileManager.default
		
		var error : NSError?
		var isDirectory : ObjCBool = false
		let pathExists = fm.fileExists(atPath: self.path, isDirectory: &isDirectory)
		
		if !pathExists {
			
			do {
				try fm.removeItem(atPath: self.path)
			} catch let error1 as NSError {
				error = error1
			}
			do {
				try fm.createDirectory(atPath: self.path, withIntermediateDirectories: true, attributes: nil)
			} catch let error1 as NSError {
				error = error1
			}
			
			let fileURL = URL(fileURLWithPath: self.path)
			do {
				try (fileURL as NSURL).setResourceValue(false, forKey: URLResourceKey.isExcludedFromBackupKey)
			} catch let error1 as NSError {
				error = error1
				printg(error)
			}
			
		}
		
	}
	
	
	func map(_ function: ((_ file: XGFiles) -> Void) ) {
		
		let files = self.files ?? []
		
		for file in files {
			function(file)
		}
	}
	
	func empty() {
		self.map{ (file: XGFiles) -> Void in
			file.delete()
		}
	}
	
	static func setUpFolderFormat() {
		
		let folders : [XGFolders] = [
			.Documents,
			.Common,
			.DOL,
			.Decks,
			.JSON,
			.StringTables,
			.TextureImporter,
			.Import,
			.Export,
			.Textures,
			.Images,
			.PokeFace,
			.PokeBody,
			.Trainers,
			.Types,
			.FSYS,
			.LZSS,
			.Scripts,
			.Reference,
			.Resources,
			.ISO,
			.TOC,
			.AutoFSYS,
			.MenuFSYS,
			.Logs,
			.Rels,
			.Col,
			]
		
		for folder in folders {
			folder.createDirectory()
		}
		
		var images = [XGFiles]()
		for i in 0 ... 17 {
			images.append(.typeImage(i))
		}
		for i in 0 ... 414 {
			images.append(.pokeBody(i))
			images.append(.pokeFace(i))
		}
		for i in 0 ... 67 {
			images.append(.trainerFace(i))
		}
		images.append(.nameAndFolder("type_fairy.png", .Types))
		images.append(.nameAndFolder("type_shadow.png", .Types))
		
		for image in images {
			if !image.exists {
				let resource = XGResources.png(image.fileName.replacingOccurrences(of: ".png", with: ""))
				let data = resource.data
				data.file = image
				data.save()
			}
		}
		
		let jsons = ["Move Effects", "Original Pokemon", "Original Moves", "Move Categories", "Room IDs"]
		
		for j in jsons {
			let file = XGFiles.nameAndFolder(j + ".json", .JSON)
			if !file.exists {
				let resource = XGResources.JSON(j)
				let data = resource.data
				data.file = file
				data.save()
			}
		}
		
		if !DeckDataEmptyLZSS.file.exists {
			DeckDataEmptyLZSS.save()
		}
		
//		if !NullFSYS.file.exists {
//			NullFSYS.save()
//		}
		
		
	}
	
	static func setUpFolderFormatForRandomiser() {
		
		let folders : [XGFolders] = [
			.Documents,
			.Common,
			.DOL,
			.Decks,
			.StringTables,
			.FSYS,
			.LZSS,
			.ISO,
			.TOC,
			.MenuFSYS,
			.AutoFSYS,
			.Scripts,
			.Logs,
			.Reference,
			]
		
		for folder in folders {
			folder.createDirectory()
		}
		
		let jsons = ["Move Effects", "Original Pokemon", "Original Moves", "Move Categories"]
		
		for j in jsons {
			let file = XGFiles.nameAndFolder(j + ".json", .JSON)
			if !file.exists {
				let resource = XGResources.JSON(j)
				let data = resource.data
				data.file = file
				data.save()
			}
		}
		
	}
	
}











