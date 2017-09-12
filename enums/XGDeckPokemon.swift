//
//  XGDPKM.swift
//  XG Tool
//
//  Created by StarsMmd on 01/06/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

enum XGDeckPokemon : CustomStringConvertible {
	
	case dpkm(Int, XGDecks)
	case ddpk(Int)
	
	var index : Int {
		get {
			switch self {
				case .dpkm(let i, _) :
					return i
				case .ddpk(let i):
					return i
			}
		}
	}
	
	var startOffset : Int {
		switch self {
			case .dpkm:
				return deck.DPKMDataOffset + (index * kSizeOfPokemonData)
			case .ddpk:
				return XGDecks.DeckDarkPokemon.DDPKDataOffset + (index * kSizeOfShadowData)
		}
	}
	
	var isSet : Bool {
		get {
			return pokemon.index > 0
		}
	}
	
	var isShadow : Bool {
		get {
			switch self {
				case .dpkm:
					return false
				case .ddpk:
					return true
			}
		}
	}
	
	var deck : XGDecks {
		get {
			switch self {
				case .dpkm(_, let d) :
					return d
				case .ddpk:
					return XGDecks.DeckStory
			}
		}
	}
	
	var DPKMIndex : Int {
		get {
			switch self {
				case .dpkm:
					return index
				case .ddpk:
					return XGDecks.DeckDarkPokemon.data.get2BytesAtOffset(startOffset + kShadowStoryIndexOffset)
			}
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
			let start   = deck.DPKMDataOffset + (DPKMIndex * kSizeOfPokemonData)
			let species = deck.data.get2BytesAtOffset(start + kPokemonIndexOffset)
			
			return XGPokemon.pokemon(species)
		}
	}
	
	var level : Int {
		get {
			switch self {
				case .dpkm:
					return deck.data.getByteAtOffset(startOffset + kPokemonLevelOffset)
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
	
	var data : XGTrainerPokemon {
		get {
			return XGTrainerPokemon(DeckData: self)
		}
	}
	
	var dictionaryRepresentation: [String : AnyObject] {
		get {
			return self.data.dictionaryRepresentation
		}
	}
	
	var readableDictionaryRepresentation: [String : AnyObject] {
		get {
			return self.data.readableDictionaryRepresentation
		}
	}
	
}





















