//
//  CMTrainerModels.swift
//  Colosseum Tool
//
//  Created by The Steez on 04/06/2018.
//

import Foundation

let kNumberOfTrainerModels = 0x4b

var kFirstTrainerPKXIdentifierOffset: Int {
	switch region {
	case .JP: return 0x359FA8
	case .US: return 0x36D840
	case .EU: return 0x3BA938
	case .OtherGame: return 0
	}
} // in start.dol

enum XGTrainerModels : Int, Codable, CaseIterable {
	
	case none	= 0x00
	
	case wes = 1
	case ruby = 2
	case sapphire = 3
	case cipherPeonF = 4
	case cipherPeonM1 = 5
	case verde = 6
	case rosso = 7
	case bluno = 8
	case skrub = 9
	case green = 10
	case red = 11
	case funOldLady = 12
	case dakim = 13
	case gonzap = 14
	case mirorB = 15
	case venus = 16
	case nascour = 17
	case newsCaster = 18
	case stPerformer = 19
	case eagun = 20
	case vander = 21
	case superTrainerM2 = 22
	case arth = 23
	case superTrainerF1 = 24
	case ferma = 25
	case reath = 26
	case hunterM = 27
	case folly = 28
	case ladyInSuit = 29
	case glassesMan = 30
	case funOldMan = 31
	case bodyBuilderF = 32
	case bodyBuilderM = 33
	case richBoy1 = 34
	case guy = 35
	case lady1 = 36
	case riderF = 37
	case willie = 38
	case riderM = 39
	case teacher = 40
	case evice = 41
	case snagem1 = 42
	case athleteF = 43
	case athleteM = 44
	case ein = 45
	case chaserF1 = 46
	case chaserM1 = 47
	case rollerBoy = 48
	case worker = 49
	case rui = 50
	case richBoy2 = 51
	case lady2 = 52
	case coolTrainerM = 53
	case coolTrainerF = 54
	case justy = 55
	case bandanaGuy = 56
	case researcher = 57
	case hunterF = 58
	case battlus = 59
	case bodyBuilderM2 = 60
	case deepKing = 61
	case chaserM2 = 62
	case eagun2 = 63
	case eagun3 = 64
	case superTrainerF2 = 65
	case fein = 66
	case snagem2 = 67
	case snagem3 = 68
	case mirakleB = 69
	case superTrainerM1 = 70
	case trinch = 71
	case athey = 72
	case trudly = 73
	case cail = 74
	case chaserF2 = 75
	
	var name: String {
		if self.rawValue == 0 {
			return "-"
		}
		return pkxFSYS?.fileName.removeFileExtensions() ?? "-"
	}
	
	var pkxModelIdentifier : UInt32 {
		let dol = XGFiles.dol.data!
		return dol.getWordAtOffset(kFirstTrainerPKXIdentifierOffset + (self.rawValue * 12) + kModelDictionaryModelOffset)
	}
	
	var pkxFSYS : XGFsys? {
		return XGISO.current.getPKXModelWithIdentifier(id: self.pkxModelIdentifier)
	}
	
	var pkxData : XGMutableData? {
		let fsys = self.pkxFSYS
		
		if fsys != nil {
			return fsys!.decompressedDataForFileWithIndex(index: 0)
		}
		
		return nil
	}
	
	var pkxName : String? {
		if let fsys = pkxFSYS {
			return fsys.fileName.replacingOccurrences(of: "pkx_", with: "").removeFileExtensions()
		}
		return nil
	}
	
}

extension XGTrainerModels: XGEnumerable {
	var enumerableName: String {
		return name
	}
	
	var enumerableValue: String? {
		return rawValue.string
	}
	
	static var className: String {
		return "Trainer Models"
	}
	
	static var allValues: [XGTrainerModels] {
		return allCases
	}
}

extension XGTrainerModels: XGDocumentable {
	
	var documentableName: String {
		return enumerableName
	}
	
	static var DocumentableKeys: [String] {
		return ["index", "hex index", "name", "file name", "fsys ID"]
	}
	
	func documentableValue(for key: String) -> String {
		switch key {
		case "index":
			return rawValue.string
		case "hex index":
			return rawValue.hexString()
		case "name":
			return name
		case "filename":
			return pkxName ?? ""
		case "fsys ID":
			return String(pkxModelIdentifier)
		default:
			return ""
		}
	}
}
