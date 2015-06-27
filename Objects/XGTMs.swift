//
//  TMLister.swift
//  Mausoleum Tool
//
//  Created by The Steez on 11/04/2015.
//  Copyright (c) 2015 Steezy. All rights reserved.
//

import UIKit

let kFirstTMListOffset = 0x4023A0
let kSizeOfTMEntry	   = 0x08
let kFirstTMItemIndex  = 0x121
let kNumberOfTMsAndHMs = 0x3A

enum XGTMs {
	
	case TM(Int)
	
	var index : Int {
		get {
			switch self {
				case .TM(let i): return i
			}
		}
	}
	
	var startOffset : Int {
		get {
			return kFirstTMListOffset + ((index - 1) * kSizeOfTMEntry)
		}
	}
	
	var item : XGItems {
		get {
			let i = kFirstTMItemIndex + (index - 1)
			return .Item(i)
		}
	}
	
	var move : XGMoves {
		get {
			let i = XGFiles.Dol.data.get2BytesAtOffset(startOffset)
			return .Move(i)
		}
	}
	
	var location : String {
		get {
			switch self.index {
				case  1: return "Battle Disc 1"
				case  2: return "Orre Colosseum"
				case  3: return "Mt.Battle Area 2"
				case  4: return "Mt.Battle Are 7"
				case  5: return "Pyrite Colosseum"
				case  6: return "Orre Colosseum"
				case  7: return "-"
				case  8: return "Mt.Battle Area 8"
				case  9: return "Agate Village"
				case 10: return "Realgam Tower PokeMart"
				case 11: return "Battle Disc 49"
				case 12: return "Pyrite Colosseum"
				case 13: return "Phenac Stadium"
				case 14: return "Realgam Tower PokeMart"
				case 15: return "Realgam Tower PokeMart"
				case 16: return "Realgam Tower PokeMart"
				case 17: return "Realgam Tower PokeMart"
				case 18: return "Battle Disc 50"
				case 19: return "Realgam Tower Colosseum"
				case 20: return "Realgam Tower PokeMart"
				case 21: return "-"
				case 22: return "Realgam Tower Colosseum"
				case 23: return "Realgam Tower Colosseum"
				case 24: return "Cipher Key Lair"
				case 25: return "Realgam Tower PokeMart"
				case 26: return "Cipher Key Lair"
				case 27: return "Orre Colosseum"
				case 28: return "-"
				case 29: return "Team Snagem's Hideout"
				case 30: return "Team Snagem's Hideout"
				case 31: return "Pyrite Colosseum"
				case 32: return "Prestige Precept Center"
				case 33: return "Realgam Tower PokeMart"
				case 34: return "Mt.Battle Area 3"
				case 35: return "S.S. Libra"
				case 36: return "Orre Colosseum"
				case 37: return "-"
				case 38: return "Realgam Tower PokeMart"
				case 39: return "Mt.Battle Area 5"
				case 40: return "Mt.Battle Area 9"
				case 41: return "Pyrite Colosseum"
				case 42: return "Mt.Battle Area 4"
				case 43: return "-"
				case 44: return "Orre Colosseum"
				case 45: return "Gateon Port"
				case 46: return "-"
				case 47: return "Orre Colosseum"
				case 48: return "Orre Colosseum"
				case 49: return "Realgam Tower Colosseum"
				case 50: return "Mt.Battle Area 6"
				default : return "-"
			}
		}
	}
	
	func replaceWithMove(move: XGMoves) {
		
		var dol = XGFiles.Dol.data
		dol.replace2BytesAtOffset(startOffset, withBytes: move.index)
		dol.save()
	}
   
}








