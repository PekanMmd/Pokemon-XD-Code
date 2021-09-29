//
//  Trainer.swift
//  Mausoleum Tool
//
//  Created by StarsMmd on 25/09/2014.
//  Copyright (c) 2014 Steezy. All rights reserved.
//

import Foundation

let kSizeOfTrainerData				= 0x38
let kSizeOfAIData					= 0x20
let kNumberOfTrainerPokemon			= 0x06

let kStringOffset					= 0x00
let kShadowMaskOffset				= 0x04
let kTrainerClassNameOffset			= 0x05
let kTrainerNameIDOffset			= 0x06
let kTrainerClassModelOffset		= 0x11
let kTrainerCameraEffectOffset		= 0x12
let kTrainerPreBattleTextIDOffset	= 0x14
let kTrainerVictoryTextIDOffset		= 0x16
let kTrainerDefeatTextIDOffset		= 0x18
let kFirstTrainerPokemonOffset		= 0x1C
let kTrainerAIOffset				= 0x28 // 2bytes

typealias TrainerInfo = (name:String,location:String,hasShadow: Bool,trainerModel:XGTrainerModels,index:Int,deck:XGDecks)

final class XGTrainer: NSObject, Codable {

	var index				= 0x0
	var deck					= XGDecks.DeckStory
	
	var nameID			= 0x0
	var trainerStringID	= 0x0
	var trainerString		= ""
	var preBattleTextID	= 0x0
	var victoryTextID		= 0x0
	var defeatTextID		= 0x0
	var shadowMask		= 0x0
	var pokemon				= [XGDeckPokemon]()
	var trainerClass		= XGTrainerClasses.michael1
	var trainerModel		= XGTrainerModels.michael1WithoutSnagMachine
	var AI					= 0
	var cameraEffects		= 0 // some models have unique animations at the start of battle which require special camera movements
	
	var locationString : String {
		get {
			var str = self.trainerString
			guard str.length > 1 else { return "Unknown" }
			let index1 = str.index(str.startIndex, offsetBy: 1)
			let sub1 = str.substring(from: 0, to: 1)
			
			if str == "NULL" {
				str = "-"
			} else if str.range(of: "Opening") != nil {
				
				str = str.replacingOccurrences(of: "_p", with: " Player Team")
				str = str.replacingOccurrences(of: "_e", with: " Enemy Team")
				str = str.replacingOccurrences(of: "Opening", with: "Opening Battle")
				
			} else if str.range(of: "Vdisk") != nil {
				
				str = str.replacingOccurrences(of: "_p", with: " Player Team")
				str = str.replacingOccurrences(of: "_e", with: " Enemy Team")
				str = str.replacingOccurrences(of: "Vdisk", with: "Battle CD ")
				
			} else if str.range(of: "Tutor") != nil {
				
				str = str.replacingOccurrences(of: "p", with: " Player Team")
				str = str.replacingOccurrences(of: "e", with: " Enemy Team")
				str = str.replacingOccurrences(of: "Tutor", with: "Tutor Sim ")
				
			} else if sub1 == "N" {
				str = str.replacingCharacters(in: str.startIndex..<index1, with: "Mt.Battle Zone ")
			} else if sub1 == "P" {
				str = str.replacingCharacters(in: str.startIndex..<index1, with: "Pyrite Colosseum ")
			} else if sub1 == "O" {
				str = str.replacingCharacters(in: str.startIndex..<index1, with: "Orre Colosseum ")
			} else if sub1 == "T" {
				str = str.replacingCharacters(in: str.startIndex..<index1, with: "Tower Colosseum ")
			} else {
				let sub = str.substring(from: 0, to: 2)
				str = XGMaps(rawValue: sub)?.name ?? str
			}
			
			str = str.replacingOccurrences(of: "_col_", with: " Colosseum ")
			str = str.replacingOccurrences(of: "555_", with: "Battle ")
			str = str.replacingOccurrences(of: "Esaba", with: "Pokespot")
			str = str.replacingOccurrences(of: "_", with: " ")
			str = str.replacingOccurrences(of: "Mirabo", with: "Miror B.")
			str = str.replacingOccurrences(of: "mirabo", with: "Miror B.")
			str = str.replacingOccurrences(of: "haihu", with: "Gift")
			
			
			return str
		}
	}
	
	override var description : String {
		get {
			var s = ""
			
			s += "--------------------------\n"
			s += "\(self.index): \(self.trainerClass.name) \(self.name)\n"
			s += "--------------------------\n"
			for p in self.pokemon {
				s += "level \(p.level) : \(p.pokemon.name)"
				s += p.isShadow ? "(Shadow)\n" : "\n"
			}
			
			s += "--------------------------\n"
			
			return s
		}
	}
	
