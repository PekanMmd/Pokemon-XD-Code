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
	
	@IBAction func setDescription(_ sender: GoDMovePopUpButton) {
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
	
	
	@IBAction func setPocket(_ sender: Any) {
		currentItem.bagSlot = pocketPopupButton.selectedValue
	}
	
	@IBAction func save(_ sender: Any) {
		currentItem.canBeHeld = consumable.state == .on
		if let value = price.stringValue.integerValue {
			var price = value
			if value < 0 {
				price = 0
				self.price.stringValue = price.string
			}
			if value > 0xFFFF {
				price = 0xFFFF
				self.price.stringValue = price.string
			}
			currentItem.price = price
		} else {
			price.stringValue = currentItem.price.string
		}
		if let value = coupon.stringValue.integerValue {
			var price = value
			if value < 0 {
				price = 0
				self.coupon.stringValue = price.string
			}
			if value > 0xFFFF {
				price = 0xFFFF
				self.coupon.stringValue = price.string
			}
			currentItem.couponPrice = price
		} else {
			coupon.stringValue = currentItem.couponPrice.string
		}
		if let value = parameter.stringValue.integerValue {
			var val = value
			if value < 0 {
				val = 0
				self.parameter.stringValue = val.string
			}
			if value > 0xFF {
				val = 0xFF
				self.parameter.stringValue = val.string
			}
			currentItem.parameter = val
		} else {
			parameter.stringValue = currentItem.parameter.string
		}
		if let value = holdid.stringValue.integerValue {
			var val = value
			if value < 0 {
				val = 0
				self.holdid.stringValue = val.string
			}
			if value > 0xFF {
				val = 0xFF
				self.holdid.stringValue = val.string
			}
			currentItem.holdItemID = val
		} else {
			holdid.stringValue = currentItem.holdItemID.string
		}
		if let value = battleid.stringValue.integerValue {
			var val = value
			if value < 0 {
				val = 0
				self.battleid.stringValue = val.string
			}
			if value > 0xFF {
				val = 0xFF
				self.battleid.stringValue = val.string
			}
			currentItem.inBattleUseID = val
		} else {
			battleid.stringValue = currentItem.inBattleUseID.string
		}
		
		let friends = [friend1, friend2, friend3]
		for i in 0 ... 2 {
			let friend = friends[i]
			if let value = friend!.stringValue.integerValue {
				var val = value
				if value < 0 {
					val = 0
					friend!.stringValue = val.string
				}
				if value > 0xFF {
					val = 0xFF
					friend!.stringValue = val.string
				}
				currentItem.friendshipEffects[i] = val
			} else {
				holdid.stringValue = currentItem.holdItemID.string
			}
		}
		
		if let value = nameIDView.stringValue.integerValue {
			var val = value
			if value < 0 {
				val = 0
				self.nameIDView.stringValue = val.string
			}
			if value > kMaxStringID {
				val = kMaxStringID
				self.nameIDView.stringValue = val.string
			}
			currentItem.nameID = val
		} else {
			nameIDView.stringValue = currentItem.nameID.string
		}
		
		if let value = descriptionIDField.stringValue.integerValue {
			var val = value
			if value < 0 {
				val = 0
				self.descriptionIDField.stringValue = val.string
			}
			if value > kMaxStringID {
				val = kMaxStringID
				self.descriptionIDField.stringValue = val.string
			}
			currentItem.descriptionID = val
		} else {
			descriptionIDField.stringValue = currentItem.descriptionID.string
		}
		
		
		var id = self.descriptionIDField.stringValue
		if descriptionField.stringValue.length > 0 {
			if let val = id.integerValue {
				if let s = getStringWithID(id: val) {
					if !s.duplicateWithString(descriptionField.stringValue).replace() {
						descriptionField.stringValue = getStringSafelyWithID(id: val).string
					}
				}
			}
		}
		
		id = self.nameIDView.stringValue
		if nameView.stringValue.length > 0 {
			if let val = id.integerValue {
				if let s = getStringWithID(id: val) {
					if !s.duplicateWithString(nameView.stringValue).replace() {
						nameView.stringValue = getStringSafelyWithID(id: val).string
					}
				}
			}
		}
		
		currentItem.save()
		for tm in allTMsArray() {
			if tm.item.index == currentItem.index {
				tm.replaceWithMove(tmButton.selectedValue)
			}
		}
	}
	

	var items = allItemsArray().map { (item) -> String in
		return item.name.string
	}
	
	var currentItem = XGItem(index: 0) {
		didSet {
			self.reloadViewWithActivity()
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do view setup here.
		
		self.title = "Item Editor"
	}
	
	func reloadViewWithActivity() {
		self.showActivityView {
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
		descriptionField.stringValue = currentItem.descriptionString.string
		descriptionIDField.stringValue = currentItem.descriptionID.string
		
		consumable.state = currentItem.canBeHeld ? .on : .off
		pocketPopupButton.selectPocket(pocket: currentItem.bagSlot)
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
				tmButton.selectMove(move: tm.move)
				tmLabel.isHidden = false
			}
		}
		if !isTM {
			tmButton.isHidden = true
			tmLabel.isHidden = true
		}
		
	}
	
	override func numberOfRows(in tableView: NSTableView) -> Int {
		return kNumberOfItems
	}
	
	override func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
		return 50
	}
	
	override func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		
		let item = items[row]
		
		let cell = (tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cell"), owner: self) ?? GoDTableCellView(title: "", colour: GoDDesign.colourBlack(), showsImage: false, image: nil, background: NSImage(named: NSImage.Name(rawValue: "File Cell")), fontSize: 16, width: self.table.width)) as! GoDTableCellView
		
		cell.setTitle(item)
		
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
			self.currentItem = XGItem(index: row)
		}
		self.table.reloadData()
		self.table.tableView.selectRowIndexes([row], byExtendingSelection: false)
	}
	
}
