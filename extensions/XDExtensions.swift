//
//  XDExtensions.swift
//  Colosseum Tool
//
//  Created by The Steez on 04/06/2018.
//

import Foundation


extension XGUtility {
	
	class func updateHealingItems() {
		guard region != .OtherGame else {
			return
		}
		let kBattleItemDataStartOffset: Int
		switch region {
		case .US: kBattleItemDataStartOffset = 0x402570
		case .EU: kBattleItemDataStartOffset = 0x43CE50
		case .JP: kBattleItemDataStartOffset = 0x3DFC30
		case .OtherGame: kBattleItemDataStartOffset = 0
		}
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
		guard region != .OtherGame else {
			return
		}

		let kFunctionalItemDataStartOffset: Int
		switch region {
		case .US: kFunctionalItemDataStartOffset = 0x402570
		case .EU: kFunctionalItemDataStartOffset = 0x43CE50
		case .JP: kFunctionalItemDataStartOffset = 0x3DFC30
		case .OtherGame: kFunctionalItemDataStartOffset = 0
		}

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
		if let rel = XGFiles.common_rel.data {

			printg("Updating items list...")

			for i in 1 ..< CommonIndexes.NumberOfItems.value {
				let currentOffset = itemListStart + (i * 2)

				if XGItems.index(i).nameID != 0 {
					rel.replace2BytesAtOffset(currentOffset, withBytes: i)
				} else {
					rel.replace2BytesAtOffset(currentOffset, withBytes: 0)
				}
			}

			rel.save()
		}
	}
	
	class func updateShadowMoves() {
		if let rel = XGFiles.common_rel.data {
			for i in 0 ..< kNumberOfMoves {

				let m = XGMoves.index(i).data
				if m.isShadowMove {
					rel.replaceWordAtOffset(m.startOffset + 0x14, withBytes: 0x00023101)
				}

			}
			rel.save()
		}
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

	class func copyDDPKToCommon() {
		let deckFolder = XGFiles.fsys("deck_archive").folder
		let commonFolder = XGFiles.fsys("common").folder
		if deckFolder.exists {
			for file in deckFolder.files where file.fileName.contains("DeckData_DarkPokemon") {
				if let data = file.data {
					data.file = .nameAndFolder(file.fileName, commonFolder)
					data.save()
				}
			}
		}
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
		copyDDPKToCommon()
		filesTooLargeForReplacement = nil
	}
	
	class func renameZaprong(newName: String) {
		guard region != .OtherGame else { return }
		let offset: Int
		switch region {
		case .US: offset = 0x420904
		case .JP: offset = 0x3FD738
		case .EU: offset = 0x45B304
		case .OtherGame: offset = 0
		}
		if let dol = XGFiles.dol.data {
			dol.replaceBytesFromOffset(offset, withByteStream: newName.unicodeRepresentation)
			dol.save()
		}
	}

	class func getPotentialMewTutorMovePairs() -> [(move1: XGMoves, move2: XGMoves)] {
		guard region == .US else { return [] }

		let startOffset = 0x4198fc
		let endOffset = startOffset + 0x1d4
		guard let dol = XGFiles.dol.data else {
			return []
		}

		var currentOffset = startOffset
		var pairs = [(move1: XGMoves, move2: XGMoves)]()

		while currentOffset < endOffset {
			let move1 = XGMoves.index(dol.get2BytesAtOffset(currentOffset + 4))
			let move2 = XGMoves.index(dol.get2BytesAtOffset(currentOffset + 6))
			pairs.append((move1: move1, move2: move2))
			currentOffset += 12
		}

		return pairs
	}

	class func saveMewTutorMovePairs() {
		let moves = getPotentialMewTutorMovePairs()
		var s = "XD Mew Tutor Move Pairs:\t\(moves.count) pairs\n\n"
		for (m1, m2) in moves {
			s += "\(m1), \(m2)\n"
		}

		saveString(s, toFile: .nameAndFolder("Mew Tutor Moves.txt", .Reference))
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
				let evo = XGPokemon.index(e.evolvesInto)
				pokes.append(evo)
				for ev in XGPokemonStats(index: evo.index).evolutions {
					let evol = XGPokemon.index(ev.evolvesInto)
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
		var s = "XD Obtainable Pokemon:\t\(k.count)\n"
		for p in k {
			s += "\(p.index):\t\(p)\n"
		}
		
		saveString(s, toFile: .nameAndFolder("obtainable pokemon.txt",.Reference))
	}
	
