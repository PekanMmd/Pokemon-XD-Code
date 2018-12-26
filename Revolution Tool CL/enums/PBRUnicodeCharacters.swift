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
	case special(XGSpecialCharacters)
	
	var byteStream : [UInt8] {
		get {
			switch self {
				case .unicode(let val)		: return [UInt8(val / 0x100), UInt8(val % 0x100)]
				case .special(let sp)		: return sp.byteStream
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
	
	var string : String {
		get {
			var string = ""
			switch self {
			case .unicode(let i)			: let u = UnicodeScalar(i); string = u == nil ? "" : u!.description
			case .special(let s)			: string = s.string
			}
			
			return string
		}
	}
	
	var name : String {
		get {
			switch self {
				case .unicode			: return self.string
				case .special			: return self.string
			}
		}
	}
	
}














