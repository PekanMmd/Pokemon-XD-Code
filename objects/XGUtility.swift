//
//  XGUtility.swift
//  XGCommandLineTools
//
//  Created by StarsMmd on 17/02/2016.
//  Copyright © 2016 StarsMmd. All rights reserved.
//

import Foundation

var compressionTooLarge = false
var commonTooLarge = false

class XGUtility {
	
	//MARK: - ISO Building
	
	class func compressFiles() {
		
		for folder in compressionFolders where folder.exists {
			for file in folder.files {
				printg("compressing file: " + file.fileName)
				let lzss = file.compress()
				if verbose {
					printg("compressed to: \(lzss.fileName)")
				}
			}
		}
		
	}
	
	class func compileMainFiles() {
		prepareForCompilation()
		ISO.importFiles([.fsys("common"), .dol])
		if game == .XD {
			ISO.importFiles([.fsys("deck_archive")])
		}
	}
	
	class func compileCommonRel() {
		XGFiles.fsys("common").fsysData.shiftAndReplaceFileWithIndexEfficiently(0, withFile: XGFiles.common_rel.compress(), save: true)
		ISO.importFiles([.fsys("common")])
	}
	
	class func compileDol() {
		ISO.importDol()
	}
	
	class func compileAllMapFsys() {
		printg("Compiling Map fsys...")
		for file in XGFolders.AutoFSYS.files where file.fileType == .fsys {
			if verbose {
				printg("compiling: \(file.fileName)")
			}
			file.compileMapFsys()
		}
		ISO.importFiles(XGFolders.AutoFSYS.files.filter({  $0.fileType == .fsys }))
	}
	
	class func compileAllMenuFsys() {
		printg("Compiling Menu fsys...")
		for file in XGFolders.MenuFSYS.files where file.fileType == .fsys {
			if verbose {
				printg("compiling: \(file.fileName)")
			}
			file.compileMenuFsys()
		}
		ISO.importFiles(XGFolders.MenuFSYS.files.filter({  $0.fileType == .fsys }))
	}
	
	class func compileAllFiles() {
		
		prepareForCompilation()
		compileAllMapFsys()
		compileAllMenuFsys()
		importFsys()
		
		ISO.importAllFiles()
	}
	
	class func importRels() {
		for file in XGFolders.Rels.files where file.fileType == .rel {
			
			if verbose { printg("importing relocation table: " + file.fileName) }
			
			let fsysFile = XGFiles.fsys(file.fileName.removeFileExtensions())
			if fsysFile.exists {
				fsysFile.fsysData.shiftAndReplaceFileWithType(.rel, withFile: file.compress(), save: true)
			}
		}
	}
	
	class func importScripts() {
		for file in XGFolders.Scripts.files where file.fileType == .scd {
			
			if verbose { printg("importing script: " + file.fileName) }
			
			let fsysFile = XGFiles.fsys(file.fileName.removeFileExtensions())
			if fsysFile.exists {
				fsysFile.fsysData.shiftAndReplaceFileWithType(.scd, withFile: file.compress(), save: true)
			}
		}
	}
	
	class func importStringTables() {
		
		for file in XGFolders.AutoFSYS.files where file.fileType == .fsys {
			
			if verbose {
				printg("importing string table: " + file.fileName.removeFileExtensions() + XGFileTypes.msg.fileExtension)
			}
			
			let msgFile = XGFiles.msg(file.fileName.removeFileExtensions())
			
			if msgFile.exists {
				file.fsysData.shiftAndReplaceFileWithType(.msg, withFile: msgFile.compress(), save: true)
			}
		}
		
		importSpecificStringTables()
		
	}
	
	class func importTextures() {
		// into the .gtx file, not into ISO
		for file in XGFolders.Textures.files {
			var imageFile : XGFiles!
			for image in XGFolders.Import.files {
				if image.fileName.removeFileExtensions() == file.fileName.removeFileExtensions() {
					imageFile = image
				}
			}
			if imageFile != nil {
				file.texture.importImage(file: imageFile!)
			}
		}
		
	}
	
