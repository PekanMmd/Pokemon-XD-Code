//
//  GoDItemViewController.swift
//  GoD Tool
//
//  Created by The Steez on 30/09/2017.
//
//

import Cocoa

class GoDItemViewController: GoDTableViewController {
	
	@IBOutlet var nameView: NSTextField!
	@IBOutlet var nameIDView: NSTextField!
	@IBOutlet var indexLabel: NSTextField!
	@IBOutlet var hexLabel: NSTextField!
	@IBOutlet var startLabel: NSTextField!
	@IBOutlet var descriptionIDField: NSTextField!
	@IBOutlet var descriptionField: NSTextField!
	
	@IBAction func setDescription(_ sender: AnyObject) {
		self.descriptionField.stringValue = XGTMs.createItemDescriptionForMove(self.tmButton.selectedValue)
	}
	
	@IBOutlet var consumable: NSButton!
	@IBOutlet var pocketPopupButton: GoDPocketPopUpButton!
	@IBOutlet var price: NSTextField!
	@IBOutlet var coupon: NSTextField!
	@IBOutlet var parameter: NSTextField!
	@IBOutlet var holdid: NSTextField!
	@IBOutlet var battleid: NSTextField!
	@IBOutlet var friend1: NSTextField!
	@IBOutlet var friend2: NSTextField!
	@IBOutlet var friend3: NSTextField!
	
	@IBOutlet var tmButton: GoDMovePopUpButton!
	@IBOutlet var tmLabel: NSTextField!

	var currentItem = XGItem(index: 0) {
		didSet {
			self.reloadViewWithActivity()
		}
	}

	var filteredItems = [XGItems]()
	var allItems = {
		XGItems.allItems()
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Item Editor"
		filteredItems = allItems
		table.setShouldUseIntercellSpacing(to: true)
		table.reloadData()
	}
	
	
	@IBAction func setPocket(_ sender: Any) {
		currentItem.bagSlot = pocketPopupButton.selectedValue
	}
	
	func sanitise(_ value: Int?, bytes: Int) -> Int {
		guard let val = value else {
			return 0
		}
		if val < 0 {
			return 0
		}
		let max = bytes == 2 ? 0xFFFF : 0xFF
		return min(val, max)
	}
	
	@IBAction func save(_ sender: Any) {
		currentItem.canBeHeld = consumable.state == .on
		
		currentItem.price = sanitise(price.stringValue.integerValue, bytes: 2)
		currentItem.couponPrice = sanitise(coupon.stringValue.integerValue, bytes: 2)
		currentItem.parameter = sanitise(parameter.stringValue.integerValue, bytes: 1)
		currentItem.holdItemID = sanitise(holdid.stringValue.integerValue, bytes: 1)
		currentItem.inBattleUseID = sanitise(battleid.stringValue.integerValue, bytes: 1)
		
		let friends = [friend1, friend2, friend3]
		for i in 0 ... 2 {
			let friend = friends[i]!
			currentItem.friendshipEffects[i] = sanitise(friend.stringValue.integerValue, bytes: 1)
		}
		
		var nameUpdate = false
		if let value = nameIDView.stringValue.integerValue {
			var val = value
			val = max(val, 0)
			val = min(val, kMaxStringID)
			currentItem.nameID = val
			
			if nameView.stringValue.length > 0 && val > 0 {
				let string = XGString(string: nameView.stringValue, file: nil, sid: val)
				if !XGFiles.common_rel.stringTable.addString(string, increaseSize: true, save: true) {
					printg("couldn't replace string in common.rel:", string.string)
				} else {
					nameUpdate = true
				}
				let pocket = XGFiles.typeAndFsysName(.msg, "pocket_menu")
				if pocket.exists {
					if !pocket.stringTable.addString(string, increaseSize: true, save: true) {
						printg("couldn't replace string in pocket_menu.msg:", string.string)
					}
				} else {
					printg("couldn't save name in pocket_menu.msg as it doesn't exist, extract all files and save again.")
				}
			}
			
		}
		
		if let value = descriptionIDField.stringValue.integerValue {
			var val = value
			val = max(val, 0)
			val = min(val, kMaxStringID)
			currentItem.descriptionID = val
			
			if descriptionField.stringValue.length > 0 && val > 0 {
				let string = XGString(string: descriptionField.stringValue, file: nil, sid: val)
				let pocket = XGFiles.typeAndFsysName(.msg, "pocket_menu")
				if pocket.exists {
					if !pocket.stringTable.addString(string, increaseSize: true, save: true) {
						printg("couldn't replace string in pocket_menu.msg:", string.string)
					}
				} else {
					printg("couldn't save description in pocket_menu.msg as it doesn't exist, extract all files and save again.")
				}
			}
		}
		
		
		currentItem.save()
		for tm in allTMsArray() {
			if tm.item.index == currentItem.index {
				tm.replaceWithMove(tmButton.selectedValue)
			}
		}
		reloadViewWithActivity()
		if nameUpdate {
			table.reloadData()
		}
	}
	
