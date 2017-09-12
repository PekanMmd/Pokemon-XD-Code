//
//  XGGiftPokemon.swift
//  XG Tool
//
//  Created by StarsMmd on 01/08/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

protocol XGGiftPokemon : XGDictionaryRepresentable {
	
	var index			: Int { get set }
	
	var level			: Int { get set }
	var exp				: Int { get set }
	var species			: XGPokemon { get set }
	var move1			: XGMoves { get set }
	var move2			: XGMoves { get set }
	var move3			: XGMoves { get set }
	var move4			: XGMoves { get set }
	var shinyValue		: XGShinyValues { get set }
	
	var giftType		: String { get set }
	
	func save()
   
}

extension XGGiftPokemon {
	
	var dictionaryRepresentation : [String : AnyObject] {
		get {
			var dictRep = [String : AnyObject]()
			dictRep["level"] = self.level as AnyObject?
			dictRep["exp"] = self.exp as AnyObject?
			
			dictRep["species"] = self.species.dictionaryRepresentation as AnyObject?
			dictRep["move1"] = self.move1.dictionaryRepresentation as AnyObject?
			dictRep["move2"] = self.move2.dictionaryRepresentation as AnyObject?
			dictRep["move3"] = self.move3.dictionaryRepresentation as AnyObject?
			dictRep["move4"] = self.move4.dictionaryRepresentation as AnyObject?
			dictRep["shinyValue"] = self.shinyValue.dictionaryRepresentation as AnyObject?
			
			return dictRep
		}
	}
	
	var readableDictionaryRepresentation : [String : AnyObject] {
		get {
			var dictRep = [String : AnyObject]()
			dictRep["giftType"] = self.giftType as AnyObject?
			dictRep["level"] = self.level as AnyObject?
			dictRep["exp"] = self.exp as AnyObject?
			
			dictRep["move1"] = self.move1.name.string as AnyObject?
			dictRep["move2"] = self.move2.name.string as AnyObject?
			dictRep["move3"] = self.move3.name.string as AnyObject?
			dictRep["move4"] = self.move4.name.string as AnyObject?
			dictRep["shinyValue"] = self.shinyValue.string as AnyObject?
			
			return [self.species.name.string : dictRep as AnyObject]
		}
	}
	
}












