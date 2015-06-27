//
//  XGBattleBingoCard.swift
//  XG Tool
//
//  Created by The Steez on 11/06/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//

import UIKit

let kFirstBattleBingoCardOffset			= 0x1CAF

let kNumberOfBingoCouponRewards			= 0x0A
let kNumberOfBingoCards					= 0x0B
let kNumberOfPanels						= 0x10
let kSizeOfBingoCardData				= 0xB8

let kNumberOfMysteryPanels				= 0x03
let kNumberOfPokemonPanels				= 0x0D


let kBingoCardIndexOffset				= 0x01
let kBingoCardDifficultyLevelOffset		= 0x02
let kBingoCardSubIndexOffset			= 0x03
let kBingoCardPokemonLevelOffset		= 0x04
let kBingoCardPokemonCountOffset		= 0x07
let kBingoCardMysteryPanelCountOffset	= 0x08
let kBingoCardNameIDOffset				= 0x0B
let kBingoCardDetailsIDOffset			= 0x0F
let kBingoCardFirstCouponsRewardOffset	= 0x11
let kBingoCardFirstPokemonOffset		= 0x25
let kBingoCardFirstMysteryPanelOffset	= 0xB1



class XGBattleBingoCard: NSObject {
	
	var difficulty			= 0
	var subIndex			= 0
	
	var index				= 0
	
	var nameID				= 0
	var detailsID			= 0
	
	var pokemonLevel		= 0
	var startingPokemon		= XGBattleBingoPokemon(startOffset: 0x1CD1)
	var panels				= [XGBattleBingoPanel]()
	var rewards				= [Int]()
	
	var startOffset : Int {
		get {
			return kFirstBattleBingoCardOffset + (index * kSizeOfBingoCardData)
		}
	}
	
	
	init(index: Int) {
		super.init()
		
		self.index = index
		
		var start = self.startOffset
		var rel = XGFiles.Common_rel.data
		
		difficulty = rel.getByteAtOffset(start + kBingoCardDifficultyLevelOffset)
		subIndex = rel.getByteAtOffset(start + kBingoCardSubIndexOffset)
		
		nameID = rel.get2BytesAtOffset(start + kBingoCardNameIDOffset)
		detailsID = rel.get2BytesAtOffset(start + kBingoCardDetailsIDOffset)
		
		pokemonLevel = rel.getByteAtOffset(start + kBingoCardPokemonLevelOffset)
		
		startingPokemon = XGBattleBingoPokemon(startOffset: start + kBingoCardFirstPokemonOffset)
		for var i = 1; i <= kNumberOfPokemonPanels; i++ {
			
			var poke = XGBattleBingoPokemon(startOffset: start + kBingoCardFirstPokemonOffset + (i * kSizeOfBattleBingoPokemonData))
			
			self.panels.append( .Pokemon(poke) )
			
		}
		
		var mysteryOffset = start + kBingoCardFirstMysteryPanelOffset
		for var i = 0 ; i < kNumberOfMysteryPanels; i++ {
			
			var panelType = rel.getByteAtOffset(mysteryOffset)
			
			mysteryOffset++
			
			var panelPosition = rel.getByteAtOffset(mysteryOffset)
			
			// mystery panels are always listed in order of their position
			self.panels.insert( .MysteryPanel( XGBattleBingoItem(rawValue: panelType) ?? .MasterBall ) , atIndex:  panelPosition)
			
			mysteryOffset++
			
		}
		
		for var i = 0; i < kNumberOfBingoCouponRewards; i++ {
			
			rewards.append( rel.get2BytesAtOffset(start + kBingoCardFirstCouponsRewardOffset + (i*2) ) )
			
		}
		
	}
	
	
	
	
	
	
	
   
}





















