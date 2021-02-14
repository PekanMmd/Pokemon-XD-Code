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
		printg("randomising battle bingo...")
		for i in 0 ..< kNumberOfBingoCards {
			let card = XGBattleBingoCard(index: i)
			let starter = card.startingPokemon!
			starter.species = XGPokemon.random()
			starter.move = XGMoves.random()
			starter.save()
			
			for panel in card.panels {
				if let pokemon = panel.pokemon {
					pokemon.species = XGPokemon.random()
					pokemon.move = XGMoves.randomDamaging()
					pokemon.save()
				}
			}
		}
		printg("done!")
	}
	#endif
	
	class func randomisePokemon(shadowsOnly: Bool = false, similarBST: Bool = false) {
		printg("randomising pokemon species...")

		let cachedPokemonStats = XGPokemon.allPokemon().map{$0.stats}.filter{$0.catchRate > 0}
		var speciesAlreadyUsed = [Int]()

		func randomise(oldSpecies: XGPokemon, checkDuplicates: Bool = false) -> XGPokemon {
			let oldStats = oldSpecies.stats
			guard oldStats.index > 0 else { return oldSpecies }
			guard oldStats.catchRate > 0 else { return oldSpecies }

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
				speciesAlreadyUsed.addUnique(oldSpecies.index)
				return oldSpecies
			}

			let rand = Int.random(in: 0 ..< options.count)
			let newSpecies = XGPokemon.index(options[rand].index)
			speciesAlreadyUsed.addUnique(newSpecies.index)
			return newSpecies
		}

		for deck in MainDecksArray {
			#if GAME_COLO
			var shadows = [Int: XGPokemon]()
			#endif

			for pokemon in deck.allActivePokemon {
				#if GAME_COLO
				if shadowsOnly && !pokemon.isShadow {
					continue
				}
				#else
				if shadowsOnly && !pokemon.isShadowPokemon {
					continue
				}
				#endif

				#if GAME_XD
				pokemon.species = randomise(oldSpecies: pokemon.species, checkDuplicates: pokemon.isShadowPokemon)
				#else
				if pokemon.isShadow {
					if let species = shadows[pokemon.shadowID] {
						pokemon.species = species
					} else {
						let newSpecies = randomise(oldSpecies: pokemon.species, checkDuplicates: true)
						pokemon.species = newSpecies
						shadows[pokemon.shadowID] = newSpecies
					}
				} else {
					pokemon.species = randomise(oldSpecies: pokemon.species)
				}
				#endif
				pokemon.shadowCatchRate = pokemon.species.catchRate
				pokemon.moves = pokemon.species.movesForLevel(pokemon.level)
				pokemon.happiness = 128
				pokemon.save()

			}
		}

		if !shadowsOnly {
			for gift in XGGiftPokemonManager.allGiftPokemon() {

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
			#endif
		}

		printg("done!")
	}
	
	class func randomiseMoves() {
		printg("randomising pokemon moves...")
		
		for deck in MainDecksArray {
			for pokemon in deck.allActivePokemon {
				
				if pokemon.species.index == 0 {
					continue
				}
				
				pokemon.moves = XGMoves.randomMoveset()
				pokemon.save()
			}
		}


		#if GAME_XD
		for shadow in XGDecks.DeckDarkPokemon.allActivePokemon {
			let count = shadow.shadowMoves.filter { (m) -> Bool in
				return m.index != 0
			}.count
			shadow.shadowMoves = XGMoves.randomShadowMoveset(count: count)
			shadow.save()
		}
		#endif
		
		
		for gift in XGGiftPokemonManager.allGiftPokemon() {
			
			var pokemon = gift
			let moves = XGMoves.randomMoveset()
			pokemon.move1 = moves[0]
			pokemon.move2 = moves[1]
			pokemon.move3 = moves[2]
			pokemon.move4 = moves[3]
			
			pokemon.save()
			
		}
		
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
		printg("done!")
	}
	
	
	class func randomiseAbilities() {
		printg("randomising pokemon abilities...")
		for i in 1 ..< kNumberOfPokemon {
			
			if XGPokemon.index(i).nameID == 0 {
				continue
			}
			
			let pokemon = XGPokemon.index(i)
			if pokemon.nameID > 0 {
				let p = XGPokemonStats(index: pokemon.index)
				
				p.ability1 = XGAbilities.random()
				if p.ability2.index > 0 {
					p.ability2 = XGAbilities.random()
				}
				
				p.save()
			}
		}
		printg("done!")
	}
	
	class func randomiseTypes() {
		printg("randomising pokemon types...")
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
	
	class func randomiseEvolutions() {
		printg("randomising pokemon evolutions...")
		for i in 1 ..< kNumberOfPokemon {
			
			let pokemon = XGPokemon.index(i)
			if pokemon.nameID > 0 {
				let p = XGPokemonStats(index: pokemon.index)
				let m = p.evolutions
				for n in m {
					if n.evolvesInto > 0 {
						n.evolvesInto = XGPokemon.random().index
					}
				}
				p.evolutions = m
				
				p.save()
			}
		}
		printg("done!")
	}
	
	class func randomiseTMs() {
		printg("randomising TMs and Tutor Moves...")
		
		var tmIndexes = [Int]()
		while tmIndexes.count < kNumberOfTMsAndHMs + kNumberOfTutorMoves {
			tmIndexes.addUnique(XGMoves.random().index)
		}
		
		for i in 1 ... kNumberOfTMsAndHMs {
			let tm = XGTMs.tm(i)
			tm.replaceWithMove(.index(tmIndexes[i - 1]))
		}
		for i in 1 ... kNumberOfTutorMoves {
			let tm = XGTMs.tutor(i)
			tm.replaceWithMove(XGMoves.random())
			tm.replaceWithMove(.index(tmIndexes[i + kNumberOfTMsAndHMs - 1]))
		}
		printg("done!")
	}
	
	
	class func randomiseMoveTypes() {
		printg("randomising move types...")
		for move in allMovesArray() {
			let m = move.data
			m.type = XGMoveTypes.random()
			m.save()
		}
		printg("done!")
	}
	
	class func randomisePokemonStats() {
		printg("randomising pokemon stats...")
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
	
	
}

































