//
//  XGDecks.swift
//  XG Tool
//
//  Created by StarsMmd on 30/05/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

let kNumberOfDecks = 8
let TrainerDecksArray : [XGDecks] = [.DeckStory, .DeckColosseum, .DeckHundred, .DeckVirtual, .DeckImasugu, .DeckBingo, .DeckSample,]
let MainDecksArray  : [XGDecks] = [.DeckStory, .DeckColosseum, .DeckHundred, .DeckVirtual]

let kOffensiveDTAI = [0x0F, 0x3A, 0x00, 0x00, 0x73, 0x73, 0x74, 0x73, 0x73, 0x74, 0x82, 0x00, 0x2C, 0x27, 0x50, 0x00, 0x50, 0x32, 0x14, 0x0A, 0x09, 0x09, 0x32, 0x32, 0x00, 0x09, 0x00, 0x09, 0x32, 0x32, 0x08, 00]
let kDefensiveDTAI = [0x0F, 0x3A, 0x00, 0x00, 0x73, 0x73, 0x74, 0x73, 0x73, 0x74, 0x82, 0x00, 0x2C, 0x27, 0x50, 0x00, 0x50, 0x1E, 0x00, 0x0A, 0x07, 0x09, 0x4B, 0x32, 0x00, 0x03, 0x00, 0x01, 0x4B, 0x19, 0x04, 0x00]
let kSimpleDTAI = [0x4F, 0x3E, 0x00, 0x00, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x00, 0x2B, 0x29, 0x32, 0x64, 0x32, 0x32, 0x32, 0x32, 0x09, 0x09, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]
let kCycleDTAI = [0x27, 0x2A, 0x00, 0x00, 0x73, 0x73, 0x74, 0x73, 0x73, 0x74, 0x82, 0x00, 0x2C, 0x27, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x09, 0x09, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]

/* Enum for different types of AI trainers can use.
* These values aren't inherent in XD
* they are AI data copy and pasted from different files.
* I'm not even entirely sure how they work or what the data means.
*
* run addOrreColoAIOptions() on the deck to enable these options
* otherwise they'll just be setting whichever AI happens
* to be in that index.
*
*/

enum XGAI : Int {
	case none 		= 0
	case offensive  = 1 // Copied from orre colosseum. Makes fairly smart and slightly randomised decisions but often gets stuck spamming status moves.
	case defensive  = 2 // Copied from orre colosseum. Makes fairly smart and slightly randomised decisions but often gets stuck spamming status moves.
	case simple 	= 3 // Copied from wild pokespot pokemon. Always makes the same best decision based on target in front. Seems to be unreliable in double battles.
	case cycle 		= 4 // Copied from battle CDs. Uses each of the pokemon's moves in order.
}

enum XGDecks : String, XGDictionaryRepresentable {
	
	case DeckDarkPokemon	= "DeckData_DarkPokemon"
	case DeckStory			= "DeckData_Story"
	case DeckBingo			= "DeckData_Bingo"
	case DeckColosseum		= "DeckData_Colosseum"
	case DeckHundred		= "DeckData_Hundred"
	case DeckImasugu		= "DeckData_Imasugu"
	case DeckSample			= "DeckData_Sample"
	case DeckVirtual		= "DeckData_Virtual"
	
	var id : Int {
		switch self {
		case .DeckStory:
			return 1
		case .DeckHundred:
			return 2
		case .DeckImasugu:
			return 3
		case .DeckVirtual:
			return 4
		case .DeckBingo:
			return 5
		case .DeckColosseum:
			return 6
		case .DeckSample:
			return 7
		case .DeckDarkPokemon:
			return 0
		}
	}
	
	static func deckWithID(_ id: Int) -> XGDecks? {
		for deck in TrainerDecksArray {
			if deck.id == id {
				return deck
			}
		}
		return nil
	}
	
	var file : XGFiles {
		get {
			return .deck(self)
		}
	}
	
	var fileName : String {
		get {
			return self.rawValue + XGFileTypes.bin.fileExtension
		}
	}
	
	var data : XGMutableData {
		get {
			return XGFiles.deck(self).data
		}
	}
	
	var fileSize : Int {
		get {
			return Int(data.getWordAtOffset(0x4))
		}
	}
	
	// DDPK only
	var DDPKHeaderOffset : Int {
		get {
			return 0x10
		}
	}
	
	var DDPKSize : Int {
		get {
			let offset = DDPKHeaderOffset + 0x4
			return Int(data.getWordAtOffset(offset))
		}
	}
	
	var DDPKEntries : Int {
		get {
			let offset = DDPKHeaderOffset + 0x08
			return Int(data.getWordAtOffset(offset))
		}
	}
	
	var DDPKDataOffset : Int {
		get {
			return DDPKHeaderOffset + 0x10
		}
	}
	
	// All other Decks
	
