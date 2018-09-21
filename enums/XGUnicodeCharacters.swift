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
	case special(XGSpecialCharacters, [Int])
	case predefinedFontColour(XGFontColours)
	case specifiedFontColour(XGRGBAFontColours)
	
	var byteStream : [UInt8] {
		get {
			switch self {
				case .unicode(let val)				: return [UInt8(val / 0x100), UInt8(val % 0x100)]
				case .predefinedFontColour(let p)	: return p.specialUnicode.byteStream
				case .specifiedFontColour(let s)	: return s.specialUnicode.byteStream
				case .special(let sp, let vals)		: var spec = sp.byteStream; for i in 0 ..< vals.count {
													  spec.append(UInt8(vals[i]))
												  }; return spec
			}
		}
	}
	
	var length : Int {
		get {
			return self.byteStream.count
		}
	}
	
	var extraBytes : Int {
		get {
			switch self {
				case .unicode( _)				: return 0
				case .predefinedFontColour( _)	: return 1
				case .specifiedFontColour( _)	: return 4
				case .special( _, let e)			: return e.count
			}
		}
	}
	
	var string : String {
		get {
			var string = ""
			switch self {
			case .unicode(let i)				: let u = UnicodeScalar(i); string = u == nil ? "" : u!.description
			case .predefinedFontColour(let p)	: return p.specialUnicode.string
			case .specifiedFontColour(let s)	: return s.specialUnicode.string
			case .special(let s, let b)			: var str = s.string
													if b.count > 0 {
														str = str + "{"
														for hex in b {
															str = str + String(format: "%02x", hex)
														}
														str = str + "}";
													}
													string = str
			}
			
			return string
		}
	}
	
	var name : String {
		get {
			switch self {
				case .unicode( _)				: return self.string
				case .predefinedFontColour(let p)	: return p.name
				case .specifiedFontColour(let s)	: return s.name
				case .special( _, _)			: return self.string
			}
		}
	}
	
	static func hexStringToInt(_ hex: String) -> Int {
		
		return Int(strtoul(hex, nil, 16)) // converts hex string to uint and then cast as Int
		
	}
	
}














