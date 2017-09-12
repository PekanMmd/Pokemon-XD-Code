//
//  XGDeckViewController.swift
//  XG Tool
//
//  Created by StarsMmd on 13/07/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import UIKit

class XGDeckViewController: XGTableViewController, UISearchResultsUpdating, UISearchBarDelegate {
	
	var deck = XGDecks.DeckSample
	
	var trainer = XGTrainer(index: 0, deck: .DeckSample) {
		didSet {
			self.setPokemon(1)
		}
	}
	
	var currentRow = 0
	var currentMon = 0
	
	var trainerClass = XGTextField()
	var trainerFace	 = XGTextField()
	var trainerName  = XGTextField()
	
	var trainerPreText  = XGTextField()
	var trainerWinText  = XGTextField()
	var trainerLossText = XGTextField()
	
	var payout = XGValueTextField()
	
	var p1 = XGButton()
	var p2 = XGButton()
	var p3 = XGButton()
	var p4 = XGButton()
	var p5 = XGButton()
	var p6 = XGButton()
	
	// Pokemon
	
	var pokemonData = XGTrainerPokemon(DeckData: XGDeckPokemon.dpkm(0, .DeckSample))
	var currentPokemonIndex = 0
	
	var name	= XGPopoverButton()
	var species	= XGPopoverButton()
	var nature  = XGPopoverButton()
	var item	= XGPopoverButton()
	var ability = XGButton()
	var gender  = XGButton()
	var level	= XGValueTextField()
	var move1	= XGPopoverButton()
	var move2	= XGPopoverButton()
	var move3	= XGPopoverButton()
	var move4	= XGPopoverButton()
	var happy	= XGValueTextField()
	var priority = XGValueTextField()
	var ivs		= XGValueTextField()
	var hp		= XGValueTextField()
	var attack	= XGValueTextField()
	var defense	= XGValueTextField()
	var spatk	= XGValueTextField()
	var spdef	= XGValueTextField()
	var speed	= XGValueTextField()
	var shadow1 = XGPopoverButton()
	var shadow2	= XGPopoverButton()
	var shadow3 = XGPopoverButton()
	var shadow4	= XGPopoverButton()
	var catchRate	= XGValueTextField()
	var counter	= XGValueTextField()
	
	var shadowButton = XGPopoverButton()
	
	var purgeButton = XGButton()
	var saveButton = XGButton()
	
	let searchController = UISearchController(searchResultsController: nil)
	var filteredTrainers = [XGTrainer]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.title = self.deck.fileName
		filteredTrainers = deck.allTrainers
		
		searchController.searchResultsUpdater = self
		searchController.dimsBackgroundDuringPresentation = false
		definesPresentationContext = true
		self.table.tableHeaderView = searchController.searchBar
		searchController.searchBar.scopeButtonTitles = ["Name", "Location", "Shadow"]
		//searchController.hidesNavigationBarDuringPresentation = false
		searchController.searchBar.delegate = self
		
