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
func !=(lhs: XGFiles, rhs: XGFiles) -> Bool {
	return lhs.path != rhs.path
}

var loadedFiles = [String : XGMutableData]()
var loadedStringTables = [String : XGStringTable]()
var loadedFsys = [String: XGFsys]()

#if GAME_XD
let loadableFiles = [XGFiles.common_rel.path,XGFiles.dol.path,XGDecks.DeckStory.file.path,XGDecks.DeckDarkPokemon.file.path, XGDecks.DeckColosseum.file.path,XGDecks.DeckHundred.file.path,XGDecks.DeckVirtual.file.path,XGFiles.iso.path, XGFiles.fsys("people_archive").path, XGFiles.pocket_menu.path, XGFiles.toc.path]
let loadableStringTables = [XGFiles.tableres2.path,XGFiles.typeAndFsysName(.msg, "pocket_menu").path,XGFiles.common_rel.path,XGFiles.dol.path]
#elseif  GAME_COLO
let loadableFiles = [XGFiles.common_rel.path,XGFiles.dol.path, XGFiles.iso.path, XGFiles.fsys("people_archive").path, XGFiles.pocket_menu.path, XGFiles.toc.path]
let loadableStringTables = [XGFiles.typeAndFsysName(.msg, "pocket_menu").path,XGFiles.common_rel.path,XGFiles.dol.path]
#else
let loadableFiles = [XGFiles.dol.path]
let loadableStringTables = [XGFiles]()
#endif

let loadableFsys = [XGFiles.fsys("people_archive").path]


let DeckDataEmptyLZSS = XGMutableData(byteStream: [0x4C, 0x5A, 0x53, 0x53, 0x00, 0x00, 0x01, 0xF4, 0x00, 0x00, 0x00, 0x54, 0x00, 0x00, 0x00, 0x00, 0xAF, 0x44, 0x45, 0x43, 0x4B, 0xEB, 0xF0, 0xD0, 0xEB, 0xF0, 0x02, 0xAE, 0xEA, 0xF2, 0x54, 0x4E, 0x52, 0xEB, 0xF0, 0x48, 0xEB, 0xF0, 0x01, 0x70, 0xDC, 0xFF, 0x1B, 0x0F, 0x2D, 0x0F, 0xE8, 0xF4, 0x50, 0x4B, 0x4D, 0xEB, 0xF0, 0x31, 0x30, 0x06, 0x0F, 0x5F, 0x0F, 0xFA, 0xF3, 0x41, 0x49, 0x4A, 0x0F, 0x8B, 0x0F, 0xD6, 0xE6, 0xF6, 0x53, 0x54, 0x01, 0x01, 0x18, 0xE6, 0xF5, 0x4E, 0x55, 0x03, 0x4C, 0x4C, 0x94, 0x01], file: .embedded("DeckData_Empty.bin.lzss"))

