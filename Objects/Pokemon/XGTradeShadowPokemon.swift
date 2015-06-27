//
//  XGTradeShadowPokemon.swift
//  XG Tool
//
//  Created by The Steez on 11/06/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//

import UIKit

let kTogepiOffset						= 0x1C5760

let kTradeShadowPokemonSpeciesOffset	=  0x02
let kTradeShadowDDPKIDOffset			=  0x06
let kTradeShadowPokemonLevelOffset		=  0x0B
let kTradeShadowPokemonMove1Offset		=  0x0E
let kTradeShadowPokemonMove2Offset		=  0x12
let kTradeShadowPokemonMove3Offset		=  0x16
let kTradeShadowPokemonMove4Offset		=  0x1A

class XGTradeShadowPokemon: NSObject {
	
	var level			= 0x0
	var DDPKID			= 0x0
	var species			= XGPokemon.Pokemon(0)
	var move1			= XGMoves.Move(0)
	var move2			= XGMoves.Move(0)
	var move3			= XGMoves.Move(0)
	var move4			= XGMoves.Move(0)
	
	var startOffset : Int {
		get {
			return kTogepiOffset
		}
	}
	
	override init() {
		super.init()
		
		var dol			= XGFiles.Dol.data
		
		let start = startOffset
		
		var species = dol.get2BytesAtOffset(start + kTradeShadowPokemonSpeciesOffset)
		self.species = .Pokemon(species)
		
		level = dol.getByteAtOffset(start + kTradeShadowPokemonLevelOffset)
		DDPKID = dol.get2BytesAtOffset(kTradeShadowDDPKIDOffset)
		
		var moveIndex = dol.get2BytesAtOffset(start + kTradeShadowPokemonMove1Offset)
		move1 = .Move(moveIndex)
		moveIndex = dol.get2BytesAtOffset(start + kTradeShadowPokemonMove2Offset)
		move2 = .Move(moveIndex)
		moveIndex = dol.get2BytesAtOffset(start + kTradeShadowPokemonMove3Offset)
		move3 = .Move(moveIndex)
		moveIndex = dol.get2BytesAtOffset(start + kTradeShadowPokemonMove4Offset)
		move4 = .Move(moveIndex)
		
		
	}
	
	func save() {
		
		var dol = XGFiles.Dol.data
		let start = startOffset
		
		dol.replace2BytesAtOffset(start + kTradeShadowDDPKIDOffset, withBytes: DDPKID)
		dol.replaceByteAtOffset(  start + kTradeShadowPokemonLevelOffset, withByte: level)
		dol.replace2BytesAtOffset(start + kTradeShadowPokemonSpeciesOffset, withBytes: species.index)
		dol.replace2BytesAtOffset(start + kTradeShadowPokemonMove1Offset, withBytes: move1.index)
		dol.replace2BytesAtOffset(start + kTradeShadowPokemonMove2Offset, withBytes: move2.index)
		dol.replace2BytesAtOffset(start + kTradeShadowPokemonMove3Offset, withBytes: move3.index)
		dol.replace2BytesAtOffset(start + kTradeShadowPokemonMove4Offset, withBytes: move4.index)
		
		
		dol.save()
	}
	
}
