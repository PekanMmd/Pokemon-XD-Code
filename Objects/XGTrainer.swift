//
//  Trainer.swift
//  Mausoleum Tool
//
//  Created by The Steez on 25/09/2014.
//  Copyright (c) 2014 Steezy. All rights reserved.
//

import UIKit

let kSizeOfTrainerData				= 0x38
let kSizeOfAIData					= 0x20
let kNumberOfTrainerPokemon			= 0x06

let kStringOffset					= 0x00
let kShadowMaskOffset				= 0x04
let kTrainerClassNameOffset			= 0x05
let kTrainerNameIDOffset			= 0x06
let kTrainerClassModelOffset		= 0x11
let kTrainerAIOffset				= 0x12 // 2bytes
let kTrainerPreBattleTextIDOffset	= 0x14
let kTrainerVictoryTextIDOffset		= 0x16
let kTrainerDefeatTextIDOffset		= 0x18
let kFirstTrainerPokemonOffset		= 0x1C

class XGTrainer: NSObject {

	var index				= 0x0
	var deck				= XGDecks.DeckStory
	
	var nameID				= 0x0
	var trainerString		= ""
	var preBattleTextID		= 0x0
	var victoryTextID		= 0x0
	var DefeatTextID		= 0x0
	var pokemonIndexes		= [Int]()
	var shadowIndexes		= [Int]()
	var trainerClass		= XGTrainerClasses.Michael1
	var trainerModel		= XGTrainerModels.Michael1WithoutSnagMachine
	
	init(index: Int, deck: XGDecks) {
		super.init()
		
		self.index = index
		self.deck  = deck
		
	}
	
   
}























