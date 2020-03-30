//
//  PBRExtensions.swift
//  GoDToolCL
//
//  Created by The Steez on 24/12/2018.
//

import Foundation

enum XGRegions : UInt32 {
	
	case US = 0x52504245 // RPBE
	case EU = 0x52504250 // RPBP
	case JP = 0x5250424A // RPBJ
	
	var index : Int {
		switch self {
		// arbitrary values
		case .US: return 0
		case .EU: return 1
		case .JP: return 2
		}
	}
	
}

enum XGGame {
	case Colosseum
	case XD
	case PBR
    
    var name: String {
		switch self {
		case .Colosseum: return "Pokemon Colosseum"
		case .XD: return "Pokemon XD: Gale of Darkness"
		case .PBR: return "Pokemon Battle Revolution"
		}
	}
}

let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/Revolution-Tool"
let region = XGRegions.US
let game = XGGame.PBR

let date = Date(timeIntervalSinceNow: 0)
var logString = ""


class XGUtility {
	class func saveData(_ data: Data, toFile file: XGFiles) -> Bool {
		if !file.folder.exists {
			file.folder.createDirectory()
		}
		do {
			try data.write(to: URL(fileURLWithPath: file.path), options: [.atomic])
		} catch {
			return false
		}
		return true
	}
	
	class func saveString(_ str: String, toFile file: XGFiles) {
		
		if let string = str.data(using: String.Encoding.utf8) {
			if !saveData(string, toFile: file) {
				// if printging to a log fails, don't keep printging :)
				if file.folder.name != XGFolders.Logs.name {
					printg("Couldn't save string to file: \(file.path)")
				} else {
					print("Couldn't save string to file: \(file.path)")
				}
			}
		} else {
			// if printging to a log fails, don't keep printging :)
			if file.folder.name != XGFolders.Logs.name {
				printg("Couldn't encode string for file: \(file.path)")
			} else {
				print("Couldn't encode string for file: \(file.path)")
			}
		}
	}
	
