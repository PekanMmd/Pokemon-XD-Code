//
//  main.swift
//  XGCommandLineTools
//
//  Created by StarsMmd on 13/11/2015.
//  Copyright © 2015 StarsMmd. All rights reserved.
//
//

import Foundation

loadISO(exitOnFailure: true)

XDProcess.launch(settings: [
	(key: .Dolphin(.Interface(.DebugModeEnabled)),"no"),
	(key: .Dolphin(.Core(.EnableCheats)),"no"),
	(key: .Dolphin(.Interface(.ConfirmStop)),"yes"),
], autoSkipWarningScreen: true) { (process) in

	print("Launched Dolphin Process")

	print("Skipping start up screens")
	process.inputHandler.input([
		.neutral(duration: 20),
		.button(.A),
		.neutral(duration: 1),
		.button(.A),
		.neutral(duration: 1),
		.button(.A),
		.neutral(duration: 3),
		.button(.UP),
		.neutral(duration: 1),
		.button(.A)
	])

	return true

} onFinish: {

	printg("Finished running XD Process")

} onRNGRoll: { (rngState, process, gameState) -> Bool in
	print("rng roll:", rngState.roll)

	return true
}

