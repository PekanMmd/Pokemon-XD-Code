//
//  PDADumper.swift
//  GoD Tool
//
//  Created by Stars Momodu on 26/07/2021.
//

import Foundation

/// Used for dumping data tables to be referenced by the PDA discord Bot
class PDADumper {
	static let folder = XGFolders.nameAndFolder("PDA Dump", .Reference)

	private class func fileWithName(_ filename: String, forXG: Bool) -> XGFiles {
		var gameName = ""
		switch game {
		case .Colosseum: gameName = "CM"
		case .XD: gameName = forXG ? "XG" : "XD"
		case .PBR: gameName = "PBR"
		}
		return XGFiles.nameAndFolder(filename + " \(gameName)" + ".json", folder)
	}

	private class func writeDump(_ data: [String: AnyObject], to file: XGFiles) {
		XGUtility.saveJSON(data as AnyObject, toFile: file)
	}

	class func dump(forXG: Bool = false) {
		dumpData(forXG: forXG)
		dumpFiles(forXG: forXG)
		dumpMSG(forXG: forXG)
	}

	class func dumpData(forXG: Bool = false) {
		var data = [String: AnyObject]()

		#if GAME_PBR
		let face = XGFiles.fsys("menu_face").fsysData
		let body = XGFiles.fsys("menu_pokemon").fsysData
		#else
		let face = XGFiles.fsys("poke_face").fsysData
		let body = XGFiles.fsys(game == .Colosseum ? "poke_body" : "poke_dance").fsysData
		#endif


