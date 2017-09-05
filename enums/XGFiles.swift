//
//  XGDecks.swift
//  XG Tool
//
//  Created by The Steez on 30/05/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//

import Foundation

func ==(lhs: XGFiles, rhs: XGFiles) -> Bool {
	return lhs.path == rhs.path
}

var loadedFiles = [String : XGMutableData]()
var loadedStringTables = [String : XGStringTable]()

let loadableFiles = [XGFiles.common_rel.path,XGFiles.dol.path,XGDecks.DeckStory.file.path,XGDecks.DeckDarkPokemon.file.path, XGFiles.iso.path,XGFiles.original(.common_rel).path,XGFiles.original(.dol).path,XGFiles.original(.tableres2).path]
let loadableStringTables = [XGFiles.tableres2.path,XGFiles.stringTable("pocket_menu.msg").path,XGFiles.common_rel.path,XGFiles.dol.path,XGFiles.original(.common_rel).path,XGFiles.original(.dol).path,XGFiles.original(.tableres2).path]

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
	case iso
	case toc
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
				case .common_rel			: return "common_rel.fdat"
				case .tableres2				: return "tableres2.fdat"
				case .pocket_menu			: return "pocket_menu.fdat"
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
				case .iso					: return "XD.iso"
				case .toc					: return "Game.toc"
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
				case .iso				: folder = .ISO
				case .toc				: folder = .TOC
				case .original(let f)	: folder = f.folder
				case .nameAndFolder( _, let aFolder) : folder = aFolder
				
			}
			
			return folder
		}
	}

	var data : XGMutableData {
		get {
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
	
	var fsysData : XGFsys {
		get {
			return XGFsys.fsys(self)
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
	
}


enum XGFolders : String {
	
	case Documents			= "Documents"
	case Common				= "Common"
	case DOL				= "DOL"
	case Decks				= "Decks"
	case JSON				= "JSON"
	case StringTables		= "String Tables"
	case TextureImporter	= "Texture Importer"
	case PNG				= "PNG"
	case FDAT				= "FDAT"
	case Output				= "Output"
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
				case .PNG		: path = XGFolders.TextureImporter.path
				case .FDAT		: path = XGFolders.TextureImporter.path
				case .Output	: path = XGFolders.TextureImporter.path
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
			case .PNG		: path = XGFolders.TextureImporter.resourcePath
			case .FDAT		: path = XGFolders.TextureImporter.resourcePath
			case .Output	: path = XGFolders.TextureImporter.resourcePath
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
				print(error)
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
			.PNG,
			.FDAT,
			.Output,
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
		images.append(.nameAndFolder("type_shadow.png", .Types))
		
		for image in images {
			if !image.exists {
				let resource = XGResources.png(image.fileName.replacingOccurrences(of: ".png", with: ""))
				let data = resource.data
				data.file = image
				data.save()
			}
		}
		
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
			.Scripts
			]
		
		for folder in folders {
			folder.createDirectory()
		}
		
	}
	
}











