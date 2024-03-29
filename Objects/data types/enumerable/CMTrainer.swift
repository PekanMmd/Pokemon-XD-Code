//
//  CMTrainer.swift
//  Colosseum Tool
//
//  Created by The Steez on 04/06/2018.
//

import Foundation

let kSizeOfTrainerData				= 0x34
let kNumberOfTrainerPokemon			= 0x06
let kNumberOfTrainerEntries			= CommonIndexes.NumberOfTrainers.value // 820

let kTrainerGenderOffset			= 0x00
let kTrainerClassOffset				= 0x03
let kTrainerFirstPokemonOffset		= 0x04
let kTrainerAIOffset				= 0x06
let kTrainerNameIDOffset			= 0x08
let kTrainerBattleTransitionOffset	= 0x0C
let kTrainerClassModelOffset		= 0x13
let kTrainerPreBattleTextIDOffset	= 0x24
let kTrainerVictoryTextIDOffset		= 0x28
let kTrainerDefeatTextIDOffset		= 0x2C
let kFirstTrainerLoseText2Offset	= 0x32
let kTrainerFirstItemOffset			= 0x14

typealias TrainerInfo = (fullname:String,name:String,location:String,hasShadow: Bool,trainerModel:XGTrainerModels,index:Int, deck: XGDecks)

final class XGTrainer: NSObject, Codable {
	
	var index				= 0x0
	
	var AI					= 0
	var cameraEffects		= 0 // xd only
	
	var nameID				= 0x0
	var preBattleTextID		= 0x0
	var victoryTextID		= 0x0
	var defeatTextID		= 0x0
	var shadowMask			= 0x0
	var pokemon				= [XGTrainerPokemon]()
	var trainerClass		= XGTrainerClasses.none
	var trainerModel		= XGTrainerModels.wes

	var items				= [XGItems]()
	
	lazy var battleData: XGBattle? = {
		return XGBattle.battleForTrainer(index: self.index)
	}()
	
	var startOffset : Int {
		get {
			return CommonIndexes.Trainers.startOffset + (index * kSizeOfTrainerData)
		}
	}
	
	var name : XGString {
		get {
			return XGFiles.common_rel.stringTable.stringSafelyWithID(self.nameID)
		}
	}
	
	var isPlayer : Bool {
		return self.index == 1
	}
	
	var prizeMoney : Int {
		get {
			var maxLevel = 0
			
			for poke in self.pokemon {
				maxLevel = poke.level > maxLevel ? poke.level : maxLevel
			}
			
			return self.trainerClass.payout * 2 * maxLevel
		}
	}
	
	var hasShadow : Bool {
		get {
			for poke in self.pokemon {
				if poke.isShadowPokemon {
					return true
				}
			}
			return false
		}
	}

	var trainerInfo: TrainerInfo {
		return (self.trainerClass.name.string + " " + self.name.unformattedString, self.name.unformattedString,"",self.hasShadow,self.trainerModel,self.index, .DeckStory)
	}
	
	init(index: Int) {
		super.init()
		
		self.index = index
		let start = startOffset
		
		let deck = XGFiles.common_rel.data!
		
		self.nameID =  deck.getWordAtOffset(start + kTrainerNameIDOffset).int
		self.preBattleTextID = deck.getWordAtOffset(start + kTrainerPreBattleTextIDOffset).int
		self.victoryTextID = deck.getWordAtOffset(start + kTrainerVictoryTextIDOffset).int
		self.defeatTextID = deck.getWordAtOffset(start + kTrainerDefeatTextIDOffset).int
		self.AI = deck.get2BytesAtOffset(start + kTrainerAIOffset)
		
		let tClass = deck.getByteAtOffset(start + kTrainerClassOffset)
		let tModel = deck.getByteAtOffset(start + kTrainerClassModelOffset)
		
		self.trainerClass = XGTrainerClasses(rawValue: tClass) ?? .none
		self.trainerModel = XGTrainerModels(rawValue: tModel)  ?? .wes

		self.items = deck.getShortStreamFromOffset(start + kTrainerFirstItemOffset, length: 8).map({ (index) -> XGItems in
			return .index(index)
		})
		
		let first = deck.get2BytesAtOffset(start + kTrainerFirstPokemonOffset)
		if first < CommonIndexes.NumberOfTrainerPokemonData.value {
			for i in 0 ..< kNumberOfTrainerPokemon {
				self.pokemon.append(XGTrainerPokemon(index: (first + i)))
			}
		}
		
	}
	
