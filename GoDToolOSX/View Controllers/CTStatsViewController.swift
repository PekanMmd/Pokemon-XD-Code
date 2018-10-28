//
//  CTStatsViewController.swift
//  Colosseum Tool
//
//  Created by The Steez on 07/06/2018.
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
	
	@IBOutlet var TMsContainer: GoDContainerView!
	@IBOutlet var LUMContainer: GoDContainerView!
	
	var TMTable : GoDTableView!
	var LUMTable : GoDTableView!
	
	
	var mons = allPokemonArray().map { (mon) -> (name: String, type1 : XGMoveTypes, index : Int) in
		return (mon.name.string, mon.type1, mon.index)
	}
	
	var pokemon = XGPokemonStats(index: 0) {
		didSet {
			self.reloadViewWithActivity()
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.title = "Pokemon Stats Editor"
		
		let evos = [evo1,evo2,evo3,evo4,evo5]
		for i in 0 ..< evos.count {
			evos[i]!.index = i
			evos[i]!.delegate = self
		}
		
		let tmwidth : NSNumber = (TMsContainer.frame.width - 10) as! NSNumber
		let tmheight : NSNumber = 180
		let tmdelegate = TMTableDelegate(delegate: self, width: tmwidth)
		TMTable = GoDTableView(width: tmwidth, rows: kNumberOfTutorMoves + kNumberOfTMs, rowHeight: 30, delegate: tmdelegate, dataSource: tmdelegate)
		TMTable.setBackgroundColour(GoDDesign.colourClear())
		TMTable.tableView.intercellSpacing = NSSize(width: 0, height: 2)
		self.addSubview(TMTable, name: "TMs")
		self.addConstraintWidth(view: TMTable, width: tmwidth)
		self.addConstraintHeight(view: TMTable, height: tmheight)
		self.addConstraintAlignCenterX(view1: TMsContainer, view2: TMTable)
		self.addConstraintAlignCenterY(view1: TMsContainer, view2: TMTable)
		
		let lumwidth : NSNumber = (LUMContainer.frame.width - 10) as! NSNumber
		let lumheight : NSNumber = 180
		let lumdelegate = LUMTableDelegate(delegate: self, width: lumwidth)
		LUMTable = GoDTableView(width: tmwidth, rows: kNumberOfLevelUpMoves, rowHeight: 30, delegate: lumdelegate, dataSource: lumdelegate)
		LUMTable.setBackgroundColour(GoDDesign.colourClear())
		LUMTable.tableView.intercellSpacing = NSSize(width: 0, height: 2)
		self.addSubview(LUMTable, name: "LUM")
		self.addConstraintWidth(view: LUMTable, width: lumwidth)
		self.addConstraintHeight(view: LUMTable, height: lumheight)
		self.addConstraintAlignCenterX(view1: LUMContainer, view2: LUMTable)
		self.addConstraintAlignCenterY(view1: LUMContainer, view2: LUMTable)
		
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
		
		let cell = (tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cell"), owner: self) ?? GoDTableCellView(title: "", colour: GoDDesign.colourBlack(), showsImage: true, image: nil, background: nil, fontSize: 16, width: self.table.width)) as! GoDTableCellView
		
		cell.setBackgroundImage(pokemon.type1.image)
		cell.setTitle(pokemon.name)
		cell.setImage(image: XGFiles.pokeFace(pokemon.index).image)
		
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
		
		self.HPEVField.integerValue = self.pokemon.hpYield
		self.attackEVField.integerValue = self.pokemon.attackYield
		self.defEVField.integerValue = self.pokemon.defenseYield
		self.spatkEVField.integerValue = self.pokemon.specialAttackYield
		self.spdefEVField.integerValue = self.pokemon.specialDefenseYield
		self.speedEVField.integerValue = self.pokemon.speedYield
		
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
		
		self.TMTable.reloadData()
		self.LUMTable.reloadData()
		
	}
	
	@IBAction func setHP(_ sender: NSTextField) {
		var value = sender.integerValue
		value = value < 0 ? 0 : value
		value = value > 255 ? 255 : value
		
		self.pokemon.hp = value
		
	}
	
	@IBAction func setAtk(_ sender: NSTextField) {
		var value = sender.integerValue
		value = value < 0 ? 0 : value
		value = value > 255 ? 255 : value
		
		self.pokemon.attack = value
		
		
	}
	
	@IBAction func setDef(_ sender: NSTextField) {
		var value = sender.integerValue
		value = value < 0 ? 0 : value
		value = value > 255 ? 255 : value
		
		self.pokemon.defense = value
		
		
	}
	
	@IBAction func setSpAtk(_ sender: NSTextField) {
		var value = sender.integerValue
		value = value < 0 ? 0 : value
		value = value > 255 ? 255 : value
		
		self.pokemon.specialAttack = value
		
		
	}
	
	@IBAction func setSpDef(_ sender: NSTextField) {
		var value = sender.integerValue
		value = value < 0 ? 0 : value
		value = value > 255 ? 255 : value
		
		self.pokemon.specialDefense = value
		
		
	}
	
	@IBAction func setSpeed(_ sender: NSTextField) {
		var value = sender.integerValue
		value = value < 0 ? 0 : value
		value = value > 255 ? 255 : value
		
		self.pokemon.speed = value
		
		
	}
	
	@IBAction func setHPEV(_ sender: NSTextField) {
		var value = sender.integerValue
		value = value < 0 ? 0 : value
		value = value > 255 ? 255 : value
		
		self.pokemon.hpYield = value
		
	}
	
	@IBAction func setAtkEV(_ sender: NSTextField) {
		var value = sender.integerValue
		value = value < 0 ? 0 : value
		value = value > 255 ? 255 : value
		
		self.pokemon.attackYield = value
		
		
	}
	
	@IBAction func setDefEV(_ sender: NSTextField) {
		var value = sender.integerValue
		value = value < 0 ? 0 : value
		value = value > 255 ? 255 : value
		
		self.pokemon.defenseYield = value
		
		
	}
	
	@IBAction func setSpAtkEV(_ sender: NSTextField) {
		var value = sender.integerValue
		value = value < 0 ? 0 : value
		value = value > 255 ? 255 : value
		
		self.pokemon.specialAttackYield = value
		
		
	}
	
	@IBAction func setSpDefEV(_ sender: NSTextField) {
		var value = sender.integerValue
		value = value < 0 ? 0 : value
		value = value > 255 ? 255 : value
		
		self.pokemon.specialDefenseYield = value
		
		
	}
	
	@IBAction func setSpeedEV(_ sender: NSTextField) {
		var value = sender.integerValue
		value = value < 0 ? 0 : value
		value = value > 255 ? 255 : value
		
		self.pokemon.speedYield = value
		
		
	}
	
	@IBAction func setName(_ sender: NSTextField) {
		if pokemon.nameID == 0 {
			return
		}
		let value = sender.stringValue
		_ = self.pokemon.name.duplicateWithString(value).replace()
		
		self.reloadViewWithActivity()
	}
	
	@IBAction func setNameID(_ sender: NSTextField) {
		var value = sender.integerValue
		value = value < 0 ? 0 : value
		value = value > kMaxStringID ? kMaxStringID : value
		
		self.pokemon.nameID = value
		self.reloadViewWithActivity()
		
		
	}
	
	@IBAction func setType1(_ sender: GoDTypePopUpButton) {
		self.pokemon.type1 = sender.selectedValue
		
		
	}
	
	@IBAction func setType2(_ sender: GoDTypePopUpButton) {
		self.pokemon.type2 = sender.selectedValue
		
		
	}
	
	@IBAction func setAbility1(_ sender: GoDAbilityPopUpButton) {
		self.pokemon.ability1 = sender.selectedValue
		
		
	}
	
	@IBAction func setAbility2(_ sender: GoDAbilityPopUpButton) {
		self.pokemon.ability2 = sender.selectedValue
		
		
	}
	
	@IBAction func setItem1(_ sender: GoDItemPopUpButton) {
		self.pokemon.heldItem1 = sender.selectedValue
		
		
	}
	
	@IBAction func setItem2(_ sender: GoDItemPopUpButton) {
		self.pokemon.heldItem2 = sender.selectedValue
		
		
	}
	
	@IBAction func setExpRate(_ sender: GoDExpRatePopUpButton) {
		self.pokemon.levelUpRate = sender.selectedValue
		
		
	}
	
	@IBAction func setGenderRatio(_ sender: GoDGenderRatioPopUpButton) {
		self.pokemon.genderRatio = sender.selectedValue
		
		
	}
	
	@IBAction func setCatchRate(_ sender: NSTextField) {
		var value = sender.integerValue
		value = value < 0 ? 0 : value
		value = value > 255 ? 255 : value
		
		self.pokemon.catchRate = value
		
		
	}
	
	@IBAction func setHappiness(_ sender: NSTextField) {
		var value = sender.integerValue
		value = value < 0 ? 0 : value
		value = value > 255 ? 255 : value
		
		self.pokemon.baseHappiness = value
		
		
	}
	
	@IBAction func setBaseExp(_ sender: NSTextField) {
		var value = sender.integerValue
		value = value < 0 ? 0 : value
		value = value > 255 ? 255 : value
		
		self.pokemon.baseExp = value
		
		
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
		
	}
	
	
	@IBAction func save(_ sender: NSButton) {
		
		prepareForSave()
		self.pokemon.save()
		
		let current = self.mons[self.pokemon.index]
		self.mons[self.pokemon.index] = (self.pokemon.name.string, self.pokemon.type1, current.index)
		
		self.reloadViewWithActivity()
		self.table.reloadIndex(current.index)
		
		printg("saved updated stats:",self.pokemon.name)
	}
	
	
	//MARK: - TMs Delegate
	class TMTableDelegate: NSObject, GoDTableViewDelegate, NSTableViewDataSource {
		var delegate : GoDStatsViewController!
		
		var TMs = [XGTMs]()
		var Tutors = [XGTMs]()
		
		var width : NSNumber = 0
		
		init(delegate: GoDStatsViewController, width: NSNumber) {
			super.init()
			self.TMs = XGTMs.allTMs()
			
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
			
			let tm = XGTMs.tm(row + 1)
			
			let cell = (tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cell"), owner: self) ?? GoDTableCellView(title: "", colour: GoDDesign.colourBlack(), showsImage: false, image: nil, background: nil, fontSize: 12, width: self.width)) as! GoDTableCellView
			
			cell.setBackgroundImage(tm.move.type.image)
			if tm.move.isShadowMove {
				cell.setBackgroundImage(XGMoveTypes.shadowImage)
			}
			cell.setTitle(tm.move.name.string)
			cell.addBorder(colour: GoDDesign.colourBlack(), width: 1)
			
			cell.identifier = NSUserInterfaceItemIdentifier(rawValue: "cell")
			cell.translatesAutoresizingMaskIntoConstraints = false
			
			
			cell.alphaValue = delegate.pokemon.learnableTMs[row] ? 1 : 0.5
			
			
			return cell
		}
		
		func tableView(_ tableView: GoDTableView, didSelectRow row: Int) {
			if row >= 0 {
				if row < 58 {
					delegate.pokemon.learnableTMs[row]  = !delegate.pokemon.learnableTMs[row]
				} else {
					delegate.pokemon.tutorMoves[row - 58] = !delegate.pokemon.tutorMoves[row - 58]
				}
			}
			tableView.reloadData()
		}
		
		func tableView(tableView: NSTableView, didSelectRow row: Int) {
			if row >= 0 {
				if row < 58 {
					delegate.pokemon.learnableTMs[row]  = !delegate.pokemon.learnableTMs[row]
				} 
			}
			tableView.reloadData()
		}
		
		func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
			self.tableView(tableView: tableView, didSelectRow: row)
			return false
		}
	}
	
	//MARK: - Level Up Moves Delegate
	class LUMTableDelegate: NSObject, GoDTableViewDelegate, NSTableViewDataSource {
		
		var delegate : GoDStatsViewController!
		
		var width : NSNumber = 0
		
		init(delegate: GoDStatsViewController, width: NSNumber) {
			super.init()
			
			self.width = width
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
	}
	
}



