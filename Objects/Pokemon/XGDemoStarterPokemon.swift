//
//  XGStarterPokemon.swift
//  XG Tool
//
//  Created by The Steez on 09/06/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//

import UIKit

let kVaporeonStartOffset = 0x14F614
let kJolteonStartOffset	 = 0x14F73C
let kSizeOfStartPokemonData = 0x0128

let kDemoStarterSpeciesOffset		= 0x02
let kDemoStarterLevelOffset			= 0x07
let kDemoStarterMove1Offset			= 0x16
let kDemoStarterMove2Offset			= 0x26
let kDemoStarterMove3Offset			= 0x36
let kDemoStarterMove4Offset			= 0x46
let kDemoStarterShinyValueOffset	= 0x5E
let kDemoStarterExpValueOffset		= 0x92

class XGDemoStarterPokemon: NSObject {
	
	var index			= 0
	
	var level			= 0
	var exp				= 0
	var species			= XGPokemon.Pokemon(0)
	var move1			= XGMoves.Move(0)
	var move2			= XGMoves.Move(0)
	var move3			= XGMoves.Move(0)
	var move4			= XGMoves.Move(0)
	var shinyValue		= XGShinyValues.Never
	
	var startOffset : Int {
		get {
			return index == 0 ? kVaporeonStartOffset : kJolteonStartOffset
		}
	}
	
	init(index: Int) {
		super.init()
		
		var dol			= XGFiles.Dol.data
		self.index		= index
		
		let start = startOffset
		
		level = dol.getByteAtOffset(start + kDemoStarterLevelOffset)
		exp	  = dol.get2BytesAtOffset(start + kDemoStarterExpValueOffset)
		
		var species = dol.get2BytesAtOffset(start + kDemoStarterSpeciesOffset)
		self.species = .Pokemon(species)
		
		var moveIndex = dol.get2BytesAtOffset(start + kDemoStarterMove1Offset)
		move1 = .Move(moveIndex)
		moveIndex = dol.get2BytesAtOffset(start + kDemoStarterMove2Offset)
		move2 = .Move(moveIndex)
		moveIndex = dol.get2BytesAtOffset(start + kDemoStarterMove3Offset)
		move3 = .Move(moveIndex)
		moveIndex = dol.get2BytesAtOffset(start + kDemoStarterMove4Offset)
		move4 = .Move(moveIndex)
		
		var shiny = dol.get2BytesAtOffset(start + kDemoStarterShinyValueOffset)
		self.shinyValue = XGShinyValues(rawValue: shiny)!
		
		
	}
	
	func save() {
		
		var dol = XGFiles.Dol.data
		let start = startOffset
		
		dol.replaceByteAtOffset(start + kDemoStarterLevelOffset, withByte: level)
		dol.replace2BytesAtOffset(start + kDemoStarterExpValueOffset, withBytes: exp)
		dol.replace2BytesAtOffset(start + kDemoStarterSpeciesOffset, withBytes: species.index)
		dol.replace2BytesAtOffset(start + kDemoStarterShinyValueOffset, withBytes: shinyValue.rawValue)
		dol.replace2BytesAtOffset(start + kDemoStarterMove1Offset, withBytes: move1.index)
		dol.replace2BytesAtOffset(start + kDemoStarterMove2Offset, withBytes: move2.index)
		dol.replace2BytesAtOffset(start + kDemoStarterMove3Offset, withBytes: move3.index)
		dol.replace2BytesAtOffset(start + kDemoStarterMove4Offset, withBytes: move4.index)
		
		
		dol.save()
	}
	
	
	
}

















