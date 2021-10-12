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
	@IBOutlet weak var filePathLabel: NSTextField!

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "String Search"
		loadAllStrings(refresh: true)
	}
	
	@IBAction func findFreeID(_ sender: Any) {
		#if GAME_PBR
		freeid.stringValue = "\(PBRStringManager.messageDataTable.numberOfEntries + 1)"
		#else
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
		#endif
	}
	
	@IBAction func getString(_ sender: Any) {
		if let val = stringid.stringValue.integerValue {
			let msgString = getStringSafelyWithID(id: val)
			text.string = msgString.string
			#if !GAME_PBR
			filePathLabel.stringValue = msgString.table?.path ?? "File unknown"
			#else
			if let (tableID, _) = PBRStringManager.tableIDAndIndexForStringWithID(val),
			   let table = getStringTableWithId(tableID) {
				filePathLabel.stringValue =  table.file.path
			} else {
				filePathLabel.stringValue =  "File unknown"
			}
			#endif
		}
	}
	
	@IBAction func replaceString(_ sender: Any) {
		if let val = stringid.stringValue.integerValue {
			if val < 1 {
				GoDAlertViewController.displayAlert(title: "Replacement failed!", text: "Please enter a valid string id")
				return
			}
			if text.string.length > 0 {
				if !XGString(string: text.string, sid: val).replace() {
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
