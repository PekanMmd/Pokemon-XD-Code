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

		#if GAME_PBR
		var textData =
		"""
		Hey there :-)
		
		Whenever you open this app, it automatically creates a bunch of folders in:
		"\(documentsPath)"
		
		Simply pop your ISO of "\(game.name)"
		into the folder called "ISO".
		Make sure you rename the ISO: "\(XGFiles.iso.fileName)".
		
		Once you've done this, come back to the app and click
		File -> Unpack ISO, then Extract Files
		from the menu bar to extract the necessary files from the ISO .
		
		This will take a minute or two but afterwards you'll be able to use this tool to modify the game.
		
		When you're satisfied with the changes, click
		File -> Import Files, then Build ISO
		to put all the files back in the ISO. You won't see any changes to the game itself until you do this.

		"""
		#else
		var textData =
		"""
		Please select an ISO to use with this tool by selecting
		File -> Open...

		You can also use the open menu to unzip individual .fsys archives
		or view individual .gtx, .atx and .msg files.

		"""
		#endif

		textData += "\n\nTwitter: @StarsMmd\nDiscord: @Stars#4434"

		text.stringValue = textData
    }
    
}
