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
        // Do view setup here.

		let extraction = game == .PBR ? "File -> Unpack ISO, then Extract Files"
									  : "File -> Extract ISO"

		let compilation = game == .PBR ? "File -> Import Files, then Build ISO"
									   : "File -> Rebuild ISO"
		
		var textData =
		"""
		Hey there :-)
		
		Whenever you open this app, it automatically creates a bunch of folders in:
		"\(documentsPath)"
		
		Simply pop your ISO of "\(game.name)"
		into the folder called "ISO".
		Make sure you rename the ISO: "\(XGFiles.iso.fileName)".
		
		Once you've done this, come back to the app and click
		\(extraction)
		from the menu bar to extract the necessary files from the ISO .
		
		This will take a minute or two but afterwards you'll be able to use this tool to modify the game.
		
		When you're satisfied with the changes, click
		\(compilation)
		to put all the files back in the ISO. You won't see any changes to the game itself until you do this.
		"""

		if game != .PBR {
			textData += """

			If you haven't changed anything like scripts, textures or game text you will probably be fine doing
			ISO -> Quick Build
			which just compiles the important files to save time.

			Twitter: @StarsMmd
			"""
		}

		text.stringValue = textData
    }
    
}
