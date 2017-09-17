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
        // Do view setup here.
		self.title = "Patches"
    }
	
	var patches = ["Gen 4 Physical/Special Split","Assign default phys/spec categories to moves"]
	var funcs = [#selector(gen4Categories),#selector(defaultCategories),]
	
	
	func gen4Categories() {
		XGDolPatcher.applyPatch(.physicalSpecialSplitApply)
	}
	
	func defaultCategories() {
		XGUtility.defaultMoveCategories()
	}
	
	override func numberOfRows(in tableView: NSTableView) -> Int {
		return patches.count
	}
	
	override func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		
		let colour = row % 2 == 0 ? GoDDesign.colourWhite() : GoDDesign.colourGrey()
		
		let view = (tableView.make(withIdentifier: "cell", owner: self) ?? GoDTableCellView(title: patches[row], colour: GoDDesign.colourBlack(), showsImage: false, image: nil, background: nil, fontSize: 10, width: self.table.width)) as! GoDTableCellView
		
		view.setBackgroundColour(colour)
		view.setTitle(patches[row])
		
		return view
	}
	
	override func widthForTable() -> NSNumber {
		return 300
	}
	
	override func tableView(_ tableView: GoDTableView, didSelectRow row: Int) {
		self.showActivityView { 
			self.performSelector(onMainThread: self.funcs[row], with: nil, waitUntilDone: true)
			self.hideActivityView()
		}
		
	}
	
}





