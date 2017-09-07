//
//  GoDPokemonPopUpButton.swift
//  GoD Tool
//
//  Created by The Steez on 06/09/2017.
//
//

import Cocoa

let pokemonFiltered = XGPokemon.allPokemon().filter { (p) -> Bool in
	return p.stats.nameID > 0 || p.index == 0
}

class GoDPokemonPopUpButton: GoDPopUpButton {
	
	var selectedValue : XGPokemon {
		return pokemonFiltered[self.indexOfSelectedItem]
	}
	
	override func setUpItems() {
		let values = pokemonFiltered.map { (p) -> String in
			return p.name.string
		}
		
		self.addItems(withTitles: values)
	}
	
}