	class func saveJSON(_ json: AnyObject, toFile file: XGFiles) {
		if !file.folder.exists {
			file.folder.createDirectory()
		}
		do {
			try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted).write(to: URL(fileURLWithPath: file.path), options: [.atomic])
		} catch {
			printg("couldn't save json to file: \(file.path)")
		}
	}
	
	class func loadJSONFromFile(_ file: XGFiles) -> AnyObject? {
		do {
			let json = try JSONSerialization.jsonObject(with: file.data!.data as Data, options: [])
			return json as AnyObject?
		} catch {
			printg("couldn't load json from file: \(file.path)")
			return nil
		}
	}
	
	// extraction
	@discardableResult
	class func decompileISO(printOutput: Bool = true) -> String? {
        printg("decompiling ISO using wit. This will overwrite any existing files...")
        if !XGFiles.iso.exists {
            printg("ISO doesn't exist:", XGFiles.iso.path)
            return nil
        }
        let verbose = settings.verbose ? "-v " : ""
        let overwrite = "-o"
        let args = "extract \(verbose) \(overwrite) \(XGFiles.iso.path) \(XGFolders.ISODump.path)"
        return GoDShellManager.run(.wit, args: args, printOutput: printOutput)
    }
    
	class func extractMainFiles() {
		XGFolders.setUpFolderFormat()
		
		printg("extracting required files...")
		let requiredFiles : [XGFiles] = [.fsys("common"), .fsys("mes_common"), .fsys("deck")]
		var fileMissing = false
		for file in requiredFiles {
			if !file.exists {
				printg("Error: required file '\(file.path)' doesn't exist")
				fileMissing = true
			}
		}
		if fileMissing {
            printg("At least one required file was missing, try decompiling the ISO first.")
            return
        }
		
		let fsys = XGFiles.fsys("deck").fsysData
		
		var tid = 0
		var pid = 0
		for i in 0 ..< fsys.numberOfEntries {
			if !XGFiles.dckt(i).exists {
				let data = fsys.decompressedDataForFileWithIndex(index: i)!
				
				if let type = XGDeckTypes(rawValue: data.getWordAtOffset(0)) {
					switch type {
						case .DCKA: data.file = .dcka
						case .DCKP: data.file = .dckp(pid); pid += 1
						case .DCKT: data.file = .dckt(tid); tid += 1
						case .none: data.file = .nameAndFolder("deck_\(i)", .Decks)
					}
					
				} else {
					data.file = .nameAndFolder("deck_\(i)", .Decks)
				}
				data.save()
			}
		}
		
		let common = XGFiles.fsys("common").fsysData
		for i in 0 ... 32 {
			if !XGFiles.common(i).exists {
				let data = common.decompressedDataForFileWithIndex(index: i)!
				data.file = .common(i)
				data.save()
			}
		}
		
		if !XGFiles.msg("mes_common").exists {
			let msg = XGFiles.fsys("mes_common").fsysData.decompressedDataForFileWithIndex(index: 1)!
			msg.file = .msg("mes_common")
			msg.save()
		}
        
        if !XGFiles.msg("mes_fight_e").exists {
            let msg = XGFiles.fsys("mes_fight_e").fsysData.decompressedDataForFileWithIndex(index: 1)!
            msg.file = .msg("mes_fight_e")
            msg.save()
        }
        
        if !XGFiles.msg("mes_name_e").exists {
            let msg = XGFiles.fsys("mes_name_e").fsysData.decompressedDataForFileWithIndex(index: 1)!
            msg.file = .msg("mes_name_e")
            msg.save()
        }
        
		printg("extraction complete!")
		
	}
	
	class func extractAllFiles() {
		XGFolders.setUpFolderFormat()
        extractMainFiles()
        printg("extracting fsys files...\nThis may take a while")
        for file in XGFolders.FSYS.files where file.fileType == .fsys {
            printg("extracting:", file.path)
            let fsys = file.fsysData
            if let msg = fsys.decompressedDataForFileWithFiletype(type: .msg) {
                msg.file = .msg(msg.file.fileName.removeFileExtensions())
                if !msg.file.exists {
                    msg.save()
                }
            }
            let folder = XGFolders.ISOExport(fsys.fileName.removeFileExtensions())
            folder.createDirectory()
            fsys.extractFilesToFolder(folder: folder, decode: true)
        }
        printg("extraction complete!")
    }
    
    class func compileMainFiles() {
        XGFolders.setUpFolderFormat()
        printg("compiling all files...")
        compileDecks()
        compileCommon()
        compileMSG()
    }

	@discardableResult
	class func compileISO(printOutput: Bool = true) -> String? {
        printg("compiling ISO...\nThis will overwrite the existing ISO")
        let verbose = settings.verbose ? "-v " : ""
        let overwrite = "-o"
        let args = "copy --raw \(overwrite) \(verbose) \(XGFolders.ISODump.path) \(XGFiles.iso.path)"
        return GoDShellManager.run(.wit, args: args, printOutput: printOutput)
    }
	
	class func getFSYSForIdentifier(id: UInt32) -> XGFsys? {
		for file in XGFolders.FSYS.files where file.fileName.contains(".fsys") {
			let fsys = file.data!
			let entries = fsys.get4BytesAtOffset(kNumberOfEntriesOffset)
			
			for i in 0 ..< entries {
				let details = fsys.get4BytesAtOffset(0x60)
				let identifier = fsys.getWordAtOffset(details + (i * kSizeOfArchiveEntry))
				if identifier == id {
					return file.fsysData
				}
			}
			
		}
		return nil
	}
	
	class func compileDecks() {
		printg("Compiling decks...")
		var pid = 0
		var tid = 0
		
		var deckDict = [Int : XGFiles]()
		for i in 0 ... 25 {
			deckDict[i] = .dckt(tid)
			tid += 1
		}
		for i in 0 ... 7 {
			deckDict[i + 26] = .dckp(pid)
			pid += 1
		}
		deckDict[34] = .dckt(tid)
		tid += 1
		for i in 0 ... 5 {
			deckDict[35 + i] = .dckp(pid)
			pid += 1
		}
		for i in 0 ... 1 {
			deckDict[41 + i] = .dckt(tid)
			tid += 1
		}
		for i in 0 ... 1 {
			deckDict[43 + i] = .dckp(pid)
			pid += 1
		}
		deckDict[45] = .dcka
		
		let file = XGFiles.fsys("deck")
		if file.exists {
			let fsys = XGFiles.fsys("deck").fsysData
			
			for (index, file) in deckDict {
				if file.exists {
					if settings.verbose {
						printg("Compiling deck:", file.path)
					}
					fsys.shiftAndReplaceFileWithIndexEfficiently(index, withFile: file.compress(), save: false)
				}
			}
			
			fsys.save()
			printg("Finished compiling decks.")
		} else {
			printg("Couldn't compile decks as \(file.path) doesn't exist")
		}
		
	}
    
    class func compileCommon() {
        printg("Compiling common...")
        let file = XGFiles.fsys("common")
        if file.exists {
            let fsys = XGFiles.fsys("common").fsysData
            
            for cid in 0 ... 32 {
                let cFile = XGFiles.common(cid)
                if cFile.exists {
                    if settings.verbose {
                        printg("Compiling common:", cFile.path)
                    }
                    fsys.shiftAndReplaceFileWithIndexEfficiently(cid, withFile: cFile.compress(), save: false)
                }
            }
            
            fsys.save()
            printg("Finished compiling common.")
        } else {
            printg("Couldn't compile common as \(file.path) doesn't exist")
        }
        
    }
    
    class func compileMSG() {
        printg("Compiling msgs...")
        
        for filename in ["mes_common", "mes_fight_e", "mes_name_e"] {
            let fsys = XGFiles.fsys(filename)
            let msg = XGFiles.msg(filename)
            if fsys.exists && msg.exists {
                if settings.verbose {
                    printg("Compiling msg:", msg.path)
                }
                let fsysData = fsys.fsysData
                fsysData.shiftAndReplaceFileWithIndexEfficiently(1, withFile: msg.compress(), save: true)
            }
        }
        printg("Finished compiling msgs.")
    }
	
}


