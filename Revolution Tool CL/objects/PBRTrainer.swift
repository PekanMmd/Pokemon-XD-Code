//
//  Trainer.swift
//  Mausoleum Tool
//
//  Created by StarsMmd on 25/09/2014.
//  Copyright (c) 2014 Steezy. All rights reserved.
//

import Foundation

let kSizeOfTrainerData				= 0x98
let kNumberOfTrainerPokemon			= 0x06

class XGTrainer: NSObject, XGIndexedValue {

	var index				= 0x0
	var deckData			= XGDeckTrainer.deck(0, .null)
	
	var nameID				= 0x0
	var pokemon				= [XGDeckPokemon]()
	var trainerModel		= XGTrainerModels.none
	
	override var description : String {
		get {
			var s = ""
			
			s += "--------------------------\n"
			s += "\(self.index): \(self.name)\n"
			s += "--------------------------\n"
			for p in self.pokemon {
				s += "\(p.pokemon.name)"
				s += "\n"
			}
			
			s += "--------------------------\n"
			
			return s
		}
	}
	
	@objc var name : XGString {
		get {
			return getStringSafelyWithID(id: nameID)
		}
	}
	
	init(deckData: XGDeckTrainer) {
		super.init()
		
		self.index = deckData.index
		self.deckData  = deckData

		var deckTable: PBRDataTable?
		switch deckData.deck {
		case .null:
			break
		case .dckp(let id):
			deckTable = PBRDataTable.pokemonDeckWithID(id)
		case .dckt(let id):
			deckTable = PBRDataTable.trainerDeckWithID(id)
		case .dcka:
			deckTable = PBRDataTable.AIDeck()
		}

		guard let entry = deckTable?.entryWithIndex(index) else {
			printg("Failed to load deck data:", deckData.deck.file.path, "\nindex:", index)
			return
		}

		nameID = entry.getShort(6)

	}
	
	@objc func save() {
		
	}
   
}




























