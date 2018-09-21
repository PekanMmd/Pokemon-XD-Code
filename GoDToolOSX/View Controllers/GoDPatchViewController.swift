//
//  GoDPatchViewController.swift
//  GoD Tool
//
//  Created by The Steez on 17/09/2017.
//
//

import Cocoa

let xdpatches = ["Apply Physical/Special move split","Remove Physical/Special move split","Assign default phys/spec categories to moves", "When a pokémon is KO'd it isn't replaced until the end of the turn","Remove foreign languages from common_rel (very useful if it gets too big to import)","Fix shiny glitch for shadow pokemon","Shadow pokemon can be shiny","Shadow pokemon are never shiny","Shadow pokemon are always shiny","Infinite use TMs", "Always show shadow pokemon natures", "Set Deoxys model to: Normal", "Set Deoxys model to: Attack", "Set Deoxys model to: Defense", "Set Deoxys model to: Speed","Allow female demo starter pokemon","Gen VII critical hit ratios"]
let colopatches = ["Apply Physical/Special move split","Assign default phys/spec categories to moves", "Delete Battle Mode Data. (highly recommended)", "Allow female starter pokemon","Gen VII critical hit ratios"]


class GoDPatchViewController: GoDTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
		self.title = "Patches"
    }
	
	let patches = game == .XD ? xdpatches : colopatches
	var funcs = game == .Colosseum ? [#selector(gen4Categories), #selector(defaultCategories), #selector(deleteBattleMode),  #selector(allowFemaleStarters),#selector(gen7CriticalRatios)] :
		[#selector(gen4Categories), #selector(removeGen4Categories), #selector(defaultCategories), #selector(endOfTurnSwitchIns), #selector(removeLanguages), #selector(fixShinyGlitch), #selector(randomShinyShadows), #selector(neverShinyShadows), #selector(alwaysShinyShadows), #selector(infiniteTMs), #selector(shadowNature), #selector(deoxysN), #selector(deoxysA), #selector(deoxysD), #selector(deoxysS), #selector(allowFemaleStarters),#selector(gen7CriticalRatios)]
	
	@objc func gen7CriticalRatios() {
		XGDolPatcher.gen7CritRatios()
	}
	
	@objc func allowFemaleStarters() {
		XGDolPatcher.allowFemaleStarters()
	}
	
	@objc func endOfTurnSwitchIns() {
		XGAssembly.switchNextPokemonAtEndOfTurn()
	}
	
	@objc func infiniteTMs() {
		XGAssembly.infiniteUseTMs()
	}
	
	@objc func shadowNature() {
		XGDolPatcher.alwaysShowShadowPokemonNature()
	}

	@objc func fixShinyGlitch() {
		XGAssembly.fixShinyGlitch()
	}
	
	@objc func alwaysShinyShadows() {
		XGAssembly.setShadowPokemonShininess(value: .always)
	}
	
	@objc func neverShinyShadows() {
		XGAssembly.setShadowPokemonShininess(value: .never)
	}
	
	@objc func randomShinyShadows() {
		XGAssembly.setShadowPokemonShininess(value: .random)
	}
	
	@objc func removeLanguages() {
		XGDolPatcher.applyPatch(.zeroForeignStringTables)
	}
	
	func oneStarter() {
		XGDolPatcher.applyPatch(.betaStartersRemove)
	}
	
	func twoStarters() {
		XGDolPatcher.applyPatch(.betaStartersApply)
	}
	
	@objc func removeGen4Categories() {
		XGDolPatcher.applyPatch(.physicalSpecialSplitRemove)
	}
	
	@objc func gen4Categories() {
		XGDolPatcher.applyPatch(.physicalSpecialSplitApply)
	}
	
	@objc func defaultCategories() {
		XGUtility.defaultMoveCategories()
	}
	
	@objc func deoxysN() {
		XGAssembly.setDeoxysForme(to: .normal)
	}
	
	@objc func deoxysA() {
		XGAssembly.setDeoxysForme(to: .attack)
	}
	
	@objc func deoxysD() {
		XGAssembly.setDeoxysForme(to: .defense)
	}
	
	@objc func deoxysS() {
		XGAssembly.setDeoxysForme(to: .speed)
	}
	
	@objc func deleteBattleMode() {
		XGDolPatcher.deleteBattleModeData()
	}
	
	override func numberOfRows(in tableView: NSTableView) -> Int {
		return patches.count
	}
	
	override func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		
		let colour = row % 2 == 0 ? GoDDesign.colourWhite() : GoDDesign.colourLightGrey()
		
		let view = (tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cell"), owner: self) ?? GoDTableCellView(title: patches[row], colour: GoDDesign.colourBlack(), showsImage: false, image: nil, background: nil, fontSize: 10, width: self.table.width)) as! GoDTableCellView
		
		view.setBackgroundColour(colour)
		view.setTitle(patches[row])
		
		return view
	}
	
	override func widthForTable() -> NSNumber {
		return 400
	}
	
	override func tableView(_ tableView: GoDTableView, didSelectRow row: Int) {
		if row == -1 {
			return
		}
		self.showActivityView { 
			self.performSelector(onMainThread: self.funcs[row], with: nil, waitUntilDone: true)
			self.hideActivityView()
		}
		
	}
	
}





