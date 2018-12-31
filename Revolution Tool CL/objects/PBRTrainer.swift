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

class XGTrainer: NSObject, XGDictionaryRepresentable, XGIndexedValue {

	var index				= 0x0
	var deckData			= XGDeckTrainer.deck(0, .null)
	
	var nameID				= 0x0
	var pokemon				= [XGDeckPokemon]()
	var trainerModel		= XGTrainerModels.none
	
	@objc var dictionaryRepresentation : [String : AnyObject] {
		get {
			var dictRep = [String : AnyObject]()
			dictRep["index"] = self.index as AnyObject?
			dictRep["nameID"] = self.nameID as AnyObject?
			
			dictRep["trainerModel"] = self.trainerModel.dictionaryRepresentation as AnyObject?
			
			var pokemonArray = [ [String : AnyObject] ]()
			for a in pokemon {
				pokemonArray.append(a.dictionaryRepresentation)
			}
			dictRep["pokemon"] = pokemonArray as AnyObject?
			
			return dictRep
		}
	}
	
	@objc var readableDictionaryRepresentation : [String : AnyObject] {
		get {
			
			var dictRep = [String : AnyObject]()
			dictRep["index"] = self.index as AnyObject?
			
			dictRep["trainerModel"] = self.trainerModel.name as AnyObject?
			
			var pokemonArray = [AnyObject]()
			for a in pokemon {
				pokemonArray.append(a.readableDictionaryRepresentation as AnyObject)
			}
			dictRep["pokemon"] = pokemonArray as AnyObject?
			
			return [self.name.string : dictRep as AnyObject]
		}
	}
	
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
		
		let deck = PBRDataTableEntry(index: deckData.index, deck: deckData.deck)
		
		nameID = deck.getShort(6)
		
		
		
	}
	
	@objc func save() {
		
	}
   
}




























