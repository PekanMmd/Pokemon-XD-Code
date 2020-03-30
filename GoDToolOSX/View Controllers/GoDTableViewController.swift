//
//  GoDTableViewController.swift
//  GoD Tool
//
//  Created by StarsMmd on 29/06/2016.
//  Copyright © 2016 StarsMmd. All rights reserved.
//

import AppKit

class GoDTableViewController: GoDViewController, GoDTableViewDelegate, NSTableViewDataSource {

	var table : GoDTableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		

		self.table = GoDTableView(width: self.widthForTable(), rows: 0, rowHeight: 0, delegate: self, dataSource: self)
		self.table.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(table, name: "table")
		self.metrics["tableWidth"] = self.widthForTable()
		
		self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[table(tableWidth)]", options: [.alignAllTop, .alignAllBottom], metrics: metrics, views: views))
		self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[table]|", options: [], metrics: nil, views: views))
		
		table.backgroundColor = NSColor.black
		table.reloadData()
		
	}
	
	func widthForTable() -> NSNumber {
		return 200
	}
	
	func numberOfRows(in tableView: NSTableView) -> Int {
		return 0
	}
	
	func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
		return 40
	}
	
	func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cell"), owner: self) ?? NSImageView(frame: NSMakeRect(0,0,200,0))
		
		cell.identifier = NSUserInterfaceItemIdentifier(rawValue: "cell")
		cell.translatesAutoresizingMaskIntoConstraints = false
		
		if cell.isKind(of: NSImageView.self) {
			
			let imageView = (cell as! NSImageView)
			
			imageView.imageAlignment = .alignCenter
			imageView.imageScaling = .scaleAxesIndependently
			imageView.image = row % 2 == 0 ? NSImage(named: "cell") : NSImage(named: "Tool Cell")
		}
		
		return cell
	}
	
	func tableView(_ tableView: GoDTableView, didSelectRow row: Int) {
		self.table.selectedRow = row
		self.table.reloadData()
	}
	
	
}