	class func exportTextures() {
		// from .gtx file, not from ISO
		for file in XGFolders.Textures.files {
			let filename = file.fileName.removeFileExtensions() + ".png"
			file.texture.saveImage(file: .nameAndFolder(filename, .Export))
		}
	}
	
	class func searchForFsysForFile(file: XGFiles) {
		let iso = ISO
		for name in iso.allFileNames where name.fileExtensions == ".fsys" {
			let fsys = iso.dataForFile(filename: name)!.fsysData
			for index in 0 ..< fsys.numberOfEntries {
				if fsys.fileNames[index].contains(file.fileName.removeFileExtensions()) {
					printg("fsys: ", name, ", index: ", index, ", file type: ", fsys.fileTypeForFile(index: index).fileExtension, ", name: ", fsys.fileNameForFileWithIndex(index: index))
				}
			}
			
		}
	}
	
	class func searchForFsysForIdentifier(id: UInt32) -> [XGFsys] {
		let iso = ISO
		var found = [XGFsys]()
		if verbose {
			printg("Searching for fsys containing identifier: \(id.hexString())")
		}
		for name in iso.allFileNames where name.fileExtensions == ".fsys" {
			let fsys = iso.dataForFile(filename: name)!.fsysData
			for index in 0 ..< fsys.identifiers.count {
				if fsys.identifiers[index] == id {
					if verbose {
						printg("found id: \(id), fsys: ",name,", index: ", index, ", name: ", fsys.fileNames[index])
					}
					found += [fsys]
				}
			}
			
		}
		return found
	}
	
	class func deleteSuperfluousFiles() {
		// deletes files that the game doesn't use in order to create space in the ISO for larger fsys files
		if game == .XD {
			var substrings = ["ex_","M2_cave","M4","Script_t","test","TEST","carde", "debug", "DNA", "keydisc"]
			if region != .EU  {
				substrings += ["_fr.","_ge.","_it."]
			}
			for file in ISO.allFileNames {
				for substring in substrings {
					if file.contains(substring) {
						ISO.deleteFileAndPreserve(name: file, save: false)
					}
				}
				for i in 1 ... 7 {
					let b1Name = "B1_\(i).fsys"
					if file == b1Name {
						ISO.deleteFileAndPreserve(name: file, save: false)
					}
				}
			}
			ISO.save()
		}
		
	}
	
	//MARK: - Saving to disk
	class func saveObject(_ obj: AnyObject, toFile file: XGFiles) {
		NSKeyedArchiver.archiveRootObject(obj, toFile: file.path)
	}
	
