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
		if let val = minimumid.stringValue.integerValue {
			if let id = freeMSGID(from: val) {
				freeid.stringValue = id.string
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
				GoDAlertViewController.alert(title: "Replacement failed!", text: "Please enter a valid string id").show(sender: self)
				return
			}
			if text.string.length > 0 {
				if !XGString(string: text.string, file: nil, sid: val).replace() {
					GoDAlertViewController.alert(title: "Replacement failed!", text: "The string could not be replaced").show(sender: self)
				}
			} else {
				GoDAlertViewController.alert(title: "Replacement failed!", text: "Please add some text to replace").show(sender: self)
			}
		} else {
			GoDAlertViewController.alert(title: "Replacement failed!", text: "Please enter a valid string id").show(sender: self)
		}
	}
	
	
	
    
}