	class func saveObtainablePokemonByLocation() {
		
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
		
		saveString(string, toFile: XGFiles.nameAndFolder("Obtainable Pokemon List.txt", XGFolders.Reference))
	}
	
	
	class func updateShadowMonitor() {
		guard region != .OtherGame else {
			return
		}
		
		printg("updating shadow monitor")
		
		let start: Int
		switch region {
		case .US: start = 0x4014EA
		case .JP: start = 0x3DEBAA
		case .EU: start = 0x4014EA
		case .OtherGame: start = 0
		}
		
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

		guard region != .OtherGame else {
			return
		}
		
		printg("updating tutor moves")
		
		let dol = XGFiles.dol.data!

		let firstUSOffset = 0x1C2EA6
		let firstOffset: Int
		switch region {
		case .US: firstOffset = firstUSOffset
		case .JP: firstOffset = 0x1BE3B6
		case .EU: firstOffset = 0x1C47A2
		case .OtherGame: firstOffset = 0
		}

		let offsetDifference = firstOffset - firstUSOffset
		
		let offsets = [
			0x1C2EA6, // 4
			0x1C2EB2, // 5
			0x1C2EBE, // 1
			0x1C2ECA, // 0
			0x1C2ED6, // 2
			0x1C2EE2, // 10
			0x1C2EEE, // 3
			0x1C2EFA, // 11
			0x1C2F06, // 6
			0x1C2F12, // 9
			0x1C2F1E, // 8
			0x1C2F2A, // 7
		]
		
