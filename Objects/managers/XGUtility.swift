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
		prepareForCompilation()
		ISO.importFiles([.fsys("common"), XGFiles.fsys("pocket_menu"), XGFiles.fsys("fight_common"), .dol])
		if game == .XD {
			ISO.importFiles([.fsys("deck_archive")])
			if !isDemo && region != .JP {
				ISO.importFiles([.fsys("common_dvdeth")])
			}
			let dukingTradeFsysFile = XGFiles.fsys("M2_guild_1F_2")
			if dukingTradeFsysFile.exists {
				ISO.importFiles([dukingTradeFsysFile])
			}
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
		ISO.importFiles(XGFolders.FSYS.files.filter({  $0.fileType == .fsys }) + [XGFiles.dol])
		
	}

	class func exportFileFromISO(_ file: XGFiles, decode: Bool = true) -> Bool {
		XGFolders.ISOExport("").createDirectory()

		if let data = ISO.dataForFile(filename: file.fileName) {
			if data.length > 0 {
				data.file = file
				if file.fileType == .fsys {
					let fsysData = data.fsysData
					fsysData.extractFilesToFolder(folder: file.folder, decode: decode)
				}
				data.save()
				return true
			}
		}
		return false
	}

	class func importFileToISO(_ fileToImport: XGFiles, encode: Bool = true) -> Bool {
		if fileToImport.exists {
			if fileToImport.fileType == .fsys {

				if encode {
					XGColour.colourThreshold = 0
					for file in fileToImport.folder.files {



						// encode string tables before compiling scripts
						if file.fileType == .msg {
							for json in fileToImport.folder.files where json.fileType == .json {
								if json.fileName.removeFileExtensions() == file.fileName.removeFileExtensions() {
									if settings.verbose {
										printg("importing \(json.path) into \(file.path)")
									}
									let table = try? XGStringTable.fromJSONFile(file: json)
									if let table = table {
										table.file = file
										table.save()
									} else {
										printg("Failed to decode string table from: ", json.path)
									}
								}
							}
						}

						if file.fileType == .thp, let thpData = file.data {
							let thp = XGTHP(thpData: thpData)
							thp.headerData.save()
							thp.bodyData.save()
						}

						if file.fileType == .gtx || file.fileType == .atx {
							for imageFile in fileToImport.folder.files where XGFileTypes.imageFormats.contains(imageFile.fileType) {
								if imageFile.fileName.removeFileExtensions() == file.fileName.removeFileExtensions() {
									if settings.verbose {
										printg("importing \(imageFile.path) into \(file.path)")
									}
									if let image = XGImage.loadImageData(fromFile: imageFile) {
										let texture: GoDTexture
										if file.fileName.contains(".gsw.") {
											// preserves the image format so can easily be imported into gsw
											texture = image.getTexture(format: file.texture.format)

										} else {
											// automatically chooses a good format for the new image
											texture = image.texture
										}
										texture.file = file
										texture.save()
									}
								}
							}
						}
					}

					for file in fileToImport.folder.files {
						// encode gsws after all gtxs have been encoded
						if file.fileType == .gsw {
							let gsw = XGGSWTextures(data: file.data!)

							for subFile in fileToImport.folder.files where subFile.fileName.contains(gsw.subFilenamesPrefix) && subFile.fileType == .gtx {
								if settings.verbose {
									printg("importing \(subFile.path) into \(file.path)")
								}
								if let id = subFile.fileName.removeFileExtensions().replacingOccurrences(of: gsw.subFilenamesPrefix, with: "").integerValue {
									gsw.importTextureData(subFile.data!, withID: id)
								}
							}

							gsw.save()
						}

						// import textures into models after textures have been encoded
						#warning("import textures into models")

						// strings in the xds scripts will override those particular strings in the msg's json
						if file.fileType == .xds && game != .PBR {
							if settings.verbose {
								printg("compiling \(file.path)")
							}
							XDSScriptCompiler.setFlags(disassemble: false, decompile: false, updateStrings: true, increaseMSG: true)
							XDSScriptCompiler.baseStringID = 1000
							if !XDSScriptCompiler.compile(textFile: file, toFile: .nameAndFolder(file.fileName.removeFileExtensions() + XGFileTypes.scd.fileExtension, file.folder)) {
								printg("XDS Compilation Error:\n" + XDSScriptCompiler.error)
								return false
							}
						}
					}
				}

				for file in fileToImport.folder.files {
					// import models into pkxs after textures have been imported into models
					if file.fileType == .pkx {
						for dat in fileToImport.folder.files where dat.fileType == .dat {
							if dat.fileName.removeFileExtensions() == file.fileName.removeFileExtensions() {
								if let datData = dat.data, let pkxData = file.data {
									if settings.verbose {
										printg("importing \(dat.path) into \(file.path)")
									}
									XGUtility.importDatToPKX(dat: datData, pkx: pkxData).save()
								}
							}
						}
					}
				}

				if settings.verbose {
					printg("loading fsys data")
				}
				let fsysData = fileToImport.fsysData
				for i in 0 ..< fsysData.numberOfEntries {
					var filename = ""
					if fsysData.usesFileExtensions {
						filename = fsysData.fullFileNames[i]
					} else {
						filename = fsysData.fileNames[i].removeFileExtensions() + fsysData.fileTypeForFile(index: i).fileExtension
					}
					if !fsysData.usesFileExtensions || filename.removeFileExtensions() == filename {
						filename = filename.removeFileExtensions()
						filename += fsysData.fileTypeForFile(index: i).fileExtension
					}
					for file in fileToImport.folder.files {
						if file.fileName == filename {
							if fsysData.isFileCompressed(index: i) {
								if settings.verbose {
									printg("compressing file", file.path)
								}
								let compressed = file.compress()
								if settings.verbose {
									printg("importing \(file.path) into \(fileToImport.path)")
								}
								fsysData.shiftAndReplaceFileWithIndexEfficiently(i, withFile: compressed, save: false)
							} else {
								if settings.verbose {
									printg("importing \(file.path) into \(fileToImport.path)")
								}
								fsysData.shiftAndReplaceFileWithIndexEfficiently(i, withFile: file, save: false)
							}
						}
					}
				}
				if settings.verbose {
					printg("saving updated fsys \(fsysData.file.path)")
				}
				fsysData.save()
			}
			if settings.verbose {
				printg("importing \(fileToImport.path) into \(XGFiles.iso.path)")
			}
			ISO.importFiles([fileToImport])
			return true
		} else {
			printg("The file: \(fileToImport.path) doesn't exit")
			return false
		}
	}
	
	class func importRels() {
		for file in XGFolders.Rels.files where file.fileType == .rel {
			
			if settings.verbose { printg("importing relocation table: " + file.fileName) }
			
			let fsysFile = XGFiles.fsys(file.fileName.removeFileExtensions())
			if fsysFile.exists {
				fsysFile.fsysData.shiftAndReplaceFile(file.compress(), save: true)
			}
		}
	}
	
	class func importScripts() {
		for file in XGFolders.Scripts.files where file.fileType == .scd {
			
			if settings.verbose { printg("importing script: " + file.fileName) }
			
			let fsysFile = XGFiles.fsys(file.fileName.removeFileExtensions())
			if fsysFile.exists {
				fsysFile.fsysData.shiftAndReplaceFile(file.compress(), save: true)
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
				file.fsysData.shiftAndReplaceFile(msgFile.compress(), save: true)
			}
		}
		
		importSpecificStringTables()
		
	}

	class func importTPLFiles(_ files: [XGFiles]) {
		if files.isEmpty { return }
		
		printg("importing tpl files...")
		for file in files {
			let source = file.path.escapedPath
			var dest = (XGFolders.Textures.path + "/" + file.fileName).escapedPath
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
		printg("importing textures...")
		for imageFile in XGFolders.Import.files where XGFileTypes.imageFormats.contains(imageFile.fileType) && !imageFile.fileName.contains(".tpl") {
			
			let textureFilename = imageFile.fileName.removeFileExtensions() + XGFileTypes.gtx.fileExtension
			let animTextureFilename = imageFile.fileName.removeFileExtensions() + XGFileTypes.atx.fileExtension

			guard let image = XGImage.loadImageData(fromFile: imageFile) else {
				continue
			}
			
			let tFile = XGFiles.nameAndFolder(textureFilename, .Textures)
			let aFile = XGFiles.nameAndFolder(animTextureFilename, .Textures)

			if tFile.exists || aFile.exists {
				if tFile.exists {
					GoDTextureImporter.replaceTextureData(texture: tFile.texture, withImage: image, save: true)
				}
				if aFile.exists {
					GoDTextureImporter.replaceTextureData(texture: aFile.texture, withImage: image, save: true)
				}
			} else {
				let texture = image.texture
				let filename = tFile.fileName.removeFileExtensions() + XGFileTypes.gtx.fileExtension
				texture.file = .nameAndFolder(filename, tFile.folder)
				texture.save()
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
			let dest = (XGFolders.Export.path + "/" + file.fileName + ".png").escapedPath

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
		printg("exporting textures...")
		for file in XGFolders.Textures.files where [.gtx, .atx].contains(file.fileType)  {
			let filename = file.fileName.removeFileExtensions() + ".png"
			file.texture.image.writePNGData(toFile: .nameAndFolder(filename, .Export))
		}
		exportTPLFiles(XGFolders.Textures.files.filter({ (file) -> Bool in
			file.fileType == .tpl
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
	
	class func saveString(_ str: String, toFile file: XGFiles) {
		
		if let string = str.data(using: String.Encoding.utf8) {
			if !string.write(to: file) {
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
			let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
			if !data.write(to: file) {
				printg("couldn't save json to file: \(file.path)")
			}
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


