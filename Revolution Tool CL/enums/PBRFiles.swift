//
//  PBRFiles.swift
//
//  Created by The Steez on 24/12/2018.
//

import Foundation

func ==(lhs: XGFiles, rhs: XGFiles) -> Bool {
	return lhs.path == rhs.path
}
func !=(lhs: XGFiles, rhs: XGFiles) -> Bool {
	return lhs.path != rhs.path
}

var loadedFiles = [String : XGMutableData]()
var loadedStringTables = [String : XGStringTable]()

let loadableFiles = [XGFiles.dol.path, XGFiles.fsys("common").path]
let loadableStringTables = [""]


let DeckDataEmptyLZSS = XGMutableData(byteStream: [0x4C, 0x5A, 0x53, 0x53, 0x00, 0x00, 0x01, 0xF4, 0x00, 0x00, 0x00, 0x54, 0x00, 0x00, 0x00, 0x00, 0xAF, 0x44, 0x45, 0x43, 0x4B, 0xEB, 0xF0, 0xD0, 0xEB, 0xF0, 0x02, 0xAE, 0xEA, 0xF2, 0x54, 0x4E, 0x52, 0xEB, 0xF0, 0x48, 0xEB, 0xF0, 0x01, 0x70, 0xDC, 0xFF, 0x1B, 0x0F, 0x2D, 0x0F, 0xE8, 0xF4, 0x50, 0x4B, 0x4D, 0xEB, 0xF0, 0x31, 0x30, 0x06, 0x0F, 0x5F, 0x0F, 0xFA, 0xF3, 0x41, 0x49, 0x4A, 0x0F, 0x8B, 0x0F, 0xD6, 0xE6, 0xF6, 0x53, 0x54, 0x01, 0x01, 0x18, 0xE6, 0xF5, 0x4E, 0x55, 0x03, 0x4C, 0x4C, 0x94, 0x01], file: .lzss("DeckData_Empty.bin"))

let NullFSYS = XGMutableData(byteStream: [0x46, 0x53, 0x59, 0x53, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
										  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
										  0x00, 0x00, 0x00, 0x60, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
										  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
										  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
										  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x4E, 0x55, 0x4C, 0x4C, 0x46, 0x53, 0x59, 0x53],
							 file: .fsys("Null"))

