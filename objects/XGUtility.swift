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
		
		let compressFolders = [XGFolders.Common, XGFolders.Decks, XGFolders.Textures, XGFolders.StringTables, XGFolders.Scripts]
		
		for folder in compressFolders where folder.exists {
			for file in folder.files {
				print("compressing file: " + file.fileName)
				file.compress()
			}
		}
		
	}
	
	class func importFsys() {
		
		print("importing files to .fsys archives")
		
		if !DeckDataEmptyLZSS.file.exists {
			DeckDataEmptyLZSS.save()
		}
		
		let common = XGFiles.fsys("common.fsys").fsysData
		common.shiftAndReplaceFileWithIndex(2, withFile: .lzss("DeckData_Empty.bin.lzss")) //EU file
		common.shiftAndReplaceFileWithIndex(4, withFile: .lzss("DeckData_DarkPokemon.bin.lzss"))
		common.shiftAndReplaceFileWithIndex(0, withFile: .lzss("common_rel.fdat.lzss"))
		
		XGFiles.fsys("common_dvdeth.fsys").fsysData.shiftAndReplaceFileWithIndex(0, withFile: .lzss("tableres2.fdat.lzss"))
		
		let deckArchive = XGFiles.fsys("deck_archive.fsys").fsysData
		
		for i in 0 ..< deckArchive.numberOfEntries {
			// remove eu files to make space for increased file sizes assuming they're all the odd ones
			if i % 2 == 1 {
				deckArchive.shiftAndReplaceFileWithIndex(i, withFile: .lzss("DeckData_Empty.bin.lzss"))
			}
		}
		
		deckArchive.shiftAndReplaceFileWithIndex(2, withFile: .lzss("DeckData_Colosseum.bin.lzss"))
		deckArchive.shiftAndReplaceFileWithIndex(4, withFile: .lzss("DeckData_DarkPokemon.bin.lzss"))
		deckArchive.shiftAndReplaceFileWithIndex(12, withFile: .lzss("DeckData_Story.bin.lzss"))
		deckArchive.shiftAndReplaceFileWithIndex(14, withFile: .lzss("DeckData_Virtual.bin.lzss"))
		
		XGFiles.fsys("fight_common.fsys").fsysData.shiftAndReplaceFileWithIndex(0, withFile: .lzss("fight.msg.lzss"))
		XGFiles.nameAndFolder("pocket_menu.fsys",.MenuFSYS).fsysData.shiftAndReplaceFileWithIndex(0, withFile: .lzss("pocket_menu.fdat.lzss"))
		
	}
	
	class func updateHealingItems() {
		let kBattleItemDataStartOffset = 0x402570
		let kSizeOfBattleItemEntry = 0x10
		let kBattleItemHPToRestoreOffset = 0xA
		// N.B. A lot of these values are bit mask and so a single item can have many of these effects at once
		// byte 0x3 status to heal mask (0x20 sleep, 0x10 poison, 0x8 burn, 0x4 freeze, 0x2 paralysis, 0x1 confusion, 0x3F all)
		// 0x40 level up, 0x80 guard spec
		// byte 0x4 0x80 increase max pp, 0x40 revive, 0x20 restore pp, 0x10 evolution stone, 0x8 max out pp
		// byte 0xb pp to restore (0x7f for all pp)
		// bytes 5-7 friendship change
		// byte 0xa hp to restore (0xfd hp gained by level up, 0xfe for half, 0xff for full)
		// byte 0x8 hp evs
		// byte 0x9 attack evs
		// byte 0xc defense evs
		// byte 0xd speed
		// byte 0xe spdef evs
		// byte 0xf spatk evs
		// byte 0x0 0x20 dire hit, 0x2 x attack
		// byte 0x1 0x10 x defend, 0x1 x speed
		// byte 0x2 0x10 x accuracy, 0x1 x special
		
		let dol = XGFiles.dol.data
		
		let healingItems = [13,19,20,21,22,26,27,28,29,30,31,44,139,142]
		
		for i in healingItems {
			let item = XGItem(index: i)
			let id = item.inBattleUseID
			let offset = kBattleItemDataStartOffset + (kSizeOfBattleItemEntry * id)
			dol.replaceByteAtOffset(offset + kBattleItemHPToRestoreOffset, withByte: item.parameter)
		}
		
		dol.save()
		
	}
	
	class func updateValidItems() {
		let itemListStart = Common_relIndices.ValidItems.startOffset()
		let rel = XGFiles.common_rel.data
		
		print("Updating items list...")
		
		for i in 1 ..< kNumberOfItems {
			let currentOffset = itemListStart + (i * 2)
			
			if XGItems.item(i).nameID != 0 {
				rel.replace2BytesAtOffset(currentOffset, withBytes: i)
			} else {
				rel.replace2BytesAtOffset(currentOffset, withBytes: 0)
			}
		}
		
		rel.save()
	}
	
	class func updateShadowMoves() {
		// shadow move table
		// create entry for every move so any move can be shadow
		let tableStart = 0x73740
		let rel = XGFiles.common_rel.data
		for i in 0 ..< kNumberOfMoves {
			let offset = tableStart + (i * 4)
			rel.replace4BytesAtOffset(offset, withBytes: UInt32(i << 16) + 0x0500)
		}
		
		for i in 0 ..< kNumberOfMoves {
			
			let m = XGMoves.move(i).data
			if m.isShadowMove {
				rel.replace4BytesAtOffset(m.startOffset + 0x14, withBytes: 0x00023101)
			}
			
		}
		rel.save()
	}
	
	class func shadowMadnessAnimation() {
		print("updating shadow madness animation")
		
		let rel = XGFiles.common_rel.data
		let offset = move("shadow madness").data.startOffset + kAnimation2IndexOffset
		rel.replace2BytesAtOffset(offset, withBytes: 0x173)
		rel.save()
	}
	
	class func shadowLugiaDPKMLevel() {
		let lugia = XGDeckPokemon.ddpk(73)
		let data = lugia.deck.data
		let start = lugia.data.startOffset
		data.replaceByteAtOffset(start + kPokemonLevelOffset, withByte: 80)
		data.save()
	}
	
	class func prepareXG() {
		shadowLugiaDPKMLevel()
		shadowMadnessAnimation()
	}
	
	class func prepareForCompilation() {
		updateShadowMoves()
		updateValidItems()
		updateHealingItems()
		updateTutorMoves()
		updatePokeSpots()
		updateShadowMonitor()
		compressFiles()
		importFsys()
	}
	
	class func compileMainFiles() {
		prepareForCompilation()
		XGISO().updateISO()
	}
	
	class func compileCommonRel() {
		XGFiles.fsys("common.fsys").fsysData.shiftAndReplaceFileWithIndex(0, withFile: XGFiles.common_rel.compress())
		XGISO().importFiles([.fsys("common.fsys")])
	}
	
	class func compileDol() {
		XGISO().importDol()
	}
	
	class func compileForRandomiser() {
		prepareForCompilation()
		
		XGISO().importRandomiserFiles()
	}
	
	class func compileAllFiles() {
		
		importStringTables()
		importScripts()
		
		prepareForCompilation()
		
		
		XGISO().importAllFiles()
	}
	
	class func compileForRelease(XG: Bool) {
		prepareForRelease()
		if XG { prepareXG() }
		compileAllFiles()
	}
	
	class func importScripts() {
		for file in XGFolders.Scripts.files {
			
			print("importing script: " + file.fileName)
			
			let fsysName = file.fileName.replacingOccurrences(of: ".scd", with: ".fsys")
			let lzssName = file.fileName + ".lzss"
			
			let fsysFile = XGFiles.nameAndFolder(fsysName, XGFolders.AutoFSYS)
			let lzssFile = XGFiles.nameAndFolder(lzssName, XGFolders.LZSS)
			
			if fsysFile.exists {
				fsysFile.fsysData.shiftAndReplaceFileWithIndex(1, withFile: lzssFile)
			}
		}
	}
	
	class func importStringTables() {
		for file in XGFolders.StringTables.files {
			
			print("importing string table: " + file.fileName)
			
			let fsysName = file.fileName.replacingOccurrences(of: ".msg", with: ".fsys")
			let lzssName = file.fileName + ".lzss"
			
			let fsysFile = XGFiles.nameAndFolder(fsysName, XGFolders.AutoFSYS)
			let lzssFile = XGFiles.nameAndFolder(lzssName, XGFolders.LZSS)
			
			if fsysFile.exists {
				fsysFile.fsysData.shiftAndReplaceFileWithIndex(2, withFile: lzssFile)
			}
		}
		
		print("importing menu string tables")
		
		let pocket_menu = XGFiles.lzss("pocket_menu.msg.lzss")
		let d4tower1f3 = XGFiles.lzss("D4_tower_1F_3.msg.lzss")
		let m5labo2f = XGFiles.lzss("M5_labo_2F.msg.lzss")
		let d4tower1f2 = XGFiles.lzss("D4_tower_1F_2.msg.lzss")
		let nameentrymenu = XGFiles.lzss("name_entry_menu.msg.lzss")
		let system_tool = XGFiles.lzss("system_tool.msg.lzss")
		let m3shrine1frl = XGFiles.lzss("M3_shrine_1F_rl.msg.lzss")
		let relivehall_menu = XGFiles.lzss("relivehall_menu.msg.lzss")
		let pda_menu = XGFiles.lzss("pda_menu.msg.lzss")
		let d2pc1f = XGFiles.lzss("D2_pc_1F.msg.lzss")
		let d7out = XGFiles.lzss("D7_out.msg.lzss")
		let p_exchange = XGFiles.lzss("p_exchange.msg.lzss")
		let world_map = XGFiles.lzss("world_map.msg.lzss")
		let fight = XGFiles.lzss("fight.msg.lzss")
		
		XGFiles.nameAndFolder("battle_disk.fsys",.MenuFSYS).fsysData.shiftAndReplaceFileWithIndex(0, withFile: pocket_menu)
		XGFiles.nameAndFolder("battle_disk.fsys",.MenuFSYS).fsysData.shiftAndReplaceFileWithIndex(1, withFile: m5labo2f)
		XGFiles.nameAndFolder("battle_disk.fsys",.MenuFSYS).fsysData.shiftAndReplaceFileWithIndex(2, withFile: d4tower1f3)
		XGFiles.nameAndFolder("bingo_menu.fsys",.MenuFSYS).fsysData.shiftAndReplaceFileWithIndex(0, withFile: d4tower1f2)
		XGFiles.nameAndFolder("carde_menu.fsys",.MenuFSYS).fsysData.shiftAndReplaceFileWithIndex(0, withFile: system_tool)
		XGFiles.fsys("fight_common.fsys").fsysData.shiftAndReplaceFileWithIndex(0, withFile: fight)
		XGFiles.nameAndFolder("hologram_menu.fsys",.MenuFSYS).fsysData.shiftAndReplaceFileWithIndex(0, withFile: m3shrine1frl)
		XGFiles.nameAndFolder("hologram_menu.fsys",.MenuFSYS).fsysData.shiftAndReplaceFileWithIndex(1, withFile: relivehall_menu)
		XGFiles.nameAndFolder("mailopen_menu.fsys",.MenuFSYS).fsysData.shiftAndReplaceFileWithIndex(0, withFile: pda_menu)
		XGFiles.nameAndFolder("mewwaza.fsys",.MenuFSYS).fsysData.shiftAndReplaceFileWithIndex(0, withFile: d2pc1f)
		XGFiles.nameAndFolder("name_entry_menu.fsys",.MenuFSYS).fsysData.shiftAndReplaceFileWithIndex(1, withFile:nameentrymenu)
		XGFiles.nameAndFolder("orre_menu.fsys",.MenuFSYS).fsysData.shiftAndReplaceFileWithIndex(0, withFile: d7out)
		XGFiles.nameAndFolder("orre_menu.fsys",.MenuFSYS).fsysData.shiftAndReplaceFileWithIndex(1, withFile: pocket_menu)
		XGFiles.nameAndFolder("orre_menu.fsys",.MenuFSYS).fsysData.shiftAndReplaceFileWithIndex(2, withFile: system_tool)
		XGFiles.nameAndFolder("pcbox_menu.fsys",.MenuFSYS).fsysData.shiftAndReplaceFileWithIndex(0, withFile: system_tool)
		XGFiles.nameAndFolder("pcbox_menu.fsys",.MenuFSYS).fsysData.shiftAndReplaceFileWithIndex(1, withFile: pocket_menu)
		XGFiles.nameAndFolder("pcbox_name_entry_menu.fsys",.MenuFSYS).fsysData.shiftAndReplaceFileWithIndex(0, withFile: nameentrymenu)
		XGFiles.nameAndFolder("pcbox_pocket_menu.fsys",.MenuFSYS).fsysData.shiftAndReplaceFileWithIndex(0, withFile: pocket_menu)
		XGFiles.nameAndFolder("pda_menu.fsys",.MenuFSYS).fsysData.shiftAndReplaceFileWithIndex(2, withFile: pda_menu)
		XGFiles.nameAndFolder("pocket_menu.fsys",.MenuFSYS).fsysData.shiftAndReplaceFileWithIndex(1, withFile: pocket_menu)
		XGFiles.nameAndFolder("pokemonchange_menu.fsys",.MenuFSYS).fsysData.shiftAndReplaceFileWithIndex(0, withFile: system_tool)
		XGFiles.nameAndFolder("pokemonchange_menu.fsys",.MenuFSYS).fsysData.shiftAndReplaceFileWithIndex(1, withFile: pocket_menu)
		XGFiles.nameAndFolder("pokemonchange_menu.fsys",.MenuFSYS).fsysData.shiftAndReplaceFileWithIndex(2, withFile: p_exchange)
		XGFiles.nameAndFolder("relivehall_menu.fsys",.MenuFSYS).fsysData.shiftAndReplaceFileWithIndex(0, withFile: relivehall_menu)
		XGFiles.nameAndFolder("pokemonchange_menu.fsys",.MenuFSYS).fsysData.shiftAndReplaceFileWithIndex(0, withFile: system_tool)
		XGFiles.nameAndFolder("title.fsys",.MenuFSYS).fsysData.shiftAndReplaceFileWithIndex(1, withFile: system_tool)
		XGFiles.nameAndFolder("topmenu.fsys",.MenuFSYS).fsysData.shiftAndReplaceFileWithIndex(0, withFile: system_tool)
		XGFiles.nameAndFolder("waza_menu.fsys",.MenuFSYS).fsysData.shiftAndReplaceFileWithIndex(1, withFile: pocket_menu)
		XGFiles.nameAndFolder("worldmap.fsys",.MenuFSYS).fsysData.shiftAndReplaceFileWithIndex(1, withFile: world_map)
		XGFiles.nameAndFolder("colosseumbattle_menu.fsys",.MenuFSYS).fsysData.replaceFileWithIndex(0, withFile: pocket_menu, saveWhenDone: true)
		XGFiles.nameAndFolder("colosseumbattle_menu.fsys",.MenuFSYS).fsysData.replaceFileWithIndex(2, withFile: nameentrymenu, saveWhenDone: true)
		XGFiles.nameAndFolder("colosseumbattle_menu.fsys",.MenuFSYS).fsysData.replaceFileWithIndex(3, withFile: system_tool, saveWhenDone: true)
		
		
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
		let iso = XGISO()
		for name in iso.allFileNames where name.contains(".fsys") {
			let fsys = XGFsys(data: iso.dataForFile(filename: name)!)
			for index in 0 ..< fsys.numberOfEntries {
				if fsys.fileNames[index].contains(file.fileName.removeFileExtensions()) {
					print("fsys: ",name,", index: ", index, ",name: ", fsys.fileNames[index])
				}
			}
			
		}
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
			print("couldn't save json to file: \(file.path)")
		}
	}
	
	class func loadJSONFromFile(_ file: XGFiles) -> AnyObject? {
		do {
			let json = try JSONSerialization.jsonObject(with: file.data.data as Data, options: [])
			return json as AnyObject?
		} catch {
			print("couldn't load json from file: \(file.path)")
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
	
	class func patchDol() {
		
		let patches = [0,2,3,6,7]
		
		for i in patches {
			XGDolPatcher.applyPatch(XGDolPatches(rawValue: i)!)
		}
	}
	
	class func renameZaprong(newName: String) {
		let offset = 0x420904
		let dol = XGFiles.dol.data
		dol.replaceBytesFromOffset(offset, withByteStream: newName.characters.map({ (c) -> Int in
			let charScalar = String(c).unicodeScalars
			let charValue  = Int(charScalar[charScalar.startIndex].value)
			return charValue
		}))
		dol.save()
	}
	
	class func defaultMoveCategories() {
		let categories = XGResources.JSON("MoveCategories").json as! [Int]
		for i in 0 ..< kNumberOfMoves {
			let move = XGMove(index: i)
			move.category = XGMoveCategories(rawValue: categories[i]) ?? XGMoveCategories.none
			move.save()
		}
		printg("all moves have now had their default categories applied.")
		
	}
	
	//MARK: - Obtainable pokemon
	class func obtainablePokemon() -> [XGPokemon] {
		var pokes = [XGPokemon]()
		
		for i in 1 ..< XGDecks.DeckDarkPokemon.DDPKEntries {
			let p = XGDeckPokemon.ddpk(i).pokemon
			pokes.append(p)
		}
		pokes.append(XGTradeShadowPokemon().species)
		for i in 0 ..< 2 {
			pokes.append(XGDemoStarterPokemon(index: i).species)
		}
		for i in 0 ..< 3 {
			pokes.append(XGMtBattlePrizePokemon(index: i).species)
		}
		
		for i in 0 ..< 4 {
			pokes.append(XGTradePokemon(index: i).species)
		}
		
		for s in 0 ... 2 {
			
			let spot = XGPokeSpots(rawValue: s)!
			
			for p in 0 ..< spot.numberOfEntries() {
				pokes.append(XGPokeSpotPokemon(index: p, pokespot: spot).pokemon)
			}
		}
		
		for p in pokes {
			for e in XGPokemonStats(index: p.index).evolutions {
				let evo = XGPokemon.pokemon(e.evolvesInto)
				pokes.append(evo)
				for ev in XGPokemonStats(index: evo.index).evolutions {
					let evol = XGPokemon.pokemon(ev.evolvesInto)
					pokes.append(evol)
				}
			}
		}
		
		var obts = [XGPokemon]()
		
		for p in pokes {
			if !(obts.contains{ $0.index == p.index }) {
				obts.append(p)
			}
		}
		
		return obts
	}
	
	class func saveObtainablePokemon() {
		let k = obtainablePokemon().sorted{$0 < $1}.filter{$0.index != 0}
		var s = "XG Obtainable Pokemon:\t\(k.count)\n"
		for p in k {
			s += "\(p.index):\t\(p)\n"
		}
		
		saveString(s, toFile: .nameAndFolder("output/obtainable pokemon.txt",.Documents))
	}
	
	class func saveObtainableTypes() {
		
		var pokes = [XGPokemon]()
		
		for i in 0 ..< XGDecks.DeckDarkPokemon.DDPKEntries {
			let p = XGDeckPokemon.ddpk(i).pokemon
			pokes.append(p)
		}
		pokes.append(XGTradeShadowPokemon().species)
		for i in 0 ..< 2 {
			pokes.append(XGDemoStarterPokemon(index: i).species)
		}
		for i in 0 ..< 3 {
			pokes.append(XGMtBattlePrizePokemon(index: i).species)
		}
		
		for i in 0 ..< 4 {
			pokes.append(XGTradePokemon(index: i).species)
		}
		
		for s in 0 ... 2 {
			
			let spot = XGPokeSpots(rawValue: s)!
			
			for p in 0 ..< spot.numberOfEntries() {
				pokes.append(XGPokeSpotPokemon(index: p, pokespot: spot).pokemon)
			}
		}
		
		var typesCount = [Int]()
		
		for _ in 0...17 {
			typesCount.append(0)
		}
		
		for i in pokes {
			
			guard i.index != 0 else {
				continue
			}
			
			let poke = XGPokemonStats(index: i.index)
			let t1 = poke.type1.rawValue
			let t2 = poke.type2.rawValue
			typesCount[t1] = typesCount[t1] + 1
			if t2 != t1 {
				typesCount[t2] = typesCount[t2] + 1
			}
		}
		
		var string = "XG Obtainable types count:\n"
		for i in 0...17 {
			let name = XGMoveTypes(rawValue: i)!.name
			
			string += name
			string += "\t:\t"
			string += "\(typesCount[i])\n"
		}
		saveString(string, toFile: XGFiles.nameAndFolder("XG Obtainable Types Count.txt", XGFolders.Reference))
		
	}
	
	class func saveObtainablePokemonByLocation() {
		
		func tabsForName(_ name: String) -> String {
			return name.characters.count >= 9 ? "\t" : (name.characters.count >= 3 ? "\t\t" : "\t\t\t")
		}
		
		var string = "Pokemon XD Obtainable Pokemon by Location:\n\n"
		
		string += "\n************************************************************************************\nStarter Pokemon\n\n"
		
		for i in 0 ..< 2 {
			let pokemon = XGDemoStarterPokemon(index: i)
			string += pokemon.species.name.string + "\t\(tabsForName(pokemon.species.name.string))Lv. " + "\(pokemon.level)" + "\n"
		}
		
		string += "\n************************************************************************************\nShadow Pokemon" + " \(XGDecks.DeckDarkPokemon.allActivePokemon.count)" + "\n\n"
		
		var shadows = [Int]()
		
		for trainer in XGDecks.DeckStory.allTrainers {
			
			if !trainer.hasShadow {
				continue
			}
			
			var str = trainer.trainerString
			var range = str.startIndex ..< str.characters.index(str.startIndex, offsetBy: 1)
			let sub1 = str.substring(with: range)
			
			if str == "NULL" {
				str = "-"
			} else if str.range(of: "Opening", options: [], range: nil, locale: nil) != nil {
				
				str = str.replacingOccurrences(of: "_p", with: " Player Team", options: [], range: nil)
				str = str.replacingOccurrences(of: "_e", with: " Enemy Team", options: [], range: nil)
				str = str.replacingOccurrences(of: "Opening", with: "Opening Battle ", options: [], range: nil)
				
			} else if str.range(of: "Vdisk", options: [], range: nil, locale: nil) != nil {
				
				str = str.replacingOccurrences(of: "_p", with: " Player Team", options: [], range: nil)
				str = str.replacingOccurrences(of: "_e", with: " Enemy Team", options: [], range: nil)
				str = str.replacingOccurrences(of: "Vdisk", with: "Battle CD ", options: [], range: nil)
				
			} else if sub1 == "N" {
				str = str.replacingCharacters(in: range, with: "Mt.Battle Zone ")
			} else if sub1 == "P" {
				str = str.replacingCharacters(in: range, with: "Pyrite Colosseum ")
			} else if sub1 == "O" {
				str = str.replacingCharacters(in: range, with: "Orre Colosseum ")
			} else if sub1 == "T" {
				str = str.replacingCharacters(in: range, with: "Tower Colosseum ")
			} else {
				range = str.startIndex ..< str.characters.index(str.startIndex, offsetBy: 2)
				let sub = str.substring(with: range)
				str = XGMaps(rawValue: sub)?.name ?? str
			}
			
			str = str.replacingOccurrences(of: "_col_", with: " Colosseum ", options: [], range: nil)
			str = str.replacingOccurrences(of: "555_", with: "Battle ", options: [], range: nil)
			str = str.replacingOccurrences(of: "Esaba", with: "Pokespot", options: [], range: nil)
			str = str.replacingOccurrences(of: "_", with: " ", options: [], range: nil)
			str = str.replacingOccurrences(of: "Mirabo", with: "Miror B.", options: [], range: nil)
			str = str.replacingOccurrences(of: "mirabo", with: "Miror B.", options: [], range: nil)
			str = str.replacingOccurrences(of: "haihu", with: "Gift", options: [], range: nil)
			let location = str
			
			
			for poke in trainer.pokemon {
				if poke.isShadow {
					if !shadows.contains(poke.index) {
						shadows.append(poke.index)
						let pokemon = poke.data
						
						let name = trainer.trainerClass.name.string.replacingOccurrences(of: "[07]{00}", with: "") + " " + trainer.name.string
						var spaces = " "
						for i in 1 ... 20 {
							if i > name.characters.count {
								spaces += " "
							}
						}
						
						string += "Shadow " + pokemon.species.name.string + "\(tabsForName(pokemon.species.name.string))Lv. " + String(format: "%02d+\t\t", pokemon.level)
						string += name + spaces + "\t\t\t" + location + "\n"
						
					}
				}
			}
			
			
		}
		
		
		string += "\n************************************************************************************\nPokespots\n\n"
		
		string += "----------------------------------\n"
		string += "Rock Pokespot:\n"
		for i in 0 ..< XGPokeSpots.rock.numberOfEntries() {
			let poke = XGPokeSpotPokemon(index: i, pokespot: .rock)
			string += "Wild " + poke.pokemon.name.string + "  \t\(tabsForName(poke.pokemon.name.string))Lv. " + "\(poke.minLevel) - \(poke.maxLevel)" + "\n"
		}
		
		string += "----------------------------------\n"
		string += "Oasis Pokespot:\n"
		for i in 0 ..< XGPokeSpots.oasis.numberOfEntries() {
			let poke = XGPokeSpotPokemon(index: i, pokespot: .oasis)
			string += "Wild " + poke.pokemon.name.string + "  \t\(tabsForName(poke.pokemon.name.string))Lv. " + "\(poke.minLevel) - \(poke.maxLevel)" + "\n"
		}
		
		string += "----------------------------------\n"
		string += "Cave Pokespot:\n"
		for i in 0 ..< XGPokeSpots.cave.numberOfEntries() {
			let poke = XGPokeSpotPokemon(index: i, pokespot: .cave)
			string += "Wild " + poke.pokemon.name.string + "  \t\(tabsForName(poke.pokemon.name.string))Lv. " + "\(poke.minLevel) - \(poke.maxLevel)" + "\n"
		}
		
		string += "\n************************************************************************************\nHordel Trade\n\n"
		
		let pokemon = XGTradePokemon(index: 0)
		string += "Hordel's " + pokemon.species.name.string + "\t\(tabsForName(pokemon.species.name.string))Lv. " + "\(pokemon.level)" + "\n"
		
		string += "\n************************************************************************************\nDuking Trades\n\n"
		
		for i in 1 ..< 4 {
			let pokemon = XGTradePokemon(index: i)
			string += "Duking's " + pokemon.species.name.string + "\(tabsForName(pokemon.species.name.string))Lv. " + "\(pokemon.level)" + "\n"
		}
		
		string += "\n************************************************************************************\nMt. Battle Prizes\n\n"
		
		for i in 0 ..< 3 {
			let pokemon = XGMtBattlePrizePokemon(index: i)
			string += "Mt. Battle " + pokemon.species.name.string + "\t\(tabsForName(pokemon.species.name.string))Lv. " + "\(pokemon.level)" + "\n"
		}
		
		saveString(string, toFile: XGFiles.nameAndFolder("XD Obtainable Pokemon List.txt", XGFolders.Reference))
	}
	
	
	//MARK: - Release configuration
	class func prepareForRelease() {
		//	prepareMonsForRelease()
		//	prepareMovesForRelease()
		fixUpTrainerPokemon()
	}
	
	class func prepareMonsForRelease() {
		for id in 1 ..< kNumberOfPokemon {
			let mon = XGPokemonStats(index: id)
			let name = mon.name
			if name.string.characters.count > 2 {
				let index = name.string.characters.index(name.string.endIndex, offsetBy: -2)
				let lastChars = name.string.substring(from: index)
				
				if lastChars == "-A" {
					name.println()
					let new = name.string.replacingOccurrences(of: "-A", with: "")
					mon.name.duplicateWithString(new).replace()
				}
				
			}
		}
	}
	
	class func prepareMovesForRelease() {
		for id in 1 ..< kNumberOfMoves {
			let move = XGMove(index: id)
			let name = move.nameString
			if name.string.characters.count > 1 {
				
				let index = name.string.characters.index(before: name.string.endIndex)
				let lastChar = name.string.substring(from: index)
				
				if lastChar == "+" || lastChar == "-" {
					let new = name.string.replacingCharacters(in: index ..< name.string.characters.endIndex, with: "")
					move.nameString.duplicateWithString(new).replace()
				}
				
			}
		}
	}
	
	class func fixUpTrainerPokemon() {
		for deck in TrainerDecksArray {
			for poke in deck.allPokemon {
				let spec = poke.species.stats
				
				if spec.genderRatio == .maleOnly { poke.gender = .male }
				if spec.genderRatio == .femaleOnly { poke.gender = .female }
				if spec.genderRatio == .genderless { poke.gender = .genderless }
				
				if (spec.ability2.index == 0) && (poke.ability == 1) { poke.ability = 0 }
				
				poke.save()
			}
		}
	}
	
	class func updateShadowMonitor() {
		
		print("updating shadow monitor")
		
		let start = 0x4014EA
		
		var indices = [Int]()
		let deck = XGDecks.DeckDarkPokemon
		var pokes = [XGDeckPokemon]()
		
		for i in 1..<deck.DDPKEntries {
			pokes.append(.ddpk(i))
		}
		
		for poke in pokes {
			if poke.pokemon.index == 0 {
				indices.append(0x118)
			} else {
				indices.append(poke.pokemon.index)
			}
		}
		
		let dol = XGFiles.dol.data
		
		dol.replaceBytesFromOffset(start, withShortStream: indices)
		
		dol.save()
		
	}
	
	class func updateTutorMoves() {
		// Need to update class function which determines which pokemon stats move tutor move index
		// Corresponds to each tutor move. This class function will set it so that it is in the same
		// Order as the tutor moves indexes.
		
		print("updating tutor moves")
		
		let dol = XGFiles.dol.data
		
		let offsets = [
			0x1C2ECA, // 0
			0x1C2EBE, // 1
			0x1C2ED6, // 2
			0x1C2EEE, // 3
			0x1C2EA6, // 4
			0x1C2EB2, // 5
			0x1C2F06, // 6
			0x1C2F2A, // 7
			0x1C2F1E, // 8
			0x1C2F12, // 9
			0x1C2EE2, // 10
			0x1C2EFA, // 11
		]
		
		for i in 1...12 {
			let tmove = XGTMs.tutor(i).move
			let offset = offsets[i-1]
			
			dol.replace4BytesAtOffset(offset + 6, withBytes: kNopInstruction)
			
			dol.replace2BytesAtOffset(offset, withBytes: tmove.index)
		}
		
		dol.save()
	}
	
	
	
	class func updatePokeSpots() {
		// Need to change array values at bottom of m2 guild script.
		// You need the national dex index of the pokemon you trade.
		// Then replace the values with 1000 + the national dex index.
		// Wooper is 1194 0x4aa, trapinch is 1328 0x530, surskit is 1283 0x503.
		// This code only does it for gen I-II since national id is same as index.
		// Also need to get national ids for the pokemon you get from trade.
		
		print("updating pokespots")
		
		let script = XGFiles.script("M2_guild_1F_2.scd").data
		
		let trapinches = [0x0B4A,0x0D1E]
		let surskits = [0x0B9A,0x0D62]
		let woopers = [0x0BEA,0x0DA6]
		
		let trapinch = XGPokeSpotPokemon(index: 2, pokespot: .rock).pokemon.stats.nationalIndex
		let surskit = XGPokeSpotPokemon(index: 2, pokespot: .oasis).pokemon.stats.nationalIndex
		let wooper = XGPokeSpotPokemon(index: 2, pokespot: .cave).pokemon.stats.nationalIndex
		
		for offset in trapinches {
			script.replace2BytesAtOffset(offset, withBytes: trapinch)
		}
		
		for offset in surskits {
			script.replace2BytesAtOffset(offset, withBytes: surskit)
		}
		
		for offset in woopers {
			script.replace2BytesAtOffset(offset, withBytes: wooper)
		}
		
		script.replace2BytesAtOffset(0x0D3A, withBytes: trapinch + 1000)
		script.replace2BytesAtOffset(0x1756, withBytes: trapinch + 1000)
		
		
		script.replace2BytesAtOffset(0x0D7E, withBytes: surskit + 1000)
		script.replace2BytesAtOffset(0x175E, withBytes: surskit + 1000)
		
		
		script.replace2BytesAtOffset(0x0DC2, withBytes: wooper + 1000)
		script.replace2BytesAtOffset(0x1766, withBytes: wooper + 1000)
		
		
		let meditite = XGTradePokemon(index: 1).species.stats.nationalIndex
		let shuckle = XGTradePokemon(index: 2).species.stats.nationalIndex
		let larvitar = XGTradePokemon(index: 3).species.stats.nationalIndex
		
		script.replace2BytesAtOffset(0x0D32, withBytes: meditite + 1000)
		script.replace2BytesAtOffset(0x0D76, withBytes: shuckle + 1000)
		script.replace2BytesAtOffset(0x0DBA, withBytes: larvitar + 1000)
		
		
		
		script.save()
	}
	
	class func printOccurencesOfMove(search: XGMoves) {
		
		if search.index == 0 {
			return
		}
		
		for deck in TrainerDecksArray {
			for trainer in deck.allTrainers {
				for mon in trainer.pokemon.map({ (p) -> XGTrainerPokemon in
					return p.data
				}) {
					if mon.moves.contains(where: { (m) -> Bool in
						return m.index == search.index
					}) {
						print(trainer.name, trainer.locationString)
					}
				}
			}
		}
		
		for i in 1 ..< kNumberOfPokemon {
			let mon = XGPokemonStats(index: i)
			if mon.levelUpMoves.contains(where: { (m) -> Bool in
				return m.move.index == search.index
			}) {
				print(mon.name)
			}
		}
		
		for i in 0 ..< kNumberOfBingoCards {
			let card = XGBattleBingoCard(index: i)
			for panel in card.panels {
				switch panel {
				case .pokemon(let mon):
					if mon.move.index == search.index {
						print("Battle Bingo Card ", i)
					}
				default:
					break
				}
			}
		}
	}
	
	class func printOccurencesOfPokemon(search: XGPokemon) {
		for deck in TrainerDecksArray {
			for trainer in deck.allTrainers {
				for mon in trainer.pokemon.map({ (p) -> XGTrainerPokemon in
					return p.data
				}) {
					if mon.species.index == search.index {
						print(trainer.name, trainer.locationString)
					}
				}
			}
		}
		
	}
	
	//MARK: - Utilities 2
	class func replaceString(_ a: String, withString b: String) {
		loadAllStrings()
		
		for st in allStrings {
			if st.string.contains(a) {
				st.duplicateWithString(st.string.replacingOccurrences(of: a, with: b, options: .literal)).replace()
			}
		}
		print("replaced \"\(a)\" with \"\(b)\"\n")
	}
	
	class func valueContext(_ value: Int) {
		print("Value:", value, "can have the following meanings:\n")
		if value <= kNumberOfMoves {
			print("Move: ",XGMoves.move(value).name.string,"\n")
		}
		if value <= kNumberOfPokemon {
			print("Pokemon: ",XGPokemon.pokemon(value).name.string,"\n")
		}
		
		if value <= kNumberOfAbilities {
			print("Ability: ",XGAbilities.ability(value).name.string,"\n")
		}
		
		if value <= kNumberOfItems {
			print("Item: ",XGItems.item(value).name.string,"\n")
		}
		
		// Key items
		if value > kNumberOfItems && value < 0x250 {
			print("Item: ",XGItems.item(value - (517 - 367)).name.string,"\n")
		}
		
		if value < kNumberOfTypes {
			print("Type: ",XGMoveTypes(rawValue: value)!,"\n")
		}
		
		for i in 1 ..< kNumberOfItems {
			let item = XGItems.item(i).data
			if item.holdItemID == value {
				print("Hold item id: ",item.name.string,"\n")
			}
			if item.inBattleUseID == value {
				print("In battle item id: ",item.name.string,"\n")
			}
		}
		
		if value > 0x1000 {
			loadAllStrings()
			print("String: ",getStringSafelyWithID(id: value),"\n")
		}
		
		
	}
	
	
	//MARK: - Pokemarts
	class func printPokeMarts() {
		let dat = XGFiles.pocket_menu.data
		
		let itemHexList = dat.getShortStreamFromOffset(0x300, length: 0x170)
		
		for j in 0..<itemHexList.count {
			let i = itemHexList[j]
			
			if i == 0x1FF {
				print("---------")
				continue
			}
			let item = XGItems.item(i)
			
			var tmName = ""
			for i in 1 ... kNumberOfTMs {
				if XGTMs.tm(i).item.index == item.index {
					tmName = "(" + XGTMs.tm(i).move.name.string + ")"
				}
			}
			
			print("\(0x300 + (j*2)):\t",item.index,item.name.string,tmName,"\n")
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
		
		print(string)
		
	}
	
	//MARK: - Documentation
	class func documentPokemonStats(title: String, forXG: Bool) {
		
		let fileName = "Pokemon Stats"
		print("documenting " + fileName + "...")
		
		var raw_array = [AnyObject]()
		var hum_array = [AnyObject]()
		
		var indices = [String]()
		var hexIndices = [String]()
		var names = [String]()
		var type1s = [String]()
		var type2s = [String]()
		var ability1s = [String]()
		var ability2s = [String]()
		var atks = [String]()
		var defs = [String]()
		var spas = [String]()
		var spds = [String]()
		var spes = [String]()
		var hps = [String]()
		var item1s = [String]()
		var item2s = [String]()
		var levelRates = [String]()
		var baseExps = [String]()
		var catchRates = [String]()
		var happinesses = [String]()
		var genderRatios = [String]()
		
		// vertical only
		var lumHeaders = [String]()
		var levelUpMoves = [ [String] ]()
		var TMHeaders = [String]()
		var TMs = [ [String] ]()
		var tutorHeaders = [String]()
		var tutors = [ [String] ]()
		
		for _ in 0 ..< kNumberOfLevelUpMoves {
			levelUpMoves.append([String]())
		}
		
		for _ in 0 ..< kNumberOfTMs {
			TMs.append([String]())
		}
		
		for _ in 0 ..< kNumberOfTutorMoves {
			tutors.append([String]())
		}
		
		for i in 0 ..< kNumberOfPokemon {
			
			let mon = XGPokemonStats(index: i)
			
			if !forXG || ((i < 252) || (i > 276) || (i == 264) || (i == 265)) {
				
				indices.append(i.string)
				hexIndices.append(i.hexString())
				
				let mon = XGPokemonStats(index: i)
				
				names.append(mon.name.string)
				type1s.append(mon.type1.name)
				type2s.append(mon.type2.name)
				ability1s.append(mon.ability1.name.string)
				ability2s.append(mon.ability2.name.string)
				atks.append(mon.attack.string)
				defs.append(mon.defense.string)
				spes.append(mon.speed.string)
				spas.append(mon.specialAttack.string)
				spds.append(mon.specialDefense.string)
				hps.append(mon.hp.string)
				item1s.append(mon.heldItem1.name.string)
				item2s.append(mon.heldItem2.name.string)
				levelRates.append(mon.levelUpRate.string)
				baseExps.append(mon.baseExp.string)
				catchRates.append(mon.catchRate.string)
				happinesses.append(mon.baseHappiness.string)
				genderRatios.append(mon.genderRatio.string)
				
				lumHeaders.append(mon.levelUpMoves.filter({ (move) -> Bool in
					return move.move.index > 0
				}).count.string)
				
				let lums = mon.levelUpMoves.map({ (lum) -> String in
					var level = lum.level.string
					if lum.level < 10  { level = " " + level}
					if lum.level < 100 { level = " " + level}
					return "\(level) - \(lum.move.name.string)"
				})
				
				for j in 0 ..< kNumberOfLevelUpMoves {
					levelUpMoves[j].append(lums[j])
				}
				
				TMHeaders.append(mon.learnableTMs.filter({ (tm) -> Bool in
					return tm
				}).count.string)
				
				for j in 0 ..< kNumberOfTMs {
					TMs[j].append(mon.learnableTMs[j].string)
				}
				
				tutorHeaders.append(mon.tutorMoves.filter({ (tm) -> Bool in
					return tm
				}).count.string)
				
				for j in 0 ..< kNumberOfTutorMoves {
					tutors[j].append(mon.tutorMoves[j].string)
				}
				
			}
			
			raw_array.append(mon.dictionaryRepresentation as AnyObject)
			hum_array.append(mon.readableDictionaryRepresentation as AnyObject)
		}
		print("saving " + fileName + "...")
		
		saveJSON(raw_array as AnyObject, toFile: XGFiles.nameAndFolder(fileName + " raw.json", .Reference))
		saveJSON(hum_array as AnyObject, toFile: XGFiles.nameAndFolder(fileName + " human readable.json", .Reference))
		
		print("saved " + fileName + "!\n")
		
		var dataRepresentation = [
			
			("Index dec", indices, true),
			("hex", hexIndices, true),
			("Name", names, false),
			("Type 1", type1s, false),
			("Type 2", type2s, false),
			("Ability 1", ability1s, false),
			("Ability 2", ability2s, false),
			("HP", hps,true),
			("Atk", atks, true),
			("Def", defs, true),
			("Sp.Atk", spas, true),
			("Sp.Def", spds, true),
			("Speed", spes, true),
			("Item 1", item1s, false),
			("Item 2", item2s, false),
			("Level Up Rate", levelRates, false),
			("Base Exp", baseExps, true),
			("Base Happiness", happinesses, true),
			("Catch Rate", catchRates, true),
			("Gender Ratio", genderRatios, false),
			]
		
		documentDataHorizontally(title: title, data: dataRepresentation)
		
		dataRepresentation.append(("Level Up Moves",lumHeaders,true))
		for i in 0 ..< kNumberOfLevelUpMoves {
			dataRepresentation.append(("Level",levelUpMoves[i],false))
		}
		
		dataRepresentation.append(("Tutor Moves",tutorHeaders,true))
		for i in 0 ..< kNumberOfTutorMoves {
			dataRepresentation.append((XGTMs.tutor(i + 1).move.name.string,tutors[i],false))
		}
		
		dataRepresentation.append(("TMs",tutorHeaders,true))
		for i in 0 ..< kNumberOfTMs {
			dataRepresentation.append((XGTMs.tm(i + 1).move.name.string,TMs[i],false))
		}
		
		documentDataVertically(title: title, data: dataRepresentation)
		
	}
	
	class func documentObtainablePokemonStats(title: String, forXG: Bool) {
		
		var indices = [String]()
		var hexIndices = [String]()
		var names = [String]()
		var type1s = [String]()
		var type2s = [String]()
		var ability1s = [String]()
		var ability2s = [String]()
		var atks = [String]()
		var defs = [String]()
		var spas = [String]()
		var spds = [String]()
		var spes = [String]()
		var hps = [String]()
		var item1s = [String]()
		var item2s = [String]()
		var levelRates = [String]()
		var baseExps = [String]()
		var catchRates = [String]()
		var happinesses = [String]()
		var genderRatios = [String]()
		
		// vertical only
		var lumHeaders = [String]()
		var levelUpMoves = [ [String] ]()
		var TMHeaders = [String]()
		var TMs = [ [String] ]()
		var tutorHeaders = [String]()
		var tutors = [ [String] ]()
		
		for _ in 0 ..< kNumberOfLevelUpMoves {
			levelUpMoves.append([String]())
		}
		
		for _ in 0 ..< kNumberOfTMs {
			TMs.append([String]())
		}
		
		for _ in 0 ..< kNumberOfTutorMoves {
			tutors.append([String]())
		}
		
		for poke in obtainablePokemon().sorted(by: { (p1, p2) -> Bool in
			return p1.index < p2.index
		}) {
			
			let mon = poke.stats
			
			
			indices.append(poke.index.string)
			hexIndices.append(poke.index.hexString())
			
			names.append(mon.name.string)
			type1s.append(mon.type1.name)
			type2s.append(mon.type2.name)
			ability1s.append(mon.ability1.name.string)
			ability2s.append(mon.ability2.name.string)
			atks.append(mon.attack.string)
			defs.append(mon.defense.string)
			spes.append(mon.speed.string)
			spas.append(mon.specialAttack.string)
			spds.append(mon.specialDefense.string)
			hps.append(mon.hp.string)
			item1s.append(mon.heldItem1.name.string)
			item2s.append(mon.heldItem2.name.string)
			levelRates.append(mon.levelUpRate.string)
			baseExps.append(mon.baseExp.string)
			catchRates.append(mon.catchRate.string)
			happinesses.append(mon.baseHappiness.string)
			genderRatios.append(mon.genderRatio.string)
			
			lumHeaders.append(mon.levelUpMoves.filter({ (move) -> Bool in
				return move.move.index > 0
			}).count.string)
			
			let lums = mon.levelUpMoves.map({ (lum) -> String in
				var level = lum.level.string
				if lum.level < 10  { level = " " + level}
				if lum.level < 100 { level = " " + level}
				return "\(level) - \(lum.move.name.string)"
			})
			
			for j in 0 ..< kNumberOfLevelUpMoves {
				levelUpMoves[j].append(lums[j])
			}
			
			TMHeaders.append(mon.learnableTMs.filter({ (tm) -> Bool in
				return tm
			}).count.string)
			
			for j in 0 ..< kNumberOfTMs {
				TMs[j].append(mon.learnableTMs[j].string)
			}
			
			tutorHeaders.append(mon.tutorMoves.filter({ (tm) -> Bool in
				return tm
			}).count.string)
			
			for j in 0 ..< kNumberOfTutorMoves {
				tutors[j].append(mon.tutorMoves[j].string)
			}
			
		}
		
		var dataRepresentation = [
			
			("Index dec", indices, true),
			("hex", hexIndices, true),
			("Name", names, false),
			("Type 1", type1s, false),
			("Type 2", type2s, false),
			("Ability 1", ability1s, false),
			("Ability 2", ability2s, false),
			("HP", hps,true),
			("Atk", atks, true),
			("Def", defs, true),
			("Sp.Atk", spas, true),
			("Sp.Def", spds, true),
			("Speed", spes, true),
			("Item 1", item1s, false),
			("Item 2", item2s, false),
			("Level Up Rate", levelRates, false),
			("Base Exp", baseExps, true),
			("Base Happiness", happinesses, true),
			("Catch Rate", catchRates, true),
			("Gender Ratio", genderRatios, false),
			
			]
		
		documentDataHorizontally(title: title, data: dataRepresentation)
		
		dataRepresentation.append(("Level Up Moves",lumHeaders,true))
		for i in 0 ..< kNumberOfLevelUpMoves {
			dataRepresentation.append(("Level",levelUpMoves[i],false))
		}
		
		dataRepresentation.append(("Tutor Moves",tutorHeaders,true))
		for i in 0 ..< kNumberOfTutorMoves {
			dataRepresentation.append((XGTMs.tutor(i + 1).move.name.string,tutors[i],false))
		}
		
		dataRepresentation.append(("TMs",tutorHeaders,true))
		for i in 0 ..< kNumberOfTMs {
			dataRepresentation.append((XGTMs.tm(i + 1).move.name.string,TMs[i],false))
		}
		
		documentDataVertically(title: title, data: dataRepresentation)
		
	}
	
	class func documentMoves(title: String, forXG: Bool) {
		
		let fileName = "Moves"
		print("documenting " + fileName + "...")
		
		var raw_array = [AnyObject]()
		var hum_array = [AnyObject]()
		
		for i in 0 ..< kNumberOfMoves {
			
			let entry = XGMove(index: i)
			
			raw_array.append(entry.dictionaryRepresentation as AnyObject)
			hum_array.append(entry.readableDictionaryRepresentation as AnyObject)
		}
		print("saving " + fileName + "...")
		
		saveJSON(raw_array as AnyObject, toFile: XGFiles.nameAndFolder(fileName + " raw.json", .Reference))
		saveJSON(hum_array as AnyObject, toFile: XGFiles.nameAndFolder(fileName + " human readable.json", .Reference))
		
		print("saved " + fileName + "!\n")
		
		var indices = [String]()
		var hexIndices = [String]()
		var names = [String]()
		var descriptions = [String]()
		var priorities = [String]()
		var basePowers = [String]()
		var effectAccuracies = [String]()
		var pps = [String]()
		var effectNumbers = [String]()
		var accuracies = [String]()
		var isShadows = [String]()
		var types = [String]()
		var categories = [String]()
		var targets = [String]()
		var HMFlags = [String]()
		var soundFlags = [String]()
		var mirrorFlags = [String]()
		var snatchFlags = [String]()
		var protectFlags = [String]()
		var contactFlags = [String]()
		var magicFlags = [String]()
		
		for i in 0 ..< kNumberOfMoves {
			
			let move = XGMove(index: i)
			
			indices.append(String(i))
			hexIndices.append(i.hex())
			names.append(move.nameString.string)
			descriptions.append(move.descriptionString.string)
			priorities.append(move.priority < 128 ? move.priority.string : (move.priority - 256).string)
			basePowers.append(move.basePower > 0 ? move.basePower.string : "-")
			effectAccuracies.append(move.effectAccuracy > 0 ? move.effectAccuracy.string + "%" : "-")
			pps.append(move.pp.string)
			effectNumbers.append(move.effect.string)
			accuracies.append(move.accuracy > 0 ? move.accuracy.string + "%" : "-")
			isShadows.append(move.isShadowMove.string)
			types.append(move.type.name)
			categories.append(forXG ? move.category.string : (move.isShadowMove ? move.category.string : move.type.category.string))
			targets.append(move.target.string)
			HMFlags.append(move.HMFlag.string)
			soundFlags.append(move.soundBasedFlag.string)
			mirrorFlags.append(move.mirrorMoveFlag.string)
			snatchFlags.append(move.snatchFlag.string)
			protectFlags.append(move.protectFlag.string)
			contactFlags.append(move.contactFlag.string)
			magicFlags.append(move.mirrorMoveFlag.string)
			
		}
		
		let dataRepresentation = [
			
			("Index dec", indices, true),
			("hex", hexIndices, true),
			("Name", names, false),
			("Type", types, false),
			("Category", categories, false),
			("Base Power", basePowers,true),
			("Accuracy", accuracies, true),
			("Priority", priorities, true),
			("PP", pps, true),
			("Targets", targets, false),
			("Effect", effectNumbers, true),
			("Effect Accuracy", effectAccuracies, true),
			("Makes Contact", contactFlags,false),
			("Shadow Move", isShadows,false),
			("Sound Based", soundFlags,false),
			("Blocked By Protect", protectFlags,false),
			(forXG ? "Magic Bounce" : "Magic Coat Reflects", magicFlags,false),
			(forXG ? "Bulletproof" : "Can Be Snatched", snatchFlags,false),
			(forXG ? "Mega Launcher" : "Mirror Move Copies", mirrorFlags,false),
			(forXG ? "Shadow Flag" : "HM Move", HMFlags,false),
			("Description", descriptions, false)
		]
		
		documentData(title: title, data: dataRepresentation)
		
	}
	
	class func documentBattleBingo() {
		
		let fileName = "Battle Bingo"
		print("documenting " + fileName + "...")
		
		var raw_array = [AnyObject]()
		var hum_array = [AnyObject]()
		
		for i in 0 ..< kNumberOfBingoCards {
			
			let entry = XGBattleBingoCard(index: i)
			
			raw_array.append(entry.dictionaryRepresentation as AnyObject)
			hum_array.append(entry.readableDictionaryRepresentation as AnyObject)
		}
		print("saving " + fileName + "...")
		
		saveJSON(raw_array as AnyObject, toFile: XGFiles.nameAndFolder(fileName + " raw.json", .Reference))
		saveJSON(hum_array as AnyObject, toFile: XGFiles.nameAndFolder(fileName + " human readable.json", .Reference))
		
		print("saved " + fileName + "!\n")
		
	}
	
	class func documentItems() {
		
		let fileName = "Items"
		print("documenting " + fileName + "...")
		
		var raw_array = [AnyObject]()
		var hum_array = [AnyObject]()
		
		for i in 0 ..< kNumberOfItems {
			
			let entry = XGItem(index: i)
			
			raw_array.append(entry.dictionaryRepresentation as AnyObject)
			hum_array.append(entry.readableDictionaryRepresentation as AnyObject)
		}
		print("saving " + fileName + "...")
		
		saveJSON(raw_array as AnyObject, toFile: XGFiles.nameAndFolder(fileName + " raw.json", .Reference))
		saveJSON(hum_array as AnyObject, toFile: XGFiles.nameAndFolder(fileName + " human readable.json", .Reference))
		
		print("saved " + fileName + "!\n")
		
	}
	
	class func documentTrainers(title: String, forXG: Bool) {
		
		let fileName = "Trainers"
		print("documenting " + fileName + "...")
		
		var raw_array = [AnyObject]()
		var hum_array = [AnyObject]()
		
		var decksString = ""
		
		for deck in TrainerDecksArray {
			
			decksString += deck.trainersString()
			
			raw_array.append(deck.dictionaryRepresentation as AnyObject)
			hum_array.append(deck.readableDictionaryRepresentation as AnyObject)
			
		}
		print("saving " + fileName + "...")
		
		saveJSON(raw_array as AnyObject, toFile: XGFiles.nameAndFolder(fileName + " raw.json", .Reference))
		saveJSON(hum_array as AnyObject, toFile: XGFiles.nameAndFolder(fileName + " human readable.json", .Reference))
		
		print("saved " + fileName + "!\n")
		
		saveString(decksString, toFile: .nameAndFolder(title + ".txt", .Reference))
	}
	
	class func documentShadowPokemon(title: String, forXG: Bool) {
		
		let fileName = "Shadow Pokemon"
		print("documenting " + fileName + "...")
		
		let raw_array = XGDecks.DeckDarkPokemon.dictionaryRepresentation
		let hum_array = XGDecks.DeckDarkPokemon.readableDictionaryRepresentation
		
		print("saving " + fileName + "...")
		
		saveJSON(raw_array as AnyObject, toFile: XGFiles.nameAndFolder(fileName + " raw.json", .Reference))
		saveJSON(hum_array as AnyObject, toFile: XGFiles.nameAndFolder(fileName + " human readable.json", .Reference))
		
		print("saved " + fileName + "!\n")
		
		var indices = [String]()
		var hexIndices = [String]()
		var names = [String]()
		var m1s = [String]()
		var m2s = [String]()
		var m3s = [String]()
		var m4s = [String]()
		var levels = [String]()
		var types = [String]()
		var counters = [String]()
		var aggros = [String]()
		
		let mons = XGDecks.DeckDarkPokemon.allActivePokemon
		
		for i in 0 ..< mons.count {
			
			let mon = mons[i]
			
			indices.append(String(i))
			hexIndices.append(i.hex())
			names.append(mon.species.name.string)
			m1s.append(mon.shadowMoves[0].index == 0 ? mon.moves[0].name.string : mon.shadowMoves[0].name.string + " (\(mon.moves[0].name.string))")
			m2s.append(mon.shadowMoves[1].index == 0 ? mon.moves[1].name.string : mon.shadowMoves[1].name.string + " (\(mon.moves[1].name.string))")
			m3s.append(mon.shadowMoves[2].index == 0 ? mon.moves[2].name.string : mon.shadowMoves[2].name.string + " (\(mon.moves[2].name.string))")
			m4s.append(mon.shadowMoves[3].index == 0 ? mon.moves[3].name.string : mon.shadowMoves[3].name.string + " (\(mon.moves[3].name.string))")
			levels.append(mon.level.string + "+")
			types.append(mon.species.type1.rawValue == mon.species.type2.rawValue ? mon.species.type1.name : mon.species.type1.name + "/" + mon.species.type2.name)
			counters.append(mon.shadowCounter.string)
			aggros.append(mon.shadowAggression.string)
			
		}
		
		let dataRepresentation = [
			
			("Index dec", indices, true),
			("hex", hexIndices, true),
			("Name", names, false),
			("Level", levels, true),
			("Type", types, false),
			("Aggression", aggros, true),
			("Purification Counter", counters, true),
			("Move 1", m1s, false),
			("Move 2", m2s, false),
			("Move 3", m3s, false),
			("Move 4", m4s, false),
			]
		
		documentData(title: title, data: dataRepresentation)
		
	}
	
	class func documentTMs() {
		
		let fileName = "TMs"
		print("documenting " + fileName + "...")
		
		var raw_array = [AnyObject]()
		var hum_array = [AnyObject]()
		
		for i in 1 ... kNumberOfTMs {
			
			let entry = XGTMs.tm(i)
			
			raw_array.append(entry.dictionaryRepresentation as AnyObject)
			hum_array.append(entry.readableDictionaryRepresentation as AnyObject)
		}
		print("saving " + fileName + "...")
		
		saveJSON(raw_array as AnyObject, toFile: XGFiles.nameAndFolder(fileName + " raw.json", .Reference))
		saveJSON(hum_array as AnyObject, toFile: XGFiles.nameAndFolder(fileName + " human readable.json", .Reference))
		
		print("saved " + fileName + "!\n")
		
	}
	
	class func documentTutorMoves() {
		
		let fileName = "Tutor Moves"
		print("documenting " + fileName + "...")
		
		var raw_array = [AnyObject]()
		var hum_array = [AnyObject]()
		
		for i in 1 ... kNumberOfTutorMoves {
			
			let entry = XGTMs.tutor(i)
			
			raw_array.append(entry.dictionaryRepresentation as AnyObject)
			hum_array.append(entry.readableDictionaryRepresentation as AnyObject)
		}
		print("saving " + fileName + "...")
		
		saveJSON(raw_array as AnyObject, toFile: XGFiles.nameAndFolder(fileName + " raw.json", .Reference))
		saveJSON(hum_array as AnyObject, toFile: XGFiles.nameAndFolder(fileName + " human readable.json", .Reference))
		
		print("saved " + fileName + "!\n")
		
	}
	
	class func documentTrainerClasses() {
		
		let fileName = "Trainer classes"
		print("documenting " + fileName + "...")
		
		var raw_array = [AnyObject]()
		var hum_array = [AnyObject]()
		
		for i in 0 ..< kNumberOfTrainerClasses {
			
			let entry = XGTrainerClasses(rawValue: i)!.data
			
			raw_array.append(entry.dictionaryRepresentation as AnyObject)
			hum_array.append(entry.readableDictionaryRepresentation as AnyObject)
		}
		print("saving " + fileName + "...")
		
		saveJSON(raw_array as AnyObject, toFile: XGFiles.nameAndFolder(fileName + " raw.json", .Reference))
		saveJSON(hum_array as AnyObject, toFile: XGFiles.nameAndFolder(fileName + " human readable.json", .Reference))
		
		print("saved " + fileName + "!\n")
		
	}
	
	class func documentStarterPokemon() {
		
		let fileName = "Starter Pokemon"
		print("documenting " + fileName + "...")
		
		var raw_array = [AnyObject]()
		var hum_array = [AnyObject]()
		
		raw_array.append(XGStarterPokemon().dictionaryRepresentation as AnyObject)
		hum_array.append(XGStarterPokemon().readableDictionaryRepresentation as AnyObject)
		
		for i in 0 ..< 2 {
			
			let entry = XGDemoStarterPokemon(index: i)
			
			raw_array.append(entry.dictionaryRepresentation as AnyObject)
			hum_array.append(entry.readableDictionaryRepresentation as AnyObject)
		}
		print("saving " + fileName + "...")
		
		saveJSON(raw_array as AnyObject, toFile: XGFiles.nameAndFolder(fileName + " raw.json", .Reference))
		saveJSON(hum_array as AnyObject, toFile: XGFiles.nameAndFolder(fileName + " human readable.json", .Reference))
		
		print("saved " + fileName + "!\n")
		
	}
	
	class func documentMtBattlePokemon() {
		
		let fileName = "Mt. Battle Prize Pokemon"
		print("documenting " + fileName + "...")
		
		var raw_array = [AnyObject]()
		var hum_array = [AnyObject]()
		
		for i in 0 ..< 3 {
			
			let entry = XGMtBattlePrizePokemon(index: i)
			
			raw_array.append(entry.dictionaryRepresentation as AnyObject)
			hum_array.append(entry.readableDictionaryRepresentation as AnyObject)
		}
		print("saving " + fileName + "...")
		
		saveJSON(raw_array as AnyObject, toFile: XGFiles.nameAndFolder(fileName + " raw.json", .Reference))
		saveJSON(hum_array as AnyObject, toFile: XGFiles.nameAndFolder(fileName + " human readable.json", .Reference))
		
		print("saved " + fileName + "!\n")
		
	}
	
	class func documentTrades() {
		
		let fileName = "In-Game Trades"
		print("documenting " + fileName + "...")
		
		var raw_array = [AnyObject]()
		var hum_array = [AnyObject]()
		
		for i in 0 ..< 4 {
			
			let entry = XGTradePokemon(index: i)
			
			raw_array.append(entry.dictionaryRepresentation as AnyObject)
			hum_array.append(entry.readableDictionaryRepresentation as AnyObject)
		}
		print("saving " + fileName + "...")
		
		saveJSON(raw_array as AnyObject, toFile: XGFiles.nameAndFolder(fileName + " raw.json", .Reference))
		saveJSON(hum_array as AnyObject, toFile: XGFiles.nameAndFolder(fileName + " human readable.json", .Reference))
		
		print("saved " + fileName + "!\n")
		
	}
	
	class func documentGiftShadowPokemon() {
		
		let fileName = "Shadow Pokemon Gift"
		print("documenting " + fileName + "...")
		
		var raw_array = [AnyObject]()
		var hum_array = [AnyObject]()
		
		let entry = XGTradeShadowPokemon()
		
		raw_array.append(entry.dictionaryRepresentation as AnyObject)
		hum_array.append(entry.readableDictionaryRepresentation as AnyObject)
		
		print("saving " + fileName + "...")
		
		saveJSON(raw_array as AnyObject, toFile: XGFiles.nameAndFolder(fileName + " raw.json", .Reference))
		saveJSON(hum_array as AnyObject, toFile: XGFiles.nameAndFolder(fileName + " human readable.json", .Reference))
		
		print("saved " + fileName + "!\n")
		
	}
	
	class func documentPokemarts() {
		
		let dat = XGFiles.pocket_menu.data
		let itemHexList = dat.getShortStreamFromOffset(0x300, length: 0x170)
		
		let fileName = "Pokemarts"
		print("documenting " + fileName + "...")
		
		var raw_array = [AnyObject]()
		var hum_array = [AnyObject]()
		
		for item in itemHexList {
			
			if item != 0x1FF {
				
				let entry = XGItems.item(item)
				
				raw_array.append(entry.dictionaryRepresentation as AnyObject)
				hum_array.append(entry.readableDictionaryRepresentation as AnyObject)
				
			} else {
				raw_array.append(["Value" : 0x1FF] as AnyObject)
				hum_array.append(["Value" : "End of Mart"] as AnyObject)
			}
			
		}
		print("saving " + fileName + "...")
		
		saveJSON(raw_array as AnyObject, toFile: XGFiles.nameAndFolder(fileName + " raw.json", .Reference))
		saveJSON(hum_array as AnyObject, toFile: XGFiles.nameAndFolder(fileName + " human readable.json", .Reference))
		
		print("saved " + fileName + "!\n")
		
	}
	
	class func documentPokespots() {
		
		let fileName = "Pokespots"
		print("documenting " + fileName + "...")
		
		var raw_array1 = [AnyObject]()
		var hum_array1 = [AnyObject]()
		
		for s in 0 ... 3 {
			
			var raw_array = [AnyObject]()
			var hum_array = [AnyObject]()
			
			let spot = XGPokeSpots(rawValue: s)!
			
			for p in 0 ..< spot.numberOfEntries() {
				let entry = XGPokeSpotPokemon(index: p, pokespot: spot)
				
				raw_array.append(entry.dictionaryRepresentation as AnyObject)
				hum_array.append(entry.readableDictionaryRepresentation as AnyObject)
			}
			raw_array1.append(raw_array as AnyObject)
			hum_array1.append([spot.string : hum_array] as AnyObject)
		}
		
		print("saving " + fileName + "...")
		
		saveJSON(raw_array1 as AnyObject, toFile: XGFiles.nameAndFolder(fileName + " raw.json", .Reference))
		saveJSON(hum_array1 as AnyObject, toFile: XGFiles.nameAndFolder(fileName + " human readable.json", .Reference))
		
		print("saved " + fileName + "!\n")
		
	}
	
	class func documentAbilities(title: String, forXG: Bool) {
		
		var indices = [String]()
		var hexIndices = [String]()
		var names = [String]()
		var descriptions = [String]()
		var pokes = [String]()
		
		var abs = [ [Int] ](repeating: [Int](), count: kNumberOfAbilities)
		
		for i in 0 ..< kNumberOfPokemon {
			if !forXG || ((i < 252) || (i > 276) || (i == 264) || (i == 265)) {
				let poke = XGPokemon.pokemon(i).stats
				if poke.ability1.index != 0 {
					abs[poke.ability1.index].append(poke.index)
				}
				if poke.ability2.index != 0 {
					abs[poke.ability2.index].append(poke.index)
				}
			}
		}
		
		for i in 0 ..< kNumberOfAbilities {
			
			let ability = XGAbilities.ability(i)
			let name = ability.name.string
			
			if (name == "-") || (name == "") {
				continue
			}
			
			indices.append(String(i))
			hexIndices.append(i.hex())
			names.append(name)
			descriptions.append(ability.adescription.string)
			
			var pokeList = ""
			for p in abs[ability.index] {
				let mon = XGPokemon.pokemon(p).name.string
				pokeList += (pokeList == "" ? mon : ", " + mon)
			}
			pokes.append(pokeList)
			
		}
		
		let dataRepresentation = [
			
			("Index dec", indices, true),
			("hex", hexIndices, true),
			("Name", names, false),
			("Description", descriptions, false),
			("Pokemon with ability", pokes, false)
		]
		
		documentData(title: title, data: dataRepresentation)
		
	}
	
	class func documentISO(forXG: Bool) {
		
		let prefix = forXG ? "XG " : "XD "
		
		documentTMs()
		documentItems()
		documentMoves(title: prefix + "Moves", forXG: forXG)
		documentTrades()
		documentTrainers(title: prefix + "Trainers", forXG: forXG)
		documentAbilities(title: prefix + "Abilities", forXG: forXG)
		documentPokemarts()
		documentPokespots()
		documentTutorMoves()
		documentBattleBingo()
		documentPokemonStats(title: prefix + "Stats", forXG: forXG)
		documentObtainablePokemonStats(title: prefix + "Obtainable Pokemon Stats", forXG: forXG)
		documentShadowPokemon(title: prefix + "Shadow Pokemon", forXG: forXG)
		documentStarterPokemon()
		documentTrainerClasses()
		documentMtBattlePokemon()
		documentGiftShadowPokemon()
		saveObtainablePokemonByLocation()
	}
	
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
	
	//MARK: - Model Utilities
	class func convertFromPKXToOverWorldModel(pkx: XGMutableData) -> XGMutableData {
		
		//	let rawData = pkx.charStream
		let modelHeader = 0xE60
		let modelStart = 0xE80
		var modelEndPaddingCounter = 0
		
		// get number of padding 0s at end
		var index = pkx.length - 4
		var current = pkx.get4BytesAtOffset(index)
		
		while current == 0 {
			modelEndPaddingCounter += 4
			index -= 4
			current = pkx.get4BytesAtOffset(index)
		}
		modelEndPaddingCounter = pkx.length - (index + 4)
		
		let skipStart = Int(pkx.get4BytesAtOffset(pkx.length - modelEndPaddingCounter - 0x1C)) + modelStart
		let skipEnd = Int(pkx.get4BytesAtOffset(modelHeader + 4)) + modelStart
		
		let part2 = pkx.getCharStreamFromOffset(modelStart, length: skipStart - modelStart)
		let part3 = pkx.getCharStreamFromOffset(skipEnd, length: pkx.length - modelEndPaddingCounter - 0x1C - skipEnd)
		let part4 : [UInt8] = [0x73, 0x63, 0x65, 0x6E, 0x65, 0x5F, 0x64, 0x61, 0x74, 0x61, 0x00]
		var rawBytes = part2 + part3 + part4
		
		let newLength = rawBytes.count + 0x20
		let header4 = [newLength, skipStart - modelStart, Int(pkx.get4BytesAtOffset(modelHeader + 8)), 0x01]
		var header = [UInt8]()
		for h in header4 {
			header.append(UInt8(h >> 24))
			header.append(UInt8((h & 0xFF0000) >> 16))
			header.append(UInt8((h & 0xFF00) >> 8))
			header.append(UInt8(h % 0x100))
		}
		for _ in 0 ..< 0x10 {
			header.append(0)
		}
		
		rawBytes = header + rawBytes
		
		return XGMutableData(byteStream: rawBytes, file: .nameAndFolder("", .Documents))
	}
	
	
	//MARK: - pokespot
	class func relocatePokespots(startOffset: UInt32, numberOfEntries n: UInt32) {
		
		var spotStart = startOffset
		let entrySize = UInt32(kSizeOfPokeSpotData)
		
		//rock
		XGPokeSpots.rock.relocatePokespotData(toOffset: spotStart)
		XGPokeSpots.rock.setEntries(entries: n)
		spotStart += n * entrySize
		
		//oasis
		XGPokeSpots.oasis.relocatePokespotData(toOffset: spotStart)
		XGPokeSpots.oasis.setEntries(entries: n)
		spotStart += n * entrySize
		
		//cave
		XGPokeSpots.cave.relocatePokespotData(toOffset: spotStart)
		XGPokeSpots.cave.setEntries(entries: n)
		spotStart += n * entrySize
		
		//bonsly munchlax
		XGPokeSpots.all.relocatePokespotData(toOffset: spotStart)
		
		
		let dol = XGFiles.dol.data
		let offset = 0x1faf50 - kDOLtoRAMOffsetDifference
		dol.replace4BytesAtOffset(offset, withBytes: 0x280A0000 + n)
		dol.save()
		
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


XGISO().importFiles([.dol])
*/

