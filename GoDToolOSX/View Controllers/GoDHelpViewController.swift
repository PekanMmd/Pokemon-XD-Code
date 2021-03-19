//
//  GoDHelpViewController.swift
//  GoD Tool
//
//  Created by The Steez on 07/06/2018.
//

import Cocoa

class GoDHelpViewController: GoDViewController {

	@IBOutlet var text: NSTextField!
	
    override func viewDidLoad() {
        super.viewDidLoad()

		var textData =
		"""
		Please select an ISO to use with this tool by selecting
		File -> Open...

		You can also use the open menu to unzip individual .fsys archives
		or view individual .gtx, .atx and .msg files.

		"""

		textData += "\n\nTwitter: @StarsMmd\nDiscord: @Stars#4434"

		text.stringValue = textData
    }
    
}
