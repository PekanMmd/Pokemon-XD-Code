//
//  XGFileTypes.swift
//  GoD Tool
//
//  Created by The Steez on 18/11/2017.
//
//

import Foundation

enum XGFileTypes : Int, Codable {
	case none = 0x00
	case rdat = 0x02 // room model in hal dat format (unknown if it uses a different file extension)
	case dat  = 0x04 // character model in hal dat format
	case ccd  = 0x06 // collision file
	case samp = 0x08 // shorter music files for fanfares etc.
	case msg  = 0x0a // string table
	case fnt  = 0x0c // font
	case scd  = 0x0e // script data
	case dats = 0x10 // multiple .dat models in one archive
	case gtx  = 0x12 // texture
	case gpt1 = 0x14 // @made_s should know what this is but I admittedly do not know. something to do with 3d models or effects :p
	case cam  = 0x18 // camera data
	case rel  = 0x1c // relocation table
	case pkx  = 0x1e // character battle model (same as dat with additional header information)
	case wzx  = 0x20 // move animation
	case isd  = 0x28 // audio file header
	case ish  = 0x2a // audio file
	case gsw  = 0x30 // multi texture
	case atx  = 0x32 // animated texture (official file extension is currently unknown)
	case bin  = 0x34 // binary data
	
	
	// all arbitrary values
	case fsys = 0xf0 // don't know if it has it's own identifier
	
	case json = 0xf5
	case txt  = 0xf6
	case lzss = 0xf7
	case bmp  = 0xf8
	case jpeg = 0xf9
	case png  = 0xfa
	case xds  = 0xfb
	case toc  = 0xfc
	case dol  = 0xfd
	case iso  = 0xfe
	
	case unknown = 0xff
	
	var index : Int {
		return self.rawValue / 2
	}
	
	var fileExtension : String {
		switch self {
		case .none: return ""
		case .rdat: return ".rdat"
		case .dat : return ".dat"
		case .ccd : return ".ccd"
		case .samp: return ".samp"
		case .msg : return ".msg"
		case .fnt : return ".fnt"
		case .scd : return ".scd"
		case .dats: return ".dats"
		case .gtx : return ".gtx"
		case .gpt1: return ".gpt1"
		case .cam : return ".cam"
		case .rel : return ".rel"
		case .pkx : return ".pkx"
		case .wzx : return ".wzx"
		case .isd : return ".isd"
		case .ish : return ".ish"
		case .gsw : return ".gsw"
		case .atx : return ".atx"
		case .bin : return ".bin"
		case .fsys: return ".fsys"
		case .iso : return ".iso"
		case .xds : return ".xds"
		case .dol : return ".dol"
		case .toc : return ".toc"
		case .png : return ".png"
		case .bmp : return ".bmp"
		case .jpeg: return ".jpeg"
		case .lzss : return ".lzss"
		case .txt : return ".txt"
		case .json: return ".json"
		case .unknown: return ".bin"
		}
	}
	
	static let imageFormats : [XGFileTypes] = [.png, .jpeg, .bmp]
	
}


















