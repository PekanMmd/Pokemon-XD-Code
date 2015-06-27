//
//  LevelUpMove.swift
//  Mausoleum Stats Tool
//
//  Created by The Steez on 26/12/2014.
//  Copyright (c) 2014 Ovation International. All rights reserved.
//

import UIKit

let kNumberOfLevelUpMoves = 0x13
let kSizeOfLevelUpData = 0x4

let kLevelUpMoveLevelOffset = 0x0 // 1 byte
let kLevelUpMoveIndexOffset = 0x2 // 2 bytes

class XGLevelUpMove: NSObject {
	
	var level = 0x0
	var move  = XGMoves.Move(0)
	
	init(level: Int, move: Int) {
		super.init()
		
		self.level = level
		self.move  = .Move(move)
	}
	
	func isSet() -> Bool {
		return self.level > 0
	}
	
	func toInts() -> (Int, Int) {
		return (level, move.index)
	}
   
}
