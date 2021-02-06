//
//  XGDecks.swift
//  XG Tool
//
//  Created by StarsMmd on 30/05/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

enum XGDeckTypes : UInt32 {
	case DCKT = 0x44434B54
	case DCKP = 0x44434B50
	case DCKA = 0x44434B41
	case none = 0x00000000

	var name: String {
		switch self {
		case .DCKT: return "Trainer Deck"
		case .DCKP: return "Pokemon Deck"
		case .DCKA: return "AI Deck"
		case .none: return "none"
		}
	}
}

enum XGDecks {
	
	case null
	case dckp(Int)
	case dckt(Int)
	case dcka
	
	var file : XGFiles {
		get {
			switch self {
				case .null: return .nameAndFolder("", .Documents)
				case .dckp(let i): return .dckp(i)
				case .dckt(let i): return .dckt(i)
				case .dcka: return .dcka
			}
		}
	}

	var index: Int {
		switch self {
			case .null: return 0
			case .dckp(let i): return i
			case .dckt(let i): return i
			case .dcka: return 0
		}
	}
	
	var type : XGDeckTypes {
		switch self {
			case .dckp	: return .DCKP
			case .dckt	: return .DCKT
			case .dcka  : return .DCKA
			default		: return .none
		}
	}
	
	var numberOfEntries : Int {
		return self.dataTable.numberOfEntries
	}
	
	var entrySize : Int {
		return self.dataTable.entrySize
	}
	
	static var headerSize : Int {
		return 0x10
	}
	
	var dataTable : GoDDataTable {
		return GoDDataTable.tableForFile(file)
	}

	var name: String {
		guard case .dckp = self else {
			return file.fileName
		}
		switch index {
		case 0: return "Level 30 open double"
		case 1: return "Level 30 open single"
		case 2: return "Level 50 all double"
		case 3: return "Level 50 all single"
		case 4: return "Masters"
		case 5: return "Rental double"
		case 6: return "Rental single"
		case 7: return "Rental passes"
		case 8: return "Level 30 survival double"
		case 9: return "Level 30 survival single"
		case 10: return "Level 50 survival double"
		case 11: return "Level 50 survival single"
		case 12: return "Tutorial"
		case 13: return "Sample"
		case 14: return "Little cup double"
		case 15: return "Little cup single"
		default: return file.fileName
		}
	}

	var pokemon: [XGDeckPokemon] {
		switch self {
		case .dckp:
			return (0 ..< numberOfEntries).map { XGDeckPokemon.deck($0, self) }
		default:
			return []
		}
	}

	static var level30opendouble : XGDecks { return .dckp(0) }
	static var level30opensingle : XGDecks { return .dckp(1) }
	static var level50alldouble : XGDecks { return .dckp(2) }
	static var level50allsingle : XGDecks { return .dckp(3) }
	static var masters : XGDecks { return .dckp(4) }
	static var rentaldouble : XGDecks { return .dckp(5) }
	static var rentalsingle : XGDecks { return .dckp(6) }
	static var rentalpasses : XGDecks { return .dckp(7) }
	static var level30survivaldouble : XGDecks { return .dckp(8) }
	static var level30survivalsingle : XGDecks { return .dckp(9) }
	static var level50survivaldouble : XGDecks { return .dckp(10) }
	static var level50survivalsingle : XGDecks { return .dckp(11) }
	static var tutorial : XGDecks { return .dckp(12) }
	static var sample : XGDecks { return .dckp(13) }
	static var littledouble : XGDecks { return .dckp(14) }
	static var littlesingle : XGDecks { return .dckp(15) }
}

extension XGDecks: XGEnumerable {
	var enumerableName: String {
		name
	}

	var enumerableValue: String? {
		type.name + " " + index.string
	}

	static var enumerableClassName: String {
		"Decks"
	}

	static var allValues: [XGDecks] {
		(0...15).map{ XGDecks.dckp($0) }
	}
}













