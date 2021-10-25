//
//  XGTrainerData.swift
//  GoD Tool
//
//  Created by The Steez on 28/10/2017.
//
//

import Foundation

var kSizeOfBattleData: Int {
	return region == .EU ? 0x4C : 0x3C
}

let kBattleBattleTypeOffset = 0x0
let kBattleTrainersPerSideOffset = 0x1
let kBattleStyleOffset = 0x2
let kBattlePokemonPerPlayerOffset = 0x3
let kBattleUnknown1Offset = 0x4 // 1 in story, 0 otherwise. could be whether or not to receive prize money or black out etc.
let kBattleFieldOffset = 0x6
let kBattleBattleCDIDOffset = 0x8 // 2 bytes, set programmatically so is always 0 in the game files
let kBattleBGMOffset = 0x12
let kBattleUnknown2Offset = 0x17
let kBattleColosseumRoundOffset = 0x1b

var kBattlePlayer1DeckIDOffset: Int { return region == .EU ? 0x2C : 0x1C }
var kBattlePlayer1TrainerIDOffset: Int { return region == .EU ? 0x2E : 0x1E }
var kBattlePlayer1ControlOffset: Int { return region == .EU ? 0x23 : 0x23 }

var kBattlePlayer2DeckIDOffset: Int { return region == .EU ? 0x34 : 0x24 }
var kBattlePlayer2TrainerIDOffset: Int { return region == .EU ? 0x36 : 0x26 }
var kBattlePlayer2ControlOffset: Int { return region == .EU ? 0x3B : 0x2B }

var kBattlePlayer3DeckIDOffset: Int { return region == .EU ? 0x3C : 0x2C }
var kBattlePlayer3TrainerIDOffset: Int { return region == .EU ? 0x3E : 0x2E }
var kBattlePlayer3ControlOffset: Int { return region == .EU ? 0x33 : 0x33 }

var kBattlePlayer4DeckIDOffset: Int { return region == .EU ? 0x44 : 0x34 }
var kBattlePlayer4TrainerIDOffset: Int { return region == .EU ? 0x46 : 0x36 }
var kBattlePlayer4ControlOffset: Int { return region == .EU ? 0x4B : 0x3B }

final class XGBattle: Codable {
	
	var index = 0
	var startOffset = 0
	
	var battleType: XGBattleTypes
	var battleStyle: XGBattleStyles
	var battleField: XGBattleField
	var trainersPerSide = 0
	var pokemonPerPlayer = 0
	var BGMusicID = 0
	var round = XGColosseumRounds.none
	var unknown = false
	var unknown2 = 0
	
	var p1Deck : XGDecks!
	var p1TID = 0
	var p1Controller : XGTrainerController!
	var p1Trainer : XGTrainer? {
		if p1Deck == nil {
			return nil
		}
		return XGTrainer(index: p1TID, deck: p1Deck)
	}
	
	var p2Deck : XGDecks!
	var p2TID = 0
	var p2Controller : XGTrainerController!
	var p2Trainer : XGTrainer? {
		if p2Deck == nil {
			return nil
		}
		return XGTrainer(index: p2TID, deck: p2Deck)
	}
	
	var p3Deck : XGDecks!
	var p3TID = 0
	var p3Controller : XGTrainerController!
	var p3Trainer : XGTrainer? {
		if p3Deck == nil {
			return nil
		}
		return XGTrainer(index: p3TID, deck: p3Deck)
	}
	
	var p4Deck : XGDecks!
	var p4TID = 0
	var p4Controller : XGTrainerController!
	var p4Trainer : XGTrainer? {
		if p4Deck == nil {
			return nil
		}
		return XGTrainer(index: p4TID, deck: p4Deck)
	}
	
	
	var rawData : [Int] {
		return XGFiles.common_rel.data!.getByteStreamFromOffset(self.startOffset, length: kSizeOfBattleData)
	}
	
	var title : String {
		
		let p1t = p1Trainer
		let p1 = p1t == nil ? (p1TID == 0x1388 ? "Player" : "Invalid") : p1t!.trainerClass.name.unformattedString.titleCased + " " + p1t!.name.string.titleCased
		
		let p2t = p2Trainer
		let p2 = p2t == nil ? (p2TID == 0x1388 ? "Player" : "Invalid") : p2t!.trainerClass.name.unformattedString.titleCased + " " + p2t!.name.string.titleCased
		
		let p3t = p3Trainer
		let p3 = p3t == nil ? (p3TID == 0x1388 ? "Player" : "Invalid") : p3t!.trainerClass.name.unformattedString.titleCased + " " + p3t!.name.string.titleCased
		
		let p4t = p4Trainer
		let p4 = p4t == nil ? (p4TID == 0x1388 ? "Player" : "Invalid") : p4t!.trainerClass.name.unformattedString.titleCased + " " + p4t!.name.string.titleCased
		
		var str = p1 + ( p3t == nil && p4t == nil ? " vs. " : " & ")
		str += p2 + ( p3t == nil && p4t == nil ? "" : " vs. ")
		if p3t != nil || p4t != nil { str += p3 + " & " + p4 }
		
		return str
	}
	
