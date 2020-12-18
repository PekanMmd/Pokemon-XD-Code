////
////  XGResources.swift
////  XG Tool
////
////  Created by StarsMmd on 01/06/2015.
////  Copyright (c) 2015 StarsMmd. All rights reserved.
////
//
import Foundation

enum XGResources {
	
	case JSON(String)
	case png(String)
	case shader(String)
	case sublimeColourScheme(String)
	case sublimeSyntax(String)
	case sublimeSettings(String)
	case sublimeCompletions(String)
    case tool(String)
	case folder(String)
	case nameAndFileType(String, String)
	
	var path : String {
		get{
			return Bundle.main.path(forResource: name, ofType: fileType) ?? Bundle.main.bundlePath + "/Assets/\(game.shortName)/\(fileName)"
		}
	}
	
	var name : String {
		get {
			switch self {
				case .JSON(let name)							: return name
				case .png(let name)								: return name
				case .shader(let name)							: return name
				case .sublimeColourScheme(let name)				: return name
				case .sublimeSyntax(let name)					: return name
				case .sublimeSettings(let name)					: return name
				case .sublimeCompletions(let name)				: return name
                case .tool(let name)                            : return name
				case .folder(let name)                          : return name
				case .nameAndFileType(let name, _)				: return name
			}
		}
	}
	
	var fileType : String {
		get {
			switch self {
				case .JSON									: return ".json"
				case .png									: return ".png"
				case .shader								: return ".glsl"
				case .sublimeColourScheme					: return ".sublime-color-scheme"
				case .sublimeSyntax							: return ".sublime-syntax"
				case .sublimeSettings						: return ".sublime-settings"
				case .sublimeCompletions					: return ".sublime-completions"
				case .tool                                  : return environment == .Windows ? ".exe" : ""
				case .folder                                : return ""
				case .nameAndFileType( _, let filetype)		: return filetype
			}
		}
	}
	
	var fileName : String {
		get {
			return name + fileType
		}
	}
	
	var fileSize : Int {
		get {
			return self.data.length
		}
	}
	
	var data : XGMutableData {
		get {
			let d = XGMutableData(contentsOfFile: self.path)
			d.file = .nameAndFolder(self.fileName, .Documents)
			return d
		}
	}
	
	var json : AnyObject {
		if let jsonObject =  try? JSONSerialization.jsonObject(with: self.data.data as Data, options: JSONSerialization.ReadingOptions.mutableContainers) {
			return jsonObject as AnyObject
		} else {
			return [String: String]() as AnyObject
		}
	}

	func copy(to file: XGFiles) {
		switch self {
		case .folder: assertionFailure("Cannot copy folder to file"); break
		default: copy(to: file.path)
		}
	}

	func copy(to folder: XGFolders) {
		switch self {
		case .folder: copy(to: folder.path)
		default: copy(to: XGFiles.nameAndFolder(fileName, folder))
		}
	}
	
    func copy(to path: String) {
		let srcPath = self.path
		let dstPath = path

		switch self {
		case .folder(let name):
			if name == "wiimm" {
				let folder = XGFolders.path(srcPath)
				if !folder.exists {
					let wiimm = XGFolders.Wiimm
					let wimgt = XGFiles.wimgt
					let wit = XGFiles.wit
					if !wiimm.exists {
						wiimm.createDirectory()
					}
					if !wit.exists {
						XGResources.tool(wit.fileName).copy(to: wit)
					}
					if !wimgt.exists {
						XGResources.tool(wimgt.fileName).copy(to: wimgt)
					}
					return
				}
			}
		default:
			break
		}

		if settings.verbose {
			printg("Copying resource:", srcPath, "to:", dstPath)
		}

		guard srcPath != "" else {
			printg("resource doesn't exist:", name)
            return
        }
        guard dstPath != "" else {
            assertionFailure("cannot copy resource \(name) to unspecified path")
            return
        }

        do {
            try FileManager.default.copyItem(atPath: srcPath, toPath: dstPath)
        } catch let error {
            printg("Error copying resource:", error)
        }
    }
}



