	// DTNR
	var DTNRHeaderOffset : Int {
		get {
			return 0x10
		}
	}
	
	var DTNRSize : Int {
		get {
			let offset = DTNRHeaderOffset + 0x4
			return Int(data.getWordAtOffset(offset))
		}
	}
	
	var DTNREntries : Int {
		get {
			let offset = DTNRHeaderOffset + 0x8
			return Int(data.getWordAtOffset(offset))
		}
	}
	
	var DTNRDataOffset : Int {
		get {
			return DTNRHeaderOffset + 0x10
		}
	}
	
	// DPKM
	var DPKMHeaderOffset : Int {
		get {
			return DTNRHeaderOffset + DTNRSize
		}
	}
	
	var DPKMSize : Int {
		get {
			let offset = DPKMHeaderOffset + 0x4
			return Int(data.getWordAtOffset(offset))
		}
	}
	
	var DPKMEntries : Int {
		get {
			let offset = DPKMHeaderOffset + 0x8
			return Int(data.getWordAtOffset(offset))
		}
	}
	
	var DPKMDataOffset : Int {
		get {
			return DPKMHeaderOffset + 0x10
		}
	}
	
	// DTAI
	var DTAIHeaderOffset : Int {
		get {
			return DPKMHeaderOffset + DPKMSize
		}
	}
	
	var DTAISize : Int {
		get {
			let offset = DTAIHeaderOffset + 0x4
			return Int(data.getWordAtOffset(offset))
		}
	}
	
	var DTAIEntries : Int {
		get {
			let offset = DTAIHeaderOffset + 0x8
			return Int(data.getWordAtOffset(offset))
		}
	}
	
	var DTAIDataOffset : Int {
		get {
			return DTAIHeaderOffset + 0x10
		}
	}
	
	// DSTR
	var DSTRHeaderOffset : Int {
		get {
			return DTAIHeaderOffset + DTAISize
		}
	}
	
	var DSTRSize : Int {
		get {
			let offset = DSTRHeaderOffset + 0x4
			return Int(data.getWordAtOffset(offset))
		}
	}
	
	var DSTREntries : Int {
		get {
			let offset = DSTRHeaderOffset + 0x8
			return Int(data.getWordAtOffset(offset))
		}
	}
	
	var DSTRDataOffset : Int {
		get {
			return DSTRHeaderOffset + 0x10
		}
	}
	
	func addPokemonEntries(count: Int) {
		let data = self.data
		
		let bytesToAdd = count * kSizeOfPokemonData
		let insertionPoint = DTAIHeaderOffset
		data.replaceWordAtOffset(DPKMHeaderOffset + 0x4, withBytes: UInt32(DPKMSize + bytesToAdd))
		data.replaceWordAtOffset(DPKMHeaderOffset + 0x8, withBytes: UInt32(DPKMEntries + count))
		data.insertRepeatedByte(byte: 0, count: bytesToAdd, atOffset: insertionPoint)
		data.replaceWordAtOffset(0x4, withBytes: UInt32(data.length))
		
		data.save()
	}
	
	func addTrainerEntries(count: Int) {
		let data = self.data
		
		let bytesToAdd = count * kSizeOfTrainerData
		let insertionPoint = DPKMHeaderOffset
		data.replaceWordAtOffset(DTNRHeaderOffset + 0x4, withBytes: UInt32(DTNRSize + bytesToAdd))
		data.replaceWordAtOffset(DTNRHeaderOffset + 0x8, withBytes: UInt32(DTNREntries + count))
		data.insertRepeatedByte(byte: 0, count: bytesToAdd, atOffset: insertionPoint)
		data.replaceWordAtOffset(0x4, withBytes: UInt32(data.length))
		
		data.save()
	}
	
	func unusedPokemon() -> XGDeckPokemon {
		let next = nextUnusedIndexFromIndex(0)
		return XGDeckPokemon.dpkm(next, self)
	}
	
	func unusedPokemonCount(_ count:Int) -> [XGDeckPokemon] {
		let indices = nextUnusedIndicesCount(count)
		
		return indices.map({ (id) -> XGDeckPokemon in
			return XGDeckPokemon.dpkm(id, self)
		})
	}
	
	func nextUnusedIndexFromIndex(_ index: Int) -> Int {
		for i in index...DPKMEntries {
			
			if i == 0 {
				continue
			}
			
			let deckdata = XGDeckPokemon.dpkm(i, self)
			if XGTrainerPokemon(DeckData: deckdata).species.index == 0 {
				return i
			}
		}
		printg("No more unused pokemon")
		return 0
	}
	
	func nextUnusedIndicesCount(_ count:Int) -> [Int] {
		var indices = [Int]()
		
		var index = 1
		for _ in 1...count {
			let nex = self.nextUnusedIndexFromIndex(index)
			if nex == 0 {
				break
			}
			indices.append(nex)
			index = nex + 1
		}
		return indices
	}
	