let NullFSYS = XGMutableData(byteStream:
	[0x46, 0x53, 0x59, 0x53, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
	 0x00, 0x00, 0x00, 0x60, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x4E, 0x55, 0x4C, 0x4C, 0x46, 0x53, 0x59, 0x53],
								          file: .embedded("Null.fsys"))

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
	case fsys(String)
	case lzss(String)
	case json(String)
	case iso
	case toc
	case log(Date)
	case wit
	case wimgt
	case tool(String)
	case embedded(String)
	case gameFile(String)
	case nameAndFsysName(String, String)
	case typeAndFsysName(XGFileTypes, String)
	case nameAndFolder(String, XGFolders)
	
	var path : String {
		return folder.path + "/" + self.fileName
	}
	
	var fileName : String {
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
		case .fsys(let s)			: return XGFiles.gameFile(s + XGFileTypes.fsys.fileExtension).fileName
		case .lzss(let s)			: return s + XGFileTypes.lzss.fileExtension
		case .toc					: return "game" + XGFileTypes.toc.fileExtension
		// windows doesn't support colons in file names
		case .log(let d)			: return d.description.replacingOccurrences(of: ":", with: ".") + XGFileTypes.txt.fileExtension
		case .json(let s)			: return s + XGFileTypes.json.fileExtension
		case .iso					: return inputISOFile?.fileName ?? "game" + XGFileTypes.iso.fileExtension
		case .wit                   : return environment == .Windows ? "wit.exe" :  "wit"
		case .wimgt                 : return environment == .Windows ? "wimgt.exe" :  "wimgt"
		case .tool(let s)			: return s + (environment == .Windows ? ".exe" : "")
		case .embedded(let s)		: return s
		case .gameFile(let s)			: return s
		case .nameAndFolder(let name, _) : return name
		case .nameAndFsysName(let name, _): return name
		case .typeAndFsysName(let type, _): return folder.files.first(where: {$0.fileType == type})?.fileName ?? "-"
		}
	}
	
	var folder : XGFolders {
		switch self {

		#if GAMe_PBR
		case .dol				: return .Sys
		#else
		case .dol				: return .ISOExport("Start")
		#endif
		case .common_rel		: return XGFiles.fsys("common").folder
		case .tableres2			: return XGFiles.fsys("common_dvdeth").folder
		case .pocket_menu		: return XGFiles.fsys("pocket_menu").folder
		case .deck				: return XGFiles.fsys("deck_archive").folder
		case .fsys(let s)		: return XGFiles.gameFile(s + XGFileTypes.fsys.fileExtension).folder
		case .lzss				: return .LZSS
		case .pokeFace			: return .PokeFace
		case .pokeBody			: return .PokeBody
		case .typeImage			: return .Types
		case .trainerFace		: return .Trainers
		case .iso				: return .ISO
		case .toc				: return .ISOExport("TOC")
		case .log				: return .Logs
		case .json				: return .JSON
		case .wit      		    : return .Wiimm
		case .wimgt      		: return .Wiimm
		case .tool				: return .Resources
		case .embedded			: return .Documents
		case .gameFile(let s)	: return .ISOExport(s.removeFileExtensions())
		case .nameAndFolder( _, let aFolder) : return aFolder
		case .nameAndFsysName(_, let fsysName): return XGFiles.fsys(fsysName).folder
		case .typeAndFsysName(_, let fsysName): return XGFiles.fsys(fsysName).folder
		}
	}
	
	var text: String {
		return data?.string ?? ""
	}

	var data: XGMutableData? {
		
		switch self {
		case .embedded("DeckData_Empty.bin.lzss"): return DeckDataEmptyLZSS
		case .embedded("Null.fsys"): return NullFSYS
		default: break
		}
		
		if !self.exists && self != .toc && self != .iso {
			XGFolders.setUpFolderFormat()

			if !XGUtility.exportFileFromISO(self, decode: true) {
				switch self {
				case .tableres2:
					if !XGUtility.exportFileFromISO(.fsys("common_dvdeth"), decode: false) {
						printg("file doesn't exist and couldn't be extracted:", self.path)
						return nil
					}
				case .dol:
					if !XGUtility.exportFileFromISO(.dol, decode: false) {
						printg("file doesn't exist and couldn't be extracted:", self.path)
						return nil
					}
				case .deck:
					if !XGUtility.exportFileFromISO(.fsys("deck_archive"), decode: false) {
						printg("file doesn't exist and couldn't be extracted:", self.path)
						return nil
					}
				case .typeAndFsysName(_, let name), .nameAndFsysName(_, let name):
					if !XGUtility.exportFileFromISO(.fsys(name), decode: false) {
						printg("file doesn't exist and couldn't be extracted:", self.path)
						return nil
					}
				default:
					if !XGUtility.exportFileFromISO(.fsys(self.fileName.removeFileExtensions()), decode: false) {
						printg("file doesn't exist and couldn't be extracted:", self.path)
						return nil
					}
				}
			}
		}
		
		
		var data: XGMutableData?
		if self == .iso || loadableFiles.contains(self.path) {
			
			if let data = loadedFiles[self.path] {
				return data
			}
		}
		
		if self == .toc {
			data = tocData
		} else {
			data = XGMutableData(contentsOfXGFile: self)
		}
		
		
		if self == .iso || loadableFiles.contains(self.path) {
			if let d = data {
				loadedFiles[self.path] = d
			}
		}
		
		return data
		
	}
	
	var exists: Bool {
		return FileManager.default.fileExists(atPath: self.path)
	}
	
	var json: AnyObject {
		if let data = self.data?.data {
			return try! JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
		} else {
			return [String: String]() as AnyObject
		}
	}
	
	var texture: GoDTexture {
		return GoDTexture(file: self)
	}
	
	var fsysData: XGFsys {
		if loadableFsys.contains(self.path) {
			if loadedFsys[self.path] != nil {
				return loadedFsys[self.path]!
			}
		}

		let fsys = XGFsys(file: self)

		if loadableFsys.contains(self.path) {
			loadedFsys[self.path] = fsys
		}

		return fsys
	}
	
	var mapData: XGMapRel {
		return XGMapRel(file: self)
	}
	
	var scriptData: XGScript {
		switch self {
		case .common_rel:
			guard game == .XD, region != .OtherGame else {
				printg("common.rel script not documented for colosseum")
				fatalError()
			}
			let start: Int
			if isDemo {
				start = 0x5BF5C
			} else {
				switch region {
				case .US: start = 0x5BEE4
				case .JP: start = 0x57CB4
				case .EU: start = 0x5dea4
				case .OtherGame: start = 0
				}
			}
			let data = XGMutableData(byteStream: self.data!.getCharStreamFromOffset(start, length: 0x3d20), file: .common_rel)
			return XGScript(data: data)
		default:
			return XGScript(file: self)
		}
	}
	
	var stringTable: XGStringTable {
		if loadableStringTables.contains(self.path) {
			if loadedStringTables[self.path] != nil {
				return loadedStringTables[self.path]!
			}
		}

		var table: XGStringTable!

		switch self {
		case .common_rel: table = XGStringTable.common_rel()
		case .tableres2:  table = XGStringTable.tableres2()!
		case .dol:		  table = XGStringTable.dol()

		default: table = XGStringTable(file: self, startOffset: 0, fileSize: self.fileSize)
		}

		if loadableStringTables.contains(self.path) {
			loadedStringTables[self.path] = table
		}

		return table
	}

	#if !GAME_PBR
	var collisionData: XGCollisionData {
		return XGCollisionData(file: self)
	}
	#endif

	var textures: [GoDTexture] {
		if XGFileTypes.textureFormats.contains(fileType) {
			return [texture]
		}
		#if GAME_PBR
		if XGFileTypes.textureContainingFormats.contains(fileType) {
			return PBRTextureContaining.fromFile(self)?.textures ?? []
		}
		#endif
		if fileType == .gsw {
			return XGGSWTextures(file: self).extractTextureData().map { GoDTexture(data: $0) }
		}
		if XGFileTypes.modelFormats.contains(fileType) {
			#warning("extract textures from models colo/xd")
			return []
		}
		return []
	}
	
	var fileSize: Int {
		return self.data?.length ?? 0
	}
	
	func rename(_ name: String) {
		let fm = FileManager.default
		
		let newPath = self.folder.path + ("/" + name)
		do {
			try fm.moveItem(atPath: self.path, toPath: newPath)
		} catch _ {
			printg("failed to rename file \(self.path) to \(name)")
		}
	}
	
	func delete() {
		let fm = FileManager.default
		
		var isDirectory: ObjCBool = false
		let pathExists = fm.fileExists(atPath: self.path, isDirectory: &isDirectory)
		
		if pathExists {
			do {
				try fm.removeItem(atPath: self.path)
			} catch let error as NSError {
				printg("failed to delete file:", self.path)
				printg(error)
			}
		}
	}
	
	func compress() -> XGFiles {
		let outputFile = XGFiles.lzss(fileName)
		if self.exists, let data = self.data {
			let compressedData = XGLZSS.encode(data: data)
			compressedData.file = outputFile
			compressedData.save()
		}
		return outputFile
	}
	
	var fileExtension: String {
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
				break
			}
		}
		return "." + ext
	}
	
	var fileType: XGFileTypes {
		for i in 2 ..< 255 {
			if let type = XGFileTypes(rawValue: i) {
				if type.fileExtension == self.fileExtension {
					return type
				}
			}
		}
		return .unknown
	}

	static var commonStringTableFile: XGFiles {
		if game == .PBR {
			return region == .JP ? .typeAndFsysName(.msg, "common") : .typeAndFsysName(.msg, "mes_common")
		} else {
			return .common_rel
		}
	}

	static func allFilesWithType(_ type: XGFileTypes) -> [XGFiles] {
		var files = [XGFiles]()
		XGFolders.ISOExport("").subfolders.forEach { (folder) in
			folder.files.filter { $0.fileType == type }.forEach {
				files.append($0)
			}
		}
		return files
	}
}


