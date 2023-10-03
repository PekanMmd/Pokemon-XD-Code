//
//  XGRandomiser.swift
//  GoD Tool
//
//  Created by The Steez on 15/09/2018.
//

import Foundation

class XGRandomiser: NSObject {

	#if GAME_XD
	class func randomiseBattleBingo() {
		printg("Randomising battle bingo...")
		for i in 0 ..< kNumberOfBingoCards {
			let card = XGBattleBingoCard(index: i)
			let starter = card.startingPokemon!
			starter.species = XGPokemon.random()

			let moves = starter.species.movesForLevel(card.pokemonLevel)
			starter.move = moves.first(where: { $0.data.basePower > 0 })
				?? starter.species.stats.levelUpMoves.first(where: { $0.move.data.basePower > 0 })?.move
				?? (moves.count > 0 ? moves[0] : XGMoves.randomDamaging())
			starter.save()
			
			for panel in card.panels {
				if let pokemon = panel.pokemon {
					pokemon.species = XGPokemon.random()

					let moves = pokemon.species.movesForLevel(card.pokemonLevel)
					pokemon.move = moves.first(where: { $0.data.basePower > 0 })
						?? pokemon.species.stats.levelUpMoves.first(where: { $0.move.data.basePower > 0 })?.move
						?? (moves.count > 0 ? moves[0] : XGMoves.randomDamaging())
					pokemon.save()
				}
			}
		}
		printg("done!")
	}
	#endif
	
	class func randomisePokemon(includeStarters: Bool = true, includeObtainableMons: Bool = true, includeUnobtainableMons: Bool = true, similarBST: Bool = false) {
		printg("Randomising pokemon species...")

		var cachedPokemonStats = XGPokemon.allPokemon().map{$0.stats}.filter{$0.catchRate > 0}
		#if GAME_PBR
		if let eggId = cachedPokemonStats.first(where: { stats in
			stats.index > 1 && stats.nameID == 10
		})?.index {
			cachedPokemonStats = cachedPokemonStats.filter{$0.index < eggId}
		}
		#endif
		var speciesAlreadyUsed = [Int]()
		var shadowPokemonByID = [Int: XGPokemon]()

		func strikeEvolutionLineForPokemon(index: Int) {
			// strikes all preevolutions and all evolution
			// but doesn't strike alternate evolution branches from preevo
			// so those mons are still obtainable
			// e.g. striking wurmple strikes both branches
			// but striking silcoon, keeps the cascoon branch possible
			// only checks for 2 layers of preevos and 2 layers of evos
			// to prevent endless loops on edited versions with evolution loops.
			// If multiple pokemon evolve into this pokemon in an edited version
			// then only the first one found will be stricken

			speciesAlreadyUsed.addUnique(index)

			if let preEvo = cachedPokemonStats.first(where: { pokemon in
				pokemon.evolutions.contains(where: { evolution in
					return evolution.evolvesInto == index
				})
			}) {
				speciesAlreadyUsed.addUnique(preEvo.index)
				if let secondPreEvo = cachedPokemonStats.first(where: { pokemon in
					pokemon.evolutions.contains(where: { evolution in
						return evolution.evolvesInto == preEvo.index
					})
				}) {
					speciesAlreadyUsed.addUnique(secondPreEvo.index)
				}
			}

			if let stats = cachedPokemonStats.first(where: { pokemon in
				pokemon.index == index
			}) {
				stats.evolutions.forEach { evoData in
					let evo = evoData.evolvesInto
					if evo > 0 {
						speciesAlreadyUsed.addUnique(evo)
						if let evoStats = cachedPokemonStats.first(where: { pokemon in
							pokemon.index == evo
						}) {
							evoStats.evolutions.forEach { evoData in
								let evo2 = evoData.evolvesInto
								if evo2 > 0 {
									speciesAlreadyUsed.addUnique(evo2)
								}
							}
						}
					}
				}
			}

		}

