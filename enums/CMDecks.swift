//
//  CMDecks.swift
//  GoD Tool
//
//  Created by Stars Momodu on 28/01/2021.
//

import Foundation

let TrainerDecksArray : [XGDecks] = [.DeckStory]
let MainDecksArray: [XGDecks] = [.DeckStory]
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
					string += ((p.isShadowPokemon ? "Shadow " : "") + p.species.name.string).spaceToLength(pokemonLength)
				}
			}
			string += "\n" + "".spaceToLength(trainerLength)

			for p in trainer.pokemon {
				if p.isSet {
					string += ("Level " + p.level.string + (p.isShadowPokemon ? "+" : "")).spaceToLength(pokemonLength)
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