	func save() {
		
		let start = startOffset
		let deck = XGFiles.common_rel.data!
		
		deck.replaceWordAtOffset(start + kTrainerNameIDOffset, withBytes: UInt32(self.nameID))
		deck.replaceWordAtOffset(start + kTrainerPreBattleTextIDOffset, withBytes: UInt32(self.preBattleTextID))
		deck.replaceWordAtOffset(start + kTrainerVictoryTextIDOffset, withBytes: UInt32(self.victoryTextID))
		deck.replaceWordAtOffset(start + kTrainerDefeatTextIDOffset, withBytes: UInt32(self.defeatTextID))
		
		deck.replace2BytesAtOffset(start + kTrainerAIOffset, withBytes: self.AI)
		deck.replaceByteAtOffset(start + kTrainerClassOffset , withByte: self.trainerClass.rawValue)
		deck.replaceByteAtOffset(start + kTrainerClassModelOffset, withByte: self.trainerModel.rawValue)
		deck.replaceBytesFromOffset(start + kTrainerFirstItemOffset, withShortStream: items.map({ (item) -> Int in
			return item.index
		}))

		deck.save()
	}
	
	func purge(autoSave: Bool) {
		
		for poke in self.pokemon {
			poke.purge()
			if autoSave {
				poke.save()
			}
		}
		
	}

	var fullDescription : String {
		let trainerLength = 30
		let pokemonLength = 20

		var string = ""
		let className = self.trainerClass.name.unformattedString

		string += (className + " " + name.string).spaceToLength(trainerLength) + "\n\n"
		for p in pokemon {
			if p.isSet {
				string += ((p.isShadowPokemon ? "Shadow " : "") + p.species.name.string).spaceToLength(pokemonLength)
			}
		}
		string += "\n"

		for p in self.pokemon {
			if p.isSet {
				string += ("Level " + p.level.string).spaceToLength(pokemonLength)
			}
		}
		string += "\n"

		for p in pokemon {
			if p.isSet {
				if p.ability == 0xFF {
					string += "Random".spaceToLength(pokemonLength)
				} else {
					string += (p.ability == 0 ? p.species.ability1 : p.species.ability2).spaceToLength(pokemonLength)
				}
			}
		}
		string += "\n"

		for p in pokemon {
			if p.isSet {
				string += p.item.name.string.spaceToLength(pokemonLength)
			}
		}
		string += "\n"

		for i in 0 ..< 4 {
			for p in pokemon {
				if p.isSet {
					string += p.moves[i].name.string.spaceToLength(pokemonLength)
				}
			}
			string += "\n"
		}

		string += "\n"
		return string
	}
	
}

func allTrainers() -> [XGTrainer] {
	var trainers = [XGTrainer]()
	
	for i in 0 ..< kNumberOfTrainerEntries {
		trainers.append(XGTrainer(index: i))
	}
	
	return trainers
}

extension XGTrainer: XGEnumerable {
	var enumerableName: String {
		return trainerClass.name.string + " " + name.string
	}
	
	var enumerableValue: String? {
		return String(format: "%03d", index)
	}
	
	static var className: String {
		return "Trainers"
	}
	
	static var allValues: [XGTrainer] {
		var values = [XGTrainer]()
		for i in 0 ..< CommonIndexes.NumberOfTrainers.value {
			values.append(XGTrainer(index: i))
		}
		return values
	}
}
