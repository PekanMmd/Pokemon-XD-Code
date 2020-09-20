//
//  XGUtility.swift
//  XGCommandLineTools
//
//  Created by StarsMmd on 17/02/2016.
//  Copyright © 2016 StarsMmd. All rights reserved.
//

import Foundation


class XGUtility {
	
	//MARK: - ISO Building
	
	class func compressFiles() {
		
		for folder in compressionFolders where folder.exists {
			for file in folder.files {
				printg("compressing file: " + file.fileName)
				let lzss = file.compress()
				if settings.verbose {
					printg("compressed to: \(lzss.fileName)")
				}
			}
		}
		
	}
	
	class func compileMainFiles() {
		prepareForQuickCompilation()
		importFsys()
		ISO.importFiles([.fsys("common"), XGFiles.fsys("pocket_menu"), XGFiles.fsys("fight_common"), XGFiles.fsys("common_dvdeth"), .dol])
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
			if settings.verbose {
				printg("compiling: \(file.fileName)")
			}
			file.compileMapFsys()
		}
		ISO.importFiles(XGFolders.AutoFSYS.files.filter({  $0.fileType == .fsys }))
	}
	
	class func compileAllMenuFsys() {
		printg("Compiling Menu fsys...")
		for file in XGFolders.MenuFSYS.files where file.fileType == .fsys {
			if settings.verbose {
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
		ISO.importFiles(XGFolders.FSYS.files.filter({  $0.fileType == .fsys }) + [XGFiles.dol])
		
	}
	
	class func importRels() {
		for file in XGFolders.Rels.files where file.fileType == .rel {
			
			if settings.verbose { printg("importing relocation table: " + file.fileName) }
			
			let fsysFile = XGFiles.fsys(file.fileName.removeFileExtensions())
			if fsysFile.exists {
				fsysFile.fsysData.shiftAndReplaceFileWithType(.rel, withFile: file.compress(), save: true)
			}
		}
	}
	
	class func importScripts() {
		for file in XGFolders.Scripts.files where file.fileType == .scd {
			
			if settings.verbose { printg("importing script: " + file.fileName) }
			
			let fsysFile = XGFiles.fsys(file.fileName.removeFileExtensions())
			if fsysFile.exists {
				fsysFile.fsysData.shiftAndReplaceFileWithType(.scd, withFile: file.compress(), save: true)
			}
		}
	}
	
	class func importStringTables() {
		
		for file in XGFolders.AutoFSYS.files where file.fileType == .fsys {
			
			if settings.verbose {
				printg("importing string table: " + file.fileName.removeFileExtensions() + XGFileTypes.msg.fileExtension)
			}
			
			let msgFile = XGFiles.msg(file.fileName.removeFileExtensions())
			
			if msgFile.exists {
				file.fsysData.shiftAndReplaceFileWithType(.msg, withFile: msgFile.compress(), save: true)
			}
		}
		
		importSpecificStringTables()
		
	}

	class func importTPLFiles(_ files: [XGFiles]) {
		if files.isEmpty { return }
		
		printg("importing tpl files...")
		for file in files {
			let source = file.path.escapedPath
			var dest = XGFolders.Textures.path.escapedPath + "/" + file.fileName
			dest = dest.removeFileExtensions() + ".tpl"

			let imageFormatID: Int
			if let underscoreIndex = file.fileName.lastIndex(of: "_") {
				let imageFormatSubstring = file.fileName.substring(from: file.fileName.index(underscoreIndex, offsetBy: 1), to: file.fileName.endIndex)
				let imageFormatNumberString = imageFormatSubstring.removeFileExtensions()
				imageFormatID = imageFormatNumberString.integerValue ?? -1
			} else {
				imageFormatID = -1
			}
			let format = GoDTextureFormats.fromStandardRawValue(imageFormatID) ?? .C8

			let overwrite = "-o"
			let formatString = "-x TPL." + format.name
			let args = "encode \(source) \(overwrite) \(formatString) -d \(dest)"
			if settings.verbose {
				printg(GoDShellManager.Commands.wimgt.file.path + " " + args)
			}
			GoDShellManager.run(.wimgt, args: args)
		}
	}
	
	class func importTextures() {
		// into the .gtx file, not into ISO
		
		for image in XGFolders.Import.files where [XGFileTypes.png, .jpeg, .bmp].contains(image.fileType) && !image.fileName.contains(".tpl") {
			
			let textureFilename = image.fileName.removeFileExtensions() + XGFileTypes.gtx.fileExtension
			let animTextureFilename = image.fileName.removeFileExtensions() + XGFileTypes.atx.fileExtension
			
			let tFile = XGFiles.nameAndFolder(textureFilename, .TextureImporter)
			let aFile = XGFiles.nameAndFolder(animTextureFilename, .TextureImporter)
			
			if tFile.exists || aFile.exists {
				if tFile.exists {
					GoDTextureImporter.replaceTextureData(texture: tFile.texture, withImage: image, save: true)
				}
				if aFile.exists {
					GoDTextureImporter.replaceTextureData(texture: aFile.texture, withImage: image, save: true)
				}
			} else {
				let textures = image.image.textures
				for texture in textures {
					let filename = tFile.fileName.removeFileExtensions() + "_\(texture.format.name)" + XGFileTypes.gtx.fileExtension
					texture.file = .nameAndFolder(filename, tFile.folder)
					texture.save()
				}
			}
		}
		
		XGColour.colourThreshold = 0
		for file in XGFolders.Textures.files where file.fileExtension == ".png" && !file.fileName.contains(".tpl") {
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

		importTPLFiles(XGFolders.Import.files.filter({ (file) -> Bool in
			file.fileName.contains(".tpl.png")
		}))
	}

	class func exportTPLFiles(_ files: [XGFiles]) {
		if files.isEmpty { return }

		printg("exporting tpl files...")
		for file in files {
			let source = file.path.escapedPath
			let dest = XGFolders.Export.path.escapedPath + "/" + file.fileName + ".png"

			let overwrite = "-o"

			let args = "copy \(source) \(overwrite) -d \(dest)"
			if settings.verbose {
				printg(GoDShellManager.Commands.wimgt.file.path + " " + args)
			}
			GoDShellManager.run(.wimgt, args: args)
		}
	}
	
	class func exportTextures() {
		// from .gtx file, not from ISO
		for file in XGFolders.Textures.files where [".gtx", ".atx"].contains(file.fileExtension)  {
			let filename = file.fileName.removeFileExtensions() + ".png"
			file.texture.saveImage(file: .nameAndFolder(filename, .Export))
		}
		exportTPLFiles(XGFolders.Textures.files.filter({ (file) -> Bool in
			file.fileExtension == "tpl"
		}))
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
		if settings.verbose {
			printg("Searching for fsys containing identifier: \(id.hexString())")
		}
		for name in iso.allFileNames where name.fileExtensions == ".fsys" {
			let fsys = iso.dataForFile(filename: name)!.fsysData
			for index in 0 ..< fsys.identifiers.count {
				if fsys.identifiers[index] == id {
					if settings.verbose {
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
		// TODO: check if can delete fsys files used for creating prerendered cutscenes
		
		var substrings = [String]()
		if game == .XD {
			substrings = ["Script_t","_test", "debug", "DNA", "keydisc", "M2_cave"]
			if region != .EU  {
				substrings += ["_fr.","_ge.","_it.", "_sp."]
				substrings += ["l_fr","l_ge","l_it", "l_sp"]
				substrings += ["g_fr","g_ge","g_it", "g_sp"]
			}
		} else {
			substrings = ["carde", "ex", "debug"]
		}
		
		for file in ISO.allFileNames {
			for substring in substrings {
				if file.contains(substring) && !file.contains("wzx") && !file.contains("pkx") {
					ISO.deleteFileAndPreserve(name: file, save: false)
				}
			}
		}
		ISO.save()
		
	}
	
	//MARK: - Saving to disk
	class func saveObject(_ obj: AnyObject, toFile file: XGFiles) {
		if !file.folder.exists {
			file.folder.createDirectory()
		}
		NSKeyedArchiver.archiveRootObject(obj, toFile: file.path)
	}
	
	@discardableResult class func saveData(_ data: Data, toFile file: XGFiles) -> Bool {
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
			printg("Type: ",XGMoveTypes.type(value),"\n")
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
		let dat = XGFiles.pocket_menu.data!
		
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
	
}


