//
//  main.swift
//  Revolution Tool
//
//  Created by The Steez on 24/12/2018.
//

import Foundation


for i in [15] {
	let deck = XGDecks.dckp(i)

	let indices = 0 ..< deck.numberOfEntries
	let mons = indices.map { (index) -> XGTrainerPokemon  in
		return XGDeckPokemon.deck(index, deck).data
	}

	for mon in mons.sorted(by: { (p1, p2) -> Bool in
		p1.species.index < p2.species.index
	})
//	for mon in mons
	{
		mon.species.formeName.println()
		mon.ability.name.unformattedString.println()
		for move in mon.moves {
			move.name.unformattedString.println()
		}
		for item in mon.items {
			item.name.unformattedString.println()
		}

		"".println()
	}

}




