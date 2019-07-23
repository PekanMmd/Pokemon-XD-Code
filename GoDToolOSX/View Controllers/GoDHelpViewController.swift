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
		
		text.stringValue = game == PBR ?
		"""
			Hey there :-)
			
			Whenever you open this app, it automatically creates a bunch of folders in:
			"\(documentsPath)"
			
			Use Wit to extract the file system of Pokemon Battle Revolution
			>>\("./wit extract Pokemon\ Battle\ Revolution.iso")
			and copy any FSYS files you want into:
			\(XGFolders.FSYS.path)
			Make sure you you include common.fsys and mes_name_e.fsys.
			Also move "main.dol" into the DOL folder.
			
			Once you've done this, come back to the app and click
			Files -> Extract Files
			
			This may take a minute or two but afterwards you'll be able to use this tool to modify the game.
			
			When you're satisfied with the changes, click
			Files -> Import Files
			to put all the files back in their fsys archives. You won't see any changes to the game itself until you do this. Replace your edited .dol and .fsys files in your wit folder and rebuild the ISO with wit.
			
			which just compiles the important files to save time.
			
			Twitter: @StarsMmd
		"""
		:
		"""
		Hey there :-)
		
		Whenever you open this app, it automatically creates a bunch of folders in:
		"\(documentsPath)"
		
		Simply pop your ISO of
		\(game == .XD ? "Pokémon XD: Gale of Darkness" : "Pokemon Colosseum") (US version only)
		into the folder called "ISO".
		Make sure you rename the ISO: "\(XGFiles.iso.fileName)".
		
		Once you've done this, come back to the app and click
		ISO -> Extract ISO
		from the menu bar to extract the necessary files from the ISO .
		
		This will take a minute or two but afterwards you'll be able to use this tool to modify the game.
		
		When you're satisfied with the changes, click
		ISO -> Rebuild ISO
		to put all the files back in the ISO. You won't see any changes to the game itself until you do this.
		
		If you haven't changed anything like scripts, textures or game text you will probably be fine doing
		ISO -> Quick Build
		which just compiles the important files to save time.
		
		Twitter: @StarsMmd
		"""
    }
    
}
