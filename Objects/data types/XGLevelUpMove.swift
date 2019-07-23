//
//  LevelUpMove.swift
//  Mausoleum Stats Tool
//
//  Created by StarsMmd on 26/12/2014.
//  Copyright (c) 2014 StarsMmd. All rights reserved.
//

import Foundation

let kNumberOfLevelUpMoves = 0x13
let kSizeOfLevelUpData = 0x4

let kLevelUpMoveLevelOffset = 0x0 // 1 byte
let kLevelUpMoveIndexOffset = 0x2 // 2 bytes

class XGLevelUpMove: NSObject {
	
	@objc var level = 0x0
	var move  = XGMoves.move(0)
	
	@objc init(level: Int, move: Int) {
		super.init()
		
		self.level = level
		self.move  = .move(move)
	}
	
	@objc func isSet() -> Bool {
		return self.level > 0
	}
	
	func toInts() -> (Int, Int) {
		return (level, move.index)
	}
   
}
