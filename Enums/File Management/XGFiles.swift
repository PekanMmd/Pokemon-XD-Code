//
//  XGDecks.swift
//  XG Tool
//
//  Created by The Steez on 30/05/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//

import UIKit

enum XGFiles {
	
	case Dol
	case Common_rel			
	case Tableres2
	case Deck(XGDecks)
	case PokeFace(Int)
	case PokeBody(Int)
	case TypeImage(Int)
	case TrainerFace(Int)
	case StringTable(String)
	case Resources(XGResources)
	case NameAndFolder(String, XGFolders)
	
	var path : String {
		get{
			switch self {
				case .Resources(let r)  : return r.path!
				default					: return folder.path.stringByAppendingPathComponent(self.fileName)
			}
		}
		
	}
	
	var fileName : String {
		get {
			switch self {
				
				case .Dol					: return "Start.dol"
				case .Common_rel			: return "common_rel.fdat"
				case .Tableres2				: return "tableres2.fdat"
				case .Deck(let deck)		: return deck.fileName
				case .PokeFace(let id)		: return String(id) + ".png"
				case .PokeBody(let id)		: return String(id) + ".png"
				case .TypeImage(let id)		: return String(id) + ".png"
				case .TrainerFace(let id)	: return String(id) + ".png"
				case .StringTable(let s)	: return s
				case .Resources(let r)		: return r.fileName
				case .NameAndFolder(let name, let _) : return name
				
			}
		}
	}
	
	var folder : XGFolders {
		get {
			var folder = XGFolders.Documents
			
			switch self {
				
				case .Dol				: folder = .DOL
				case .Common_rel		: folder = .Common
				case .Tableres2			: folder = .Common
				case .Deck				: folder = .Decks
				case .PokeFace			: folder = .PokeFace
				case .PokeBody			: folder = .PokeBody
				case .TypeImage			: folder = .Types
				case .TrainerFace		: folder = .Trainers
				case .StringTable		: folder = .StringTables
				case .NameAndFolder(let _, let aFolder) : folder = aFolder
				default: break
				
			}
			
			return folder
		}
	}

	var data : XGMutableData {
		get {
			return XGMutableData(contentsOfXGFile: self)!
		}
	}
	
	var exists : Bool {
		get {
			var fm = NSFileManager.defaultManager()
			return fm.fileExistsAtPath(self.path)
		}
	}
	
	var json : AnyObject {
		get {
			return NSJSONSerialization.JSONObjectWithData(self.data.data, options: NSJSONReadingOptions.MutableContainers, error: nil)!
		}
	}
	
	var image : UIImage {
		get {
			return UIImage(contentsOfFile: self.path)!
		}
	}
	
	var stringTable : XGStringTable {
		get {
			switch self {
				case .Common_rel : return XGStringTable.common_rel()
				case .Tableres2  : return XGStringTable.tableres2()
				case .Dol		 : return XGStringTable.dol()
				default			 : return XGStringTable(file: self, startOffset: 0, fileSize: self.fileSize)
			}
		}
	}
	
	var fileSize : Int {
		get {
			return self.data.length
		}
	}
	
	func rename(name: String) {
		let fm = NSFileManager.defaultManager()
		
		let newPath = self.folder.path.stringByAppendingPathComponent(name)
		fm.moveItemAtPath(self.path, toPath: newPath, error: nil)
	}
	
	func delete() {
		var fm = NSFileManager.defaultManager()
		
		var error : NSError?
		var isDirectory : ObjCBool = false
		var pathExists = fm.fileExistsAtPath(self.path, isDirectory: &isDirectory)
		
		if pathExists && !isDirectory {
			fm.removeItemAtPath(self.path, error: &error)
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
	case PNG				= "PNG"
	case FDAT				= "FDAT"
	case Output				= "Output"
	case Images				= "Images"
	case PokeFace			= "PokeFace"
	case PokeBody			= "PokeBody"
	case Trainers			= "Trainers"
	case Types				= "Types"
	
	var name : String {
		get {
			return self.rawValue
		}
	}
	
	var path : String {
		get {
			var path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
			
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
			
			return path.stringByAppendingPathComponent(self.name)
		}
	}
	
	var filenames : [String]! {
		get {
			var names = NSFileManager.defaultManager().contentsOfDirectoryAtPath(self.path, error: nil) as! [String]!
			return names.filter{ $0.substringToIndex( advance($0.startIndex, 1)) != "." }
		}
	}
	
	var files : [XGFiles]! {
		get {
			let fileNames = self.filenames ?? []
			var xgfs = [XGFiles]()
			
			for file in fileNames {
				let xgf = XGFiles.NameAndFolder(file, self)
				xgfs.append(xgf)
			}
			return xgfs
		}
	}
	
	func createDirectory() {
		
		var fm = NSFileManager.defaultManager()
		
		var error : NSError?
		var isDirectory : ObjCBool = false
		var pathExists = fm.fileExistsAtPath(self.path, isDirectory: &isDirectory)
		
		if !pathExists || !isDirectory {
			
			fm.removeItemAtPath(self.path, error: &error)
			fm.createDirectoryAtPath(self.path, withIntermediateDirectories: true, attributes: nil, error: &error)
			
			var fileURL = NSURL(fileURLWithPath: self.path)
			fileURL!.setResourceValue(false, forKey: NSURLIsExcludedFromBackupKey, error: &error)
			
		}
		
	}
	
	func copyResource(resource: XGResources) {
		
		let fm = NSFileManager.defaultManager()
		
		let copyPath = self.path.stringByAppendingPathComponent(resource.fileName)
		
		if !fm.fileExistsAtPath(copyPath) && (resource.path != nil) {
			fm.copyItemAtPath(resource.path!, toPath: copyPath, error: nil)
		}
		
	}
	
	func map(function: ((file: XGFiles) -> Void) ) {
		
		let files = self.files ?? []
		
		for file in files {
			function(file: file)
		}
	}
	
	func empty() {
		self.map{ (file: XGFiles) -> Void in
			file.delete()
		}
	}
	
}