	func reloadViewWithActivity() {
		showActivityView {
			self.reloadView()
			self.hideActivityView()
		}
	}
	
	func reloadView() {
		
		nameView.stringValue = currentItem.name.string
		nameIDView.stringValue = currentItem.nameID.string
		indexLabel.stringValue = currentItem.index.string
		hexLabel.stringValue = currentItem.index.hexString()
		startLabel.stringValue = currentItem.startOffset.hexString()
		descriptionField.stringValue = currentItem.descriptionString.stringWithEscapedNewlines
		descriptionIDField.stringValue = currentItem.descriptionID.string
		
		consumable.state = currentItem.canBeHeld ? .on : .off
		pocketPopupButton.select(currentItem.bagSlot)
		price.stringValue = currentItem.price.string
		coupon.stringValue = currentItem.couponPrice.string
		parameter.stringValue = currentItem.parameter.string
		holdid.stringValue = currentItem.holdItemID.string
		battleid.stringValue = currentItem.inBattleUseID.string
		friend1.stringValue = currentItem.friendshipEffects[0].string
		friend2.stringValue = currentItem.friendshipEffects[1].string
		friend3.stringValue = currentItem.friendshipEffects[2].string
		
		var isTM = false
		for tm in allTMsArray() {
			if isTM { continue }
			if tm.item.index == currentItem.index {
				isTM = true
				tmButton.isHidden = false
				tmButton.select(tm.move)
				tmLabel.isHidden = false
			}
		}
		if !isTM {
			tmButton.isHidden = true
			tmLabel.isHidden = true
		}
	}
	
	override func numberOfRows(in tableView: NSTableView) -> Int {
		return filteredItems.count
	}
	
	override func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
		return 50
	}
	
	override func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		
		let item = filteredItems[row]
		
		let cell = super.tableView(tableView, viewFor: tableColumn, row: row) as? GoDTableCellView

		var colour = GoDDesign.colourWhite()
		switch item.data.bagSlot {
		case .none:
			colour = GoDDesign.colourWhite()
		case .pokeballs:
			colour = GoDDesign.colourRed()
		case .items:
			colour = GoDDesign.colourYellow()
		case .berries:
			colour = GoDDesign.colourGreen()
		case .tms:
			colour = GoDDesign.colourBlue()
		case .keyItems:
			colour = GoDDesign.colourPurple()
		case .colognes:
			colour = GoDDesign.colourPink()
		case .battleCDs:
			colour = GoDDesign.colourGrey()
		}
		cell?.setBackgroundColour(colour)
		
		cell?.setTitle(item.name.string)

		if table.selectedRow == row {
			cell?.addBorder(colour: GoDDesign.colourWhite(), width: 1)
		} else {
			cell?.removeBorder()
		}

		return cell
	}
	
	override func tableView(_ tableView: GoDTableView, didSelectRow row: Int) {
		if row >= 0 {
			let item = filteredItems[row]
			self.currentItem = XGItem(index: item.index)
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
			filteredItems = allItems
			return
		}

		filteredItems = allItems.filter({ (item) -> Bool in
			let data = item.data
			return item.name.string.simplified.contains(text.simplified)
				|| item.index == text.integerValue
				|| item.TMIndex == text.integerValue
				|| data.inBattleUseID == text.integerValue
				|| data.holdItemID == text.integerValue
		})
	}
}