		func randomise(oldSpecies: XGPokemon, checkDuplicates: Bool = false, shadowID: Int = 0) -> XGPokemon {
			if shadowID > 0, let mon = shadowPokemonByID[shadowID] {
				return mon
			}

			let oldStats = oldSpecies.stats
			guard oldStats.index > 0, oldStats.catchRate > 0 else {
				if shadowID > 0 {
					shadowPokemonByID[shadowID] = oldSpecies
				}
				return oldSpecies
			}

			var options = cachedPokemonStats
			if speciesAlreadyUsed.count >= cachedPokemonStats.count {
				speciesAlreadyUsed.removeAll()
			}

			// Check for duplicates unless there aren't any non duplicate pokemon left
			let canCheckDuplicates = options.first(where: {!speciesAlreadyUsed.contains($0.index)}) != nil
			if checkDuplicates && canCheckDuplicates {
				options = options.filter{!speciesAlreadyUsed.contains($0.index)}
			}

			// Limit BST if required. Automatically increase radius if the number of remaining options is too low.
			var bstRadius = 50
			let oldBST = oldStats.baseStatTotal
			func canLimitBST() -> Bool {
				return (options.first(where: {($0.baseStatTotal >= oldBST - bstRadius) && ($0.baseStatTotal <= oldBST + bstRadius)}) != nil)
			}
			while similarBST && !canLimitBST() && (bstRadius <= 600) {
				bstRadius += 20
			}
			if similarBST && canLimitBST() {
				options = options.filter { ($0.baseStatTotal >= oldBST - bstRadius) && ($0.baseStatTotal <= oldBST + bstRadius) }
			}

			guard options.count > 0 else {
				if checkDuplicates {
					strikeEvolutionLineForPokemon(index: oldSpecies.index)
				}
				if shadowID > 0 {
					shadowPokemonByID[shadowID] = oldSpecies
				}
				return oldSpecies
			}

			let rand = Int.random(in: 0 ..< options.count)
			var newSpecies = XGPokemon.index(options[rand].index)
			if newSpecies.index == oldSpecies.index {
				// If it randomises to the original mon then reroll one time
				// If it manages to roll the original mon twice in a row then that's just rng
				newSpecies = XGPokemon.index(options[rand].index)
			}
			if checkDuplicates {
				strikeEvolutionLineForPokemon(index: newSpecies.index)
			}
			if shadowID > 0 {
				shadowPokemonByID[shadowID] = newSpecies
			}
			return newSpecies
		}

		#if !GAME_PBR
		if includeStarters {
			for gift in XGGiftPokemonManager.allStarterGiftPokemon() {

				var pokemon = gift
				pokemon.species = randomise(oldSpecies: pokemon.species, checkDuplicates: true)
				let moves = pokemon.species.movesForLevel(pokemon.level)
				pokemon.move1 = moves[0]
				pokemon.move2 = moves[1]
				pokemon.move3 = moves[2]
				pokemon.move4 = moves[3]

				pokemon.save()

			}
		}
		
		if includeObtainableMons {
			
			#if GAME_XD
			let gifts = XGGiftPokemonManager.nonShadowGiftPokemon()
			#else
			let gifts = XGGiftPokemonManager.allNonStarterGiftPokemon()
			#endif
			for gift in gifts {

				var pokemon = gift
				pokemon.species = randomise(oldSpecies: pokemon.species, checkDuplicates: true)
				let moves = pokemon.species.movesForLevel(pokemon.level)
				pokemon.move1 = moves[0]
				pokemon.move2 = moves[1]
				pokemon.move3 = moves[2]
				pokemon.move4 = moves[3]

				pokemon.save()

			}

			#if GAME_XD
			for p in 0 ... 3 {
				let spot = XGPokeSpots(rawValue: p) ?? .rock
				if case .all = spot, spot.numberOfEntries <= 2 {
					continue
				}
				for i in 0 ..< spot.numberOfEntries {
					let pokemon = XGPokeSpotPokemon(index: i, pokespot: spot)
					pokemon.pokemon = randomise(oldSpecies: pokemon.pokemon, checkDuplicates: true)
					pokemon.save()
				}
			}
			
			let tradeShadowPokemon = XGTradeShadowPokemon()
			tradeShadowPokemon.species = randomise(oldSpecies: tradeShadowPokemon.species, checkDuplicates: true, shadowID: tradeShadowPokemon.shadowID)
			let moves = tradeShadowPokemon.species.movesForLevel(tradeShadowPokemon.level)
			tradeShadowPokemon.move1 = moves[0]
			tradeShadowPokemon.move2 = moves[1]
			tradeShadowPokemon.move3 = moves[2]
			tradeShadowPokemon.move4 = moves[3]
			tradeShadowPokemon.save()
			#endif
		}
		
