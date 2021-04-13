//
//  XGPokeSpots.swift
//  XG Tool
//
//  Created by StarsMmd on 08/06/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

enum XGPokeSpots : Int, Codable, CaseIterable {
	
	case rock		= 0x00
	case oasis		= 0x01
	case cave		= 0x02
	case all			= 0x03
	
	var string : String {
		get {
			switch self {
				case .rock	: return "Rock"
				case .oasis	: return "Oasis"
				case .cave	: return "Cave"
				case .all	: return "All"
			}
		}
	}
	
	var numberOfEntries : Int {
		let rel = XGFiles.common_rel.data!
		return rel.get4BytesAtOffset(self.commonRelEntriesIndex.startOffset)
	}
	
	func setEntries(entries: Int) {
		let rel = XGFiles.common_rel.data!
		rel.replace4BytesAtOffset(self.commonRelEntriesIndex.startOffset, withBytes: entries)
		rel.save()
	}
	
	var commonRelIndex : CommonIndexes {
		get {
			switch self {
			case .rock:
				return .PokespotRock
			case .oasis:
				return .PokespotOasis
			case .cave:
				return .PokespotCave
			case .all:
				return .PokespotAll
			}
		}
	}
	
	var commonRelEntriesIndex : CommonIndexes {
		get {
			switch self {
			case .rock:
				return .PokespotRockEntries
			case .oasis:
				return .PokespotOasisEntries
			case .cave:
				return .PokespotCaveEntries
			case .all:
				return .PokespotAllEntries
			}
		}
	}
	
	
	func relocatePokespotData(toOffset offset: Int) {
		common.replacePointer(index: self.commonRelIndex.rawValue, newAbsoluteOffset: offset)
	}
	
}

extension XGPokeSpots: XGEnumerable {
	var enumerableName: String {
		return string
	}
	
	var enumerableValue: String? {
		return rawValue.string
	}
	
	static var className: String {
		return "Pokespots"
	}
	
	static var allValues: [XGPokeSpots] {
		return allCases
	}
}

extension XGPokeSpots: XGDocumentable {
	
	var documentableName: String {
		return string
	}
	
	static var DocumentableKeys: [String] {
		return ["Encounters"]
	}
	
	func documentableValue(for key: String) -> String {
		switch key {
		case "Encounters":
			var text = ""
			for i in 0 ..< self.numberOfEntries {
				let encounter = XGPokeSpotPokemon(index: i, pokespot: self)
				text += "\n" + encounter.pokemon.name.string.spaceToLength(20)
				text += " Lv. " + encounter.minLevel.string + " - " + encounter.maxLevel.string
			}
			return text
		default:
			return ""
		}
	}
}



















