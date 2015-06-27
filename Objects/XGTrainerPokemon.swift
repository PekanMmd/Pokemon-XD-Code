//
//  Pokemon.swift
//  Mausoleum Tool
//
//  Created by The Steez on 03/10/2014.
//  Copyright (c) 2014 Steezy. All rights reserved.
//

import Foundation

let kSizeOfPokemonData		= 0x20
let kNumberOfPokemonMoves	= 0x04
let kNumberOfEVs			= 0x06
let kNumberOfIVs			= 0x06

let kPokemonIndexOffset		= 0x00
let kPokemonLevelOffset		= 0x02
let kPokemonHappinessOffset	= 0x03
let kPokemonItemOffset		= 0x04
let kFirstPokemonIVOffset	= 0x08
let kFirstPokemonEVOffset	= 0x0E
let kFirstPokemonMoveOffset	= 0x14
let kPokemonPIDOffset		= 0x1E

let kSizeOfShadowData		= 0x18

let kShadowCatchRateOFfset	= 0x01
let kShadowLevelOffset		= 0x02
let kShadowStoryIndexOffset	= 0x06
let kShadowCounterOffset	= 0x08
let kFirstShadowMoveOFfset	= 0x0C

class XGTrainerPokemon : NSObject {
	
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
	
	init(DeckData: XGDeckPokemon) {
		super.init()
		
		self.deckData = DeckData
		
		
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
	
	
	func save() {
		
		if self.isSet {
			
			var data = self.deckData.deck.data
			let start = startOffset
			
			data.replace2BytesAtOffset(start + kPokemonIndexOffset, withBytes: species.index)
			data.replace2BytesAtOffset(start + kPokemonItemOffset, withBytes: item.index)
			data.replaceByteAtOffset(start + kPokemonHappinessOffset, withByte: happiness)
			data.replaceByteAtOffset(start + kPokemonLevelOffset, withByte: isShadowPokemon ? 0 : level)
			// Shadow Pokemon have their level determined by the level in DDPK. Might as well set this to 0 to improve compression.
			
			var pid = self.nature.rawValue << 3
			pid += self.gender.rawValue << 1
			pid += self.ability
			
			data.replaceByteAtOffset(start + kPokemonPIDOffset, withByte: pid)
			
			let IVs = [Int](count: kNumberOfIVs, repeatedValue: self.IVs)
			data.replaceBytesFromOffset(start + kFirstPokemonIVOffset, withByteStream: IVs)
			
			data.replaceBytesFromOffset(start + kFirstPokemonEVOffset, withByteStream: self.EVs)
			
			for var i = 0; i < kNumberOfPokemonMoves; i++ {
				data.replace2BytesAtOffset(start + kFirstPokemonMoveOffset + i, withBytes: self.moves[i].index)
			}
			
			data.save()
		}
		
		if self.isShadowPokemon {
			
			var data = XGDecks.DeckDarkPokemon.data
			
			data.replaceByteAtOffset(shadowStartOffset + kShadowCatchRateOFfset, withByte: shadowCatchRate)
			data.replaceByteAtOffset(shadowStartOffset + kShadowLevelOffset, withByte: level)
			data.replace2BytesAtOffset(shadowStartOffset + kShadowCounterOffset, withBytes: shadowCounter)
			
			for var i = 0; i < kNumberOfPokemonMoves; i++ {
				data.replace2BytesAtOffset(shadowStartOffset + kFirstShadowMoveOFfset + i, withBytes: self.shadowMoves[i].index)
			}
			
			data.save()
		}
	}


}





















