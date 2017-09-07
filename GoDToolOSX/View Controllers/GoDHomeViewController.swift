//
//  GoDHomeViewController.swift
//  GoD Tool
//
//  Created by The Steez on 01/07/2016.
//  Copyright © 2016 StarsMmd. All rights reserved.
//

import Cocoa

class GoDHomeViewController: GoDTableViewController {
	
	let tools = ["Pokemon Stats Editor"]
	let segues = ["toStatsVC"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	override func numberOfRows(in tableView: NSTableView) -> Int {
		return tools.count
	}
	
//	func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
//		return 50
//	}
	
	override func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		
		let image = (row % 2 == 0 ? NSImage(named: "cell") : NSImage(named: "cell gold"))!
		
		let view = (tableView.make(withIdentifier: "cell", owner: self) ?? GoDTableCellView(title: tools[row], colour: GoDDesign.colourBlack(), showsImage: false, image: nil, background: image, fontSize: 16, width: self.table.frame.width)) as! GoDTableCellView
		
		
		view.setTitle(tools[row])
		
		return view
	}
	
	override func tableView(_ tableView: GoDTableView, didSelectRow row: Int) {
		if row < segues.count && row >= 0 {
			performSegue(withIdentifier: segues[row], sender: self)
		}
	}
    
}
