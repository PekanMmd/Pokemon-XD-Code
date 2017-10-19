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
		nameIDView.integerValue = currentItem.nameID
		indexLabel.integerValue = currentItem.index
		hexLabel.stringValue = currentItem.index.hexString()
		startLabel.stringValue = currentItem.startOffset.hexString()
		
	}
	
	override func numberOfRows(in tableView: NSTableView) -> Int {
		return CommonIndexes.NumberOfItems.value
	}
	
	override func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
		return 50
	}
	
	override func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		
		let item = items[row]
		
		let cell = (tableView.make(withIdentifier: "cell", owner: self) ?? GoDTableCellView(title: "", colour: GoDDesign.colourBlack(), showsImage: false, image: nil, background: NSImage(named: "cell"), fontSize: 16, width: self.table.width)) as! GoDTableCellView
		
		cell.setTitle(item)
		
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
			self.currentItem = XGItem(index: row)
		}
		self.table.reloadData()
		self.table.tableView.selectRowIndexes([row], byExtendingSelection: false)
	}
	
}
