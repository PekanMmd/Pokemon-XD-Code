//
//  XGUnicodeCharacters.swift
//  XG Tool
//
//  Created by StarsMmd on 10/06/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

enum XGUnicodeCharacters {
	
	case unicode(Int)
	case special(XGSpecialCharacters, [Int]) // [Int] is unused but required to keep code consistent with colosseum and xd
	
	var byteStream : [UInt8] {
		get {
			switch self {
				case .unicode(let val)		: return [UInt8(val / 0x100), UInt8(val % 0x100)]
				case .special(let sp, _)		: return sp.byteStream
			}
		}
	}
	
	var unicode : UInt8 {
		get {
			switch self {
			case .unicode(let val): return UInt8(val % 0x100)
			default: 				return 0xff
			}
		}
	}
	
	var length : Int {
		get {
			return self.byteStream.count
		}
	}

	var isFormattingChar: Bool {
		switch self {
		case .special(let c, _) where c.isNewLine:
			return false
		case .special:
			return true
		case .unicode:
			return false
		}
	}
	
	var string : String {
		get {
			var string = ""
			switch self {
			case .unicode(let i)			: let u = UnicodeScalar(i); string = u == nil ? "" : u!.description
			case .special(let s, _)			: string = s.string
			}
			
			return string
		}
	}
	
	var name : String {
		self.string
	}
	
}














