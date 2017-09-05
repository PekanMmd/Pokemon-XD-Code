//
//  GoDStatsViewController.swift
//  GoD Tool
//
//  Created by The Steez on 29/06/2016.
//  Copyright © 2016 StarsMmd. All rights reserved.
//

import AppKit

class GoDStatsViewController: GoDTableViewController {
	
	@IBOutlet var HPField: NSTextField!
	@IBOutlet var attackField: NSTextField!
	@IBOutlet var defField: NSTextField!
	@IBOutlet var spatkField: NSTextField!
	@IBOutlet var spdefField: NSTextField!
	@IBOutlet var speedField: NSTextField!
	
	
	let mons = allPokemonArray().map { (mon) -> (name: String, type1 : XGMoveTypes, index : Int) in
		return (mon.name.string, mon.type1, mon.index)
	}
	
	var pokemon = XGPokemonStats(index: 0) {
		didSet {
			self.reloadView()
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
		
		reloadView()
    }
	
	override func numberOfRows(in tableView: NSTableView) -> Int {
		return kNumberOfPokemon
	}
	
	override func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
		return 50
	}
	
	override func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		
		let pokemon = mons[row]
		
		let cell = (tableView.make(withIdentifier: "cell", owner: self) ?? GoDTableCellView(title: "", colour: GoDDesign.colourBlack(), showsImage: true, image: nil, background: nil, fontSize: 16, width: self.table.frame.width)) as! GoDTableCellView
		
		cell.setBackgroundImage(pokemon.type1.image)
		cell.setTitle(pokemon.name)
		cell.setImage(image: XGFiles.pokeFace(pokemon.index).image)
		
		cell.identifier = "cell"
		cell.translatesAutoresizingMaskIntoConstraints = false
		
		
		return cell
	}
	
	override func tableView(_ tableView: GoDTableView, didSelectRow row: Int) {
		if row >= 0 {
			self.pokemon = XGPokemonStats(index: row)
		}
	}
	
	func reloadView() {
		
		self.HPField.integerValue = self.pokemon.hp
		self.attackField.integerValue = self.pokemon.attack
		self.defField.integerValue = self.pokemon.defense
		self.spatkField.integerValue = self.pokemon.specialAttack
		self.spdefField.integerValue = self.pokemon.specialDefense
		self.speedField.integerValue = self.pokemon.speed
		
	}
	
	@IBAction func setHP(_ sender: NSTextField) {
		let value = sender.integerValue
		if value > 0 && value <= 255 {
			self.pokemon.hp = value
		}
		self.reloadView()
	}
	
	@IBAction func setAtk(_ sender: NSTextField) {
		let value = sender.integerValue
		if value > 0 && value <= 255 {
			self.pokemon.attack = value
		}
		self.reloadView()
	}
	
	@IBAction func setDef(_ sender: NSTextField) {
		let value = sender.integerValue
		if value > 0 && value <= 255 {
			self.pokemon.defense = value
		}
		self.reloadView()
	}
	
	@IBAction func setSpAtk(_ sender: NSTextField) {
		let value = sender.integerValue
		if value > 0 && value <= 255 {
			self.pokemon.specialAttack = value
		}
		self.reloadView()
	}
	
	@IBAction func setSpDef(_ sender: NSTextField) {
		let value = sender.integerValue
		if value > 0 && value <= 255 {
			self.pokemon.specialDefense = value
		}
		self.reloadView()
	}
	
	@IBAction func setSpped(_ sender: NSTextField) {
		let value = sender.integerValue
		if value > 0 && value <= 255 {
			self.pokemon.speed = value
		}
		self.reloadView()
	}
	
}


































