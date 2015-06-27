//
//  XGDecks.swift
//  XG Tool
//
//  Created by The Steez on 30/05/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//

import Foundation

enum XGDecks : String {
	
	case DeckDarkPokemon	= "DeckData_DarkPokemon.bin"
	case DeckStory			= "DeckData_Story.bin"
	case DeckBingo			= "DeckData_Bingo.bin"
	case DeckColosseum		= "DeckData_Colosseum.bin"
	case DeckHundred		= "DeckData_Hundred.bin"
	case DeckImasugu		= "DeckData_Imasugu.bin"
	case DeckSample			= "DeckData_Sample.bin"
	case DeckVirtual		= "DeckData_Virtual.bin"
	
	var fileName : String {
		get {
			return self.rawValue
		}
	}
	
	var data : XGMutableData {
		get {
			return XGFiles.Deck(self).data
		}
	}
	
	var fileSize : Int {
		get {
			return Int(data.get4BytesAtOffset(0x4))
		}
	}
	
	// DDPK only
	var DDPKHeaderOffset : Int {
		get {
			return 0x10
		}
	}
	
	var DDPKSize : Int {
		get {
			let offset = DDPKHeaderOffset + 0x4
			return Int(data.get4BytesAtOffset(offset))
		}
	}
	
	var DDPKDataOffset : Int {
		get {
			return DDPKHeaderOffset + 0x10
		}
	}
	
	// All other Decks
	
	// DTNR
	var DTNRHeaderOffset : Int {
		get {
			return 0x10
		}
	}
	
	var DTNRSize : Int {
		get {
			let offset = DTNRHeaderOffset + 0x4
			return Int(data.get4BytesAtOffset(offset))
		}
	}
	
	var DTNREntries : Int {
		get {
			let offset = DTNRHeaderOffset + 0x8
			return Int(data.get4BytesAtOffset(offset))
		}
	}
	
	var DTNRDataOffset : Int {
		get {
			return DTNRHeaderOffset + 0x10
		}
	}
	
	// DPKM
	var DPKMHeaderOffset : Int {
		get {
			return DTNRHeaderOffset + DTNRSize
		}
	}
	
	var DPKMSize : Int {
		get {
			let offset = DPKMHeaderOffset + 0x4
			return Int(data.get4BytesAtOffset(offset))
		}
	}
	
	var DPKMEntries : Int {
		get {
			let offset = DPKMHeaderOffset + 0x8
			return Int(data.get4BytesAtOffset(offset))
		}
	}
	
	var DPKMDataOffset : Int {
		get {
			return DPKMHeaderOffset + 0x10
		}
	}
	
	// DTAI
	var DTAIHeaderOffset : Int {
		get {
			return DPKMHeaderOffset + DPKMSize
		}
	}
	
	var DTAISize : Int {
		get {
			let offset = DTAIHeaderOffset + 0x4
			return Int(data.get4BytesAtOffset(offset))
		}
	}
	
	var DTAIEntries : Int {
		get {
			let offset = DTAIHeaderOffset + 0x8
			return Int(data.get4BytesAtOffset(offset))
		}
	}
	
	var DTAIDataOffset : Int {
		get {
			return DTAIHeaderOffset + 0x10
		}
	}
	
	// DSTR
	var DSTRHeaderOffset : Int {
		get {
			return DTAIHeaderOffset + DTAISize
		}
	}
	
	var DSTRSize : Int {
		get {
			let offset = DSTRHeaderOffset + 0x4
			return Int(data.get4BytesAtOffset(offset))
		}
	}
	
	var DSTREntries : Int {
		get {
			let offset = DSTRHeaderOffset + 0x8
			return Int(data.get4BytesAtOffset(offset))
		}
	}
	
	var DSTRDataOffset : Int {
		get {
			return DSTRHeaderOffset + 0x10
		}
	}
	
	
}














