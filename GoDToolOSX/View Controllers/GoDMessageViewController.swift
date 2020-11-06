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

	var singleTable: XGStringTable?
//	lazy var allStringTables = XGFolders.StringTables.files
//							  .filter { $0.fileType == .msg }
//							  .map { $0.stringTable }

	var stringIDs = [Int]()

	var currentString: XGString?
	var currentTable : XGStringTable? {
		didSet {
			setUpForFile()
		}
	}

	init(singleTable: XGStringTable) {
		self.singleTable = singleTable
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		loadAllStrings()
		if let table = singleTable {
			self.filesPopup.setTitles(values: [table.file.fileName])
			self.filesPopup.isEnabled = false
			currentTable = table
		} else {
			self.filesPopup.setTitles(values: ["-"] + allStringTables.map { $0.file.fileName }.sorted())
		}
		self.hideInterface()
    }
	
	func hideInterface() {
		stringIDField.isEnabled = false
		messageField.isEditable = false
		saveButton.isEnabled = false
	}
	
	func showInterface() {
		stringIDField.isEnabled = true
		messageField.isEditable = true
		stringIDField.isEditable = game != .PBR
		saveButton.isEnabled = true
	}
	
	func setUpForFile() {
		currentString = nil
		stringIDs = currentTable?.stringIDs ?? []
		stringIDField.stringValue = ""
		messageField.string = ""
		hideInterface()
		table.reloadData()
		table.scrollToTop()
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

		var sid: Int?
		if game == .PBR {
			sid = currentString?.id
		} else {
			sid = stringIDField.stringValue.integerValue
		}

		if let stringID = sid {
			
			let message = messageField.string == "" ? "-" : messageField.string
			let string = XGString(string: message, file: table.file, sid: stringID)
			let operation = table.containsStringWithId(stringID) ? "replacing" : "adding"
			let success = table.addString(string, increaseSize: settings.increaseFileSizes, save: true)
			let successMessage = success ? "Completed" : "Failed"
			let successTitle = success ? "Success" : "Failure"
			GoDAlertViewController.displayAlert(title: successTitle, text: "\(successMessage) \(operation) id: \(stringID) message: \(message) to \(table.file.path)")
			self.table.reloadData()
			
		} else {
			GoDAlertViewController.displayAlert(title: "Error", text: "Please enter a valid string ID")
		}
	}
	
	override func numberOfRows(in tableView: NSTableView) -> Int {
		return stringIDs.count
	}
	
	override func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
		return 50
	}
	
	override func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		
		let cell = (tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cell"), owner: self) ?? GoDTableCellView(title: "", colour: GoDDesign.colourBlack(), fontSize: 12, width: widthForTable())) as! GoDTableCellView
		
		guard let currentTable = currentTable else {
			return cell
		}

		let id = stringIDs[row]
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

			let id = stringIDs[row]
			let string = table.stringSafelyWithID(id)
			currentString = string
			
			stringIDField.stringValue = string.id.hexString()
			messageField.string = string.string
			showInterface()
		}
	}

	override func searchBarBehaviourForTableView(_ tableView: GoDTableView) -> GoDSearchBarBehaviour {
		.onEndEditing
	}

	override func tableView(_ tableView: GoDTableView, didSearchForText text: String) {

		defer {
			tableView.reloadData()
		}

		guard !text.isEmpty else {
			stringIDs = currentTable?.stringIDs ?? []
			return
		}

		stringIDs = currentTable?.allStrings().filter({ (s) -> Bool in
			s.string.simplified.contains(text.simplified)
			|| (text.integerValue != nil && text.integerValue == s.id)
			|| ((text.integerValue ?? -1) == s.id)
		}).map({ (s) -> Int in
			s.id
		}) ?? []
	}
}







