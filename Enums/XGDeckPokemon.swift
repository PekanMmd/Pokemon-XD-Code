//
//  XGDPKM.swift
//  XG Tool
//
//  Created by The Steez on 01/06/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//

import Foundation

enum XGDeckPokemon {
	
	case DPKM(Int, XGDecks)
	case DDPK(Int)
	
	var index : Int {
		get {
			switch self {
				case .DPKM(let i, let _) : return i
				case .DDPK(let i): return i
			}
		}
	}
	
	var isSet : Bool {
		get {
			return index > 0
		}
	}
	
	var isShadow : Bool {
		get {
			switch self {
				case .DPKM: return false
				case .DDPK: return true
			}
		}
	}
	
	var deck : XGDecks {
		get {
			switch self {
				case .DPKM(let _, let d) : return d
				case .DDPK				 : return XGDecks.DeckStory
			}
		}
	}
	
	var DPKMIndex : Int {
		get {
			switch self {
				case .DPKM: return index
				case .DDPK: var start = XGDecks.DeckDarkPokemon.DDPKDataOffset + (index * kSizeOfShadowData)
							return XGDecks.DeckDarkPokemon.data.get2BytesAtOffset(start + kShadowStoryIndexOffset)
			}
		}
	}
	
	var pokemon : XGPokemon {
		get {
			var start   = deck.DPKMDataOffset + (DPKMIndex * kSizeOfPokemonData)
			var species = deck.data.get2BytesAtOffset(start + kPokemonIndexOffset)
			
			return XGPokemon.Pokemon(species)
		}
	}
	
	var level : Int {
		get {
			switch self {
				case .DPKM: var start = deck.DPKMDataOffset + (index * kSizeOfPokemonData)
							return deck.data.getByteAtOffset(start + kPokemonLevelOffset)
				case .DDPK: var start = XGDecks.DeckDarkPokemon.DDPKDataOffset + (index * kSizeOfShadowData)
							return XGDecks.DeckDarkPokemon.data.getByteAtOffset(start + kShadowLevelOffset)
			}
		}
	}
	
}





