indirect enum XGFiles {
	
	case dol
	case common(Int)
	case msg(String)
	case dckp(Int)
	case dckt(Int)
	case dcka
	case pokeFace(Int)
	case pokeBody(Int)
	case typeImage(Int)
	case trainerFace(Int)
	case fsys(String)
	case lzss(String)
	case json(String)
	case log(Date)
	case nameAndFolder(String, XGFolders)
	
	var path : String {
		get {
			return folder.path + "/" + self.fileName
		}
	}
	
	var fileName : String {
		get {
			switch self {
				
			case .dol					: return "main" + XGFileTypes.dol.fileExtension
			case .common(let i)			: return "common_" + String(format: "%02d", i) + XGFileTypes.dta.fileExtension
			case .msg(let s)			: return s + XGFileTypes.msg.fileExtension
			case .dckp(let i)			: return "pokemon deck_" + String(format: "%02d", i) + XGFileTypes.dckp
				.fileExtension
			case .dckt(let i)			: return "trainer deck_" + String(format: "%02d", i) + XGFileTypes.dckt
				.fileExtension
			case .dcka					: return "AI deck" + XGFileTypes.dcka.fileExtension
			case .pokeFace(let id)		: return "face_" + String(format: "%03d", id) + XGFileTypes.png.fileExtension
			case .pokeBody(let id)		: return "body_" + String(format: "%03d", id) + XGFileTypes.png.fileExtension
			case .typeImage(let id)		: return "type_" + String(id) + XGFileTypes.png.fileExtension
			case .trainerFace(let id)	: return "trainer_" + String(id) + XGFileTypes.png.fileExtension
			case .fsys(let s)			: return s + XGFileTypes.fsys.fileExtension
			case .lzss(let s)			: return s + XGFileTypes.lzss.fileExtension
			case .log(let d)			: return d.description + XGFileTypes.txt.fileExtension
			case .json(let s)			: return s + XGFileTypes.json.fileExtension
			case .nameAndFolder(let name, _) : return name
			}
		}
	}
	
	var folder : XGFolders {
		get {
			var folder = XGFolders.Documents
			
			switch self {
				
			case .dol				: folder = .DOL
			case .common			: folder = .Common
			case .msg				: folder = .MSG
			case .dckp				: folder = .Decks
			case .dckt				: folder = .Decks
			case .dcka				: folder = .Decks
			case .pokeFace			: folder = .PokeFace
			case .pokeBody			: folder = .PokeBody
			case .typeImage			: folder = .Types
			case .trainerFace		: folder = .Trainers
			case .lzss				: folder = .LZSS
			case .log				: folder = .Logs
			case .json				: folder = .JSON
			case .fsys				: folder = .FSYS
			case .nameAndFolder( _, let aFolder) : folder = aFolder
				
			}
			
			return folder
		}
	}
	
	var text : String {
		if !self.exists {
			printg("File doesn't exist:", self.path)
		}
		return self.exists ? data!.string : ""
	}
	
	var data : XGMutableData? {
		
		switch self {
		case .lzss("DeckData_Empty.bin"): return DeckDataEmptyLZSS
		case .fsys("Null"): return NullFSYS
		default: break
		}
		
		if !self.exists {
			printg("file doesn't exist:", self.path)
			return nil
		}
		
		var data : XGMutableData?
		if let data = loadedFiles[self.path] {
			return data
		}
		
		data = XGMutableData(contentsOfXGFile: self)
		
		if loadableFiles.contains(self.path) {
			
			if let d = data {
				loadedFiles[self.path] = d
			}
		}
		
		return data
		
	}
	
	var exists : Bool {
		return FileManager.default.fileExists(atPath: self.path)
	}
	
	var json : AnyObject {
		get {
			if self.exists {
				return try! JSONSerialization.jsonObject(with: self.data!.data as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
			} else {
				printg("File doesn't exist: \(self.path)")
				return [String : String]() as AnyObject
			}
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
	
	var scriptData : XGScript {
		return XGScript(file: self)
	}
	
	func writeScriptData() {
		
		let scriptData = self.scriptData
		XGUtility.saveString(scriptData.description, toFile: .nameAndFolder(self.fileName + XGFileTypes.txt.fileExtension, self.folder))
		XGUtility.saveString(scriptData.getXDSScript(), toFile: .nameAndFolder(self.fileName.removeFileExtensions() + XGFileTypes.xds.fileExtension, self.folder))
	}
	
	var stringTable : XGStringTable {
		get {
			if loadableStringTables.contains(self.path) {
				if loadedStringTables[self.path] != nil {
					return loadedStringTables[self.path]!
				}
			}
			
			let table = XGStringTable(file: self, startOffset: 0, fileSize: self.fileSize)
			
			if loadableStringTables.contains(self.path) {
				loadedStringTables[self.path] = table
			}
			
			return table
		}
	}
	
	var fileSize : Int {
		get {
			if self.exists {
				return self.data!.length
			} else {
				printg("File doesn't exist:", self.path)
				return 0
			}
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
		
		var isDirectory : ObjCBool = false
		let pathExists = fm.fileExists(atPath: self.path, isDirectory: &isDirectory)
		
		if pathExists {
			do {
				try fm.removeItem(atPath: self.path)
			} catch let error as NSError {
				printg(error)
			}
		}
	}
	
	func compress() -> XGFiles {
		XGLZSS.Input(self).compress()
		return .lzss(self.fileName)
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


indirect enum XGFolders {
	
	case Documents
	case Common
	case DOL
	case Decks
	case JSON
	case TextureImporter
	case Import
	case Export
	case Textures
	case Images
	case PokeFace
	case PokeBody
	case Trainers
	case Types
	case FSYS
	case LZSS
	case MSG
	case Reference
	case Resources
	case Logs
	case ISOExport(String)
	case nameAndPath(String, String)
	case nameAndFolder(String, XGFolders)
	
	var name : String {
		get {
			switch self {
			case .Documents			: return "Documents"
			case .Common			: return "Common"
			case .DOL				: return "DOL"
			case .Decks				: return "Decks"
			case .JSON				: return "JSON"
			case .TextureImporter	: return "Texture Importer"
			case .Import			: return "Import"
			case .Export			: return "Export"
			case .Textures			: return "Textures"
			case .Images			: return "Images"
			case .PokeFace			: return "PokeFace"
			case .PokeBody			: return "PokeBody"
			case .Trainers			: return "Trainers"
			case .Types				: return "Types"
			case .FSYS				: return "FSYS"
			case .LZSS				: return "LZSS"
			case .MSG				: return "String Tables"
			case .Reference			: return "Reference"
			case .Resources			: return "Resources"
			case .Logs				: return "Logs"
			case .ISOExport      	: return "FSYS Export"
			case .nameAndPath(let s, _): return s
			case .nameAndFolder(let s, _): return s
			}
		}
	}
	
	var path : String {
		get {
			
			var path = documentsPath
			
			switch self {
				
			case .Documents	: return path
			case .nameAndPath(let name, let path): return path + "/\(name)"
			case .ISOExport(let folder): return path + ("/" + self.name) + ("/" + folder)
			case .Import	: path = XGFolders.TextureImporter.path
			case .Export	: path = XGFolders.TextureImporter.path
			case .Textures	: path = XGFolders.TextureImporter.path
			case .PokeFace	: path = XGFolders.Images.path
			case .PokeBody	: path = XGFolders.Images.path
			case .Trainers	: path = XGFolders.Images.path
			case .Types		: path = XGFolders.Images.path
			case .nameAndFolder(_, let f): path = f.path
			default: break
				
			}
			
			return path + "/" + self.name
		}
	}
	
	var resourcePath : String {
		get {
			var path = XGFolders.Documents.path + "/Original"
			
			switch self {
				
			case .nameAndPath(let name, let path): return path + "/\(name)"
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
	
	var filenames : [String] {
		if self.exists {
			let names = (try? FileManager.default.contentsOfDirectory(atPath: self.path)) as [String]?
			return names!.filter{ $0.substring(from: 0, to: 1) != "." }
		} else {
			return []
		}
	}
	
	var files : [XGFiles]! {
		get {
			let fileNames = self.filenames
			var xgfs = [XGFiles]()
			
			for file in fileNames {
				let xgf = XGFiles.nameAndFolder(file, self)
				xgfs.append(xgf)
			}
			return xgfs
		}
	}
	
	var exists : Bool {
		return FileManager.default.fileExists(atPath: self.path)
	}
	
	func createDirectory() {
		
		let fm = FileManager.default
		
		var isDirectory : ObjCBool = false
		let pathExists = fm.fileExists(atPath: self.path, isDirectory: &isDirectory)
		
		if !pathExists {
			
			do {
				try fm.createDirectory(atPath: self.path, withIntermediateDirectories: true, attributes: nil)
			} catch let error as NSError {
				printg(error)
			}
			
			let fileURL = URL(fileURLWithPath: self.path)
			do {
				try (fileURL as NSURL).setResourceValue(false, forKey: URLResourceKey.isExcludedFromBackupKey)
			} catch let error as NSError {
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
			.MSG,
			.Decks,
			.JSON,
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
			.Reference,
			.Resources,
			.Logs,
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
		
		for image in images {
			if !image.exists {
				let resource = XGResources.png(image.fileName.replacingOccurrences(of: ".png", with: ""))
				let data = resource.data
				data.file = image
				data.save()
			}
		}
		
		let jsons = ["Move Effects", "Original Pokemon", "Original Moves",]
		
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











