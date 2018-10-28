//
//  AppDelegate.swift
//  GoD Tool
//
//  Created by StarsMmd on 29/06/2016.
//  Copyright © 2016 StarsMmd. All rights reserved.
//

import AppKit

let appDelegate = (NSApp.delegate as! AppDelegate)

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
	
	var homeViewController : GoDHomeViewController!
	
	@IBOutlet weak var decompileXDSMenuItem: NSMenuItem!
	@IBOutlet weak var scriptMenuItem: NSMenuItem!
	
	@IBOutlet weak var godtoolmenuitem: NSMenuItem!
	@IBOutlet weak var godtoolaboutmenuitem: NSMenuItem!
	@IBOutlet weak var quitgodtoolmenuitem: NSMenuItem!
	@IBOutlet weak var godtoolhelpmenuitem: NSMenuItem!
	
	
	
	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// Insert code here to initialize your application
		
		createDirectories()
		if game == .Colosseum {
			scriptMenuItem.isHidden = true
			godtoolmenuitem.title = "Colosseum Tool"
			godtoolaboutmenuitem.title = "About Colosseum Tool"
			quitgodtoolmenuitem.title = "Quit Colosseum Tool"
			godtoolhelpmenuitem.title = "Colosseum Tool Help"
		}
		
	}
	
	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}
	
	@IBAction func getFreeStringID(_ sender: Any) {
		guard !isSearchingForFreeStringID else {
			self.displayAlert(title: "Please wait", text: "Please wait for previous string id search to complete.")
			return
		}
		guard XGFiles.iso.exists else {
			let text = "ISO file doesn't exist. Please place your \(game == .XD ? "Pokemon XD" : "Pokemon Colosseum") file in the folder \(XGFolders.ISO.path) and name it \(XGFiles.iso.fileName)"
			
			self.displayAlert(title: "Error", text: text)
			return
		}
		XGThreadManager.manager.runInBackgroundAsync {
			if let id = freeMSGID() {
				XGThreadManager.manager.runInForegroundAsync {
					self.displayAlert(title: "Free String ID", text: "The next free id is: \(id) (\(id.hexString()))")
				}
			} else {
				XGThreadManager.manager.runInForegroundAsync {
					self.displayAlert(title: "Free String ID", text: "Failed to find a free string id")
				}
			}
		}
	}
	
	@IBAction func importTextures(_ sender: Any) {
		XGUtility.importTextures()
	}
	
	@IBAction func exportTextures(_ sender: Any) {
		XGUtility.exportTextures()
	}
	
	
	@IBAction func setVerboseLogs(_ sender: Any) {
		verbose = true
	}
	
	@IBAction func setFastLogs(_ sender: Any) {
		verbose = false
	}
	
	@IBOutlet weak var fileSizeMenuItem: NSMenuItem!
	
	@IBAction func deleteLogs(_ sender: Any) {
		for file in XGFolders.Logs.files where file.fileType == .txt {
			file.delete()
		}
	}
	
	
	
	@IBAction func toggleAllowIncreasedFileSizes(_ sender: Any) {
		increaseFileSizes = !increaseFileSizes
		if increaseFileSizes {
			printg("Enabled file size increases. This will stop the file importer from ignoring files that are larger than the original but importing might take a lot longer if the files are larger. Make sure your ISO has enough free space if using larger files.")
		}
		fileSizeMenuItem.title = increaseFileSizes ? "Disable File Size Increases" : "Enable File Size Increases"
	}
	
	
	@IBAction func extractISO(_ sender: Any) {
		printg("extracting iso")
		guard XGFiles.iso.exists else {
			let text = "ISO file doesn't exist. Please place your \(game == .XD ? "Pokemon XD" : "Pokemon Colosseum") file in the folder \(XGFolders.ISO.path) and name it \(XGFiles.iso.fileName)"
			printg("file \"\(XGFiles.iso.fileName)\" not in ISO folder")
			
			self.displayAlert(title: "Error", text: text)
			return
		}
		XGFolders.setUpFolderFormat()
		XGISO.extractAllFiles()
		
		if game == .Colosseum && XGFiles.common_rel.exists {
			let rel = XGFiles.common_rel.data!
			var zero = false
			if region == .JP {
				zero = rel.getWordAtOffset(0x4580 + 0x9cf8 - 4) != 0
			}
			if region == .US {
				zero = rel.getWordAtOffset(0x784e0 + 0x13068 - 4) != 0
			}
			
			if zero {
				XGDolPatcher.zeroForeignStringTables()
			}
		}
		
		printg("extraction complete")
		self.displayAlert(title: "ISO Extraction Complete", text: "Done.")
	}
	
	var isBuilding = false
	
	@IBAction func quickBuildISO(_ sender: Any) {
		guard !isBuilding else {
			self.displayAlert(title: "Please wait", text: "Please wait for previous build to complete.")
			return
		}
		isBuilding = true
		XGThreadManager.manager.runInBackgroundAsync {
			XGUtility.compileMainFiles()
			if filesTooLargeForReplacement != nil  {
				filesTooLargeForReplacement = nil
				var text = "Files too large to replace:"
				
				for file in filesTooLargeForReplacement! {
					text += "\n\(file.fileName)"
				}
				
				text += "\n\nSet 'ISO > Enable File Size Increases' to include them."
				
				XGThreadManager.manager.runInForegroundAsync {
					self.displayAlert(title: "Quick Build Incomplete", text: text)
				}
				
			} else {
				XGThreadManager.manager.runInForegroundAsync {
					self.displayAlert(title: "Done", text: "Quick build completed successfully!")
				}
			}
			self.isBuilding = false
		}
	}
	
	@IBAction func rebuildISO(_ sender: AnyObject) {
		guard !isBuilding else {
			self.displayAlert(title: "Please wait", text: "Please wait for previous build to complete.")
			return
		}
		isBuilding = true
		XGThreadManager.manager.runInBackgroundAsync {
			XGUtility.compileAllFiles()
			if filesTooLargeForReplacement != nil  {
				filesTooLargeForReplacement = nil
				var text = "Files too large to replace:"
				
				for file in filesTooLargeForReplacement! {
					text += "\n\(file.fileName)"
				}
				
				text += "\n\nSet 'ISO > Enable File Size Increases' to include them."
				
				XGThreadManager.manager.runInForegroundAsync {
					self.displayAlert(title: "Reuild Incomplete", text: text)
				}
			} else {
				XGThreadManager.manager.runInForegroundAsync {
					self.displayAlert(title: "Done", text: "ISO rebuild completed successfully!")
				}
			}
			self.isBuilding = false
		}
	
	}
	
	@IBAction func decompileXDS(_ sender: Any) {
		XGThreadManager.manager.runInBackgroundAsync {
			if game == .XD {
				XGUtility.documentXDS()
			}
		}
	}
	
	@IBAction func getXDSMacros(_ sender: Any) {
		XGThreadManager.manager.runInBackgroundAsync {
			if game == .XD {
				XGUtility.documentMacrosXDS()
			}
		}
	}
	
	@IBAction func showHexCalculator(_ sender: Any) {
		self.homeViewController.performSegue(withIdentifier: NSStoryboardSegue.Identifier(rawValue: "toHexCalcVC"), sender: self.homeViewController)
	}
	
	@IBAction func showStringIDTool(_ sender: Any) {
		self.performSegue("toStringVC")
	}
	
	func present(_ controller: NSViewController) {
		self.homeViewController.presentViewControllerAsModalWindow(controller)
	}
	
	
	@IBAction func showAbout(_ sender: AnyObject) {
		let text = """
		Gale of Darkness Tool
		by @StarsMmd

		source code: https://github.com/PekanMmd/Pokemon-XD-Code.git
		"""
		GoDAlertViewController.displayAlert(title: "About GoD Tool", text: text)
	}
	
	@IBAction func showHelp(_ sender: Any) {
		self.performSegue("toHelpVC")
	}
	
	func createDirectories() {
		XGFolders.setUpFolderFormat()
	}
	
	func displayAlert(title: String, text: String) {
		GoDAlertViewController.displayAlert(title: title, text: text)
	}
	
	var isDocumenting = false
	@IBAction func documentISO(_ sender: Any) {
		guard !isDocumenting else {
			return
		}
		isDocumenting = true
		XGThreadManager.manager.runInBackgroundAsync {
			XGUtility.documentISO(forXG: false)
			self.isDocumenting = false
		}
	}
	
	func performSegue(_ name: String) {
		guard XGFiles.iso.exists else {
			self.homeViewController.performSegue(withIdentifier: NSStoryboardSegue.Identifier("toHelpVC"), sender: self.homeViewController)
			return
		}
		self.homeViewController.performSegue(withIdentifier: NSStoryboardSegue.Identifier(name), sender: self.homeViewController)
	}
	
	@IBAction func openScriptCompiler(_ sender: Any) {
		self.performSegue("toScriptVC")
	}
	
	@IBAction func openStatsEditor(_ sender: Any) {
		self.performSegue("toStatsVC")
	}
	
	@IBAction func openMoveEditor(_ sender: Any) {
		self.performSegue("toMoveVC")
	}
	
	@IBAction func openGiftEditor(_ sender: Any) {
		self.performSegue("toGiftVC")
	}
	
	@IBAction func openPatchEditor(_ sender: Any) {
		self.performSegue("toPatchVC")
	}
	
	@IBAction func openContextTool(_ sender: Any) {
		self.performSegue("toContextVC")
	}
	
	@IBAction func openRandomiser(_ sender: Any) {
		self.performSegue("toRandomiserVC")
	}
	
	@IBAction func exporeISO(_ sender: Any) {
		self.performSegue("toISOVC")
	}
	
}






















