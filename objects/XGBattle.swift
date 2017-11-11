//
//  XGTrainerData.swift
//  GoD Tool
//
//  Created by The Steez on 28/10/2017.
//
//

import Cocoa

let kSizeOfBattleData = 0x3c

let kBattleStyleOffset = 0x2
let kBattlePokemonPerPlayerOffset = 0x3
let kBattleUnknown1Offset = 0x4 // 1 in story, 0 otherwise. could be whether or not to receive prize money or black out etc.
let kBattleFieldOffset = 0x6

let kBattlePlayer1DeckIDOffset = 0x1C
let kBattlePlayer1TrainerIDOffset = 0x1E
let kBattleDeckIDOffset = 0x24
let kBattleTrainerIDOffset = 0x26

enum XGBattleStyles : Int {
	
	case none = 0
	case single = 1
	case double = 2
	
	var name: String {
		switch self {
		case .none:
			return "none"
		case .single:
			return "single"
		case .double:
			return "double"
		}
	}
	
}

class XGBattle: NSObject {
	
	var battleStyle : XGBattleStyles!
	var deck : XGDecks!
	var battleField : XGBattleField!
	var trainerID = 0
	var pokemonPerPlayer = 6
	
	var p1Deck : XGDecks!
	var p1TID = 0
	
	var index = 0
	var startOffset = 0
	
	var trainer : XGTrainer? {
		if deck == nil {
			return nil
		}
		return XGTrainer(index: trainerID, deck: deck)
	}
	
	var p1Trainer : XGTrainer? {
		if p1Deck == nil {
			return nil
		}
		return XGTrainer(index: p1TID, deck: p1Deck)
	}

	var rawData : [Int] {
		return XGFiles.common_rel.data.getByteStreamFromOffset(self.startOffset, length: kSizeOfBattleData)
	}
	
	var title : String {
		let p1t = p1Trainer
		let p1 = p1t == nil ? (p1TID == 0x1388 ? "Player" : "Invalid") : p1t!.name.string
		
		let p2t = trainer
		let p2 = p2t == nil ? "Invalid" : p2t!.name.string
		
		return p1 + " vs. " + p2
	}
	
	override var description: String {
		
		let p1t = p1Trainer
		let p2t = trainer
		
		
		var desc = title + "\n"
		desc += "Location: \(p2t == nil ? "-" : p2t!.locationString)\n"
		if battleField.roomID > 0 {
			desc += "Battle Field: \(battleField.room!.name)\n"
		}
		desc += "\(pokemonPerPlayer) vs. \(pokemonPerPlayer) \(battleStyle.name) battle\n\n"

		if p1t != nil {
			desc += p1t!.fullDescription + "\n"
		}
		
		if p2t != nil {
			desc += p2t!.fullDescription + "\n"
		}

		return desc
	}
	
	init(index: Int) {
		super.init()
		
		self.index = index
		self.startOffset = CommonIndexes.Battles.startOffset + (index * kSizeOfBattleData)
		
		let data = XGFiles.common_rel.data
		
		let style = data.getByteAtOffset(startOffset + kBattleStyleOffset)
		self.battleStyle = XGBattleStyles(rawValue: style) ?? .none
		
		let d = data.get2BytesAtOffset(startOffset + kBattleDeckIDOffset)
		self.deck = XGDecks.deckWithID(d)
		
		let b = data.get2BytesAtOffset(startOffset + kBattleFieldOffset)
		self.battleField = XGBattleField(index: b)
		
		self.trainerID = data.get2BytesAtOffset(startOffset + kBattleTrainerIDOffset)
		self.pokemonPerPlayer = data.getByteAtOffset(startOffset + kBattlePokemonPerPlayerOffset)
		
		let p1d = data.get2BytesAtOffset(startOffset + kBattlePlayer1DeckIDOffset)
		self.p1Deck = XGDecks.deckWithID(p1d)
		
		self.p1TID = data.get2BytesAtOffset(startOffset + kBattlePlayer1TrainerIDOffset)
		
		
	}
	
	func save() {
		
		let data = XGFiles.common_rel.data
		
		data.replaceByteAtOffset(startOffset + kBattleStyleOffset, withByte: self.battleStyle.rawValue)
		data.replace2BytesAtOffset(startOffset + kBattleDeckIDOffset, withBytes: self.deck.id)
		data.replace2BytesAtOffset(startOffset + kBattleFieldOffset, withBytes: self.battleField.index)
		data.replace2BytesAtOffset(startOffset + kBattleTrainerIDOffset, withBytes: self.trainerID)
		data.replaceByteAtOffset(startOffset + kBattlePokemonPerPlayerOffset, withByte: self.pokemonPerPlayer)
		data.replace2BytesAtOffset(startOffset + kBattlePlayer1DeckIDOffset, withBytes: (self.p1Deck ?? .DeckDarkPokemon).id)
		data.replace2BytesAtOffset(startOffset + kBattlePlayer1TrainerIDOffset, withBytes: self.p1TID)
		
		data.save()
	}
	
	class func battleForTrainer(index: Int, deck: XGDecks) -> XGBattle? {
		for i in 0 ..< CommonIndexes.NumberOfBattles.value {
			let battle = XGBattle(index: i)
			if battle.deck == deck && battle.trainerID == index {
				return battle
			}
		}
		return nil
	}
	
}











