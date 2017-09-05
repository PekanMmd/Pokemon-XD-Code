//
//  XDRHomeViewController.swift
//  GoD Tool
//
//  Created by The Steez on 05/09/2017.
//
//

import Cocoa

class XDRHomeViewController: XDRViewController {

	var buttons = [NSButton]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		let names = ["Randomise Pokemon", "Randomise Moves", "Randomise Abilities", "Randomise Types", "Randomise Evolutions", "Remove Trade Evolutions", "Randomise Battle Bingo", "Save"]
		let actions : [Selector] = [ #selector(randomisePokemon), #selector(randomiseMoves), #selector(randomiseAbilities), #selector(randomiseTypes), #selector(randomiseEvolutions), #selector(removeTradeEvolutions), #selector(randomiseBattleBingo), #selector(save)]
		
		for i in 0 ..< names.count {
			let b = button(names[i], action: actions[i])
			buttons.append(b)
			
			b.frame.origin = CGPoint(x: 25, y: 50 * CGFloat(names.count - i) - 40)
			
		}
		
		
		
	}
	
	override func activeSet() {
		for b in buttons {
			b.isEnabled = !active
		}
	}
	
	override var representedObject: Any? {
		didSet {
			// Update the view, if already loaded.
		}
	}
	
	func button(_ name: String, action: Selector) -> NSButton {
		let b = NSButton(frame: NSRect(x: 0, y: 0, width: 200, height: 40))
		b.title = name
		b.action = action
		b.target = self
		self.view.addSubview(b)
		return b
	}
	
	func randomiseBattleBingo() {
		self.showActivityView { (Bool) -> Void in
			for i in 0 ..< kNumberOfBingoCards {
				let card = XGBattleBingoCard(index: i)
				let starter = card.startingPokemon!
				starter.species = XGPokemon.random()
				starter.move = XGMoves.random()
				starter.save()
				
				for panel in card.panels {
					switch panel {
					case .pokemon(let mon):
						let pokemon = mon
						pokemon.species = XGPokemon.random()
						pokemon.move = XGMoves.random()
						pokemon.save()
					default:
						break
					}
				}
			}
			self.hideActivityView()
		}
	}
	
	func randomisePokemon() {
		self.showActivityView { (Bool) -> Void in
			
			var entries = 0
			
			for deck in MainDecksArray {
				entries += deck.DPKMEntries
			}
			
			var counter = entries - 1
			
			for deck in MainDecksArray {
				for pokemon in deck.allActivePokemon {
					
					self.progressBar.doubleValue = Double(entries - counter) / Double(entries) * 100
					if counter > 0 { counter -= 1 }
					
					if pokemon.species.index == 0 {
						continue
					}
					
					pokemon.species = XGPokemon.random()
					pokemon.moves = pokemon.species.movesForLevel(pokemon.level)
					pokemon.happiness = 128
					pokemon.save()
					
				}
			}
			
			var gifts : [XGGiftPokemon] = []
			
			gifts.append(XGStarterPokemon())
			
			for i in 0 ..< 2 {
				gifts.append(XGDemoStarterPokemon(index: i))
			}
			
			for i in 0 ..< 3 {
				gifts.append(XGMtBattlePrizePokemon(index: i))
			}
			
			for i in 0 ..< 4 {
				gifts.append(XGTradePokemon(index: i))
			}
			
			gifts.append(XGTradeShadowPokemon())
			
			for gift in gifts {
				
				var pokemon = gift
				pokemon.species = XGPokemon.random()
				let moves = pokemon.species.movesForLevel(pokemon.level)
				pokemon.move1 = moves[0]
				pokemon.move2 = moves[1]
				pokemon.move3 = moves[2]
				pokemon.move4 = moves[3]
				
				pokemon.save()
				
			}
			
			for p in 0 ... 2 {
				let spot = XGPokeSpots(rawValue: p) ?? .rock
				for i in 0 ..< spot.numberOfEntries() {
					let pokemon = XGPokeSpotPokemon(index: i, pokespot: spot)
					pokemon.pokemon = XGPokemon.random()
					pokemon.save()
				}
				
			}
			
			self.hideActivityView()
		}
	}
	
