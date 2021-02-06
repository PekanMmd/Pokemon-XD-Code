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
		
		pokemonPopUp.target = self
		pokemonPopUp.action = #selector(setPokemon)
		methodPopUp.target = self
		methodPopUp.action = #selector(setMethod)
		coniditionPopUp.target = self
		coniditionPopUp.action = #selector(setCondition)
		
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
	
	@objc func setPokemon() {
		if delegate != nil {
			delegate.pokemon.evolutions[self.index].evolvesInto = self.pokemonPopUp.selectedValue.index
			reloadData()
		}
	}
	
	@objc func setMethod() {
		if delegate != nil {
			delegate.pokemon.evolutions[index].evolutionMethod = methodPopUp.selectedValue
			coniditionPopUp.method = delegate.pokemon.evolutions[index].evolutionMethod
			coniditionPopUp.selectCondition(condition: 0)
			setCondition()
		}
	}
	
	@objc func setCondition() {
		if delegate != nil {
			delegate.pokemon.evolutions[index].condition = coniditionPopUp.selectedValue
			reloadData()
		}
	}
	
	func reloadData() {
		if delegate != nil {
			let evolution = delegate.pokemon.evolutions[index]
			let evolvesInto = XGPokemon.index(evolution.evolvesInto)
			let method = evolution.evolutionMethod
			pokemonPopUp.select(evolvesInto)
			methodPopUp.select(method)
			coniditionPopUp.method = method
			coniditionPopUp.selectCondition(condition: evolution.condition)
		}
	}
}






