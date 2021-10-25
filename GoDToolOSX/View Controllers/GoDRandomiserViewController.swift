//
//  GoDRandomiserViewController.swift
//  GoD Tool
//
//  Created by The Steez on 15/09/2018.
//

import Cocoa

class GoDRandomiserViewController: GoDViewController {

	@IBOutlet var pspecies: NSButton!
	@IBOutlet var pmoves: NSButton!
	@IBOutlet var ptypes: NSButton!
	@IBOutlet var pabilities: NSButton!
	@IBOutlet var pstats: NSButton!
	@IBOutlet var pevolutions: NSButton!
	@IBOutlet var mtypes: NSButton!
	@IBOutlet var tmmoves: NSButton!
	@IBOutlet var bbingo: NSButton!
	@IBOutlet weak var items: NSButton!
	@IBOutlet weak var randomiseShadowsOnly: NSButton!
	@IBOutlet weak var randomiseByBST: NSButton!
	@IBOutlet var removeTrades: NSButton!


    override func viewDidLoad() {
        super.viewDidLoad()
		if game != .XD {
			bbingo.isHidden = true
		}
		if game == .PBR {
			randomiseShadowsOnly.title = "Only Randomise Rental Pass Pokemon"
			removeTrades.isHidden = true
			items.isHidden = true
		}
    }
	
	@IBAction func randomise(_ sender: Any) {

		let species = pspecies.state == .on
		let moves = pmoves.state == .on
		let types = ptypes.state == .on
		let abilities = pabilities.state == .on
		let stats = pstats.state == .on
		let evolutions = pevolutions.state == .on
		let moveTypes = mtypes.state == .on
		let tms = tmmoves.state == .on
		let boxes = items.state == .on
		let tradeEvos = removeTrades.state == .on
		let limit = randomiseShadowsOnly.state == .on
		let bst = randomiseByBST.state == .on

		#if GAME_XD
		let bingo = bbingo.state == .on
		#endif

		#if GUI
		let randomiserMessage = "The randomisation might take a while. \nTry not to save any changes with the other tools while the randomisation is in progress. There will be an alert when it is done."
		#else
		let randomiserMessage = "The randomisation might take a while. Please wait."
		#endif

		GoDAlertViewController.displayAlert(title: "Randomisation starting", text: randomiserMessage)

		XGThreadManager.manager.runInBackgroundAsync {
			XGUtility.deleteSuperfluousFiles()

			if species {
				XGRandomiser.randomisePokemon(limitToMainMons: limit, similarBST: bst)
			}
			if moves {
				XGRandomiser.randomiseMoves()
			}
			if types {
				XGRandomiser.randomiseTypes()
			}
			if abilities {
				XGRandomiser.randomiseAbilities()
			}
			if stats {
				XGRandomiser.randomisePokemonStats()
			}
			if evolutions {
				XGRandomiser.randomiseEvolutions()
			}
			if moveTypes {
				XGRandomiser.randomiseMoveTypes()
			}
			if tms {
				XGRandomiser.randomiseTMs()
			}

			#if GAME_XD
			if bingo {
				XGRandomiser.randomiseBattleBingo()
			}
			#endif
			#if !GAME_PBR
			if boxes {
				XGRandomiser.randomiseTreasureBoxes()
			}
			if tradeEvos {
				XGPatcher.removeTradeEvolutions()
				XGPatcher.removeItemEvolutions()
			}
			#endif

			XGUtility.compileMainFiles()
			GoDAlertViewController.displayAlert(title: "Randomisation complete!", text: "done.")
		}
	}
	
    
}