		pokemonStatsTable.allEntries.forEachIndexed { (index, entry) in
			guard index > 0 else { return }
			entry.flatten()
			if let nameID: Int = entry.get("Name ID"), nameID > 0,
			   let nameString = getStringWithID(id: nameID),
			   let object = entry.jsonObject(useRawValue: false) as? [String: AnyObject] {
				var name = nameString.unformattedString
				var entryName = name.simplified
				var duplicateNumber = 1
				while data[entryName] != nil {
					duplicateNumber += 1
					entryName = entryName + "\(duplicateNumber)"
				}

				if forXG {
					if entryName == "marowak2" {
						name = "Alolan Marowak"
						entryName = name.simplified
					}
					if entryName == "ninetales2" {
						name = "Alolan Ninetales"
						entryName = name.simplified
					}
					if entryName == "sandslash2" {
						name = "Alolan Sandslash"
						entryName = name.simplified
					}
					if entryName == "robogroudn" {
						name = "Robo Groudon"
						entryName = name.simplified
					}
					if entryName == "robokyogre" {
						name = "Robo Kyogre"
						entryName = name.simplified
					}
				}

				var updatedObject = object
				updatedObject["index"] = index as AnyObject
				updatedObject["name"] = name as AnyObject
				updatedObject["entryName"] = entryName as AnyObject
				updatedObject["tabletype"] = "pokemon" as AnyObject

				let stats = XGPokemon.index(index).stats

				var evolutions = [String]()
				for i in 0 ..< stats.evolutions.count {
					let evolution = stats.evolutions[i]
					switch evolution.evolutionMethod {
					case .none:
						continue

					#if GAME_PBR
					case .levelUpMale,
						 .levelUpFemale,
						 .levelUpInMagneticField,
						 .levelUpAtMossRock,
						 .levelUpAtIceRock:
						fallthrough
					#endif

					case .levelUp,
						 .silcoon,
						 .cascoon,
						 .ninjask,
						 .shedinja,
						 .moreAttack,
						 .equalAttack,
						 .moreDefense:
						evolutions.append("\(evolution.evolutionMethod.string) (Lv. \(evolution.condition)) -> \(XGPokemon.index(evolution.evolvesInto).name.unformattedString)")

					#if GAME_PBR
					case .levelWithMove:
						evolutions.append("\(evolution.evolutionMethod.string) (\(XGMoves.index(evolution.condition).name.unformattedString)) -> \(XGPokemon.index(evolution.evolvesInto).name.unformattedString)")
					case .levelWithPartyPokemon:
						evolutions.append("\(evolution.evolutionMethod.string) (\(XGPokemon.index(evolution.condition).name.unformattedString)) -> \(XGPokemon.index(evolution.evolvesInto).name.unformattedString)")

					case .evolutionStoneMale,
						 .evolutionStoneFemale,
						 .levelWithItemDay,
						 .levelWithItemNight:
						fallthrough

					#elseif GAME_XD
					case .levelUpWithKeyItem:
						fallthrough

					#endif
					case .tradeWithItem,
						 .evolutionStone:
						evolutions.append("\(evolution.evolutionMethod.string) (\(XGItems.index(evolution.condition).name.unformattedString)) -> \(XGPokemon.index(evolution.evolvesInto).name.unformattedString)")
					#if GAME_XD
					case .Gen4:
						if forXG {
							evolutions.append("Evolves in Gen IV (can use eviolite)")
						}
					#endif
					default:
						evolutions.append("\(evolution.evolutionMethod.string) -> \(XGPokemon.index(evolution.evolvesInto).name.unformattedString)")
					}
				}
				updatedObject["evolutions"] = evolutions as AnyObject

				var lums = [String]()
				for lum in stats.levelUpMoves where lum.level > 0 {
					lums.append("Lv. \(lum.level) - \(lum.move.name.unformattedString)")
				}
				updatedObject["moves"] = lums as AnyObject

				var TMs = [String]()
				stats.learnableTMs.forEachIndexed { (index, learnable) in
					if learnable {
						let tm = XGTMs.tm(index + 1)
						TMs.append("\(tm.enumerableName) - \(tm.enumerableValue ?? "-")")
					}
				}
				#if GAME_XD
				stats.tutorMoves.forEachIndexed { (index, learnable) in
					if learnable {
						let tm = XGTMs.tutor(index + 1)
						TMs.append("\(tm.enumerableName) - \(tm.enumerableValue ?? "-")")
					}
				}
				#endif
				updatedObject["TMs"] = TMs as AnyObject

				var faceImages = [String]()
				var bodyImages = [String]()
				var modelTextures = [String]()

				#if GAME_PBR
				stats.faces.forEach { (info) in
					if let female = face.fileNameForFileWithIdentifier(info.femaleID.int) {
						faceImages.append(female)
					}
					if info.maleID != info.maleID, let male = face.fileNameForFileWithIdentifier(info.femaleID.int) {
						faceImages.append(male)
					}
				}
				stats.bodies.forEach { (info) in
					if let female = body.fileNameForFileWithIdentifier(info.femaleID.int) {
						bodyImages.append(female)
					}
					if info.maleID != info.maleID, let male = body.fileNameForFileWithIdentifier(info.femaleID.int) {
						bodyImages.append(male)
					}
				}
				stats.models.forEach { (info) in
					if let fsysName = GSFsys.shared.entryWithID(info.fsysFileIndex)?.name,
					   let fsysData = XGISO.current.dataForFile(filename: fsysName) {
						let fsys = XGFsys(data: fsysData)
						if let fileIndex = fsys.indexForIdentifier(identifier: info.fileID.int) {
							let modelData = fsys.extractDataForFileWithIndex(index: fileIndex)
							let sdr = PBRSDRModel(data: modelData)
							sdr.textures.forEach {
								modelTextures.append($0.file.fileName)
							}
						}
					}
				}
				#else
				if let faceName = face.fileNameForFileWithIdentifier(stats.faceTextureIdentifier.int) {
					faceImages.append(faceName)
				}
				for bodyID in [stats.bodyID, stats.bodyShinyID] {
					if let bodyName = body.fileNameForFileWithIdentifier(bodyID.int) {
						bodyImages.append(bodyName)
					}
				}
				if let model = stats.pkxModel {
					model.datModel.textures.forEach { (texture) in
						modelTextures.append(texture.file.fileName)
					}

					// Check if pokemon has a separate shiny model
					let rareModelName = "pkx_rare_" + model.data.file.fileName.removeFileExtensions() + ".fsys"
					if let data = XGISO.current.dataForFile(filename: rareModelName) {
						let fsys = XGFsys(data: data)
						if let pkxData = fsys.extractDataForFileWithIndex(index: 0) {
							let pkx = PKXModel(data: pkxData)
							pkx.datModel.textures.forEach { (texture) in
								modelTextures.append(texture.file.fileName)
							}
						}
					}
				}
				#endif

				updatedObject["faceTextures"] = faceImages as AnyObject
				updatedObject["bodyTextures"] = bodyImages as AnyObject
				updatedObject["modelTextures"] = modelTextures as AnyObject

				data[entryName] = updatedObject as AnyObject
			}
		}
		movesTable.allEntries.forEachIndexed { (index, entry) in
			guard index > 0 else { return }
			entry.flatten()
			if let nameID: Int = entry.get("Name ID"), nameID > 0,
			   let descriptionID: Int = entry.get("Description ID"), descriptionID > 0,
			   let name = getStringWithID(id: nameID),
			   let object = entry.jsonObject(useRawValue: false) as? [String: AnyObject] {
				var entryName = name.unformattedString.simplified
				var duplicateNumber = 1
				while data[entryName] != nil {
					duplicateNumber += 1
					entryName = entryName + "\(duplicateNumber)"
				}
				var updatedObject = object
				updatedObject["index"] = index as AnyObject
				updatedObject["name"] = name.unformattedString as AnyObject
				updatedObject["entryName"] = entryName as AnyObject
				updatedObject["tabletype"] = "move" as AnyObject
				data[entryName] = updatedObject as AnyObject
			}
		}
		itemsTable.allEntries.forEachIndexed { (index, entry) in
			guard index > 0 else { return }
			entry.flatten()
			if let nameID: Int = entry.get("Name ID"), nameID > 0,
			   let descriptionID: Int = entry.get("Description ID"), descriptionID > 0,
			   let name = getStringWithID(id: nameID),
			   let object = entry.jsonObject(useRawValue: false) as? [String: AnyObject] {
				var entryName = name.unformattedString.simplified
				var duplicateNumber = 1
				while data[entryName] != nil {
					duplicateNumber += 1
					entryName = entryName + "\(duplicateNumber)"
				}
				var updatedObject = object
				updatedObject["index"] = index as AnyObject
				updatedObject["name"] = name.unformattedString as AnyObject
				updatedObject["entryName"] = entryName as AnyObject
				updatedObject["tabletype"] = "item" as AnyObject
				data[entryName] = updatedObject as AnyObject
			}
		}
		#if !GAME_PBR
		naturesTable.allEntries.forEachIndexed { (index, entry) in
			entry.flatten()
			if let nameID: Int = entry.get("Name ID"), nameID > 0,
			   let name = getStringWithID(id: nameID),
			   let object = entry.jsonObject(useRawValue: false) as? [String: AnyObject] {
				var entryName = name.unformattedString.simplified
				var duplicateNumber = 1
				while data[entryName] != nil {
					duplicateNumber += 1
					entryName = entryName + "\(duplicateNumber)"
				}
				var updatedObject = object
				updatedObject["index"] = index as AnyObject
				updatedObject["name"] = name.unformattedString as AnyObject
				updatedObject["entryName"] = entryName as AnyObject
				updatedObject["tabletype"] = "nature" as AnyObject
				data[entryName] = updatedObject as AnyObject
			}
		}
		#endif
		XGFileTypes.allCases.forEach { (fileType) in
			if let info = fileType.info {
				var object = [String: AnyObject]()
				let entryName = fileType.fileExtension.simplified
				object["name"] = "\(fileType.fileExtension) file format"  as AnyObject
				object["description"] = info as AnyObject
				object["tabletype"] = "filetype" as AnyObject
				object["entryName"] = entryName as AnyObject
				data[entryName] = object as AnyObject
			}
		}
		#if !GAME_PBR
		var trainers = [String: [AnyObject]]()
		for trainer in XGTrainer.allValues {
			if trainer.nameID == 0 || !trainer.pokemon[0].isSet {
				continue
			}
			#if GAME_COLO
			guard !trainer.isPlayer else {
				continue
			}
			#endif

			var trainerData = [String: AnyObject]()
			let entryName = trainer.name.unformattedString.simplifiedKey
			trainerData["entryname"] = entryName as AnyObject
			trainerData["fullname"] = trainer.trainerClass.name.unformattedString + " " + trainer.name.unformattedString as AnyObject
			trainerData["class"] = trainer.trainerClass.name.unformattedString as AnyObject
			trainerData["name"] = trainer.name.unformattedString as AnyObject
			trainerData["prizemoney"] = trainer.prizeMoney as AnyObject
			trainerData["hasShadow"] = trainer.hasShadow as AnyObject
			trainerData["index"] = trainer.index as AnyObject

			#if GAME_XD
			trainerData["deck"] = trainer.deck.fileName as AnyObject
			trainerData["location"] = trainer.locationString as AnyObject
			let faceName = "trainer_\(trainer.trainerModel.rawValue).png"
			#else
			trainerData["items"] = trainer.items.map { $0.name.unformattedString } as AnyObject
			let faceName = "colo_trainer_\(trainer.trainerModel.rawValue).png"
			#endif
			trainerData["image"] = faceName as AnyObject

			if let battle = trainer.battleData {
				var battleData = [String: AnyObject]()
				battleData["description"] = battle.shortDescription as AnyObject
				battleData["BGM"] = battle.BGMusicID as AnyObject
				battleData["index"] = battle.index as AnyObject
				trainerData["battle"] = battleData as AnyObject
			}

			var pokemonArray = [[String: AnyObject]]()
			for deckPokemon in trainer.pokemon {
				guard deckPokemon.index > 0 else {
					continue
				}
				#if GAME_COLO
				let pokemon = deckPokemon
				#else
				let pokemon = deckPokemon.data
				#endif
				guard pokemon.species.index > 0 else {
					continue
				}

				var pokemonData = [String: AnyObject]()
				pokemonData["level"] = pokemon.level as AnyObject
				#if GAME_COLO
				if pokemon.isShadowPokemon {
					pokemonData["move1"] = "SHADOW RUSH | " + pokemon.moves[0].name.unformattedString as AnyObject
				} else {
					pokemonData["move1"] = pokemon.moves[0].name.unformattedString as AnyObject
				}
				pokemonData["move2"] = pokemon.moves[1].name.unformattedString as AnyObject
				pokemonData["move3"] = pokemon.moves[2].name.unformattedString as AnyObject
				pokemonData["move4"] = pokemon.moves[3].name.unformattedString as AnyObject
				#else
				for i in 0 ..< 4 {
					let move = pokemon.moves[i]
					let shadowMove = pokemon.shadowMoves[i]
					var moveText = ""
					if shadowMove.index > 0 {
						moveText += shadowMove.name.unformattedString + " | "
					}
					moveText += move.index > 0 ? move.name.unformattedString : "-"
					pokemonData["move\(i + 1)"] = moveText as AnyObject
				}
				#endif
				pokemonData["item"] = pokemon.item.name.unformattedString as AnyObject
				pokemonData["species"] = pokemon.species.name.unformattedString as AnyObject
				pokemonData["ability"] = (pokemon.ability == 0 ? pokemon.species.ability1 : pokemon.species.ability2) as AnyObject
				pokemonData["nature"] = pokemon.nature.string as AnyObject
				pokemonData["type1"] = pokemon.species.type1.name as AnyObject
				pokemonData["type2"] = pokemon.species.type1.name as AnyObject
				pokemonData["shadowID"] = pokemon.shadowID as AnyObject
				pokemonData["index"] = deckPokemon.index as AnyObject
				pokemonData["tabletype"] = "trainerpokemon" as AnyObject
				#if GAME_XD
				pokemonData["deck"] = deckPokemon.pokemonDeck.fileName as AnyObject
				pokemonData["shadowLevel"] = pokemon.shadowBoostLevel as AnyObject
				pokemonData["heartGauge"] = pokemon.shadowCounter as AnyObject
				pokemonData["aggression"] = pokemon.shadowAggression.name as AnyObject
				if forXG {
					pokemonData["isShiny"] = pokemon.shinyness.string as AnyObject
					if pokemon.species.index > 251 && pokemon.species.index < 277 {
						switch pokemon.species.index {
						case 252: pokemonData["species"] = "XD001" as AnyObject
						case 253: pokemonData["species"] = "Robo Groudon" as AnyObject
						case 254: pokemonData["species"] = "Robo Kyogre" as AnyObject
						case 255: pokemonData["species"] = "Mawile" as AnyObject
						case 256: pokemonData["species"] = "Kirlia" as AnyObject
						case 257: pokemonData["species"] = "Gardevoir" as AnyObject
						case 258: pokemonData["species"] = "Marill" as AnyObject
						case 259: pokemonData["species"] = "Azumarill" as AnyObject
						case 260: pokemonData["species"] = "Wigglytuff" as AnyObject
						case 261: pokemonData["species"] = "Snubbull" as AnyObject
						case 262: pokemonData["species"] = "Granbull" as AnyObject
						case 263: pokemonData["species"] = "Altaria" as AnyObject
						case 264: pokemonData["species"] = "Alolan Ninetales" as AnyObject
						case 265: pokemonData["species"] = "Alolan Marowak" as AnyObject
						case 266: pokemonData["species"] = "Alolan Sandslash" as AnyObject
						default: pokemonData["species"] = "Unused" as AnyObject
						}
					}
				}
				#else
				pokemonData["heartGauge"] = pokemon.shadowCounter * 100 as AnyObject
				#endif
				pokemonData["catchRate"] = pokemon.shadowCatchRate as AnyObject

				pokemonArray.append(pokemonData)
				let name: String
				if pokemon.shadowID > 0 {
					name = (forXG ? "Shadow " : "SHADOW ") + pokemon.species.name.unformattedString

				} else {
					name = pokemon.species.name.unformattedString
				}
				pokemonData["name"] = name as AnyObject
				let entryName = name.simplifiedKey
				pokemonData["entryname"] = entryName as AnyObject
				if pokemon.shadowID > 0 {
					data[entryName] = pokemonData as AnyObject
				}
			}
			trainerData["pokemon"] = pokemonArray as AnyObject

			var trainerArray = trainers[entryName] ?? []
			trainerArray.append(trainerData as AnyObject)
			trainers[entryName] = trainerArray
		}
		for (key, array) in trainers {
			var trainerObject = [String: AnyObject]()
			trainerObject["entries"] = array as AnyObject
			trainerObject["tabletype"] = "trainer" as AnyObject
			trainerObject["entryname"] = key as AnyObject
			data[key] = trainerObject as AnyObject
		}
		#endif

