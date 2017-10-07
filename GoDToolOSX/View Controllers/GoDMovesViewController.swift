//
//  GoDMovesViewController.swift
//  GoD Tool
//
//  Created by The Steez on 16/09/2017.
//
//

import Cocoa

class GoDMovesViewController: GoDTableViewController {
	
	@IBOutlet var name: NSTextField!
	@IBOutlet var nameID: NSTextField!
	@IBOutlet var index: NSTextField!
	@IBOutlet var hex: NSTextField!
	@IBOutlet var offset: NSTextField!
	
	@IBOutlet var type: GoDTypePopUpButton!
	@IBOutlet var category: GoDCategoryPopUpButton!
	@IBOutlet var targets: GoDTargetsPopUpButton!
	@IBOutlet var animation: GoDOriginalMovesPopUpButton!
	
	@IBOutlet var descID: NSTextField!
	@IBOutlet var desc: NSTextField!
	
	@IBOutlet var effect: GoDEffectsPopUpButton!
	
	@IBOutlet var power: NSTextField!
	@IBOutlet var accuracy: NSTextField!
	@IBOutlet var pp: NSTextField!
	@IBOutlet var priority: NSTextField!
	@IBOutlet var effectAcc: NSTextField!
	
	@IBOutlet var hm: NSButton!
	@IBOutlet var sound: NSButton!
	@IBOutlet var contact: NSButton!
	@IBOutlet var kings: NSButton!
	@IBOutlet var protect: NSButton!
	@IBOutlet var snatch: NSButton!
	@IBOutlet var magic: NSButton!
	@IBOutlet var mirror: NSButton!
	
	
	
	var moves = allMovesArray().map { (move) -> (name: String, type : XGMoveTypes, index : Int, isShadow: Bool) in
		return (move.name.string, move.type, move.index, move.isShadowMove)
	}
	
	var currentMove = XGMove(index: 0) {
		didSet {
			self.reloadViewWithActivity()
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
		
		self.title = "Move Editor"
		self.nameID.formatter = NumberFormatter.shortFormatter()
		self.descID.formatter = NumberFormatter.shortFormatter()
		self.priority.formatter = NumberFormatter.signedByteFormatter()
		self.pp.formatter = NumberFormatter.byteFormatter()
		self.power.formatter = NumberFormatter.byteFormatter()
		self.accuracy.formatter = NumberFormatter.byteFormatter()
		self.effectAcc.formatter = NumberFormatter.byteFormatter()
    }
	
	func reloadViewWithActivity() {
		self.showActivityView {
			self.reloadView()
			self.hideActivityView()
		}
	}
	
	func reloadView() {
		
		self.name.stringValue = currentMove.name.string
		self.nameID.integerValue = currentMove.nameID
		self.index.integerValue = currentMove.moveIndex
		self.hex.stringValue = currentMove.moveIndex.hexString()
		self.offset.integerValue = currentMove.startOffset
		
		self.descID.integerValue = currentMove.descriptionID
		self.desc.stringValue = currentMove.mdescription.string
		self.effect.selectItem(at: currentMove.effect)
		
		self.power.integerValue = currentMove.basePower
		self.priority.integerValue = currentMove.priority
		self.pp.integerValue = currentMove.pp
		self.accuracy.integerValue = currentMove.accuracy
		self.effectAcc.integerValue = currentMove.effectAccuracy
		
		self.animation.selectItem(at: currentMove.animationID)
		
		self.type.selectType(type: currentMove.type)
		self.targets.selectTarget(target: currentMove.target)
		self.category.selectCategory(category: currentMove.category)
		
		self.contact.state = currentMove.contactFlag ? NSOnState : NSOffState
		self.mirror.state = currentMove.mirrorMoveFlag ? NSOnState : NSOffState
		self.protect.state = currentMove.protectFlag ? NSOnState : NSOffState
		self.kings.state = currentMove.kingsRockFlag ? NSOnState : NSOffState
		self.magic.state = currentMove.magicCoatFlag ? NSOnState : NSOffState
		self.sound.state = currentMove.soundBasedFlag ? NSOnState : NSOffState
		self.snatch.state = currentMove.snatchFlag ? NSOnState : NSOffState
		self.hm.state = currentMove.HMFlag ? NSOnState : NSOffState
		
		
	}
	
	override func numberOfRows(in tableView: NSTableView) -> Int {
		return kNumberOfMoves
	}
	
	override func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
		return 50
	}
	
	override func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		
		let move = moves[row]
		
		let cell = (tableView.make(withIdentifier: "cell", owner: self) ?? GoDTableCellView(title: "", colour: GoDDesign.colourBlack(), showsImage: false, image: nil, background: nil, fontSize: 16, width: self.table.width)) as! GoDTableCellView
		
