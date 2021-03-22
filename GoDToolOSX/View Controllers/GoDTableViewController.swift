//
//  GoDTableViewController.swift
//  GoD Tool
//
//  Created by StarsMmd on 29/06/2016.
//  Copyright © 2016 StarsMmd. All rights reserved.
//

import AppKit

class GoDTableViewController: GoDViewController, GoDTableViewDelegate, GoDTableViewDataSource {

	var table : GoDTableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()

		table = GoDTableView(width: widthForTable(), delegate: self, dataSource: self)
		view.addSubview(table)

		table.pinTop(to: view)
		table.pinLeading(to: view)
		table.pinBottom(to: view)
		table.pinWidth(as: widthForTable())
		
		table.backgroundColor = NSColor.black
		table.reloadData()
		
	}
	
	func widthForTable() -> CGFloat {
		return 200
	}
	
	func numberOfRows(in tableView: NSTableView) -> Int {
		return 0
	}
	
	func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
		return 40
	}
	
	func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		let view = (tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cell"), owner: self) ?? GoDTableCellView(title: "", colour: GoDDesign.colourBlack(), fontSize: 10, width: widthForTable())) as! GoDTableCellView
		
		view.identifier = NSUserInterfaceItemIdentifier(rawValue: "cell")
		view.translatesAutoresizingMaskIntoConstraints = false
		
		if table.selectedRow == row {
			view.addBorder(colour: GoDDesign.colourBlack(), width: 1)
		} else {
			view.removeBorder()
		}
		
		return view
	}
	
	func tableView(_ tableView: GoDTableView, didSelectRow row: Int) {}
	func tableView(_ tableView: GoDTableView, didSearchForText text: String) {}
	func searchBarBehaviourForTableView(_ tableView: GoDTableView) -> GoDSearchBarBehaviour {
		return .none
	}
}









