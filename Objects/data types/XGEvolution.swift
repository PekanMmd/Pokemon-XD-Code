//
//  Evolution.swift
//  Mausoleum Stats Tool
//
//  Created by StarsMmd on 03/01/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

let kNumberOfEvolutions			= 0x5
let kSizeOfEvolutionData		= 0x6

let kEvolutionMethodOffset		= 0x0 // 1 byte
let kEvolutionConditionOffset	= 0x2 // 2 bytes
let kEvolvedFormOffset			= 0x4 // 2 bytes

class XGEvolution: NSObject, Codable {
	
	var evolutionMethod	= XGEvolutionMethods.none
	@objc var condition		= 0
	@objc var evolvesInto	= 0
	
	@objc init(evolutionMethod: Int, condition: Int, evolvedForm: Int) {
		super.init()
		
		self.evolutionMethod = XGEvolutionMethods(rawValue: evolutionMethod)!
		self.condition		 = condition
		self.evolvesInto	 = evolvedForm
	}
	
	@objc func isSet() -> Bool {
		return self.evolutionMethod != .none
	}
	
	func toInts() -> (Int, Int, Int) {
		return (evolutionMethod.rawValue, condition, evolvesInto)
	}
	
}
