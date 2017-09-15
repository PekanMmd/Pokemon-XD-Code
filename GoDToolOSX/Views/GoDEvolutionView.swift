//
//  GoDEvolutionView.swift
//  GoD Tool
//
//  Created by StarsMmd on 09/09/2017.
//
//

import Cocoa

class GoDEvolutionView: NSView {
	
	var index = 0

    var pokemonPopUp = GoDPokemonPopUpButton()
	var methodPopUp = GoDEvolutionMethodPopUpButton()
	var coniditionPopUp = GoDEvolutionConditionPopUpButton()
	
	var delegate : GoDStatsViewController! {
		didSet {
			self.reloadData()
		}
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		
		self.pokemonPopUp.target = self
		self.pokemonPopUp.action = #selector(setPokemon)
		self.methodPopUp.target = self
		self.methodPopUp.action = #selector(setMethod)
		self.coniditionPopUp.target = self
		self.coniditionPopUp.action = #selector(setCondition)
		
		let viewsArray : [GoDPopUpButton] = [pokemonPopUp,methodPopUp,coniditionPopUp]
		let viewsDict : [String : NSView] = ["p" : pokemonPopUp, "m" : methodPopUp, "c" : coniditionPopUp]
		for view in viewsArray  {
			view.font = GoDDesign.fontOfSize(8)
			view.translatesAutoresizingMaskIntoConstraints = false
			self.addSubview(view)
			self.addConstraintEqualHeights(view1: self, view2: view)
			self.addConstraintAlignCenterY(view1: self, view2: view)
		}
		self.addConstraints(visualFormat: "|[p]-(2)-[m]-(2)-[c]|", layoutFormat: [], metrics: nil, views: viewsDict)
		self.addConstraintEqualWidths(view1: methodPopUp, view2: coniditionPopUp)
		self.addConstraint(NSLayoutConstraint(item: pokemonPopUp, attribute: .width, relatedBy: .equal, toItem: methodPopUp, attribute: .width, multiplier: 1.5, constant: 0))
		
	}
	
	func setPokemon() {
		if delegate != nil {
			delegate.pokemon.evolutions[self.index].evolvesInto = self.pokemonPopUp.selectedValue.index
			self.reloadData()
		}
	}
	
	func setMethod() {
		if delegate != nil {
			delegate.pokemon.evolutions[self.index].evolutionMethod = self.methodPopUp.selectedValue
			self.coniditionPopUp.method = delegate.pokemon.evolutions[self.index].evolutionMethod
			self.coniditionPopUp.selectCondition(condition: 0)
			self.setCondition()
		}
	}
	
	func setCondition() {
		if delegate != nil {
			delegate.pokemon.evolutions[self.index].condition = self.coniditionPopUp.selectedValue
			self.reloadData()
		}
	}
	
	func reloadData() {
		if delegate != nil {
			let evolution = self.delegate.pokemon.evolutions[self.index]
			let evolvesInto = XGPokemon.pokemon(evolution.evolvesInto)
			let method = evolution.evolutionMethod
			self.pokemonPopUp.selectPokemon(pokemon: evolvesInto)
			self.methodPopUp.selectEvolutionMethod(method: method)
			self.coniditionPopUp.method = method
			self.coniditionPopUp.selectCondition(condition: evolution.condition)
			
		}
		
	}
    
}