var allStringTables = [XGStringTable]()
var stringsLoaded = false

func loadAllStrings() {
	
	if !stringsLoaded {
		
		// very specific order based on the id at index 0xb in the .msg file
		// files with the same id are identical but may be loaded at different times
		// the first stringid in the next file is one greater than the last stringid of the previous file
		allStringTables = [XGFiles.msg("mes_common").stringTable, XGFiles.msg("mes_fight_e").stringTable, XGFiles.msg("mes_name_e").stringTable]
		
		stringsLoaded = true
	}
	
}

func getStringWithID(id: Int) -> XGString? {
	loadAllStrings()
	
	if id == 0 {
		return nil
	}
	
	var currentID = id
	for table in allStringTables {
		if table.containsStringWithId(currentID) {
			if let s = table.stringWithID(currentID) {
				return s
			}
		} else {
			currentID -= table.numberOfEntries
		}
	}
	return nil
}

func getStringSafelyWithID(id: Int) -> XGString {
	loadAllStrings()
	
	return getStringWithID(id: id) ?? XGString(string: "-", file: nil, sid: nil)
}

func getStringsContaining(substring: String) -> [XGString] {
	loadAllStrings()
	
	var found = [XGString]()
	for table in allStringTables {
		for str in table.allStrings() where str.containsSubstring(substring) {
			found.append(str)
		}
	}
	
	return found
}


extension XGUtility {
	//MARK: - Documentation
	class func documentXDS() { }
	class func documentMacrosXDS() { }
	class func documentXDSClasses() { }
	class func documentXDSAutoCompletions(toFile file: XGFiles) { }
	
	class func documentISO() {
		
	}
}












