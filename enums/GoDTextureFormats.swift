//
//  GoDTextureFormats.swift
//  GoD Tool
//
//  Created by The Steez on 13/09/2017.
//
//

import Cocoa

enum GoDTextureFormats: Int {
	
	case I4 = 0x40
	case I8 = 0x42
	case IA4 = 0x41
	case IA8 = 0x43
	case RGB565 = 0x44
	case RGB5A3 = 0x90
	case RGBA32 = 0x45
	case C4 = 0x0
	case C8 = 0x1
	case C14X2 = 10
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
	
	var isIndexed : Bool {
		switch self {
		case .C4    : fallthrough
		case .C8    : fallthrough
		case .C14X2 : return true
		default     : return false
		}
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
    
}









