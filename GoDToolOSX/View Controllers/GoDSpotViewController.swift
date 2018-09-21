//
//  GoDSpotViewController.swift
//  GoD Tool
//
//  Created by The Steez on 16/09/2017.
//
//

import Cocoa

class GoDSpotViewController: GoDTableViewController {

	@IBOutlet var image: NSImageView!
	@IBOutlet var species: GoDPokemonPopUpButton!
	
	@IBOutlet var minLevel: GoDLevelPopUpButton!
	@IBOutlet var maxLevel: GoDLevelPopUpButton!
	
	@IBOutlet var chance: NSTextField!
	@IBOutlet var steps: NSTextField!
	
	var currentMon = XGPokeSpotPokemon(index: 0, pokespot: .rock)
	
    override func viewDidLoad() {
        super.viewDidLoad()
        chance.formatter = NumberFormatter.byteFormatter()
		steps.formatter = NumberFormatter.shortFormatter()
		self.reloadView()
    }
	
	func reloadView() {
		self.showActivityView {
			
			self.image.image = self.currentMon.pokemon.body
			self.species.selectPokemon(pokemon: self.currentMon.pokemon)
			self.minLevel.selectLevel(level: self.currentMon.minLevel)
			self.maxLevel.selectLevel(level: self.currentMon.maxLevel)
			self.chance.integerValue = self.currentMon.encounterPercentage
			self.steps.integerValue = self.currentMon.stepsPerSnack
			
			self.hideActivityView()
		}
	}
	
	override func numberOfRows(in tableView: NSTableView) -> Int {
		return XGPokeSpots.all.numberOfEntries() + XGPokeSpots.rock.numberOfEntries() + XGPokeSpots.oasis.numberOfEntries() + XGPokeSpots.cave.numberOfEntries()
	}
	
	override func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		let pokemon = rowToMon(row: row).pokemon
		
		let cell = (tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cell"), owner: self) ?? GoDTableCellView(title: "", colour: GoDDesign.colourBlack(), showsImage: true, image: nil, background: nil, fontSize: 16, width: self.table.width)) as! GoDTableCellView
		
		let spot = rowToSpot(row: row)
//		cell.setBackgroundImage(pokemon.type1.image)
		cell.setTitle(pokemon.name.string + "\n" + spot.string + " Pokespot : " + pokemon.index.string)
		cell.setImage(image: pokemon.face)
		
		switch spot {
		case .rock:
			cell.setBackgroundImage(XGMoveTypes.rock.image)
		case .oasis:
			cell.setBackgroundImage(XGMoveTypes.grass.image)
		case .cave:
			cell.setBackgroundImage(XGMoveTypes.water.image)
		case .all:
			cell.setBackgroundImage(XGMoveTypes.steel.image)
		}
		
		cell.identifier = NSUserInterfaceItemIdentifier(rawValue: "cell")
		cell.translatesAutoresizingMaskIntoConstraints = false
		
		cell.alphaValue = self.table.selectedRow == row ? 1 : 0.75
		if self.table.selectedRow == row {
			cell.addBorder(colour: GoDDesign.colourBlack(), width: 1)
		} else {
			cell.removeBorder()
		}
		
		return cell
	}
	
	func rowToSpot(row: Int) -> XGPokeSpots {
		let rock = XGPokeSpots.rock.numberOfEntries()
		let oasis = XGPokeSpots.oasis.numberOfEntries()
		let cave = XGPokeSpots.cave.numberOfEntries()
		
		var index = 0
		var spot = XGPokeSpots.all
		
		if row < rock {
			spot = .rock
		} else if row < rock + oasis {
			spot = .oasis
		} else if row < rock + oasis + cave {
			spot = .cave
		}
		
		return spot
		
	}
	
	func rowToMon(row: Int) -> XGPokeSpotPokemon {
		let rock = XGPokeSpots.rock.numberOfEntries()
		let oasis = XGPokeSpots.oasis.numberOfEntries()
		let cave = XGPokeSpots.cave.numberOfEntries()
		
		var index = 0
		var spot = XGPokeSpots.all
		
		if row < rock {
			index = row
			spot = .rock
		} else if row < rock + oasis {
			index = row - rock
			spot = .oasis
		} else if row < rock + oasis + cave {
			index = row - (rock + oasis)
			spot = .cave
		} else {
			index = row - (rock + oasis + cave)
		}
		
		return XGPokeSpotPokemon(index: index, pokespot: spot)
		
	}
	
	override func tableView(_ tableView: GoDTableView, didSelectRow row: Int) {
		if row == -1 {
			return
		}
		self.currentMon = rowToMon(row: row)
		self.reloadView()
	}
	
	@IBAction func setSpeciesAction(_ sender: GoDPokemonPopUpButton) {
		currentMon.pokemon = sender.selectedValue
		self.reloadView()
	}
	
	@IBAction func setMinAction(_ sender: GoDLevelPopUpButton) {
		currentMon.minLevel = sender.selectedValue
	}
	
	@IBAction func setMaxAction(_ sender: GoDLevelPopUpButton) {
		currentMon.maxLevel = sender.selectedValue
	}
	
	@IBAction func setChanceAction(_ sender: NSTextField) {
		currentMon.encounterPercentage = sender.integerValue
	}
	
	@IBAction func setStepsAction(_ sender: NSTextField) {
		currentMon.stepsPerSnack = sender.integerValue
	}
	
	@IBAction func saveAction(_ sender: GoDButton) {
		currentMon.save()
		self.reloadView()
		self.table.reloadData()
	}
	
}





















