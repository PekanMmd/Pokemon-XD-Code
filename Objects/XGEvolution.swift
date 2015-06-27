//
//  Evolution.swift
//  Mausoleum Stats Tool
//
//  Created by The Steez on 03/01/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//

import UIKit

let kNumberOfEvolutions			= 0x5
let kSizeOfEvolutionData		= 0x6

let kEvolutionMethodOffset		= 0x0 // 1 byte
let kEvolutionConditionOffset	= 0x2 // 2 bytes
let kEvolvedFormOffset			= 0x4 // 2 bytes

class XGEvolution: NSObject {
	
	var evolutionMethod	= XGEvolutionMethods.None
	var condition		= 0
	var evolvesInto		= 0
	
	
	init(evolutionMethod: Int, condition: Int, evolvedForm: Int) {
		super.init()
		
		self.evolutionMethod = XGEvolutionMethods(rawValue: evolutionMethod)!
		self.condition		 = condition
		self.evolvesInto	 = evolvedForm
	}
	
	func isSet() -> Bool {
		return self.evolutionMethod != .None
	}
	
	func toInts() -> (Int, Int, Int) {
		return (evolutionMethod.rawValue, condition, evolvesInto)
	}
	
}
