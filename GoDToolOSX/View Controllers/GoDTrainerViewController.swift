//
//  GoDTrainerViewController.swift
//  GoD Tool
//
//  Created by The Steez on 18/09/2017.
//
//

import Cocoa

class GoDTrainerViewController: GoDTableViewController {

	var currentTrainer = XGTrainer(index: 0, deck: .DeckStory) {
		didSet {
			self.pokemon = currentTrainer.pokemon.map({ (mon) -> XGTrainerPokemon in
				return mon.data
			})
		}
	}
	
	var pokemon = [XGTrainerPokemon]()

	var filteredTrainers = [TrainerInfo]()
	var trainers = [TrainerInfo]()
	
	
	var pokemonViews = [GoDPokemonView]()
	let pokemonContainer = GoDContainerView()
	let trainerView = GoDTrainerView()
	
	var saveButton : GoDButton!

	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.title = "Trainer Editor"
		
		self.pokemon = currentTrainer.pokemon.map({ (mon) -> XGTrainerPokemon in
			return mon.data
		})
		
		for deck in TrainerDecksArray {
			trainers += deck.allTrainers.map { (trainer) -> TrainerInfo in
				return trainer.trainerInfo
			}
		}

		filteredTrainers = trainers
		
		self.table.reloadData()
		table.setShouldUseIntercellSpacing(to: true)
		
		for i in 0 ... 5 {
			let mon = GoDPokemonView()
			mon.index = i
			mon.delegate = self
			self.pokemonViews.append(mon)
		}
		
		self.trainerView.delegate = self
		
		self.pokemonContainer.translatesAutoresizingMaskIntoConstraints = false
		self.pokemonContainer.wantsLayer = true
		self.pokemonContainer.addBorder(colour: GoDDesign.colourBlack(), width: 1)
		
		self.saveButton = GoDButton(title: "Save", buttonType: NSButton.ButtonType.momentaryPushIn, target: self, action: #selector(save))
		
		self.saveButton.keyEquivalent = "⌘S"
		
		self.layoutViews()
	}
	