		var decks = MainDecksArray
		var additionalPokemon = [XGTrainerPokemon]()


		#if GAME_XD
		decks += [XGDecks.DeckDarkPokemon]
		additionalPokemon = includeUnobtainableMons ? [] : [
			XGDeckPokemon.dpkm(1, .DeckVirtual).data,
			XGDeckPokemon.dpkm(2, .DeckVirtual).data
		]
		#endif

		var mons = additionalPokemon
		for deck in decks {
			for pokemon in deck.allActivePokemon {
				if !includeUnobtainableMons && !pokemon.isShadowPokemon {
					continue
				}
				if !includeObtainableMons && pokemon.isShadowPokemon {
					continue
				}
				mons.append(pokemon)
			}
		}
		mons.forEach { (pokemon) in
			pokemon.species = randomise(oldSpecies: pokemon.species, checkDuplicates: pokemon.isShadowPokemon, shadowID: pokemon.shadowID)
			pokemon.shadowCatchRate = pokemon.species.catchRate
			pokemon.moves = pokemon.species.movesForLevel(pokemon.level)
			pokemon.happiness = 128
			pokemon.save()
		}
		#endif

		#if GAME_PBR
		for index in allPokemonDeckFileIndexes {
			if !includeStarters && index == rentalPassDeckIndex {
				continue
			}
			if !includeUnobtainableMons && index != rentalPassDeckIndex {
				continue
			}
			let file = XGFiles.indexAndFsysName(index, "deck")
			let deck = GoDDataTable.tableForFile(file)
			for i in 0 ..< deck.numberOfEntries {
				let mon = XGTrainerPokemon(index: i, file: file)
				mon.species = randomise(oldSpecies: mon.species, checkDuplicates: index == rentalPassDeckIndex)
				// For rental mons, use their last 4 level up moves at level 55 to make the movesets decent
				// without too many super high level moves which tend to be quite bad anyway
				mon.moves = index == rentalPassDeckIndex ? mon.species.movesForLevel(55) : mon.randomiserMoveset()
				mon.save()
			}
		}
		#endif
		
		#if GAME_XD
		XGUtility.updateXD001Purification()
		#endif

		printg("done!")
	}
	
	class func randomiseMoves() {
		printg("Randomising pokemon moves...")

		#if !GAME_PBR
		for deck in MainDecksArray {
			for pokemon in deck.allActivePokemon {
				
				if pokemon.species.index == 0 {
					continue
				}
				
				pokemon.moves = XGMoves.randomMoveset()
				pokemon.save()
			}
		}
		#endif

		#if GAME_XD
		for shadow in XGDecks.DeckDarkPokemon.allActivePokemon {
			let count = shadow.shadowMoves.filter { (m) -> Bool in
				return m.index != 0
			}.count
			shadow.shadowMoves = XGMoves.randomShadowMoveset(count: count)
			shadow.save()
		}
		#endif
		
		#if !GAME_PBR
		for gift in XGGiftPokemonManager.allGiftPokemon() {
			
			var pokemon = gift
			let moves = XGMoves.randomMoveset()
			pokemon.move1 = moves[0]
			pokemon.move2 = moves[1]
			pokemon.move3 = moves[2]
			pokemon.move4 = moves[3]
			
			pokemon.save()
			
		}
		#endif

		for i in 1 ..< kNumberOfPokemon {
			
			if XGPokemon.index(i).nameID == 0 {
				continue
			}
			
			let pokemon = XGPokemon.index(i)
			if pokemon.nameID > 0 {
				let p = XGPokemonStats(index: pokemon.index)
				
				for j in 0 ..< p.levelUpMoves.count {
					if p.levelUpMoves[j].level > 0 {
						p.levelUpMoves[j].move = XGMoves.random()
						var dupe = true
						while dupe {
							dupe = false
							for k in 0 ..< j {
								if p.levelUpMoves[k].move == p.levelUpMoves[j].move {
									p.levelUpMoves[j].move = XGMoves.random()
									dupe = true
								}
							}
						}
					}
				}
				
				p.save()
			}
		}

