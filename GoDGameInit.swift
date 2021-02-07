//
//  XGOSXExtensions.swift
//  GoD Tool
//
//  Created by StarsMmd on 20/08/2017.
//
//

import Foundation

let versionNumber = "V2.0.0"

var inputISOFile: XGFiles?
var fileDecodingMode = false

#if GAME_XD
let documentsFolderName = "GoD Tool"
let game = XGGame.XD
let console = Console.ngc
var isDemo: Bool {
	return XGFiles.iso.exists && ISO.allFileNames.count < 200 // 166 in vanilla demo
}

#elseif GAME_COLO

let documentsFolderName = "Colosseum Tool"
let game = XGGame.Colosseum
let console = Console.ngc
let isDemo = false

#elseif GAME_PBR

let documentsFolderName = "PBR Tool"
let game = XGGame.PBR
let console = Console.wii
let isDemo = false

#endif

var documentsPath: String {
	return (inputISOFile?.folder.path ?? NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
		+ "/\(documentsFolderName)"
		+ (inputISOFile == nil ? "" : " \(inputISOFile!.fileName.removeFileExtensions())")
}

let region = XGRegions(rawValue: XGFiles.iso.data!.getWordAtOffset(0)) ?? .OtherGame

enum Environment {
	case Linux
	case OSX
	case Windows
}

#if ENV_OSX

let environment = Environment.OSX

#elseif ENV_WINDOWS

let environment = Environment.Windows

#elseif ENV_LINUX

let environment = Environment.Linux

#endif


enum Console {
	case ngc
	case wii
}

enum XGGame {
	case Colosseum
	case XD
	case PBR

	var name: String {
		switch self {
		case .Colosseum: return "Pokemon Colosseum"
		case .XD: return "Pokemon XD: Gale of Darkness"
		case .PBR: return "Pokemon Battle Revolution"
		}
	}

	var shortName: String {
		switch self {
		case .Colosseum: return "Colosseum"
		case .XD: return "XD"
		case .PBR: return "PBR"
		}
	}
}

enum XGRegions: UInt32 {

	#if GAME_XD
	case US = 0x47585845 // GXXE
	case EU = 0x47585850 // GXXP
	case JP = 0x4758584A // GXXJ
	case OtherGame = 0
	#elseif GAME_COLO
	case US = 0x47433645 // GC6E
	case EU = 0x47433650 // GC6P
	case JP = 0x4743364A // GC6J
	case OtherGame = 0
	#elseif GAME_PBR
	case US = 0x52504245 // RPBE
	case EU = 0x52504250 // RPBP
	case JP = 0x5250424A // RPBJ
	case OtherGame = 0
	#endif

	var index : Int {
		switch self {
		// arbitrary values
		case .US: return 0
		case .EU: return 1
		case .JP: return 2
		case .OtherGame: return -1
		}
	}

	var name: String {
		switch self {
		case .US: return "US"
		case .EU: return "PAL"
		case .JP: return "JP"
		case .OtherGame: return "Other Game"
		}
	}
}