	func randomiseMoves() {
		
		self.showActivityView { (Bool) -> Void in
			
			var entries = 0
			
			for deck in MainDecksArray {
				entries += deck.DPKMEntries
			}
			
			var counter = entries - 1
			
			for deck in MainDecksArray {
				for pokemon in deck.allActivePokemon {
					
					self.progressBar.doubleValue = Double(entries - counter) / Double(entries) * 100
					if counter > 0 { counter -= 1 }
					
					if pokemon.species.index == 0 {
						continue
					}
					
					pokemon.moves = XGMoves.randomMoveset()
					
					if pokemon.isShadowPokemon {
						for i in 0 ..< pokemon.shadowMoves.count {
							if pokemon.shadowMoves[i].index > 0 {
								pokemon.shadowMoves[i] = XGMoves.randomShadow()
							}
						}
					}
					
					pokemon.save()
					
				}
			}
			
			var gifts : [XGGiftPokemon] = []
			
			gifts.append(XGStarterPokemon())
			
			for i in 0 ..< 2 {
				gifts.append(XGDemoStarterPokemon(index: i))
			}
			
			for i in 0 ..< 3 {
				gifts.append(XGMtBattlePrizePokemon(index: i))
			}
			
			for i in 0 ..< 4 {
				gifts.append(XGTradePokemon(index: i))
			}
			
			gifts.append(XGTradeShadowPokemon())
			
			for gift in gifts {
				
				var pokemon = gift
				let moves = XGMoves.randomMoveset()
				pokemon.move1 = moves[0]
				pokemon.move2 = moves[1]
				pokemon.move3 = moves[2]
				pokemon.move4 = moves[3]
				
				pokemon.save()
				
			}
			
			self.hideActivityView()
		}
		
	}
	
	func randomiseAbilities() {
		self.showActivityView { (Bool) -> Void in
			for i in 1 ... kNumberOfPokemon {
				self.progressBar.doubleValue = Double(i) / Double(kNumberOfPokemon) * 100
				
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
			self.hideActivityView()
		}
	}
	
	func randomiseTypes() {
		self.showActivityView { (Bool) -> Void in
			for i in 1 ... kNumberOfPokemon {
				self.progressBar.doubleValue = Double(i) / Double(kNumberOfPokemon) * 100
				
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
			self.hideActivityView()
		}
	}
	
	func randomiseEvolutions() {
		self.showActivityView { (Bool) -> Void in
			for i in 1 ... kNumberOfPokemon {
				self.progressBar.doubleValue = Double(i) / Double(kNumberOfPokemon) * 100
				
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
			self.hideActivityView()
		}
	}
	
	func removeTradeEvolutions() {
		removeTradeEvs(40)
	}
	
	func removeTradeEvs(_ level: Int) {
		self.showActivityView { (Bool) -> Void in
			for i in 1 ... kNumberOfPokemon {
				
				self.progressBar.doubleValue = Double(i) / Double(kNumberOfPokemon) * 100
				
				let pokemon = XGPokemon.pokemon(i)
				if pokemon.nameID > 0 {
					let p = XGPokemonStats(index: pokemon.index)
					let m = p.evolutions
					for n in m {
						if n.evolutionMethod == .trade || n.evolutionMethod == .tradeWithItem {
							n.evolutionMethod = .levelUp
							n.condition = level
						}
					}
					p.evolutions = m
					
					p.save()
				}
			}
			self.hideActivityView()
		}
	}
	
	func save() {
		self.showActivityView { (Bool) -> Void in
			self.progressBar.doubleValue = 50
			XGUtility.compileForRandomiser()
			self.progressBar.doubleValue = 100
			self.hideActivityView()
		}
	}
	
}