		#if GAME_PBR
		for index in allPokemonDeckFileIndexes {
			let file = XGFiles.indexAndFsysName(index, "deck")
			let deck = GoDDataTable.tableForFile(file)
			for i in 0 ..< deck.numberOfEntries {
				let mon = XGTrainerPokemon(index: i, file: file)
				mon.moves = index == rentalPassDeckIndex ? XGMoves.randomMoveset() : XGMoves.inGameRandomMoveset()
				mon.save()
			}
		}
		randomiseTMs()
		#endif

		printg("done!")
	}
	
	
	class func randomiseAbilities() {
		printg("Randomising pokemon abilities...")
		for i in 1 ..< kNumberOfPokemon {
			
			if XGPokemon.index(i).nameID == 0 {
				continue
			}
			
			let pokemon = XGPokemon.index(i)
			if pokemon.nameID > 0 {
				let p = XGPokemonStats(index: pokemon.index)
				
				if p.ability1.name.string.simplified == "wonderguard"
					|| p.ability2.name.string.simplified == "wonderguard" {
					continue
				}
				
				p.ability1 = XGAbilities.random()
				if p.ability2.index > 0 {
					p.ability2 = XGAbilities.random()
				}
				
				while p.ability1.name.string.simplified == "wonderguard" {
					p.ability1 = XGAbilities.random()
				}
				while p.ability2.name.string.simplified == "wonderguard" {
					p.ability2 = XGAbilities.random()
				}
				
				p.save()
			}
		}
		printg("done!")
	}
	
	class func randomiseTypes() {
		printg("Randomising pokemon types...")
		for i in 1 ..< kNumberOfPokemon {
			
			if XGPokemon.index(i).nameID == 0 {
				continue
			}
			
			let pokemon = XGPokemon.index(i)
			if pokemon.nameID > 0 {
				let p = XGPokemonStats(index: pokemon.index)
				
				p.type1 = XGMoveTypes.random()
				p.type2 = XGMoveTypes.random()
				
				p.save()
			}
		}
		printg("done!")
	}
	
	class func randomiseEvolutions(forIronmon: Bool = false) {
		printg("Randomising pokemon evolutions...")
		for i in 1 ..< kNumberOfPokemon {
			
			let pokemon = XGPokemon.index(i)
			if pokemon.nameID > 0 {
				
				let p = XGPokemonStats(index: pokemon.index)
				let m = p.evolutions
				
				if forIronmon {
					for n in m {
						if n.evolvesInto > 0 {
							let currentEvo = XGPokemon.index(n.evolvesInto).stats
							let options = XGPokemon.allPokemon().filter {
								let stats = $0.stats
								let bstRatio = Double(stats.baseStatTotal) / Double(currentEvo.baseStatTotal)
								return stats.nameID > 0
								&& stats.catchRate > 0
								&& stats.index != currentEvo.index
								&& (stats.type1.index == currentEvo.type1.index
									|| stats.type1.index == currentEvo.type2.index
									|| stats.type2.index == currentEvo.type1.index
									|| stats.type2.index == currentEvo.type2.index)
								&& (0.80 <= bstRatio || bstRatio <= 1.15)
							}
							if options.count > 0 {
								n.evolvesInto = (options.randomElement() ?? options[0]).index
							}
						}
					}
					p.evolutions = m
				} else {
					for n in m {
						if n.evolvesInto > 0 {
							var newEvolution = XGPokemon.random()
							while newEvolution.stats.catchRate == 0 {
								newEvolution = XGPokemon.random()
							}
							n.evolvesInto = newEvolution.index
						}
					}
					p.evolutions = m
				}
				
				p.save()
			}
		}
		printg("done!")
	}
	
	class func randomiseTMs() {
		if game == .PBR {
			printg("Randomising TMs...")
		} else {
			printg("Randomising TMs and Tutor Moves...")
		}
		
		var tmIndexes = [Int]()
		while tmIndexes.count < kNumberOfTMsAndHMs + kNumberOfTutorMoves {
			tmIndexes.addUnique(XGMoves.random().index)
		}
		
		for i in 1 ... kNumberOfTMsAndHMs {
			let tm = XGTMs.tm(i)
			tm.replaceWithMove(.index(tmIndexes[i - 1]))
		}
		#if GAME_XD
		for i in 1 ... kNumberOfTutorMoves {
			let tm = XGTMs.tutor(i)
			tm.replaceWithMove(XGMoves.random())
			tm.replaceWithMove(.index(tmIndexes[i + kNumberOfTMsAndHMs - 1]))
		}
		#endif
		printg("done!")
	}
	
	
	class func randomiseMoveTypes() {
		printg("Randomising move types...")
		for move in allMovesArray() {
			let m = move.data
			m.type = XGMoveTypes.random()
			m.save()
		}
		printg("done!")
	}
	
