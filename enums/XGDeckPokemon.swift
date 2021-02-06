//
//  XGDPKM.swift
//  XG Tool
//
//  Created by StarsMmd on 01/06/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

enum XGDeckPokemon: CustomStringConvertible {
	
	case dpkm(Int, XGDecks)
	case ddpk(Int)
	
	var index: Int {
		get {
			switch self {
				case .dpkm(let i, _) :
					return i
				case .ddpk(let i):
					return i
			}
		}
	}
	
	var startOffset: Int {
		switch self {
			case .dpkm:
				return pokemonDeck.DPKMDataOffset + (index * kSizeOfPokemonData)
			case .ddpk:
				return XGDecks.DeckDarkPokemon.DDPKDataOffset + (index * kSizeOfShadowData)
		}
	}
	
	var isSet: Bool {
		get {
			return pokemon.index > 0
		}
	}
	
	var isShadow: Bool {
		get {
			switch self {
				case .dpkm:
					return false
				case .ddpk:
					return true
			}
		}
	}
	
	var pokemonDeck: XGDecks {
		switch self {
		case .dpkm(_, let d) :
			return d
		case .ddpk:
			return XGDecks.DeckStory
		}
	}

	private var rawDeck: XGDecks {
		switch self {
		case .dpkm(_, let d) :
			return d
		case .ddpk:
			return XGDecks.DeckDarkPokemon
		}
	}
	
	var DPKMIndex: Int {
		switch self {
		case .dpkm:
			return index
		case .ddpk:
			return XGDecks.DeckDarkPokemon.data.get2BytesAtOffset(startOffset + kShadowStoryIndexOffset)
		}
	}
	
	func setDPKMIndexForDDPK(newIndex: Int) {
		switch self {
			case .dpkm:
				break;
			case .ddpk:
				let deckData = XGDecks.DeckDarkPokemon.data
				deckData.replace2BytesAtOffset(startOffset + kShadowStoryIndexOffset, withBytes: newIndex)
				deckData.save()
		}
	}
	
	var pokemon : XGPokemon {
		get {
			let start   = pokemonDeck.DPKMDataOffset + (DPKMIndex * kSizeOfPokemonData)
			let species = pokemonDeck.data.get2BytesAtOffset(start + kPokemonIndexOffset)
			
			return XGPokemon.index(species)
		}
	}
	
	var level : Int {
		get {
			switch self {
				case .dpkm:
					return pokemonDeck.data.getByteAtOffset(startOffset + kPokemonLevelOffset)
				case .ddpk:
					return XGDecks.DeckDarkPokemon.data.getByteAtOffset(startOffset + kShadowLevelOffset)
			}
		}
	}
	
	var description : String {
		get {
			var d = "DPKM # " + String(format: "%3d", self.DPKMIndex) + "\n"
			
			if !self.isSet {
				return d + "<Empty Deck Slot>\n"
			}
			
			let p = XGTrainerPokemon(DeckData: self)
			let poke = self.pokemon
			
			if self.isShadow {
				d += "DDPK # " + String(format: "%3d", self.index) + "\n"
				d += "Shadow "
			}
			
			d += poke.name.string + "\n"
			d += String(format: "Level: %3d", self.level)
			d += self.isShadow ? "+\n" : "\n"
			
			let moves = p.moves
			
			for m in moves {
				d += "[\(m)]\n"
			}
			
			return d
		}
	}
	
	var data: XGTrainerPokemon {
		return XGTrainerPokemon(DeckData: self)
	}
	
}

extension XGDeckPokemon: Codable {
	enum CodingKeys: String, CodingKey {
		case deck, index
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		let deck = try container.decode(XGDecks.self, forKey: .deck)
		let index = try container.decode(Int.self, forKey: .index)
		switch deck {
		case .DeckDarkPokemon: self = .ddpk(index)
		default: self = .dpkm(index, deck)
		}
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(self.index, forKey: .index)
		try container.encode(self.rawDeck, forKey: .deck)
	}
}

extension XGDeckPokemon: XGEnumerable {
	var enumerableName: String {
		return pokemonDeck.enumerableName + " " + DPKMIndex.string
	}
	
	var enumerableValue: String? {
		return index.string
	}
	
	static var enumerableClassName: String {
		return "Trainer Pokemon"
	}
	
	static var allValues: [XGDeckPokemon] {
		var pokemon = [XGDeckPokemon]()
		for id in 1 ... 7 {
			if let deck = XGDecks.deckWithID(id) {
				pokemon += deck.allDeckPokemon
			}
		}
		return pokemon
	}
}

















