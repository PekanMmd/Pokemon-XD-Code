//
//  GoDHomeViewController.swift
//  GoD Tool
//
//  Created by StarsMmd on 01/07/2016.
//  Copyright © 2016 StarsMmd. All rights reserved.
//

import Cocoa

class GoDHomeViewController: GoDTableViewController {
	
	@IBOutlet var logView: NSTextView!
	
	let tools = ["Trainer Editor","Shadow Pokemon Editor","Pokemon Stats Editor","Move Editor","Item Editor (Incomplete)","Pokespot Editor","Gift Pokemon Editor","Patches", "Script Viewer", "Collision Viewer","Save Reference Data"]
	let segues = ["toTrainerVC","toShadowVC","toStatsVC","toMoveVC","toItemVC","toSpotVC","toGiftVC","toPatchVC","toScriptVC", "toCollisionVC"]

    override func viewDidLoad() {
        super.viewDidLoad()
		self.table.reloadData()
		
    }
	
	override func viewDidAppear() {
		super.viewDidAppear()
		
		(NSApp.delegate as! AppDelegate).homeViewController = self
		
		if !XGFiles.iso.exists {
			self.performSegue(withIdentifier: "toHelpVC", sender: self)
		}
	}
	
	override func numberOfRows(in tableView: NSTableView) -> Int {
		return tools.count
	}
	
	override func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
		return 50
	}
	
	override func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		
		let image = (row % 2 == 0 ? NSImage(named: "cell") : NSImage(named: "cell gold"))!
		
		let view = (tableView.make(withIdentifier: "cell", owner: self) ?? GoDTableCellView(title: tools[row], colour: GoDDesign.colourBlack(), showsImage: false, image: nil, background: image, fontSize: 14, width: self.table.width)) as! GoDTableCellView
		
		view.setTitle(tools[row])
		
		return view
	}
	
	override func tableView(_ tableView: GoDTableView, didSelectRow row: Int) {
		if !XGFiles.iso.exists || !XGFiles.common_rel.exists || !XGFiles.dol.exists {
			self.performSegue(withIdentifier: "toHelpVC", sender: self)
		} else if row < segues.count && row >= 0 {
			performSegue(withIdentifier: segues[row], sender: self)
		} else {
			XGUtility.documentISO(forXG: false)
		}
	}
	
	override func viewDidDisappear() {
		super.viewDidDisappear()
		NSApplication.shared().terminate(self)
	}
	
}





