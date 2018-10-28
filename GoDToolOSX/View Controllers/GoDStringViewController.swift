//
//  GoDStringViewController.swift
//  GoD Tool
//
//  Created by The Steez on 24/10/2018.
//

import Cocoa

class GoDStringViewController: GoDViewController {

	@IBOutlet var text: NSTextView!
	@IBOutlet var stringid: NSTokenField!
	@IBOutlet var minimumid: NSTextField!
	@IBOutlet var freeid: NSTextField!
	
	
	@IBAction func findFreeID(_ sender: Any) {
		guard !isSearchingForFreeStringID else {
			GoDAlertViewController.displayAlert(title: "Please wait", text: "Please wait for previous string id search to complete.")
			return
		}
		if let val = minimumid.stringValue.integerValue {
			if let id = freeMSGID(from: val) {
				freeid.stringValue = id.string + " (\(id.hexString()))"
			} else {
				freeid.stringValue = "0"
			}
		}
	}
	
	@IBAction func getString(_ sender: Any) {
		if let val = stringid.stringValue.integerValue {
			text.string = getStringSafelyWithID(id: val).string
		}
	}
	
	@IBAction func replaceString(_ sender: Any) {
		if let val = stringid.stringValue.integerValue {
			if val < 1 {
				GoDAlertViewController.displayAlert(title: "Replacement failed!", text: "Please enter a valid string id")
				return
			}
			if text.string.length > 0 {
				if !XGString(string: text.string, file: nil, sid: val).replace() {
					GoDAlertViewController.displayAlert(title: "Replacement failed!", text: "The string could not be replaced")
				}
			} else {
				GoDAlertViewController.displayAlert(title: "Replacement failed!", text: "Please add some text to replace")
			}
		} else {
			GoDAlertViewController.displayAlert(title: "Replacement failed!", text: "Please enter a valid string id")
		}
	}
	
	
	
    
}
