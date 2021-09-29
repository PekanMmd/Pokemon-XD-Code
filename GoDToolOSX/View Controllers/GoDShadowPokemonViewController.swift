//
//  GoDShadowPokemonViewController.swift
//  GoDToolOSX
//
//  Created by The Steez on 09/05/2018.
//

import AppKit

class GoDShadowPokemonViewController: GoDTableViewController {
	
	var currentPokemon  = XGDeckPokemon.ddpk(0).data
	var allShadows		= XGDecks.DeckDarkPokemon.allPokemon
	var filteredShadows = [XGTrainerPokemon]()
	
	@IBOutlet var pokemonView: GoDShadowPokemonView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "Shadow Pokemon Editor"
		
		pokemonView.delegate = self
		filteredShadows = allShadows
		
		table.reloadData()
		table.setShouldUseIntercellSpacing(to: true)
	}

	func reloadAllData() {
		self.showActivityView {
			let row = self.table.selectedRow
			self.allShadows = XGDecks.DeckDarkPokemon.allPokemon
			self.table.reloadData()
			self.tableView(self.table, didSelectRow: row)
			self.hideActivityView()
		}
	}
	
	@IBAction func save(_ sender: Any) {
		self.showActivityView {
			self.pokemonView.prepareForSave()
			self.currentPokemon.save()
			let row = self.table.selectedRow
			self.table.reloadData()
			self.tableView(self.table, didSelectRow: row)
			self.hideActivityView()
		}
	}
	
	override func widthForTable() -> CGFloat {
		return 200
	}
	
	override func numberOfRows(in tableView: NSTableView) -> Int {
		return filteredShadows.count
	}
	
	override func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
		return 50
	}
	
	override func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		
		let cell = (tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cell"), owner: self) ?? GoDTableCellView(title: "", colour: GoDDesign.colourBlack(), fontSize: 12, width: widthForTable())) as! GoDTableCellView
		
		cell.identifier = NSUserInterfaceItemIdentifier(rawValue: "cell")
		
		cell.titleField.maximumNumberOfLines = 2
		
		let mon = filteredShadows[row]
		cell.setTitle("\(mon.deckData.index): Shadow " + mon.species.name.string + "\nLv. \(mon.level)+")
		cell.setImage(image: mon.species.face)
		
		cell.setBackgroundColour(GoDDesign.colourPurple())
		
		if self.table.selectedRow == row {
			cell.setBackgroundColour(GoDDesign.colourGreen())
		}
		
		return cell
	}
	
	override func tableView(_ tableView: GoDTableView, didSelectRow row: Int) {
		super.tableView(tableView, didSelectRow: row)
		if row == -1 {
			return
		}
		self.showActivityView {
			self.currentPokemon = self.filteredShadows[row]
			
			self.pokemonView.setUp()
			
			self.hideActivityView()
		}
	}

	override func searchBarBehaviourForTableView(_ tableView: GoDTableView) -> GoDSearchBarBehaviour {
		.onTextChange
	}

	override func tableView(_ tableView: GoDTableView, didSearchForText text: String) {
		defer {
			tableView.reloadData()
		}

		guard !text.isEmpty else {
			filteredShadows = allShadows
			return
		}

		filteredShadows = allShadows.filter({ (mon) -> Bool in
			return mon.species.name.string.simplified.contains(text.simplified)
				|| mon.species.index == text.integerValue
				|| mon.shadowID == text.integerValue
		})
	}

}
