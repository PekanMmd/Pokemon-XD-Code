//
//  CMBattle.swift
//  Colosseum Tool
//
//  Created by The Steez on 23/08/2018.
//

import Cocoa

let kSizeOfBattleData = 0x38

let kBattleBattleTypeOffset = 0x0
let kBattleFieldOffset  = 0x5
let kBattleNameIDOffset = 0x8
let kBattleColosseumRoundOffset = 0x16

let kBattleTrainer1IndexOffset = 0x18
let kBattleTrainer1ControlOffset = 0x1f
let kBattleTrainer2IndexOffset = 0x20
let kBattleTrainer2ControlOffset = 0x27
let kBattleTrainer3IndexOffset = 0x28
let kBattleTrainer3ControlOffset = 0x2f
let kBattleTrainer4IndexOffset = 0x30
let kBattleTrainer4ControlOffset = 0x37



class XGBattle: NSObject, Codable {
	
	var battleType : XGBattleTypes?
	var battleStyle : XGBattleStyles?
	var battleField : XGBattleField?
	var trainersPerSide = 0
	var pokemonPerPlayer = 6
	var BGMusicID = 0
	var round = XGColosseumRounds.none
	var unknown = false
	var unknown2 = 0
	var index = 0
	
	func save() {
		
	}
}