	func layoutViews() {
		view.addSubview(trainerView)
		view.addSubview(pokemonContainer)
		view.addSubview(saveButton)
		
		pokemonViews.forEach(pokemonContainer.addSubview)

		pokemonViews[0].pinWidth(as: 330)
		(1...5).forEach { (index) in
			pokemonViews[index].constrainWidthEqual(to: pokemonViews[0])
			pokemonViews[index].constrainHeightEqual(to: pokemonViews[0])
		}

		trainerView.pinLeadingToTrailing(of: table)
		trainerView.pinTrailing(to: view)
		trainerView.pinHeight(as: 80)
		trainerView.pinTop(to: view)
		pokemonContainer.pinTopToBottom(of: trainerView)
		pokemonContainer.pinLeadingToTrailing(of: table)
		pokemonContainer.pinTrailing(to: view)
		pokemonContainer.pinBottom(to: view)

		[0, 3].forEach { (index) in
			pokemonViews[index].pinLeading(to: pokemonContainer, padding: 10)
			pokemonViews[index + 1].pinLeadingToTrailing(of: pokemonViews[index], padding: 10)
			pokemonViews[index + 1].pinTop(to: pokemonViews[index])
			pokemonViews[index + 1].pinBottom(to: pokemonViews[index])
			pokemonViews[index + 2].pinLeadingToTrailing(of: pokemonViews[index + 1], padding: 10)
			pokemonViews[index + 2].pinTop(to: pokemonViews[index])
			pokemonViews[index + 2].pinBottom(to: pokemonViews[index])
			pokemonViews[index + 2].pinTrailing(to: pokemonContainer, padding: 10)
		}

		[0, 1, 2].forEach { (index) in
			pokemonViews[index].pinTopToBottom(of: trainerView, padding: 10)
			pokemonViews[index + 3].pinTopToBottom(of: pokemonViews[index], padding: 10)
			pokemonViews[index + 3].pinLeading(to: pokemonViews[index])
			pokemonViews[index + 3].pinTrailing(to: pokemonViews[index])
		}

		saveButton.pinHeight(as: 20)
		saveButton.pinWidth(as: 100)
		saveButton.pinCenterX(to: pokemonViews[4])
		saveButton.pinTopToBottom(of: pokemonViews[4], padding: 10)
		saveButton.pinBottom(to: pokemonContainer, padding: 10)
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
			for view in self.pokemonViews {
				view.didSave()
			}
			
			self.hideActivityView()
		}
	}
	
	override func widthForTable() -> CGFloat {
		return 250
	}
	
	override func numberOfRows(in tableView: NSTableView) -> Int {
		return filteredTrainers.count
	}
	
	override func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
		return 50
	}
	
	override func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		let cell = (tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cell"), owner: self) ?? GoDTableCellView(title: "", colour: GoDDesign.colourBlack(), fontSize: 12, width: widthForTable())) as! GoDTableCellView
		
		cell.identifier = NSUserInterfaceItemIdentifier(rawValue: "cell")
		
		cell.titleField.maximumNumberOfLines = 2
		
		let trainer = filteredTrainers[row]
		cell.setTitle("\(trainer.index): " + trainer.name + "\n" + trainer.location)
		cell.setImage(image: trainer.trainerModel.image)
		
		if trainer.trainerModel == XGTrainerModels.none {
			let face = XGTrainer(index: trainer.index, deck: trainer.deck).pokemon[0].data.species.face
			cell.setImage(image: face)
		}
		
		var colour = GoDDesign.colourWhite()
		switch trainer.deck {
		case .DeckStory:
			colour = GoDDesign.colourBlue()
		case .DeckHundred:
			colour = GoDDesign.colourRed()
		case .DeckColosseum:
			colour = GoDDesign.colourYellow()
		case .DeckVirtual:
			colour = GoDDesign.colourGreen()
		case .DeckImasugu:
			colour = GoDDesign.colourPink()
		default:
			break
		}
		
		cell.setBackgroundColour(trainer.hasShadow ? GoDDesign.colourPurple() : colour)
		
		if self.table.selectedRow == row {
			cell.setBackgroundColour(GoDDesign.colourOrange())
		}
		
		return cell
	}
	
	override func tableView(_ tableView: GoDTableView, didSelectRow row: Int) {
		super.tableView(tableView, didSelectRow: row)
		if row == -1 {
			return
		}
		self.showActivityView { 
			let info = self.filteredTrainers[row]
			self.currentTrainer = XGTrainer(index: info.index, deck: info.deck)
			self.trainerView.setUp(loadBattleData: true)
			for view in self.pokemonViews {
				view.setUp()
			}
			self.hideActivityView()
		}
	}

	override func searchBarBehaviourForTableView(_ tableView: GoDTableView) -> GoDSearchBarBehaviour {
		.onEndEditing
	}

	override func tableView(_ tableView: GoDTableView, didSearchForText text: String) {
		func searchFilter(info: TrainerInfo) -> Bool {
			let trainer = XGTrainer(index: info.index, deck: info.deck)
			return (info.hasShadow && text.lowercased() == "shadow")
				|| info.name.simplified.contains(text.simplified)
				|| trainer.className.simplified.contains(text.simplified)
				|| trainer.locationString.simplified.contains(text.simplified)
				|| (GoD_Tool.pokemon(text).index > 0 && trainer.pokemon.contains(where: { (mon) -> Bool in
					mon.pokemon.index == GoD_Tool.pokemon(text).index
				}))
				|| (GoD_Tool.move(text).index > 0 && trainer.pokemon.contains(where: { (mon) -> Bool in
					mon.data.moves.contains(where: { (m) -> Bool in
						m.index == GoD_Tool.move(text).index
					})
				}))
				|| (GoD_Tool.item(text).index > 0 && trainer.pokemon.contains(where: { (mon) -> Bool in
					mon.data.item.index == GoD_Tool.item(text).index
				}))
				|| (GoD_Tool.ability(text).index > 0 && trainer.pokemon.contains(where: { (mon) -> Bool in
					let stats = mon.pokemon.stats
					let abilities = [stats.ability1, stats.ability2]
					return abilities[mon.data.ability].index == GoD_Tool.ability(text).index
				}))
				|| trainer.index == text.integerValue
		}

		defer {
			tableView.reloadData()
		}

		guard !text.isEmpty else {
			filteredTrainers = trainers
			return
		}

		filteredTrainers = trainers.filter(searchFilter)
	}
}