		cell.setBackgroundImage(move.isShadow ? XGMoveTypes.shadowImage : move.type.image)
		cell.setTitle(move.name)
		
		cell.identifier = "cell"
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
			self.currentMove = XGMove(index: row)
		}
		self.table.reloadData()
		self.table.tableView.selectRowIndexes([row], byExtendingSelection: false)
		
	}
	
	
	@IBAction func setMoveName(_ sender: NSTextField) {
		let newName = sender.stringValue
		
		if currentMove.name.duplicateWithString(newName).replace() {
			self.moves[currentMove.moveIndex].name = newName
		}
		
		self.reloadViewWithActivity()
		self.table.reloadData()
	}
	
	@IBAction func setMoveNameID(_ sender: NSTextField) {
		
		let id = sender.integerValue
		
		self.currentMove.nameID = id
		
		self.reloadViewWithActivity()
		self.table.reloadData()
	}
	
	@IBAction func setDescriptionID(_ sender: NSTextField) {
		
		let id = sender.integerValue
		
		self.currentMove.descriptionID = id
		
		self.reloadViewWithActivity()
		
	}
	
	@IBAction func setMoveDescription(_ sender: NSTextField) {
		
		let newDesc = sender.stringValue
		
		currentMove.mdescription.duplicateWithString(newDesc).replace()
		
		self.reloadViewWithActivity()
		
	}
	
	@IBAction func newType(_ sender: GoDTypePopUpButton) {
		let value = sender.selectedValue
		
		self.currentMove.type = value
	}
	
	@IBAction func newCategory(_ sender: GoDCategoryPopUpButton) {
		let value = sender.selectedValue
		
		self.currentMove.category = value
	}
	
	@IBAction func newTargets(_ sender: GoDTargetsPopUpButton) {
		let value = sender.selectedValue
		
		self.currentMove.target = value
	}
	
	@IBAction func newAnimation(_ sender: GoDOriginalMovesPopUpButton) {
		let value = sender.indexOfSelectedItem
		
		self.currentMove.animationID = value
		self.currentMove.animation2ID = value - (value < 0x164 ? 0 : 1)
	}
	
	@IBAction func newEffect(_ sender: GoDEffectsPopUpButton) {
		let value = sender.selectedValue
		
		self.currentMove.effect = value
	}
	
	@IBAction func newPower(_ sender: NSTextField) {
		let value = sender.integerValue
		
		self.currentMove.basePower = value
	}
	
	@IBAction func newAccuracy(_ sender: NSTextField) {
		let value = sender.integerValue
		
		self.currentMove.accuracy = value
	}
	
	@IBAction func newPP(_ sender: NSTextField) {
		let value = sender.integerValue
		
		self.currentMove.pp = value
	}
	
	@IBAction func newPriority(_ sender: NSTextField) {
		let value = sender.integerValue
		
		self.currentMove.priority = value
	}
	
	@IBAction func newEffectAcc(_ sender: NSTextField) {
		let value = sender.integerValue
		
		self.currentMove.effectAccuracy = value
	}
	
	@IBAction func toggleHMFlag(_ sender: NSButton) {
		let value = sender.state == NSOnState
		
		self.currentMove.HMFlag = value
	}
	
	@IBAction func toggleSound(_ sender: NSButton) {
		let value = sender.state == NSOnState
		
		self.currentMove.soundBasedFlag = value
	}
	
	@IBAction func toggleContact(_ sender: NSButton) {
		let value = sender.state == NSOnState
		
		self.currentMove.contactFlag = value
	}
	
	@IBAction func toggleKings(_ sender: NSButton) {
		let value = sender.state == NSOnState
		
		self.currentMove.kingsRockFlag = value
	}
	
	@IBAction func toggleProtect(_ sender: NSButton) {
		let value = sender.state == NSOnState
		
		self.currentMove.protectFlag = value
	}
	
	@IBAction func toggleSnatch(_ sender: NSButton) {
		let value = sender.state == NSOnState
		
		self.currentMove.snatchFlag = value
	}
	
	@IBAction func toggleMagic(_ sender: NSButton) {
		let value = sender.state == NSOnState
		
		self.currentMove.magicCoatFlag = value
	}
	
	@IBAction func toggleMirror(_ sender: NSButton) {
		let value = sender.state == NSOnState
		
		self.currentMove.mirrorMoveFlag = value
	}
	
	@IBAction func save(_ sender: Any) {
		self.currentMove.save()
		
		self.moves[currentMove.moveIndex].name = self.currentMove.name.string
		self.moves[currentMove.moveIndex].isShadow = self.currentMove.isShadowMove
		self.moves[currentMove.moveIndex].type = self.currentMove.type
		
		self.reloadViewWithActivity()
		self.table.reloadData()
	}
	
}

