	var fullDescription : String {
		get {
			
			let trainerLength = 30
			let pokemonLength = 20
			let trainerTab = "".spaceToLength(trainerLength)
			
			var string = ""
			let name = self.trainerClass.name
			if name.stringLength > 1 {
				switch name.chars[0] {
				case .special( _, _) : name.chars[0...1] = [name.chars[1]]
				default: break
				}
			}
			
			string += (name.string + " " + self.name.string).spaceToLength(trainerLength)
			for p in self.pokemon {
				if p.isSet {
					string += ((p.isShadow ? "Shadow " : "") + p.pokemon.name.string).spaceToLength(pokemonLength)
				}
			}
			string += "\n" + self.locationString.spaceToLength(trainerLength)
			
			for p in self.pokemon {
				if p.isSet {
					string += ("Level " + p.level.string + (p.isShadow ? "+" : "")).spaceToLength(pokemonLength)
				}
			}
			string += "\n" + trainerTab
			
			let mons = self.pokemon.map({ (dpoke) -> XGTrainerPokemon in
				return dpoke.data
			})
			
			for p in mons {
				if p.isSet {
					string += (p.ability == 0 ? p.species.ability1 : p.species.ability2).spaceToLength(pokemonLength)
				}
			}
			string += "\n" + trainerTab
			
			for p in mons {
				if p.isSet {
					string += p.item.name.string.spaceToLength(pokemonLength)
				}
			}
			string += "\n" + trainerTab
			
			for i in 0 ..< 4 {
				
				for p in mons {
					if p.isSet {
						string += (p.shadowMoves[i].index == 0 ? p.moves[i] : p.shadowMoves[i]).name.string.spaceToLength(pokemonLength)
					}
				}
				
				string += "\n" + trainerTab
			}
			
			
			string += "\n"
			return string
		}
	}
	
	var startOffset : Int {
		get {
			return deck.DTNRDataOffset + (index * kSizeOfTrainerData)
		}
	}
	
	var name : XGString {
		get {
			return XGFiles.common_rel.stringTable.stringSafelyWithID(self.nameID)
		}
	}
	
	var prizeMoney : Int {
		get {
			var maxLevel = 0
			
			for poke in self.pokemon {
				let lev = poke.isShadow ? poke.data.shadowBoostLevel : poke.level
				
				maxLevel = lev > maxLevel ? lev : maxLevel
			}
			
			return self.trainerClass.payout * 2 * maxLevel
		}
	}
	
	var hasShadow : Bool {
		get {
			return self.shadowMask > 0
		}
	}
	
	var battleData : XGBattle? {
		return XGBattle.battleForTrainer(index: self.index, deck: self.deck)
	}

	var trainerInfo: TrainerInfo {
		return (self.trainerClass.name.unformattedString + " " + self.name.unformattedString, self.locationString,self.hasShadow,self.trainerModel,self.index,self.deck)
	}
	
	init(index: Int, deck: XGDecks) {
		super.init()
		
		self.index = index
		self.deck  = deck
		
		let start = startOffset
		let deck = deck.data
		
		self.trainerStringID = deck.get2BytesAtOffset(start + kStringOffset)
		
		var currentOff = self.deck.DSTRDataOffset + self.trainerStringID
		var name = ""
		var currentChar = 1
		
		while currentChar != 0 {
			currentChar = deck.getByteAtOffset(currentOff)
			if currentChar != 0 {
				let ch = String(describing: UnicodeScalar(currentChar)!)
				name += ch
			}
			currentOff += 1
		}
		self.trainerString = name
		
		self.nameID =  deck.get2BytesAtOffset(start + kTrainerNameIDOffset)
		self.preBattleTextID = deck.get2BytesAtOffset(start + kTrainerPreBattleTextIDOffset)
		self.victoryTextID = deck.get2BytesAtOffset(start + kTrainerVictoryTextIDOffset)
		self.defeatTextID = deck.get2BytesAtOffset(start + kTrainerDefeatTextIDOffset)
		
		self.shadowMask = deck.getByteAtOffset(start + kShadowMaskOffset)
		
		var mask = self.shadowMask
		
		for i in 0 ..< 6 {
			
			let id = deck.get2BytesAtOffset(start + kFirstTrainerPokemonOffset + (i*2))
			let m = mask % 2
			if  m == 1 {
				self.pokemon.append(.ddpk(id))
			} else {
				self.pokemon.append(.dpkm(id,self.deck))
			}
			mask = mask >> 1
		}
		
		let tClass = deck.getByteAtOffset(start + kTrainerClassNameOffset)
		let tModel = deck.getByteAtOffset(start + kTrainerClassModelOffset)
		
		self.trainerClass = XGTrainerClasses(rawValue: tClass) ?? .michael1
		self.trainerModel = XGTrainerModels(rawValue: tModel)  ?? .michael1WithoutSnagMachine
		
		self.AI = deck.get2BytesAtOffset(start + kTrainerAIOffset)
		
		self.cameraEffects = deck.get2BytesAtOffset(start + kTrainerCameraEffectOffset)
	}
	
