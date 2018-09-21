//
//  ColosseumExtensions.swift
//  Colosseum Tool
//
//  Created by The Steez on 04/06/2018.
//

import Foundation

enum XGRegions : UInt32 {
	
	case US = 0x47433645
	case EU = 0x47433650
	case JP = 0x4743364A
	
}

class XGMapRel : XGRelocationTable {
	
	@objc var characters = [XGCharacter]()
	@objc var interactionLocations = [XGInteractionLocation]()
	
	@objc var roomID = 0
	
	override convenience init(file: XGFiles) {
		self.init(file: file, checkScript: true)
	}
	
	init(file: XGFiles, checkScript: Bool) {
		super.init(file: file)
		
		let firstIP = self.getPointer(index: MapRelIndexes.FirstInteractionLocation.rawValue)
		let numberOfIPs = self.getValueAtPointer(index: MapRelIndexes.NumberOfInteractionLocations.rawValue)
		
		for i in 0 ..< numberOfIPs {
			let ip = XGInteractionLocation(file: file, index: i, startOffset: firstIP + (i * kSizeOfInteractionLocation))
			interactionLocations.append(ip)
		}
		
		for i in 0 ..< CommonIndexes.NumberOfRooms.value {
			if let room = XGRoom.roomWithID(i) {
				if room.name == file.fileName.removeFileExtensions() {
					self.roomID = room.roomID
				}
			}
		}
		
		
		let firstCharacter = self.getPointer(index: MapRelIndexes.FirstCharacter.rawValue)
		let numberOfCharacters = self.getValueAtPointer(index: MapRelIndexes.NumberOfCharacters.rawValue)
		
		for i in 0 ..< numberOfCharacters {
			let character = XGCharacter(file: file, index: i, startOffset: firstCharacter + (i * kSizeOfCharacter))
			
			characters.append(character)
		}
	}
	
}

extension XGISO {
	var autoFsysList : [String] {
		return [
			"D1_labo_1F.fsys",
			"D1_labo_B1.fsys",
			"D1_labo_B2.fsys",
			"D1_labo_B3.fsys",
			"D1_out.fsys",
			"D2_cloud_1.fsys",
			"D2_cloud_2.fsys",
			"D2_cloud_3.fsys",
			"D2_cloud_4.fsys",
			"D2_crater_colo.fsys",
			"D2_magma_1.fsys",
			"D2_magma_2.fsys",
			"D2_magma_3.fsys",
			"D2_out.fsys",
			"D2_pc_1F.fsys",
			"D2_rest_1.fsys",
			"D2_rest_2.fsys",
			"D2_rest_3.fsys",
			"D2_rest_4.fsys",
			"D2_rest_5.fsys",
			"D2_rest_6.fsys",
			"D2_rest_7.fsys",
			"D2_rest_8.fsys",
			"D2_rest_9.fsys",
			"D2_valley_1.fsys",
			"D2_valley_2.fsys",
			"D2_valley_3.fsys",
			"D4_dome_3.fsys",
			"D4_dome_4.fsys",
			"D4_out.fsys",
			"D4_out_2.fsys",
			"D4_tower_1F_1.fsys",
			"D4_tower_1F_2.fsys",
			"D4_tower_1F_3.fsys",
			"M1_carde_1.fsys",
			"M1_gym_1F.fsys",
			"M1_gym_B1.fsys",
			"M1_houseA_1F.fsys",
			"M1_houseA_2F.fsys",
			"M1_houseB_1F.fsys",
			"M1_houseC_1F.fsys",
			"M1_out.fsys",
			"M1_pc_1F.fsys",
			"M1_pc_B1.fsys",
			"M1_shop_1F.fsys",
			"M1_shop_2F.fsys",
			"M1_stadium_1F.fsys",
			"M1_water_colo.fsys",
			"M2_building_1F.fsys",
			"M2_building_2F.fsys",
			"M2_building_3F.fsys",
			"M2_building_4F.fsys",
			"M2_enter_1F.fsys",
			"M2_enter_1F_2.fsys",
			"M2_guild_1F_1.fsys",
			"M2_guild_1F_2.fsys",
			"M2_hotel_1F.fsys",
			"M2_houseA_1F.fsys",
			"M2_out.fsys",
			"M2_police_1F.fsys",
			"M2_shop_1F.fsys",
			"M2_uranai_1F.fsys",
			"M2_windmill_1F.fsys",
			"M3_cave_1F_1.fsys",
			"M3_cave_1F_2.fsys",
			"M3_houseA_1F.fsys",
			"M3_houseB_1F.fsys",
			"M3_houseC_1F.fsys",
			"M3_houseC_2F.fsys",
			"M3_houseD_1F.fsys",
			"M3_out.fsys",
			"M3_pc_1F.fsys",
			"M3_shop_1F.fsys",
			"M3_shrine_1F.fsys",
			"M4_bottom_1F.fsys",
			"M4_bottom_colo.fsys",
			"M4_cylinder_colo.fsys",
			"M4_enter_1F.fsys",
			"M4_enter_B1.fsys",
			"M4_hotel_1F.fsys",
			"M4_hotel_B1.fsys",
			"M4_houseA_1F.fsys",
			"M4_junk_1F.fsys",
			"M4_junk_B1.fsys",
			"M4_kanpo_1F.fsys",
			"M4_labo_1F.fsys",
			"M4_labo_B1.fsys",
			"M4_out.fsys",
			"M4_out_2.fsys",
			"M4_shop_1F.fsys",
			"M4_subway_1F.fsys",
			"M4_subway_B1.fsys",
			"M4_subway_B2_1.fsys",
			"M4_subway_B2_2.fsys",
			"M4_subway_B3.fsys",
			"M4_train_1F.fsys",
			"S1_out.fsys",
			"S1_shop_1F.fsys",
			"S2_bossroom_1.fsys",
			"S2_building_1F_2.fsys",
			"S2_building_2F_2.fsys",
			"S2_building_3F_2.fsys",
			"S2_hallway_1.fsys",
			"S2_out_1.fsys",
			"S2_out_2.fsys",
			"S2_out_3.fsys",
			"S2_snatchroom_1.fsys"
		]
	}
	
