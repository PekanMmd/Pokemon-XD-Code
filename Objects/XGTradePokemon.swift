//
//  XGTradePokemon.swift
//  XG Tool
//
//  Created by The Steez on 11/06/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//

import UIKit

let kMedititeOffset			= 0x1C5888
let kShuckleOffset			= 0x1C58D8
let kLarvitarOffset			= 0x1C5928

let kTradePokemonSpeciesOffset		=  0x02
let kTradePokemonLevelOffset		=  0x0B
let kTradePokemonMove1Offset		=  0x26
let kTradePokemonMove2Offset		=  0x2A
let kTradePokemonMove3Offset		=  0x2E
let kTradePokemonMove4Offset		=  0x32

class XGTradePokemon: NSObject {
	
	var index			= 0
	
	var level			= 0x0
	var species			= XGPokemon.Pokemon(0)
	var move1			= XGMoves.Move(0)
	var move2			= XGMoves.Move(0)
	var move3			= XGMoves.Move(0)
	var move4			= XGMoves.Move(0)
	
	var startOffset : Int {
		get {
			switch index {
				case 0 : return kMedititeOffset
				case 1 : return kShuckleOffset
				default: return kLarvitarOffset
			}
		}
	}
	
	init(index: Int) {
		super.init()
		
		var dol			= XGFiles.Dol.data
		self.index		= index
		
		let start = startOffset
		
		var species = dol.get2BytesAtOffset(start + kTradePokemonSpeciesOffset)
		self.species = .Pokemon(species)
		
		var moveIndex = dol.get2BytesAtOffset(start + kTradePokemonMove1Offset)
		move1 = .Move(moveIndex)
		moveIndex = dol.get2BytesAtOffset(start + kTradePokemonMove2Offset)
		move2 = .Move(moveIndex)
		moveIndex = dol.get2BytesAtOffset(start + kTradePokemonMove3Offset)
		move3 = .Move(moveIndex)
		moveIndex = dol.get2BytesAtOffset(start + kTradePokemonMove4Offset)
		move4 = .Move(moveIndex)
		
		level = dol.getByteAtOffset(start + kTradePokemonLevelOffset)
		
		
	}
	
	func save() {
		
		var dol = XGFiles.Dol.data
		let start = startOffset
		
		dol.replaceByteAtOffset(start + kTradePokemonLevelOffset, withByte: level)
		dol.replace2BytesAtOffset(start + kTradePokemonSpeciesOffset, withBytes: species.index)
		dol.replace2BytesAtOffset(start + kTradePokemonMove1Offset, withBytes: move1.index)
		dol.replace2BytesAtOffset(start + kTradePokemonMove2Offset, withBytes: move2.index)
		dol.replace2BytesAtOffset(start + kTradePokemonMove3Offset, withBytes: move3.index)
		dol.replace2BytesAtOffset(start + kTradePokemonMove4Offset, withBytes: move4.index)
		
		
		dol.save()
	}
	
}


















