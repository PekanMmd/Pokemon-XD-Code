//
//  GoDHomeViewController.swift
//  GoD Tool
//
//  Created by StarsMmd on 01/07/2016.
//  Copyright © 2016 StarsMmd. All rights reserved.
//

import Cocoa

let xdtools = ["Trainer Editor","Shadow Pokemon Editor","Pokemon Stats Editor","Move Editor","Item Editor","Pokespot Editor","Gift Pokemon Editor", "Type Editor", "Treasure Editor", "Patches", "Randomizer", "Message Editor", "Script Compiler", "Collision Viewer", "Interaction Editor", "Vertex Filters", "Universal Editor", "ISO Explorer"]
let xdsegues = ["toTrainerVC","toShadowVC","toStatsVC","toMoveVC","toItemVC","toSpotVC","toGiftVC", "toTypeVC", "toTreasureVC", "toPatchVC", "toRandomiserVC", "toMessageVC", "toScriptVC", "toCollisionVC", "toInteractionVC", "toFiltersVC", "toUniversalVC", "toISOVC"]

let colotools = ["Trainer Editor","Pokemon Stats Editor","Move Editor","Item Editor","Gift Pokemon Editor", "Type Editor", "Treasure Editor", "Patches", "Randomizer", "Message Editor", "Collision Viewer", "Interaction Editor", "Vertex Filters", "Universal Editor", "ISO Explorer"]
let colosegues = ["toTrainerVC","toStatsVC","toMoveVC","toItemVC","toGiftVC", "toTypeVC", "toTreasureVC", "toPatchVC", "toRandomiserVC", "toMessageVC", "toCollisionVC", "toInteractionVC", "toFiltersVC", "toUniversalVC", "toISOVC"]

let pbrtools = ["Pokemon Stats Editor", "Move Editor", "Type Editor", "Message Editor", "Randomizer", "Patches", "Universal Editor", "ISO Explorer"]
let pbrsegues = ["toStatsVC", "toMoveVC", "toTypeVC", "toMessageVC", "toRandomiserVC", "toPatchVC", "toUniversalVC", "toISOVC"]

let generaltools = ["ISO Explorer"]
let generalsegues = ["toISOVC"]

class GoDHomeViewController: GoDTableViewController {
	
	@IBOutlet var logView: NSTextView!
	
	var tools: [String] {
		if XGFiles.iso.exists && region == .OtherGame {
			return generaltools
		}
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
		guard region != .OtherGame else {
			return generalsegues
		}
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
	}
	
	override func numberOfRows(in tableView: NSTableView) -> Int {
		return tools.count
	}
	
	override func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
		return 50
	}
	
	override func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		let view = super.tableView(tableView, viewFor: tableColumn, row: row) as? GoDTableCellView

		view?.image = (row % 2 == 0 ? NSImage(named: "Item Cell") : NSImage(named: "Tool Cell"))
		view?.setTitle(tools[row])
		
		return view
	}
	
	override func tableView(_ tableView: GoDTableView, didSelectRow row: Int) {
		super.tableView(tableView, didSelectRow: row)
		guard row > -1, checkRequiredFiles() else {
			return
		}
		
		if row < segues.count {
			#if !canImport(Metal) || !canImport(GLKit)
			guard segues[row] != "toCollisionVC" else {
				GoDAlertViewController.displayAlert(title: "Not supported", text: "This tool isn't supported on this platform")
				return
			}
			#endif
			performSegue(withIdentifier: segues[row], sender: self)
		}
	}

	override func viewDidDisappear() {
		super.viewDidDisappear()
		NSApplication.shared.terminate(self)
	}
	
    @discardableResult
    func checkRequiredFiles() -> Bool {
		if XGISO.inputISOFile == nil || !XGFiles.iso.exists {
			if let appDelegate = (NSApplication.shared.delegate as? AppDelegate) {
				appDelegate.openFilePicker(self)
			} else {
				self.performSegue(withIdentifier: "toHelpVC", sender: self)
			}
			return false
        }
        if !XGFiles.iso.exists {
            return false
        }
        return true
    }

	func reload() {
		table.reloadData()
	}
}





