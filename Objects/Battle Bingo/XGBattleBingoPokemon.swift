//
//  XGBattleBingoPokemon.swift
//  XG Tool
//
//  Created by The Steez on 11/06/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//

import UIKit

let kSizeOfBattleBingoPokemonData		= 0x0A

let kBattleBingoPokemonPanelTypeOffset	= 0x00
let kBattleBingoPokemonAbilityOffset	= 0x01
let kBattleBingoPokemonNatureOffset		= 0x02
let kBattleBingoPokemonGenderOffset		= 0x03
let kBattleBingoPokemonSpeciesOffset	= 0x04
let kBattleBingoPokemonMoveOffset		= 0x06

class XGBattleBingoPokemon: NSObject {
	
	var deckData	= XGDeckPokemon.DPKM(0, XGDecks.DeckStory)
	
	var species		= XGPokemon.Pokemon(0)
	var level		= 0x0
	var happiness	= 0x0
	var ability		= 0x0
	var item		= XGItems.Item(0)
	var nature		= XGNatures.Hardy
	var gender		= XGGenders.Male
	var IVs			= 0x0 // All IVs will be the same. Not much point in varying them.
	var EVs			= [Int]()
	var moves		= [XGMoves](count: kNumberOfPokemonMoves, repeatedValue: XGMoves.Move(0))
	
	var shadowCatchRate = 0x0
	var shadowCounter	= 0x0
	var shadowMoves	= [XGMoves](count: kNumberOfPokemonMoves, repeatedValue: XGMoves.Move(0))
	
	var startOffset : Int {
		get {
			return deckData.deck.DPKMDataOffset + (deckData.DPKMIndex * kSizeOfPokemonData)
		}
	}
	
	var shadowStartOffset : Int {
		get {
			return XGDecks.DeckDarkPokemon.DDPKDataOffset + (deckData.index * kSizeOfShadowData)
		}
	}
	
	var isShadowPokemon : Bool {
		get {
			return deckData.isShadow
		}
	}
	
	var isSet : Bool {
		get {
			return deckData.isSet
		}
	}
	
	init(startOffset: Int) {
		super.init()
		
		
		var data = deckData.deck.data
		var start = self.startOffset
		
		species			= deckData.pokemon
		level			= deckData.level
		
		happiness		= data.getByteAtOffset(start + kPokemonHappinessOffset)
		var item		= data.get2BytesAtOffset(start + kPokemonItemOffset)
		self.item		= .Item(item)
		IVs				= data.getByteAtOffset(start + kFirstPokemonIVOffset)
		
		var pid = data.getByteAtOffset(start + kPokemonPIDOffset)
		
		ability		= pid % 2
		
		var gender	= (pid / 2) % 4
		self.gender = XGGenders(rawValue: gender)!
		
		var nature	= pid / 8
		self.nature	= XGNatures(rawValue: nature)!
		
		self.EVs = data.getByteStreamFromOffset(start + kFirstPokemonEVOffset, length: kNumberOfEVs)
		
		for var i = 0; i < kNumberOfPokemonMoves; i++ {
			let index = data.get2BytesAtOffset(start + kFirstPokemonMoveOffset + i)
			self.moves[i] = .Move(index)
		}
		
		if isShadowPokemon {
			
			var data = XGDecks.DeckDarkPokemon.data
			var start = self.shadowStartOffset
			
			shadowCatchRate = data.getByteAtOffset(start + kShadowCatchRateOFfset)
			shadowCounter	= data.get2BytesAtOffset(start + kShadowCounterOffset)
			
			for var i = 0; i < kNumberOfPokemonMoves; i++ {
				let index = data.get2BytesAtOffset(start + kFirstShadowMoveOFfset + i)
				self.shadowMoves[i] = .Move(index)
			}
		}
		
	}
	
	
	
   
}























