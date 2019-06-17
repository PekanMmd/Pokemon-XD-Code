//
//  XGFontColours.swift
//  XG Tool
//
//  Created by StarsMmd on 10/06/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

let kNumberOfPredefinedFontColours =  6
let kNumberOfSpecifiedFontColours  = 12

enum XGFontColours : Int, Codable {
	
	case white		= 0x00
	case yellow		= 0x01
	case green		= 0x02
	case darkBlue	= 0x03
	case orange		= 0x04
	case black		= 0x05
	
	var name : String {
		get {
			var str = ""
			switch self {
				case .white			: str = "White"
				case .yellow		: str = "Yellow"
				case .green			: str = "Green"
				case .darkBlue		: str = "Dark Blue"
				case .orange		: str = "Orange"
				case .black			: str = "Black"
			}
			return "Predefined " + str
		}
	}
	
	var unicode : XGUnicodeCharacters {
		get {
			return .predefinedFontColour(self)
		}
	}
	
	var specialUnicode : XGUnicodeCharacters {
		get {
			return .special(.changeColourPredefined, self.bytes)
		}
	}
	
	var string : XGString {
		get {
			return XGString(string: specialUnicode.string, file: nil, sid: nil)
		}
	}
	
	var bytes : [Int] {
		get {
			return [self.rawValue]
		}
	}
	
}

enum XGRGBAFontColours : Int {
	
	case red		= 0
	case green
	case blue
	case yellow
	case cyan
	case magenta
	case lightGreen
	case orange
	case purple
	case grey
	case white
	case black
	
	var name : String {
		get {
			var str = ""
			switch self {
				case .red			: str =  "Red"
				case .green			: str =  "Green"
				case .blue			: str =  "Blue"
				case .yellow		: str =  "Yellow"
				case .cyan			: str =  "Cyan"
				case .magenta		: str =  "Magenta"
				case .lightGreen	: str =  "Light Green"
				case .orange		: str =  "Orange"
				case .purple		: str =  "Purple"
				case .grey			: str =  "Grey"
				case .white			: str =  "White"
				case .black			: str =  "Black"
			}
			return "Specified " + str
		}
	}
	
	var unicode : XGUnicodeCharacters {
		get {
			return XGUnicodeCharacters.specifiedFontColour(self)
		}
	}
	
	var specialUnicode : XGUnicodeCharacters {
		get {
			return .special(.changeColourSpecified, self.bytes)
		}
	}
	
	var string : XGString {
		get {
			return XGString(string: specialUnicode.string, file: nil, sid: nil)
		}
	}
	
	var bytes : [Int] {
		get {
			var bytes = [Int]()
			switch self {
			case .red			: bytes = [0xFF,0x00,0x00,0xFF]
			case .green			: bytes = [0x00,0xFF,0x00,0xFF]
			case .blue			: bytes = [0x00,0x00,0xFF,0xFF]
			case .yellow		: bytes = [0xFF,0xFF,0x00,0xFF]
			case .cyan			: bytes = [0x00,0xFF,0xFF,0xFF]
			case .magenta		: bytes = [0xFF,0x00,0xFF,0xFF]
			case .lightGreen	: bytes = [0xC8,0xFF,0x00,0xFF]
			case .purple		: bytes = [0xC8,0x00,0xC8,0xFF]
			case .orange		: bytes = [0xFF,0xB0,0x00,0xFF]
			case .grey			: bytes = [0xC8,0xC8,0xC8,0xFF]
			case .white			: bytes = [0xFF,0xFF,0xFF,0xFF]
			case .black			: bytes = [0x00,0x00,0x00,0xFF]
			}
			return bytes
		}
	}
	
}







































