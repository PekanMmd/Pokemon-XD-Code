//
//  ColosseumExtensions.swift
//  Colosseum Tool
//
//  Created by The Steez on 04/06/2018.
//

import Foundation

enum XGRegions : UInt32 {
	
	case US = 0x47433645 // GC6E
	case EU = 0x47433650 // GC6P
	case JP = 0x4743364A // GC6J

	var name: String {
		switch self {
		case .US: return "US"
		case .EU: return "PAL"
		case .JP: return "JP"
		}
	}
}

class XGMapRel : XGRelocationTable {
	
	var characters = [XGCharacter]()
	var interactionLocations = [XGMapEntryLocation]()
	
	var roomID = 0
	
	override convenience init(file: XGFiles) {
		self.init(file: file, checkScript: true)
	}
	
	init(file: XGFiles, checkScript: Bool) {
		super.init(file: file)
		
		let firstIP = self.getPointer(index: MapRelIndexes.FirstInteractionLocation.rawValue)
		let numberOfIPs = self.getValueAtPointer(index: MapRelIndexes.NumberOfInteractionLocations.rawValue)
		
		for i in 0 ..< numberOfIPs {
			let ip = XGMapEntryLocation(file: file, index: i, startOffset: firstIP + (i * kSizeOfMapEntryLocation))
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
			"D2_present_room.fsys",
			"keydisc.fsys",
			"DNA_key.fsys",
			"title.fsys",
			"world_map.fsys"
		]
	}
	
	var deckList : [String] {
		return [String]()
	}
	
	func extractDecks() { }
	
	func extractSpecificStringTables() {
		
		extractMenuFSYS()
		extractFSYS()
		
		let fightFile = XGFiles.msg("fight")
		if !fightFile.exists {
			if let fight = XGFiles.fsys("fight_common").fsysData.decompressedDataForFileWithFiletype(type: .msg) {
				fight.file = fightFile
				fight.save()
			}
		}
		
		let pocket_menu = XGFiles.msg("pocket_menu")
		let nameentrymenu = XGFiles.msg("name_entry_menu")
		let system_tool = XGFiles.msg("system_tool")
		let pda_menu = XGFiles.msg("pda_menu")
		let p_exchange = XGFiles.msg("p_exchange")
		let world_map = XGFiles.msg("world_map")
		
		if !pocket_menu.exists {
			if let pm = XGFiles.fsys("pocket_menu").fsysData.decompressedDataForFileWithFiletype(type: .msg) {
				pm.file = pocket_menu
				pm.save()
			}
		}
		
		if !nameentrymenu.exists {
			if let nem = XGFiles.fsys("pcbox_name_entry_menu").fsysData.decompressedDataForFileWithFiletype(type: .msg) {
				nem.file = nameentrymenu
				nem.save()
			}
		}
		
		if !system_tool.exists {
			if let st = XGFiles.fsys("pcbox_menu").fsysData.decompressedDataForFileWithFiletype(type: .msg) {
				st.file = system_tool
				st.save()
			}
		}
		
		if !pda_menu.exists {
			if let pda = XGFiles.fsys("pda_menu").fsysData.decompressedDataForFileWithFiletype(type: .msg) {
				pda.file = pda_menu
				pda.save()
			}
		}
		
		if !p_exchange.exists && region != .EU {
			if let pex = XGFiles.fsys("pokemonchange_menu").fsysData.decompressedDataForFileWithFiletype(type: .msg) {
				pex.file = p_exchange
				pex.save()
			}
		}
		
		if !world_map.exists {
			if let wm = XGFiles.fsys("world_map").fsysData.decompressedDataForFileWithFiletype(type: .msg) {
				wm.file = world_map
				wm.save()
			}
		}
	}
}

extension XGUtility {

	class func extractMainFiles() {
		XGISO.extractMainFiles()
	}
	
	class func extractAllFiles() {
		XGISO.extractAllFiles()
	}
	
	class func importFsys() {
		
		printg("importing files to .fsys archives")
		
		ISO.extractFSYS()
		ISO.extractMenuFSYS()
		
		let common = XGFiles.fsys("common").fsysData
		if game == .XD {
			common.shiftAndReplaceFileWithIndexEfficiently(0, withFile: XGFiles.common_rel.compress(), save: true)
		} else {
			common.shiftAndReplaceFileWithIndexEfficiently(0, withFile: XGFiles.common_rel.compress(), save: true)
		}

		let pocketFile = XGFiles.pocket_menu
		if pocketFile.exists {
			XGFiles.fsys("pocket_menu").fsysData.shiftAndReplaceFile(pocketFile.compress(), save: true)
		}

		XGUtility.importSpecificStringTables()
	}
	
	class func prepareForQuickCompilation() {
		importFsys()
	}
	
	class func prepareForCompilation() {
		fixUpTrainerPokemon()
		importFsys()
	}
	
