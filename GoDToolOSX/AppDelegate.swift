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
	
	@IBAction func extractISO(_ sender: Any) {
		printg("extracting iso")
		guard XGFiles.iso.exists else {
			printg("file \"XD.iso\" not in ISO folder")
			return
		}
		
		XGFolders.setUpFolderFormat()
		XGISO.extractAllFiles()
		GoDAlertViewController.alert(title: "ISO Extraction Complete", text: "Done.").show(sender: self.homeViewController)
		
	}
	
	@IBAction func quickBuildISO(_ sender: Any) {
		
		XGUtility.compileMainFiles()
		GoDAlertViewController.alert(title: "Quick Build Complete", text: "Done.").show(sender: self.homeViewController)
	}
	
	@IBAction func rebuildISO(_ sender: AnyObject) {
		XGUtility.compileAllFiles()
		GoDAlertViewController.alert(title: "ISO Rebuild Complete", text: "Done.").show(sender: self.homeViewController)
	}
	
	
	@IBAction func showAbout(_ sender: AnyObject) {
		let text = """
		Gale of Darkness Tool
		by @StarsMmd

		
			
		"""
		GoDAlertViewController.alert(title: "About GoD Tool", text: text).show(sender: self.homeViewController)
	}
	
	
	func createDirectories() {
		
		XGFolders.setUpFolderFormat()
		
	}
	
	
	
}

