//
//  XDExtensions.swift
//  Colosseum Tool
//
//  Created by The Steez on 04/06/2018.
//

import Foundation

enum XGRegions : UInt32 {
	
	case US = 0x47585845 // GXXE
	case EU = 0x47585850 // GXXP
	case JP = 0x4758584A // GXXJ
	
	var index : Int {
		switch self {
		// arbitrary values
		case .US: return 0
		case .EU: return 1
		case .JP: return 2
		}
	}
	
}

class XGMapRel : XGRelocationTable {
	
	@objc var characters = [XGCharacter]()
	@objc var interactionLocations = [XGInteractionLocation]()
	@objc var treasure = [XGTreasure]()
	
	@objc var roomID = 0
	var isValid = true
	
	@objc var script : XGScript? {
		let scriptFile = XGFiles.scd(file.fileName.removeFileExtensions())
		return scriptFile.exists ? scriptFile.scriptData : nil
	}
	
	override convenience init(file: XGFiles) {
		self.init(file: file, checkScript: true)
	}
	
	init(file: XGFiles, checkScript: Bool) {
		super.init(file: file)
		
		if self.numberOfPointers < kNumberMapPointers {
			if verbose {
				printg("Map: \(file.path) has the incorrect number of map pointers. Possibly a colosseum file.")
			}
			self.isValid = false
			return
		}
		
		let firstIP = self.getPointer(index: MapRelIndexes.FirstInteractionLocation.rawValue)
		let numberOfIPs = self.getValueAtPointer(index: MapRelIndexes.NumberOfInteractionLocations.rawValue)
		
		for i in 0 ..< numberOfIPs {
			let startOffset = firstIP + (i * kSizeOfInteractionLocation)
			if startOffset + 16 < file.fileSize {
				let ip = XGInteractionLocation(file: file, index: i, startOffset: startOffset)
				interactionLocations.append(ip)
			}
		}
		
		if let room = XGRoom.roomWithName(file.fileName.removeFileExtensions()) {
			self.roomID = room.roomID
		}
		
		for i in 0 ..< CommonIndexes.NumberTreasureBoxes.value {
			let treasure = XGTreasure(index: i)
			if treasure.roomID == self.roomID {
				self.treasure.append(treasure)
			}
		}
		
		let firstCharacter = self.getPointer(index: MapRelIndexes.FirstCharacter.rawValue)
		let numberOfCharacters = self.getValueAtPointer(index: MapRelIndexes.NumberOfCharacters.rawValue)
		
		let script = checkScript ? self.script : nil
		for i in 0 ..< numberOfCharacters {
			let startOffset = firstCharacter + (i * kSizeOfCharacter)
			if startOffset + kSizeOfCharacter < file.fileSize {
				let character = XGCharacter(file: file, index: i, startOffset: startOffset)
				
				if character.isValid {
					if character.hasScript {
						if script != nil {
							if character.scriptIndex < script!.ftbl.count {
								character.scriptName = script!.ftbl[character.scriptIndex].name
							}
						}
					}
				} else {
					self.isValid = false
				}
				
				characters.append(character)
			}
		}
	}
	
}

extension XGISO {
	
	@objc var fsysList : [String] {
		return [
			"common.fsys",
			"common_dvdeth.fsys",
			"deck_archive.fsys",
			"field_common.fsys",
			"fight_common.fsys",
			"people_archive.fsys"
		]
	}
	
	@objc var menuFsysList : [String] {
		// also any file with "menu" in the name
		return [
			"battle_disk.fsys",
			"evolution.fsys",
			"mewwaza.fsys",
			"title.fsys",
			"worldmap.fsys"
		]
	}
	
	
	@objc func extractDecks() {
		let deckData = XGFiles.fsys("deck_archive").fsysData
		let decksOrdered : [XGDecks] = [.DeckBingo, .DeckColosseum, .DeckDarkPokemon, .DeckHundred, .DeckImasugu, .DeckSample, .DeckStory, .DeckVirtual]
		
		for i in 0 ..< decksOrdered.count {
			let deck = decksOrdered[i]
			if !deck.file.exists {
				if verbose {
					printg("Extracting deck: \(deck.file.fileName)")
				}
				if let data = deckData.decompressedDataForFileWithIndex(index: i * 2) {
					data.file = deck.file
					data.save()
				} else {
					printg("Couldn't extract deck \(deck.file.fileName), doesn't exist in deck archive")
				}
			}
		}
		
	}
	
	
	@objc func extractSpecificStringTables() {
		stringsLoaded = false
		
		let fightFile = XGFiles.msg("fight")
		if !fightFile.exists {
			let fight = XGFiles.fsys("fight_common").fsysData.decompressedDataForFileWithFiletype(type: .msg)!
			fight.file = fightFile
			fight.save()
		}
		
		let pocket_menu = XGFiles.msg("pocket_menu")
		let nameentrymenu = XGFiles.msg("name_entry_menu")
		let system_tool = XGFiles.msg("system_tool")
		let m3shrine1frl = XGFiles.msg("M3_shrine_1F_rl")
		let relivehall_menu = XGFiles.msg("relivehall_menu")
		let pda_menu = XGFiles.msg("pda_menu")
		let p_exchange = XGFiles.msg("p_exchange")
		let world_map = XGFiles.msg("world_map")
		
		if !pocket_menu.exists {
			let pm = XGFiles.fsys("pocket_menu").fsysData.decompressedDataForFileWithFiletype(type: .msg)!
			pm.file = pocket_menu
			pm.save()
		}
		
		if !nameentrymenu.exists {
			let nem = XGFiles.fsys("pcbox_name_entry_menu").fsysData.decompressedDataForFileWithFiletype(type: .msg)!
			nem.file = nameentrymenu
			nem.save()
		}
		
		if !system_tool.exists {
			let st = XGFiles.fsys("pcbox_menu").fsysData.decompressedDataForFileWithFiletype(type: .msg)!
			st.file = system_tool
			st.save()
		}
		
		if !m3shrine1frl.exists {
			let m3rl = XGFiles.fsys("hologram_menu").fsysData.decompressedDataForFileWithFiletype(type: .msg)!
			m3rl.file = m3shrine1frl
			m3rl.save()
		}
		
		if !relivehall_menu.exists {
			let rh = XGFiles.fsys("relivehall_menu").fsysData.decompressedDataForFileWithFiletype(type: .msg)!
			rh.file = relivehall_menu
			rh.save()
		}
		
		if !pda_menu.exists {
			let pda = XGFiles.fsys("pda_menu").fsysData.decompressedDataForFileWithFiletype(type: .msg)!
			pda.file = pda_menu
			pda.save()
		}
		
		if !p_exchange.exists {
			let pex = XGFiles.fsys("pokemonchange_menu").fsysData.decompressedDataForFileWithFiletype(type: .msg)!
			pex.file = p_exchange
			pex.save()
		}
		
		if !world_map.exists {
			let wm = XGFiles.fsys("worldmap").fsysData.decompressedDataForFileWithFiletype(type: .msg)!
			wm.file = world_map
			wm.save()
		}
	}
}

