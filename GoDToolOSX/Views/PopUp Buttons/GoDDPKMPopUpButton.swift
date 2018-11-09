//
//  GoDDPKMPopUpButton.swift
//  GoD Tool
//
//  Created by The Steez on 20/09/2017.
//
//

import Cocoa

class GoDDPKMPopUpButton: GoDPopUpButton {

	var deck : XGDecks = .DeckSample {
		didSet {
			self.setUpItems()
		}
	}
	
	var selectedValue : XGDeckPokemon {
		return XGDeckPokemon.dpkm(self.indexOfSelectedItem, deck)
	}
	
	func selectPokemon(pokemon: XGDeckPokemon) {
		self.selectItem(at: pokemon.DPKMIndex)
	}
	
	override func setUpItems() {
		var values = [XGDeckPokemon]()
		for i in 0 ..< deck.DPKMEntries {
			values.append(XGDeckPokemon.dpkm(i, deck))
		}
		let titles = values.map { (mon) -> String in
			let free = mon.isSet || mon.DPKMIndex == 0 ? "" : "(unused) "
			return free + "\(mon.DPKMIndex) Lv." + "\(mon.level) " + mon.pokemon.name.string
		}
		
		self.setTitles(values: titles)
	}
	
}




