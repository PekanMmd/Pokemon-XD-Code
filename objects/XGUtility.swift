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
				file.compress()
			}
		}
		
	}
	
	class func compileMainFiles() {
		prepareForQuickCompilation()
		ISO.importFiles([.fsys("common.fsys"),.dol])
		if game == .XD {
			ISO.importFiles([.fsys("deck_archive.fsys")])
		}
	}
	
	class func compileCommonRel() {
		XGFiles.fsys("common.fsys").fsysData.shiftAndReplaceFileWithIndex(0, withFile: XGFiles.common_rel.compress())
		ISO.importFiles([.fsys("common.fsys")])
	}
	
	class func compileDol() {
		ISO.importDol()
	}
	
	class func compileAllFiles() {
		
		prepareForCompilation()
		
		importStringTables()
		importScripts()
		importRels()
		
		ISO.importAllFiles()
	}
	
	class func importRels() {
		for file in XGFolders.Rels.files where file.fileName.contains(".rel") {
			
			printg("importing relocation table: " + file.fileName)
			
			let fsysName = file.fileName.replacingOccurrences(of: ".rel", with: ".fsys")
			let lzssName = file.fileName + ".lzss"
			
			let fsysFile = XGFiles.nameAndFolder(fsysName, XGFolders.AutoFSYS)
			let lzssFile = XGFiles.nameAndFolder(lzssName, XGFolders.LZSS)
			
			if fsysFile.exists && lzssFile.exists {
				let fsys = fsysFile.fsysData
				fsys.shiftAndReplaceFileWithType(.rel, withFile: lzssFile)
			}
		}
	}
	
	class func importScripts() {
		for file in XGFolders.Scripts.files {
			
			printg("importing script: " + file.fileName)
			
			let fsysName = file.fileName.replacingOccurrences(of: ".scd", with: ".fsys")
			let lzssName = file.fileName + ".lzss"
			
			let fsysFile = XGFiles.nameAndFolder(fsysName, XGFolders.AutoFSYS)
			let lzssFile = XGFiles.nameAndFolder(lzssName, XGFolders.LZSS)
			
			if fsysFile.exists && lzssFile.exists {
				fsysFile.fsysData.shiftAndReplaceFileWithType(.scd, withFile: lzssFile)
			}
		}
	}
	
	class func importStringTables() {
		
		for file in XGFolders.StringTables.files {
			
			printg("importing string table: " + file.fileName)
			
			let fsysName = file.fileName.replacingOccurrences(of: ".msg", with: ".fsys")
			let lzssName = file.fileName + ".lzss"
			
			let fsysFile = XGFiles.nameAndFolder(fsysName, XGFolders.AutoFSYS)
			let lzssFile = XGFiles.nameAndFolder(lzssName, XGFolders.LZSS)
			
			if fsysFile.exists && lzssFile.exists {
				fsysFile.fsysData.shiftAndReplaceFileWithType(.msg, withFile: lzssFile)
			}
		}
		
		importSpecificStringTables()
		
	}
	
	class func importTextures() {
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
		for file in XGFolders.Textures.files {
			let filename = file.fileName.removeFileExtensions() + ".png"
			file.texture.saveImage(file: .nameAndFolder(filename, .Export))
		}
	}
	
	class func searchForFsysForFile(file: XGFiles) {
		let iso = ISO
		for name in iso.allFileNames where name.contains(".fsys") {
			let fsys = XGFsys(data: iso.dataForFile(filename: name)!)
			for index in 0 ..< fsys.numberOfEntries {
				if fsys.fileNames[index].contains(file.fileName.removeFileExtensions()) {
					printg("fsys: ",name,", index: ", index, ",name: ", fsys.fileNames[index])
				}
			}
			
		}
	}
	
	class func searchForFsysForIdentifier(id: UInt32) -> XGFsys? {
		let iso = ISO
		for name in iso.allFileNames where name.contains(".fsys") {
			let fsys = XGFsys(data: iso.dataForFile(filename: name)!)
			for index in 0 ..< fsys.identifiers.count {
				if fsys.identifiers[index] == id {
					printg("found id: \(id), fsys: ",name,", index: ", index, ",name: ", fsys.fileNames[index])
					return fsys
				}
			}
			
		}
		return nil
	}
	
	//MARK: - Saving to disk
	class func saveObject(_ obj: AnyObject, toFile file: XGFiles) {
		NSKeyedArchiver.archiveRootObject(obj, toFile: file.path)
	}
	
	class func saveData(_ data: Data, toFile file: XGFiles) {
		try? data.write(to: URL(fileURLWithPath: file.path), options: [.atomic])
	}
	
	class func saveString(_ str: String, toFile file: XGFiles) {
		saveData(str.data(using: String.Encoding.utf8)!, toFile: file)
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
			s.duplicateWithString(r.string).replace()
			
		}
		
	}
	
	class func defaultMoveCategories() {
		let categories = XGFiles.nameAndFolder("Move Categories.json", .JSON).json as! [Int]
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
		}
		
		if value <= kNumberOfAbilities {
			printg("Ability: ",XGAbilities.ability(value).name.string,"\n")
		}
		
		if value <= kNumberOfItems {
			printg("Item: ",XGItems.item(value).name.string,"\n")
		}
		
		// Key items
		if value > kNumberOfItems && value < 0x250 {
			printg("Item: ",XGItems.item(value - 150).name.string,"\n")
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
		
		if value > 0x1000 {
			loadAllStrings()
			printg("String: ",getStringSafelyWithID(id: value),"\n")
		}
		
		
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
	
	class func getMartItemAtOffset(_ offset: Int) -> XGItems {
		
		let dat = XGFiles.pocket_menu.data
		
		return XGItems.item(dat.get2BytesAtOffset(offset))
		
	}
	
	class func replaceMartItemAtOffset(_ offset: Int, withItem item: XGItems) {
		
		let dat = XGFiles.pocket_menu.data
		
		dat.replace2BytesAtOffset(offset, withBytes: item.index)
		
		dat.save()
		
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
			return str.characters.count
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
			return entry.values.map({ (str: String) -> Int in return str.characters.count }).max()!
		}
		for i in 0 ..< names.count {
			lengths[i] = lengths[i] < names[i].characters.count ? names[i].characters.count : lengths[i]
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


/*
// FOR JETSPLIT --------------------------------------------------

// everything can be shiny

// generate PID to match criteria to load random value
let dol = XGFiles.dol.data
dol.replace4BytesAtOffset(0x14155C - kDOLtoRAMOffsetDifference, withBytes: 0x3B40FFFF)
// shiny calc to use fixed TID
dol.replace4BytesAtOffset(0x14416c - kDOLtoRAMOffsetDifference, withBytes: 0x38600000)
dol.replace4BytesAtOffset(0x14af84 - kDOLtoRAMOffsetDifference, withBytes: 0x38600000)

// shadow lugia HUD
dol.replace4BytesAtOffset(0x1118b0 - kDOLtoRAMOffsetDifference, withBytes: kNopInstruction)

dol.save()


ISO.importFiles([.dol])
*/