	var fsysList : [String] {
		return [
			"common.fsys",
			"field_common.fsys",
			"fight_common.fsys",
			"people_archive.fsys"
		]
	}
	
	var menuFsysList : [String] {
		return [
			"carde_menu.fsys",
			"colosseumbattle_menu.fsys",
			"D2_present_room.fsys",
			"keydisc.fsys",
			"DNA_key.fsys",
			"name_entry_menu.fsys",
			"pcbox_menu.fsys",
			"pcbox_name_entry_menu.fsys",
			"pcbox_pocket_menu.fsys",
			"pda_menu.fsys",
			"pocket_menu.fsys",
			"pokemonchange_menu.fsys",
			"title.fsys",
			"topmenu.fsys",
			"waza_menu.fsys",
			"world_map.fsys"
		]
	}
	
	var deckList : [String] {
		return [String]()
	}
	
	func extractDecks() { }
	
	func extractSpecificStringTables() {
		
		let fightFile = XGFiles.stringTable("fight.msg")
		if !fightFile.exists {
			let fight = XGFiles.fsys("fight_common.fsys").fsysData.decompressedDataForFileWithFiletype(type: .msg)!
			fight.file = fightFile
			fight.save()
		}
		
		let pocket_menu = XGFiles.stringTable("pocket_menu.msg")
		let nameentrymenu = XGFiles.stringTable("name_entry_menu.msg")
		let system_tool = XGFiles.stringTable("system_tool.msg")
		let pda_menu = XGFiles.stringTable("pda_menu.msg")
		let p_exchange = XGFiles.stringTable("p_exchange.msg")
		let world_map = XGFiles.stringTable("world_map.msg")
		
		if !pocket_menu.exists {
			let pm = XGFiles.nameAndFolder("pcbox_pocket_menu.fsys",.MenuFSYS).fsysData.decompressedDataForFileWithFiletype(type: .msg)!
			pm.file = pocket_menu
			pm.save()
		}
		
		if !nameentrymenu.exists {
			let nem = XGFiles.nameAndFolder("pcbox_name_entry_menu.fsys",.MenuFSYS).fsysData.decompressedDataForFileWithFiletype(type: .msg)!
			nem.file = nameentrymenu
			nem.save()
		}
		
		if !system_tool.exists {
			let st = XGFiles.nameAndFolder("pcbox_menu.fsys",.MenuFSYS).fsysData.decompressedDataForFileWithFiletype(type: .msg)!
			st.file = system_tool
			st.save()
		}
		
		if !pda_menu.exists {
			let pda = XGFiles.nameAndFolder("pda_menu.fsys",.MenuFSYS).fsysData.decompressedDataForFileWithFiletype(type: .msg)!
			pda.file = pda_menu
			pda.save()
		}
		
		if !p_exchange.exists {
			let pex = XGFiles.nameAndFolder("pokemonchange_menu.fsys",.MenuFSYS).fsysData.decompressedDataForFileWithFiletype(type: .msg)!
			pex.file = p_exchange
			pex.save()
		}
		
		if !world_map.exists {
			let wm = XGFiles.nameAndFolder("world_map.fsys",.MenuFSYS).fsysData.decompressedDataForFileWithFiletype(type: .msg)!
			wm.file = world_map
			wm.save()
		}
	}
}

