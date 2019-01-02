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
	
	var dataTable : PBRDataTable {
		switch self {
		case .dcka: return PBRDataTable.AIDeck()!
		case .dckt(let i): return PBRDataTable.trainerDeckWithID(i)!
		case .dckp(let i): return PBRDataTable.pokemonDeckWithID(i)!
		case .null: return PBRDataTable(file: self.file)
		}
		
	}
	
	static var level30opendouble : XGDecks { return .dckp(0) }
	static var level30opensingle : XGDecks { return .dckp(1) }
	static var level50alldouble : XGDecks { return .dckp(2) }
	static var level50allsingle : XGDecks { return .dckp(3) }
	static var masters : XGDecks { return .dckp(4) }
	static var tradedouble : XGDecks { return .dckp(5) }
	static var tradesingle : XGDecks { return .dckp(6) }
	static var rentalpasses : XGDecks { return .dckp(7) }
	static var level30opendouble2 : XGDecks { return .dckp(8) }
	static var level30opensingle2 : XGDecks { return .dckp(9) }
	static var level50alldouble2 : XGDecks { return .dckp(10) }
	static var level50allsingle2 : XGDecks { return .dckp(11) }
	static var empty : XGDecks { return .dckp(12) }
	static var sample : XGDecks { return .dckp(13) }
	static var littledouble : XGDecks { return .dckp(14) }
	static var littlesingle : XGDecks { return .dckp(15) }
	
	
}














