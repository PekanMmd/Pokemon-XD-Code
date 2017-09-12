//
//  AppDelegate.swift
//  XD Randomiser
//
//  Created by StarsMmd on 05/09/2017.
//
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// Insert code here to initialize your application
		
		XGFolders.setUpFolderFormatForRandomiser()
		
		if XGFiles.iso.exists {
			XGISO.extractRandomiserFiles()
		}
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}


}

