//
//  GoDTableViewController.swift
//  GoD Tool
//
//  Created by The Steez on 29/06/2016.
//  Copyright © 2016 StarsMmd. All rights reserved.
//

import AppKit

class GoDTableViewController: GoDViewController, GoDTableViewDelegate, NSTableViewDataSource {

	var table : GoDTableView!
	var currentIndexPath = IndexPath(item: 0, section: 0)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		

		self.table = GoDTableView(width: 200, rows: 100, rowHeight: 75, delegate: self, dataSource: self)
		self.table.translatesAutoresizingMaskIntoConstraints = false
		self.view.addSubview(table)
		self.views["table"] = table
		
		self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[table(200)]", options: [.alignAllTop, .alignAllBottom], metrics: nil, views: views))
		self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[table]|", options: [], metrics: nil, views: views))
		
		table.backgroundColor = NSColor.black
		
	}
	
	
	func numberOfRows(in tableView: NSTableView) -> Int {
		return 100
	}
	
	func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
		return 75
	}
	
	func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		let cell = tableView.make(withIdentifier: "cell", owner: self) ?? NSImageView(frame: NSMakeRect(0,0,200,0))
		
		cell.identifier = "cell"
		cell.translatesAutoresizingMaskIntoConstraints = false
		
		if cell.isKind(of: NSImageView.self) {
			
			let imageView = (cell as! NSImageView)
			
			imageView.imageAlignment = .alignCenter
			imageView.imageScaling = .scaleAxesIndependently
			imageView.image = row % 2 == 0 ? NSImage(named: "cell") : NSImage(named: "cell gold")
		}
		
		return cell
	}
	
	func tableView(_ tableView: GoDTableView, didSelectRow row: Int) {
		print(row)
	}
	
}
