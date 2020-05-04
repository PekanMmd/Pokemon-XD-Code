//
//  XGSpecialStringCharacters.swift
//  XG Tool
//
//  Created by StarsMmd on 22/05/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

private let specialNames = [
	0x0001 : "Furigana", // parameters: first byte is number of hiragana chars, followed by number of kanji chars
	0x0002 : "Pause", // parameter is duration (possibly in frames)
	0xfffe : "New Line",
	0xffff : "End",
]

enum XGSpecialCharacters {
	
	case id(Int)
	case pause
	case newLine
	case dialogueEnd
	
	var id : Int {
		switch self {
		case .id(let i): return i
		case .pause: return 2
		case .newLine: return 0xFFFE
		case .dialogueEnd: return 0xFFFF
		}
	}
	
	var extraBytes : Int {
		switch self.id {
		case 1,2,3,4,5: return 2
		default: return 0
		}
	}
	
	var byteStream : [UInt8] {
		return [UInt8(0xFF), UInt8(0xFF), UInt8((self.id >> 8) & 0xFF), UInt8(self.id & 0xFF)]
	}
	
	var unicode : XGUnicodeCharacters {
		return .special(self, [Int](repeating: 0, count: self.extraBytes))
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






















