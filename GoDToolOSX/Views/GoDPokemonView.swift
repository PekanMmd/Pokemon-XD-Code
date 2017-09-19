//
//  GoDPokemonView.swift
//  GoD Tool
//
//  Created by The Steez on 18/09/2017.
//
//

import Cocoa

class GoDPokemonView: NSImageView {
	
	var index = 0

	var delegate : GoDTrainerViewController! {
		didSet {
			setUp()
		}
	}
	
	func setUp() {
		let pokemon = self.delegate.currentTrainer.pokemon[self.index].data
		let stats = pokemon.species.stats
		
//		self.setBackgroundColour(pokemon.isShadowPokemon ? GoDDesign.colourPurple() : GoDDesign.colourRed())
		if !pokemon.isSet {
			self.setBackgroundColour(GoDDesign.colourGrey())
		} else if pokemon.isShadowPokemon {
			self.setBackgroundColour(GoDDesign.colourPurple())
		} else {
			self.setBackgroundColour(GoDDesign.colourLightGrey())
		}
		
	}
	
	init() {
		super.init(frame: .zero)
		self.translatesAutoresizingMaskIntoConstraints = false
		self.wantsLayer = true
		self.layer?.cornerRadius = 12
		self.layer?.borderColor = GoDDesign.colourBlack().cgColor
		self.layer?.borderWidth = 1
		self.imageScaling = .scaleAxesIndependently
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
}















