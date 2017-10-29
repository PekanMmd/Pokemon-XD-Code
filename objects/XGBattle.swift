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
let kBattleFieldOffset = 0x6
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
	
	var index = 0
	var startOffset = 0
	
	var trainer : XGTrainer {
		return XGTrainer(index: trainerID, deck: deck)
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











