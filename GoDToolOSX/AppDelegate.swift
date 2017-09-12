//
//  AppDelegate.swift
//  GoD Tool
//
//  Created by StarsMmd on 29/06/2016.
//  Copyright © 2016 StarsMmd. All rights reserved.
//

import AppKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
	
	var currentViewController : GoDViewController!
	
	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// Insert code here to initialize your application
		
		createDirectories()
	}
	
	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}
	
	@IBAction func extractISO(_ sender: Any) {
		print("extracting iso")
		guard XGFiles.iso.exists else {
			print("file \"XD.iso\" not in ISO folder")
			return
		}
		
		XGISO.extractAllFiles()
		print("done")
		
	}
	
	@IBAction func quickBuildISO(_ sender: Any) {
		print("quick build iso")
	}
	
	@IBAction func rebuildISO(_ sender: AnyObject) {
		print("rebuild iso")
	}
	
	@IBAction func showHelp(_ sender: AnyObject) {
		print("show help")
	}
	
	
	@IBAction func showAbout(_ sender: AnyObject) {
		print("show about")
	}
	
	
	func createDirectories() {
		
		XGFolders.setUpFolderFormat()
		
	}
	
	
	
}

