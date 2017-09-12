//
//  GoDStatsViewController.swift
//  GoD Tool
//
//  Created by StarsMmd on 29/06/2016.
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
	
	
	@IBOutlet var nameContainer: NSView!
	@IBOutlet var nameField: NSTextField!
	@IBOutlet var nameIDField: NSTextField!
	@IBOutlet var indexField: NSTextField!
	@IBOutlet var hexField: NSTextField!
	@IBOutlet var startField: NSTextField!
	
	@IBOutlet var saveButton: NSButton!
	
	@IBOutlet var type1PopUp: GoDTypePopUpButton!
	@IBOutlet var type2PopUp: GoDTypePopUpButton!
	@IBOutlet var ability1PopUp: GoDAbilityPopUpButton!
	@IBOutlet var ability2PopUp: GoDAbilityPopUpButton!
	@IBOutlet var item1PopUp: GoDItemPopUpButton!
	@IBOutlet var item2PopUp: GoDItemPopUpButton!
	
	@IBOutlet var catchRateField: NSTextField!
	@IBOutlet var happinessField: NSTextField!
	@IBOutlet var ExpYieldField: NSTextField!
	
	@IBOutlet var ExpRatePopUp: GoDExpRatePopUpButton!
	@IBOutlet var genderPopUp: GoDGenderRatioPopUpButton!
	
	@IBOutlet var evo1: GoDEvolutionView!
	@IBOutlet var evo2: GoDEvolutionView!
	@IBOutlet var evo3: GoDEvolutionView!
	@IBOutlet var evo4: GoDEvolutionView!
	@IBOutlet var evo5: GoDEvolutionView!
	
	var mons = allPokemonArray().map { (mon) -> (name: String, type1 : XGMoveTypes, index : Int) in
		return (mon.name.string, mon.type1, mon.index)
	}
	
	var pokemon = XGPokemonStats(index: 0) {
		didSet {
			self.reloadView()
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		let evos = [evo1,evo2,evo3,evo4,evo5]
		for i in 0 ..< evos.count {
			evos[i]!.index = i
			evos[i]!.delegate = self
		}
		
		reloadViewWithActivity()
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
		
		cell.alphaValue = self.table.selectedRow == row ? 1 : 0.75
		
		return cell
	}
	
	override func tableView(_ tableView: GoDTableView, didSelectRow row: Int) {
		if row >= 0 {
			self.pokemon = XGPokemonStats(index: row)
		}
		self.table.reloadData()
		self.table.tableView.selectRowIndexes([row], byExtendingSelection: false)
	}
	
	func reloadViewWithActivity() {
		self.showActivityView {
			self.reloadView()
			self.hideActivityView()
		}
	}
	
	func reloadView() {
		
		self.HPField.integerValue = self.pokemon.hp
		self.attackField.integerValue = self.pokemon.attack
		self.defField.integerValue = self.pokemon.defense
		self.spatkField.integerValue = self.pokemon.specialAttack
		self.spdefField.integerValue = self.pokemon.specialDefense
		self.speedField.integerValue = self.pokemon.speed
		
//		self.HPEVField.integerValue = self.pokemon.hpYield
//		self.attackEVField.integerValue = self.pokemon.attackYield
//		self.defEVField.integerValue = self.pokemon.defenseYield
//		self.spatkEVField.integerValue = self.pokemon.specialAttackYield
//		self.spdefEVField.integerValue = self.pokemon.specialDefenseYield
//		self.speedEVField.integerValue = self.pokemon.speedYield
		
		self.catchRateField.integerValue = self.pokemon.catchRate
		self.ExpYieldField.integerValue = self.pokemon.baseExp
		self.happinessField.integerValue = self.pokemon.baseHappiness
		
		self.nameField.stringValue = self.pokemon.name.string
		self.nameIDField.stringValue = self.pokemon.nameID.string
		self.indexField.integerValue = self.pokemon.index
		self.hexField.stringValue = self.pokemon.index.hexString()
		self.startField.stringValue = self.pokemon.startOffset.hexString()
		
		self.type1PopUp.selectType(type: self.pokemon.type1)
		self.type2PopUp.selectType(type: self.pokemon.type2)
		self.ability1PopUp.selectAbility(ability: self.pokemon.ability1)
		self.ability2PopUp.selectAbility(ability: self.pokemon.ability2)
		self.item1PopUp.selectItem(item: self.pokemon.heldItem1)
		self.item2PopUp.selectItem(item: self.pokemon.heldItem2)
		
		self.ExpRatePopUp.selectExpRate(rate: self.pokemon.levelUpRate)
		self.genderPopUp.selectGenderRatio(ratio: self.pokemon.genderRatio)
		
		let evos = [evo1,evo2,evo3,evo4,evo5]
		for evo in evos {
			evo?.reloadData()
		}
		
	}
	
	@IBAction func setHP(_ sender: NSTextField) {
		var value = sender.integerValue
		value = value < 0 ? 0 : value
		value = value > 255 ? 255 : value
		
		self.pokemon.hp = value
		self.reloadView()
	}
	
	@IBAction func setAtk(_ sender: NSTextField) {
		var value = sender.integerValue
		value = value < 0 ? 0 : value
		value = value > 255 ? 255 : value
		
		self.pokemon.attack = value
		
		self.reloadView()
	}
	
	@IBAction func setDef(_ sender: NSTextField) {
		var value = sender.integerValue
		value = value < 0 ? 0 : value
		value = value > 255 ? 255 : value
		
		self.pokemon.defense = value
		
		self.reloadView()
	}
	
	@IBAction func setSpAtk(_ sender: NSTextField) {
		var value = sender.integerValue
		value = value < 0 ? 0 : value
		value = value > 255 ? 255 : value
		
		self.pokemon.specialAttack = value
		
		self.reloadView()
	}
	
	@IBAction func setSpDef(_ sender: NSTextField) {
		var value = sender.integerValue
		value = value < 0 ? 0 : value
		value = value > 255 ? 255 : value
		
		self.pokemon.specialDefense = value
		
		self.reloadView()
	}
	
	@IBAction func setSpeed(_ sender: NSTextField) {
		var value = sender.integerValue
		value = value < 0 ? 0 : value
		value = value > 255 ? 255 : value
		
		self.pokemon.speed = value
		
		self.reloadView()
	}
	
	@IBAction func setHPEV(_ sender: NSTextField) {
		var value = sender.integerValue
		value = value < 0 ? 0 : value
		value = value > 255 ? 255 : value
		
		self.pokemon.hpYield = value
		self.reloadView()
	}
	
	@IBAction func setAtkEV(_ sender: NSTextField) {
		var value = sender.integerValue
		value = value < 0 ? 0 : value
		value = value > 255 ? 255 : value
		
		self.pokemon.attackYield = value
		
		self.reloadView()
	}
	
	@IBAction func setDefEV(_ sender: NSTextField) {
		var value = sender.integerValue
		value = value < 0 ? 0 : value
		value = value > 255 ? 255 : value
		
		self.pokemon.defenseYield = value
		
		self.reloadView()
	}
	
	@IBAction func setSpAtkEV(_ sender: NSTextField) {
		var value = sender.integerValue
		value = value < 0 ? 0 : value
		value = value > 255 ? 255 : value
		
		self.pokemon.specialAttackYield = value
		
		self.reloadView()
	}
	
	@IBAction func setSpDefEV(_ sender: NSTextField) {
		var value = sender.integerValue
		value = value < 0 ? 0 : value
		value = value > 255 ? 255 : value
		
		self.pokemon.specialDefenseYield = value
		
		self.reloadView()
	}
	
	@IBAction func setSpeedEV(_ sender: NSTextField) {
		var value = sender.integerValue
		value = value < 0 ? 0 : value
		value = value > 255 ? 255 : value
		
		self.pokemon.speedYield = value
		
		self.reloadView()
	}
	
	@IBAction func setName(_ sender: NSTextField) {
		if pokemon.nameID == 0 {
			return
		}
		let value = sender.stringValue
		let success = self.pokemon.name.duplicateWithString(value).replace()
		
		self.reloadView()
	}
	
	@IBAction func setNameID(_ sender: NSTextField) {
		var value = sender.integerValue
		value = value < 0 ? 0 : value
		value = value > 0xFFFF ? 0xFFFF : value
		
		self.pokemon.nameID = value
		
		self.reloadView()
	}
	
	@IBAction func setType1(_ sender: GoDTypePopUpButton) {
		self.pokemon.type1 = sender.selectedValue
		
		self.reloadView()
	}
	
	@IBAction func setType2(_ sender: GoDTypePopUpButton) {
		self.pokemon.type2 = sender.selectedValue
		
		self.reloadView()
	}
	
	@IBAction func setAbility1(_ sender: GoDAbilityPopUpButton) {
		self.pokemon.ability1 = sender.selectedValue
		
		self.reloadView()
	}
	
	@IBAction func setAbility2(_ sender: GoDAbilityPopUpButton) {
		self.pokemon.ability2 = sender.selectedValue
		
		self.reloadView()
	}
	
	@IBAction func setItem1(_ sender: GoDItemPopUpButton) {
		self.pokemon.heldItem1 = sender.selectedValue
		
		self.reloadView()
	}
	
	@IBAction func setItem2(_ sender: GoDItemPopUpButton) {
		self.pokemon.heldItem2 = sender.selectedValue
		
		self.reloadView()
	}
	
	@IBAction func setExpRate(_ sender: GoDExpRatePopUpButton) {
		self.pokemon.levelUpRate = sender.selectedValue
		
		self.reloadView()
	}
	
	@IBAction func setGenderRatio(_ sender: GoDGenderRatioPopUpButton) {
		self.pokemon.genderRatio = sender.selectedValue
		
		self.reloadView()
	}
	
	@IBAction func setCatchRate(_ sender: NSTextField) {
		var value = sender.integerValue
		value = value < 0 ? 0 : value
		value = value > 255 ? 255 : value
		
		self.pokemon.catchRate = value
		
		self.reloadView()
	}
	
	@IBAction func setHappiness(_ sender: NSTextField) {
		var value = sender.integerValue
		value = value < 0 ? 0 : value
		value = value > 255 ? 255 : value
		
		self.pokemon.baseHappiness = value
		
		self.reloadView()
	}
	
	@IBAction func setBaseExp(_ sender: NSTextField) {
		var value = sender.integerValue
		value = value < 0 ? 0 : value
		value = value > 255 ? 255 : value
		
		self.pokemon.baseExp = value
		
		self.reloadView()
	}
	
	
	
	@IBAction func save(_ sender: NSButton) {
		self.pokemon.save()
		
		let current = self.mons[self.pokemon.index]
		self.mons[self.pokemon.index] = (self.pokemon.name.string, self.pokemon.type1, current.index)
		
		self.reloadViewWithActivity()
		self.table.reloadIndex(current.index)
	}
	
}


































