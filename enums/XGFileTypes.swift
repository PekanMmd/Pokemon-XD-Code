//
//  XGFileTypes.swift
//  GoD Tool
//
//  Created by The Steez on 18/11/2017.
//
//

import Foundation

enum XGFileTypes: Int, Codable, CaseIterable {
	case none = 0x00
	case rdat = 0x02 // room model in hal dat format. Also .dat files but considered different by the fsys headers
	case dat  = 0x04 // character model in hal dat format
	case col  = 0x06 // collision file
	case samp = 0x08 // shorter music files for fanfares etc.
	case msg  = 0x0a // string table
	case fnt  = 0x0c // font
	case scd  = 0x0e // script data
	case dats = 0x10 // multiple .dat models in one archive
	case gtx  = 0x12 // texture
	case gpt1 = 0x14 // particle data
	case cam  = 0x18 // camera data
	case rel  = 0x1c // relocation table
	case pkx  = 0x1e // character battle model (same as dat with additional header information)
	case wzx  = 0x20 // move animation
	case isd  = 0x28 // audio file header
	case ish  = 0x2a // audio file
	case thh  = 0x2c // thp media header
	case thd  = 0x2e // thp media data
	case gsw  = 0x30 // multi texture
	case atx  = 0x32 // animated texture (official file extension is currently unknown)
	case bin  = 0x34 // binary data
	
	
	// all arbitrary values
	case fsys = 0x80

	// These have ids of 0 for some reason
	case proj = 0x82
	case sdir = 0x84
	case pool = 0x86

	case raw  = 0xf0
	case gci  = 0xf1
	case thp  = 0xf2
	case json = 0xf3
	case txt  = 0xf4
	case lzss = 0xf5
	case tpl  = 0xf6
	case bmp  = 0xf7
	case jpeg = 0xf8
	case png  = 0xf9
	case tex0 = 0xfa
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
		case .col : return ".ccd"
		case .samp: return ".samp"
		case .sdir: return ".sdir"
		case .proj: return ".proj"
		case .pool: return ".pool"
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
		case .thh : return ".thh"
		case .thd : return ".thd"
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
		case .jpeg: return ".jpg"
		case .tex0: return ".tex0"
		case .tpl : return ".tpl"
		case .lzss: return ".lzss"
		case .txt : return ".txt"
		case .json: return ".json"
		case .thp : return ".thp"
		case .gci : return ".gci"
		case .raw : return ".raw"
		case .unknown: return ".bin"
		}
	}

	var identifier: Int {
		return rawValue < XGFileTypes.fsys.rawValue ? rawValue : 0
	}

	#if canImport(Cocoa)
	static let imageFormats: [XGFileTypes] = [.png, .jpeg, .bmp]
	#else
	static let imageFormats: [XGFileTypes] = [.png]
	#endif

	static let textureFormats: [XGFileTypes] = [.gtx, .atx]
	static let modelFormats: [XGFileTypes] = [.dat, .rdat, /*.dats can't remember what these are so not adding for now*/]
	static let textureContainingFormats: [XGFileTypes] = [.dat, .rdat] // gsw once implemented and models

	static func fileTypeForExtension(_ ext: String) -> XGFileTypes? {
		return XGFileTypes.allCases.first(where: {
			$0.fileExtension.replacingOccurrences(of: ".", with: "") == ext.replacingOccurrences(of: ".", with: "")
		})
	}
}


