		func addEnumeration(name: String, text: String) {
			let enumerationData = text.replacingOccurrences(of: "\n\n", with: "\n")
			var lines = enumerationData.lines()
			if !forXG, name == "Evolution Methods", game != .PBR {
				lines.removeLast()
			}
			let header = lines.removeFirst()
			var tableData = [String: AnyObject]()
			let entryName = name.simplifiedKey
			tableData["entryname"] = entryName as AnyObject
			tableData["header"] = header as AnyObject
			tableData["values"] = lines as AnyObject
			tableData["count"] = lines.count as AnyObject
			tableData["tabletype"] = "enum" as AnyObject
			data[entryName] = tableData as AnyObject
		}

		for table in structTablesList {
			addEnumeration(name: table.properties.CStructName, text: table.getEnumerationData())
		}
		addEnumeration(name: XGAbilities.className, text: XGAbilities.getEnumerationData())
		addEnumeration(name: XGContestCategories.className, text: XGContestCategories.getEnumerationData())
		addEnumeration(name: XGDeoxysFormes.className, text: XGDeoxysFormes.getEnumerationData())
		addEnumeration(name: XGEffectivenessValues.className, text: XGEffectivenessValues.getEnumerationData())
		addEnumeration(name: XGEggGroups.className, text: XGEggGroups.getEnumerationData())
		addEnumeration(name: XGEvolutionMethods.className, text: XGEvolutionMethods.getEnumerationData())
		addEnumeration(name: XGExpRate.className, text: XGExpRate.getEnumerationData())
		addEnumeration(name: XGGenderRatios.className, text: XGGenderRatios.getEnumerationData())
		addEnumeration(name: XGGenders.className, text: XGGenders.getEnumerationData())
		addEnumeration(name: XGItems.className, text: XGItems.getEnumerationData())
		addEnumeration(name: XGMoveCategories.className, text: XGMoveCategories.getEnumerationData())
		addEnumeration(name: XGMoveEffectTypes.className, text: XGMoveEffectTypes.getEnumerationData())
		addEnumeration(name: XGMoves.className, text: XGMoves.getEnumerationData())
		addEnumeration(name: XGMoveTargets.className, text: XGMoveTargets.getEnumerationData())
		addEnumeration(name: XGMoveTypes.className, text: XGMoveTypes.getEnumerationData())
		addEnumeration(name: XGNatures.className, text: XGNatures.getEnumerationData())
		addEnumeration(name: XGPokemon.className, text: XGPokemon.getEnumerationData())
		addEnumeration(name: XGShinyValues.className, text: XGShinyValues.getEnumerationData())
		addEnumeration(name: XGTMs.className, text: XGTMs.getEnumerationData())
		addEnumeration(name: XGWeather.className, text: XGWeather.getEnumerationData())
		
