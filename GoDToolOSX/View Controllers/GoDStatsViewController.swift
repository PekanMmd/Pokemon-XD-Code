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
	
	@IBOutlet var HPEVField: NSTextField!
	@IBOutlet var attackEVField: NSTextField!
	@IBOutlet var defEVField: NSTextField!
	@IBOutlet var spatkEVField: NSTextField!
	@IBOutlet var spdefEVField: NSTextField!
	@IBOutlet var speedEVField: NSTextField!
	
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

	// PBR only
	@IBOutlet var evo6: GoDEvolutionView!
	@IBOutlet var evo7: GoDEvolutionView!
	
	@IBOutlet var TMsContainer: GoDContainerView!
	@IBOutlet var LUMContainer: GoDContainerView!

	lazy var tmdelegate = TMTableDelegate(delegate: self, width: 150)
	lazy var lumdelegate = LUMTableDelegate(delegate: self)
	
	var TMTable: GoDTableView!
	var LUMTable: GoDTableView!
	
	@IBOutlet weak var heightLabel: NSTextField!
	@IBOutlet weak var heightField: NSTextField!
	@IBOutlet weak var weightLabel: NSTextField!
	@IBOutlet weak var weightField: NSTextField!

	var filteredMons = [(name: String, type1: XGMoveTypes, index: Int)]()
	var mons = allPokemonArray().map { (mon) -> (name: String, type1 : XGMoveTypes, index : Int) in
		return (mon.name.unformattedString, mon.type1, mon.index)
	}
	
	var pokemon = XGPokemonStats(index: 0) {
		didSet {
			self.reloadViewWithActivity()
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.title = "Pokemon Stats Editor"
		
		let evos = [evo1,evo2,evo3,evo4,evo5] + (game == .PBR ? [evo6, evo7] : [])
		for i in 0 ..< evos.count {
			evos[i]!.index = i
			evos[i]!.delegate = self
		}

		TMTable = GoDTableView(width: 150, delegate: tmdelegate, dataSource: tmdelegate)
		TMTable.setShouldUseIntercellSpacing(to: true)
		TMsContainer.addSubview(TMTable)
		TMTable.pinTop(to: TMsContainer, padding: 3)
		TMTable.pinBottom(to: TMsContainer, padding: 3)
		TMTable.pinCenterX(to: TMsContainer)
		TMTable.pinWidth(as: 150)

		LUMTable = GoDTableView(width: 200, delegate: lumdelegate, dataSource: lumdelegate)
		LUMTable.setShouldUseIntercellSpacing(to: true)
		LUMContainer.addSubview(LUMTable)
		LUMTable.pinTop(to: LUMContainer, padding: 3)
		LUMTable.pinBottom(to: LUMContainer, padding: 3)
		LUMTable.pinCenterX(to: LUMContainer)
		LUMTable.pinWidth(as: 200)
		
		for view in [HPField, attackField, defField, spatkField, spdefField, speedField] {
			view?.backgroundColor = NSColor.controlBackgroundColor
			view?.textColor = NSColor.controlTextColor
		}

		if game == .Colosseum {
			heightLabel.stringValue = "Height (ft)"
			weightLabel.stringValue = "Weight (lbs)"
		}

		filteredMons = mons
		table.reloadData()
		
		reloadViewWithActivity()
    }
	
	override func numberOfRows(in tableView: NSTableView) -> Int {
		return filteredMons.count
	}
	
	override func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
		return 50
	}
	
	override func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		
		let pokemon = filteredMons[row]
		
		let cell = super.tableView(tableView, viewFor: tableColumn, row: row) as? GoDTableCellView
		
		cell?.setBackgroundImage(pokemon.type1.image)
		cell?.setTitle(pokemon.name)
		cell?.setImage(image: XGFiles.pokeFace(pokemon.index).image)
		
		return cell
	}
	
	override func tableView(_ tableView: GoDTableView, didSelectRow row: Int) {
		super.tableView(tableView, didSelectRow: row)
		if row >= 0 {
			let mon = filteredMons[row]
			self.pokemon = XGPokemonStats(index: mon.index)
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
			filteredMons = mons
			return
		}

		filteredMons = mons.filter({ (mon) -> Bool in
			return mon.name.simplified.contains(text.simplified)
				|| mon.index == text.integerValue
		})
	}
	
	func reloadViewWithActivity() {
		showActivityView {
			self.reloadView()
			self.hideActivityView()
		}
	}
	
	func reloadView() {
		
		HPField.integerValue = pokemon.hp
		attackField.integerValue = pokemon.attack
		defField.integerValue = pokemon.defense
		spatkField.integerValue = pokemon.specialAttack
		spdefField.integerValue = pokemon.specialDefense
		speedField.integerValue = pokemon.speed

		heightField.doubleValue = pokemon.height
		weightField.doubleValue = pokemon.weight

		HPEVField.integerValue = pokemon.hpYield
		attackEVField.integerValue = pokemon.attackYield
		defEVField.integerValue = pokemon.defenseYield
		spatkEVField.integerValue = pokemon.specialAttackYield
		spdefEVField.integerValue = pokemon.specialDefenseYield
		speedEVField.integerValue = pokemon.speedYield
		
		catchRateField.integerValue = pokemon.catchRate
		ExpYieldField.integerValue = pokemon.baseExp
		happinessField.integerValue = pokemon.baseHappiness
		
		nameField.stringValue = pokemon.name.unformattedString
		nameIDField.stringValue = pokemon.nameID.string
		indexField.integerValue = pokemon.index
		hexField.stringValue = pokemon.index.hexString()
		startField.stringValue = pokemon.startOffset.hexString()
		
		type1PopUp.select(pokemon.type1)
		type2PopUp.select(pokemon.type2)
		ability1PopUp.select(pokemon.ability1)
		ability2PopUp.select(pokemon.ability2)
		item1PopUp.select(pokemon.heldItem1)
		item2PopUp.select(pokemon.heldItem2)
		
		ExpRatePopUp.select(pokemon.levelUpRate)
		genderPopUp.select(pokemon.genderRatio)
        
		let evos = [evo1,evo2,evo3,evo4,evo5] + (game == .PBR ? [evo6, evo7] : [])
		for evo in evos {
			evo?.reloadData()
		}
		
		TMTable.reloadData()
		LUMTable.reloadData()
	}

	@IBAction func setHeight(_ sender: NSTextField) {
		let max = Double(0xFFFF) / 10
		var value = sender.doubleValue
		value = value < 0 ? 0 : value
		value = value > max ? max : value

		pokemon.height = value
	}

	@IBAction func setWeight(_ sender: NSTextField) {
		let max = Double(0xFFFF) / 10
		var value = sender.doubleValue
		value = value < 0 ? 0 : value
		value = value > max ? max : value

		pokemon.weight = value
	}

	@IBAction func setHP(_ sender: NSTextField) {
		var value = sender.integerValue
		value = value < 0 ? 0 : value
		value = value > 255 ? 255 : value
		
		pokemon.hp = value
	}
	
	@IBAction func setAtk(_ sender: NSTextField) {
		var value = sender.integerValue
		value = value < 0 ? 0 : value
		value = value > 255 ? 255 : value
		
		pokemon.attack = value
	}
	
	@IBAction func setDef(_ sender: NSTextField) {
		var value = sender.integerValue
		value = value < 0 ? 0 : value
		value = value > 255 ? 255 : value
		
		pokemon.defense = value
	}
	
	@IBAction func setSpAtk(_ sender: NSTextField) {
		var value = sender.integerValue
		value = value < 0 ? 0 : value
		value = value > 255 ? 255 : value
		
		pokemon.specialAttack = value
	}
	
	@IBAction func setSpDef(_ sender: NSTextField) {
		var value = sender.integerValue
		value = value < 0 ? 0 : value
		value = value > 255 ? 255 : value
		
		pokemon.specialDefense = value
	}
	
	@IBAction func setSpeed(_ sender: NSTextField) {
		var value = sender.integerValue
		value = value < 0 ? 0 : value
		value = value > 255 ? 255 : value
		
		pokemon.speed = value
	}
	
	@IBAction func setHPEV(_ sender: NSTextField) {
		let max = game == .PBR ? 3 : 0xFF
		var value = sender.integerValue
		value = value < 0 ? 0 : value
		value = value > max ? max : value
		
		pokemon.hpYield = value
	}
	
	@IBAction func setAtkEV(_ sender: NSTextField) {
		let max = game == .PBR ? 3 : 0xFF
		var value = sender.integerValue
		value = value < 0 ? 0 : value
		value = value > max ? max : value
		
		pokemon.attackYield = value
	}
	
	@IBAction func setDefEV(_ sender: NSTextField) {
		let max = game == .PBR ? 3 : 0xFF
		var value = sender.integerValue
		value = value < 0 ? 0 : value
		value = value > max ? max : value
		
		pokemon.defenseYield = value
	}
	
	@IBAction func setSpAtkEV(_ sender: NSTextField) {
		let max = game == .PBR ? 3 : 0xFF
		var value = sender.integerValue
		value = value < 0 ? 0 : value
		value = value > max ? max : value
		
		pokemon.specialAttackYield = value
	}
	
	@IBAction func setSpDefEV(_ sender: NSTextField) {
		let max = game == .PBR ? 3 : 0xFF
		var value = sender.integerValue
		value = value < 0 ? 0 : value
		value = value > max ? max : value
		
		pokemon.specialDefenseYield = value
	}
	
	@IBAction func setSpeedEV(_ sender: NSTextField) {
		let max = game == .PBR ? 3 : 0xFF
		var value = sender.integerValue
		value = value < 0 ? 0 : value
		value = value > max ? max : value
		
		pokemon.speedYield = value
	}
	
	@IBAction func setName(_ sender: NSTextField) {
		if nameIDField.stringValue.integerValue != nil {
			var value = nameIDField.stringValue.integerValue!
			value = value < 0 ? 0 : value
			value = value > kMaxStringID ? kMaxStringID : value
			
			self.pokemon.nameID = value
			
			if pokemon.nameID == 0 {
				return
			}

			if sender.stringValue.length == 0 {
				sender.stringValue = pokemon.name.unformattedString
				return
			}

			var nameText = ""
			if game == .PBR {
				for char in XGSpecialCharacters.generalFormattingChars {
					nameText += char.string
				}
			}
			nameText += sender.stringValue

			#if GAME_PBR
			if !XGString(string: nameText, sid: pokemon.nameID).replace() {
				GoDAlertViewController.displayAlert(title: "Replacement failed!", text: "The string could not be replaced")
			}
			#else
			let string = XGString(string: nameText, file: XGFiles.commonStringTableFile, sid: pokemon.nameID)
			if !XGFiles.commonStringTableFile.stringTable.addString(string, increaseSize: false, save: true) {
				printg("Failed to set pokemon name:", sender.stringValue)
			}
			#endif
		}
		
		reloadView()
		table.reloadData()
	}
	
	@IBAction func setNameID(_ sender: NSTextField) {
		var value = sender.integerValue
		value = value < 0 ? 0 : value
		value = value > kMaxStringID ? kMaxStringID : value
		
		pokemon.nameID = value
		
		reloadView()
	}
	
	@IBAction func setType1(_ sender: GoDTypePopUpButton) {
		pokemon.type1 = sender.selectedValue
	}
	
	@IBAction func setType2(_ sender: GoDTypePopUpButton) {
		pokemon.type2 = sender.selectedValue
	}
	
	@IBAction func setAbility1(_ sender: GoDAbilityPopUpButton) {
		pokemon.ability1 = sender.selectedValue
	}
	
	@IBAction func setAbility2(_ sender: GoDAbilityPopUpButton) {
		pokemon.ability2 = sender.selectedValue
	}
	
	@IBAction func setItem1(_ sender: GoDItemPopUpButton) {
		pokemon.heldItem1 = sender.selectedValue
	}
	
	@IBAction func setItem2(_ sender: GoDItemPopUpButton) {
		pokemon.heldItem2 = sender.selectedValue
	}
	
	@IBAction func setExpRate(_ sender: GoDExpRatePopUpButton) {
		pokemon.levelUpRate = sender.selectedValue
	}
	
	@IBAction func setGenderRatio(_ sender: GoDGenderRatioPopUpButton) {
		pokemon.genderRatio = sender.selectedValue
	}
	
	@IBAction func setCatchRate(_ sender: NSTextField) {
		var value = sender.integerValue
		value = value < 0 ? 0 : value
		value = value > 255 ? 255 : value
		
		pokemon.catchRate = value
		
	}
	
	@IBAction func setHappiness(_ sender: NSTextField) {
		var value = sender.integerValue
		value = value < 0 ? 0 : value
		value = value > 255 ? 255 : value
		
		pokemon.baseHappiness = value
		
	}
	
	@IBAction func setBaseExp(_ sender: NSTextField) {
		var value = sender.integerValue
		value = value < 0 ? 0 : value
		value = value > 255 ? 255 : value
		
		pokemon.baseExp = value
		
	}
	
	func prepareForSave() {
		
		setCatchRate(catchRateField)
		setHappiness(happinessField)
		setBaseExp(ExpYieldField)
		setHP(HPField)
		setAtk(attackField)
		setDef(defField)
		setSpeed(speedField)
		setSpAtk(spatkField)
		setSpDef(spdefField)
		setHPEV(HPEVField)
		setAtkEV(attackEVField)
		setDefEV(defEVField)
		setSpeedEV(speedEVField)
		setSpAtkEV(spatkEVField)
		setSpDefEV(spdefEVField)
		setNameID(nameIDField)
		setHeight(heightField)
		setWeight(weightField)
	}
	
	
	@IBAction func save(_ sender: NSButton) {
		
		prepareForSave()
		pokemon.save()
		
		let current = mons[pokemon.index]
		mons[pokemon.index] = (pokemon.name.unformattedString, pokemon.type1, current.index)
		
		reloadViewWithActivity()
		table.reloadData()
		
		printg("saved updated stats:",pokemon.name)
	}
	
	
	//MARK: - TMs Delegate
	class TMTableDelegate: NSObject, GoDTableViewDelegate, GoDTableViewDataSource {
		
		weak var delegate : GoDStatsViewController!
		var width: CGFloat = 0
		
		init(delegate: GoDStatsViewController, width: CGFloat) {
			super.init()
			self.width = width
			self.delegate = delegate
			
		}
		
		func numberOfRows(in tableView: NSTableView) -> Int {
			return kNumberOfTMsAndHMs + kNumberOfTutorMoves
		}
		
		func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
			return 30
		}
		
		func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
			
			let isTM = row < kNumberOfTMsAndHMs
			let tm = isTM ? XGTMs.tm(row + 1) : XGTMs.tutor(row - kNumberOfTMsAndHMs + 1)
			
			let cell = (tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cell"), owner: self) ?? GoDTableCellView(title: "", colour: GoDDesign.colourBlack(), fontSize: 12, width: self.width)) as! GoDTableCellView
			
			cell.setBackgroundImage(tm.move.type.image)
			if tm.move.isShadowMove {
				cell.setBackgroundImage(XGMoveTypes.shadowImage)
			}
			cell.setTitle(tm.move.name.unformattedString)

			let isLearnable: Bool
			if isTM {
				isLearnable = delegate.pokemon.learnableTMs[row]
			} else {
				isLearnable = delegate.pokemon.tutorMoves[row - kNumberOfTMsAndHMs]
			}
			if isLearnable {
				cell.addBorder(colour: GoDDesign.colourWhite(), width: 1)
			} else {
				cell.removeBorder()
			}
			
			cell.identifier = NSUserInterfaceItemIdentifier(rawValue: "cell")
			cell.translatesAutoresizingMaskIntoConstraints = false

			return cell
		}
		
		func tableView(_ tableView: GoDTableView, didSelectRow row: Int) {
			if row >= 0 {
				if row < kNumberOfTMsAndHMs {
					delegate.pokemon.learnableTMs[row]  = !delegate.pokemon.learnableTMs[row]
				} else {
					delegate.pokemon.tutorMoves[row - kNumberOfTMsAndHMs] = !delegate.pokemon.tutorMoves[row - kNumberOfTMsAndHMs]
				}
			}
			tableView.reloadData()
		}
		
		func tableView(tableView: NSTableView, didSelectRow row: Int) {
			if row >= 0 {
				if row < kNumberOfTMsAndHMs {
					delegate.pokemon.learnableTMs[row]  = !delegate.pokemon.learnableTMs[row]
				} else {
					delegate.pokemon.tutorMoves[row - kNumberOfTMsAndHMs] = !delegate.pokemon.tutorMoves[row - kNumberOfTMsAndHMs]
				}
			}
			tableView.reloadData()
		}
		
		func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
			self.tableView(tableView: tableView, didSelectRow: row)
			return false
		}

		func tableView(_ tableView: GoDTableView, didSearchForText text: String) {}
		func searchBarBehaviourForTableView(_ tableView: GoDTableView) -> GoDSearchBarBehaviour {
			return .none
		}
	}
	
	//MARK: - Level Up Moves Delegate
	class LUMTableDelegate: NSObject, GoDTableViewDelegate, GoDTableViewDataSource {

		weak var delegate: GoDStatsViewController!
		
		init(delegate: GoDStatsViewController) {
			super.init()
			self.delegate = delegate
		}
		
		func numberOfRows(in tableView: NSTableView) -> Int {
			return kNumberOfLevelUpMoves
		}
		
		func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
			return 30
		}
		
		func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
			
			let cell = (tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cell"), owner: self) ?? GoDLevelUpMoveView() ) as! GoDLevelUpMoveView
			
			cell.identifier = NSUserInterfaceItemIdentifier(rawValue: "cell")
			cell.translatesAutoresizingMaskIntoConstraints = false
			
			cell.index = row
			cell.delegate = self.delegate
			
			cell.reloadData()
			
			return cell
		}
		
		func tableView(_ tableView: GoDTableView, didSelectRow row: Int) {
			return
		}
		
		func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
			return false
		}

		func tableView(_ tableView: GoDTableView, didSearchForText text: String) {}
		func searchBarBehaviourForTableView(_ tableView: GoDTableView) -> GoDSearchBarBehaviour {
			return .none
		}
	}
	
}


































