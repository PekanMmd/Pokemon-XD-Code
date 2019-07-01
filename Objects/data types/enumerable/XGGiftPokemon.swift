//
//  XGGiftPokemon.swift
//  XG Tool
//
//  Created by StarsMmd on 01/08/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

protocol XGGiftPokemon {
	
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












