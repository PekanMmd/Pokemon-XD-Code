//
//  GoDMessageViewController.swift
//  GoD Tool
//
//  Created by The Steez on 14/04/2019.
//

import Cocoa

class GoDMessageViewController: GoDTableViewController {
	
	@IBOutlet var filesPopup: GoDPopUpButton!
	@IBOutlet var stringIDLabel: NSTextField!
	@IBOutlet var stringIDField: NSTextField!
	@IBOutlet var messageField: NSTextView!
	@IBOutlet var saveButton: NSButton!
	@IBOutlet var messageScrollView: NSScrollView!

	var currentTable : XGStringTable? {
		didSet {
			setUpForFile()
		}
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		loadAllStrings()
		self.filesPopup.setTitles(values: ["-"] + allStringTables.map { $0.file.fileName }.sorted())
		self.hideInterface()
    }
	
	func hideInterface() {
		let views : [NSView] = [stringIDField, stringIDLabel, messageScrollView, saveButton]
		for view in views {
			view.isHidden = true
		}
	}
	
	func showInterface() {
		let views : [NSView] = [stringIDField, stringIDLabel, messageScrollView, saveButton]
		for view in views {
			view.isHidden = false
		}
	}
	
	func setUpForFile() {
		self.stringIDField.stringValue = ""
		self.messageField.string = ""
		hideInterface()
		self.table.reloadData()
	}
	
	@IBAction func setFile(_ sender: GoDPopUpButton) {
		guard sender.indexOfSelectedItem > 0 else {
			currentTable = nil
			return
		}
		currentTable = allStringTables.sorted { $0.file.fileName < $1.file.fileName }[sender.indexOfSelectedItem - 1]
	}
	
	@IBAction func save(_ sender: Any) {
		guard let table = currentTable else {
			GoDAlertViewController.displayAlert(title: "Error", text: "No File selected")
			return
		}
		
		if let stringID = stringIDField.stringValue.integerValue {
			
			let message = messageField.string == "" ? "-" : messageField.string
			let string = XGString(string: message, file: table.file, sid: stringID)
			let operation = table.containsStringWithId(stringID) ? "replacing" : "adding"
			let success = table.addString(string, increaseSize: true, save: true)
			let successMessage = success ? "Completed" : "Failed"
			let successTitle = success ? "Success" : "Failure"
			GoDAlertViewController.displayAlert(title: successTitle, text: "\(successMessage) \(operation) id: \(stringID) message: \(message) to \(table.file.path)")
			self.table.reloadData()
			
		} else {
			GoDAlertViewController.displayAlert(title: "Error", text: "Please enter a valid string ID")
		}
	}
	
	override func numberOfRows(in tableView: NSTableView) -> Int {
		return currentTable?.numberOfEntries ?? 0
	}
	
	override func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
		return 50
	}
	
	override func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		
		let cell = (tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cell"), owner: self) ?? GoDTableCellView(title: "", colour: GoDDesign.colourBlack(), showsImage: false, image: nil, background: nil, fontSize: 12, width: self.table.width)) as! GoDTableCellView
		
		guard let currentTable = currentTable else {
			return cell
		}

		let id = currentTable.stringIDs[row]
		let string = currentTable.stringSafelyWithID(id)
		cell.setTitle(string.id.hexString() + ": " + string.unformattedString)
		cell.titleField.maximumNumberOfLines = 3
		cell.addBorder(colour: GoDDesign.colourBlack(), width: 1)
		
		if self.table.selectedRow == row {
			cell.setBackgroundColour(GoDDesign.colourLightBlue())
		} else {
			cell.setBackgroundColour(GoDDesign.colourWhite())
		}
		
		return cell
	}
	
	override func tableView(_ tableView: GoDTableView, didSelectRow row: Int) {
		super.tableView(tableView, didSelectRow: row)
		if row >= 0 {
			guard let table = currentTable else {
				return
			}

			let id = table.stringIDs[row]
			let string = table.stringSafelyWithID(id)
			
			self.stringIDField.stringValue = string.id.hexString()
			self.messageField.string = string.string
			showInterface()
		}
	}

}







