//
//  XGRandomiser.swift
//  GoD Tool
//
//  Created by The Steez on 15/09/2018.
//

import Foundation

class XGRandomiser : NSObject {
	
	class func randomisePokemon() {
		printg("randomising pokemon species...")
		
		printg("done!")
	}
	
	class func randomiseMoves() {
		printg("randomising pokemon moves...")
		
		printg("done!")
	}
	
	
	class func randomiseAbilities() {
		printg("randomising pokemon abilities...")
		
		printg("done!")
	}
	
	class func randomiseTypes() {
		printg("randomising pokemon types...")
		
		printg("done!")
	}
	
	class func randomiseMoveTypes() {
		printg("randomising move types...")
		
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

