extension XGUtility {
	
	class func importFsys() {
		
		printg("importing files to .fsys archives")
		
		if !DeckDataEmptyLZSS.file.exists {
			DeckDataEmptyLZSS.save()
		}
		ISO.extractFSYS()
		
		let common = XGFiles.fsys("common").fsysData
		if XGFiles.common_rel.exists {
			common.shiftAndReplaceFileWithIndexEfficiently(0, withFile: XGFiles.common_rel.compress(), save: false)
		}
		common.shiftAndReplaceFileWithIndexEfficiently(2, withFile: DeckDataEmptyLZSS.file, save: false) //EU file
		if XGDecks.DeckDarkPokemon.file.exists {
			common.shiftAndReplaceFileWithIndexEfficiently(4, withFile: XGFiles.deck(.DeckDarkPokemon).compress(), save: false)
		}
		common.save()
		
		if XGFiles.tableres2.exists {
			XGFiles.fsys("common_dvdeth").fsysData.shiftAndReplaceFileWithIndexEfficiently(0, withFile: XGFiles.tableres2.compress(), save: true)
		}
		
		let deckArchive = XGFiles.fsys("deck_archive").fsysData
		
		for i in 0 ..< deckArchive.numberOfEntries {
			// remove eu files to make space for increased file sizes assuming they're all the odd ones
			if i % 2 == 1 {
				deckArchive.shiftAndReplaceFileWithIndexEfficiently(i, withFile: DeckDataEmptyLZSS.file, save: false)
			}
		}
		
		let decksOrdered : [XGDecks] = [.DeckBingo, .DeckColosseum, .DeckDarkPokemon, .DeckHundred, .DeckImasugu, .DeckSample, .DeckStory, .DeckVirtual]
		for i in 0 ..< decksOrdered.count {
			let deck = decksOrdered[i]
			if deck.file.exists {
				deckArchive.shiftAndReplaceFileWithIndexEfficiently(i * 2, withFile: deck.file.compress(), save: false)
			}
		}
		deckArchive.save()
		
		if XGFiles.msg("fight").exists {
			XGFiles.fsys("fight_common").fsysData.shiftAndReplaceFileWithType(.msg, withFile: XGFiles.msg("fight").compress(), save: true)
		}
		
		if !XGFiles.fsys("pocket_menu").exists {
			ISO.extractMenuFSYS()
		}
		if XGFiles.pocket_menu.exists {
			XGFiles.fsys("pocket_menu").fsysData.shiftAndReplaceFileWithType(.rel, withFile: XGFiles.pocket_menu.compress(), save: true)
		}

	}
	
	class func updateHealingItems() {
		let kBattleItemDataStartOffset = 0x402570
		let kSizeOfBattleItemEntry = 0x10
		let kBattleItemHPToRestoreOffset = 0xA
		// N.B. A lot of these values are bit masks and so a single item can have many of these effects at once
		// byte 0x3 status to heal mask (0x20 sleep, 0x10 poison, 0x8 burn, 0x4 freeze, 0x2 paralysis, 0x1 confusion, 0x3F all)
		// 0x40 level up, 0x80 guard spec
		// byte 0x4 0x80 increase max pp, 0x40 revive, 0x20 restore pp, 0x10 evolution stone, 0x8 max out pp
		// byte 0xb pp to restore (0x7f for all pp)
		// bytes 5-7 friendship change
		// byte 0xa hp to restore (0xfd hp gained by level up, 0xfe for half, 0xff for full)
		// byte 0x8 hp evs
		// byte 0x9 attack evs
		// byte 0xc defense evs
		// byte 0xd speed evs
		// byte 0xe spdef evs
		// byte 0xf spatk evs
		// byte 0x0 0x20 dire hit, 0x2 x attack
		// byte 0x1 0x10 x defend, 0x1 x speed
		// byte 0x2 0x10 x accuracy, 0x1 x special
		
		if let dol = XGFiles.dol.data {
			
			let healingItems = [13,19,20,21,22,26,27,28,29,30,31,32,33,44,45,139,142]
			
			for i in healingItems {
				
				let item = XGItem(index: i)
				if i >= 30 && i <= 33 {
					if item.parameter == 0 {
						// for some reason these are 0 by default in xd
						// the following code uses it so let's set it manually
						item.parameter = [50, 200, 0, 255][i - 30]
						item.save()
					}
				}
				
				
				let id = item.inBattleUseID
				if id > 0 {
					let offset = kBattleItemDataStartOffset + (kSizeOfBattleItemEntry * id)
					dol.replaceByteAtOffset(offset + kBattleItemHPToRestoreOffset, withByte: item.parameter)
				}
			}
			
			dol.save()
		}
		
	}
	
	class func updateFunctionalItems() {
		// Maybe I should stop being so pedantic and use shorter variable names...
		let kFunctionalItemDataStartOffset = 0x402570
		let kSizeOfFunctionalItemEntry = 0x10
		let kFunctionalItemFirstFriendshipOffset = 0x5
		if let dol = XGFiles.dol.data {
			for i in allItemsArray() {
				let item = i.data
				let index = item.inBattleUseID
				if index > 0 && index <= 63 {
					let start = kFunctionalItemDataStartOffset + (index * kSizeOfFunctionalItemEntry) + kFunctionalItemFirstFriendshipOffset
					for i in 0 ... 2 {
						dol.replaceByteAtOffset(start + i, withByte: item.friendshipEffects[i])
					}
				}
			}
			dol.save()
		}
	}
	
	class func updateValidItems() {
		let itemListStart = CommonIndexes.ValidItems.startOffset
		let rel = XGFiles.common_rel.data!
		
		printg("Updating items list...")
		
		for i in 1 ..< CommonIndexes.NumberOfItems.value {
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
		let rel = XGFiles.common_rel.data!
		for i in 0 ..< kNumberOfMoves {
			
			let m = XGMoves.move(i).data
			if m.isShadowMove {
				rel.replaceWordAtOffset(m.startOffset + 0x14, withBytes: 0x00023101)
			}
			
		}
		rel.save()
	}
	
	class func prepareShinyness() {
		if isShinyAvailable {
			for mon in XGDecks.DeckStory.allActivePokemon {
				if mon.isShadowPokemon {
					mon.shinyness = .random
				} else {
					mon.shinyness = mon.shinyness == .always ? .always : .never
				}
				mon.save()
			}
		}
	}
	
	class func prepareForQuickCompilation() {
		updateValidItems()
		updateHealingItems()
		updateFunctionalItems()
		updateTutorMoves()
		updatePokeSpots()
		updateShadowMonitor()
		importSpecificStringTables()
	}
	
	class func prepareForCompilation() {
		fixUpTrainerPokemon()
		prepareShinyness()
		updateShadowMoves()
		updateValidItems()
		updateHealingItems()
		updateFunctionalItems()
		updateTutorMoves()
		updatePokeSpots()
		updateShadowMonitor()
		importSpecificStringTables()
	}
	