		for i in 1...12 {
			let tmove = XGTMs.tutor(i).move
			let offset = offsets[i-1] + offsetDifference
			
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
		printg("updating duking trades script")

		let filename = "M2_guild_1F_2"
		let scriptFile = XGFiles.typeAndFsysName(.scd, filename)
		if !scriptFile.exists {
			let scriptFsysFile = XGFiles.fsys(filename)
			XGUtility.exportFileFromISO(scriptFsysFile, decode: false)
		}
		if scriptFile.exists, scriptFile.fileSize == 0x1770, let script = scriptFile.data {

			let trapinches = [0x0B4A,0x0D1E]
			let surskits = [0x0B9A,0x0D62]
			let woopers = [0x0BEA,0x0DA6]

			let trapinch = XGPokeSpotPokemon(index: 2, pokespot: .rock).pokemon
			let surskit = XGPokeSpotPokemon(index: 2, pokespot: .oasis).pokemon
			let wooper = XGPokeSpotPokemon(index: 2, pokespot: .cave).pokemon

			for offset in trapinches {
				script.replace2BytesAtOffset(offset, withBytes: trapinch.index)
			}

			for offset in surskits {
				script.replace2BytesAtOffset(offset, withBytes: surskit.index)
			}

			for offset in woopers {
				script.replace2BytesAtOffset(offset, withBytes: wooper.index)
			}

			script.replace2BytesAtOffset(0x0D3A, withBytes: trapinch.nameID)
			script.replace2BytesAtOffset(0x1756, withBytes: trapinch.nameID)


			script.replace2BytesAtOffset(0x0D7E, withBytes: surskit.nameID)
			script.replace2BytesAtOffset(0x175E, withBytes: surskit.nameID)


			script.replace2BytesAtOffset(0x0DC2, withBytes: wooper.nameID)
			script.replace2BytesAtOffset(0x1766, withBytes: wooper.nameID)


			let meditite = XGTradePokemon(index: 1).species.nameID
			let shuckle = XGTradePokemon(index: 2).species.nameID
			let larvitar = XGTradePokemon(index: 3).species.nameID

			script.replace2BytesAtOffset(0x0D32, withBytes: meditite)
			script.replace2BytesAtOffset(0x0D76, withBytes: shuckle)
			script.replace2BytesAtOffset(0x0DBA, withBytes: larvitar)


			script.save()
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
	
	class func documentMacrosXDS() {
		
		printg("documenting script macros...")
		printg("This may take a while :-)")
		
		var text = ""
		
		func addMacro(value: Int, type: XDSMacroTypes) {
			let constant = XDSConstant.integer(value)
			text += "define \(XDSExpr.stringFromMacroImmediate(c: constant, t: type)) \(constant.rawValueString)\n"
		}
		
		for i in 0 ..< CommonIndexes.NumberOfPokemon.value {
			if i == 0 || XGPokemon.index(i).nameID > 0 {
				addMacro(value: i, type: .pokemon)
			}
		}
		for i in 0 ..< CommonIndexes.NumberOfMoves.value {
			if i == 0 || XGMoves.index(i).nameID > 0 {
				addMacro(value: i, type: .move)
			}
		}
		
		for i in 0 ..< CommonIndexes.TotalNumberOfItems.value {
			if i == 0 || (XGItems.index(i).scriptIndex == i && XGItems.index(i).nameID > 0) {
				addMacro(value: i, type: .item)
			}
		}
		
		for i in 0 ..< kNumberOfAbilities {
			if i == 0 || XGAbilities.index(i).nameID > 0 {
				addMacro(value: i, type: .ability)
			}
		}

		for i in 0 ..< kNumberOfGiftPokemon {
			addMacro(value: i, type: .giftPokemon)
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
		
		for i in 0 ..< CommonIndexes.NumberOfSounds.value {
			let sound = XGMusicMetaData(index: i)
			if sound.sfxID == 0 {
				let music = sound.music
				if music.ishID == 0 && music.isdID == 0 && music.fsysID != 0 {
					addMacro(value: i, type: .sfxID)
				}
			}
		}

		for storyProgress in XGStoryProgress.allCases {
			addMacro(value: storyProgress.rawValue, type: .storyProgress)
		}
		
		// get macros.xds
		// file containing common macros to use as reference
		if text.length > 0 {
			let file = XGFiles.nameAndFolder("Common Macros.xds", .Reference)
			printg("writing script ", file.fileName, "to:", file.path)
			text.save(toFile: file)
		}
		
	}
	
	class func documentXDSClasses() {
		printg("documenting script classes...")
		var text = ""
		var classes = [(id: Int, name: String)]()
		XGScript.loadCustomClasses()
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
			let file = XGFiles.nameAndFolder("Classes.xds", .Reference)
			printg("writing script ", file.fileName, "to:", file.path)
			text.save(toFile: file)
		}
		
	}
	
	class func documentXDSAutoCompletions(toFile file: XGFiles) {
		printg("Documenting XDS Autocompletions")
		var json = [String : AnyObject]()
		json["scope"] = "xdscript" as AnyObject
		var completions = [ [String: String] ]()

		XGScript.loadCustomClasses()
		for (id, name) in ScriptClassNames {
			
			if id != 0 {
				var plainTextCompletion = [String : String]()
				plainTextCompletion["trigger"] = name + "\t\(name) Class"
				plainTextCompletion["contents"] = name
				completions.append(plainTextCompletion)
			}
			
			guard let functions = ScriptClassFunctions[id] else {
				continue
			}
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
			let item = XGItems.index(i)
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
		
		for i in 0 ..< CommonIndexes.NumberOfSounds.value {
			let sound = XGMusicMetaData(index: i)
			if sound.sfxID == 0 {
				let music = sound.music
				if music.ishID == 0 && music.isdID == 0 && music.fsysID != 0 {
					macros.append(.macroImmediate(XDSConstant.integer(i), .sfxID))
				}
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
	
	private static var isDocumentingISO = false
	private static var shouldCancelDocumentation = false
	static func cancelDocumentation() {
		shouldCancelDocumentation = true
	}
	class func documentISO() {
		
		guard !isDocumentingISO else {
			printg("Already Documenting ISO!")
			return
		}

		isDocumentingISO = true
		shouldCancelDocumentation = false

		printg("Documenting ISO.\nThis may take a while...")
		XGThreadManager.manager.runInBackgroundAsync {
			printg("Documenting Enumerations...")
			// Enumerations
			if !shouldCancelDocumentation {
				printg("Enumerating Abilities...")
				XGAbilities.documentEnumerationData()
				XGAbilities.documentData()
			}
			if !shouldCancelDocumentation {
				printg("Enumerating Battles...")
				XGBattle.documentEnumerationData()
			}
			if !shouldCancelDocumentation {
				printg("Enumerating Character Models...")
				XGCharacterModel.documentEnumerationData()
			}
			if !shouldCancelDocumentation {
				printg("Enumerating B-G Enumerations...")
				XGBagSlots.documentEnumerationData()
				XGBattleBingoCard.documentEnumerationData()
				XGBattleBingoCard.documentData()
				XGBattleField.documentEnumerationData()
				XGBattleTypes.documentEnumerationData()
				XGBattleStyles.documentEnumerationData()
				XGColosseumRounds.documentEnumerationData()
				XGDecks.documentEnumerationData()
				XGDeoxysFormes.documentEnumerationData()
				XGEffectivenessValues.documentEnumerationData()
				XGEvolutionMethods.documentEnumerationData()
				XGExpRate.documentEnumerationData()
				XGGenderRatios.documentEnumerationData()
				XGGenders.documentEnumerationData()
			}
			if !shouldCancelDocumentation {
				printg("Enumerating Gift Pokemon...")
				XGStarterPokemon.documentEnumerationData()
				XGStarterPokemon.documentData()
				XGDemoStarterPokemon.documentEnumerationData()
				XGDemoStarterPokemon.documentData()
				CMGiftPokemon.documentEnumerationData()
				CMGiftPokemon.documentData()
				XGTradeShadowPokemon.documentEnumerationData()
				XGTradeShadowPokemon.documentData()
				XGTradePokemon.documentEnumerationData()
				XGTradePokemon.documentData()
				XGMtBattlePrizePokemon.documentEnumerationData()
				XGMtBattlePrizePokemon.documentData()
			}
			if !shouldCancelDocumentation {
				printg("Enumerating Items...")
				XGItems.documentEnumerationData()
				XGItem.documentData()
			}
			if !shouldCancelDocumentation {
				printg("Enumerating Moves...")
				XGMoves.documentEnumerationData()
				XGMove.documentData()
			}
			if !shouldCancelDocumentation {
				printg("Enumerating M-N Enumerations...")
				XGMaps.documentEnumerationData()
				XGMoveCategories.documentEnumerationData()
				XGMoveEffectTypes.documentEnumerationData()
				XGMoveTargets.documentEnumerationData()
				XGMoveTypes.documentEnumerationData()
				XGNatures.documentEnumerationData()
			}
			if !shouldCancelDocumentation {
				printg("Enumerating Pokemon...")
				XGPokemon.documentEnumerationData()
				XGPokemonStats.documentData()
			}
			if !shouldCancelDocumentation {
				printg("Enumerating Pokespot Encounters...")
				XGPokeSpotPokemon.documentEnumerationData()
				XGPokeSpotPokemon.documentData()
			}
			if !shouldCancelDocumentation {
				printg("Enumerating P-S Enumerations...")
				XGPokeSpots.documentEnumerationData()
				XGShinyValues.documentEnumerationData()
				XGStats.documentEnumerationData()
				XGStatusEffects.documentEnumerationData()
			}
			if !shouldCancelDocumentation {
				printg("Enumerating Rooms...")
				XGRoom.documentEnumerationData()
			}
			if !shouldCancelDocumentation {
				printg("Enumerating Treasure...")
				XGTreasure.documentEnumerationData()
			}
			if !shouldCancelDocumentation {
				printg("Enumerating T-W Enumerations...")
				XGTMs.documentEnumerationData()
				XGTrainerClasses.documentEnumerationData()
				XGTrainerModels.documentEnumerationData()
				XGWeather.documentEnumerationData()
			}
			// Documents
			if !shouldCancelDocumentation {
				printg("Documenting data...")
			}
			if !shouldCancelDocumentation {
				printg("Documenting obtainable pokemon...")
				saveObtainablePokemonByLocation()
			}
			
			if !shouldCancelDocumentation {
				printg("Finished Documenting ISO. Output can be found in \(XGFolders.Reference.path)")
			} else {
				printg("Cancelled Documenting ISO.")
			}
			isDocumentingISO = false
		}
			
	}
	
	private static var isEncodingISO = false
	private static var shouldCancelEncoding = false
	static func cancelEncoding() {
		shouldCancelEncoding = true
	}
	/*
	class func encodeISO() {
		
		guard !isEncodingISO else {
			printg("Already Encoding ISO!")
			return
		}
		
		isEncodingISO = true
		shouldCancelEncoding = false

		printg("Encoding ISO.\nThis may take a while...")
		XGThreadManager.manager.runInBackgroundAsync {
			if !shouldCancelEncoding {
				printg("Encoding Abilities...")
				XGAbilities.encodeData(filename: { (value) -> String in
					(value as? XGAbilities)?.index.string ?? "-"
				})
			}
			if !shouldCancelEncoding {
				printg("Encoding Trainers...")
				
				for deck in TrainerDecksArray {
					for trainer in deck.allTrainers {
						if !shouldCancelEncoding {
							trainer.writeJSON(to: .nameAndFolder(trainer.deck.rawValue + " " + trainer.index.string + ".json", XGTrainer.encodedDataFolder()))
						}
					}
				}
			}
			if !shouldCancelEncoding {
				printg("Encoding TMs and Tutor Moves...")
				XGTMs.encodeData(filename: { (value) -> String in
					if let value = (value as? XGTMs) {
						switch value {
						case .tm(let i): return "TM \(i)"
						case .tutor(let i): return "Tutor \(i)"
						}
					}
					return "-"
				})
				saveMewTutorMovePairs()
			}
			if !shouldCancelEncoding {
				printg("Encoding Battle Bingo Cards...")
				XGBattleBingoCard.encodeData(filename: { (value) -> String in
					(value as? XGBattleBingoCard)?.index.string ?? "-"
				})
			}
			if !shouldCancelEncoding {
				printg("Encoding Battles...")
				XGBattle.encodeData(filename: { (value) -> String in
					(value as? XGBattle)?.index.string ?? "-"
				})
			}
			if !shouldCancelEncoding {
				printg("Encoding Character Models...")
				XGCharacterModel.encodeData(filename: { (value) -> String in
					(value as? XGCharacterModel)?.index.string ?? "-"
				})
			}
			if !shouldCancelEncoding {
				printg("Encoding Gift Pokemon...")
				XGDemoStarterPokemon.encodeData(filename: { (value) -> String in
					(value as? XGDemoStarterPokemon)?.index.string ?? "-"
				})
				XGStarterPokemon.encodeData(filename: { (value) -> String in
					(value as? XGStarterPokemon)?.index.string ?? "-"
				})
				CMGiftPokemon.encodeData(filename: { (value) -> String in
					(value as? CMGiftPokemon)?.index.string ?? "-"
				})
				XGTradePokemon.encodeData(filename: { (value) -> String in
					(value as? XGTradePokemon)?.index.string ?? "-"
				})
				XGTradeShadowPokemon.encodeData(filename: { (value) -> String in
					(value as? XGTradeShadowPokemon)?.index.string ?? "-"
				})
				XGMtBattlePrizePokemon.encodeData(filename: { (value) -> String in
					(value as? XGMtBattlePrizePokemon)?.index.string ?? "-"
				})
			}
			if !shouldCancelEncoding {
				printg("Encoding Doors...")
				XGDoor.encodeData(filename: { (value) -> String in
					(value as? XGDoor)?.index.string ?? "-"
				})
			}
			if !shouldCancelEncoding {
				printg("Encoding Interaction Points...")
				XGInteractionPointData.encodeData(filename: { (value) -> String in
					(value as? XGInteractionPointData)?.index.string ?? "-"
				})
			}
			if !shouldCancelEncoding {
				printg("Encoding Items...")
				XGItem.encodeData(filename: { (value) -> String in
					(value as? XGItem)?.index.string ?? "-"
				})
			}
			if !shouldCancelEncoding {
				printg("Encoding Moves...")
				XGMove.encodeData(filename: { (value) -> String in
					(value as? XGMove)?.moveIndex.string ?? "-"
				})
			}
			if !shouldCancelEncoding {
				printg("Encoding Music...")
				XGMusic.encodeData(filename: { (value) -> String in
					(value as? XGMusic)?.index.string ?? "-"
				})
			}
			if !shouldCancelEncoding {
				printg("Encoding Pokemarts...")
				XGPokemart.encodeData(filename: { (value) -> String in
					(value as? XGPokemart)?.index.string ?? "-"
				})
			}
			if !shouldCancelEncoding {
				printg("Encoding Pokemon Stats...")
				XGPokemonStats.encodeData(filename: { (value) -> String in
					(value as? XGPokemonStats)?.index.string ?? "-"
				})
			}
			if !shouldCancelEncoding {
				printg("Encoding Pokespot Encounters...")
				XGPokeSpotPokemon.encodeData(filename: { (value) -> String in
					if let value = value as? XGPokeSpotPokemon {
						return value.spot.string + " " + value.index.string
					}
					return "-"
				})
			}
			if !shouldCancelEncoding {
				printg("Encoding Rooms...")
				XGRoom.encodeData(filename: { (value) -> String in
					(value as? XGRoom)?.index.string ?? "-"
				})
			}
			if !shouldCancelEncoding {
				printg("Encoding Trainer Classes...")
				XGTrainerClass.encodeData(filename: { (value) -> String in
					(value as? XGTrainerClass)?.index.string ?? "-"
				})
			}
			if !shouldCancelEncoding {
				printg("Encoding Treasure...")
				XGTreasure.encodeData(filename: { (value) -> String in
					(value as? XGTreasure)?.index.string ?? "-"
				})
			}
			if !shouldCancelEncoding {
				printg("Encoding Types...")
				XGType.encodeData(filename: { (value) -> String in
					(value as? XGType)?.index.string ?? "-"
				})
				// if we're in here then it's too late to cancel anyway
				shouldCancelEncoding = false
			}
			
			if !shouldCancelEncoding {
				printg("Finished Encoding ISO. Output can be found at \(XGFolders.nameAndFolder("Raw Data", .Reference).path)")
			} else {
				printg("Cancelled Encoding ISO.")
			}
			isEncodingISO = false
		}
		
	}
	*/
	
	private static var isDecodingISO = false
	private static var shouldCancelDecoding = false
	static func cancelDecoding() {
		shouldCancelDecoding = true
	}
	/*
	class func decodeISO() {
		
		guard !isDecodingISO else {
			printg("Already Decoding ISO!")
			return
		}
		
		isDecodingISO = true
		shouldCancelDecoding = false

		printg("Decoding ISO.\nThis may take a while...")
		XGThreadManager.manager.runInBackgroundAsync {
			if !shouldCancelDecoding {
				printg("Decoding Trainers...")
				for file in XGTrainer.decodedJSONFiles() {
					do {
						try XGTrainer.fromJSON(file: file).save()
					} catch {
						printg("Failed to decode file:", file.path)
					}
				}
			}
			if !shouldCancelDecoding {
				printg("Decoding Battle Bingo Cards...")
				for file in XGBattleBingoCard.decodedJSONFiles() {
					do {
						try XGBattleBingoCard.fromJSON(file: file).save()
					} catch {
						printg("Failed to decode file:", file.path)
					}
				}
			}
			if !shouldCancelDecoding {
				printg("Decoding Battles...")
				for file in XGBattle.decodedJSONFiles() {
					do {
						try XGBattle.fromJSON(file: file).save()
					} catch {
						printg("Failed to decode file:", file.path)
					}
				}
			}
			if !shouldCancelDecoding {
				printg("Decoding Character Models...")
				for file in XGCharacterModel.decodedJSONFiles() {
					do {
						try XGCharacterModel.fromJSON(file: file).save()
					} catch {
						printg("Failed to decode file:", file.path)
					}
				}
			}
			if !shouldCancelDecoding {
				printg("Decoding Gift Pokemon...")
				for file in XGDemoStarterPokemon.decodedJSONFiles() {
					do {
						try XGDemoStarterPokemon.fromJSON(file: file).save()
					} catch {
						printg("Failed to decode file:", file.path)
					}
				}
				for file in XGStarterPokemon.decodedJSONFiles() {
					do {
						try XGStarterPokemon.fromJSON(file: file).save()
					} catch {
						printg("Failed to decode file:", file.path)
					}
				}
				for file in CMGiftPokemon.decodedJSONFiles() {
					do {
						try CMGiftPokemon.fromJSON(file: file).save()
					} catch {
						printg("Failed to decode file:", file.path)
					}
				}
				for file in XGTradePokemon.decodedJSONFiles() {
					do {
						try XGTradePokemon.fromJSON(file: file).save()
					} catch {
						printg("Failed to decode file:", file.path)
					}
				}
				for file in XGTradeShadowPokemon.decodedJSONFiles() {
					do {
						try XGTradeShadowPokemon.fromJSON(file: file).save()
					} catch {
						printg("Failed to decode file:", file.path)
					}
				}
				for file in XGMtBattlePrizePokemon.decodedJSONFiles() {
					do {
						try XGMtBattlePrizePokemon.fromJSON(file: file).save()
					} catch {
						printg("Failed to decode file:", file.path)
					}
				}
			}
			if !shouldCancelDecoding {
				printg("Decoding Doors...")
				for file in XGDoor.decodedJSONFiles() {
					do {
						try XGDoor.fromJSON(file: file).save()
					} catch {
						printg("Failed to decode file:", file.path)
					}
				}
			}
			if !shouldCancelDecoding {
				printg("Decoding Interaction Points...")
				for file in XGInteractionPointData.decodedJSONFiles() {
					do {
						try XGInteractionPointData.fromJSON(file: file).save()
					} catch {
						printg("Failed to decode file:", file.path)
					}
				}
			}
			if !shouldCancelDecoding {
				printg("Decoding Items...")
				for file in XGItem.decodedJSONFiles() {
					do {
						try XGItem.fromJSON(file: file).save()
					} catch {
						printg("Failed to decode file:", file.path)
					}
				}
			}
			if !shouldCancelDecoding {
				printg("Decoding Moves...")
				for file in XGMove.decodedJSONFiles() {
					do {
						try XGMove.fromJSON(file: file).save()
					} catch {
						printg("Failed to decode file:", file.path)
					}
				}
			}
			if !shouldCancelDecoding {
				printg("Decoding Pokemarts...")
				for file in XGPokemart.decodedJSONFiles() {
					do {
						try XGPokemart.fromJSON(file: file).save()
					} catch {
						printg("Failed to decode file:", file.path)
					}
				}
			}
			if !shouldCancelDecoding {
				printg("Decoding Pokemon Stats...")
				for file in XGPokemonStats.decodedJSONFiles() {
					do {
						try XGPokemonStats.fromJSON(file: file).save()
					} catch {
						printg("Failed to decode file:", file.path)
					}
				}
			}
			if !shouldCancelDecoding {
				printg("Decoding Pokespot Encounters...")
				for file in XGPokeSpotPokemon.decodedJSONFiles() {
					do {
						try XGPokeSpotPokemon.fromJSON(file: file).save()
					} catch {
						printg("Failed to decode file:", file.path)
					}
				}
			}
			if !shouldCancelDecoding {
				printg("Decoding Trainer Classes...")
				for file in XGTrainerClass.decodedJSONFiles() {
					do {
						try XGTrainerClass.fromJSON(file: file).save()
					} catch {
						printg("Failed to decode file:", file.path)
					}
				}
			}
			if !shouldCancelDecoding {
				printg("Decoding Treasure...")
				for file in XGTreasure.decodedJSONFiles() {
					do {
						try XGTreasure.fromJSON(file: file).save()
					} catch {
						printg("Failed to decode file:", file.path)
					}
				}
			}
			if !shouldCancelDecoding {
				printg("Decoding Types...")
				for file in XGType.decodedJSONFiles() {
					do {
						try XGType.fromJSON(file: file).save()
					} catch {
						printg("Failed to decode file:", file.path)
					}
				}
				// if we're in here then it's too late to cancel anyway
				shouldCancelDecoding = false
			}
			
			if !shouldCancelDecoding {
				printg("Finished Decoding ISO.")
			} else {
				printg("Cancelled Decoding ISO.")
			}
			isDecodingISO = false
		}
		
	}
	*/
	
	//MARK: - Model Utilities
	class func importDatToPKX(dat: XGMutableData, pkx: XGMutableData) -> XGMutableData {
		var gpt1Length = pkx.get4BytesAtOffset(8)
		while gpt1Length % 0x20 != 0 {
			gpt1Length += 1
		}

		var start = 0xE60
		if gpt1Length > 0 && pkx.getWordAtOffset(0xe60) == 0x47505431 /*GPT1 magic*/ {
			start += gpt1Length + 4
		}
		let pkxHeader = pkx.getCharStreamFromOffset(0, length: start)
		
		let newPKX = XGMutableData(byteStream: pkxHeader + dat.charStream, file: pkx.file)
		newPKX.replace4BytesAtOffset(0, withBytes: dat.length)
		while newPKX.length % 16 != 0 {
			newPKX.appendBytes([0])
		}
		return newPKX
	}

	class func exportDatFromPKX(pkx: XGMutableData) -> XGMutableData {

		let length = pkx.get4BytesAtOffset(0)
		var gpt1Length = pkx.get4BytesAtOffset(8)
		while gpt1Length % 0x20 != 0 {
			gpt1Length += 1
		}
		var start = 0xE60
		if gpt1Length > 0 && pkx.getWordAtOffset(0xe60) == 0x47505431 /*GPT1 magic*/ {
			start += gpt1Length + 4
		}
		let charStream = pkx.getCharStreamFromOffset(start, length: length)
		let filename = pkx.file.fileName.removeFileExtensions() + ".dat"
		return XGMutableData(byteStream: charStream, file: .nameAndFolder(filename, pkx.file.folder))

	}
	
	class func copyOWPokemonIdleAnimationFromIndex(index: Int, forModel file: XGFiles) {
		copyPokemonModelAnimationFromIndex(index: index, toIndex: 0, forModel: file)
	}
	
	class func copyPokemonModelAnimationFromIndex(index: Int, toIndex to: Int, forModel file: XGFiles, backUp: Bool = false) {
		// almost always index 0 holds the idle animation
		// for overworld need to copy that to index 3
		let data = file.data!
		if backUp {
			let backup = file.data!
			backup.file = .nameAndFolder(file.fileName + ".bak", file.folder)
			backup.save()
		}
		
		let pkxHeaderSize = file.fileType == .pkx ? 0xe60 : 0
		let headerSize = 0x20 + pkxHeaderSize
		let pointerListPointer = data.getWordAtOffset(4 + pkxHeaderSize).int + headerSize
		let numberOfPointers = data.getWordAtOffset(8 + pkxHeaderSize).int
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
		
		data.replaceWordAtOffset(animation0Pointer + (to * 4), withBytes: animationOffsets[index])
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
		let offset = 0x1faf50 - kDolToRAMOffsetDifference
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
	class func getItemLocations() -> [[String]] {
		var locations = [[String]]()
		for _ in 0 ..< CommonIndexes.NumberOfItems.value {
			locations.append([String]())
		}
		
		for i in 0 ..< CommonIndexes.NumberTreasureBoxes.value {
			let treasure = XGTreasure(index: i)
			if let mapName = treasure.room?.map.name {
				locations[treasure.item.index].addUnique(mapName)
			}
		}

		for folder in XGFolders.ISOExport("").subfolders {
			for s in folder.files where s.fileType == .scd {
				let script = s.scriptData
				let map = (XGMaps(rawValue: s.fileName.substring(from: 0, to: 2)) ?? .Unknown).name

				for item in script.getItems() {
					locations[item.index].addUnique(map)
				}
			}
		}
		return locations
	}

	class func documentItemsByLocation() -> String {
		var locations = [String: [XGItems]]()

		for i in 0 ..< CommonIndexes.NumberTreasureBoxes.value {
			let treasure = XGTreasure(index: i)
			if treasure.item.index > 0 {
				if let map = treasure.room?.map.name {
					var items = locations[map] ?? [XGItems]()
					items.addUnique(treasure.item)
					locations[map] = items
				}
			}
		}

		for folder in XGFolders.ISOExport("").subfolders {
			for s in folder.files where s.fileType == .scd {
				let script = s.scriptData
				let map = (XGMaps(rawValue: s.fileName.substring(from: 0, to: 2)) ?? .Unknown).name
				var items = locations[map] ?? [XGItems]()

				for item in script.getItems() where item.index > 0 {
					items.addUnique(item)
				}

				locations[map] = items
			}
		}

		var text = "XD items by location\n"

		let keys = locations.keys.sorted()
		for key in keys {
			if let items = locations[key] {
				text += "\n\n" + key + ":"
				for item in items.sorted(by: { (i1, i2) -> Bool in
					i1.index < i2.index
				}) {
					text += "\n  " + item.name.string
				}
			}
		}

		return text
	}
	
	class func getTMLocations() -> [(tm:XGTMs, locations:[String])] {
		let locations = getItemLocations()
		var tmLocations = [(XGTMs,[String])]()
		
		let firstIndex = XGTMs.tm(1).item.index
		for i in firstIndex ..< firstIndex + kNumberOfTMsAndHMs {
			let tm = XGTMs.tm(i - firstIndex + 1)
			tmLocations.append((tm, locations[i]))
		}
		
		return tmLocations
	}
}



















