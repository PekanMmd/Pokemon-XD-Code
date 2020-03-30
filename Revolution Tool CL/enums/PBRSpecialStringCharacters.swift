//
//  XGSpecialStringCharacters.swift
//  XG Tool
//
//  Created by StarsMmd on 22/05/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

private let specialNames = [
	0xfffe : "New Line",
	0xffff : "End",
]

enum XGSpecialCharacters {
	
	case id(Int)
	case newLine
	case dialogueEnd
	
	var id : Int {
		switch self {
		case .id(let i): return i
		case .newLine: return 0xFFFE
		case .dialogueEnd: return 0xFFFF
		}
	}
	
	var extraBytes : Int {
		return 0 // unused but required for consistency with colosseum and xd
	}
	
	var byteStream : [UInt8] {
		get {
			return [UInt8(0xFF), UInt8(0xFF), UInt8((self.id >> 8) & 0xFF), UInt8(self.id & 0xFF)]
		}
	}
	
	var unicode : XGUnicodeCharacters {
		get {
			return .special(self, [])
		}
	}

	var isNewLine: Bool {
		id == XGSpecialCharacters.newLine.id
	}
	
	var string : String {
		if isNewLine {
			return "\n"
		}
		return "[" + (specialNames[self.id] ?? self.id.hexString()) + "]"
	}
	
	static func fromString(_ str : String) -> XGSpecialCharacters {
		if let val = str.integerValue {
			return .id(val)
		}
		for key in specialNames.keys {
			if specialNames[key] == str {
				return .id(key)
			}
		}
		return .id(0)
	}

}






