		#if GAME_XD
		addEnumeration(name: XGPokeSpots.className, text: XGPokeSpots.getEnumerationData())
		addEnumeration(name: XGDecks.className, text: XGDecks.getEnumerationData())
		#endif
		#if GAME_PBR
		addEnumeration(name: XGWormadamCloaks.className, text: XGWormadamCloaks.getEnumerationData())
		#else
		addEnumeration(name: XGBagSlots.className, text: XGBagSlots.getEnumerationData())
		addEnumeration(name: XGBattleTypes.className, text: XGBattleTypes.getEnumerationData())
		addEnumeration(name: XGColosseumRounds.className, text: XGColosseumRounds.getEnumerationData())
		addEnumeration(name: XGMaps.className, text: XGMaps.getEnumerationData())
		addEnumeration(name: XGStatusEffects.className, text: XGStatusEffects.getEnumerationData())
		addEnumeration(name: XGTrainerClasses.className, text: XGTrainerClasses.getEnumerationData())
		addEnumeration(name: XGTrainerModels.className, text: XGTrainerModels.getEnumerationData())
		#endif

		writeDump(data, to: fileWithName("data", forXG: forXG))
	}

	class func dumpFiles(forXG: Bool = false, writeTextures: Bool = true) {
		let outputFolder = XGFolders.nameAndFolder("Texture Dump", folder)
		printg("extracting all textures to \(outputFolder.path)")
		printg("This will take a while...")

