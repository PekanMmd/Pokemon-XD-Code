//
//  GoDHomeViewController.swift
//  GoD Tool
//
//  Created by StarsMmd on 01/07/2016.
//  Copyright © 2016 StarsMmd. All rights reserved.
//

import Cocoa

let xdtools = ["Trainer Editor","Shadow Pokemon Editor","Pokemon Stats Editor","Move Editor","Item Editor","Pokespot Editor","Gift Pokemon Editor", "Type Editor", "Treasure Editor", "Patches", "Randomiser", "Message Editor", "Script Compiler", "Collision Viewer", "Interaction Editor", "ISO Explorer"]
let xdsegues = ["toTrainerVC","toShadowVC","toStatsVC","toMoveVC","toItemVC","toSpotVC","toGiftVC", "toTypeVC", "toTreasureVC", "toPatchVC", "toRandomiserVC", "toMessageVC", "toScriptVC", "toCollisionVC", "toInteractionVC", "toISOVC"]

let colotools = ["Trainer Editor","Pokemon Stats Editor","Move Editor","Item Editor","Gift Pokemon Editor", "Type Editor", "Treasure Editor", "Patches", "Randomiser", "Message Editor", "Collision Viewer", "Interaction Editor", "ISO Explorer"]
let colosegues = ["toTrainerVC","toStatsVC","toMoveVC","toItemVC","toGiftVC", "toTypeVC", "toTreasureVC", "toPatchVC", "toRandomiserVC", "toMessageVC", "toCollisionVC", "toInteractionVC", "toISOVC"]

// The type editor doesn't seem to affect the game for some reason
let pbrtools = ["Pokemon Stats Editor", "Type Editor", "Message Editor", "Patches", "ISO Explorer"]
let pbrsegues = ["toStatsVC", "toTypeVC", "toMessageVC", "toPatchVC", "toISOVC"]

class GoDHomeViewController: GoDTableViewController {
	
	@IBOutlet var logView: NSTextView!
	
	var tools: [String] {
		switch game {
		case .Colosseum:
			return colotools
		case .XD:
			return xdtools
		case .PBR:
			return pbrtools
		}
	}
	var segues: [String] {
		switch game {
		case .Colosseum:
			return colosegues
		case .XD:
			return xdsegues
		case .PBR:
			return pbrsegues
		}
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		self.table.reloadData()
		
		if game == .Colosseum {
			self.title = "Colosseum Tool"
		}
		self.logView.setBackgroundColour(GoDDesign.colourLightBlue())
		
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
		
		let image = (row % 2 == 0 ? NSImage(named: "Item Cell") : NSImage(named: "Tool Cell"))!
		
		let view = (tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cell"), owner: self) ?? GoDTableCellView(title: tools[row], colour: GoDDesign.colourBlack(), background: image, fontSize: 14, width: widthForTable())) as! GoDTableCellView
		
		view.setTitle(tools[row])
		
		return view
	}
	
	override func tableView(_ tableView: GoDTableView, didSelectRow row: Int) {
		super.tableView(tableView, didSelectRow: row)
		guard row > -1, checkRequiredFiles() else {
			return
		}
		
		if row < segues.count {
			performSegue(withIdentifier: segues[row], sender: self)
		}
	}
	
	override func viewDidDisappear() {
		super.viewDidDisappear()
		NSApplication.shared.terminate(self)
	}
	
    @discardableResult
    private func checkRequiredFiles() -> Bool {
        if game != .PBR && !XGFiles.iso.exists {
			self.performSegue(withIdentifier: "toHelpVC", sender: self)
            return false
        }
        if game == .PBR && (!XGFiles.fsys("common").exists || !XGFiles.iso.exists) {
			self.performSegue(withIdentifier: "toHelpVC", sender: self)
            return false
        }
        return true
    }
}





