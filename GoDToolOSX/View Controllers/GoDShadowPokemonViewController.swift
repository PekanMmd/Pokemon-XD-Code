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
	
	@IBOutlet var pokemonView: GoDShadowPokemonView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.title = "Shadow Pokemon Editor"
		
		pokemonView.delegate = self
		
		self.table.reloadData()
		self.table.tableView.intercellSpacing = NSSize(width: 0, height: 1)
		
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
	
	override func widthForTable() -> NSNumber {
		return 200
	}
	
	override func numberOfRows(in tableView: NSTableView) -> Int {
		return XGDecks.DeckDarkPokemon.DDPKEntries
	}
	
	override func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
		return 50
	}
	
	override func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		
		let cell = (tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cell"), owner: self) ?? GoDTableCellView(title: "", colour: GoDDesign.colourBlack(), fontSize: 12, width: self.table.width)) as! GoDTableCellView
		
		cell.identifier = NSUserInterfaceItemIdentifier(rawValue: "cell")
		
		cell.titleField.maximumNumberOfLines = 2
		
		let mon = allShadows[row]
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
			self.currentPokemon = self.allShadows[row]
			
			self.pokemonView.setUp()
			
			self.hideActivityView()
		}
		
	}

}
