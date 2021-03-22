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

	class func extractAllFiles() {
		#if GAME_PBR
		let excludedFiles = [ "pkx_", "wzx_"]
		for filename in XGISO.current.allFileNames {
			guard !excludedFiles.contains(where: { (str) -> Bool in
				filename.contains(str)
			}) else {
				continue
			}
			exportFileFromISO(.nameAndFolder(filename, .ISOExport(filename.removeFileExtensions())), decode: true, overwrite: false)
		}
		#else
		let excludedFiles = ["stm_", "pkx_", "wzx_"]
		for filename in XGISO.current.allFileNames where filename != XGFiles.toc.fileName {
			guard !excludedFiles.contains(where: { (str) -> Bool in
				filename.contains(str)
			}) else {
				continue
			}
			exportFileFromISO(.nameAndFolder(filename, .ISOExport(filename.removeFileExtensions())), decode: true, overwrite: false)
		}
		#endif
	}
	
	class func compileMainFiles() {
		prepareForCompilation()
		var filesToImport = [XGFiles.fsys("common"), .dol]
		if game != .PBR {
			filesToImport += [.fsys("pocket_menu"), XGFiles.fsys("fight_common")]
			if game == .XD {
				filesToImport += [.fsys("deck_archive"), .fsys("M2_guild_1F_2"), .fsys("common_dvdeth")]
			}
		} else {
			filesToImport += [.fsys("deck"), .fsys("mes_common")]
		}


		filesToImport.forEach {
			if $0.exists {
				printg("Compiling", $0.path)
				var fsysSubfilesToImport: [XGFiles]? = nil
				switch $0.fileName {
				case "common.fsys": if game != .PBR {
					#if !GAME_PBR
					fsysSubfilesToImport = [.common_rel]
					#else
					fsysSubfilesToImport = XGFolders.ISOExport("common").files.filter({ (file) -> Bool in
						return file.fileType == .bin
					})
					#endif
					#if GAME_XD
					fsysSubfilesToImport?.append(.deck(.DeckDarkPokemon))
					#endif
					}
				case "M2_guild_1F_2.fsys": if game == .XD { fsysSubfilesToImport = [.typeAndFsysName(.scd, "M2_guild_1F_2")] }
				default: break
				}
				importFileToISO($0, encode: true, save: false, importFiles: fsysSubfilesToImport)
			}
		}

		XGISO.current.save()

		printg("Quick build complete")
	}
	
	class func compileAllFiles() {
		
		prepareForCompilation()
		for file in XGISO.current.allFileNames {
			if file.fileExtensions == XGFileTypes.fsys.fileExtension {
				XGUtility.importFileToISO(.fsys(file.removeFileExtensions()), encode: true, save: false)
			} else {
				XGUtility.importFileToISO(.nameAndFolder(file, .ISOExport(file.removeFileExtensions())), encode: false, save: false)
			}
		}
		XGISO.current.save()
	}

	@discardableResult
	class func exportFileFromISO(_ file: XGFiles, extractFsysContents: Bool = true, decode: Bool = true, overwrite: Bool = false) -> Bool {
		XGFolders.ISOExport("").createDirectory()

		if let data = XGISO.current.dataForFile(filename: file.fileName) {
			if data.length > 0 {
				data.file = file
				if !file.exists || overwrite {
					data.save()
				}
				if extractFsysContents, file.fileType == .fsys {
					let fsysData = data.fsysData
					fsysData.extractFilesToFolder(folder: file.folder, decode: decode, overwrite: overwrite)
				}
				return true
			}
		}
		return false
	}

	@discardableResult
	class func importFileToISO(_ fileToImport: XGFiles, encode: Bool = true, save: Bool = true, importFiles importFilesToFsysExclusively: [XGFiles]? = nil) -> Bool {

		func shouldIncludeFile(_ file: XGFiles) -> Bool {
			return importFilesToFsysExclusively?.contains(where: { (f1) -> Bool in
				return f1.fileName == file.fileName
					|| f1.fileName == (file.fileName + XGFileTypes.xds.fileExtension)
			}) ?? true
		}

		if fileToImport.exists {
			if fileToImport.fileType == .fsys {

				if encode {
					XGColour.colourThreshold = 0
					for file in fileToImport.folder.files where shouldIncludeFile(file) {

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

					for file in fileToImport.folder.files where shouldIncludeFile(file) {
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
						#warning("import textures into models for Colo/XD")
						#if GAME_PBR
						// import model textures after all gtxs have been encoded
						if XGFileTypes.textureContainingFormats.contains(file.fileType) {
							if let dataFormat = PBRTextureContaining.fromFile(file) {
								var expectedFiles = dataFormat.textures
								var foundReplacement = false
								for i in 0 ..< expectedFiles.count {
									let textureFile = expectedFiles.map { $0.data.file }[i]
									if textureFile.exists {
										expectedFiles[i] = textureFile.texture
										foundReplacement = true
									}
								}
								if foundReplacement {
									dataFormat.importTextures(expectedFiles)
									dataFormat.data?.save()
								}
							}
						}
						#endif

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

					for file in fileToImport.folder.files where shouldIncludeFile(file) {
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
				}

				if settings.verbose {
					printg("loading fsys data")
				}
				let fsysData = fileToImport.fsysData
				for i in 0 ..< fsysData.numberOfEntries {
					let filename = fsysData.fileNameForFileWithIndex(index: i)
					for file in fileToImport.folder.files where shouldIncludeFile(file) {
						if file.fileName == filename {
							if fsysData.isFileCompressed(index: i) {
								if settings.verbose {
									printg("compressing file", file.path)
								}
								let compressed = file.compress()
								if settings.verbose {
									printg("importing \(file.path) into \(fileToImport.path)")
								}
								fsysData.shiftAndReplaceFileWithIndex(i, withFile: compressed, save: false)
							} else {
								if settings.verbose {
									printg("importing \(file.path) into \(fileToImport.path)")
								}
								fsysData.shiftAndReplaceFileWithIndex(i, withFile: file, save: false)
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
			#if GAME_PBR
			XGISO.current.importFiles([fileToImport])
			if save {
				XGISO.current.save()
			}
			#else
			XGISO.current.importFiles([fileToImport], save: save)
			#endif

			return true
		} else {
			printg("The file: \(fileToImport.path) doesn't exit")
			return false
		}
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
		#if !GAME_PBR
		exportTPLFiles(XGFolders.Textures.files.filter({ (file) -> Bool in
			file.fileType == .tpl
		}))
		#endif
	}
	
	class func searchForFsysForFile(file: XGFiles) {
		let iso = XGISO.current
		for name in iso.allFileNames where name.fileExtensions == ".fsys" {
			let fsys = iso.dataForFile(filename: name)!.fsysData
			for index in 0 ..< fsys.numberOfEntries {
				if fsys.fileNameForFileWithIndex(index: index) == file.fileName {
					printg(file.fileName, " found in fsys: ", name, ", index: ", index)
				}
			}
			
		}
	}
	
	class func searchForFsysForIdentifier(id: UInt32) -> [XGFsys] {
		let iso = XGISO.current
		var found = [XGFsys]()
		if settings.verbose {
			printg("Searching for fsys containing identifier: \(id.hexString())")
		}
		for name in iso.allFileNames where name.fileExtensions == ".fsys" {
			let fsys = iso.dataForFile(filename: name)!.fsysData
			for index in 0 ..< fsys.identifiers.count {
				if fsys.identifiers[index] == id {
					if settings.verbose {
						printg("found id: \(id), fsys: ",name,", index: ", index, ", name: ", fsys.fileNameForFileWithIndex(index: index) ?? "-")
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

		guard game != .PBR else {
			return
		}
		
		var substrings = [String]()
		if game == .XD {
			substrings = ["Script_t","_test", "debug", "DNA", "keydisc", "M2_cave"]
			if region != .EU  {
				substrings += ["_fr.","_ge.","_it.", "_sp."]
				substrings += ["l_fr","l_ge","l_it", "l_sp"]
				substrings += ["g_fr","g_ge","g_it", "g_sp"]
			}
		} else if game == .Colosseum {
			substrings = ["carde", "ex", "debug"]
		}
		
		for file in XGISO.current.allFileNames {
			for substring in substrings {
				if file.contains(substring) && !file.contains("wzx") && !file.contains("pkx") {
					XGISO.current.deleteFileAndPreserve(name: file, save: false)
				}
			}
		}
		XGISO.current.save()
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

	class func tutorMovesAvailableImmediately() {
		#if GAME_XD
		for i in 1 ... CommonIndexes.NumberOfTutorMoves.value {
			let tm = XGTMs.tutor(i)
			tm.replaceTutorFlag(10)
		}
		#endif
	}
	
	//MARK: - Utilities 2
	
	class func valueContext(_ value: Int) {
		printg("Value:", value, "can have the following meanings:\n")
		if value <= kNumberOfMoves {
			printg("Move: ",XGMoves.index(value).name.string,"\n")
		}
		if value <= kNumberOfPokemon {
			printg("Pokemon: ",XGPokemon.index(value).name.string,"\n")

			#if !GAME_PBR
			if value > 251 {
				printg("Pokemon national index: ", XGPokemon.nationalIndex(value).name.string,"\n")
			}
			#endif
		}
		
		if value <= kNumberOfAbilities {
			printg("Ability: ",XGAbilities.index(value).name.string,"\n")
		}
		
		if value <= kNumberOfItems {
			printg("Item: ",XGItems.index(value).name.string,"\n")
		} else if value > kNumberOfItems && value < 0x250 {
			printg("Item scriptIndex: ",XGItems.index(value - 150).name.string,"\n")
		}
		
		if value < kNumberOfTypes {
			printg("Type: ",XGMoveTypes.index(value),"\n")
		}
		
		for i in 1 ..< kNumberOfItems {
			let item = XGItems.index(i).data
			if item.holdItemID == value {
				printg("Hold item id: ",item.name.string,"\n")
			}
			#if !GAME_PBR
			if item.inBattleUseID == value {
				printg("In battle item id: ",item.name.string,"\n")
			}
			#endif
		}
		
		loadAllStrings()
		printg("String: ",getStringSafelyWithID(id: value),"\n")
		
		
	}
	
	//MARK: - Pokemarts
	class func printPokeMarts() {
		#if !GAME_PBR
		let dat = XGFiles.pocket_menu.data!
		
		let itemHexList = dat.getShortStreamFromOffset(0x300, length: 0x170)
		
		for j in 0..<itemHexList.count {
			let i = itemHexList[j]
			
			if i == 0x1FF {
				printg("---------")
				continue
			}
			let item = XGItems.index(i)
			
			var tmName = ""
			for i in 1 ... kNumberOfTMs {
				if XGTMs.tm(i).item.index == item.index {
					tmName = "(" + XGTMs.tm(i).move.name.string + ")"
				}
			}
			
			printg("\(0x300 + (j*2)):\t",item.index,item.name.string,tmName,"\n")
		}
		#endif
		
	}

	class func extractAllTextures() {
		printg("extracting all textures")
		let dumpFolder = XGFolders.nameAndFolder("Dump", .Textures)
		XGFolders.setUpFolderFormat()
		dumpFolder.createDirectory()
		printg("output folder: \(dumpFolder.path)")
		for filename in XGISO.current.allFileNames where filename.contains(".fsys") {
			if settings.verbose {
				printg("searching file:", filename)
			}
			guard let fsysData = XGISO.current.dataForFile(filename: filename) else {
				if settings.verbose {
					printg("no iso data found for file:", filename)
				}
				continue
			}
			let fsys = XGFsys(data: fsysData)
			for i in 0 ..< fsys.numberOfEntries {
				guard let fileType = fsys.fileTypeForFileWithIndex(index: i), [XGFileTypes.gtx, .atx, .gsw].contains(fileType) else {
					continue
				}
				guard let textureData = fsys.extractDataForFileWithIndex(index: i) else {
					continue
				}

				if settings.verbose {
					printg("outputting:", textureData.file.fileName)
				}

				let folder = XGFolders.nameAndFolder(filename.removeFileExtensions(), dumpFolder)
				folder.createDirectory()


				if fileType == .gsw {
					let gsw = XGGSWTextures(data: textureData)
					let textures = gsw.extractTextureData()
					textures.forEach { (data) in
						data.file = .nameAndFolder(data.file.fileName, folder)
						let texture = GoDTexture(data: data).image
						texture.writePNGData(toFile: .nameAndFolder(data.file.fileName + ".png", folder))

					}
				}
				if fileType == .gtx || fileType == .atx {
					textureData.file = .nameAndFolder(textureData.file.fileName, folder)
					let texture = GoDTexture(data: textureData).image
					texture.writePNGData(toFile: .nameAndFolder(textureData.file.fileName + ".png", folder))
				}

			}
		}
	}

	class func encodeJSONObject<T: Encodable>(_ object: T, toFile file: XGFiles) {
		if !file.folder.exists {
			file.folder.createDirectory()
		}
		object.writeJSON(to: file)
	}

	class func decodeJSONObject<T: Decodable>(from file: XGFiles) -> T? {
		return try? T.fromJSON(file: file)
	}
	
}


