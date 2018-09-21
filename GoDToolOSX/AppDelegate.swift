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
	
	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// Insert code here to initialize your application
		createDirectories()
		
	}
	
	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}
	
	@IBAction func setVerboseLogs(_ sender: Any) {
		verbose = true
	}
	
	@IBAction func setFastLogs(_ sender: Any) {
		verbose = false
	}
	
	
	
	@IBAction func extractISO(_ sender: Any) {
		printg("extracting iso")
		guard XGFiles.iso.exists else {
			let text = "ISO file doesn't exist. Please place your \(game == .XD ? "Pokemon XD" : "Pokemon Colosseum") file in the folder \(XGFolders.ISO.path) and name it \(XGFiles.iso.fileName)"
			printg("file \"\(XGFiles.iso.fileName)\" not in ISO folder")
			GoDAlertViewController.alert(title: "Error", text: text).show(sender: self.homeViewController)
			return
		}
		XGFolders.setUpFolderFormat()
		XGISO.extractAllFiles()
		
		if game == .Colosseum && XGFiles.common_rel.exists {
			let rel = XGFiles.common_rel.data
			var zero = false
			if region == .JP {
				zero = rel.get4BytesAtOffset(0x4580 + 0x9cf8 - 4) != 0
			}
			if region == .US {
				zero = rel.get4BytesAtOffset(0x784e0 + 0x13068 - 4) != 0
			}
			
			if zero {
				XGDolPatcher.zeroForeignStringTables()
			}
		}
		
		printg("extraction complete")
		GoDAlertViewController.alert(title: "ISO Extraction Complete", text: "Done.").show(sender: self.homeViewController)
	}
	
	@IBAction func quickBuildISO(_ sender: Any) {
		XGUtility.compileMainFiles()
		if commonTooLarge  {
			commonTooLarge = false
			compressionTooLarge = false
			if game == .XD {
				GoDAlertViewController.alert(title: "Quick Build Incomplete", text: "The compressed data for file \"common.rel\" is too large. Try using the patch to remove foreign languages.").show(sender: self.homeViewController)
			} else {
				GoDAlertViewController.alert(title: "Quick Build Incomplete", text: "The compressed data for file \"common.rel\" is too large. Try removing some pokemon from trainers or using the patch to remove all Battle mode data.").show(sender: self.homeViewController)
			}
		} else {
			GoDAlertViewController.alert(title: "Quick Build Complete", text: "Done.").show(sender: self.homeViewController)
		}
		
	}
	
	@IBAction func rebuildISO(_ sender: AnyObject) {
		XGUtility.compileAllFiles()
		if commonTooLarge  {
			commonTooLarge = false
			compressionTooLarge = false
			if game == .XD {
				GoDAlertViewController.alert(title: "Quick Build Incomplete", text: "The compressed data for file \"common.rel\" is too large. Try using the patch to remove foreign languages.").show(sender: self.homeViewController)
			} else {
				GoDAlertViewController.alert(title: "Quick Build Incomplete", text: "The compressed data for file \"common.rel\" is too large. Try removing some pokemon from trainers or using the patch to remove all Battle mode data.").show(sender: self.homeViewController)
			}
		} else {
			GoDAlertViewController.alert(title: "ISO Rebuild Complete", text: "Done.").show(sender: self.homeViewController)
		}
	}
	
	
	@IBAction func showAbout(_ sender: AnyObject) {
		let text = """
		Gale of Darkness Tool
		by @StarsMmd

		source code: https://github.com/PekanMmd/Pokemon-XD-Code.git
		"""
		GoDAlertViewController.alert(title: "About GoD Tool", text: text).show(sender: self.homeViewController)
	}
	
	@IBAction func showHelp(_ sender: Any) {
		self.homeViewController.performSegue(withIdentifier: NSStoryboardSegue.Identifier(rawValue: "toHelpVC"), sender: self.homeViewController)
	}
	
	func createDirectories() {
		XGFolders.setUpFolderFormat()
	}
	
}

