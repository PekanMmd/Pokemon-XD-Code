//
//  GoDPatchViewController.swift
//  GoD Tool
//
//  Created by The Steez on 17/09/2017.
//
//

import Cocoa

let xdpatches = [
    "Remove foreign languages from common_rel. Required for some patches. Probably best to apply this first.",
	"Apply Physical/Special move split (You still need to set the category for each move)",
	"Remove Physical/Special move split",
	"Set the physical/special category for all moves to their expected values",
	"Start with 2 starter pokemon from demo (use gift pokemon editor)",
	"Go back to starting with 1 starter pokemon",
	"When a pokémon is KO'd it isn't replaced until the end of the turn",
	"The HM Flag on moves determines whether it is a shadow move or not (requires foreign languages to be removed.)",
	"Delete unused files (creates much needed space in the ISO)",
	"Fix shiny glitch for shadow pokemon",
	"Shadow pokemon can be shiny",
	"Shadow pokemon are never shiny",
	"Shadow pokemon are always shiny",
	"Infinite use TMs",
	"Always show shadow pokemon natures",
	"Set Deoxys model to: Normal",
	"Set Deoxys model to: Attack",
	"Set Deoxys model to: Defense",
	"Set Deoxys model to: Speed",
	"Allow female demo starter pokemon",
	"Gen VII critical hit ratios",
	"All tutor moves are available from the start",
	"Decapitalise text",
]
let colopatches = [
	"Apply Physical/Special move split (You still need to set the category for each move)",
	"Set the physical/special category for all moves to their expected values",
	"Delete Battle Mode Data. (highly recommended)",
	"Allow female starter pokemon",
	"Gen VII critical hit ratios",
	"Decapitalise text"
]


class GoDPatchViewController: GoDTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		self.title = "Patches"
    }
	
	let patches = game == .XD ? xdpatches : colopatches
	var funcs = game == .Colosseum ? [
		#selector(gen4Categories),
		#selector(defaultCategories),
		#selector(deleteBattleMode),
		#selector(allowFemaleStarters),
		#selector(gen7CriticalRatios),
		#selector(decapitalise),
		] :
		[
			#selector(removeLanguages),
			#selector(gen4Categories),
			#selector(removeGen4Categories),
			#selector(defaultCategories),
			#selector(enableBetaStarters),
			#selector(disableBetaStarters),
			#selector(endOfTurnSwitchIns),
			#selector(shadowHMFlag),
			#selector(deleteUnusedFiles),
			#selector(fixShinyGlitch),
			#selector(randomShinyShadows),
			#selector(neverShinyShadows),
			#selector(alwaysShinyShadows),
			#selector(infiniteTMs),
			#selector(shadowNature),
			#selector(deoxysN),
			#selector(deoxysA),
			#selector(deoxysD),
			#selector(deoxysS),
			#selector(allowFemaleStarters),
			#selector(gen7CriticalRatios),
			#selector(immediateTutorMoves),
			#selector(decapitalise),
	]

	@objc func enableBetaStarters() {
		XGDolPatcher.enableBetaStarters()
	}

	@objc func disableBetaStarters() {
		XGDolPatcher.disableBetaStarters()
	}
	
	@objc func decapitalise() {
		XGDolPatcher.decapitalise()
	}
	
	@objc func immediateTutorMoves() {
		XGDolPatcher.tutorMovesAvailableImmediately()
	}
	
	@objc func shadowHMFlag() {
		XGAssembly.setShadowMovesUseHMFlag()
	}
	
	var deletingSuper = false
	@objc func deleteUnusedFiles() {
		if deletingSuper { return }
		deletingSuper = true
		XGThreadManager.manager.runInBackgroundSync {
			XGUtility.deleteSuperfluousFiles()
			let text = "Successfully deleted unused files."
			XGThreadManager.manager.runInForegroundAsync {
				GoDAlertViewController.displayAlert(title: "Files deleted!", text: text)
			}
			self.deletingSuper = false
		}
		
	}
	
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
		
		let view = (tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cell"), owner: self) ?? GoDTableCellView(title: patches[row], colour: GoDDesign.colourBlack(), fontSize: 10, width: widthForTable())) as! GoDTableCellView
		
		view.setBackgroundColour(colour)
		view.setTitle(patches[row])
		view.titleField.maximumNumberOfLines = 0
		
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





