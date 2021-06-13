//
//  GoDWindowController.swift
//  GoD Tool
//
//  Created by Stars Momodu on 15/03/2021.
//

import Cocoa

class GoDWindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()

		if game == .Colosseum {
			window?.title = "Colosseum Tool"
		}
    }
}
