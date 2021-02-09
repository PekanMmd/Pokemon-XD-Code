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

		var cachedPokemonStats = [XGPokemonStats]()
		if similarBST {
			XGPokemon.allPokemon().forEach { (pokemon) in
				cachedPokemonStats.append(pokemon.stats)
			}
		}

		func randomWithSimilarBST(to bst: Int) -> XGPokemon {
			var bstRadius = 50
			var options = cachedPokemonStats.filter { ($0.baseStatTotal >= bst - bstRadius) && ($0.baseStatTotal <= bst + bstRadius) && $0.catchRate > 0 }
			while options.count < 2 && bstRadius < 600 {
				bstRadius += 10
				options = cachedPokemonStats.filter { ($0.baseStatTotal >= bst - bstRadius) && ($0.baseStatTotal <= bst + bstRadius) && $0.catchRate > 0 }
			}

			guard options.count > 0 else { return .index(0) }

			let rand = Int.random(in: 0 ..< options.count)
			return .index(options[rand].index)
		}

		for deck in MainDecksArray {
			#if GAME_COLO
			var shadows = [Int : XGPokemon]()
			#endif

			for pokemon in deck.allActivePokemon {

				if pokemon.species.index == 0 {
					continue
				}

				#if GAME_COLO
				if shadowsOnly && !pokemon.isShadow {
					continue
				}
				#else
				if shadowsOnly && !pokemon.isShadowPokemon {
					continue
				}
				#endif

				let oldBST = pokemon.species.stats.baseStatTotal

				#if GAME_XD
				pokemon.species = similarBST ? randomWithSimilarBST(to: oldBST) : XGPokemon.random()
				#else
				if pokemon.isShadow {
					if let species = shadows[pokemon.shadowID] {
						pokemon.species = species
					} else {
						var species = similarBST ? randomWithSimilarBST(to: oldBST) : XGPokemon.random()
						var dupe = true
						var trials = 0

						while dupe && trials < 30 {
							dupe = false
							for (id, spec) in shadows {
								if id == pokemon.shadowID {
									continue
								}
								if species.index == spec.index {
									species = similarBST ? randomWithSimilarBST(to: oldBST) : XGPokemon.random()
									dupe = true
									trials += 1
								}
							}
						}

						pokemon.species = species
						shadows[pokemon.shadowID] = species
					}
				} else {
					pokemon.species = similarBST ? randomWithSimilarBST(to: oldBST) : XGPokemon.random()
				}
				#endif
				pokemon.shadowCatchRate = pokemon.species.catchRate
				pokemon.moves = pokemon.species.movesForLevel(pokemon.level)
				pokemon.happiness = 128
				pokemon.save()

			}
		}

		// change duplicate shadow pokemon
		#if GAME_XD
		for i in 1 ..< XGDecks.DeckDarkPokemon.DDPKEntries {
			let poke = XGDeckPokemon.ddpk(i)
			if poke.DPKMIndex > 0 {

				var duplicate = false
				var trials = 0

				repeat {
					duplicate = false

					for j in 1 ..< i {
						if trials < 30 {
							let check = XGDeckPokemon.ddpk(j)
							if check.data.species.index == poke.data.species.index {
								duplicate = true

								let pokemon = poke.data
								let oldBST = pokemon.species.stats.baseStatTotal
								pokemon.species = similarBST ? randomWithSimilarBST(to: oldBST) : XGPokemon.random()
								pokemon.shadowCatchRate = pokemon.species.catchRate
								pokemon.moves = pokemon.species.movesForLevel(pokemon.level)
								pokemon.happiness = 128
								pokemon.save()
								trials += 1
							}
						}
					}

				} while duplicate && trials < 30

			}
		}
		#endif

		if !shadowsOnly {
			for gift in XGGiftPokemonManager.allGiftPokemon() {

				var pokemon = gift
				pokemon.species = XGPokemon.random()
				let moves = pokemon.species.movesForLevel(pokemon.level)
				pokemon.move1 = moves[0]
				pokemon.move2 = moves[1]
				pokemon.move3 = moves[2]
				pokemon.move4 = moves[3]

				pokemon.save()

			}

			#if GAME_XD
			var pokespotEntries = [Int]()
			for p in 0 ... 2 {
				let spot = XGPokeSpots(rawValue: p) ?? .rock
				for i in 0 ..< spot.numberOfEntries {
					let pokemon = XGPokeSpotPokemon(index: i, pokespot: spot)
					var newMon = XGPokemon.random()
					while pokespotEntries.contains(newMon.index) {
						newMon = XGPokemon.random()
					}
					pokespotEntries.append(newMon.index)
					pokemon.pokemon = newMon
					pokemon.save()
				}

			}

			if XGPokeSpots.all.numberOfEntries > 2 {
				for i in 2 ..< XGPokeSpots.all.numberOfEntries {
					let pokemon = XGPokeSpotPokemon(index: i, pokespot: .all)
					var newMon = XGPokemon.random()
					while pokespotEntries.contains(newMon.index) {
						newMon = XGPokemon.random()
					}
					pokespotEntries.append(newMon.index)
					pokemon.pokemon = newMon
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

































