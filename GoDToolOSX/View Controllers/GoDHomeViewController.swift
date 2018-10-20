//
//  GoDHomeViewController.swift
//  GoD Tool
//
//  Created by StarsMmd on 01/07/2016.
//  Copyright © 2016 StarsMmd. All rights reserved.
//

import Cocoa

let xdtools = ["Trainer Editor","Shadow Pokemon Editor","Pokemon Stats Editor","Move Editor","Item Editor (Incomplete)","Pokespot Editor","Gift Pokemon Editor", "Patches", "Randomiser", "Script Viewer", "Collision Viewer","Save Reference Data"]
let xdsegues = ["toTrainerVC","toShadowVC","toStatsVC","toMoveVC","toItemVC","toSpotVC","toGiftVC","toPatchVC","toRandomiserVC","toScriptVC", "toCollisionVC"]

let colotools = ["Trainer Editor","Pokemon Stats Editor","Move Editor","Item Editor (Incomplete)","Gift Pokemon Editor", "Patches", "Randomiser", "Collision Viewer","Save Reference Data"]
let colosegues = ["toTrainerVC","toStatsVC","toMoveVC","toItemVC","toGiftVC", "toPatchVC", "toRandomiserVC", "toCollisionVC"]

class GoDHomeViewController: GoDTableViewController {
	
	@IBOutlet var logView: NSTextView!
	
	let tools  = game == .XD ? xdtools : colotools
	let segues = game == .XD ? xdsegues : colosegues

    override func viewDidLoad() {
        super.viewDidLoad()
		self.table.reloadData()
		
		if game == .Colosseum {
			self.title = "Colosseum Tool"
		}
    }
	
	override func viewDidAppear() {
		super.viewDidAppear()
		
		(NSApp.delegate as! AppDelegate).homeViewController = self
		
		if !XGFiles.iso.exists {
			self.performSegue(withIdentifier: NSStoryboardSegue.Identifier(rawValue: "toHelpVC"), sender: self)
		}
	}
	
	override func numberOfRows(in tableView: NSTableView) -> Int {
		return tools.count
	}
	
	override func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
		return 50
	}
	
	override func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		
		let image = (row % 2 == 0 ? NSImage(named: NSImage.Name(rawValue: "Item Cell")) : NSImage(named: NSImage.Name(rawValue: "Tool Cell")))!
		
		let view = (tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cell"), owner: self) ?? GoDTableCellView(title: tools[row], colour: GoDDesign.colourBlack(), showsImage: false, image: nil, background: image, fontSize: 14, width: self.table.width)) as! GoDTableCellView
		
		view.setTitle(tools[row])
		
		return view
	}
	
	override func tableView(_ tableView: GoDTableView, didSelectRow row: Int) {
		if row == -1 {
			return
		}
		if !XGFiles.iso.exists || !XGFiles.common_rel.exists || !XGFiles.dol.exists {
			self.performSegue(withIdentifier: NSStoryboardSegue.Identifier(rawValue: "toHelpVC"), sender: self)
		} else if row < segues.count && row >= 0 {
			performSegue(withIdentifier: NSStoryboardSegue.Identifier(rawValue: segues[row]), sender: self)
		} else {
			XGUtility.documentISO(forXG: false)
		}
	}
	
	override func viewDidDisappear() {
		super.viewDidDisappear()
		NSApplication.shared.terminate(self)
	}
	
}





