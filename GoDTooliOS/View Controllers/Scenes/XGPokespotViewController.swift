//
//  XGPokespotViewController.swift
//  XG Tool
//
//  Created by The Steez on 01/08/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//

import UIKit

class XGPokespotViewController: XGTableViewController {

	var currentPokemon = XGPokeSpotPokemon(index: 0, pokespot: .rock)
	
	var species				= XGPopoverButton()
	var minLevel			= XGValueTextField()
	var maxLevel			= XGValueTextField()
	var encounter			= XGValueTextField()
	var steps				= XGValueTextField()
	
	var saveButton			= XGButton()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.setUpUI()
		self.updateUI()
		
		// Do any additional setup after loading the view.
	}
	
	func setUpUI() {
		self.showActivityView { (Bool) -> Void in
			
			self.species = XGPopoverButton(title: "", colour: UIColor.red, textColour: UIColor.black, popover: XGPokemonPopover(), viewController: self)
			self.addSubview(self.species, name: "spec")
			self.addConstraintSize(view: self.species, height: 60, width: 200)
			
			self.minLevel = XGValueTextField(title: "Minimum Level", value: 1, min: 1, max: 100, height: 50, width: 200, action: { self.currentPokemon.minLevel = self.minLevel.value; self.updateUI() })
			self.addSubview(self.minLevel, name: "min")
			
			self.maxLevel = XGValueTextField(title: "Maximum Level", value: 1, min: 1, max: 100, height: 50, width: 200, action: { self.currentPokemon.maxLevel = self.maxLevel.value; self.updateUI() })
			self.addSubview(self.maxLevel, name: "max")
			
			self.encounter = XGValueTextField(title: "Encounter percentage", value: 1, min: 1, max: 100, height: 50, width: 200, action: { self.currentPokemon.encounterPercentage = self.encounter.value; self.updateUI() })
			self.addSubview(self.encounter, name: "enc")
			
			self.steps = XGValueTextField(title: "Steps per PokeSnack", value: 1, min: 1, max: 1000, height: 50, width: 200, action: { self.currentPokemon.stepsPerSnack = self.steps.value; self.updateUI() })
			self.addSubview(self.steps, name: "steps")
			
			self.saveButton = XGButton(title: "Save", colour: UIColor.blue, textColour: UIColor.black, action: { self.save() })
			self.addSubview(self.saveButton, name: "save")
			self.addConstraintSize(view: self.saveButton, height: 60, width: 200)
			
			self.createDummyViewsEqualWidths(3, baseName: "a")
			self.createDummyViewsEqualWidths(3, baseName: "b")
			
			self.createDummyViewsEqualHeights(5, baseName: "v")
			
			self.addConstraintAlignCenterX(view1: self.species, view2: self.contentView)
			self.addConstraintAlignCenterX(view1: self.saveButton, view2: self.contentView)
			
			self.addConstraints(visualFormat: "H:|[a1][min][a2][max][a3]|", layoutFormat: [.alignAllTop, .alignAllBottom])
			self.addConstraints(visualFormat: "H:|[b1][enc][b2][steps][b3]|", layoutFormat: [.alignAllTop, .alignAllBottom])
			self.addConstraints(visualFormat: "V:|[v1][spec][v2][a2][v3][b2][v4][save][v5]|", layoutFormat: .alignAllCenterX)
			
			self.hideActivityView()
		}
	}
	
	func updateUI() {
		self.showActivityView { (Bool) -> Void in
			
			self.species.textLabel.text = self.currentPokemon.pokemon.name.string
			self.minLevel.value = self.currentPokemon.minLevel
			self.maxLevel.value = self.currentPokemon.maxLevel
			self.encounter.value = self.currentPokemon.encounterPercentage
			self.steps.value = self.currentPokemon.stepsPerSnack
			
			self.hideActivityView()
		}
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell = table.dequeueReusableCell(withIdentifier: "cell") as! XGTableViewCell!
		if cell == nil {
			cell = XGTableViewCell(style: .subtitle, reuseIdentifier: "cell")
		}
		
		
		let spotmon = monForIndex(index: indexPath.row)
		let poke = spotmon.pokemon
		
		cell?.picture = poke.face
		cell?.title = poke.name.string
		cell?.subtitle = spotmon.spot.string
		
		let type = poke.type1
		cell?.background = type.image
		
		if type == XGMoveTypes.dark {
			cell?.textLabel?.textColor = UIColor.white
			cell?.detailTextLabel?.textColor = UIColor.white
		} else {
			cell?.textLabel?.textColor = UIColor.black
			cell?.detailTextLabel?.textColor = UIColor.black
		}
		
		return cell!
	}
	
	func monForIndex(index: Int) -> XGPokeSpotPokemon {
		
		let numberOfMonsPerSpot = XGPokeSpots.rock.numberOfEntries()
		
		let spot = index / numberOfMonsPerSpot
		let index = index % numberOfMonsPerSpot
		
		return XGPokeSpotPokemon(index: index, pokespot:XGPokeSpots(rawValue: spot)!)
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.currentIndexPath = indexPath
		self.currentPokemon = monForIndex(index: indexPath.row)
		self.updateUI()
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 100
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return XGPokeSpots.rock.numberOfEntries() * 3 + 2
	}
	
	override func popoverDidDismiss() {
		
		if popoverPresenter == self.species {
			self.currentPokemon.pokemon = selectedItem as! XGPokemon
		}
		
		self.popoverPresenter.popover.dismiss(animated: true)
		self.updateUI()
	}
	
	func save() {
		
		self.showActivityView { (Bool) -> Void in
			
			self.currentPokemon.save()
			
			self.table.reloadRows(at: [self.currentIndexPath], with: .fade)
			self.table.selectRow(at: self.currentIndexPath, animated: false, scrollPosition: .none)
			
			self.hideActivityView()
		}
	}

}
















