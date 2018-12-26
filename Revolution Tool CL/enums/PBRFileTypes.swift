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
	
	case dta  = 0x02 // data table
	case pkx  = 0x04 // 3d model. format is documented in online forums
	
	case wzx  = 0x0a // move animation
	case gtx  = 0x0c // texture
	
	case gpd  = 0x10 // some kind of gfx
	case scd  = 0x12 // script data
	
	case msg  = 0x18 // string table
	
	case esq  = 0x20 // some kind of gfx
	
	case dckp = 0x28 // pokemon deck
	case dckt = 0x2a // trainer deck
	
	// placeholders while still doing research to confirm
	case rdat = 0xd0 // room model in hal dat format (unknown if it uses a different file extension)

	case ccd  = 0xd2 // collision file
	case samp = 0xd4 // shorter music files for fanfares etc.
	
	case fnt  = 0xd8 // font

	case dats = 0xda // multiple .dat models in one archive

	case gpt1 = 0xdc // @made_s should know what this is but I admittedly do not know. something to do with 3d models or effects :p
	case cam  = 0xde // camera data
	case rel  = 0xe0 // relocation table


	case isd  = 0xe2 // audio file header
	case ish  = 0xe4 // audio file
	case gsw  = 0xe6 // multi texture
	case atx  = 0xe8 // animated texture (official file extension is currently unknown)
	case dat  = 0xea
	case bin  = 0xec
	
	// all arbitrary values
	case fsys = 0xf0 // don't know if it has its own identifier
	
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
		case .dta : return ".dta"
		case .rdat: return ".rdat"
		case .dat : return ".dat"
		case .dckp: return ".dckp"
		case .dckt: return ".dckt"
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
		case .esq : return ".esq"
		case .gpd : return ".gpd"
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
}


















