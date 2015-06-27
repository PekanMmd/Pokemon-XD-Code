//
//  XGStarterViewController.swift
//  XG Tool
//
//  Created by The Steez on 11/06/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//

import UIKit

let kEeveeStartOffset			= 0x1CBC50

let kStarterSpeciesOffset		= 0x02
let kStarterLevelOffset			= 0x0B
let kStarterMove1Offset			= 0x12
let kStarterMove2Offset			= 0x16
let kStarterMove3Offset			= 0x1A
let kStarterMove4Offset			= 0x1E
let kStarterExpValueOffset		= 0x66

class XGStarterPokemon: NSObject {
	
	var level			= 0
	var exp				= 0
	var species			= XGPokemon.Pokemon(0)
	var move1			= XGMoves.Move(0)
	var move2			= XGMoves.Move(0)
	var move3			= XGMoves.Move(0)
	var move4			= XGMoves.Move(0)
	
	var startOffset : Int {
		get {
			return kEeveeStartOffset
		}
	}
	
	override init() {
		super.init()
		
		var dol			= XGFiles.Dol.data
		
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
		
		
	}
	
	func save() {
		
		var dol = XGFiles.Dol.data
		let start = startOffset
		
		dol.replaceByteAtOffset(start + kDemoStarterLevelOffset, withByte: level)
		dol.replace2BytesAtOffset(start + kDemoStarterExpValueOffset, withBytes: exp)
		dol.replace2BytesAtOffset(start + kDemoStarterSpeciesOffset, withBytes: species.index)
		dol.replace2BytesAtOffset(start + kDemoStarterMove1Offset, withBytes: move1.index)
		dol.replace2BytesAtOffset(start + kDemoStarterMove2Offset, withBytes: move2.index)
		dol.replace2BytesAtOffset(start + kDemoStarterMove3Offset, withBytes: move3.index)
		dol.replace2BytesAtOffset(start + kDemoStarterMove4Offset, withBytes: move4.index)
		
		
		dol.save()
	}
	
	
	
}



























