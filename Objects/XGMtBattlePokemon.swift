//
//  XGMtBattlePrizePokemon.swift
//  XG Tool
//
//  Created by The Steez on 09/06/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//

import UIKit

let kChikoritaOffset		= 0x1C5974
let kCyndaquilOffset		= 0x1C59A0
let kTotodileOffset			= 0x1C59CC

let kMtBattlePokemonSpeciesOffset	=  0x02
let kMtBattlePokemonMove1Offset		=  0x06
let kMtBattlePokemonMove2Offset		=  0x0A
let kMtBattlePokemonMove3Offset		=  0x0E
let kMtBattlePokemonMove4Offset		=  0x12

class XGMtBattlePrizePokemon: NSObject {
	
	var index			= 0
	
	var species			= XGPokemon.Pokemon(0)
	var move1			= XGMoves.Move(0)
	var move2			= XGMoves.Move(0)
	var move3			= XGMoves.Move(0)
	var move4			= XGMoves.Move(0)
	
	var startOffset : Int {
		get {
			switch index {
				case 0 : return kChikoritaOffset
				case 1 : return kCyndaquilOffset
				default: return kTotodileOffset
			}
		}
	}
	
	init(index: Int) {
		super.init()
		
		var dol			= XGFiles.Dol.data
		self.index		= index
		
		let start = startOffset
		
		var species = dol.get2BytesAtOffset(start + kMtBattlePokemonSpeciesOffset)
		self.species = .Pokemon(species)
		
		var moveIndex = dol.get2BytesAtOffset(start + kMtBattlePokemonMove1Offset)
		move1 = .Move(moveIndex)
		moveIndex = dol.get2BytesAtOffset(start + kMtBattlePokemonMove2Offset)
		move2 = .Move(moveIndex)
		moveIndex = dol.get2BytesAtOffset(start + kMtBattlePokemonMove3Offset)
		move3 = .Move(moveIndex)
		moveIndex = dol.get2BytesAtOffset(start + kMtBattlePokemonMove4Offset)
		move4 = .Move(moveIndex)
		
		
	}
	
	func save() {
		
		var dol = XGFiles.Dol.data
		let start = startOffset
		
		dol.replace2BytesAtOffset(start + kMtBattlePokemonSpeciesOffset, withBytes: species.index)
		dol.replace2BytesAtOffset(start + kMtBattlePokemonMove1Offset, withBytes: move1.index)
		dol.replace2BytesAtOffset(start + kMtBattlePokemonMove2Offset, withBytes: move2.index)
		dol.replace2BytesAtOffset(start + kMtBattlePokemonMove3Offset, withBytes: move3.index)
		dol.replace2BytesAtOffset(start + kMtBattlePokemonMove4Offset, withBytes: move4.index)
		
		
		dol.save()
	}
   
}










