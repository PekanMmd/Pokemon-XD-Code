//
//  XGFileTypes.swift
//  GoD Tool
//
//  Created by The Steez on 18/11/2017.
//
//

import Foundation

enum XGFileTypes : Int {
	case none = 0x00
	case dat  = 0x04 // character model in hal dat format
	case msg  = 0x0a // string table
	case fnt  = 0x0c // font
	case scd  = 0x0e // script data
	case gtx  = 0x12 // texture
	case cam  = 0x18 // camera data
	case rel  = 0x1c // relocation table
	case pkx  = 0x1e // character battle model (same as dat with additional header information)
	case wzx  = 0x20 // move animation
	case isd  = 0x28 // audio file header
	case ish  = 0x2a // audio file
	case gsw  = 0x30 // multi texture
	case atx  = 0x32 // animated texture (official file extension is currently unknown)
	case bin  = 0x34 // binary data
	
	var index : Int {
		return self.rawValue / 2
	}
	
	var fileExtension : String {
		switch self {
		case .none:
			return ""
		case .dat:
			return ".dat"
		case .msg:
			return ".msg"
		case .fnt:
			return ".fnt"
		case .scd:
			return ".scd"
		case .gtx:
			return ".gtx"
		case .cam:
			return ".cam"
		case .rel:
			return ".rel"
		case .pkx:
			return ".pkx"
		case .wzx:
			return ".wzx"
		case .isd:
			return ".isd"
		case .ish:
			return ".ish"
		case .gsw:
			return ".gsw"
		case .atx:
			return ".atx"
		case .bin:
			return ".bin"
		}
	}
}


