extension XGUtility {
	
	class func importFsys() {
		
		printg("importing files to .fsys archives")
		
		let common = XGFiles.fsys("common.fsys").fsysData
		if game == .XD {
			common.shiftAndReplaceFileWithIndex(0, withFile: .lzss("common.rel.lzss"))
		} else {
			common.replaceFileWithIndex(0, withFile: .lzss("common.rel.lzss"), saveWhenDone: true)
			if game == .Colosseum && compressionTooLarge {
				commonTooLarge = true
			}
		}
		
		XGFiles.fsys("fight_common.fsys").fsysData.shiftAndReplaceFileWithType(.msg, withFile: .lzss("fight.msg.lzss"))
		XGFiles.nameAndFolder("pocket_menu.fsys",.MenuFSYS).fsysData.shiftAndReplaceFileWithType(.rel, withFile: .lzss("pocket_menu.rel.lzss"))

	}
	
	class func prepareForQuickCompilation() {
		XGFiles.common_rel.compress()
		importFsys()
	}
	
	class func prepareForCompilation() {
		compressFiles()
		importFsys()
	}
	
	class func importSpecificStringTables() {
		printg("importing menu string tables")
		
		let pocket_menu = XGFiles.lzss("pocket_menu.msg.lzss")
		let nameentrymenu = XGFiles.lzss("name_entry_menu.msg.lzss")
		let system_tool = XGFiles.lzss("system_tool.msg.lzss")
		let pda_menu = XGFiles.lzss("pda_menu.msg.lzss")
		let p_exchange = XGFiles.lzss("p_exchange.msg.lzss")
		let fight = XGFiles.lzss("fight.msg.lzss")
		
		XGFiles.nameAndFolder("carde_menu.fsys",.MenuFSYS).fsysData.shiftAndReplaceFileWithType(.msg, withFile: system_tool)
		XGFiles.fsys("fight_common.fsys").fsysData.shiftAndReplaceFileWithType(.msg, withFile: fight)
		XGFiles.nameAndFolder("name_entry_menu.fsys",.MenuFSYS).fsysData.shiftAndReplaceFileWithType(.msg, withFile: nameentrymenu)
		XGFiles.nameAndFolder("pcbox_menu.fsys",.MenuFSYS).fsysData.shiftAndReplaceFileWithType(.msg, withFile: system_tool)
		XGFiles.nameAndFolder("pcbox_menu.fsys",.MenuFSYS).fsysData.shiftAndReplaceFileWithType(.msg, withFile: pocket_menu)
		XGFiles.nameAndFolder("pcbox_name_entry_menu.fsys",.MenuFSYS).fsysData.shiftAndReplaceFileWithType(.msg, withFile: nameentrymenu)
		XGFiles.nameAndFolder("pcbox_pocket_menu.fsys",.MenuFSYS).fsysData.shiftAndReplaceFileWithType(.msg, withFile: pocket_menu)
		XGFiles.nameAndFolder("pda_menu.fsys",.MenuFSYS).fsysData.shiftAndReplaceFileWithType(.msg, withFile: pda_menu)
		XGFiles.nameAndFolder("pocket_menu.fsys",.MenuFSYS).fsysData.shiftAndReplaceFileWithType(.msg, withFile: pocket_menu)
		XGFiles.nameAndFolder("pokemonchange_menu.fsys",.MenuFSYS).fsysData.shiftAndReplaceFileWithType(.msg, withFile: system_tool)
		XGFiles.nameAndFolder("pokemonchange_menu.fsys",.MenuFSYS).fsysData.shiftAndReplaceFileWithType(.msg, withFile: pocket_menu)
		XGFiles.nameAndFolder("pokemonchange_menu.fsys",.MenuFSYS).fsysData.shiftAndReplaceFileWithType(.msg, withFile: p_exchange)
		XGFiles.nameAndFolder("pokemonchange_menu.fsys",.MenuFSYS).fsysData.shiftAndReplaceFileWithType(.msg, withFile: system_tool)
		XGFiles.nameAndFolder("title.fsys",.MenuFSYS).fsysData.shiftAndReplaceFileWithType(.msg, withFile: system_tool)
		XGFiles.nameAndFolder("topmenu.fsys",.MenuFSYS).fsysData.shiftAndReplaceFileWithType(.msg, withFile: system_tool)
		XGFiles.nameAndFolder("waza_menu.fsys",.MenuFSYS).fsysData.shiftAndReplaceFileWithType(.msg, withFile: pocket_menu)
		XGFiles.nameAndFolder("colosseumbattle_menu.fsys",.MenuFSYS).fsysData.shiftAndReplaceFileWithType(.msg, withFile: pocket_menu)
		XGFiles.nameAndFolder("colosseumbattle_menu.fsys",.MenuFSYS).fsysData.shiftAndReplaceFileWithType(.msg, withFile: nameentrymenu)
		XGFiles.nameAndFolder("colosseumbattle_menu.fsys",.MenuFSYS).fsysData.shiftAndReplaceFileWithType(.msg, withFile: system_tool)
	}
	
