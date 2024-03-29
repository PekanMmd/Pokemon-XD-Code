//
//  CMGiftPokemonManager.swift
//  GoD Tool
//
//  Created by The Steez on 25/10/2018.
//

import Foundation

let kNumberOfGiftPokemon = 6

class XGGiftPokemonManager {
	class func giftWithID(_ id: Int) -> XGGiftPokemon {
		switch id {
		case 1: return XGDemoStarterPokemon(index: 0) // espeon
		case 2: return XGDemoStarterPokemon(index: 1) // umbreon
		case 3: return CMGiftPokemon(index: 0) // duking's plusle
		case 4: return CMGiftPokemon(index: 1) // mt battle ho-oh
		case 5: return CMGiftPokemon(index: 3) // colosseum pikachu
		case 6: return CMGiftPokemon(index: 2) // agate celebi
		default: return XGDemoStarterPokemon(index: 0)
		}
	}
	
	class func allGiftPokemon() -> [XGGiftPokemon] {
		var gifts = [XGGiftPokemon]()
		
		for i in 1 ... kNumberOfGiftPokemon {
			gifts.append(XGGiftPokemonManager.giftWithID(i))
		}
		
		return gifts
	}

	class func allNonShadowGiftPokemon() -> [XGGiftPokemon] {
		return allGiftPokemon()
	}
	
	class func allStarterGiftPokemon() -> [XGGiftPokemon] {
		var gifts = [XGGiftPokemon]()

		for i in 1 ... 2 {
			gifts.append(XGGiftPokemonManager.giftWithID(i))
		}

		return gifts
	}
	
	class func allNonStarterGiftPokemon() -> [XGGiftPokemon] {
		var gifts = [XGGiftPokemon]()

		for i in 3 ... kNumberOfGiftPokemon {
			gifts.append(XGGiftPokemonManager.giftWithID(i))
		}

		return gifts
	}
}