	func save() {
		
		let start = startOffset
		let deck = self.deck.data
		
		deck.replace2BytesAtOffset(start + kTrainerCameraEffectOffset, withBytes: self.cameraEffects)
		
		for id in [nameID, preBattleTextID, victoryTextID, defeatTextID] {
			if id > 0xFFFF {
				printg("warning: trainer msg ids must not exceed 0xFFFF (~32,000)\n\(self.deck.fileName + " " + self.index.hexString())")
			}
		}
		deck.replace2BytesAtOffset(start + kTrainerNameIDOffset, withBytes: self.nameID)
		deck.replace2BytesAtOffset(start + kTrainerPreBattleTextIDOffset, withBytes: self.preBattleTextID)
		deck.replace2BytesAtOffset(start + kTrainerVictoryTextIDOffset, withBytes: self.victoryTextID)
		deck.replace2BytesAtOffset(start + kTrainerDefeatTextIDOffset, withBytes: self.defeatTextID)
		
		deck.replaceByteAtOffset(start + kTrainerClassNameOffset , withByte: self.trainerClass.rawValue)
		deck.replaceByteAtOffset(start + kTrainerClassModelOffset, withByte: self.trainerModel.rawValue)
		deck.replace2BytesAtOffset(start + kStringOffset, withBytes: self.trainerStringID)
		
		var current = start + kFirstTrainerPokemonOffset
		
		
		var mask = 0
		
		for i in 0 ..< 6 {
			mask = mask << 1
			mask += self.pokemon[5 - i].isShadow ? 1 : 0
		}
		
		deck.replaceByteAtOffset(start + kShadowMaskOffset, withByte: mask)
		
		for i in 0 ..< 6 {
			
			deck.replace2BytesAtOffset(current, withBytes: self.pokemon[i].index)
			
			current += 2
		}
		
		deck.replace2BytesAtOffset(start + kTrainerAIOffset, withBytes: self.AI)
		deck.replace2BytesAtOffset(start + kTrainerCameraEffectOffset, withBytes: self.cameraEffects)
		
		deck.save()
	}
	
	func setAI(to ai: XGAI) {
		self.AI = ai.rawValue
	}
   
}

func allTrainers() -> [XGTrainer] {
	var trainers = [XGTrainer]()
	
	for deck in TrainerDecksArray {
		trainers += deck.allTrainers
	}
	
	return trainers
}

extension XGTrainer: XGEnumerable {
	var enumerableName: String {
		return trainerClass.name.string + " " + name.string
	}
	
	var enumerableValue: String? {
		return deck.enumerableName + " " + String(format: "%03d", index)
	}
	
	static var className: String {
		return "Trainers"
	}
	
	static var allValues: [XGTrainer] {
		var values = [XGTrainer]()
		for deck in TrainerDecksArray {
			values += deck.allTrainers
		}
		return values
	}
}

//extension XGTrainer: XGDocumentable {
//	
//	static var className: String {
//		return"Trainers"
//	}
//	
//	var documentableName: String {
//		return (enumerableValue ?? "") + " - " + enumerableName
//	}
//	
//	static var DocumentableKeys: [String] {
//		return ["index", "name", "level", "gender", "nature", "shininess", "moves"]
//	}
//	
//	func documentableValue(for key: String) -> String {
//		switch key {
//		case "index":
//			return index.string
//		case "name":
//			return species.name.string
//		case "level":
//			return level.string
//		case "gender":
//			return gender.string
//		case "nature":
//			return nature.string
//		case "shininess":
//			return shinyValue.string
//		case "moves":
//			var text = ""
//			text += "\n" + move1.name.string
//			text += "\n" + move2.name.string
//			text += "\n" + move3.name.string
//			text += "\n" + move4.name.string
//			return text
//		default:
//			return ""
//		}
//	}
//}
























