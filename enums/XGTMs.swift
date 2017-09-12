//
//  TMLister.swift
//  Mausoleum Tool
//
//  Created by StarsMmd on 11/04/2015.
//  Copyright (c) 2015 Steezy. All rights reserved.
//

import Foundation

let kFirstTMListOffset = 0x4023A0
let kSizeOfTMEntry	   = 0x08
let kFirstTMItemIndex  = 0x121
let kNumberOfTMsAndHMs = 0x3A
let kNumberOfTMs	   = 0x32

let kFirstTutorMoveDataOffset	= 0xA7918
let kSizeOfTutorMoveEntry		= 0x0C
let kNumberOfTutorMoves			= 0x0C

let kTutorMoveMoveIndexOffset	= 0x00
let kAvailabilityFlagOffset		= 0x07

enum XGTMs : XGDictionaryRepresentable {
	
	case tm(Int)
	case tutor(Int)
	
	var index : Int {
		get {
			switch self {
				case .tm(let i): return i
				case .tutor(let i) : return i
			}
		}
	}
	
	var startOffset : Int {
		get {
			switch self {
			// Add 6 to the start offset because the actual Move index is 6 bytes in.
				case .tm : return kFirstTMListOffset + 6 + ((index - 1) * kSizeOfTMEntry)
				case .tutor : return kFirstTutorMoveDataOffset + ((index - 1) * kSizeOfTutorMoveEntry)
			}
		}
	}
	
	var item : XGItems {
		get {
			let i = kFirstTMItemIndex + (index - 1)
			return .item(i)
		}
	}
	
	var move : XGMoves {
		get {
			switch self {
				case .tm : return .move( XGFiles.dol.data.get2BytesAtOffset(startOffset) )
				case .tutor : return .move( XGFiles.common_rel.data.get2BytesAtOffset(startOffset + kTutorMoveMoveIndexOffset) )
			}
		}
	}
	
	var location : String {
		get {
			switch self.index {
				case  1: return "Battle CD 21"
				case  2: return "Orre Colosseum 7th set"
				case  3: return "Mt.Battle Area 2"
				case  4: return "Mt.Battle Are 7"
				case  5: return "Pyrite Colosseum 4th set"
				case  6: return "Orre Colosseum 1st set"
				case  7: return "-"
				case  8: return "Mt.Battle Area 8"
				case  9: return "Agate Village"
				case 10: return "Realgam Tower PokeMart"
				case 11: return "Battle CD 49"
				case 12: return "Pyrite Colosseum 2nd set"
				case 13: return "Phenac Stadium"
				case 14: return "Realgam Tower PokeMart"
				case 15: return "Realgam Tower PokeMart"
				case 16: return "Realgam Tower PokeMart"
				case 17: return "Realgam Tower PokeMart"
				case 18: return "Battle CD 50"
				case 19: return "Realgam Tower Colosseum 1st set"
				case 20: return "Realgam Tower PokeMart"
				case 21: return "-"
				case 22: return "Realgam Tower Colosseum 2nd set"
				case 23: return "Realgam Tower Colosseum 3rd set"
				case 24: return "Cipher Key Lair basement"
				case 25: return "Realgam Tower PokeMart"
				case 26: return "Cipher Key Lair Roof"
				case 27: return "Orre Colosseum 2nd set"
				case 28: return "-"
				case 29: return "Team Snagem's Hideout 1st floor"
				case 30: return "Team Snagem's Hideout Gonzap's key"
				case 31: return "Pyrite Colosseum 1st set"
				case 32: return "Phenac Pregym beat Justy"
				case 33: return "Realgam Tower PokeMart"
				case 34: return "Mt.Battle Area 3"
				case 35: return "S.S. Libra"
				case 36: return "Orre Colosseum 4th set"
				case 37: return "-"
				case 38: return "Realgam Tower PokeMart"
				case 39: return "Mt.Battle Area 5"
				case 40: return "Mt.Battle Area 9"
				case 41: return "Pyrite Colosseum 3rd set"
				case 42: return "Mt.Battle Area 4"
				case 43: return "-"
				case 44: return "Orre Colosseum 5th set"
				case 45: return "Gateon Port"
				case 46: return "Pyrite town prison"
				case 47: return "Orre Colosseum 6th set"
				case 48: return "Orre Colosseum 3rd set"
				case 49: return "Realgam Tower Colosseum 4th set"
				case 50: return "Mt.Battle Area 6"
				default : return "-"
			}
		}
	}
	
	var tutorFlag : XGTutorFlags {
		get {
			let flag = XGFiles.common_rel.data.getByteAtOffset(startOffset + kAvailabilityFlagOffset)
			return XGTutorFlags(rawValue: flag) ?? .immediately
		}
	}
	
	func replaceWithMove(_ move: XGMoves) {
		
		if move == XGMoves.move(0) { return }
		
		switch self {
			case .tm    :
				let dol = XGFiles.dol.data
				dol.replace2BytesAtOffset(startOffset, withBytes: move.index)
				dol.save()
				
				self.updateItemDescription()
			
			case .tutor : let rel = XGFiles.common_rel.data
						rel.replace2BytesAtOffset(startOffset + kTutorMoveMoveIndexOffset, withBytes: move.index)
						rel.save()
		}
	}
	
	func updateItemDescription() {
		
		let desc = self.move.mdescription.string
		
		let maxLineLength = 19
		let newLine = "[New Line]"
		
		let words = desc.replacingOccurrences(of: newLine, with: " ").components(separatedBy: " ")
		
		var splitDesc = ""
		var lineLength = 0
		
		for w in 0 ..< words.count {
			
			let word = words[w]
			let len  = word.characters.count
			
			if lineLength + len > maxLineLength {
				
				let end = splitDesc.endIndex
				splitDesc = splitDesc.replacingCharacters(in: splitDesc.index(before: end)..<end , with: newLine)
				
				lineLength = 0
				
			}
			
			splitDesc += word
			
			if w != words.count - 1 {
				splitDesc += " "
			}
			
			lineLength += len + 1
			
			
		}
		
		self.item.descriptionString.duplicateWithString(splitDesc).replace()
		
	}
	
	func replaceTutorFlag(_ flag: XGTutorFlags) {
		let rel = XGFiles.common_rel.data
		rel.replaceByteAtOffset(startOffset + kAvailabilityFlagOffset, withByte: flag.rawValue)
		rel.save()
	}
	
	var dictionaryRepresentation: [String : AnyObject] {
		get {
			var rep =  ["Value" : self.index as AnyObject]
			
			switch self {
			case .tutor( _):
				rep["Available"] = self.tutorFlag.rawValue as AnyObject?
			default:
				break
			}
			
			return rep
		}
	}
	
	var readableDictionaryRepresentation: [String : AnyObject] {
		get {
			switch self {
			case .tm(let i):
				return ["TM \(i)" : ["Move" : self.move.name.string, "Location" : self.location] as AnyObject]
			case .tutor(let i):
				return ["Tutor Move \(i)" : ["Move" : self.move.name.string, "Activated" : self.tutorFlag.string] as AnyObject]
			}
		}
	}
	
	static func allTMs() -> [XGTMs] {
		var tms = [XGTMs]()
		for i in 0 ..< kNumberOfTMs {
			tms.append(.tm(i))
		}
		return tms
	}
}

func allTMsArray() -> [XGTMs] {
	var tms: [XGTMs] = []
	for i in 0 ..< kNumberOfTMs {
		tms.append(XGTMs.tm(i))
	}
	return tms
}




















