//
//  XGTradeShadowPokemon.swift
//  XG Tool
//
//  Created by StarsMmd on 11/06/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

let kTogepiOffset						= 0x1C5760

let kTradeShadowPokemonSpeciesOffset	=  0x02
let kTradeShadowDDPKIDOffset			=  0x06
let kTradeShadowPokemonLevelOffset		=  0x0B
let kTradeShadowPokemonMove1Offset		=  0x0E
let kTradeShadowPokemonMove2Offset		=  0x12
let kTradeShadowPokemonMove3Offset		=  0x16
let kTradeShadowPokemonMove4Offset		=  0x1A

class XGTradeShadowPokemon: NSObject, XGGiftPokemon {
	
	var level			= 0x0
//	var DDPKID			= 0x0
	var species			= XGPokemon.pokemon(0)
	var move1			= XGMoves.move(0)
	var move2			= XGMoves.move(0)
	var move3			= XGMoves.move(0)
	var move4			= XGMoves.move(0)
	
	var giftType		= "Given Shadow Pokemon"
	
	// unused
	var index			= 0
	var exp				= -1
	var shinyValue		= XGShinyValues.random
	
	var startOffset : Int {
		get {
			return kTogepiOffset
		}
	}
	
	override init() {
		super.init()
		
		let dol			= XGFiles.dol.data
		
		let start = startOffset
		
		let species = dol.get2BytesAtOffset(start + kTradeShadowPokemonSpeciesOffset)
		self.species = .pokemon(species)
		
		level = dol.getByteAtOffset(start + kTradeShadowPokemonLevelOffset)
//		DDPKID = dol.get2BytesAtOffset(kTradeShadowDDPKIDOffset)
		
		var moveIndex = dol.get2BytesAtOffset(start + kTradeShadowPokemonMove1Offset)
		move1 = .move(moveIndex)
		moveIndex = dol.get2BytesAtOffset(start + kTradeShadowPokemonMove2Offset)
		move2 = .move(moveIndex)
		moveIndex = dol.get2BytesAtOffset(start + kTradeShadowPokemonMove3Offset)
		move3 = .move(moveIndex)
		moveIndex = dol.get2BytesAtOffset(start + kTradeShadowPokemonMove4Offset)
		move4 = .move(moveIndex)
		
		
	}
	
	func save() {
		
		let dol = XGFiles.dol.data
		let start = startOffset
		
//		dol.replace2BytesAtOffset(start + kTradeShadowDDPKIDOffset, withBytes: DDPKID)
		dol.replaceByteAtOffset(  start + kTradeShadowPokemonLevelOffset, withByte: level)
		dol.replace2BytesAtOffset(start + kTradeShadowPokemonSpeciesOffset, withBytes: species.index)
		dol.replace2BytesAtOffset(start + kTradeShadowPokemonMove1Offset, withBytes: move1.index)
		dol.replace2BytesAtOffset(start + kTradeShadowPokemonMove2Offset, withBytes: move2.index)
		dol.replace2BytesAtOffset(start + kTradeShadowPokemonMove3Offset, withBytes: move3.index)
		dol.replace2BytesAtOffset(start + kTradeShadowPokemonMove4Offset, withBytes: move4.index)
		
		
		dol.save()
	}
	
}
