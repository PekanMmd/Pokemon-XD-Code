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

class XGTrainer: NSObject, XGDictionaryRepresentable {

	var index				= 0x0
	var deck				= XGDecks.DeckStory
	
	var nameID				= 0x0
	var trainerStringID		= 0x0
	var trainerString		= ""
	var preBattleTextID		= 0x0
	var victoryTextID		= 0x0
	var defeatTextID		= 0x0
	var shadowMask			= 0x0
	var pokemon				= [XGDeckPokemon]()
	var trainerClass		= XGTrainerClasses.michael1
	var trainerModel		= XGTrainerModels.michael1WithoutSnagMachine
	var AI					= 0
	var cameraEffects		= 0 // some models have unique animations at the start of battle which require special camera movements
	
	var locationString : String {
		get {
			var str = self.trainerString
			let index1 = str.index(str.startIndex, offsetBy: 1)
			let index2 = str.index(str.startIndex, offsetBy: 2)
			let sub1 = str.substring(to: index1)
			
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
				
			} else if sub1 == "N" {
				str = str.replacingCharacters(in: str.startIndex..<index1, with: "Mt.Battle Zone ")
			} else if sub1 == "P" {
				str = str.replacingCharacters(in: str.startIndex..<index1, with: "Pyrite Colosseum ")
			} else if sub1 == "O" {
				str = str.replacingCharacters(in: str.startIndex..<index1, with: "Orre Colosseum ")
			} else if sub1 == "T" {
				str = str.replacingCharacters(in: str.startIndex..<index1, with: "Tower Colosseum ")
			} else {
				let sub = str.substring(to: index2)
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
	
	var dictionaryRepresentation : [String : AnyObject] {
		get {
			var dictRep = [String : AnyObject]()
			dictRep["index"] = self.index as AnyObject?
			dictRep["nameID"] = self.nameID as AnyObject?
			dictRep["trainerString"] = self.trainerString as AnyObject?
			dictRep["preBattleTextID"] = self.preBattleTextID as AnyObject?
			dictRep["victoryTextID"] = self.victoryTextID as AnyObject?
			dictRep["defeatTextID"] = self.defeatTextID as AnyObject?
			dictRep["shadowMask"] = self.shadowMask as AnyObject?
			dictRep["AI"] = self.AI as AnyObject?
			
			dictRep["trainerClass"] = self.trainerClass.dictionaryRepresentation as AnyObject?
			dictRep["trainerModel"] = self.trainerModel.dictionaryRepresentation as AnyObject?
			
			var pokemonArray = [ [String : AnyObject] ]()
			for a in pokemon {
				pokemonArray.append(a.dictionaryRepresentation)
			}
			dictRep["pokemon"] = pokemonArray as AnyObject?
			
			return dictRep
		}
	}
	
	var readableDictionaryRepresentation : [String : AnyObject] {
		get {
			
			var dictRep = [String : AnyObject]()
			dictRep["index"] = self.index as AnyObject?
			dictRep["location"] = self.locationString as AnyObject?
			dictRep["preBattleText"] = getStringSafelyWithID(id: self.preBattleTextID).string as AnyObject
			dictRep["victoryText"] = getStringSafelyWithID(id: self.victoryTextID).string as AnyObject
			dictRep["defeatText"] = getStringSafelyWithID(id: self.defeatTextID).string as AnyObject
			dictRep["hasShadowPokemon"] = (self.shadowMask > 0) as AnyObject?
			dictRep["AI"] = self.AI as AnyObject?
			
			dictRep["trainerClass"] = self.trainerClass.name.string as AnyObject?
			dictRep["trainerModel"] = self.trainerModel.name as AnyObject?
			
			var pokemonArray = [AnyObject]()
			for a in pokemon {
				if a.isSet {
					pokemonArray.append(a.readableDictionaryRepresentation as AnyObject)
				}
			}
			dictRep["pokemon"] = pokemonArray as AnyObject?
			
			return [self.name.string : dictRep as AnyObject]
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
				let lev = poke.isShadow ? poke.level + 5 : poke.level
				
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
		
		deck.replace2BytesAtOffset(start + kTrainerNameIDOffset, withBytes: self.nameID)
		deck.replace2BytesAtOffset(start + kTrainerPreBattleTextIDOffset, withBytes: self.preBattleTextID)
		deck.replace2BytesAtOffset(start + kTrainerVictoryTextIDOffset, withBytes: self.victoryTextID)
		deck.replace2BytesAtOffset(start + kTrainerDefeatTextIDOffset, withBytes: self.defeatTextID)
		
		deck.replaceByteAtOffset(start + kTrainerClassNameOffset , withByte: self.trainerClass.rawValue)
		deck.replaceByteAtOffset(start + kTrainerClassModelOffset, withByte: self.trainerModel.rawValue)
		
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
	
   
}




























