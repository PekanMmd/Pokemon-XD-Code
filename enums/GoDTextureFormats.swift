//
//  GoDTextureFormats.swift
//  GoD Tool
//
//  Created by The Steez on 13/09/2017.
//
//

import Foundation

enum GoDTextureFormats: Int, CaseIterable {
	
	case I4 = 0x40
	case I8 = 0x42
	case IA4 = 0x41
	case IA8 = 0x43
	case RGB565 = 0x44
	case RGB5A3 = 0x90
	case RGBA32 = 0x45
	case C4 = 0x0
	case C8 = 0x1
	case C14X2 = 0x30
	case CMPR = 0xB0

	var standardRawValue : Int {
		switch self {
		case .I4: return 0
		case .I8: return 1
		case .IA4: return 2
		case .IA8: return 3
		case .RGB565: return 4
		case .RGB5A3: return 5
		case .RGBA32: return 6
		case .C4: return 8
		case .C8: return 9
		case .C14X2: return 10
		case .CMPR: return 14
		}
	}
	
	var isIndexed: Bool {
		switch self {
		case .C4, .C8, .C14X2:
			return true
		default:
			return false
		}
	}

	var paletteCount : Int {
		return Int(pow(2, Double(bitsPerPixel)))
	}

	var blockWidth : Int {
		switch self {
		case .IA8    : fallthrough
		case .RGB565 : fallthrough
		case .RGB5A3 : fallthrough
		case .RGBA32 : fallthrough
		case .C14X2  : return 4
		default      : return 8
		}
	}
	
	var blockHeight : Int {
		switch self {
		case .I4   : fallthrough
		case .C4   : fallthrough
		case .CMPR : return 8
		default    : return 4
		}
	}
	
	var bitsPerPixel : Int {
		switch self {
		case .I4:
			return 4
		case .I8:
			return 8
		case .IA4:
			return 8
		case .IA8:
			return 16
		case .RGB565:
			return 16
		case .RGB5A3:
			return 16
		case .RGBA32:
			return 32
		case .C4:
			return 4
		case .C8:
			return 8
		case .C14X2:
			return 16
		case .CMPR:
			return 4
		}
	}
	
	var name : String {
		switch self {
		case .C14X2:
			return "C14X2"
		case .I4:
			return "I4"
		case .I8:
			return "I8"
		case .IA4:
			return "IA4"
		case .IA8:
			return "IA8"
		case .RGB565:
			return "RGB565"
		case .RGB5A3:
			return "RGB5A3"
		case .RGBA32:
			return "RGBA32"
		case .C4:
			return "C4"
		case .C8:
			return "C8"
		case .CMPR:
			return "CMPR"
		}
	}
	
	var paletteID : Int? {
		switch self {
		case .IA8: return 0
		case .RGB565: return 1
		#if GAME_PBR
		case .RGB5A3: return 2
		#else
		case .RGB5A3: return 3 // note other games use 2 for this, including .dat models in these games
		#endif
		default: return nil
		}
	}

	static func fromStandardRawValue(_ value: Int) -> GoDTextureFormats? {
		for format in allCases {
			if format.standardRawValue == value {
				return format
			}
		}
		return nil
	}

	static func fromPaletteID(_ value: Int) -> GoDTextureFormats? {
		if value == 2 {
			return .RGB5A3 // In .dat models, 2 is used for these. Seems to be the standard in other games. Also seen in PBR
		}
		for format in allCases {
			if format.paletteID == value {
				return format
			}
		}
		return nil
	}
}









