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
}

enum XGDecks {
	
	case null
	case dckp(Int)
	case dckt(Int)
	
	var file : XGFiles {
		get {
			switch self {
				case .null: return .nameAndFolder("", .Documents)
				case .dckp(let i): return .dckp(i)
				case .dckt(let i): return .dckt(i)
			}
		}
	}
	
	var type : XGDeckTypes {
		switch self {
			case .dckp	: return .DCKP
			default		: return .DCKT
		}
	}
	
	var NumberOfEntries : Int {
		get {
			return self.file.data!.get4BytesAtOffset(0x08)
		}
	}
	
	static var headerSize : Int {
		return 0x10
	}
	
	func addEntries(count: Int) {
		let data = self.file.data!
		
		let entrySize = self.type == .DCKT ? kSizeOfTrainerData : kSizeOfPokemonData
		data.insertRepeatedByte(byte: 0, count: count * entrySize, atOffset: data.length)
		
		data.replace4BytesAtOffset(0x4, withBytes: data.length)
		data.replace4BytesAtOffset(0x8, withBytes: self.NumberOfEntries + count)
		
		data.save()
	}
	
	
	
}














