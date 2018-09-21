//
//  XDRHomeViewController.swift
//  GoD Tool
//
//  Created by StarsMmd on 05/09/2017.
//
//

import Cocoa

class XDRHomeViewController: GoDViewController {

	@objc var buttons = [NSButton]()
	
	@IBOutlet var isoLabel: NSTextField!
	@IBOutlet var headerImage: NSImageView!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if XGFiles.iso.exists {
			isoLabel.stringValue = ""
			isoLabel.isHidden = true
			headerImage.isHidden = false
			
		}
		
		let names = ["Randomise Pokemon", "Randomise Moves", "Randomise Abilities", "Randomise Types", "Randomise Evolutions", "Remove Trade Evolutions", "Randomise Battle Bingo", "Gen 4 Class Split","Document Changes (Reference)","Save"]
		let actions : [Selector] = [ #selector(randomisePokemon), #selector(randomiseMoves), #selector(randomiseAbilities), #selector(randomiseTypes), #selector(randomiseEvolutions), #selector(removeTradeEvolutions), #selector(randomiseBattleBingo), #selector(gen4PhysicalSpecialSplit),#selector(document), #selector(save)]
		
		for i in 0 ..< names.count {
			let b = button(names[i], action: actions[i])
			buttons.append(b)
			
			b.frame.origin = CGPoint(x: 25, y: 50 * CGFloat(names.count - i) - 40)
			
		}
		
		self.showActivityView { 
			if XGFiles.iso.exists {
				XGISO.extractRandomiserFiles()
			}
			self.hideActivityView()
		}
		
	}
	
	override var representedObject: Any? {
		didSet {
			// Update the view, if already loaded.
		}
	}
	
	@objc func button(_ name: String, action: Selector) -> NSButton {
		let b = NSButton(frame: NSRect(x: 0, y: 0, width: 200, height: 40))
		b.title = name
		b.action = action
		b.target = self
		b.isEnabled = XGFiles.iso.exists
		self.view.addSubview(b)
		return b
	}
	
	@objc func document() {
		XGUtility.documentTrainers(title: "Randomised Trainers", forXG: false)
		XGUtility.documentStarterPokemon()
		XGUtility.documentPokespots()
		XGUtility.documentTrades()
		XGUtility.documentBattleBingo()
		XGUtility.documentPokemonStats(title: "Randomised Pokemon", forXG: false)
		XGUtility.saveObtainablePokemonByLocation(prefix: "XD Randomised")
		XGUtility.documentShadowPokemon(title: "Randomised Shadow Pokemon", forXG: false)
	}
	
	@objc func randomiseBattleBingo() {
		self.showActivityView { () -> Void in
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
	
	@objc func randomisePokemon() {
		self.showActivityView { () -> Void in
			
			for deck in MainDecksArray {
				for pokemon in deck.allActivePokemon {
					
					if pokemon.species.index == 0 {
						continue
					}
					
					pokemon.species = XGPokemon.random()
					pokemon.shadowCatchRate = pokemon.species.catchRate
					pokemon.moves = pokemon.species.movesForLevel(pokemon.level)
					pokemon.happiness = 128
					pokemon.save()
					
				}
			}
			
			// change duplicate shadow pokemon
			for i in 1 ..< XGDecks.DeckDarkPokemon.DDPKEntries {
				let poke = XGDeckPokemon.ddpk(i)
				if poke.DPKMIndex > 0 {
					
					var duplicate = false
					
					repeat {
						duplicate = false
						
						for j in 1 ..< i {
							let check = XGDeckPokemon.ddpk(j)
							if check.data.species.index == poke.data.species.index {
								duplicate = true
								
								let pokemon = poke.data
								pokemon.species = XGPokemon.random()
								pokemon.shadowCatchRate = pokemon.species.catchRate
								pokemon.moves = pokemon.species.movesForLevel(pokemon.level)
								pokemon.happiness = 128
								pokemon.save()
							}
						}
						
					} while duplicate
					
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
			
			if XGPokeSpots.all.numberOfEntries() > 2 {
				for i in 2 ..< XGPokeSpots.all.numberOfEntries() {
					let pokemon = XGPokeSpotPokemon(index: i, pokespot: .all)
					pokemon.pokemon = XGPokemon.random()
					pokemon.save()
				}
			}
			
			self.hideActivityView()
		}
	}
	
	@objc func randomiseMoves() {
		
		self.showActivityView { () -> Void in
			
			for i in 1 ..< kNumberOfPokemon {
				
				let pokemon = XGPokemon.pokemon(i)
				if pokemon.nameID > 0 {
					let p = XGPokemonStats(index: pokemon.index)
					for i in 0 ..< kNumberOfLevelUpMoves {
						p.levelUpMoves[i].move = XGMoves.random()
					}
					p.save()
				}
			}
			
			for deck in MainDecksArray {
				for pokemon in deck.allActivePokemon {
					
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
			
			for i in 1 ..< kNumberOfPokemon {
				
				if XGPokemon.pokemon(i).nameID == 0 {
					continue
				}
				
				let pokemon = XGPokemon.pokemon(i)
				if pokemon.nameID > 0 {
					let p = XGPokemonStats(index: pokemon.index)
					
					for j in 0 ..< p.levelUpMoves.count {
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
					
					p.save()
				}
			}
			
			self.hideActivityView()
		}
		
		
	}
	
	@objc func randomiseAbilities() {
		self.showActivityView { () -> Void in
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
			self.hideActivityView()
		}
	}
	
	@objc func randomiseTypes() {
		self.showActivityView { () -> Void in
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
			self.hideActivityView()
		}
	}
	
	@objc func randomiseEvolutions() {
		self.showActivityView { () -> Void in
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
			self.hideActivityView()
		}
	}
	
	@objc func removeTradeEvolutions() {
		self.showActivityView { () -> Void in
			self.removeTradeEvs(30)
		}
		
	}
	
	@objc func removeTradeEvs(_ level: Int) {
		self.showActivityView { () -> Void in
			for i in 1 ..< kNumberOfPokemon {
				
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
	
	@objc func gen4PhysicalSpecialSplit() {
		self.showActivityView { 
			XGDolPatcher.applyPatch(.physicalSpecialSplitApply)
			XGUtility.defaultMoveCategories()
			
			self.hideActivityView()
		}
		
	}
	
	@objc func save() {
		self.showActivityView { () -> Void in
			XGUtility.compileForRandomiser()
			self.hideActivityView()
		}
	}
	
	override func viewDidDisappear() {
		super.viewDidDisappear()
		NSApplication.shared.terminate(self)
	}
	
}



















