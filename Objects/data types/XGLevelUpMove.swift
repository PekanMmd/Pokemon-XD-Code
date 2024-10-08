//
//  LevelUpMove.swift
//  Mausoleum Stats Tool
//
//  Created by StarsMmd on 26/12/2014.
//  Copyright (c) 2014 StarsMmd. All rights reserved.
//

import Foundation

let kNumberOfLevelUpMoves = 0x13
let kNumberOfEggMoves = 0x8
let kSizeOfLevelUpData = 0x4

let kLevelUpMoveLevelOffset = 0x0 // 1 byte
let kLevelUpMoveIndexOffset = 0x2 // 2 bytes

class XGLevelUpMove: NSObject, Codable {
	
	var level = 0x0
	var move  = XGMoves.index(0)
	
	init(level: Int, move: Int) {
		super.init()
		
		self.level = level
		self.move  = .index(move)
	}
	
	func isSet() -> Bool {
		return self.level > 0
	}
	
	func toInts() -> (Int, Int) {
		return (level, move.index)
	}
   
}

extension XGLevelUpMove: XGDocumentable {
	
	static var className: String {
		return "Level Up Move"
	}
	
	var documentableName: String {
		return move.name.unformattedString
	}
	
	static var DocumentableKeys: [String] {
		return ["level", "move"]
	}
	
	func documentableValue(for key: String) -> String {
		switch key {
		case "level":
			return level.string
		case "move":
			return move.name.unformattedString
		default:
			return ""
		}
	}
}
