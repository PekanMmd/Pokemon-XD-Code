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

	class func extractAllFiles(decode: Bool = true) {
		let excludedFileNames = [XGFiles.toc.fileName]
		
		for filename in XGISO.current.allFileNames where !excludedFileNames.contains(filename) {
			exportFileFromISO(.nameAndFolder(filename, .ISOExport(filename.removeFileExtensions())), decode: decode, overwrite: false)
		}
	}
	
	class func compileMainFiles() {
		prepareForCompilation()
		var filesToImport = [XGFiles.fsys("common"), .dol, .GSFsys]
		if game != .PBR {
			filesToImport += [.fsys("pocket_menu"), XGFiles.fsys("fight_common")]
			if game == .XD {
				filesToImport += [.fsys("deck_archive"), .fsys("M2_guild_1F_2"), .fsys("common_dvdeth")]
			}
		} else {
			filesToImport += [.fsys("deck")]
			+ (region == .JP ?
				[.fsys("menu_fight_s"), .fsys("menu_name2")] :
				[.fsys("mes_common"), .fsys("menu_btutorial"), .fsys("mes_fight_e"), .fsys("mes_name_e")])
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
		for filename in XGISO.current.allFileNames {
			let file = XGFiles.nameAndFolder(filename, .ISOExport(filename.removeFileExtensions()))
			guard file.exists else { continue }
			XGUtility.importFileToISO(file, encode: file.fileType == .fsys, save: false)
		}
		XGISO.current.save()
	}

	@discardableResult
	class func exportFileFromISO(_ file: XGFiles, extractFsysContents: Bool = true, decode: Bool = true, overwrite: Bool = false) -> Bool {
		XGFolders.ISOExport("").createDirectory()

		if let data = XGISO.current.dataForFile(filename: file.fileName) {
			data.file = file
			if !file.exists || overwrite {
				data.save()
			}
			if file.fileType == .fsys {
				let fsysData = data.fsysData
				fsysData.extractFilesToFolder(folder: file.folder, extract: extractFsysContents, decode: decode, overwrite: overwrite)
			}
			if file == .dol, decode, game != .PBR {
				let msgFile = XGFiles.nameAndFolder(file.fileName + XGFileTypes.json.fileExtension, file.folder)
				if !msgFile.exists {
					let table = file.stringTable
					table.writeJSON(to: msgFile)
				}
			}
			return true
		}
		return false
	}

	@discardableResult
	class func importFileToISO(_ fileToImport: XGFiles, shouldImport: Bool = true, encode: Bool = true, save: Bool = true, importFiles importFilesToFsysExclusively: [XGFiles]? = nil) -> Bool {

		func shouldIncludeFile(_ file: XGFiles) -> Bool {
			return importFilesToFsysExclusively?.contains(where: { (f1) -> Bool in
				return f1.fileName == file.fileName
					|| f1.fileName == (file.fileName + XGFileTypes.xds.fileExtension)
			}) ?? true
		}

		if fileToImport.exists || !shouldImport {
			if game != .PBR, fileToImport.fileName == XGFiles.dol.fileName {
				let msgFile = XGFiles.nameAndFolder(fileToImport.fileName + ".json", fileToImport.folder)
				if let newTable = try? XGStringTable.fromJSONFile(file: msgFile) {
					newTable.save()
					loadedStringTables[fileToImport.path] = newTable
				}
			}
			if fileToImport.fileType == .fsys {

				if encode {
					XGColour.colourThreshold = 0
					for file in fileToImport.folder.files where shouldIncludeFile(file) {

						// encode string tables before compiling scripts
						if file.fileType == .msg {
							for json in fileToImport.folder.files where json.fileType == .json {
								if json.fileName.removeFileExtensions() == file.fileName.removeFileExtensions() {
									if XGSettings.current.verbose {
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

						#if !GAME_PBR
						let msgFile = XGFiles.nameAndFolder(file.fileName + ".json", file.folder)
						if file == .common_rel || file == .tableres2, msgFile.exists {
							let msgFile = XGFiles.nameAndFolder(file.fileName + ".json", file.folder)
							if let newTable = try? XGStringTable.fromJSONFile(file: msgFile) {
								newTable.save()
								loadedStringTables[file.path] = newTable
							}
						}
						if file == .common_rel && game == .Colosseum && region != .JP {
							let msgFile2 = XGFiles.nameAndFolder("common2.json", file.folder)
							let msgFile3 = XGFiles.nameAndFolder("common3.json", file.folder)
							if msgFile2.exists, let newTable = try? XGStringTable.fromJSONFile(file: msgFile2) {
								newTable.save()
								loadedStringTables[file.path] = newTable
							}
							if msgFile3.exists, let newTable = try? XGStringTable.fromJSONFile(file: msgFile3) {
								newTable.save()
								loadedStringTables[file.path] = newTable
							}
						}
						if file == .dol && game == .XD && region != .JP {
							let msgFile2 = XGFiles.nameAndFolder("Start2.json", file.folder)
							let msgFile3 = XGFiles.nameAndFolder("Start3.json", file.folder)
							if msgFile2.exists, let newTable = try? XGStringTable.fromJSONFile(file: msgFile2) {
								newTable.save()
								loadedStringTables[file.path] = newTable
							}
							if msgFile3.exists, let newTable = try? XGStringTable.fromJSONFile(file: msgFile3) {
								newTable.save()
								loadedStringTables[file.path] = newTable
							}
						}
						#endif

						if file.fileType == .thp, let thpData = file.data {
							let thp = XGTHP(thpData: thpData)
							thp.headerData.save()
							thp.bodyData.save()
						}

						if file.fileType == .gtx || file.fileType == .atx {
							for imageFile in fileToImport.folder.files where XGFileTypes.imageFormats.contains(imageFile.fileType) {
								if imageFile.fileName.removeFileExtensions() == file.fileName.removeFileExtensions() {
									if XGSettings.current.verbose {
										printg("importing \(imageFile.path) into \(file.path)")
									}
									if let image = XGImage.loadImageData(fromFile: imageFile) {
										let referenceTexture = file.texture
										let forceIndexed = referenceTexture.data.getByteAtOffset(kTextureIndexOffset) == 1
										let texture = image.getTexture(format: referenceTexture.format, paletteFormat: referenceTexture.paletteFormat)
										texture.forceIndexedValue = forceIndexed
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
								if XGSettings.current.verbose {
									printg("importing \(subFile.path) into \(file.path)")
								}
								if let id = subFile.fileName.removeFileExtensions().replacingOccurrences(of: gsw.subFilenamesPrefix, with: "").integerValue {
									gsw.importTextureData(subFile.data!, withID: id)
								}
							}

							gsw.save()
						}

						#if !GAME_PBR
						if XGFileTypes.modelFormats.contains(file.fileType) {
							let datModel = DATModel(file: file)
							var expectedFiles = datModel?.textures ?? []
							var foundReplacement = false
							for i in 0 ..< expectedFiles.count {
								let textureFile = expectedFiles.map { $0.data.file }[i]
								if textureFile.exists {
									expectedFiles[i] = textureFile.texture
									foundReplacement = true
								}
							}
							if foundReplacement {
								datModel?.importTextures(expectedFiles)
								datModel?.data?.save()
							}
						}
						#endif

						// import textures into models after textures have been encoded
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
						#if GAME_XD
						if file.fileType == .xds && game != .PBR {
							if XGSettings.current.verbose {
								printg("compiling \(file.path)")
							}
							XDSScriptCompiler.setFlags(disassemble: false, decompile: false, updateStrings: true, increaseMSG: true)
							XDSScriptCompiler.baseStringID = 1000
							if file.fileName.replacingOccurrences(of: file.fileExtension, with: "") == XGFiles.common_rel.fileName {
								if XGFiles.common_rel.exists, let newScript = XDSScriptCompiler.compile(file.text) {
									let start = CommonIndexes.Script.startOffset
									var length = CommonIndexes.Script.length
									if newScript.length > length && XGSettings.current.increaseFileSizes {
										common.expandSymbolWithIndex(CommonIndexes.Script.index, by: newScript.length - length)
										length = CommonIndexes.Script.length
									} else {
										printg("Warning: couldn't import new script for \(XGFiles.common_rel.path) because the new script is too large.")
									}
									if newScript.length <= length, let rel = XGFiles.common_rel.data {
										if newScript.length < length {
											newScript.appendData(.init(length: length - newScript.length))
										}
										rel.replaceData(data: newScript, atOffset: start)
										rel.save()
									}
								} else {
									printg("XDS Compilation Error:\n" + XDSScriptCompiler.error)
									return false
								}
							} else {
								if !XDSScriptCompiler.compile(textFile: file, toFile: .nameAndFolder(file.fileName.removeFileExtensions() + XGFileTypes.scd.fileExtension, file.folder)) {
									printg("XDS Compilation Error:\n" + XDSScriptCompiler.error)
									return false
								}
							}
						}
						#endif
					}

					for file in fileToImport.folder.files where shouldIncludeFile(file) {
						// import models into pkxs and wzxs after textures have been imported into models
						if file.fileType == .pkx {
							for dat in fileToImport.folder.files where dat.fileType == .dat && dat.fileName.contains(".pkx") {
								if dat.fileName.removeFileExtensions() == file.fileName.removeFileExtensions() {
									if let datData = dat.data, let pkxData = file.data {
										if XGSettings.current.verbose {
											printg("importing \(dat.path) into \(file.path)")
										}
										XGUtility.importDatToPKX(dat: datData, pkx: pkxData).save()
									}
								}
							}
						}

						#if !GAME_PBR
						if file.fileType == .wzx, let wzxData = file.data {
							let wzx = WZXModel(data: wzxData)
							var didImport = false
							for index in 0 ..< wzx.datModelOffsets.count {
								if let file = wzx.fileForModelWithIndex(index),
								   file.exists,
								   let datData = file.data {
									if wzx.importModel(datData, atIndex: index, save: false) {
										didImport = true
									}
								}
							}
							if didImport {
								wzx.save()
							}
						}
						#endif
					}
				}

				if XGSettings.current.verbose {
					printg("loading fsys data")
				}
				let fsysData = fileToImport.fsysData
				for i in 0 ..< fsysData.numberOfEntries {
					let filename = fsysData.fileNameForFileWithIndex(index: i)
					for file in fileToImport.folder.files where shouldIncludeFile(file) {
						if file.fileName == filename {
							if fsysData.isFileCompressed(index: i) {
								if XGSettings.current.verbose {
									printg("compressing file", file.path)
								}
								let compressed = file.compress()
								if XGSettings.current.verbose {
									printg("importing \(file.path) into \(fileToImport.path)")
								}
								fsysData.shiftAndReplaceFileWithIndex(i, withFile: compressed, save: false)
							} else {
								if XGSettings.current.verbose {
									printg("importing \(file.path) into \(fileToImport.path)")
								}
								fsysData.shiftAndReplaceFileWithIndex(i, withFile: file, save: false)
							}
						}
					}
				}
				if XGSettings.current.verbose {
					printg("saving updated fsys \(fsysData.file.path)")
				}
				fsysData.save()
			}
			if XGSettings.current.verbose {
				printg("importing \(fileToImport.path) into \(XGFiles.iso.path)")
			}
			
			if shouldImport {
				#if GAME_PBR
				XGISO.current.importFiles([fileToImport])
				if save {
					XGISO.current.save()
				}
				#else
				XGISO.current.importFiles([fileToImport], save: save)
				#endif
			}

			return true
		} else {
			printg("The file: \(fileToImport.path) doesn't exit")
			return false
		}
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
		if XGSettings.current.verbose {
			printg("Searching for fsys containing identifier: \(id.hexString())")
		}
		for name in iso.allFileNames where name.fileExtensions == ".fsys" {
			let fsys = iso.dataForFile(filename: name)!.fsysData
			for index in 0 ..< fsys.identifiers.count {
				if fsys.identifiers[index] == id {
					if XGSettings.current.verbose {
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

	class func decodeEReaderCards() {
		#if GAME_COLO
		guard game == .Colosseum, XGISO.inputISOFile != nil else { return }
		if !XGFolders.Decrypted.files.contains(where:{ $0.fileType == .bin }) {
			displayAlert(title: "No Ereader Cards Found", description: "Place your decrypted E Reader cards in \(XGFolders.Decrypted.path)\nthen use this utility to output the decoded data for those cards in \(XGFolders.Decoded.path)")
			return
		}

		XGFolders.Decrypted.files.forEach { (file) in
			if file.fileType == .bin {
				let decodedFile = XGFiles.nameAndFolder(file.fileName, XGFolders.Decoded)
				printg("Writing decoded ereader card to \(decodedFile.path)")
				EcardCoder.decode(file: file)?.writeToFile(decodedFile)
			}
		}
		#endif
	}

	class func encodeEReaderCards() {
		#if GAME_COLO
		guard game == .Colosseum, XGISO.inputISOFile != nil else { return }
		if !XGFolders.Decoded.files.contains(where:{ $0.fileType == .bin }) {
			displayAlert(title: "No Ereader Cards Found", description: "Place your decoded E Reader cards in \(XGFolders.Decoded.path)\nthen use this utility to output the reencoded data for those cards in \(XGFolders.Decrypted.path)")
			return
		}

		XGFolders.Decoded.files.forEach { (file) in
			if file.fileType == .bin {
				let encodedFile = XGFiles.nameAndFolder(file.fileName, XGFolders.Decrypted)
				printg("Writing encoded ereader card to \(encodedFile.path)")
				EcardCoder.encode(file: file)?.writeToFile(encodedFile)
			}
		}
		#endif
	}

	class func decryptEReaderCards() {
		#if GAME_COLO
		guard game == .Colosseum, XGISO.inputISOFile != nil else { return }
		if !XGFolders.Encrypted.files.contains(where:{ $0.fileType == .raw }) {
			displayAlert(title: "No Ereader Cards Found", description: "Place your encrypted E Reader cards in \(XGFolders.Encrypted.path)\nthen use this utility to output the decoded data for those cards in \(XGFolders.Decrypted.path)")
			return
		}

		XGFolders.Encrypted.files.forEach { (file) in
			if file.fileType == .raw {
				let decryptedFile = XGFiles.nameAndFolder(file.fileName.removeFileExtensions() + ".bin", XGFolders.Decrypted)
				printg("Writing decrypted ereader card to \(decryptedFile.path)")
				EcardCoder.decrypt(file: file, toFile: decryptedFile)
			}
		}
		#endif
	}

	class func encryptEReaderCards() {
		#if GAME_COLO
		guard game == .Colosseum, XGISO.inputISOFile != nil else { return }
		if !XGFolders.Decrypted.files.contains(where:{ $0.fileType == .bin }) {
			displayAlert(title: "No Ereader Cards Found", description: "Place your decrypted E Reader cards in \(XGFolders.Decrypted.path)\nthen use this utility to output the reencrypted data for those cards in \(XGFolders.Encrypted.path)")
			return
		}

		XGFolders.Decrypted.files.forEach { (file) in
			if file.fileType == .bin {
				let encryptedFile = XGFiles.nameAndFolder(file.fileName.removeFileExtensions() + ".raw", XGFolders.Encrypted)
				printg("Writing encrypted ereader card to \(encryptedFile.path)")
				EcardCoder.encrypt(file: file, toFile: encryptedFile)
			}
		}
		#endif
	}

	#if GAME_PBR
	static func dumpAvatarCustomisations(toFile file: XGFiles) {
		var text = ""
		XGTrainerModels.allCases.forEachIndexed { (index, model) in
			text += "\(model.name): \(index)\n"
			if let clothes = model.clothingOptions {
				let categories: [(name: String, values: [PBRTrainerClothing])] = [
					("hats", clothes.hats),
					("hair", clothes.hairColours),
					("face", clothes.faces),
					("tops", clothes.tops),
					("bottoms", clothes.bottoms),
					("shoes", clothes.shoes),
					("hands", clothes.hands),
					("bags", clothes.bags),
					("glasses", clothes.glasses),
					("badges", clothes.badges)
				]
				categories.forEachIndexed { (index, category) in
					text += "  - " + category.name.titleCased + "\n"
					category.values.forEachIndexed { index, clothing in
						text += "      - " + clothing.name.unformattedString + ": \(index)\n"
					}
				}
			} else {
				text += "  - No Customisations Available\n"
			}
			text += "\n"
		}
		text.save(toFile: file)
	}
	#endif
	
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

	class func extractAllTextures(forDolphin: Bool = false) {
		let outputFolder = XGFolders.nameAndFolder("Texture Dump", .Reference)
		printg("extracting all textures to \(outputFolder.path)")
		if forDolphin {
			printg("textures will be saved with dolphin compatible filenames")
		}
		printg("This will take a while...")

		for filename in XGISO.current.allFileNames where filename.contains(".fsys") {
			printg(filename)

			let dumpFolder = XGFolders.nameAndFolder(filename.removeFileExtensions(), outputFolder)
			if !dumpFolder.exists {

				let fsysFile = XGFiles.fsys(filename.removeFileExtensions())
				exportFileFromISO(fsysFile, decode: false, overwrite: false)

				let folder = XGFolders.ISOExport(filename.removeFileExtensions())
				#if !GAME_PBR
				folder.files.forEach { (file) in
					if file.fileType == .pkx, file.exists {
						let dat = exportDatFromPKX(pkx: file.data!)
						if !dat.file.exists {
							dat.save()
						}
					}
				}
				#endif

				folder.files.forEach { (file) in
					file.textures.forEach { (texture) in
						if forDolphin {
							texture.writeDolphinFormatted(to: dumpFolder)
						} else {
							texture.writePNGData(toFile: .nameAndFolder(texture.data.file.fileName + ".png", dumpFolder))
						}
					}
				}
			} else {
				printg("Skipping \(filename)\nFolder already exists: \(dumpFolder.path)")
			}
		}
	}

	class func increasePokemonLevelsByPercentage(_ percentage: Int) {
		#if GAME_COLO
		for trainer in allTrainers() {
			for mon in trainer.pokemon {
				mon.level = min(mon.level * (percentage + 100) / 100, 100)
				mon.save()
			}
		}
		#elseif GAME_XD
		for trainer in allTrainers() where ![XGDecks.DeckBingo, .DeckVirtual, .DeckSample, .DeckImasugu].contains(trainer.deck) {
			for pokemon in trainer.pokemon {
				let mon = pokemon.data
				mon.level = min(mon.level * (percentage + 100) / 100, 100)
				mon.save()
			}
		}
		#endif
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


