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
	
	var evolutionMethod		= XGEvolutionMethods.none
	@objc var condition		= 0
	@objc var evolvesInto		= 0
	
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

extension XGEvolution: XGDocumentable {
	
	static var documentableClassName: String {
		return "Evolution"
	}
	
	var documentableName: String {
		return XGPokemon.pokemon(evolvesInto).name.string
	}
	
	static var DocumentableKeys: [String] {
		return ["method", "condition", "evolution"]
	}
	
	func documentableValue(for key: String) -> String {
		switch key {
		case "method":
			return evolutionMethod.string
		case "condiiton":
			switch evolutionMethod {
			case .levelUp:
				return "level " + condition.string
			case .trade:
				return condition.string
			case .tradeWithItem:
				return XGItems.item(condition).name.string
			case .evolutionStone:
				return XGItems.item(condition).name.string
			case .levelUpWithKeyItem:
				return XGItems.item(condition).name.string
			default:
				return condition == 0 ? "-" : condition.string
			}
		case "evolution":
			return documentableName
		default:
			return ""
		}
	}
}