	class func randomisePokemonStats() {
		printg("Randomising pokemon stats...")
		for mon in allPokemonArray() {
			
			let pokemon = mon.stats
			
			// stat total will remain unchanges
			var statsTotal = pokemon.attack + pokemon.defense + pokemon.speed + pokemon.hp + pokemon.specialAttack + pokemon.specialDefense
			
			// no individual stat will be over this value
			let maxStat = min(statsTotal / 4, 255)

			if statsTotal <= 240 {
				// each stat should be at least 10
				pokemon.attack = 10
				pokemon.defense = 10
				pokemon.speed = 10
				pokemon.hp = 10
				pokemon.specialAttack = 10
				pokemon.specialDefense = 10
				statsTotal -= 60
			} else {
				// each stat should be at least 40
				pokemon.attack = 40
				pokemon.defense = 40
				pokemon.speed = 40
				pokemon.hp = 40
				pokemon.specialAttack = 40
				pokemon.specialDefense = 40
				statsTotal -= 240
			}
			
			func randomStat() -> Int {
				return Int.random(in: 0 ... 5)
			}
			
			func addToRandomStat(_ v: Int) {
				let stats = [pokemon.attack, pokemon.defense, pokemon.specialAttack, pokemon.specialDefense, pokemon.speed, pokemon.hp]
				if stats.filter({ (i) -> Bool in
					return i < 255
				}).isEmpty {
					statsTotal = 0
					return
				}
				
				if stats.filter({ (i) -> Bool in
					return i + v < 255
				}).isEmpty {
					statsTotal -= v
					return
				}
				var index = randomStat()
				while (stats[index] + v) > maxStat {
					index = randomStat()
				}
				switch index {
				case 0: pokemon.attack += v
				case 1: pokemon.defense += v
				case 2: pokemon.specialAttack += v
				case 3: pokemon.specialDefense += v
				case 4: pokemon.speed += v
				case 5: pokemon.hp += v
				default: break
				}
				statsTotal -= v
			}
			
			while statsTotal > 150 {
				addToRandomStat(statsTotal / 6)
			}
			
			while statsTotal > 25 {
				addToRandomStat(10)
			}
			
			while statsTotal > 0 {
				addToRandomStat(1)
			}
			pokemon.save()
			
		}
		printg("done!")
	}

	#if !GAME_PBR
	static func randomiseTreasureBoxes() {
		printg("Randomising item boxes...")
		for treasure in XGTreasure.allValues {
			guard treasure.item.data.bagSlot.rawValue < XGBagSlots.keyItems.rawValue,
				  treasure.item.data.price > 0 else {
				// don't randomise key items
				continue
			}
			treasure.quantity = Int.random(in: 1 ... 3)
			treasure.itemID = XGItems.random().index
			treasure.save()
		}
	}
	
	static func randomiseShops() {
		printg("Randomising shops...")
		guard let data = pocket.data else {
			return
		}
		
		func isElligible(_ item: XGItems) -> Bool {
			let data = item.data
			return data.bagSlot != .battleCDs
				&& data.bagSlot != .keyItems
				&& data.bagSlot != .colognes
				&& data.price > 0
		}
		
		let itemCount = pocket.getValueAtPointer(symbol: .numberOfMartItems)
		let startOffset = pocket.getPointer(symbol: .MartItems)
		let itemPool = XGItems.allItems()
			.filter { $0.index > 0 }
			.filter(isElligible)
		let pokeballPool = XGItems.pokeballs()
			.filter { $0.index > 0 }
			.filter(isElligible)
		var isFirstItemOfShop = true
		for i in 0 ..< itemCount {
			let currentOffset = startOffset + (i * 2)
			let currentValue = data.get2BytesAtOffset(currentOffset)
			if currentValue > 0 {
				let currentItem = XGItems.index(currentValue)
				if isElligible(currentItem) {
					let pool = isFirstItemOfShop && game == .Colosseum ? pokeballPool : itemPool
					if let newItem = pool.randomElement() {
						data.replace2BytesAtOffset(currentOffset, withBytes: newItem.index)
					}
					isFirstItemOfShop = false
				}
			} else {
				isFirstItemOfShop = true
			}
		}
		data.save()
		
		XGItem.allValues.forEach { item in
			if item.price > 0 {
				item.couponPrice = item.price * 10
				item.save()
			}
		}
	}
	#endif
	
