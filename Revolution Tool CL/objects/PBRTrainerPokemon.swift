//
//  Pokemon.swift
//  Mausoleum Tool
//
//  Created by StarsMmd on 03/10/2014.
//  Copyright (c) 2014 Steezy. All rights reserved.
//

import Foundation

let kSizeOfPokemonData		= 0x38

let kNumberOfPokemonMoves	= 0x04
let kNumberOfEVs			= 0x06
let kNumberOfIVs			= 0x06


// ---


let kPokemonIndexOffset		= 0x00
let kPokemonLevelOffset		= 0x00
let kPokemonHappinessOffset	= 0x00
let kPokemonItemOffset		= 0x00
let kFirstPokemonIVOffset	= 0x00
let kFirstPokemonEVOffset	= 0x00
let kFirstPokemonMoveOffset	= 0x00
let kPokemonPIDOffset		= 0x00
let kPokemonGenderOffset    = 0x00


class XGTrainerPokemon : NSObject, XGDictionaryRepresentable {
	
	var deckData	= XGDeckPokemon.deck(0, XGDecks.null)
	
	var species		= XGPokemon.pokemon(0)
	@objc var level		= 0x0
	@objc var happiness	= 0x0
	var item		= XGItems.item(0)
	var nature		= XGNatures.hardy
	var gender		= XGGenders.male
	@objc var IVs			= 0x0 // All IVs will be the same. Not much point in varying them.
	@objc var EVs			= [0,0,0,0,0,0]
	var moves		= [XGMoves](repeating: XGMoves.move(0), count: kNumberOfPokemonMoves)
	@objc var ability		= 0x0
	
	@objc var dictionaryRepresentation : [String : AnyObject] {
		get {
			var dictRep = [String : AnyObject]()
			dictRep["level"] = self.level as AnyObject?
			dictRep["happiness"] = self.happiness as AnyObject?
			dictRep["ability"] = self.ability as AnyObject?
			dictRep["IVs"] = self.IVs as AnyObject?
			
			dictRep["species"] = self.species.dictionaryRepresentation as AnyObject?
			dictRep["item"] = self.item.dictionaryRepresentation as AnyObject?
			dictRep["nature"] = self.nature.dictionaryRepresentation as AnyObject?
			dictRep["gender"] = self.gender.dictionaryRepresentation as AnyObject?
			
			var EVsArray = [AnyObject]()
			for a in EVs {
				EVsArray.append(a as AnyObject)
			}
			dictRep["EVs"] = EVsArray as AnyObject?
			
			var movesArray = [ [String : AnyObject] ]()
			for a in moves {
				movesArray.append(a.dictionaryRepresentation)
			}
			dictRep["moves"] = movesArray as AnyObject?
			
			return dictRep
		}
	}
	
	@objc var readableDictionaryRepresentation : [String : AnyObject] {
		get {
			var dictRep = [String : AnyObject]()
			
			dictRep["level"] = self.level as AnyObject?
			dictRep["happiness"] = self.happiness as AnyObject?
			dictRep["ability"] = (self.ability == 0 ? self.species.stats.ability1.name.string : self.species.stats.ability2.name.string ) as AnyObject?
			dictRep["IVs"] = self.IVs as AnyObject?
			
			dictRep["item"] = self.item.name.string as AnyObject?
			dictRep["nature"] = self.nature.string as AnyObject?
			dictRep["gender"] = self.gender.string as AnyObject?
				
			var EVsDict = [String : AnyObject]()
			EVsDict["HP"] = EVs[0] as AnyObject?
			EVsDict["attack"] = EVs[1] as AnyObject?
			EVsDict["defense"] = EVs[2] as AnyObject?
			EVsDict["sp.atk"] = EVs[3] as AnyObject?
			EVsDict["sp.def"] = EVs[4] as AnyObject?
			EVsDict["speed"] = EVs[5] as AnyObject?
			dictRep["EVs"] = EVsDict as AnyObject?
			
			var movesArray = [AnyObject]()
			for a in moves {
				movesArray.append(a.name.string as AnyObject)
			}
			dictRep["moves"] = movesArray as AnyObject?
			
			return [self.species.name.string : dictRep as AnyObject]
		}
	}
	
	
	@objc var startOffset : Int {
		get {
			return (deckData.index * kSizeOfPokemonData)
		}
	}
	
	init(DeckData: XGDeckPokemon) {
		super.init()
		
		self.deckData = DeckData
		
		
		let data = deckData.deck.file.data!
		let start = self.startOffset
		
		species			= deckData.pokemon
		level			= deckData.level
		
		happiness		= data.getByteAtOffset(start + kPokemonHappinessOffset)
		let item		= data.get2BytesAtOffset(start + kPokemonItemOffset)
		self.item		= .item(item)
		IVs				= data.getByteAtOffset(start + kFirstPokemonIVOffset)
		
		let pid = data.getByteAtOffset(start + kPokemonPIDOffset)
		
		ability		= 0
		
		let gender	= 0
		self.gender = XGGenders(rawValue: gender)!
		
		let nature	= 0
		self.nature	= XGNatures(rawValue: nature)!
		
		self.EVs = data.getByteStreamFromOffset(start + kFirstPokemonEVOffset, length: kNumberOfEVs)
		
		for i in 0 ..< kNumberOfPokemonMoves {
			let index = data.get2BytesAtOffset(start + kFirstPokemonMoveOffset + (i * 2))
			self.moves[i] = .move(index)
		}
		
	}
	
	
	@objc func save() {
		
		let data = self.deckData.deck.file.data!
		let start = startOffset
		
		data.replace2BytesAtOffset(start + kPokemonIndexOffset, withBytes: species.index)
		data.replace2BytesAtOffset(start + kPokemonItemOffset, withBytes: item.index)
		data.replaceByteAtOffset(start + kPokemonHappinessOffset, withByte: happiness)
		
		var pid = 0
		
		data.replaceByteAtOffset(start + kPokemonPIDOffset, withByte: pid)
		
		let IVs = [Int](repeating: self.IVs, count: kNumberOfIVs)
		data.replaceBytesFromOffset(start + kFirstPokemonIVOffset, withByteStream: IVs)
		
		data.replaceBytesFromOffset(start + kFirstPokemonEVOffset, withByteStream: self.EVs)
		
		for i in 0 ..< kNumberOfPokemonMoves {
			data.replace2BytesAtOffset(start + kFirstPokemonMoveOffset + (i * 2), withBytes: self.moves[i].index)
		}
		data.save()
		
	}
	
	@objc func purge() {
		species		= XGPokemon.pokemon(0)
		level		= 0
		happiness	= 0
		ability		= 0
		item		= XGItems.item(0)
		nature		= XGNatures.hardy
		gender		= XGGenders.male
		IVs			= 0
		EVs			= [Int](repeating: 0, count: 6)
		moves		= [XGMoves](repeating: XGMoves.move(0), count: kNumberOfPokemonMoves)
		
	}


}





















