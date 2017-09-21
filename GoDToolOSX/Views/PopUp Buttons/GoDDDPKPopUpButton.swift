//
//  GoDDDPKPopUpButton.swift
//  GoD Tool
//
//  Created by The Steez on 20/09/2017.
//
//

import Cocoa

class GoDDDPKPopUpButton: GoDPopUpButton {

	var selectedValue : XGDeckPokemon {
		return XGDeckPokemon.ddpk(self.indexOfSelectedItem)
	}
	
	func selectPokemon(pokemon: XGDeckPokemon) {
		self.selectItem(at: pokemon.index)
	}
	
	override func setUpItems() {
		var values = [XGDeckPokemon]()
		for i in 0 ..< XGDecks.DeckDarkPokemon.DDPKEntries {
			values.append(XGDeckPokemon.ddpk(i))
		}
		let titles = values.map { (mon) -> String in
			return "(\(mon.index)) Shadow " + mon.pokemon.name.string
		}
		
		self.setTitles(values: titles)
	}
	
}