	static func randomiseTypeMatchups() {
		printg("Randomising type matchups...")
		XGMoveTypes.allValues.forEach { type in
			let data = type.data
			data.effectivenessTable = data.effectivenessTable.shuffled()
			data.save()
		}
	}
	
	#if !GAME_PBR
	static func randomiseShinyHues() {
		
		printg("Applying patch to randomise colours of pokemon models...")
//		guard game == .XD else {
//			// The code doesn't affect anything in colosseum.
//			printg("This randomiser option hasn't been implemented for this game yet:", game.name)
//			return
//		}
		
		guard region == .US else {
			printg("This randomiser option hasn't been implemented for your game region:", region.name)
			return
		}
		let forceShinyModelRAMOffset: Int
		let forceShinyInstruction: XGASM = game == .Colosseum ? .li(.r28, 1) : .li(.r29, 1)
		if game == .Colosseum {
			switch region {
			case .US:
				forceShinyModelRAMOffset = 0x801de1ac
			default:
				forceShinyModelRAMOffset = 0x0
			}
		} else {
			switch region {
			case .US:
				forceShinyModelRAMOffset = 0x801d8e3c
			default:
				forceShinyModelRAMOffset = 0x0
			}
		}
		
		XGAssembly.replaceRamASM(RAMOffset: forceShinyModelRAMOffset, newASM: [forceShinyInstruction])
		
		if let freeSpace = XGAssembly.ASMfreeSpaceRAMPointer() {
			let speciesContainingRegister: XGRegisters = game == .Colosseum ? .r26 : .r27
			let resultRegister: XGRegisters = game == .Colosseum ? .r30 : .r29
			let resultOffset = game == .Colosseum ? 0x38 : 0x00
			let secondaryResultOffset = resultOffset + 0x10
			let branchOffset: Int
			let getTrainerDataOffset: Int
			let getTIDOffset: Int
			let replacedInstruction: XGASM
			if game == .Colosseum {
				replacedInstruction = .lbz(.r0, .r30, 0x4F)
				switch region {
				case .US:
					branchOffset = 0x801dce28
					getTrainerDataOffset = 0x80129280
					getTIDOffset = 0x8012ac3c
				default:
					branchOffset = 0x0
					getTrainerDataOffset = 0x0
					getTIDOffset = 0x0
				}
			} else {
				replacedInstruction = .lwz(.r30, .r26, 0x94)
				switch region {
				case .US:
					branchOffset = 0x801d9104
					getTrainerDataOffset = 0x801cefb4
					getTIDOffset = 0x8014e118
				default:
					branchOffset = 0x0
					getTrainerDataOffset = 0x0
					getTIDOffset = 0x0
				}
			}
			
			XGAssembly.replaceRamASM(RAMOffset: branchOffset, newASM: [.b(freeSpace)])
			XGAssembly.replaceRamASM(RAMOffset: freeSpace, newASM: [
				
				// get tid
				.li(.r3, 0),
				.li(.r4, 2),
				.bl(getTrainerDataOffset),
				.bl(getTIDOffset),
				
				// multiply species by tid to get seed
				.mullw(.r3, speciesContainingRegister, .r3),
				
				// calculate r,g,b, r2, g2, b2 from seed
				.mr(.r4, .r3),// r
				.srawi(.r4, .r4, 0),
				.mr(.r5, .r3),// g
				.srawi(.r5, .r5, 4),
				.mr(.r6, .r3),// b
				.srawi(.r6, .r6, 8),
				
				.mr(.r7, .r3),// r2
				.srawi(.r7, .r7, 8),
				.mr(.r8, .r3),// g2
				.srawi(.r8, .r8, 16),
				.mr(.r9, .r3),// b2
				.srawi(.r9, .r9, 24),
				
				// r
				.li(.r3, 9),
				.divw(.r3, .r4, .r3),
				.mulli(.r3, .r3, 9),
				.sub(.r4, .r4, .r3),
				
				// g
				.li(.r3, 9),
				.divw(.r3, .r5, .r3),
				.mulli(.r3, .r3, 9),
				.sub(.r5, .r5, .r3),
				
				// b
				.li(.r3, 9),
				.divw(.r3, .r6, .r3),
				.mulli(.r3, .r3, 9),
				.sub(.r6, .r6, .r3),
				
				// r
				.cmpwi(.r4, 0),
				.beq_l("r3"),
				.cmpwi(.r4, 2),
				.ble_l("r0"),
				.cmpwi(.r4, 5),
				.ble_l("r1"),
				.b_l("r2"),
				
				.label("r0"),
				.li(.r3, 0),
				.b_l("r_end"),
				.label("r1"),
				.li(.r3, 1),
				.b_l("r_end"),
				.label("r2"),
				.li(.r3, 2),
				.b_l("r_end"),
				.label("r3"),
				.li(.r3, 3),
				.label("r_end"),
				.stw(.r3, resultRegister, resultOffset),
				
				// g
				.cmpwi(.r5, 0),
				.beq_l("g3"),
				.cmpwi(.r5, 2),
				.ble_l("g0"),
				.cmpwi(.r5, 5),
				.ble_l("g1"),
				.b_l("g2"),
				
				.label("g0"),
				.li(.r3, 0),
				.b_l("g_end"),
				.label("g1"),
				.li(.r3, 1),
				.b_l("g_end"),
				.label("g2"),
				.li(.r3, 2),
				.b_l("g_end"),
				.label("g3"),
				.li(.r3, 3),
				.label("g_end"),
				.stw(.r3, resultRegister, resultOffset + 4),
				
				// b
				.cmpwi(.r6, 0),
				.beq_l("b3"),
				.cmpwi(.r6, 2),
				.ble_l("b0"),
				.cmpwi(.r6, 5),
				.ble_l("b1"),
				.b_l("b2"),
			
				.label("b0"),
				.li(.r3, 0),
				.b_l("b_end"),
				.label("b1"),
				.li(.r3, 1),
				.b_l("b_end"),
				.label("b2"),
				.li(.r3, 2),
				.b_l("b_end"),
				.label("b3"),
				.li(.r3, 3),
				.label("b_end"),
				.stw(.r3, resultRegister, resultOffset + 8),
				
				.label("secondary_start"),
				
				.andi_(.r7, .r7, 1),
				.andi_(.r8, .r8, 1),
				.andi_(.r9, .r9, 1),
				
				.cmpw(.r7, .r8),
				.bne_l("create_secondaries"),
				.cmpw(.r7, .r9),
				.bne_l("create_secondaries"),
				
				// if all are equal 50% chance to change one
				.cmpwi(.r6, 4),
				.bgt_l("create_secondaries"),
				.li(.r3, 3),
				.divw(.r3, .r6, .r3),
				.mulli(.r3, .r3, 3),
				.sub(.r6, .r6, .r3),
				
				.li(.r3, 1),
				.cmpwi(.r6, 0),
				.bne_l("check_1"),
				.sub(.r7, .r3, .r7),
				.b_l("create_secondaries"),
				
				.label("check_1"),
				.cmpwi(.r6, 1),
				.bne_l("check_2"),
				.sub(.r8, .r3, .r8),
				.b_l("create_secondaries"),
				
				.label("check_2"),
				.sub(.r9, .r3, .r9),
				
				.label("create_secondaries"),
				
				.cmpwi(.r7, 0),
				.bne_l("r_h"),
				.li(.r7, 0x80),
				.b_l("g_set"),
				.label("r_h"),
				.li(.r7, 0xD0),
				
				.label("g_set"),
				.cmpwi(.r8, 0),
				.bne_l("g_h"),
				.li(.r8, 0x80),
				.b_l("b_set"),
				.label("g_h"),
				.li(.r8, 0xD0),
				
				.label("b_set"),
				.cmpwi(.r9, 0),
				.bne_l("b_h"),
				.li(.r9, 0x80),
				.b_l("store_secondaries"),
				.label("b_h"),
				.li(.r9, 0xD0),
				
				.label("store_secondaries"),
				
				.stb(.r7, resultRegister, secondaryResultOffset),
				.stb(.r8, resultRegister, secondaryResultOffset + 1),
				.stb(.r9, resultRegister, secondaryResultOffset + 2),
				
				replacedInstruction,
				
				.b(branchOffset + 4)
			])
		}
	}
	#endif
}

































