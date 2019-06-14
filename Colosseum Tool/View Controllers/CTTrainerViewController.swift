//
//  CTTrainerViewController.swift
//  Colosseum Tool
//
//  Created by The Steez on 07/06/2018.
//

import Cocoa

class GoDTrainerViewController: GoDTableViewController {
	
	var currentTrainer = XGTrainer(index: 0) {
		didSet {
			self.pokemon = currentTrainer.pokemon
		}
	}
	
	var pokemon = [XGTrainerPokemon]()
	
	var trainers = [TrainerInfo]()
	
	
	var pokemonViews = [GoDPokemonView]()
	let pokemonContainer = NSView()
	let trainerView = GoDTrainerView()
	
	var saveButton : GoDButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.title = "Trainer Editor"
		
		self.pokemon = currentTrainer.pokemon
		
		trainers = XGDecks.DeckStory.allTrainers.map { (trainer) -> TrainerInfo in
				return trainer.trainerInfo
		}
		
		self.table.reloadData()
		self.table.tableView.intercellSpacing = NSSize(width: 0, height: 1)
		
		for i in 0 ... 5 {
			let mon = GoDPokemonView()
			mon.index = i
			mon.delegate = self
			self.pokemonViews.append(mon)
		}
		
		self.trainerView.delegate = self
		
		self.pokemonContainer.setBackgroundColour(GoDDesign.colourWhite())
		self.pokemonContainer.translatesAutoresizingMaskIntoConstraints = false
		self.pokemonContainer.wantsLayer = true
		self.pokemonContainer.layer?.borderColor = GoDDesign.colourBlack().cgColor
		self.pokemonContainer.layer?.borderWidth = 1
		
		self.saveButton = GoDButton(title: "Save", buttonType: NSButton.ButtonType.momentaryPushIn, target: self, action: #selector(save))
		
		self.saveButton.keyEquivalent = "⌘S"
		
		self.layoutViews()
	}
	
	func layoutViews() {
		self.addSubview(trainerView, name: "tv")
		self.addSubview(pokemonContainer, name: "cv")
		self.addSubview(saveButton, name: "sb")
		
		for view in self.pokemonViews {
			self.pokemonContainer.addSubview(view)
			self.views["pv\(view.index)"] = view
		}
		
		self.addConstraintWidth(view: pokemonViews[0], width: 330)
		for i in 1 ... 5 {
			self.addConstraintEqualSizes(view1: pokemonViews[0], view2: pokemonViews[i])
		}
		
		self.addConstraints(visualFormat: "H:|[table][tv]|", layoutFormat: [])
		self.addConstraintHeight(view: trainerView, height: 80)
		self.addConstraints(visualFormat: "V:|[tv][cv]|", layoutFormat: [.alignAllLeft, .alignAllRight])
		self.addMetric(value: 10, name: "g")
		self.pokemonContainer.addConstraints(visualFormat: "H:|-(g)-[pv0]-(g)-[pv1]-(g)-[pv2]-(g)-|", layoutFormat: [.alignAllTop, .alignAllBottom], metrics: metrics, views: views)
		self.pokemonContainer.addConstraints(visualFormat: "H:|-(g)-[pv3]-(g)-[pv4]-(g)-[pv5]-(g)-|", layoutFormat: [.alignAllTop, .alignAllBottom], metrics: metrics, views: views)
		self.pokemonContainer.addConstraints(visualFormat: "V:|-(g)-[pv0]-(g)-[pv3]-(40)-|", layoutFormat: [.alignAllLeft], metrics: metrics, views: views)
		self.addConstraints(visualFormat: "V:[pv4]-(g)-[sb(20)]", layoutFormat: [.alignAllCenterX])
		self.addConstraintWidth(view: saveButton, width: 100)
		
	}
	
	@objc func save() {
		self.showActivityView {
			self.trainerView.save()
			for view in self.pokemonViews {
				view.prepareForSave()
			}
			for mon in self.pokemon {
				mon.save()
			}
			self.hideActivityView()
		}
	}
	
	override func widthForTable() -> NSNumber {
		return 250
	}
	
	override func numberOfRows(in tableView: NSTableView) -> Int {
		return trainers.count
	}
	
	override func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
		return 50
	}
	
	override func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		
		let cell = (tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cell"), owner: self) ?? GoDTableCellView(title: "", colour: GoDDesign.colourBlack(), showsImage: true, image: nil, background: nil, fontSize: 12, width: self.table.width)) as! GoDTableCellView
		
		cell.identifier = NSUserInterfaceItemIdentifier(rawValue: "cell")
		
		cell.titleField.maximumNumberOfLines = 2
		
		let trainer = trainers[row]
		cell.setTitle(trainer.name.replacingOccurrences(of: "[07]{00}", with: "") + "\n" + "\(trainer.index): " + trainer.fullname.replacingOccurrences(of: "[07]{00}", with: ""))
		cell.setImage(image: trainer.trainerModel.image)
		
		var colour = GoDDesign.colourWhite()
		switch trainer.deck {
		case .DeckStory:
			colour = GoDDesign.colourBlue()
		}
		
		cell.setBackgroundColour(trainer.hasShadow ? GoDDesign.colourPurple() : colour)
		
		if self.table.selectedRow == row {
			cell.setBackgroundColour(GoDDesign.colourOrange())
		}
		
		return cell
	}
	
	override func tableView(_ tableView: GoDTableView, didSelectRow row: Int) {
		super.tableView(tableView, didSelectRow: row)
		self.showActivityView {
			let info = self.trainers[row]
			self.currentTrainer = XGTrainer(index: info.index)
			self.trainerView.setUp(loadBattleData: true)
			for view in self.pokemonViews {
				view.setUp()
			}
			self.hideActivityView()
		}
		
	}
	
}