	class func saveData(_ data: Data, toFile file: XGFiles) -> Bool {
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
				printg("Couldn't save string to file: \(file.path)")
			}
		} else {
			printg("Couldn't encode string for file: \(file.path)")
		}
	}
	
	class func saveJSON(_ json: AnyObject, toFile file: XGFiles) {
		do {
			try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted).write(to: URL(fileURLWithPath: file.path), options: [.atomic])
		} catch {
			printg("couldn't save json to file: \(file.path)")
		}
	}
	
	class func loadJSONFromFile(_ file: XGFiles) -> AnyObject? {
		do {
			let json = try JSONSerialization.jsonObject(with: file.data.data as Data, options: [])
			return json as AnyObject?
		} catch {
			printg("couldn't load json from file: \(file.path)")
			return nil
		}
	}
	
	//MARK: - Utilities 1
	class func transferStringTableFrom(_ from: XGStringTable, to: XGStringTable) {
		
		for s in to.allStrings() {
			let r = from.stringSafelyWithID(s.id)
			let new = s.duplicateWithString(r.string)
			new.table = to.file
			if !to.replaceString(new, alert: false, save: false) {
				printg("string table transfer failed. the target file was probably too small.")
				return
			}
		}
		to.save()
		
	}
	
	class func defaultMoveCategories() {
		let categories = XGFiles.json("Move Categories").json as! [Int]
		for i in 0 ..< kNumberOfMoves {
			let move = XGMove(index: i)
			move.category = XGMoveCategories(rawValue: categories[i]) ?? XGMoveCategories.none
			move.save()
		}
		if game == .Colosseum {
			let move = XGMove(index: 355)
			move.category = .physical
			move.save()
		}
		printg("all moves have now had their default phys/spec categories applied.")
		
	}
	
	//MARK: - Utilities 2
	
	class func valueContext(_ value: Int) {
		printg("Value:", value, "can have the following meanings:\n")
		if value <= kNumberOfMoves {
			printg("Move: ",XGMoves.move(value).name.string,"\n")
		}
		if value <= kNumberOfPokemon {
			printg("Pokemon: ",XGPokemon.pokemon(value).name.string,"\n")
			
			if value > 251 {
				printg("Pokemon national index: ", XGPokemon.nationalIndex(value).name.string,"\n")
			}
		}
		
		if value <= kNumberOfAbilities {
			printg("Ability: ",XGAbilities.ability(value).name.string,"\n")
		}
		
		if value <= kNumberOfItems {
			printg("Item: ",XGItems.item(value).name.string,"\n")
		} else if value > kNumberOfItems && value < 0x250 {
			printg("Item scriptIndex: ",XGItems.item(value - 150).name.string,"\n")
		}
		
		if value < kNumberOfTypes {
			printg("Type: ",XGMoveTypes(rawValue: value)!,"\n")
		}
		
		for i in 1 ..< kNumberOfItems {
			let item = XGItems.item(i).data
			if item.holdItemID == value {
				printg("Hold item id: ",item.name.string,"\n")
			}
			if item.inBattleUseID == value {
				printg("In battle item id: ",item.name.string,"\n")
			}
		}
		
		loadAllStrings()
		printg("String: ",getStringSafelyWithID(id: value),"\n")
		
		
	}
	
	//MARK: - Pokemarts
	class func printPokeMarts() {
		let dat = XGFiles.pocket_menu.data
		
		let itemHexList = dat.getShortStreamFromOffset(0x300, length: 0x170)
		
		for j in 0..<itemHexList.count {
			let i = itemHexList[j]
			
			if i == 0x1FF {
				printg("---------")
				continue
			}
			let item = XGItems.item(i)
			
			var tmName = ""
			for i in 1 ... kNumberOfTMs {
				if XGTMs.tm(i).item.index == item.index {
					tmName = "(" + XGTMs.tm(i).move.name.string + ")"
				}
			}
			
			printg("\(0x300 + (j*2)):\t",item.index,item.name.string,tmName,"\n")
		}
		
	}
	
	
	//MARK: - Utilities 3
	class func printDictionaryRepresentationFunction(_ values: [String], enums: [String], arrays: [String], enumArrays: [String]) {
		
		
		var string = "var dictionaryRepresentation : [String : AnyObject] {\nget { \n"
		string += "var dictRep = [String : AnyObject]()\n"
		
		for value in values {
			string += "dictRep[\"\(value)\"] = self.\(value) as AnyObject?\n"
		}
		
		string += "\n"
		
		for en in enums {
			string += "dictRep[\"\(en)\"] = self.\(en).dictionaryRepresentation as AnyObject?\n"
		}
		
		string += "\n"
		
		for arr in arrays {
			string += "var \(arr)Array = [AnyObject]()\n"
			string += "for a in \(arr) {\n \(arr)Array.append(a)\n}\n"
			string += "dictRep[\"\(arr)\"] = \(arr)Array as AnyObject?\n\n"
		}
		
		for arr in enumArrays {
			string += "var \(arr)Array = [ [String : AnyObject] ]()\n"
			string += "for a in \(arr) {\n \(arr)Array.append(a.dictionaryRepresentation)\n}\n"
			string += "dictRep[\"\(arr)\"] = \(arr)Array as AnyObject?\n\n"
		}
		
		string += "return dictRep\n}\n}\n\n"
		
		
		string += "var readableDictionaryRepresentation : [String : AnyObject] {\nget { \n"
		string += "var dictRep = [String : AnyObject]()\n"
		
		for value in values {
			string += "dictRep[\"\(value)\"] = self.\(value) as AnyObject?\n"
		}
		
		string += "\n"
		
		for en in enums {
			string += "dictRep[\"\(en)\"] = self.\(en).string as AnyObject?\n"
		}
		
		string += "\n"
		
		for arr in arrays {
			string += "var \(arr)Array = [AnyObject]()\n"
			string += "for a in \(arr) {\n \(arr)Array.append(a)\n}\n"
			string += "dictRep[\"\(arr)\"] = \(arr)Array as AnyObject?\n\n"
		}
		
		for arr in enumArrays {
			string += "var \(arr)Array = [AnyObject]()\n"
			string += "for a in \(arr) {\n \(arr)Array.append(a.string)\n}\n"
			string += "dictRep[\"\(arr)\"] = \(arr)Array as AnyObject?\n\n"
		}
		
		string += "return [self.name.string : dictRep]\n}\n}\n\n"
		
		printg(string)
		
	}
	
	//MARK: - Documentation
	class func documentData(title: String, data: [ (name: String, values: [String], spacedLeft: Bool) ]) {
		documentDataVertically(title: title, data: data)
		documentDataHorizontally(title: title, data: data)
	}
	
	class func documentDataVertically(title: String, data: [ (name: String, values: [String], spacedLeft: Bool) ]) {
		
		var string  = title + "\n\n"
		let entries = data[0].values.count
		let values  = data.count
		let names = data.map { (entry: (name: String, values: [String], spacedLeft: Bool)) -> String in
			return entry.name
		}
		let nameLength = names.map { (str : String) -> Int in
			return str.length
			}.max()!
		
		for e in 0 ..< entries {
			for v in 0 ..< values {
				
				let name   = data[v].name
				let value  = data[v].values[e]
				string += (name + ":").spaceToLength(nameLength + 1) + "    "
				string += value + "\n"
				
			}
			string += "\n\n"
		}
		
		saveString(string, toFile: XGFiles.nameAndFolder(title + " list.txt", XGFolders.Reference))
	}
	
	class func documentDataHorizontally(title: String, data: [ (name: String, values: [String], spacedLeft: Bool) ]) {
		
		var string  = title + "\n\n"
		let entries = data[0].values.count
		let values  = data.count
		let names = data.map { (entry: (name: String, values: [String], spacedLeft: Bool)) -> String in
			return entry.name
		}
		var lengths = data.map { ( entry: (name: String, values: [String], spacedLeft: Bool) ) -> Int in
			return entry.values.map({ (str: String) -> Int in return str.length }).max()!
		}
		for i in 0 ..< names.count {
			lengths[i] = lengths[i] < names[i].length ? names[i].characters.count : lengths[i]
		}
		
		var header = "\n"
		for n in 0 ..< names.count {
			
			let name   = names[n]
			let length = lengths[n]
			header += name.spaceToLength(length)
			header += "    "
		}
		header += "\n\n"
		
		string += header
		
		for e in 0 ..< entries {
			
			if (e % 20 == 0) && (e != 0) && (entries > 30) {
				string += header
			}
			
			for v in 0 ..< values {
				
				let value  = data[v].values[e]
				let length = lengths[v]
				let left   = data[v].spacedLeft
				string += left ? value.spaceLeftToLength(length) : value.spaceToLength(length)
				string += "    "
			}
			string += "\n"
		}
		
		saveString(string, toFile: XGFiles.nameAndFolder(title + " table.txt", XGFolders.Reference))
	}
	
}