		self.showActivityView { (Bool) -> Void in
			self.table.reloadData()
			self.setUpUI()
			self.updateUI()
		}
	}
	
	func updateSearchResults(for searchController: UISearchController) {
		let searchBar = searchController.searchBar
		let text = searchBar.text!
		let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
		NSObject.cancelPreviousPerformRequests(withTarget: self)
		self.perform(#selector(filterContentForSearchText), with: [text, scope], afterDelay: 1.0)
	}
	
	func filterContentForSearchText(textAndScope: [String]) {
		let searchText = textAndScope[0]
		let scope = textAndScope[1]
		if searchText.characters.count > 0 || scope == "Shadow" {
			filteredTrainers = deck.allTrainers.filter { trainer in
				let wantedInfo: String
				if scope == "Location" {
					wantedInfo = trainer.locationString
				} else {
					wantedInfo = trainer.trainerClass.name.string + trainer.name.string
				}
				
				let hasMatchingText = wantedInfo.simplified.contains(searchText.simplified)
				
				if scope == "Shadow" {
					if searchText.characters.count == 0 {
						return trainer.hasShadow
					} else {
						return trainer.hasShadow && hasMatchingText
					}
				}
				
				return hasMatchingText
			}
		} else {
			filteredTrainers = deck.allTrainers
		}
		
		self.table.reloadData()
	}
	
	func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
		filterContentForSearchText(textAndScope: [searchBar.text!, searchBar.scopeButtonTitles![selectedScope]])
	}
	
	// accommodating for cells scrolling up under search bar when it becomes active
	func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
		//self.table.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: true)
		//self.table.setContentOffset(CGPoint(x: 0, y: 0 - self.table.contentInset.top), animated: true)
		
		let searchBarHeight = searchController.searchBar.frame.height
		self.table.contentInset = UIEdgeInsetsMake(searchBarHeight + 20, 0, 0, 0)
		self.table.reloadData()
		
		//self.table.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
	}
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		self.table.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
		self.table.reloadData()
	}
	
	func setUpUI() {
		
		self.contentView.backgroundColor = UIColor.white
		let trainerView = UIView()
		trainerView.backgroundColor = UIColor.red
		self.addSubview(trainerView, name: "trBack")
		trainerView.translatesAutoresizingMaskIntoConstraints = false
		
		self.addConstraintAlignTopEdges(view1: trainerView, view2: self.contentView)
		self.addConstraintAlignLeftAndRightEdges(view1: trainerView, view2: self.contentView)
		self.addConstraintHeight(view: trainerView, height: 120)
		
		p1 = XGButton(title: "", colour: UIColor.clear, textColour: UIColor.clear, action: { self.setPokemon(1) })
		self.addSubview(p1, name: "p1")
		self.addConstraintSize(view: p1, height: 50, width: 50)
		
		p2 = XGButton(title: "", colour: UIColor.clear, textColour: UIColor.clear, action: { self.setPokemon(2) })
		self.addSubview(p2, name: "p2")
		self.addConstraintSize(view: p2, height: 50, width: 50)
		
		p3 = XGButton(title: "", colour: UIColor.clear, textColour: UIColor.clear, action: { self.setPokemon(3) })
		self.addSubview(p3, name: "p3")
		self.addConstraintSize(view: p3, height: 50, width: 50)
		
		p4 = XGButton(title: "", colour: UIColor.clear, textColour: UIColor.clear, action: { self.setPokemon(4) })
		self.addSubview(p4, name: "p4")
		self.addConstraintSize(view: p4, height: 50, width: 50)
		
		p5 = XGButton(title: "", colour: UIColor.clear, textColour: UIColor.clear, action: { self.setPokemon(5) })
		self.addSubview(p5, name: "p5")
		self.addConstraintSize(view: p5, height: 50, width: 50)
		
		p6 = XGButton(title: "", colour: UIColor.clear, textColour: UIColor.clear, action: { self.setPokemon(6) })
		self.addSubview(p6, name: "p6")
		self.addConstraintSize(view: p6, height: 50, width: 50)
		
		name	= XGPopoverButton(title: "", colour: UIColor.red, textColour: UIColor.black, popover: XGDeckPokemonPopover(deck: self.deck), viewController: self)
		self.addSubview(name, name: "name")
		self.addConstraintSize(view: name, height: 60, width: 150)
		
		species	= XGPopoverButton(title: "", colour: UIColor.clear, textColour: UIColor.clear, popover: XGPokemonPopover(), viewController: self)
		self.addSubview(species, name: "spec")
		self.addConstraintSize(view: species, height: 60, width: 60)
		
		nature  = XGPopoverButton(title: "", colour: UIColor.green, textColour: UIColor.black, popover: XGNaturePopover(), viewController: self)
		self.addSubview(nature, name: "nature")
		self.addConstraintSize(view: nature, height: 50, width: 80)
		
		item	= XGPopoverButton(title: "", colour: UIColor.yellow, textColour: UIColor.black, popover: XGItemPopover(), viewController: self)
		self.addSubview(item, name: "item")
		self.addConstraintSize(view: item, height: 50, width: 80)
		
		ability = XGButton(title: "", colour: UIColor.blue, textColour: UIColor.black, action: { self.pokemonData.ability = 1 - self.pokemonData.ability; self.updateUI() })
		self.addSubview(ability, name: "ability")
		self.addConstraintSize(view: ability, height: 50, width: 80)
		
		gender  = XGButton(title: "", colour: UIColor.purple, textColour: UIColor.black, action: { self.pokemonData.gender = self.pokemonData.gender.cycle(); self.updateUI() })
		self.addSubview(gender, name: "gender")
		self.addConstraintSize(view: gender, height: 50, width: 80)
		
		level	= XGValueTextField(title: "Level", value: 100, min: 1, max: 100, height: 30, width: 150, action: { self.pokemonData.level = self.level.value; self.updateUI() })
		level.field.backgroundColor = UIColor.orange
		level.field.textColor = UIColor.black
		self.addSubview(level, name: "level")
		
		let movePopover = XGMovePopover()
		move1	= XGPopoverButton(title: "", colour: UIColor.clear, textColour: UIColor.black, popover: movePopover, viewController: self)
		self.addSubview(move1, name: "m1")
		self.addConstraintSize(view: move1, height: 40, width: 100)
		
		move2	= XGPopoverButton(title: "", colour: UIColor.clear, textColour: UIColor.black, popover: movePopover, viewController: self)
		self.addSubview(move2, name: "m2")
		self.addConstraintSize(view: move2, height: 40, width: 100)
		
		move3	= XGPopoverButton(title: "", colour: UIColor.clear, textColour: UIColor.black, popover: movePopover, viewController: self)
		self.addSubview(move3, name: "m3")
		self.addConstraintSize(view: move3, height: 40, width: 100)
		
		move4	= XGPopoverButton(title: "", colour: UIColor.clear, textColour: UIColor.black, popover: movePopover, viewController: self)
		self.addSubview(move4, name: "m4")
		self.addConstraintSize(view: move4, height: 40, width: 100)
		
		happy = XGValueTextField(title: "Happiness", value: 0, min: 0, max: 0xFF, height: 20, width: 80, action: { self.pokemonData.happiness = self.happy.value; self.updateUI() })
		self.addSubview(happy, name: "happy")
		happy.field.backgroundColor = UIColor.orange
		happy.field.textColor = UIColor.black
		happy.title.textColor = UIColor.black
		
		priority = XGValueTextField(title: "Priority", value: 0, min: 0, max: 0xFF, height: 20, width: 80, action: { self.pokemonData.priority = self.priority.value; self.updateUI() })
		self.addSubview(priority, name: "priority")
		priority.field.backgroundColor = UIColor.orange
		priority.field.textColor = UIColor.black
		priority.title.textColor = UIColor.black
		
		ivs = XGValueTextField(title: "IVs", value: 0, min: 0, max: 31, height: 30, width: 60, action: { self.pokemonData.IVs = self.ivs.value; self.updateUI() })
		self.addSubview(ivs, name: "iv")
		ivs.field.backgroundColor = UIColor.orange
		ivs.field.textColor = UIColor.black
		ivs.title.textColor = UIColor.black
		
		hp = XGValueTextField(title: "HP EVs", value: 0, min: 0, max: 0xFF, height: 30, width: 60, action: { self.pokemonData.EVs[0] = self.hp.value; self.updateUI() })
		self.addSubview(hp, name: "hp")
		hp.field.backgroundColor = UIColor.yellow
		hp.field.textColor = UIColor.black
		hp.title.textColor = UIColor.black
		
		attack = XGValueTextField(title: "Attack EVs", value: 0, min: 0, max: 0xFF, height: 30, width: 60, action: { self.pokemonData.EVs[1] = self.attack.value; self.updateUI() })
		self.addSubview(attack, name: "atk")
		attack.field.backgroundColor = UIColor.yellow
		attack.field.textColor = UIColor.black
		attack.title.textColor = UIColor.black
		
		defense = XGValueTextField(title: "Defense EVs", value: 0, min: 0, max: 0xFF, height: 30, width: 60, action: { self.pokemonData.EVs[2] = self.defense.value; self.updateUI() })
		self.addSubview(defense, name: "def")
		defense.field.backgroundColor = UIColor.yellow
		defense.field.textColor = UIColor.black
		defense.title.textColor = UIColor.black
		
		spatk = XGValueTextField(title: "Sp.Atk EVs", value: 0, min: 0, max: 0xFF, height: 30, width: 60, action: { self.pokemonData.EVs[3] = self.spatk.value; self.updateUI() })
		self.addSubview(spatk, name: "spatk")
		spatk.field.backgroundColor = UIColor.yellow
		spatk.field.textColor = UIColor.black
		spatk.title.textColor = UIColor.black
		
		spdef = XGValueTextField(title: "Sp.Def EVs", value: 0, min: 0, max: 0xFF, height: 30, width: 60, action: { self.pokemonData.EVs[4] = self.spdef.value; self.updateUI() })
		self.addSubview(spdef, name: "spdef")
		spdef.field.backgroundColor = UIColor.yellow
		spdef.field.textColor = UIColor.black
		spdef.title.textColor = UIColor.black
		
		speed = XGValueTextField(title: "Speed EVs", value: 0, min: 0, max: 0xFF, height: 30, width: 60, action: { self.pokemonData.EVs[5] = self.speed.value; self.updateUI() })
		self.addSubview(speed, name: "speed")
		speed.field.backgroundColor = UIColor.yellow
		speed.field.textColor = UIColor.black
		speed.title.textColor = UIColor.black
		
		shadow1 = XGPopoverButton(title: "", colour: UIColor.clear, textColour: UIColor.white, popover: movePopover, viewController: self)
		shadow1.setBackgroundImage(XGFiles.nameAndFolder("type_shadow.png", .Types).image, for: UIControlState())
		self.addSubview(shadow1, name: "s1")
		self.addConstraintSize(view: shadow1, height: 40, width: 100)
		
		shadow2 = XGPopoverButton(title: "", colour: UIColor.clear, textColour: UIColor.white, popover: movePopover, viewController: self)
		shadow2.setBackgroundImage(XGFiles.nameAndFolder("type_shadow.png", .Types).image, for: UIControlState())
		self.addSubview(shadow2, name: "s2")
		self.addConstraintSize(view: shadow2, height: 40, width: 100)
		
		shadow3 = XGPopoverButton(title: "", colour: UIColor.clear, textColour: UIColor.white, popover: movePopover, viewController: self)
		shadow3.setBackgroundImage(XGFiles.nameAndFolder("type_shadow.png", .Types).image, for: UIControlState())
		self.addSubview(shadow3, name: "s3")
		self.addConstraintSize(view: shadow3, height: 40, width: 100)
		
		shadow4 = XGPopoverButton(title: "", colour: UIColor.clear, textColour: UIColor.white, popover: movePopover, viewController: self)
		shadow4.setBackgroundImage(XGFiles.nameAndFolder("type_shadow.png", .Types).image, for: UIControlState())
		self.addSubview(shadow4, name: "s4")
		self.addConstraintSize(view: shadow4, height: 40, width: 100)
		
		catchRate = XGValueTextField(title: "Catch Rate", value: 0xFF, min: 0, max: 0xFF, height: 30, width: 100, action: { self.pokemonData.shadowCatchRate	= self.catchRate.value; self.updateUI() })
		self.addSubview(catchRate, name: "catch")
		catchRate.field.backgroundColor = UIColor.purple
		catchRate.field.textColor = UIColor.black
		catchRate.title.textColor = UIColor.black
		
		counter = XGValueTextField(title: "Purification Counter", value: 0, min: 0, max: 0xFFFF, height: 30, width: 100, action: { self.pokemonData.shadowCounter = self.counter.value; self.updateUI() })
		self.addSubview(counter, name: "count")
		counter.field.backgroundColor = UIColor.purple
		counter.field.textColor = UIColor.black
		counter.title.textColor = UIColor.black
		
		shadowButton = XGPopoverButton(title: "Shadow Pokemon", colour: UIColor.purple, textColour: UIColor.black, popover: XGDDPKPopover(), viewController: self)
		self.addSubview(shadowButton, name: "shadow")
		self.addConstraintSize(view: shadowButton, height: 60, width: 150)
		
		
		purgeButton = XGButton(title: "Purge", colour: UIColor.red, textColour: UIColor.white, action: { self.pokemonData.purge(); self.updateUI() })
		self.addSubview(purgeButton, name: "purge")
		self.addConstraintSize(view: purgeButton, height: 30, width: 100)
		
		saveButton = XGButton(title: "Save", colour: UIColor.blue, textColour: UIColor.white, action: { self.save() })
		self.addSubview(saveButton, name: "save")
		self.addConstraintSize(view: saveButton, height: 30, width: 200)
		
		
		self.createDummyViewsEqualWidths(7, baseName: "a")
		self.createDummyViewsEqualWidths(4, baseName: "b")
		self.createDummyViewsEqualWidths(2, baseName: "c")
		self.createDummyViewsEqualWidths(7, baseName: "d")
		self.createDummyViewsEqualWidths(5, baseName: "e")
		self.createDummyViewsEqualWidths(8, baseName: "f")
		self.createDummyViewsEqualWidths(5, baseName: "g")
		self.createDummyViewsEqualWidths(3, baseName: "h")
		self.createDummyViewsEqualWidths(2, baseName: "i")
		
		self.createDummyViewsEqualHeights(9, baseName: "v")
		
		self.addConstraints(visualFormat: "H:|[a1][p1][a2][p2][a3][p3][a4][p4][a5][p5][a6][p6][a7]|", layoutFormat: [.alignAllTop, .alignAllBottom])
		self.addConstraints(visualFormat: "H:|[b1][name][b2][level][b3][shadow][b4]|", layoutFormat: [.alignAllTop, .alignAllBottom])
		self.addConstraints(visualFormat: "H:|[c1][spec][c2]|", layoutFormat: [.alignAllTop, .alignAllBottom])
		self.addConstraints(visualFormat: "H:|[d1][item][d2][nature][d3][ability][d4][gender][d5][happy][d6][priority][d7]|", layoutFormat: .alignAllCenterY)
		self.addConstraints(visualFormat: "H:|[e1][m1][e2][m2][e3][m3][e4][m4][e5]|", layoutFormat: [.alignAllTop, .alignAllBottom])
		self.addConstraints(visualFormat: "H:|[f1][iv][f2][hp][f3][atk][f4][def][f5][spatk][f6][spdef][f7][speed][f8]|", layoutFormat: [.alignAllTop, .alignAllBottom])
		self.addConstraints(visualFormat: "H:|[g1][s1][g2][s2][g3][s3][g4][s4][g5]|", layoutFormat: [.alignAllTop, .alignAllBottom])
		self.addConstraints(visualFormat: "H:|[h1][catch][h2][count][h3]|", layoutFormat: [.alignAllTop, .alignAllBottom])
		self.addConstraints(visualFormat: "H:[save][i1][purge][i2]|", layoutFormat: [.alignAllTop, .alignAllBottom])
		
		self.addConstraints(visualFormat: "V:[trBack]-(5)-[a4][v1][level][v2][def][v3][d4(50)][v4][spec][v5][e3][v6][g3][v7][h2][v8][save][v9]|", layoutFormat: .alignAllCenterX)
		
	}
	
	func updateUI() {
		
		self.showActivityView { (Bool) -> Void in
			
			self.p1.setBackgroundImage(self.trainer.pokemon[0].pokemon.face , for: UIControlState())
			self.p2.setBackgroundImage(self.trainer.pokemon[1].pokemon.face , for: UIControlState())
			self.p3.setBackgroundImage(self.trainer.pokemon[2].pokemon.face , for: UIControlState())
			self.p4.setBackgroundImage(self.trainer.pokemon[3].pokemon.face , for: UIControlState())
			self.p5.setBackgroundImage(self.trainer.pokemon[4].pokemon.face , for: UIControlState())
			self.p6.setBackgroundImage(self.trainer.pokemon[5].pokemon.face , for: UIControlState())
			
			let pd = self.pokemonData
			
			self.name.textLabel.text = pd.species.name.string
			self.species.setBackgroundImage(pd.species.body, for: UIControlState())
			self.nature.textLabel.text = pd.nature.string
			self.item.textLabel.text = pd.item.name.string
			self.ability.textLabel.text = pd.ability == 0 ? pd.species.ability1 : pd.species.ability2
			self.gender.textLabel.text = pd.gender.string
			self.level.value = pd.level
			self.happy.value = pd.happiness
			self.priority.value = pd.priority
			self.ivs.value = pd.IVs
			self.hp.value = pd.EVs[0]
			self.attack.value = pd.EVs[1]
			self.defense.value = pd.EVs[2]
			self.spatk.value = pd.EVs[3]
			self.spdef.value = pd.EVs[4]
			self.speed.value = pd.EVs[5]
			self.move1.textLabel.text = pd.moves[0].name.string
			self.move1.setBackgroundImage( XGFiles.typeImage(pd.moves[0].type.rawValue).image , for: UIControlState())
			self.move2.textLabel.text = pd.moves[1].name.string
			self.move2.setBackgroundImage( XGFiles.typeImage(pd.moves[1].type.rawValue).image , for: UIControlState())
			self.move3.textLabel.text = pd.moves[2].name.string
			self.move3.setBackgroundImage( XGFiles.typeImage(pd.moves[2].type.rawValue).image , for: UIControlState())
			self.move4.textLabel.text = pd.moves[3].name.string
			self.move4.setBackgroundImage( XGFiles.typeImage(pd.moves[3].type.rawValue).image , for: UIControlState())
			
			self.shadow1.textLabel.text = pd.shadowMoves[0].name.string
			self.shadow2.textLabel.text = pd.shadowMoves[1].name.string
			self.shadow3.textLabel.text = pd.shadowMoves[2].name.string
			self.shadow4.textLabel.text = pd.shadowMoves[3].name.string
			
			self.catchRate.value   = pd.shadowCatchRate
			self.counter.value = pd.shadowCounter
			
			self.shadow1.isUserInteractionEnabled = pd.isShadowPokemon
			self.shadow2.isUserInteractionEnabled = pd.isShadowPokemon
			self.shadow3.isUserInteractionEnabled = pd.isShadowPokemon
			self.shadow4.isUserInteractionEnabled = pd.isShadowPokemon
			self.catchRate.isUserInteractionEnabled	= pd.isShadowPokemon
			self.counter.isUserInteractionEnabled	= pd.isShadowPokemon
			
			self.p1.layer.shadowColor = self.trainer.pokemon[0].isShadow ? UIColor.purple.cgColor : UIColor.black.cgColor
			self.p2.layer.shadowColor = self.trainer.pokemon[1].isShadow ? UIColor.purple.cgColor : UIColor.black.cgColor
			self.p3.layer.shadowColor = self.trainer.pokemon[2].isShadow ? UIColor.purple.cgColor : UIColor.black.cgColor
			self.p4.layer.shadowColor = self.trainer.pokemon[3].isShadow ? UIColor.purple.cgColor : UIColor.black.cgColor
			self.p5.layer.shadowColor = self.trainer.pokemon[4].isShadow ? UIColor.purple.cgColor : UIColor.black.cgColor
			self.p6.layer.shadowColor = self.trainer.pokemon[5].isShadow ? UIColor.purple.cgColor : UIColor.black.cgColor
			
			self.species.layer.shadowColor = self.pokemonData.isShadowPokemon ? UIColor.purple.cgColor : UIColor.black.cgColor
			
			self.hideActivityView()
		}
	}
	
	func setPokemon(_ index: Int) {
		self.pokemonData = XGTrainerPokemon(DeckData: self.trainer.pokemon[index - 1])
		self.currentPokemonIndex = index - 1
		self.updateUI()
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! XGTableViewCell!
		if cell == nil {
			cell = XGTableViewCell(style: .subtitle, reuseIdentifier: "cell")
		}
		
		let trainer: XGTrainer
		if searchController.isActive {
			trainer = filteredTrainers[indexPath.row]
		} else {
			trainer = XGTrainer(index: indexPath.row, deck: self.deck)
		}
		
		let name = trainer.trainerClass.name
		if name.length > 1 {
			switch name.chars[0] {
			case .special(_, _) : name.chars[0...1] = [name.chars[1]]
			default: break
			}
		}
		
		cell?.title = "\(trainer.index): \(name) \(trainer.name)"
		
		cell?.subtitle = trainer.locationString
		
		cell?.picture = trainer.trainerModel.image
		cell?.background = UIImage(named: "Item Cell")!
		
		cell?.textLabel?.textColor = UIColor.blue
		
		if trainer.hasShadow {
			cell?.background = XGFiles.nameAndFolder("type_shadow.png", .Types).image
		}
		
		return cell!
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.currentIndexPath = indexPath
		if searchController.isActive {
			self.trainer = filteredTrainers[indexPath.row]
		} else {
			self.trainer = XGTrainer(index: indexPath.row, deck: self.deck)
		}
		
		self.currentRow = indexPath.row
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if searchController.isActive {
			return filteredTrainers.count
		}
		return deck.DTNREntries
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 75
	}
	
	override func popoverDidDismiss() {
		if popoverPresenter == name {
			
			self.trainer.pokemon[currentPokemonIndex] = selectedItem as! XGDeckPokemon
			self.setPokemon(currentPokemonIndex + 1)
			
		} else if popoverPresenter == species {
			
			let spec = selectedItem as! XGPokemon
			
			self.pokemonData.species = spec
			let moves = spec.movesForLevel(self.pokemonData.level)
			self.pokemonData.moves = moves
			
			let pd = self.pokemonData
			if pd.isShadowPokemon {
				let cr = pd.species.catchRate
				
				self.pokemonData.shadowCatchRate = cr
			}
			
		} else if popoverPresenter == move1 {
			self.pokemonData.moves[0] = selectedItem as! XGMoves
		} else if popoverPresenter == move2 {
			self.pokemonData.moves[1] = selectedItem as! XGMoves
		} else if popoverPresenter == move3 {
			self.pokemonData.moves[2] = selectedItem as! XGMoves
		} else if popoverPresenter == move4 {
			self.pokemonData.moves[3] = selectedItem as! XGMoves
		} else if popoverPresenter == item {
			self.pokemonData.item = selectedItem as! XGItems
		} else if popoverPresenter == nature {
			self.pokemonData.nature = selectedItem as! XGNatures
		} else if popoverPresenter == shadow1 {
			self.pokemonData.shadowMoves[0] = selectedItem as! XGMoves
		} else if popoverPresenter == shadow2 {
			self.pokemonData.shadowMoves[1] = selectedItem as! XGMoves
		} else if popoverPresenter == shadow3 {
			self.pokemonData.shadowMoves[2] = selectedItem as! XGMoves
		} else if popoverPresenter == shadow4 {
			self.pokemonData.shadowMoves[3] = selectedItem as! XGMoves
		} else if popoverPresenter == self.shadowButton {
			
			self.trainer.pokemon[currentPokemonIndex] = selectedItem as! XGDeckPokemon
			self.setPokemon(currentPokemonIndex + 1)
			
		}
		
		self.popoverPresenter.popover.dismiss(animated: true)
		self.updateUI()
	}
	
	func save() {
		
		self.showActivityView { (Bool) -> Void in
			
			self.trainer.save()
			self.pokemonData.save()
			
			self.table.reloadRows(at: [self.currentIndexPath], with: .fade)
			self.table.selectRow(at: self.currentIndexPath, animated: false, scrollPosition: .none)
			
			self.hideActivityView()
			
			self.updateUI()
			
		}
	}
	
}

















