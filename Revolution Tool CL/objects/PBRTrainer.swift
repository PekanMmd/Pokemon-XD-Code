//
//  Trainer.swift
//  Mausoleum Tool
//
//  Created by StarsMmd on 25/09/2014.
//  Copyright (c) 2014 Steezy. All rights reserved.
//

import Foundation

let kSizeOfTrainerData				= 0x98

// ---

let kNumberOfTrainerPokemon			= 0x06

let kTrainerClassNameOffset			= 0x00
let kTrainerNameIDOffset			= 0x00
let kTrainerClassModelOffset		= 0x00
let kFirstTrainerPokemonOffset		= 0x00

class XGTrainer: NSObject, XGDictionaryRepresentable {

	var index				= 0x0
	var deckData			= XGDeckTrainer.deck(0, .null)
	
	@objc var nameID		= 0x0
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
				s += "level \(p.level) : \(p.pokemon.name)"
				s += "\n"
			}
			
			s += "--------------------------\n"
			
			return s
		}
	}
	
	@objc var startOffset : Int {
		get {
			return index * kSizeOfTrainerData
		}
	}
	
	@objc var name : XGString {
		get {
			return XGString(string: "", file: nil, sid: nil)
		}
	}
	
	init(deckData: XGDeckTrainer) {
		super.init()
		
		self.index = deckData.index
		self.deckData  = deckData
		
		let start = startOffset
		let deck = deckData.deck.file.data!
		
		self.nameID =  deck.get2BytesAtOffset(start + kTrainerNameIDOffset)
		for i in 0 ..< 6 {
			
			let id = deck.get2BytesAtOffset(start + kFirstTrainerPokemonOffset + (i*2))
			
		}
		
		let tClass = deck.getByteAtOffset(start + kTrainerClassNameOffset)
		let tModel = deck.getByteAtOffset(start + kTrainerClassModelOffset)
		
		self.trainerModel = .none
		
		
	}
	
	@objc func save() {
		
		let start = startOffset
		let deck = self.deckData.deck.file.data!
		
		deck.replace2BytesAtOffset(start + kTrainerNameIDOffset, withBytes: self.nameID)
		
		deck.replaceByteAtOffset(start + kTrainerClassModelOffset, withByte: self.trainerModel.rawValue)
		
		var current = start + kFirstTrainerPokemonOffset
		
		for i in 0 ..< 6 {
			
			deck.replace2BytesAtOffset(current, withBytes: self.pokemon[i].index)
			
			current += 2
		}
		
		deck.save()
	}
   
}




