		var data = [String: AnyObject]()

		for filename in XGISO.current.allFileNames {
			printg(filename)

			// skip foreign language images for now
			// pbr names files based on fsys name anyway so other language files would have different filenames
			#if !GAME_PBR
			if !filename.starts(with: "wzx"),
			   filename.fileExtensions == ".fsys",
			   ["_ge", "_fr", "_sp", "_it"].contains(filename.removeFileExtensions().substring(from: filename.length - 8, to: filename.length - 5)) {
				continue
			}
			#endif

			let extractedFile = XGFiles.nameAndFolder(filename, .ISOExport(filename.removeFileExtensions()))
			XGUtility.exportFileFromISO(extractedFile, decode: false, overwrite: false)

			let folder = XGFolders.ISOExport(filename.removeFileExtensions())
			folder.files.forEach { (file) in
				guard file.fileType.rawValue <= XGFileTypes.fsys.rawValue else { return }

				let entryName = file.fileName.simplifiedKey

				var fileObject = [String: AnyObject]()
				fileObject["fsysname"] = filename as AnyObject
				fileObject["filename"] = file.fileName as AnyObject
				fileObject["entryName"] = entryName as AnyObject
				fileObject["filetype"] = file.fileType.fileExtension as AnyObject
				fileObject["filesize"] = file.fileSize  as AnyObject

				var textureObjects = [[String: AnyObject]]()
				var containedTextures = [GoDTexture]()

				if file.fileType == .fsys,
				   let fileData = file.data {
					let fsys = XGFsys(data: fileData)
					fileObject["filecount"] = fsys.numberOfEntries as AnyObject
					fileObject["filenames"] = fsys.filenames as AnyObject
					if game != .PBR {
						fileObject["fsysID"] = fsys.groupID as AnyObject
					}
					for file in fsys.files {
						if XGFileTypes.textureFormats.contains(file.fileType),
						   let data = fsys.extractDataForFile(file) {
							containedTextures.append(data.texture)
						}
					}
				} else {
					containedTextures = file.textures
				}

				containedTextures.sorted(by: { (t1, t2) -> Bool in
					return t1.file.fileName < t2.file.fileName
				}).forEach { (texture) in
					let imageFileName = texture.file.fileName + ".png"
					let imageFile = XGFiles.nameAndFolder(imageFileName, outputFolder)
					if !imageFile.exists, writeTextures {
						texture.writePNGData(toFile: imageFile)
					}

					var object = [String: AnyObject]()
					object["filename"] = texture.file.fileName as AnyObject
					object["format"] = texture.format.name as AnyObject
					object["paletteformat"] = (texture.isIndexed ? texture.paletteFormat.name : "None") as AnyObject
					object["width"] = texture.width as AnyObject
					object["height"] = texture.height as AnyObject
					let dolphinName = texture.dolphinFileName
					object["dolphinName"] = dolphinName as AnyObject
					object["fsysname"] = filename as AnyObject
					object["entryName"] = texture.file.fileName.simplified as AnyObject
					object["filetype"] = texture.file.fileType.fileExtension as AnyObject
					object["filesize"] = texture.data.length  as AnyObject
					textureObjects.append(object)

					data[texture.file.fileName.simplifiedKey] = object as AnyObject
					data[dolphinName.simplifiedKey] = object as AnyObject
				}
				if [XGFileTypes.gtx, .atx].contains(file.fileType) {
					return
				}

				fileObject["textures"] = textureObjects as AnyObject

				if file.fileType == .msg {
					let table = file.stringTable
					fileObject["numberOfStrings"] = table.numberOfEntries as AnyObject
					#if !GAME_PBR
					fileObject["minStringID"] = table.stringIDs.min() as AnyObject
					fileObject["maxStringID"] = table.stringIDs.max() as AnyObject
					#endif
				}

				var hasScript = file.fileType == .scd
				#if !GAME_PBR
				if file == .common_rel {
					hasScript = true
				}
				#endif
				if hasScript && !file.fileName.contains("ending") && !file.fileName.contains("ending") {
					let script: XGScript
					switch file.path {
					#if !GAME_PBR
					case XGFiles.common_rel.path:
						let start = CommonIndexes.Script.startOffset
						let length = CommonIndexes.Script.length

						let data = XGMutableData(byteStream: file.data!.getCharStreamFromOffset(start, length: length), file: .common_rel)
						script = XGScript(data: data)
					#endif
					default:
						#if GAME_XD
						script = XGScript(file: file, loadRel: false)
						#else
						script = XGScript(file: file)
						#endif
					}
					var functionNames = [String]()
					fileObject["numberOfFunctions"] = script.ftbl.count as AnyObject
					for function in script.ftbl {
						functionNames.append(function.name)
					}
					fileObject["functions"] = functionNames as AnyObject
				}

				data[entryName] = fileObject as AnyObject
				if game != .PBR,
				   file.fileType == .fsys,
				   let fsysId = fileObject["fsysID"] as? Int {
					let groupIDName = "groupid\(fsysId)"
					data[groupIDName] = fileObject as AnyObject
				}
			}
		}
		writeDump(data, to: fileWithName("files", forXG: forXG))
	}

	class func dumpMSG(forXG: Bool = false) {
		var msgData = [String: AnyObject]()

		loadAllStrings()
		#if GAME_PBR
		let stringsCount = PBRStringManager.totalNumberOfStrings
		for i in 0 ..< stringsCount {
			let id = i + 1
			let string = getStringSafelyWithID(id: id)

			var msgObject = [String: AnyObject]()
			msgObject["filename"] = (string.filename ?? "unknown") as AnyObject
			msgObject["text"] = string.string as AnyObject
			msgObject["id"] = string.id as AnyObject

			msgData[string.id.string] = msgObject as AnyObject
			msgData[string.id.hexString().simplified] = msgObject as AnyObject
		}
		#else
		for table in allStringTables {
			for string in table.allStrings() {
				var msgObject = [String: AnyObject]()
				msgObject["filename"] = table.file.fileName as AnyObject
				msgObject["text"] = string.string as AnyObject
				msgObject["id"] = string.id as AnyObject

				msgData[string.id.string] = msgObject as AnyObject
				msgData[string.id.hexString().simplified] = msgObject as AnyObject
			}
		}
		#endif

		writeDump(msgData, to: fileWithName("msg", forXG: forXG))
	}
}