indirect enum XGFolders {
	
	case Documents
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
	case LZSS
	case Reference
	case Resources
	case Wiimm
	case ISO
	case Logs
	case ISOExport(String)
	case path(String)
	case nameAndPath(String, String)
	case nameAndFolder(String, XGFolders)
	#if GAME_PBR
	case DATA
	case Files
	case Dump
	case Sys
	#endif
	
	var name: String {
		switch self {
		case .Documents			: return "Documents"
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
		case .LZSS				: return "LZSS"
		case .Reference			: return "Reference"
		case .Resources			: return "Resources"
		case .Wiimm				: return "Wiimm"
		case .ISO				: return inputISOFile?.folder.name ?? "ISO"
		case .Logs				: return "Logs"
		case .ISOExport      	: return "Game Files"
		case .path(let s) 		: return s
		case .nameAndPath(let s, _): return s
		case .nameAndFolder(let s, _): return s
		#if GAME_PBR
		case .Sys				: return "sys"
		case .Files				: return "files"
		case .Dump         		: return "Dump"
		case .DATA              : return "DATA"
		#endif
		}
	}
	
	var path: String {

		if case .path(let s) = self {
			return s
		}

		var path = ""

		switch self {

		case .Documents	: return documentsPath
		case .nameAndPath(let name, let path): return path + "/\(name)"
		case .ISOExport(let folder): return documentsPath + "/" + self.name +
			(folder == "" ? "" : "/" + folder)
		case .Images	: path = XGFolders.Resources.path
		case .JSON		: path = XGFolders.Resources.path
		case .Import	: path = XGFolders.TextureImporter.path
		case .Export	: path = XGFolders.TextureImporter.path
		case .Textures	: path = XGFolders.TextureImporter.path
		case .PokeFace	: path = XGFolders.Images.path
		case .PokeBody	: path = XGFolders.Images.path
		case .Trainers	: path = XGFolders.Images.path
		case .Types		: path = XGFolders.Images.path
		case .Wiimm		: path = XGFolders.Resources.path
		case .nameAndFolder(_, let f): path = f.path
		case .ISO		: return inputISOFile?.folder.path ?? documentsPath + "/" + self.name
		case .path(let s): return s
		#if GAME_PBR
		case .Dump  	: path = inputISOFile? == nil ? documentsPath : XGFolders.ISO.path
		case .DATA      : path = XGFolders.Dump.path
		case .Sys, .Files: path = XGFolders.DATA.exists ? XGFolders.DATA.path : XGFolders.Dump.path
		#endif
		default: path = documentsPath

		}

		return path + "/" + self.name
	}
	
	var projectPath: String {
		return path.replacingOccurrences(of: documentsPath, with: "")
	}
    
    var files: [XGFiles] {
		var filenames = (try? FileManager.default.contentsOfDirectory(atPath: self.path)) ?? []
		filenames = filenames.filter { $0.substring(from: 0, to: 1) != "." }

		return filenames.map { XGFiles.nameAndFolder($0, self) }.filter {
			var isDirectory: ObjCBool = false
			_ = FileManager.default.fileExists(atPath: $0.path, isDirectory: &isDirectory)
			return !isDirectory.boolValue
		}
	}

	var subfolders: [XGFolders] {
		var filenames = (try? FileManager.default.contentsOfDirectory(atPath: self.path)) ?? []
		filenames = filenames.filter { $0.substring(from: 0, to: 1) != "." }

		return filenames.map { XGFolders.nameAndFolder($0, self) }.filter {
			var isDirectory: ObjCBool = false
			_ = FileManager.default.fileExists(atPath: $0.path, isDirectory: &isDirectory)
			return isDirectory.boolValue
		}
	}
	
	var exists: Bool {
		return FileManager.default.fileExists(atPath: self.path)
	}

	func contains(_ file: XGFiles) -> Bool {
		return files.contains { (f2) -> Bool in
			f2.fileName == file.fileName
		}
	}

	func createDirectory() {
		
		let fm = FileManager.default
		
		var isDirectory: ObjCBool = false
		let pathExists = fm.fileExists(atPath: self.path, isDirectory: &isDirectory)
		
		if !pathExists {
			
			do {
				try fm.createDirectory(atPath: self.path, withIntermediateDirectories: true, attributes: nil)
			} catch let error as NSError {
				print(error)
			}
			
			let fileURL = URL(fileURLWithPath: self.path)
			do {
				try (fileURL as NSURL).setResourceValue(false, forKey: URLResourceKey.isExcludedFromBackupKey)
			} catch let error as NSError {
				print(error)
			}
		}
	}
	
	static func setUpFolderFormat() {
		
		let folders: [XGFolders] = [
			.Documents,
			.Resources,
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
			.LZSS,
			.Reference,
			.ISO,
			.Logs,
			.ISOExport("")
			]
		
		for folder in folders {
			folder.createDirectory()
		}
		
		var images = [XGFiles]()
		for i in 0 ... 17 {
			images.append(.typeImage(i))
		}
		images.append(.nameAndFolder("type_fairy.png", .Types))
		if game != .PBR {
			images.append(.nameAndFolder("type_shadow.png", .Types))
		}

		if game == .PBR {
			for i in 0 ... 500 {
				images.append(.pokeBody(i))
				images.append(.pokeFace(i))
			}
		} else {
			for i in 0 ... 414 {
				images.append(.pokeBody(i))
				images.append(.pokeFace(i))
			}
		}

		if game != .PBR {
			let maxTrainerFaceIndex = game == .XD ? 67 : 75
			for i in 0 ... maxTrainerFaceIndex {
				images.append(.trainerFace(i))
			}
		}

		
		for image in images {
			if !image.exists {
				var filename = image.fileName
				if case .trainerFace = image, game == .Colosseum {
					filename = "colo_" + image.fileName
				}
				if game == .PBR {
					if case .pokeBody = image {
						filename = "PBR_" + image.fileName
					}
					if case .pokeFace = image {
						filename = "PBR_" + image.fileName
					}
				}

				let resource = XGResources.png(filename.replacingOccurrences(of: ".png", with: ""))
                resource.copy(to: image)
			}
		}
		
		var jsons = ["Move Effects", "Original Pokemon", "Original Moves"]
		if game == .PBR {
			jsons += ["Original Items"]
		} else {
			jsons += ["Move Categories", "Room IDs"]
		}
		
		for j in jsons {
			let file = XGFiles.json(j)
			if !file.exists {
                XGResources.JSON(j).copy(to: file)
			}
		}

		#if GAME_XD
		XGScript.encodeDummyJSON()
		#endif

		let wiimm = XGFolders.Wiimm
        if !wiimm.exists {
			XGResources.folder("wiimm").copy(to: wiimm)
        }

		if game != .PBR {
			let gcitool = XGFiles.tool("gcitool")
			if !gcitool.exists {
				XGResources.tool("gcitool").copy(to: gcitool)
			}
		}
	}
	
}

extension XGFolders: Codable {
	enum CodingKeys: String, CodingKey {
		case path
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		let url = try container.decode(String.self, forKey: .path)
		self = .path(documentsPath + url)
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		let path = self.path.replacingOccurrences(of: documentsPath, with: "")
		try container.encode(path, forKey: .path)
	}
}

extension XGFiles: Codable {
	enum CodingKeys: String, CodingKey {
		case name, folder
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		let name = try container.decode(String.self, forKey: .name)
		let folder = try container.decode(XGFolders.self, forKey: .folder)
		self = .nameAndFolder(name, folder)
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(fileName, forKey: .name)
		try container.encode(folder, forKey: .folder)
	}
}








