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
	case nameAndFileType(String, String)
	
	var path : String {
		get{
			return Bundle.main.path(forResource: name, ofType: fileType) ?? FileManager.default.currentDirectoryPath + "/Assets/\(game.shortName)/\(fileName.replacingOccurrences(of: " ", with: "\\ "))"
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
                case .tool                                  : return ""
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
		get {
			return try! JSONSerialization.jsonObject(with: self.data.data as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
		}
	}
	
    func copy(to file: XGFiles) {
        guard path != "" else {
			printg("resource doesn't exist:", name)
            return
        }
        guard file.path != "" else {
            assertionFailure("no path specified for file")
            return
        }

        do {
			let path = self.path
			if settings.verbose {
				printg("Copying resource:", path, "to:", file.path)
			}
            try FileManager.default.copyItem(atPath: path, toPath: file.path)
        } catch {
            let data = self.data
            data.file = file
            data.save()
        }
        
    }
}



















