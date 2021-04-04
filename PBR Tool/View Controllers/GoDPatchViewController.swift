//
//  GoDPatchViewController.swift
//  GoD Tool
//
//  Created by The Steez on 17/09/2017.
//
//

import Cocoa

class GoDPatchViewController: GoDTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		self.title = "Patches"
    }
	
	let patches = [
		"Move type matchup table to location with more space",
		"Disable rental pass checksums (prevents bad eggs)",
		"Disable visual blur effect"
	]

	var funcs = [
		#selector(moveTypeMatchupsTable),
		#selector(disableRentalPassChecksums),
		#selector(disableBlur)
	]
	
	@objc func moveTypeMatchupsTable() {
		XGPatcher.moveTypeMatchupsTableToPassValidationFunction()
	}

	@objc func disableRentalPassChecksums() {
		XGPatcher.disableRentalPassChecksums()
	}

	@objc func disableBlur() {
		XGPatcher.disableBlurEffect()
	}
	
	override func numberOfRows(in tableView: NSTableView) -> Int {
		return patches.count
	}
	
	override func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		
		let colour = row % 2 == 0 ? GoDDesign.colourWhite() : GoDDesign.colourLightGrey()
		
		let view = (tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cell"), owner: self) ?? GoDTableCellView(title: patches[row], colour: GoDDesign.colourBlack(), fontSize: 10, width: widthForTable())) as! GoDTableCellView
		
		view.setBackgroundColour(colour)
		view.setTitle(patches[row])
		
		return view
	}
	
	override func widthForTable() -> CGFloat {
		return 400
	}
	
	override func tableView(_ tableView: GoDTableView, didSelectRow row: Int) {
		super.tableView(tableView, didSelectRow: row)
		if row == -1 {
			return
		}
		if settings.verbose {
			printg("Selected patch:", self.patches[row])
		}
		self.showActivityView {
			self.performSelector(onMainThread: self.funcs[row], with: nil, waitUntilDone: true)
			self.hideActivityView()
			printg("Patch completed")
		}
		
	}
}