	var description: String {
		
		let p1t = p1Trainer
		let p2t = p2Trainer
		let p3t = p3Trainer
		let p4t = p4Trainer
		
		var desc = title + "\n"
		desc += "Location: \(p2t == nil ? "-" : p2t!.locationString)\n"
		if battleField.roomID > 0 {
			desc += "Battle Field: \(battleField.room!.name)\n"
		}
		if round != .none {
			desc += round.name
		}
		let style = p3t == nil ? battleStyle.name : XGBattleStyles.double.name
		desc += "\(pokemonPerPlayer) pokémon \(style) battle (\(battleType.name))\n\n"

		if p1t != nil {
			desc += p1t!.fullDescription + "\n"
		}
		
		if p2t != nil {
			desc += p2t!.fullDescription + "\n"
		}
		
		if p3t != nil {
			desc += p3t!.fullDescription + "\n"
		}
		
		if p4t != nil {
			desc += p4t!.fullDescription + "\n"
		}

		return desc
	}

	var shortDescription: String {
		var desc = title + "\n"
		desc += "Location: \(p2Trainer == nil ? "-" : p2Trainer!.locationString)\n"
		if battleField.roomID > 0 {
			desc += "Battle Field: \(battleField.room!.name)\n"
		}
		if round != .none {
			desc += round.name
		}
		let style = p3Trainer == nil ? battleStyle.name : XGBattleStyles.double.name
		desc += "\(pokemonPerPlayer) pokémon \(style) battle (\(battleType.name))\n\n"

		return desc
	}
	
	init(index: Int) {
		self.index = index
		self.startOffset = CommonIndexes.Battles.startOffset + (index * kSizeOfBattleData)
		
		let data = XGFiles.common_rel.data!
		
		let style = data.getByteAtOffset(startOffset + kBattleStyleOffset)
		self.battleStyle = XGBattleStyles(rawValue: style) ?? .other
		
		let t = data.getByteAtOffset(startOffset + kBattleBattleTypeOffset)
		self.battleType = XGBattleTypes(rawValue: t) ?? XGBattleTypes.none
		
		let r = data.getByteAtOffset(startOffset + kBattleColosseumRoundOffset)
		self.round = XGColosseumRounds(rawValue: r) ?? .none
		
		let b = data.get2BytesAtOffset(startOffset + kBattleFieldOffset)
		self.battleField = XGBattleField(index: b)
		
		self.trainersPerSide = data.getByteAtOffset(startOffset + kBattleTrainersPerSideOffset)
		self.pokemonPerPlayer = data.getByteAtOffset(startOffset + kBattlePokemonPerPlayerOffset)
		self.BGMusicID = data.get2BytesAtOffset(startOffset + kBattleBGMOffset)
		self.unknown = data.getByteAtOffset(startOffset + kBattleUnknown1Offset) == 1
		self.unknown2 = data.getByteAtOffset(startOffset + kBattleUnknown2Offset)
		
		self.p1TID = data.get2BytesAtOffset(startOffset + kBattlePlayer1TrainerIDOffset)
		let p1d = data.get2BytesAtOffset(startOffset + kBattlePlayer1DeckIDOffset)
		self.p1Deck = XGDecks.deckWithID(p1d)
		let p1c = data.getByteAtOffset(startOffset + kBattlePlayer1ControlOffset)
		self.p1Controller = XGTrainerController(rawValue: p1c) ?? .AI
		
		self.p2TID = data.get2BytesAtOffset(startOffset + kBattlePlayer2TrainerIDOffset)
		let p2d = data.get2BytesAtOffset(startOffset + kBattlePlayer2DeckIDOffset)
		self.p2Deck = XGDecks.deckWithID(p2d)
		let p2c = data.getByteAtOffset(startOffset + kBattlePlayer2ControlOffset)
		self.p2Controller = XGTrainerController(rawValue: p2c) ?? .AI
		
		self.p3TID = data.get2BytesAtOffset(startOffset + kBattlePlayer3TrainerIDOffset)
		let p3d = data.get2BytesAtOffset(startOffset + kBattlePlayer3DeckIDOffset)
		self.p3Deck = XGDecks.deckWithID(p3d)
		let p3c = data.getByteAtOffset(startOffset + kBattlePlayer3ControlOffset)
		self.p3Controller = XGTrainerController(rawValue: p3c) ?? .AI
		
		self.p4TID = data.get2BytesAtOffset(startOffset + kBattlePlayer4TrainerIDOffset)
		let p4d = data.get2BytesAtOffset(startOffset + kBattlePlayer4DeckIDOffset)
		self.p4Deck = XGDecks.deckWithID(p4d)
		let p4c = data.getByteAtOffset(startOffset + kBattlePlayer4ControlOffset)
		self.p4Controller = XGTrainerController(rawValue: p4c) ?? .AI
		
		
	}
	
