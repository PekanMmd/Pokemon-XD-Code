//
//  XGStarterViewController.swift
//  XG Tool
//
//  Created by StarsMmd on 11/06/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

let kEeveeStartOffset			= 0x1CBC50

let kStarterSpeciesOffset		= 0x02
let kStarterLevelOffset			= 0x0B
let kStarterMove1Offset			= 0x12
let kStarterMove2Offset			= 0x16
let kStarterMove3Offset			= 0x1A
let kStarterMove4Offset			= 0x1E
let kStarterExpValueOffset		= 0x66

class XGStarterPokemon: NSObject, XGGiftPokemon {
	
	var level			= 0
	var exp				= 0
	var species			= XGPokemon.pokemon(0)
	var move1			= XGMoves.move(0)
	var move2			= XGMoves.move(0)
	var move3			= XGMoves.move(0)
	var move4			= XGMoves.move(0)
	
	var giftType		= "Starter Pokemon"
	
	// unused
	var index			= 0
	var shinyValue		= XGShinyValues.random
	
	var startOffset : Int {
		get {
			return kEeveeStartOffset
		}
	}
	
	override init() {
		super.init()
		
		let dol			= XGFiles.dol.data
		
		let start = startOffset
		
		level = dol.getByteAtOffset(start + kStarterLevelOffset)
		exp	  = dol.get2BytesAtOffset(start + kStarterExpValueOffset)
		
		let species = dol.get2BytesAtOffset(start + kStarterSpeciesOffset)
		self.species = .pokemon(species)
		
		var moveIndex = dol.get2BytesAtOffset(start + kStarterMove1Offset)
		move1 = .move(moveIndex)
		moveIndex = dol.get2BytesAtOffset(start + kStarterMove2Offset)
		move2 = .move(moveIndex)
		moveIndex = dol.get2BytesAtOffset(start + kStarterMove3Offset)
		move3 = .move(moveIndex)
		moveIndex = dol.get2BytesAtOffset(start + kStarterMove4Offset)
		move4 = .move(moveIndex)
		
		
	}
	
	func save() {
		
		let dol = XGFiles.dol.data
		let start = startOffset
		
		dol.replaceByteAtOffset(start + kStarterLevelOffset, withByte: level)
		dol.replace2BytesAtOffset(start + kStarterExpValueOffset, withBytes: exp)
		dol.replace2BytesAtOffset(start + kStarterSpeciesOffset, withBytes: species.index)
		dol.replace2BytesAtOffset(start + kStarterMove1Offset, withBytes: move1.index)
		dol.replace2BytesAtOffset(start + kStarterMove2Offset, withBytes: move2.index)
		dol.replace2BytesAtOffset(start + kStarterMove3Offset, withBytes: move3.index)
		dol.replace2BytesAtOffset(start + kStarterMove4Offset, withBytes: move4.index)
		
		
		dol.save()
	}
	
	
	
}



