	class func importSpecificStringTables() {
		printg("importing menu string tables")
		
		ISO.extractMenuFSYS()
		
		let pocket_menu = XGFiles.msg("pocket_menu").compress()
		let nameentrymenu = XGFiles.msg("name_entry_menu").compress()
		let system_tool = XGFiles.msg("system_tool").compress()
		let pda_menu = XGFiles.msg("pda_menu").compress()
		let p_exchange = XGFiles.msg("p_exchange").compress()
		let fight = XGFiles.msg("fight").compress()
		
		for file in [pocket_menu, nameentrymenu, system_tool, pda_menu, p_exchange, fight] {
			if !file.exists {
				ISO.extractSpecificStringTables()
				file.compress()
			}
		}
		
		XGFiles.fsys("fight_common").fsysData.shiftAndReplaceFile(fight, save: true)
		XGFiles.fsys("name_entry_menu").fsysData.shiftAndReplaceFile(nameentrymenu, save: true)
		XGFiles.fsys("pcbox_menu").fsysData.shiftAndReplaceFile(system_tool, save: true)
		XGFiles.fsys("pcbox_menu").fsysData.shiftAndReplaceFile(pocket_menu, save: true)
		XGFiles.fsys("pcbox_name_entry_menu").fsysData.shiftAndReplaceFile(nameentrymenu, save: true)
		XGFiles.fsys("pcbox_pocket_menu").fsysData.shiftAndReplaceFile(pocket_menu, save: true)
		XGFiles.fsys("pda_menu").fsysData.shiftAndReplaceFile(pda_menu, save: true)
		XGFiles.fsys("pocket_menu").fsysData.shiftAndReplaceFile(pocket_menu, save: true)
		if region != .EU {
			XGFiles.fsys("pokemonchange_menu").fsysData.shiftAndReplaceFile(system_tool, save: true)
			XGFiles.fsys("pokemonchange_menu").fsysData.shiftAndReplaceFile(pocket_menu, save: true)
			XGFiles.fsys("pokemonchange_menu").fsysData.shiftAndReplaceFile(p_exchange, save: true)
			XGFiles.fsys("pokemonchange_menu").fsysData.shiftAndReplaceFile(system_tool, save: true)
		}
		XGFiles.fsys("title").fsysData.shiftAndReplaceFile(system_tool, save: true)
		XGFiles.fsys("topmenu").fsysData.shiftAndReplaceFile(system_tool, save: true)
		XGFiles.fsys("waza_menu").fsysData.shiftAndReplaceFile(pocket_menu, save: true)
		XGFiles.fsys("colosseumbattle_menu").fsysData.shiftAndReplaceFile(pocket_menu, save: true)
		XGFiles.fsys("colosseumbattle_menu").fsysData.shiftAndReplaceFile(nameentrymenu, save: true)
		XGFiles.fsys("colosseumbattle_menu").fsysData.shiftAndReplaceFile(system_tool, save: true)
	}

	class func importDatToPKX(dat: XGMutableData, pkx: XGMutableData) -> XGMutableData {
		//let gpt1Length = pkx.get4BytesAtOffset(4)
		let start = 0x40
		let pkxHeader = pkx.getCharStreamFromOffset(0, length: start)

		var datData = dat.charStream
		while datData.count % 16 != 0 {
			datData.append(0)
		}

		let oldDatLength = pkx.get4BytesAtOffset(0)
		var oldDatEnd = oldDatLength + 0x40
		while oldDatEnd % 16 != 0 {
			oldDatEnd += 1
		}

		let pkxFooter = pkx.getCharStreamFromOffset(oldDatEnd, length: pkx.length - oldDatEnd)

		let newPKX = XGMutableData(byteStream: pkxHeader + datData + pkxFooter, file: pkx.file)
		newPKX.replace4BytesAtOffset(0, withBytes: dat.length)
		return newPKX
	}

	class func exportDatFromPKX(pkx: XGMutableData) -> XGMutableData {
		//let gpt1Length = pkx.get4BytesAtOffset(4)
		let length = pkx.get4BytesAtOffset(0)
		let start = 0x40
		let charStream = pkx.getCharStreamFromOffset(start, length: length)
		let filename = pkx.file.fileName.removeFileExtensions() + ".dat"
		return XGMutableData(byteStream: charStream, file: .nameAndFolder(filename, pkx.file.folder))

	}
	
	//MARK: - Release configuration
	
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
	class func documentXDS() { }
	class func documentMacrosXDS() { }
	class func documentXDSClasses() { }
	class func documentXDSAutoCompletions(toFile file: XGFiles) { }
	
	class func documentISO() {
		
	}

	class func encodeISO() {
		
	}

	class func decodeISO() {

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
	
	class func tutorMovesAvailableImmediately() { }
}

extension XGRoom {
	var script : XGScript? {
		return XGScript(file: .scd(self.name))
	}
}

