	func addOrreColoAIOptions() {
		
		let data = self.data
		
		data.replaceBytesFromOffset(DTAIDataOffset + kSizeOfAIData, withByteStream: kOffensiveDTAI + kDefensiveDTAI + kSimpleDTAI + kCycleDTAI)
		
		data.save()
	}
	
	var allTrainers : [XGTrainer] {
		get {
			var tr = [XGTrainer]()
			for i in 1 ..< self.DTNREntries {
				tr.append(XGTrainer(index: i, deck: self))
			}
			return tr
		}
	}
	
	var allPokemon : [XGTrainerPokemon] {
		get {
			
			var pokes = [XGTrainerPokemon]()
			
			if self == .DeckDarkPokemon {
				for i in 0 ..< self.DDPKEntries {
					pokes.append(XGTrainerPokemon(DeckData: .ddpk(i)))
				}
			} else {
				for i in 0 ..< self.DPKMEntries {
					pokes.append(XGTrainerPokemon(DeckData: .dpkm(i, self)))
				}
			}
			
			return pokes
		}
	}
	
	var allActivePokemon : [XGTrainerPokemon] {
		get {
			return allPokemon.filter({ (p) -> Bool in
				return p.species.index > 0
			})
		}
	}
	
	var dictionaryRepresentation: [String : AnyObject] {
		get {
			if self == .DeckDarkPokemon {
				
				var rep = [AnyObject]()
				
				for i in 0 ..< self.DDPKEntries {
					let poke = XGDeckPokemon.ddpk(i)
					
					rep.append(poke.dictionaryRepresentation as AnyObject)
					
				}
				
				return ["Shadow Pokemon" : rep as AnyObject]
				
			} else {
				var rep : [String : AnyObject] = ["Deck" : self.fileName as AnyObject]
				
				var trainers = [ [String : AnyObject] ]()
				
				for trainer in self.allTrainers {
					trainers.append(trainer.dictionaryRepresentation)
				}
				
				rep["Trainers"] = trainers as AnyObject?
				
				return rep
			}
		}
	}
	
	var readableDictionaryRepresentation: [String : AnyObject] {
		get {
			
			if self == .DeckDarkPokemon {
				
				var rep = [AnyObject]()
				
				for mon in self.allActivePokemon {
					let poke = mon.deckData
					
					rep.append(poke.readableDictionaryRepresentation as AnyObject)
					
				}
				
				return ["Shadow Pokemon" : rep as AnyObject]
				
			} else {
				
				var rep : [String : AnyObject] = ["Deck" : self.fileName as AnyObject]
				
				var trainers = [ [String : AnyObject] ]()
				
				for trainer in self.allTrainers {
					trainers.append(trainer.readableDictionaryRepresentation)
				}
				
				rep["Trainers"] = trainers as AnyObject?
				
				return [self.fileName : rep as AnyObject]
			}
		}
	}
	
	func trainersString() -> String {
		
		
		if self.rawValue == XGDecks.DeckDarkPokemon.rawValue {
			return ""
		}
		
		let trainers = self.allTrainers
		var string = self.rawValue + "\n\n\n"
		let trainerLength = 30
		let pokemonLength = 20
		let trainerTab = "".spaceToLength(trainerLength)
		
		for trainer in trainers {
			
			let name = trainer.trainerClass.name
			if name.stringLength > 1 {
				switch name.chars[0] {
				case .special( _, _) : name.chars[0...1] = [name.chars[1]]
				default: break
				}
			}
			
			string += (name.string + " " + trainer.name.string).spaceToLength(trainerLength)
			for p in trainer.pokemon {
				if p.isSet {
					string += ((p.isShadow ? "Shadow " : "") + p.pokemon.name.string).spaceToLength(pokemonLength)
				}
			}
			string += "\n" + trainer.locationString.spaceToLength(trainerLength)
			
			for p in trainer.pokemon {
				if p.isSet {
					string += ("Level " + p.level.string + (p.isShadow ? "+" : "")).spaceToLength(pokemonLength)
				}
			}
			string += "\n" + trainerTab
			
			let mons = trainer.pokemon.map({ (dpoke) -> XGTrainerPokemon in
				return dpoke.data
			})
			
			for p in mons {
				if p.isSet {
					string += p.item.name.string.spaceToLength(pokemonLength)
				}
			}
			string += "\n" + trainerTab
			
			for i in 0 ..< 4 {
				
				for p in mons {
					if p.isSet {
						string += (p.shadowMoves[i].index == 0 ? p.moves[i] : p.shadowMoves[i]).name.string.spaceToLength(pokemonLength)
					}
				}
				
				string += "\n" + trainerTab
			}
			
			
			string += "\n\n"
		}
		
		return string + "\n\n\n\n\n\n"
		
	}
	
	
}














