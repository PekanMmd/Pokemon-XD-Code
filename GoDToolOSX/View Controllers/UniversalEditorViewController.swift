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

	private var lastSearchText: String?
	private var allValues : [TableTypes] {
		return structTablesList.map { (table) -> TableTypes in
			.structTable(table: table)
		} + otherTableFormatsList.map({ (type) -> TableTypes in
			 .codableData(data: type)
		})
	}
	private var filteredValues = [TableTypes]()

	private enum TableTypes {
		case structTable(table: GoDStructTableFormattable)
		case codableData(data: GoDCodable.Type)

		var name: String {
			switch self {
			case .structTable(let table): return table.properties.name
			case .codableData(let type): return type.className
			}
		}

		var isStructTable: Bool {
			switch self {
			case .structTable: return true
			case .codableData: return false
			}
		}
	}

	private var currentTable: TableTypes? {
		didSet {
			[decodeButton, encodeButton, documentButton].forEach { (button) in
				button?.isEnabled = currentTable != nil
			}
			tableNameLabel.stringValue = currentTable?.name ?? "Data Table"
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		filteredValues = allValues
		table.reloadData()
	}
    
	@IBAction func didClickDecodeButton(_ sender: Any) {
		guard let tableInfo = currentTable else { return }
		switch tableInfo {
		case .structTable(let table): table.decodeData()
		case .codableData(let type): type.decodeData()
		}
		displayAlert(title: "Done", description: "Finished Decoding")
	}

	@IBAction func didClickEncodeButton(_ sender: Any) {
		guard let tableInfo = currentTable else { return }
		switch tableInfo {
		case .structTable(let table): table.encodeData()
		case .codableData(let type): type.encodeData()
		}
		displayAlert(title: "Done", description: "Finished Encoding")
	}

	@IBAction func didClickDocumentButton(_ sender: Any) {
		guard let tableInfo = currentTable else { return }
		switch tableInfo {
		case .structTable(let table): table.decodeCSVData(); table.documentData(); table.documentEnumerationData(); table.documentCStruct()
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
			filteredValues = allValues
			return
		}

		lastSearchText = text
		filteredValues = allValues.filter({ (tableInfo) -> Bool in
			return tableInfo.name.simplified.contains(text.simplified)
		})
	}

	override func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {

		let tableInfo = filteredValues[row]

		let colour = tableInfo.isStructTable ? GoDDesign.colourLightBlue() : GoDDesign.colourLightGreen()

		let view = (tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cell"), owner: self) ?? GoDTableCellView(title: patches[row].name, colour: GoDDesign.colourBlack(), fontSize: 10, width: widthForTable())) as! GoDTableCellView

		view.setBackgroundColour(colour)
		view.setTitle(tableInfo.name)
		view.titleField.maximumNumberOfLines = 0

		return view
	}
}