	class func importSpecificStringTables() {
		printg("importing menu string tables")
		
		let pocket_menu = XGFiles.msg("pocket_menu")
		let d4tower1f3 = XGFiles.msg("D4_tower_1F_3")
		let m5labo2f = XGFiles.msg("M5_labo_2F")
		let d4tower1f2 = XGFiles.msg("D4_tower_1F_2")
		let nameentrymenu = XGFiles.msg("name_entry_menu")
		let system_tool = XGFiles.msg("system_tool")
		let m3shrine1frl = XGFiles.msg("M3_shrine_1F_rl")
		let relivehall_menu = XGFiles.msg("relivehall_menu")
		let pda_menu = XGFiles.msg("pda_menu")
		let d2pc1f = XGFiles.msg("D2_pc_1F")
		let d7out = XGFiles.msg("D7_out")
		let p_exchange = XGFiles.msg("p_exchange")
		let world_map = XGFiles.msg("world_map")
		let fight = XGFiles.msg("fight")
		
		let msgs = [pocket_menu, d4tower1f2, d4tower1f3, m5labo2f, nameentrymenu, system_tool, m3shrine1frl, relivehall_menu, pda_menu, d2pc1f, d7out, p_exchange, world_map, fight]
		for file in XGFolders.MenuFSYS.files + [.fsys("fight_common"), .fsys("field_common")] where file.fileType == .fsys {
			let fsys = file.fsysData
			
			for msg in msgs {
				if msg.exists {
					for i in 0 ..< fsys.numberOfEntries {
						if fsys.fileTypeForFile(index: i) == .msg && fsys.fileNameForFileWithIndex(index: i).removeFileExtensions() == msg.fileName.removeFileExtensions() {
							fsys.shiftAndReplaceFileWithIndexEfficiently(i, withFile: msg.compress(), save: false)
						}
					}
				}
			}
			fsys.save()
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
		let dol = XGFiles.dol.data!
		dol.replaceBytesFromOffset(offset, withByteStream: newName.map({ (c) -> Int in
			let charScalar = String(c).unicodeScalars
			let charValue  = Int(charScalar[charScalar.startIndex].value)
			return charValue
		}))
		dol.save()
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
			
			for p in 0 ..< spot.numberOfEntries {
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
			
			for p in 0 ..< spot.numberOfEntries {
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
	
	class func saveObtainablePokemonByLocation(prefix: String) {
		
		func tabsForName(_ name: String) -> String {
			return name.length >= 9 ? "\t" : (name.length >= 3 ? "\t\t" : "\t\t\t")
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
			var range = str.startIndex ..< str.index(str.startIndex, offsetBy: 1)
			let sub1 = str.substring(from: 0, to: 1)
			
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
				range = str.startIndex ..< str.index(str.startIndex, offsetBy: 2)
				let sub = str.substring(from: 0, to: 2)
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
							if i > name.length {
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
		for i in 0 ..< XGPokeSpots.rock.numberOfEntries {
			let poke = XGPokeSpotPokemon(index: i, pokespot: .rock)
			string += "Wild " + poke.pokemon.name.string + "  \t\(tabsForName(poke.pokemon.name.string))Lv. " + "\(poke.minLevel) - \(poke.maxLevel)" + "\n"
		}
		
		string += "----------------------------------\n"
		string += "Oasis Pokespot:\n"
		for i in 0 ..< XGPokeSpots.oasis.numberOfEntries {
			let poke = XGPokeSpotPokemon(index: i, pokespot: .oasis)
			string += "Wild " + poke.pokemon.name.string + "  \t\(tabsForName(poke.pokemon.name.string))Lv. " + "\(poke.minLevel) - \(poke.maxLevel)" + "\n"
		}
		
		string += "----------------------------------\n"
		string += "Cave Pokespot:\n"
		for i in 0 ..< XGPokeSpots.cave.numberOfEntries {
			let poke = XGPokeSpotPokemon(index: i, pokespot: .cave)
			string += "Wild " + poke.pokemon.name.string + "  \t\(tabsForName(poke.pokemon.name.string))Lv. " + "\(poke.minLevel) - \(poke.maxLevel)" + "\n"
		}
		
		if XGPokeSpots.all.numberOfEntries > 2 {
			string += "\n************************************************************************************\nBoss Encounters\n\n"
			for i in 2 ..< XGPokeSpots.all.numberOfEntries {
				let poke = XGPokeSpotPokemon(index: i, pokespot: .all)
				if poke.pokemon.index > 0 {
					string += "Wild " + poke.pokemon.name.string + "  \t\(tabsForName(poke.pokemon.name.string))Lv. " + "\(poke.minLevel) - \(poke.maxLevel)" + "\n"
				}
			}
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
		
		saveString(string, toFile: XGFiles.nameAndFolder(prefix + "Obtainable Pokemon List.txt", XGFolders.Reference))
	}
	
	
	class func updateShadowMonitor() {
		
		printg("updating shadow monitor")
		
		let start = 0x4014EA
		
		var indices = [Int]()
		let deck = XGDecks.DeckDarkPokemon
		var pokes = [XGDeckPokemon]()
		
		for i in 1..<deck.DDPKEntries {
			pokes.append(.ddpk(i))
		}
		
		for poke in pokes {
			
			if poke.pokemon.index != 0 {
				indices.append(poke.pokemon.index)
			} else {
				indices.append(0x118)
			}
		}
		
		let dol = XGFiles.dol.data!
		
		dol.replaceBytesFromOffset(start, withShortStream: indices)
		
		dol.save()
		
	}
	
	
	class func updateTutorMoves() {
		// Need to update class function which determines which pokemon stats move tutor move index
		// Corresponds to each tutor move. This class function will set it so that it is in the same
		// Order as the tutor moves indexes.
		
		printg("updating tutor moves")
		
		let dol = XGFiles.dol.data!
		
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
			
			dol.replaceWordAtOffset(offset + 6, withBytes: kNopInstruction)
			
			dol.replace2BytesAtOffset(offset, withBytes: tmove.index)
		}
		
		dol.save()
	}
	
	
	
	class func updatePokeSpots() {
		// Need to change array values at bottom of m2 guild script.
		// You need the national dex index of the pokemon you trade.
		// Then replace the values with 1000 + the national dex index.
		// I.E. the pokemon's name ID.
		// Wooper is 1194 0x4aa, trapinch is 1328 0x530, surskit is 1283 0x503.
		// Also need to get national ids for the pokemon you get from trade.
		
		// Now that the xds script editor is done it's not very reliable to hardcode the offsets
		// Instead the xds scripts should be edited and compiled.
		// However for those making simple modifications or using the randomiser
		// it may still be preferrable to hard code if the script file
		// won't be tampered with.
		// I'm using the file size as the benchmark as it's really unlikely to remain the same after an xds compilation
		// since the compiler strips all debug data. If it happens to be the same length
		// after editing then oh well, unlucky mate :-p
		
		printg("updating pokespots")
		
		let scriptFile = XGFiles.scd("M2_guild_1F_2.scd")
		if scriptFile.exists {
			if scriptFile.fileSize == 0x1770 {
				
				let script = scriptFile.data!
				
				let trapinches = [0x0B4A,0x0D1E]
				let surskits = [0x0B9A,0x0D62]
				let woopers = [0x0BEA,0x0DA6]
				
				let trapinch = XGPokeSpotPokemon(index: 2, pokespot: .rock).pokemon.nameID
				let surskit = XGPokeSpotPokemon(index: 2, pokespot: .oasis).pokemon.nameID
				let wooper = XGPokeSpotPokemon(index: 2, pokespot: .cave).pokemon.nameID
				
				for offset in trapinches {
					script.replace2BytesAtOffset(offset, withBytes: trapinch)
				}
				
				for offset in surskits {
					script.replace2BytesAtOffset(offset, withBytes: surskit)
				}
				
				for offset in woopers {
					script.replace2BytesAtOffset(offset, withBytes: wooper)
				}
				
				script.replace2BytesAtOffset(0x0D3A, withBytes: trapinch)
				script.replace2BytesAtOffset(0x1756, withBytes: trapinch)
				
				
				script.replace2BytesAtOffset(0x0D7E, withBytes: surskit)
				script.replace2BytesAtOffset(0x175E, withBytes: surskit)
				
				
				script.replace2BytesAtOffset(0x0DC2, withBytes: wooper)
				script.replace2BytesAtOffset(0x1766, withBytes: wooper)
				
				
				let meditite = XGTradePokemon(index: 1).species.nameID
				let shuckle = XGTradePokemon(index: 2).species.nameID
				let larvitar = XGTradePokemon(index: 3).species.nameID
				
				script.replace2BytesAtOffset(0x0D32, withBytes: meditite)
				script.replace2BytesAtOffset(0x0D76, withBytes: shuckle)
				script.replace2BytesAtOffset(0x0DBA, withBytes: larvitar)
				
				
				script.save()
			}
		}
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
						printg(trainer.index,trainer.name, trainer.locationString)
					} else if mon.shadowMoves.contains(where: { (m) -> Bool in
						return m.index == search.index
					}) {
						printg(trainer.index,trainer.name, trainer.locationString)
					}
				}
			}
		}
		
		for i in 1 ..< kNumberOfPokemon {
			let mon = XGPokemonStats(index: i)
			if mon.levelUpMoves.contains(where: { (m) -> Bool in
				return m.move.index == search.index
			}) {
				printg(mon.name)
			}
		}
		
		for i in 0 ..< kNumberOfBingoCards {
			let card = XGBattleBingoCard(index: i)
			for panel in card.panels {
				switch panel {
				case .pokemon(let mon):
					if mon.move.index == search.index {
						printg("Battle Bingo Card ", i)
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
						printg(trainer.name, trainer.locationString)
					}
				}
			}
		}
		
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
	
	
	class func documentBattleBingo() {
		
		let fileName = "Battle Bingo"
		printg("documenting " + fileName + "...")
		
		var raw_array = [AnyObject]()
		var hum_array = [AnyObject]()
		
		for i in 0 ..< kNumberOfBingoCards {
			
			let entry = XGBattleBingoCard(index: i)
			
			raw_array.append(entry.dictionaryRepresentation as AnyObject)
			hum_array.append(entry.readableDictionaryRepresentation as AnyObject)
		}
		printg("saving " + fileName + "...")
		
		saveJSON(raw_array as AnyObject, toFile: XGFiles.nameAndFolder(fileName + " raw.json", .Reference))
		saveJSON(hum_array as AnyObject, toFile: XGFiles.nameAndFolder(fileName + " human readable.json", .Reference))
		
		printg("saved " + fileName + "!\n")
		
	}
	
	class func documentItems() {
		
		let fileName = "Items"
		printg("documenting " + fileName + "...")
		
		var raw_array = [AnyObject]()
		var hum_array = [AnyObject]()
		
		for i in 0 ..< CommonIndexes.NumberOfItems.value {
			
			let entry = XGItem(index: i)
			
			raw_array.append(entry.dictionaryRepresentation as AnyObject)
			hum_array.append(entry.readableDictionaryRepresentation as AnyObject)
		}
		printg("saving " + fileName + "...")
		
		saveJSON(raw_array as AnyObject, toFile: XGFiles.nameAndFolder(fileName + " raw.json", .Reference))
		saveJSON(hum_array as AnyObject, toFile: XGFiles.nameAndFolder(fileName + " human readable.json", .Reference))
		
		printg("saved " + fileName + "!\n")
		
	}
	
	
	class func documentStarterPokemon() {
		
		let fileName = "Starter Pokemon"
		printg("documenting " + fileName + "...")
		
		var raw_array = [AnyObject]()
		var hum_array = [AnyObject]()
		
		raw_array.append(XGStarterPokemon().dictionaryRepresentation as AnyObject)
		hum_array.append(XGStarterPokemon().readableDictionaryRepresentation as AnyObject)
		
		for i in 0 ..< 2 {
			
			let entry = XGDemoStarterPokemon(index: i)
			
			raw_array.append(entry.dictionaryRepresentation as AnyObject)
			hum_array.append(entry.readableDictionaryRepresentation as AnyObject)
		}
		printg("saving " + fileName + "...")
		
		saveJSON(raw_array as AnyObject, toFile: XGFiles.nameAndFolder(fileName + " raw.json", .Reference))
		saveJSON(hum_array as AnyObject, toFile: XGFiles.nameAndFolder(fileName + " human readable.json", .Reference))
		
		printg("saved " + fileName + "!\n")
		
	}
	
	
	class func documentPokespots() {
		
		let fileName = "Pokespots"
		printg("documenting " + fileName + "...")
		
		var raw_array1 = [AnyObject]()
		var hum_array1 = [AnyObject]()
		
		for s in 0 ... 3 {
			
			var raw_array = [AnyObject]()
			var hum_array = [AnyObject]()
			
			let spot = XGPokeSpots(rawValue: s)!
			
			for p in 0 ..< spot.numberOfEntries {
				let entry = XGPokeSpotPokemon(index: p, pokespot: spot)
				
				raw_array.append(entry.dictionaryRepresentation as AnyObject)
				hum_array.append(entry.readableDictionaryRepresentation as AnyObject)
			}
			raw_array1.append(raw_array as AnyObject)
			hum_array1.append([spot.string : hum_array] as AnyObject)
		}
		
		printg("saving " + fileName + "...")
		
		saveJSON(raw_array1 as AnyObject, toFile: XGFiles.nameAndFolder(fileName + " raw.json", .Reference))
		saveJSON(hum_array1 as AnyObject, toFile: XGFiles.nameAndFolder(fileName + " human readable.json", .Reference))
		
		printg("saved " + fileName + "!\n")
		
	}
	
	class func documentMacrosXDS() {
		
		printg("documenting script macros...")
		printg("This may take a while :-)")
		
		var text = ""
		
		func addMacro(value: Int, type: XDSMacroTypes) {
			let constant = XDSConstant.integer(value)
			text += "define \(XDSExpr.stringFromMacroImmediate(c: constant, t: type)) \(constant.rawValueString)\n"
		}
		
		for i in 0 ..< CommonIndexes.NumberOfPokemon.value {
			if i == 0 || XGPokemon.pokemon(i).nameID > 0 {
				addMacro(value: i, type: .pokemon)
			}
		}
		for i in 0 ..< CommonIndexes.NumberOfMoves.value {
			if i == 0 || XGMoves.move(i).nameID > 0 {
				addMacro(value: i, type: .move)
			}
		}
		
		for i in 0 ..< CommonIndexes.TotalNumberOfItems.value {
			if i == 0 || (XGItems.item(i).scriptIndex == i && XGItems.item(i).nameID > 0) {
				addMacro(value: i, type: .item)
			}
		}
		
		for i in 0 ..< kNumberOfAbilities {
			if i == 0 || XGAbilities.ability(i).nameID > 0 {
				addMacro(value: i, type: .ability)
			}
		}
		
		let people = XGFiles.fsys("people_archive").fsysData
		for i in 0 ..< people.numberOfEntries {
			let identifier = people.identifiers[i]
			addMacro(value: identifier, type: .model)
		}
		
		let rooms = XGFiles.json("Room IDs").json as! [String : String]
		var roomList = [(Int, String)]()
		for (id, room) in rooms {
			roomList.append((id.integerValue!, room))
		}
		roomList.sort { (t1, t2) -> Bool in
			return t1.1 < t2.1
		}
		for (id, _) in roomList {
			addMacro(value: id, type: .room)
		}
		
		let battleFieldsList = roomList.filter { (room) -> Bool in
			return room.1.contains("_bf")
		}
		for (id, _) in battleFieldsList {
			addMacro(value: id, type: .battlefield)
		}
		
		for i in 0 ..< kNumberOfTalkTypes {
			if XDSTalkTypes(rawValue: i) != nil {
				addMacro(value: i, type: .talk)
			}
		}
		
		for i in 0 ... 2 {
			addMacro(value: i, type: .battleResult)
		}
		for i in 0 ... 4 {
			addMacro(value: i, type: .shadowStatus)
		}
		
		for i in 0 ..< XGDecks.DeckDarkPokemon.DDPKEntries {
			let mon = XGDeckPokemon.ddpk(i)
			if mon.isSet {
				addMacro(value: i, type: .shadowID)
			}
		}
		
		for i in 0 ... 2 {
			addMacro(value: i, type: .pokespot)
		}
		
		for i in 0 ... 3 {
			addMacro(value: i, type: .partyMember)
		}
		
		
		// get macros.xds
		// file containing common macros to use as reference
		if text.length > 0 {
			let file = XGFiles.xds("Common Macros")
			printg("documenting script: ", file.fileName)
			text.save(toFile: file)
		}
		
	}
	
	class func documentXDSClasses() {
		printg("documenting script classes...")
		var text = ""
		var classes = [(id: Int, name: String)]()
		for (id, name) in ScriptClassNames {
			classes.append((id, name))
		}
		classes.sort { (c1, c2) -> Bool in
			return c1.id < c2.id
		}
		for (id, name) in classes {
			if id > 0 {
				text += "\n\n// " + name + "\n"
			}
			if let data = ScriptClassFunctions[id] {
				let classPrefix = id == 0 ? "" : "\(name)."
				for info in data {
					text += classPrefix + info.name + "("
					if info.parameterCount == 0 || (info.parameterCount == 1 && id > 3) {
						text += ")"
						
						if let returnType = info.returnType {
							if returnType != .null {
								text += " -> " + returnType.typeName
							}
						} else {
							text += " -> Unknown"
						}
						
						text += " // \(info.hint)\n"
						continue
					}
					
					for i in 0 ..< info.parameterCount {
						
						let index = id > 3 ? i + 1 : i
						if index < info.parameterCount {
							if info.parameterTypes != nil {
								if index < info.parameterTypes!.count {
									if let type = info.parameterTypes![index] {
										text += " \(type.typeName)"
									} else {
										text += " Unknown"
									}
								} else {
									text += " Unknown"
								}
							} else {
								text += " Unknown"
							}
						}
					}
					if info.parameterTypes != nil {
						for option in info.parameterTypes! {
							if let o = option {
								if o == XDSMacroTypes.optional(.anyType) {
									text += " \(o.typeName)"
								}
							}
							
						}
					}
					
					text += " )"
					if let returnType = info.returnType {
						if returnType != .null {
							text += " -> " + returnType.typeName
						}
					} else {
						text += " -> Unknown"
					}
					text += "\n"
				}
			}
		}
		if text.length > 0 {
			let file = XGFiles.xds("Classes")
			printg("documenting script: ", file.fileName)
			text.save(toFile: file)
		}
		
	}
	
	class func documentXDS() {
		let files = XGFolders.Scripts.files.sorted { (s1, s2) -> Bool in
			return s1.fileName < s2.fileName
		}
		_ = files.map({ (file) in
			if file.fileType == .scd {
				
				let xds = XGFiles.xds(file.fileName.removeFileExtensions())
				if !xds.exists {
					printg("decompiling script: ", file.fileName)
					let script = file.scriptData.getXDSScript()
					XGUtility.saveString(script, toFile: xds)
				} else {
					if verbose {
						printg("script already exists: \(xds.path)")
					}
				}
			}
		})
		let xds = XGFiles.xds("common")
		if !xds.exists {
			printg("documenting script: ", XGFiles.common_rel.fileName)
			XGFiles.common_rel.scriptData.getXDSScript().save(toFile: xds)
		}
		printg("Finished decompiling scripts.")
		
	}
	
	class func documentXDSAutoCompletions(toFile file: XGFiles) {
		printg("Documenting XDS Autocompletions")
		var json = [String : AnyObject]()
		json["scope"] = "xdscript" as AnyObject
		var completions = [ [String: String] ]()
		
		for (id, name) in ScriptClassNames {
			
			if id != 0 {
				var plainTextCompletion = [String : String]()
				plainTextCompletion["trigger"] = name + "\t\(name) Class"
				plainTextCompletion["contents"] = name
				completions.append(plainTextCompletion)
			}
			
			let functions = ScriptClassFunctions[id]!
			let prefix = id == 0 ? "" : "\(name)."
			for function in functions {
				var completion = [String : String]()
				var trigger = prefix + function.name + "\t" + function.hint
				if let returnType = function.returnType {
					trigger += " -> \(returnType.typeName)"
				} else {
					trigger += " -> Unknown"
				}
				
				completion["trigger"] = trigger
				
				var contents = "\(function.name)("
				if let params = function.parameterTypes {
					let start = id > 3 ? 1 : 0
					for i in start ..< params.count {
						let param = params[i]
						contents += param == nil ? "/*Unknown*/ " : "/*\(param!.typeName)*/ "
					}
				}
				if contents.last! == " " {
					contents.removeLast()
				}
				contents += ")"
				
				
				completion["contents"] = contents
				completions.append(completion)
			}
		}
		
		var macros = [XDSExpr]()
		
		for i in -1 ..< CommonIndexes.NumberOfPokemon.value {
			let constant = XDSConstant.integer(i)
			macros.append(.macroImmediate(constant, .pokemon))
		}
		for i in -1 ..< CommonIndexes.NumberOfMoves.value {
			let constant = XDSConstant.integer(i)
			macros.append(.macroImmediate(constant, .move))
		}
		for i in -1 ..< CommonIndexes.NumberOfItems.value {
			let item = XGItems.item(i)
			let constant = XDSConstant.integer(item.scriptIndex)
			macros.append(.macroImmediate(constant, .item))
		}
		let people = XGFiles.fsys("people_archive")
		if people.exists {
			let fsys = people.fsysData
			for i in 0 ..< fsys.numberOfEntries {
				let constant = XDSConstant.integer(fsys.identifiers[i])
				macros.append(.macroImmediate(constant, .model))
			}
		}
		let rooms = XGFiles.json("Room IDs")
		if rooms.exists {
			if let roomsDict = rooms.json as? [String : String] {
				for (id, _) in roomsDict {
					if let idValue = id.integerValue {
						let constant = XDSConstant.integer(idValue)
						macros.append(.macroImmediate(constant, .room))
						
						if idValue >= 0x1f4 && idValue <= 0x226 {
							macros.append(.macroImmediate(constant, .battlefield))
						}
					}
				}
			}
		}
		
		for i in 0 ... 20 {
			let constant = XDSConstant.integer(i)
			macros.append(.macroImmediate(constant, .talk))
		}
		
		for i in 0 ... 0x6e {
			let constant = XDSConstant.integer(i)
			macros.append(.macroImmediate(constant, .msgVar))
		}
		
		for i in 0 ... 2 {
			let constant = XDSConstant.integer(i)
			macros.append(.macroImmediate(constant, .battleResult))
		}
		
		for i in 0 ... 4 {
			let constant = XDSConstant.integer(i)
			macros.append(.macroImmediate(constant, .shadowStatus))
		}
		
		for i in 0 ..< XGDecks.DeckDarkPokemon.DDPKEntries {
			let constant = XDSConstant.integer(i)
			macros.append(.macroImmediate(constant, .shadowID))
		}
		
		for i in 0 ... 2 {
			let constant = XDSConstant.integer(i)
			macros.append(.macroImmediate(constant, .pokespot))
		}
		
		for i in 0 ... 3 {
			let constant = XDSConstant.integer(i)
			macros.append(.macroImmediate(constant, .partyMember))
		}
		
		for i in 0 ..< kNumberOfGiftPokemon {
			let constant = XDSConstant.integer(i)
			macros.append(.macroImmediate(constant, .giftPokemon))
		}
		
		for i in 0 ... 3 {
			let constant = XDSConstant.integer(i)
			macros.append(.macroImmediate(constant, .transitionID))
		}
		
		for i in 1 ... 2000 {
			if let _ = XDSFlags(rawValue: i) {
				macros.append(.macroImmediate(XDSConstant.integer(i), .flag))
			}
		}
		
		for macro in macros {
			switch macro {
			case .macroImmediate(let c, let t):
				let macroText = XDSExpr.stringFromMacroImmediate(c: c, t: t)
				if macroText.length > 1 {
					let val = t.printsAsHexadecimal ? c.asInt.hexString() + " // \(c.asInt)" : c.asInt.string + " // \(c.asInt.hexString())"
					let contents = "define " + macroText + " \(val)"
					let trigger = contents + "\t" + t.typeName
					var completion = [String : String]()
					completion["trigger"] = trigger
					completion["contents"] = contents
					completions.append(completion)
					
					completion = [String : String]()
					completion["trigger"] = macroText + "\t" + t.typeName + " " + val
					completion["contents"] = macroText.substring(from: 1, to: macroText.length)
					completions.append(completion)
				}
			default:
				break
			}
		}
		
		json["completions"] = completions as AnyObject
		XGUtility.saveJSON(json as AnyObject, toFile: file)
	}
	
	class func documentISO(forXG: Bool) {
		
		let prefix = game == .XD ? (forXG ? "XG " : "XD ") : " Colosseum"
		
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
		saveObtainablePokemonByLocation(prefix: prefix)
		documentTMs()
	}
	
	
	//MARK: - Model Utilities
	class func convertFromPKXToOverWorldModel(pkx: XGMutableData) -> XGMutableData {
		
		//	let rawData = pkx.charStream
		let modelHeader = 0xE60
		let modelStart = 0xE80
		var modelEndPaddingCounter = 0
		
		// get number of padding 0s at end
		var index = pkx.length - 4
		var current = pkx.getWordAtOffset(index)
		
		while current == 0 {
			modelEndPaddingCounter += 4
			index -= 4
			current = pkx.getWordAtOffset(index)
		}
		modelEndPaddingCounter = pkx.length - (index + 4)
		
		let skipStart = Int(pkx.getWordAtOffset(pkx.length - modelEndPaddingCounter - 0x1C)) + modelStart
		let skipEnd = Int(pkx.getWordAtOffset(modelHeader + 4)) + modelStart
		
		let part2 = pkx.getCharStreamFromOffset(modelStart, length: skipStart - modelStart)
		let part3 = pkx.getCharStreamFromOffset(skipEnd, length: pkx.length - modelEndPaddingCounter - 0x1C - skipEnd)
		let part4 : [UInt8] = [0x73, 0x63, 0x65, 0x6E, 0x65, 0x5F, 0x64, 0x61, 0x74, 0x61, 0x00]
		var rawBytes = part2 + part3 + part4
		
		let newLength = rawBytes.count + 0x20
		let header4 = [newLength, skipStart - modelStart, Int(pkx.getWordAtOffset(modelHeader + 8)), 0x01]
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
	
	class func copyOWPokemonIdleAnimationFromIndex(index: Int, forModel file: XGFiles) {
		// almost always index 0 holds the idle animation
		// for overworld need to copy that to index 3
		let data = file.data!
		let backup = file.data!
		backup.file = .nameAndFolder(file.fileName + ".bak", file.folder)
		backup.save()
		
		let headerSize = 0x20
		let pointerListPointer = data.getWordAtOffset(4).int + headerSize
		let numberOfPointers = data.getWordAtOffset(8).int
		let sceneDataPointerOffset = pointerListPointer + (numberOfPointers * 4)
		let sceneDataPointer = data.getWordAtOffset(sceneDataPointerOffset).int + headerSize
		let struct1Pointer = data.getWordAtOffset(sceneDataPointer).int + headerSize
		let objectPointer = data.getWordAtOffset(struct1Pointer).int + headerSize
		let animation0Pointer = data.getWordAtOffset(objectPointer + 4).int + headerSize
		var animationOffsets = [UInt32]()
		var currentAnimationOffset = animation0Pointer
		var currentAnimation : UInt32 = 0
		repeat {
			currentAnimation = data.getWordAtOffset(currentAnimationOffset)
			if currentAnimation != 0 {
				animationOffsets.append(currentAnimation)
			}
			currentAnimationOffset += 4
		} while currentAnimation != 0
		
		if index >= animationOffsets.count {
			printg("animation index too large")
			return
		}
		
		if animationOffsets.count < 4 {
			printg("model has fewer than 4 animations")
			return
		}
		
		data.replaceWordAtOffset(animation0Pointer + 0xc, withBytes: animationOffsets[index])
		data.save()
		
	}
	
	
	//MARK: - pokespot
	class func relocatePokespots(startOffset: Int, numberOfEntries n: Int) {
		
		var spotStart = startOffset
		let entrySize = kSizeOfPokeSpotData
		
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
		
		let dol = XGFiles.dol.data!
		let offset = 0x1faf50 - kDOLtoRAMOffsetDifference
		dol.replace4BytesAtOffset(offset, withBytes: 0x280A0000 + n)
		dol.save()
		
	}
	
	//MARK: - Release configuration
	
	class func fixUpTrainerPokemon() {
		for deck in MainDecksArray {
			for poke in deck.allPokemon {
				let spec = poke.species.stats
				
				if spec.genderRatio == .maleOnly {
					if poke.gender != .male {
						poke.gender = .male
						poke.save()
					}
				}
				else if spec.genderRatio == .femaleOnly {
					if poke.gender != .female {
						poke.gender = .female
						poke.save()
					}
				}
				else if spec.genderRatio == .genderless {
					if poke.gender != .genderless {
						poke.gender = .genderless
						poke.save()
					}
				}
				
				if (spec.ability2.index == 0) && (poke.ability == 1) { poke.ability = 0; poke.save() }
				
			}
		}
	}
	
	//MARK: - Documentation
	class func documentPokemonStats(title: String, forXG: Bool) {
		
		let fileName = "Pokemon Stats"
		printg("documenting " + fileName + "...")
		
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
		var evolutionHeaders = [String]()
		var evolutions = [ [String] ]()
		
		for _ in 0 ..< kNumberOfLevelUpMoves {
			levelUpMoves.append([String]())
		}
		
		for _ in 0 ..< kNumberOfTMs {
			TMs.append([String]())
		}
		
		for _ in 0 ..< kNumberOfTutorMoves {
			tutors.append([String]())
		}
		
		for _ in 0 ..< kNumberOfEvolutions {
			evolutions.append([String]())
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
					if lum.level < 10  { level = "  " + level}
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
				
				evolutionHeaders.append(mon.evolutions.filter({ (evo) -> Bool in
					return evo.evolvesInto > 0
				}).count.string)
				
				for j in 0 ..< kNumberOfEvolutions {
					let evo = mon.evolutions[j]
					var condition = ""
					var method = evo.evolutionMethod.string
					switch evo.evolutionMethod {
					case .evolutionStone:
						condition = "(" + XGItems.item(evo.condition).name.string + ")"
					case .levelUp:
						condition = "(Lv. " + evo.condition.string + ")"
					case .levelUpWithKeyItem:
						condition = "(" + XGItems.item(evo.condition).name.string + ")"
					case .tradeWithItem:
						condition = "(" + XGItems.item(evo.condition).name.string + ")"
					case .none:
						method = ""
					default:
						condition = ""
						
					}
					evolutions[j].append(XGPokemon.pokemon(evo.evolvesInto).name.string + " " + method + condition)
				}
				
			}
			
			raw_array.append(mon.dictionaryRepresentation as AnyObject)
			hum_array.append(mon.readableDictionaryRepresentation as AnyObject)
		}
		printg("saving " + fileName + "...")
		
		saveJSON(raw_array as AnyObject, toFile: XGFiles.nameAndFolder(fileName + " raw.json", .Reference))
		saveJSON(hum_array as AnyObject, toFile: XGFiles.nameAndFolder(fileName + " human readable.json", .Reference))
		
		printg("saved " + fileName + "!\n")
		
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
		
		dataRepresentation.append(("Evolutions",evolutionHeaders,true))
		for i in 0 ..< kNumberOfEvolutions {
			dataRepresentation.append(("Evolution",evolutions[i],false))
		}
		
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
		printg("documenting " + fileName + "...")
		
		var raw_array = [AnyObject]()
		var hum_array = [AnyObject]()
		
		for i in 0 ..< kNumberOfMoves {
			
			let entry = XGMove(index: i)
			
			raw_array.append(entry.dictionaryRepresentation as AnyObject)
			hum_array.append(entry.readableDictionaryRepresentation as AnyObject)
		}
		printg("saving " + fileName + "...")
		
		saveJSON(raw_array as AnyObject, toFile: XGFiles.nameAndFolder(fileName + " raw.json", .Reference))
		saveJSON(hum_array as AnyObject, toFile: XGFiles.nameAndFolder(fileName + " human readable.json", .Reference))
		
		printg("saved " + fileName + "!\n")
		
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
			names.append(move.name.string)
			descriptions.append(move.mdescription.string)
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
	
	class func documentTrainers(title: String, forXG: Bool) {
		
		let fileName = "Trainers"
		printg("documenting " + fileName + "...")
		
		var raw_array = [AnyObject]()
		var hum_array = [AnyObject]()
		
		var decksString = ""
		
		for deck in TrainerDecksArray where deck.file.exists {
			
			decksString += deck.trainersString()
			
			raw_array.append(deck.dictionaryRepresentation as AnyObject)
			hum_array.append(deck.readableDictionaryRepresentation as AnyObject)
			
		}
		printg("saving " + fileName + "...")
		
		saveJSON(raw_array as AnyObject, toFile: XGFiles.nameAndFolder(fileName + " raw.json", .Reference))
		saveJSON(hum_array as AnyObject, toFile: XGFiles.nameAndFolder(fileName + " human readable.json", .Reference))
		
		printg("saved " + fileName + "!\n")
		
		saveString(decksString, toFile: .nameAndFolder(title + ".txt", .Reference))
	}
	
	class func documentShadowPokemon(title: String, forXG: Bool) {
		
		let fileName = "Shadow Pokemon"
		printg("documenting " + fileName + "...")
		
		let raw_array = XGDecks.DeckDarkPokemon.dictionaryRepresentation
		let hum_array = XGDecks.DeckDarkPokemon.readableDictionaryRepresentation
		
		printg("saving " + fileName + "...")
		
		saveJSON(raw_array as AnyObject, toFile: XGFiles.nameAndFolder(fileName + " raw.json", .Reference))
		saveJSON(hum_array as AnyObject, toFile: XGFiles.nameAndFolder(fileName + " human readable.json", .Reference))
		
		printg("saved " + fileName + "!\n")
		
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
	
	class func getItemLocations() -> [[String]] {
		var locations = [[String]]()
		for _ in 0 ..< CommonIndexes.NumberOfItems.value {
			locations.append([String]())
		}
		
		for i in 0 ..< CommonIndexes.NumberTreasureBoxes.value {
			let treasure = XGTreasure(index: i)
			locations[treasure.item.index].addUnique(treasure.room.map.name)
		}
		
		for s in XGFolders.Scripts.files where s.fileType == .scd {
			let script = s.scriptData
			let map = (XGMaps(rawValue: s.fileName.substring(from: 0, to: 2)) ?? .Unknown).name
			
			for item in script.getItems() {
				locations[item.index].addUnique(map)
			}
		}
		
		return locations
	}
	
	class func getTMLocations() -> [(tm:XGTMs, locations:[String])] {
		var locations = getItemLocations()
		var tmLocations = [(XGTMs,[String])]()
		
		let firstIndex = XGTMs.tm(1).item.index
		for i in firstIndex ..< firstIndex + kNumberOfTMsAndHMs {
			let tm = XGTMs.tm(i - firstIndex + 1)
			tmLocations.append((tm, locations[i]))
		}
		
		return tmLocations
	}
	
	class func documentTMs() {
		
		let fileName = "TM Locations"
		printg("documenting " + fileName + "\nThis may take a while...")
		
		let locations = getTMLocations()
		
		var str = "TM locations\n\n"
		
		for (tm, locs) in locations {
			var locationString = locs.count == 0 ? "N/A" : locs[0]
			if locs.count > 1 {
				for i in 1 ..< locs.count {
					locationString += ", " + locs[i]
				}
			}
			str += tm.item.name.string + " (\(tm.move.name.string))".spaceToLength(20) + ": " + locationString + "\n"
			
		}
		printg("saving " + fileName + "...")
		
		saveString(str, toFile: .nameAndFolder(fileName + ".txt", .Reference))
		
		printg("saved " + fileName + "!\n")
		
	}
	
	class func documentTutorMoves() {
		
		let fileName = "Tutor Moves"
		printg("documenting " + fileName + "...")
		
		var raw_array = [AnyObject]()
		var hum_array = [AnyObject]()
		
		for i in 1 ... kNumberOfTutorMoves {
			
			let entry = XGTMs.tutor(i)
			
			raw_array.append(entry.dictionaryRepresentation as AnyObject)
			hum_array.append(entry.readableDictionaryRepresentation as AnyObject)
		}
		printg("saving " + fileName + "...")
		
		saveJSON(raw_array as AnyObject, toFile: XGFiles.nameAndFolder(fileName + " raw.json", .Reference))
		saveJSON(hum_array as AnyObject, toFile: XGFiles.nameAndFolder(fileName + " human readable.json", .Reference))
		
		printg("saved " + fileName + "!\n")
		
	}
	
	class func documentTrainerClasses() {
		
		let fileName = "Trainer classes"
		printg("documenting " + fileName + "...")
		
		var raw_array = [AnyObject]()
		var hum_array = [AnyObject]()
		
		for i in 0 ..< kNumberOfTrainerClasses {
			
			let entry = XGTrainerClasses(rawValue: i)!.data
			
			raw_array.append(entry.dictionaryRepresentation as AnyObject)
			hum_array.append(entry.readableDictionaryRepresentation as AnyObject)
		}
		printg("saving " + fileName + "...")
		
		saveJSON(raw_array as AnyObject, toFile: XGFiles.nameAndFolder(fileName + " raw.json", .Reference))
		saveJSON(hum_array as AnyObject, toFile: XGFiles.nameAndFolder(fileName + " human readable.json", .Reference))
		
		printg("saved " + fileName + "!\n")
		
	}
	
	class func documentMtBattlePokemon() {
		
		let fileName = "Mt. Battle Prize Pokemon"
		printg("documenting " + fileName + "...")
		
		var raw_array = [AnyObject]()
		var hum_array = [AnyObject]()
		
		for i in 0 ..< 3 {
			
			let entry = XGMtBattlePrizePokemon(index: i)
			
			raw_array.append(entry.dictionaryRepresentation as AnyObject)
			hum_array.append(entry.readableDictionaryRepresentation as AnyObject)
		}
		printg("saving " + fileName + "...")
		
		saveJSON(raw_array as AnyObject, toFile: XGFiles.nameAndFolder(fileName + " raw.json", .Reference))
		saveJSON(hum_array as AnyObject, toFile: XGFiles.nameAndFolder(fileName + " human readable.json", .Reference))
		
		printg("saved " + fileName + "!\n")
		
	}
	
	class func documentTrades() {
		
		let fileName = "In-Game Trades"
		printg("documenting " + fileName + "...")
		
		var raw_array = [AnyObject]()
		var hum_array = [AnyObject]()
		
		for i in 0 ..< 4 {
			
			let entry = XGTradePokemon(index: i)
			
			raw_array.append(entry.dictionaryRepresentation as AnyObject)
			hum_array.append(entry.readableDictionaryRepresentation as AnyObject)
		}
		printg("saving " + fileName + "...")
		
		saveJSON(raw_array as AnyObject, toFile: XGFiles.nameAndFolder(fileName + " raw.json", .Reference))
		saveJSON(hum_array as AnyObject, toFile: XGFiles.nameAndFolder(fileName + " human readable.json", .Reference))
		
		printg("saved " + fileName + "!\n")
		
	}
	
	class func documentGiftShadowPokemon() {
		
		let fileName = "Shadow Pokemon Gift"
		printg("documenting " + fileName + "...")
		
		var raw_array = [AnyObject]()
		var hum_array = [AnyObject]()
		
		let entry = XGTradeShadowPokemon()
		
		raw_array.append(entry.dictionaryRepresentation as AnyObject)
		hum_array.append(entry.readableDictionaryRepresentation as AnyObject)
		
		printg("saving " + fileName + "...")
		
		saveJSON(raw_array as AnyObject, toFile: XGFiles.nameAndFolder(fileName + " raw.json", .Reference))
		saveJSON(hum_array as AnyObject, toFile: XGFiles.nameAndFolder(fileName + " human readable.json", .Reference))
		
		printg("saved " + fileName + "!\n")
		
	}
	
	class func documentPokemarts() {
		
		let dat = XGFiles.pocket_menu.data!
		let itemHexList = dat.getShortStreamFromOffset(0x300, length: 0x170)
		
		let fileName = "Pokemarts"
		printg("documenting " + fileName + "...")
		
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
		printg("saving " + fileName + "...")
		
		saveJSON(raw_array as AnyObject, toFile: XGFiles.nameAndFolder(fileName + " raw.json", .Reference))
		saveJSON(hum_array as AnyObject, toFile: XGFiles.nameAndFolder(fileName + " human readable.json", .Reference))
		
		printg("saved " + fileName + "!\n")
		
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
	
	
}

extension XGDolPatcher {
	class func deleteBattleModeData() { return }
	
	class func tutorMovesAvailableImmediately() {
		if game == .XD {
			for i in 1 ... CommonIndexes.NumberOfTutorMoves.value {
				let tm = XGTMs.tutor(i)
				tm.replaceTutorFlag(.immediately)
			}
		}
	}
}



















