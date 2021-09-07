//
//  XGOSXExtensions.swift
//  GoD Tool
//
//  Created by StarsMmd on 20/08/2017.
//
//

import Foundation

let versionNumber = "V2.4.2"
var fileDecodingMode = false

func aboutMessage() -> String {
	let gameName: String
	switch game {
	case .XD:
		gameName = "GoD Tool"
	case .Colosseum:
		gameName = "Colosseum Tool"
	case .PBR:
		gameName = "Pokemon Battle Revolution Tool"
	}
	return """
	\(gameName) \(versionNumber)
	by Stars Momodu
	Twitter: @StarsMmd | Discord: Stars#4434

	source code: https://github.com/PekanMmd/Pokemon-XD-Code.git
	"""
}

#if GAME_XD
let documentsFolderName = "GoD Tool"
let game = XGGame.XD
let console = Console.ngc
var isDemo: Bool {
	return  XGFiles.iso.exists && region != .OtherGame && XGISO.current.allFileNames.count < 200 // 166 in vanilla demo
}

#elseif GAME_COLO

let documentsFolderName = "CM Tool"
let game = XGGame.Colosseum
let console = Console.ngc
let isDemo = false

#elseif GAME_PBR

let documentsFolderName = "PBR Tool"
let game = XGGame.PBR
let console = Console.wii
let isDemo = false

#endif

func loadDocumentsPath() {
	documentsPath = {
		return (XGISO.inputISOFile?.folder.path ?? NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
			+ (XGISO.inputISOFile == nil ? "" : "/\(XGISO.inputISOFile!.fileName.removeFileExtensions()) ")
			+ "\(documentsFolderName)"
	}()
}
var documentsPath = {
	return (XGISO.inputISOFile?.folder.path ?? NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
		+ "/\(documentsFolderName)"
		+ (XGISO.inputISOFile == nil ? "" : " \(XGISO.inputISOFile!.fileName.removeFileExtensions())")
}()

fileprivate func loadRegion() {
	#if !GAME_PBR
	let fileForRegion = XGFiles.iso
	#else
	let fileForRegion = XGFiles.boot
	#endif
	if let magicBytes = fileForRegion.data?.getWordAtOffset(0),
	   let region = XGRegions(rawValue: magicBytes) {
		cachedRegion = region
	} else {
		cachedRegion = .OtherGame
	}
}
func resetRegion() {
	cachedRegion = nil
}
fileprivate var cachedRegion: XGRegions?
var region: XGRegions {
	if cachedRegion == nil {
		loadRegion()
	}
	return cachedRegion!
}


enum Environment {
	case Linux
	case OSX
	case Windows
}

#if os(macOS)

let environment = Environment.OSX

#elseif os(Windows)

let environment = Environment.Windows

#elseif os(Linux)

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

	var name: String {
		switch self {
		case .US: return "US"
		case .EU: return "PAL"
		case .JP: return "JP"
		case .OtherGame: return "Other Game"
		}
	}

	static func fromNGCID(_ index: Int) -> XGRegions? {
		switch index {
		case 0: return .JP
		case 1: return .US
		case 2: return .EU
		default: return nil
		}
	}

	static func fromGBAID(_ index: Int) -> XGRegions? {
		// ids as used in GBA games and in pokemon data
		switch index {
		case 1: return .JP
		case 2: return .US
		case 3: return .EU
		default: return nil
		}
	}
}





