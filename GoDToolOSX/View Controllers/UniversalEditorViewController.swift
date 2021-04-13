//
//  UniversalEditorViewController.swift
//  GoD Tool
//
//  Created by Stars Momodu on 19/03/2021.
//

import Cocoa

class UniversalEditorViewController: GoDTableViewController {

	@IBOutlet weak var tableNameLabel: NSTextField!
	@IBOutlet weak var decodeButton: GoDButton!
	@IBOutlet weak var encodeButton: GoDButton!
	@IBOutlet weak var documentButton: GoDButton!
	@IBOutlet weak var editButton: GoDButton!
	@IBOutlet weak var detailsLabel: NSTextField!

	private var lastSearchText: String?
	private var filteredValues = [TableTypes]()

	private var currentTable: TableTypes? {
		didSet {
			[decodeButton, encodeButton, documentButton].forEach { (button) in
				button?.isEnabled = currentTable != nil
			}
			tableNameLabel.stringValue = currentTable?.name ?? "Data Table"
			detailsLabel.stringValue = "Details: -"
			if case .structTable(let table, _) = currentTable {
				detailsLabel.stringValue =
				"""
				Details:
				File: \(table.file.path)
				Start Offset: \(table.firstEntryStartOffset.hexString()) (\(table.firstEntryStartOffset))
				Number of Entries: \(table.numberOfEntries.hexString()) (\(table.numberOfEntries))
				Entry Length: \(table.entryLength.hexString()) (\(table.entryLength))
				"""
			}
			if case .codableData(let type) = currentTable {
				detailsLabel.stringValue =
				"""
				Details:
				Number of Entries: \(type.numberOfValues.hexString()) (\(type.numberOfValues))
				"""
			}
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		filteredValues = TableTypes.allTables
		table.reloadData()
	}
    
	@IBAction func didClickEncodeButton(_ sender: Any) {
		guard let tableInfo = currentTable else { return }
		switch tableInfo {
		case .structTable(let table, _): table.encodeCSVData()
		case .codableData(let type): type.encodeData()
		}
		displayAlert(title: "Done", description: "Finished Encoding")
	}

	@IBAction func didClickDecodeButton(_ sender: Any) {
		guard let tableInfo = currentTable else { return }
		switch tableInfo {
		#if !GAME_PBR
		case .structTable(let table, type: .saveData):
			table.decodeCSVData()
			if let saveData = table.file.data {
				let gciFile = XGFiles.nameAndFolder(saveData.file.fileName.replacingOccurrences(of: ".raw", with: ""), saveData.file.folder)
				if gciFile.exists {
					XGSaveManager(file: gciFile, saveType: .gciSaveData).save()
				}
			}
		#endif
		case .structTable(let table, _): table.decodeCSVData()
		case .codableData(let type): type.decodeData()
		}
		displayAlert(title: "Done", description: "Finished Decoding")
	}

	@IBAction func didClickDocumentButton(_ sender: Any) {
		guard let tableInfo = currentTable else { return }
		switch tableInfo {
		case .structTable(let table, _): table.documentCStruct(); table.documentEnumerationData(); table.documentData()
		case .codableData(let type): type.documentData(); type.documentEnumerationData()
		}
		displayAlert(title: "Done", description: "Finished Documenting")
	}

	@IBAction func didClickEditButton(_ sender: Any) {
	}

	override func numberOfRows(in tableView: NSTableView) -> Int {
		return filteredValues.count
	}

	override func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
		return 50
	}

	override func searchBarBehaviourForTableView(_ tableView: GoDTableView) -> GoDSearchBarBehaviour {
		.onTextChange
	}

	override func tableView(_ tableView: GoDTableView, didSelectRow row: Int) {
		super.tableView(tableView, didSelectRow: row)
		if row >= 0 {
			currentTable = filteredValues[row]
		}
	}

	override func tableView(_ tableView: GoDTableView, didSearchForText text: String) {
		defer {
			tableView.reloadData()
		}

		guard !text.isEmpty else {
			lastSearchText = nil
			filteredValues = TableTypes.allTables
			return
		}

		lastSearchText = text
		filteredValues = TableTypes.allTables.filter({ (tableInfo) -> Bool in
			return tableInfo.name.simplified.contains(text.simplified)
		})
	}

	override func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {

		let tableInfo = filteredValues[row]

		let cell = super.tableView(tableView, viewFor: tableColumn, row: row)
		guard let view = cell as? GoDTableCellView else {
			assertionFailure("GoDTableViewController didn't return GoDTableCellView")
			return cell
		}

		view.setBackgroundColour(tableInfo.colour)
		view.setTitle(tableInfo.name)
		view.titleField.maximumNumberOfLines = 0

		return view
	}
}