	//MARK: - Release configuration
	class func prepareForRelease() {
		fixUpTrainerPokemon()
	}
	
	class func fixUpTrainerPokemon() {
		for deck in TrainerDecksArray {
			for poke in deck.allPokemon {
				let spec = poke.species.stats
				
				if spec.genderRatio == .maleOnly { poke.gender = .male }
				else if spec.genderRatio == .femaleOnly { poke.gender = .female }
				else if spec.genderRatio == .genderless { poke.gender = .genderless }
				else if poke.gender == .genderless { poke.gender = .female }
				
				if (spec.ability2.index == 0) && (poke.ability == 1) { poke.ability = 0 }
				
				poke.save()
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
		var evolutionHeaders = [String]()
		var evolutions = [ [String] ]()
		
		for _ in 0 ..< kNumberOfLevelUpMoves {
			levelUpMoves.append([String]())
		}
		
		for _ in 0 ..< kNumberOfTMs {
			TMs.append([String]())
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
	
	class func documentTMs() {
		
		let fileName = "TM Locations"
		printg("documenting " + fileName + "...")
		
		var str = "TM locations\n\n"
		
		for i in 1 ... 50 {
			let tm = XGTMs.tm(i)
			let locationString = tm.location
			str += tm.item.name.string + " (\(tm.move.name.string))".spaceToLength(20) + ": " + locationString + "\n"
			
		}
		printg("saving " + fileName + "...")
		
		saveString(str, toFile: .nameAndFolder(fileName + ".txt", .Reference))
		
		printg("saved " + fileName + "!\n")
		
	}
	
	class func documentPokemarts() {
		
		let dat = XGFiles.pocket_menu.data
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
	
	class func documentTrainers(title: String, forXG: Bool) {
		
		let fileName = "Trainers"
		printg("documenting " + fileName + "...")
		
		var raw_array = [AnyObject]()
		var hum_array = [AnyObject]()
		
		let deck = XGDecks.DeckStory
		
		let decksString = deck.trainersString()
		
		raw_array.append(deck.dictionaryRepresentation as AnyObject)
		hum_array.append(deck.readableDictionaryRepresentation as AnyObject)
		
		printg("saving " + fileName + "...")
		
		saveJSON(raw_array as AnyObject, toFile: XGFiles.nameAndFolder(fileName + " raw.json", .Reference))
		saveJSON(hum_array as AnyObject, toFile: XGFiles.nameAndFolder(fileName + " human readable.json", .Reference))
		
		printg("saved " + fileName + "!\n")
		
		saveString(decksString, toFile: .nameAndFolder(title + ".txt", .Reference))
	}
	
	class func documentShadowPokemon(title: String, forXG: Bool) {
		
		let fileName = "Shadow Pokemon"
		printg("documenting " + fileName + "...")
		
		var dicts = [ (raw:[String : AnyObject], hum:[String : AnyObject]) ]()
		var shadows = [XGTrainerPokemon]()
		for i in 0 ..< CommonIndexes.NumberOfShadowPokemon.value {
			
			var raw = [String : AnyObject]()
			var hum = [String : AnyObject]()
			
			let start = CommonIndexes.ShadowData.startOffset + (i * kSizeOfShadowData)
			let rel = XGFiles.common_rel.data
			let table =  XGStringTable.common_rel2()
			
			let species  = rel.get2BytesAtOffset(start + kShadowSpeciesOffset)
			let japanese = rel.get2BytesAtOffset(start + kShadowJapaneseMSGOffset)
			raw["species"] = XGPokemon.pokemon(species).name.string as AnyObject
			hum["species"] = XGPokemon.pokemon(species).name.string as AnyObject
			if region != .JP {
				raw["japanese"] = table.stringSafelyWithID(japanese).string as AnyObject
				hum["japanese"] = table.stringSafelyWithID(japanese).string as AnyObject
			}
			
			let id = rel.get2BytesAtOffset(start + kShadowTIDOffset)
			let trainer = XGTrainer(index: id)
			for p in trainer.pokemon {
				if p.isShadow {
					raw["pokemonData"] = p.dictionaryRepresentation as AnyObject
					hum["pokemonData"] = p.readableDictionaryRepresentation as AnyObject
					shadows.append(p)
				}
			}
			dicts.append((raw,hum))
		}
		
		var raw_array = [AnyObject]()
		var hum_array = [AnyObject]()
		
		for (raw, hum) in dicts {
			raw_array.append(raw as AnyObject)
			hum_array.append(hum as AnyObject)
		}
		
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
		
		for i in 0 ..< shadows.count {
			
			let mon = shadows[i]
			
			indices.append(String(i))
			hexIndices.append(i.hex())
			names.append(mon.species.name.string)
			m1s.append(mon.moves[0].name.string)
			m2s.append(mon.moves[1].name.string)
			m3s.append(mon.moves[2].name.string)
			m4s.append(mon.moves[3].name.string)
			levels.append(mon.level.string)
			
		}
		
		let dataRepresentation = [
			
			("Index dec", indices, true),
			("hex", hexIndices, true),
			("Name", names, false),
			("Level", levels, true),
			("Move 1", m1s, false),
			("Move 2", m2s, false),
			("Move 3", m3s, false),
			("Move 4", m4s, false),
			]
		
		documentData(title: title, data: dataRepresentation)
		
	}
	
	class func documentTrainerPokemon(title: String) {
		
		let fileName = "Trainer Pokemon"
		printg("documenting " + fileName + "...")
		
		var mons = [XGTrainerPokemon]()
		for i in 0 ..< CommonIndexes.NumberOfTrainerPokemonData.value {
			mons.append(XGTrainerPokemon(index: i))
		}
		
		var raw_array = [AnyObject]()
		var hum_array = [AnyObject]()
		
		for mon in mons {
			raw_array.append(mon.dictionaryRepresentation as AnyObject)
			hum_array.append(mon.readableDictionaryRepresentation as AnyObject)
		}
		
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
		var shadowIDs = [String]()
		
		
		for i in 0 ..< mons.count {
			
			let mon = mons[i]
			
			indices.append(String(i))
			hexIndices.append(i.hex())
			names.append((mon.isShadow ? "Shadow " : "") + mon.species.name.string)
			m1s.append(mon.moves[0].name.string)
			m2s.append(mon.moves[1].name.string)
			m3s.append(mon.moves[2].name.string)
			m4s.append(mon.moves[3].name.string)
			levels.append(mon.level.string)
			shadowIDs.append(mon.shadowID.string)
			
		}
		
		let dataRepresentation = [
			
			("Index dec", indices, true),
			("hex", hexIndices, true),
			("Name", names, false),
			("Level", levels, true),
			("Shadow ID", shadowIDs, true),
			("Move 1", m1s, false),
			("Move 2", m2s, false),
			("Move 3", m3s, false),
			("Move 4", m4s, false),
			]
		
		documentData(title: title, data: dataRepresentation)
		
	}
	
	class func documentISO(forXG: Bool) {
		
		let prefix = game == .XD ? (forXG ? "XG " : "XD ") : "Colosseum "
		
		documentTMs()
		documentMoves(title: prefix + "Moves", forXG: false)
		documentAbilities(title: prefix + "Abilities", forXG: false)
		documentPokemarts()
		documentPokemonStats(title: prefix + "Stats", forXG: false)
		documentTrainers(title: prefix + "Trainers", forXG: false)
		documentShadowPokemon(title: prefix + "Shadow Pokemon", forXG: false)
		documentTrainerPokemon(title: prefix + "Trainer Pokemon")
	}
	
}

let TrainerDecksArray : [XGDecks] = [.DeckStory]
enum XGDecks : String {
	
	case DeckStory			= "Story"
	
	var id : Int {
		switch self {
		case .DeckStory:
			return 1
		}
	}
	
	static func deckWithID(_ id: Int) -> XGDecks? {
		return .DeckStory
	}
	
	var file : XGFiles {
		get {
			return .nameAndFolder("", .Documents)
		}
	}
	
	var fileName : String {
		return self.rawValue
	}
	
	var data : XGMutableData {
		get {
			return XGMutableData()
		}
	}
	
	var fileSize : Int {
		return 0
	}
	
	var DDPKEntries : Int {
		return CommonIndexes.NumberOfShadowPokemon.value
	}
	
	var DDPKDataOffset : Int {
		return CommonIndexes.ShadowData.startOffset
	}
	
	var DTNREntries : Int {
		return CommonIndexes.NumberOfTrainers.value
	}
	
	var DTNRDataOffset : Int {
		return CommonIndexes.Trainers.startOffset
	}
	
	var DPKMEntries : Int {
		return CommonIndexes.NumberOfTrainerPokemonData.value
	}
	
	var DPKMDataOffset : Int {
		return CommonIndexes.TrainerPokemonData.startOffset
	}
	
	func addPokemonEntries(count: Int) {
		
	}
	
	func addTrainerEntries(count: Int) {
		
	}
	
	var allTrainers : [XGTrainer] {
		get {
			var tr = [XGTrainer]()
			for i in 1 ..< self.DTNREntries {
				tr.append(XGTrainer(index: i))
			}
			return tr
		}
	}
	
	var allPokemon : [XGTrainerPokemon] {
		get {
			var pokes = [XGTrainerPokemon]()
			for i in 0 ..< self.DPKMEntries {
				pokes.append(XGTrainerPokemon(index: i))
			}
			return pokes
		}
	}
	
	var allActivePokemon : [XGTrainerPokemon] {
		get {
			return allPokemon.filter({ (p) -> Bool in
				return p.species.index > 0
			})
		}
	}
	
	var dictionaryRepresentation: [String : AnyObject] {
		
		var rep : [String : AnyObject] = ["Deck" : self.fileName as AnyObject]
		
		var trainers = [ [String : AnyObject] ]()
		
		for trainer in self.allTrainers {
			trainers.append(trainer.dictionaryRepresentation)
		}
		
		rep["Trainers"] = trainers as AnyObject?
		
		return rep
		
	}
	
	var readableDictionaryRepresentation: [String : AnyObject] {
		var rep : [String : AnyObject] = ["Deck" : self.fileName as AnyObject]
		
		var trainers = [ [String : AnyObject] ]()
		
		for trainer in self.allTrainers {
			trainers.append(trainer.readableDictionaryRepresentation)
		}
		
		rep["Trainers"] = trainers as AnyObject?
		
		return [self.fileName : rep as AnyObject]
	}
	
	
	func trainersString() -> String {
		
		let trainers = self.allTrainers
		var string = self.rawValue + "\n\n\n"
		let trainerLength = 30
		let pokemonLength = 20
		let trainerTab = "".spaceToLength(trainerLength)
		
		for trainer in trainers {
			
			let name = trainer.trainerClass.name
			if name.stringLength > 1 {
				switch name.chars[0] {
				case .special( _, _) : name.chars[0...1] = [name.chars[1]]
				default: break
				}
			}
			
			string += (trainer.index.string + ": " + name.string + " " + trainer.name.string).spaceToLength(trainerLength)
			for p in trainer.pokemon {
				if p.isSet {
					string += ((p.isShadow ? "Shadow " : "") + p.species.name.string).spaceToLength(pokemonLength)
				}
			}
			string += "\n" + "".spaceToLength(trainerLength)
			
			for p in trainer.pokemon {
				if p.isSet {
					string += ("Level " + p.level.string + (p.isShadow ? "+" : "")).spaceToLength(pokemonLength)
				}
			}
			string += "\n" + trainerTab
			
			let mons = trainer.pokemon.map({ (dpoke) -> XGTrainerPokemon in
				return dpoke
			})
			
			for p in mons {
				if p.isSet {
					string += p.item.name.string.spaceToLength(pokemonLength)
				}
			}
			string += "\n" + trainerTab
			
			
			for i in 0 ..< 4 {
				
				for p in mons {
					let moves = p.moves
					if p.isSet {
						string += moves[i].name.string
					}
				}
				
				string += "\n" + trainerTab
			}
			
			
			string += "\n\n"
		}
		
		return string + "\n\n\n\n\n\n"
		
	}
	
	
}

extension XGDolPatcher {
	
	class func deleteBattleModeData() {
		for i in 479 ... 777 {
			XGTrainer(index: i).purge(autoSave: true)
		}
	}
}



























