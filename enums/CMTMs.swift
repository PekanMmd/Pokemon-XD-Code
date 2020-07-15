//
//  CMTMs.swift
//  Colosseum Tool
//
//  Created by The Steez on 06/06/2018.
//

import Foundation

let kFirstTMListOffset = region == .JP ? 0x351758 : 0x365018

let kSizeOfTMEntry	   = 0x08
let kFirstTMItemIndex  = 0x121
let kNumberOfTMsAndHMs = 0x3A
let kNumberOfTMs	   = 0x32

let kNumberOfTutorMoves = 0

enum XGTMs {
	
	case tm(Int)
	case tutor(Int)
	
	var index : Int {
		switch self {
		case .tm(let i): return i
		default:
			assertionFailure("This is only for XD compatibility")
			return -1
		}
	}
	
	var startOffset : Int {
		return kFirstTMListOffset + 6 + ((index - 1) * kSizeOfTMEntry)
	}
	
	var item : XGItems {
		let i = kFirstTMItemIndex + (index - 1)
		return .item(i)
	}
	
	var move : XGMoves {
		return .move( XGFiles.dol.data!.get2BytesAtOffset(startOffset) )
	}
	
	var location : String {
		return TMLocations[self.index - 1]
	}
	
	func replaceWithMove(_ move: XGMoves) {
		if move == XGMoves.move(0) { return }
		
		let dol = XGFiles.dol.data!
		dol.replace2BytesAtOffset(startOffset, withBytes: move.index)
		dol.save()
	}
	
	static func createItemDescriptionForMove(_ move: XGMoves) -> String {
		let desc = move.mdescription.string
		
		let maxLineLength = 20
		let newLine = "[New Line]"
		
		let words = desc.replacingOccurrences(of: newLine, with: " ").components(separatedBy: " ")
		
		var splitDesc = ""
		var lineLength = 0
		
		for w in 0 ..< words.count {
			
			let word = words[w]
			let len  = word.count
			
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
		return splitDesc
	}
	
	func updateItemDescription() {
		self.item.descriptionString.duplicateWithString(XGTMs.createItemDescriptionForMove(self.move)).replace()
		
	}
	
	static func allTMs() -> [XGTMs] {
		var tms = [XGTMs]()
		for i in 1 ... kNumberOfTMs {
			tms.append(.tm(i))
		}
		return tms
	}
}

func allTMsArray() -> [XGTMs] {
	var tms: [XGTMs] = []
	for i in 1 ... kNumberOfTMs {
		tms.append(XGTMs.tm(i))
	}
	return tms
}

let TMLocations = [
	"Pyrite Colosseum",
	"Deep Colosseum",
	"-",
	"-",
	"Pyrite Colosseum",
	"Pyrite Colosseum",
	"Pyrite Colosseum",
	"-",
	"-",
	"Under PokeMart",
	"Phenac Stadium",
	"Deep Colosseum",
	"Mt.Battle Prize",
	"Under PokeMart",
	"Under PokeMart",
	"Under PokeMart",
	"Under PokeMart",
	"Phenac Stadium",
	"Phenac Stadium",
	"Under PokeMart",
	"-",
	"Phenac Stadium",
	"Under Colosseum",
	"Mt.Battle Prize",
	"Under PokeMart",
	"Shadow Lab",
	"Phenac City",
	"-",
	"Mt.Battle Prize",
	"Under Colosseum",
	"Pyrite Colosseum",
	"Mt.Battle Prize",
	"Under PokeMart",
	"-",
	"Mt.Battle Prize",
	"Under Colosseum",
	"Under Colosseum",
	"Under PokeMart",
	"-",
	"-",
	"Phenac City",
	"-",
	"-",
	"Deep Colosseum",
	"The Under",
	"Pyrite Town",
	"Mt. Battle",
	"Deep Colosseum",
	"Pyrite Cave",
	"-",
]

extension XGTMs: Codable {
	enum CodingKeys: String, CodingKey {
		case index, move
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		let index = try container.decode(Int.self, forKey: .index)
		self = .tm(index)
	}
	
	static func update(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		let index = try container.decode(Int.self, forKey: .index)
		let move = try container.decode(XGMoves.self, forKey: .move)
		let tm = XGTMs.tm(index)
		tm.replaceWithMove(move)
		tm.updateItemDescription()
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(index, forKey: .index)
		try container.encode(move, forKey: .move)
	}
}

extension XGTMs: XGEnumerable {
	var enumerableName: String {
		return "TM" + String(format: "%02d", index)
	}
	
	var enumerableValue: String? {
		return move.name.string
	}
	
	static var enumerableClassName: String {
		return "TMs"
	}
	
	static var allValues: [XGTMs] {
		return allTMs()
	}
}

extension XGTMs: XGDocumentable {
	
	static var documentableClassName: String {
		return "TMs"
	}
	
	var documentableName: String {
		return enumerableName
	}
	
	static var DocumentableKeys: [String] {
		return ["index", "hex index", "name", "description"]
	}
	
	func documentableValue(for key: String) -> String {
		switch key {
		case "index":
			return index.string
		case "hex index":
			return index.hexString()
		case "name":
			return move.name.string
		case "description":
			return item.descriptionString.string
		default:
			return ""
		}
	}
}





