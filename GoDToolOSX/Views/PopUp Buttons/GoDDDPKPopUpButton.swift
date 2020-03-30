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
	
    func select(_ value: XGDeckPokemon) {
		self.selectItem(at: value.index)
	}
	
	override func setUpItems() {
		var values = [XGDeckPokemon]()
		for i in 0 ..< XGDecks.DeckDarkPokemon.DDPKEntries {
			values.append(XGDeckPokemon.ddpk(i))
		}
		let titles = values.map { (mon) -> String in
			return  mon.pokemon.name.string + " (shadow) - \(mon.index)"
		}
		
		self.setTitles(values: titles)
	}
	
}
