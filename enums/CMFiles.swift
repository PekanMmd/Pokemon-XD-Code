//
//  CMFiles.swift
//  Colosseum Tool
//
//  Created by The Steez on 07/06/2018.
//

import Foundation

func ==(lhs: XGFiles, rhs: XGFiles) -> Bool {
	return lhs.path == rhs.path
}

var loadedFiles = [String : XGMutableData]()
var loadedStringTables = [String : XGStringTable]()

let loadableFiles = [XGFiles.common_rel.path,XGFiles.dol.path, XGFiles.iso.path,XGFiles.original(.common_rel).path,XGFiles.original(.dol).path,XGFiles.original(.tableres2).path, XGFiles.fsys("people_archive").path, XGFiles.pocket_menu.path]
let loadableStringTables = [XGFiles.tableres2.path,XGFiles.msg("pocket_menu").path,XGFiles.common_rel.path,XGFiles.dol.path,XGFiles.original(.common_rel).path,XGFiles.original(.dol).path,XGFiles.original(.tableres2).path]

let compressionFolders = [XGFolders.Common, XGFolders.Textures, XGFolders.StringTables, XGFolders.Scripts, XGFolders.Rels]

let NullFSYS = XGMutableData(byteStream: [0x46, 0x53, 0x59, 0x53, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
										  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
										  0x00, 0x00, 0x00, 0x30, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
										  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
										  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
										  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x0D, 0xE1, 0xE7, 0xED, 0x46, 0x53, 0x59, 0x53],
							 file: .fsys("Null"))

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
	case msg(String)
	case original(XGFiles)
	case fsys(String)
	case lzss(String)
	case scd(String)
	case xds(String)
	case texture(String)
	case rel(String)
	case col(String)
	case json(String)
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
				
			case .dol					: return "Start" + XGFileTypes.dol.fileExtension
			case .common_rel			: return "common" + XGFileTypes.rel.fileExtension
			case .tableres2				: return "tableres2" + XGFileTypes.rel.fileExtension
			case .pocket_menu			: return "pocket_menu" + XGFileTypes.rel.fileExtension
			case .deck(let deck)		: return deck.fileName
			case .pokeFace(let id)		: return "face_" + String(format: "%03d", id) + XGFileTypes.png.fileExtension
			case .pokeBody(let id)		: return "body_" + String(format: "%03d", id) + XGFileTypes.png.fileExtension
			case .typeImage(let id)		: return "type_" + String(id) + XGFileTypes.png.fileExtension
			case .trainerFace(let id)	: return "trainer_" + String(id) + XGFileTypes.png.fileExtension
			case .msg(let s)			: return s + XGFileTypes.msg.fileExtension
			case .original(let o)		: return o.fileName
			case .fsys(let s)			: return s + XGFileTypes.fsys.fileExtension
			case .lzss(let s)			: return s + XGFileTypes.lzss.fileExtension
			case .scd(let s)			: return s + XGFileTypes.scd.fileExtension
			case .xds(let s)			: return s + XGFileTypes.xds.fileExtension
			case .texture(let s)		: return s
			case .toc					: return "Game" + XGFileTypes.toc.fileExtension
			case .log(let d)			: return d.description + XGFileTypes.txt.fileExtension
			case .rel(let s)			: return s + XGFileTypes.rel.fileExtension
			case .col(let s)			: return s + XGFileTypes.col.fileExtension
			case .json(let s)			: return s + XGFileTypes.json.fileExtension
			case .nameAndFolder(let name, _) : return name
			case .iso					: return (game == .Colosseum ? "Colosseum" : "XD") + XGFileTypes.iso.fileExtension
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
			case .deck				: folder = .Documents
			case .pokeFace			: folder = .PokeFace
			case .pokeBody			: folder = .PokeBody
			case .typeImage			: folder = .Types
			case .trainerFace		: folder = .Trainers
			case .msg		: folder = .StringTables
			case .fsys				: folder = .FSYS
			case .lzss				: folder = .LZSS
			case .scd				: folder = .Scripts
			case .xds				: folder = .Documents
			case .texture			: folder = .Textures
			case .iso				: folder = .ISO
			case .toc				: folder = .Documents
			case .log				: folder = .Logs
			case .rel				: folder = .Rels
			case .col				: folder = .Col
			case .json				: folder = .JSON
			case .original(let f)	: folder = f.folder
			case .nameAndFolder( _, let aFolder) : folder = aFolder
				
			}
			
			return folder
		}
	}
	
	var text : String {
		return data.string
	}
	
	var data : XGMutableData {
		get {
			if self == .toc {
				return tocData
			}
			
			if !self.exists {
				printg("file doesn't exist:", self.path)
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
				if data.length > 0 {
					loadedFiles[self.path] = data
				}
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
	
	func writeScriptData() { }
	
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
			case .tableres2  : table = XGStringTable.tableres2()!
			case .dol		 : table = XGStringTable.dol()
				
			default			 : table = XGStringTable(file: self, startOffset: 0, fileSize: self.fileSize)
			}
			
			if loadableStringTables.contains(self.path) {
				loadedStringTables[self.path] = table
			}
			
			return table
		}
	}
	
	var collisionData : XGCollisionData {
		return XGCollisionData(file: self)
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
				printg(error)
			}
		}
	}
	
	func compress() -> XGFiles {
		if self.exists {
			XGLZSS.Input(self).compress()
		}
		return .lzss(self.fileName)
	}
	
	func compileMapFsys() {
		
		let baseName = self.fileName.removeFileExtensions()
		let fsysFile = XGFiles.nameAndFolder(baseName + XGFileTypes.fsys.fileExtension, .AutoFSYS)
		let rel = XGFiles.rel(baseName)
		let col = XGFiles.col(baseName)
		let scd = XGFiles.scd(baseName)
		let msg = XGFiles.msg(baseName)
		
		if fsysFile.exists {
			let fsys = fsysFile.fsysData
			printg("compiling \(baseName).fsys...")
			if rel.exists {
				fsys.shiftAndReplaceFileWithType(.rel, withFile: rel.compress(), save: false)
			}
			if scd.exists {
				fsys.shiftAndReplaceFileWithType(.scd, withFile: scd.compress(), save: false)
			}
			if msg.exists {
				fsys.shiftAndReplaceFileWithType(.msg, withFile: msg.compress(), save: false)
			}
			if rel.exists {
				fsys.shiftAndReplaceFileWithType(.col, withFile: col.compress(), save: true)
			}
			ISO.importFiles([fsysFile])
		}
		
	}
	
	func compileMenuFsys() {
		
		let baseName = self.fileName.removeFileExtensions()
		let fsysFile = XGFiles.nameAndFolder(baseName + XGFileTypes.fsys.fileExtension, .MenuFSYS)
		let rel = XGFiles.rel(baseName)
		let col = XGFiles.col(baseName)
		let scd = XGFiles.scd(baseName)
		
		if fsysFile.exists {
			let fsys = fsysFile.fsysData
			printg("compiling \(baseName).fsys...")
			if rel.exists {
				fsys.shiftAndReplaceFileWithType(.rel, withFile: rel.compress(), save: false)
			}
			if scd.exists {
				fsys.shiftAndReplaceFileWithType(.scd, withFile: scd.compress(), save: false)
			}
			if rel.exists {
				fsys.shiftAndReplaceFileWithType(.col, withFile: col.compress(), save: true)
			}
			ISO.importFiles([fsysFile])
		}
		
	}
	
	var fileExtension : String {
		var ext = self.fileName.fileExtensions
		if ext.length > 0 {
			ext = ext.substring(from: 1, to: ext.length)
		}
		while ext.range(of: ".") != nil {
			if ext.length > 0 {
				ext = ext.fileExtensions
				if ext.length > 0 {
					ext = ext.substring(from: 1, to: ext.length)
				}
			} else {
				return ext
			}
		}
		return ext
	}
	
	var fileType : XGFileTypes {
		for i in 2 ..< 255 {
			if let type = XGFileTypes(rawValue: i) {
				if type.fileExtension == "." + self.fileExtension {
					return type
				}
			}
		}
		return .unknown
	}
	
}


enum XGFolders : String {
	
	case Documents			= "Documents"
	case Common				= "Common"
	case DOL				= "DOL"
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
		let path = self.path
		let pathExists = fm.fileExists(atPath: path, isDirectory: &isDirectory)
		
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
		for i in 0 ... 75 {
			images.append(.trainerFace(i))
		}
		images.append(.nameAndFolder("type_fairy.png", .Types))
		images.append(.nameAndFolder("type_shadow.png", .Types))
		
		for image in images {
			if !image.exists {
				var filename = ""
				switch image {
				case .trainerFace:
					filename = "colo_" + image.fileName
				default:
					filename = image.fileName
				}
				
				let resource = XGResources.png(filename.replacingOccurrences(of: ".png", with: ""))
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
		
	}
	
	static func setUpFolderFormatForRandomiser() {
		
		let folders : [XGFolders] = [
			.Documents,
			.Common,
			.DOL,
			.StringTables,
			.FSYS,
			.LZSS,
			.ISO,
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
			let file = XGFiles.json(j)
			if !file.exists {
				let resource = XGResources.JSON(j)
				let data = resource.data
				data.file = file
				data.save()
			}
		}
		
	}
	
}
