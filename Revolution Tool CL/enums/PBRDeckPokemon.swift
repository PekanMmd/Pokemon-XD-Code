//
//  XGDPKM.swift
//  XG Tool
//
//  Created by StarsMmd on 01/06/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

enum XGDeckPokemon : XGDictionaryRepresentable {
	
	case deck(Int, XGDecks)
	
	var index : Int {
		get {
			switch self {
				case .deck(let i, _) :
					return i
			}
		}
	}
	
	var startOffset : Int {
		switch self {
			case .deck:
				return XGDecks.headerSize + (index * kSizeOfPokemonData)
		}
	}
	
	var deck : XGDecks {
		get {
			switch self {
				case .deck(_, let d) :
					return d
			}
		}
	}
	
	var pokemon : XGPokemon {
		get {
			let species = self.deck.file.data!.get2BytesAtOffset(startOffset + kPokemonIndexOffset)
			return XGPokemon.pokemon(species)
		}
	}
	
	var level : Int {
		get {
			return self.deck.file.data!.getByteAtOffset(startOffset + kPokemonLevelOffset)
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





















