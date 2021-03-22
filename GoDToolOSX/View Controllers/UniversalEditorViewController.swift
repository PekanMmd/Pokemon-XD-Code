//
//  UniversalEditorViewController.swift
//  GoD Tool
//
//  Created by Stars Momodu on 19/03/2021.
//

import Cocoa

fileprivate enum TableTypes {
	fileprivate enum StructTableTypes {
		case deckTrainer, deckPokemon, deckAI, common, other

		var colour: NSColor {
			switch self {
			case .deckTrainer:
				return GoDDesign.colourLightBlue()
			case .deckPokemon:
				return GoDDesign.colourLightGreen()
			case .deckAI:
				return GoDDesign.colourRed()
			case .common:
				return GoDDesign.colourYellow()
			case .other:
				return GoDDesign.colourLightOrange()
			}
		}
	}
	case structTable(table: GoDStructTableFormattable, type: StructTableTypes)
	case codableData(data: GoDCodable.Type)

	var name: String {
		switch self {
		case .structTable(let table, _): return table.properties.name + (table.fileVaries ? "\n" + table.file.fileName : "")
		case .codableData(let type): return type.className
		}
	}

	var isStructTable: Bool {
		switch self {
		case .structTable: return true
		case .codableData: return false
		}
	}

	var colour: NSColor {
		switch self {
		case .structTable(_, let type): return type.colour
		case .codableData: return GoDDesign.colourLightGrey()
		}
	}
}

class UniversalEditorViewController: GoDTableViewController {

	@IBOutlet weak var tableNameLabel: NSTextField!
	@IBOutlet weak var decodeButton: GoDButton!
	@IBOutlet weak var encodeButton: GoDButton!
	@IBOutlet weak var documentButton: GoDButton!
	@IBOutlet weak var editButton: GoDButton!

	private var lastSearchText: String?
	private var allValues: [TableTypes] {
		var list = [TableTypes]()

		list += commonStructTablesList.map { (table) -> TableTypes in
			.structTable(table: table, type: .common)
		}

		#if GAME_PBR
		list += deckPokemonStructList.map { (table) -> TableTypes in
			.structTable(table: table, type: .deckPokemon)
		}
		list += deckTrainerStructList.map { (table) -> TableTypes in
			.structTable(table: table, type: .deckTrainer)
		}
		list += deckAIStructList.map { (table) -> TableTypes in
			.structTable(table: table, type: .deckAI)
		}
		#endif

		list += structTablesList.map { (table) -> TableTypes in
			.structTable(table: table, type: .other)
		}

		list += otherTableFormatsList.map({ (type) -> TableTypes in
			 .codableData(data: type)
		})

		return list
	}
	private var filteredValues = [TableTypes]()

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
		case .structTable(let table, _): table.decodeCSVData()
		case .codableData(let type): type.decodeData()
		}
		displayAlert(title: "Done", description: "Finished Decoding")
	}

	@IBAction func didClickEncodeButton(_ sender: Any) {
		guard let tableInfo = currentTable else { return }
		switch tableInfo {
		case .structTable(let table, _): table.encodeCSVData()
		case .codableData(let type): type.encodeData()
		}
		displayAlert(title: "Done", description: "Finished Encoding")
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
