//
//  CMRandomiser.swift
//  GoDToolCL
//
//  Created by The Steez on 16/09/2018.
//

import Foundation
import Darwin

class XGRandomiser : NSObject {
	
	class func randomiseBattleBingo() {}
	
	class func randomisePokemon() {
		printg("randomising pokemon species...")
		var shadows = [Int : XGPokemon]()
		for deck in TrainerDecksArray {
			for pokemon in deck.allActivePokemon {
				
				if pokemon.species.index == 0 {
					continue
				}
				
				if pokemon.isShadow {
					if let species = shadows[pokemon.shadowID] {
						pokemon.species = species
					} else {
						var species = XGPokemon.random()
						var dupe = true
						
						while dupe {
							dupe = false
							for (id, spec) in shadows {
								if id == pokemon.shadowID {
									continue
								}
								if species.index == spec.index {
									species = XGPokemon.random()
									dupe = true
								}
							}
						}
						
						pokemon.species = species
						shadows[pokemon.shadowID] = species
					}
				} else {
					pokemon.species = XGPokemon.random()
				}
				pokemon.shadowCatchRate = pokemon.species.catchRate
				pokemon.moves = pokemon.species.movesForLevel(pokemon.level)
				pokemon.happiness = 128
				pokemon.nature = .random
				pokemon.save()
				
			}
		}
		
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
		printg("done!")
	}
	
	class func randomiseMoves() {
		printg("randomising pokemon moves...")
		
		var shadows = [Int : [XGMoves]]()
		for deck in TrainerDecksArray {
			for pokemon in deck.allActivePokemon {
				
				if pokemon.species.index == 0 {
					continue
				}
				
				if pokemon.isShadow {
					if let moves = shadows[pokemon.shadowID] {
						pokemon.moves = moves
					} else {
						let moves = XGMoves.randomMoveset()
						shadows[pokemon.shadowID] = moves
						pokemon.moves = moves
					}
				} else {
					pokemon.moves = XGMoves.randomMoveset()
				}
				
				pokemon.save()
				
			}
		}
		
		
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
			
			if XGPokemon.pokemon(i).nameID == 0 {
				continue
			}
			
			let pokemon = XGPokemon.pokemon(i)
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
			
			if XGPokemon.pokemon(i).nameID == 0 {
				continue
			}
			
			let pokemon = XGPokemon.pokemon(i)
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
			
			if XGPokemon.pokemon(i).nameID == 0 {
				continue
			}
			
			let pokemon = XGPokemon.pokemon(i)
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
			
			let pokemon = XGPokemon.pokemon(i)
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
		printg("randomising TMs...")
		for tm in allTMsArray() {
			tm.replaceWithMove(XGMoves.random())
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
			
			// each stat should be at least 20
			pokemon.attack = 40
			pokemon.defense = 40
			pokemon.speed = 40
			pokemon.hp = 40
			pokemon.specialAttack = 40
			pokemon.specialDefense = 40
			statsTotal -= 240
			
			func randomStat() -> Int {
				return Int(arc4random_uniform(6))
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