	func save() {
		
		let data = XGFiles.common_rel.data!
		
		data.replaceByteAtOffset(startOffset + kBattleBattleTypeOffset, withByte: self.battleType.rawValue)
		data.replaceByteAtOffset(startOffset + kBattleTrainersPerSideOffset, withByte: self.trainersPerSide)
		data.replaceByteAtOffset(startOffset + kBattlePokemonPerPlayerOffset, withByte: self.pokemonPerPlayer)
		data.replaceByteAtOffset(startOffset + kBattleStyleOffset, withByte: self.battleStyle.rawValue)
		data.replaceByteAtOffset(startOffset + kBattleColosseumRoundOffset, withByte: self.round.rawValue)
		data.replaceByteAtOffset(startOffset + kBattleUnknown1Offset, withByte: self.unknown ? 1 : 0)
		data.replaceByteAtOffset(startOffset + kBattleUnknown2Offset, withByte: self.unknown2)
		
		data.replace2BytesAtOffset(startOffset + kBattleFieldOffset, withBytes: self.battleField.index)
		data.replace2BytesAtOffset(startOffset + kBattleBGMOffset, withBytes: self.BGMusicID)
		
		data.replace2BytesAtOffset(startOffset + kBattlePlayer1DeckIDOffset, withBytes: (self.p1Deck ?? .DeckDarkPokemon).id)
		data.replace2BytesAtOffset(startOffset + kBattlePlayer1TrainerIDOffset, withBytes: self.p1TID)
		data.replaceByteAtOffset(startOffset + kBattlePlayer1ControlOffset, withByte: self.p1Controller.rawValue)
		
		data.replace2BytesAtOffset(startOffset + kBattlePlayer2DeckIDOffset, withBytes: (self.p2Deck ?? .DeckDarkPokemon).id)
		data.replace2BytesAtOffset(startOffset + kBattlePlayer2TrainerIDOffset, withBytes: self.p2TID)
		data.replaceByteAtOffset(startOffset + kBattlePlayer2ControlOffset, withByte: self.p2Controller.rawValue)
		
		data.replace2BytesAtOffset(startOffset + kBattlePlayer3DeckIDOffset, withBytes: (self.p3Deck ?? .DeckDarkPokemon).id)
		data.replace2BytesAtOffset(startOffset + kBattlePlayer3TrainerIDOffset, withBytes: self.p3TID)
		data.replaceByteAtOffset(startOffset + kBattlePlayer3ControlOffset, withByte: self.p3Controller.rawValue)
		
		data.replace2BytesAtOffset(startOffset + kBattlePlayer4DeckIDOffset, withBytes: (self.p4Deck ?? .DeckDarkPokemon).id)
		data.replace2BytesAtOffset(startOffset + kBattlePlayer4TrainerIDOffset, withBytes: self.p4TID)
		data.replaceByteAtOffset(startOffset + kBattlePlayer4ControlOffset, withByte: self.p4Controller.rawValue)
		
		data.save()
	}
	
	func setToWildPokemon() {
		
		self.p2Deck = XGDecks.deckWithID(7)
		self.p2TID = 7
		self.battleType = .wild_pokemon
		self.trainersPerSide = 0
		self.battleStyle = .single
		self.pokemonPerPlayer = 6
		self.unknown = true
		self.unknown2 = 6
		self.save()
		
		let data = XGFiles.common_rel.data!
		
		data.replace2BytesAtOffset(self.startOffset + 0xE, withBytes: 0xf6ec)
		
		data.save()
	}
	
	class func battleForTrainer(index: Int, deck: XGDecks) -> XGBattle? {
		for i in 0 ..< CommonIndexes.NumberOfBattles.value {
			let battle = XGBattle(index: i)
			if battle.p1Deck == deck && battle.p1TID == index {
				return battle
			}
			if battle.p2Deck == deck && battle.p2TID == index {
				return battle
			}
			if battle.p3Deck == deck && battle.p3TID == index {
				return battle
			}
			if battle.p4Deck == deck && battle.p4TID == index {
				return battle
			}
		}
		return nil
	}
	
}

extension XGBattle: XGEnumerable {
	var enumerableName: String {
		return title.spaceToLength(40)
	}
	
	var enumerableValue: String? {
		return String(format: "%03d", index)
	}
	
	static var className: String {
		return "Battles"
	}
	
	static var allValues: [XGBattle] {
		var values = [XGBattle]()
		for i in 0 ..< CommonIndexes.NumberOfBattles.value {
			values.append(XGBattle(index: i))
		}
		return values
	}
}

extension XGBattle: XGDocumentable {
	
	var documentableName: String {
		return (enumerableValue ?? "") + " - " + enumerableName
	}
	
	static var DocumentableKeys: [String] {
		return ["index", "hex index", "title", "description"]
	}
	
	func documentableValue(for key: String) -> String {
		switch key {
		case "index":
            return index.string
		case "hex index":
			return index.hexString()
		case "title":
            return title
        case "description":
            return description
		default:
			return ""
		}
	}
}







