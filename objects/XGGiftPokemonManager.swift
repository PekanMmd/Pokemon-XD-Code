//
//  XGGiftPokemonManager.swift
//  GoD Tool
//
//  Created by The Steez on 25/10/2018.
//

import Foundation

let kNumberOfGiftPokemon = 14

class XGGiftPokemonManager {
	class func giftWithID(_ id: Int) -> XGGiftPokemon {
		switch id {
		case 1: return XGDemoStarterPokemon(index: 0) // demo vaporeon
		case 2: return XGDemoStarterPokemon(index: 1) // demo jolteon
		case 3: return CMGiftPokemon(index: 0) // duking's plusle
		case 4: return CMGiftPokemon(index: 1) // mt battle ho-oh
		case 5: return CMGiftPokemon(index: 3) // colosseum pikachu
		case 6: return CMGiftPokemon(index: 2) // agate celebi
		case 7: return XGTradeShadowPokemon() // shadow togepi
		case 8: return XGTradePokemon(index: 0) // hordel's elekid (zapron)
		case 9: return XGTradePokemon(index: 1) // duking's meditite
		case 10: return XGTradePokemon(index: 2) // duking's shuckle
		case 11: return XGTradePokemon(index: 3) // duking's larvitar
		case 12: return XGMtBattlePrizePokemon(index: 0) // mt battle chikorita
		case 13: return XGMtBattlePrizePokemon(index: 1) // mt battle cyndaquil
		case 14: return XGMtBattlePrizePokemon(index: 2) // mt battle totodile
			
		default: return XGStarterPokemon()
		}
	}
	
	class func allGiftPokemon() -> [XGGiftPokemon] {
		var gifts = [XGGiftPokemon]()
		
		for i in 0 ... kNumberOfGiftPokemon {
			gifts.append(XGGiftPokemonManager.giftWithID(i))
		}
		
		return gifts
	}
}
