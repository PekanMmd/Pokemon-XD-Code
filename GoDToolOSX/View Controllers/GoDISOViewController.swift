//
//  GoDISOViewController.swift
//  GoD Tool
//
//  Created by The Steez on 26/10/2018.
//

import Cocoa

class GoDISOViewController: GoDTableViewController {

	let allFileNames = XGISO.current.allFileNames.sorted()
	var filteredFileNames = [String]()

	var isExporting = false
	func exportFiles(extract: Bool, decode: Bool) {
		if isExporting {
			return
		}
		isExporting = true
		
		if XGUtility.exportFileFromISO(currentFile, extractFsysContents: extract, decode: decode) {
			GoDAlertViewController.displayAlert(title: "Export Complete", text: "Exported \(currentFile.fileName) to \(self.currentFile.folder.path)")
		} else {
			GoDAlertViewController.displayAlert(title: "File export failed", text: "Couldn't export data for file \(self.currentFile.fileName) from the ISO.")
		}
		self.isExporting = false
	}
	
	@IBAction func export(_ sender: Any) {
		self.exportFiles(extract: true, decode: true)
	}
	
	@IBAction func quickExport(_ sender: Any) {
		self.exportFiles(extract: true, decode: false)
	}

	@IBAction func decodeOnly(_ sender: Any) {
		self.exportFiles(extract: false, decode: true)
	}
	
	func importFsysFiles(shouldImport: Bool, encode: Bool) {
		if isExporting {
			return
		}
		isExporting = true

		if XGUtility.importFileToISO(currentFile, shouldImport: shouldImport, encode: encode) {
			GoDAlertViewController.displayAlert(title: "Import Complete", text: "Imported \(currentFile.path) to ISO")
		} else {
			GoDAlertViewController.displayAlert(title: "File import failed", text: "Couldn't import data for file \(self.currentFile.path) to the ISO.")
		}
		self.isExporting = false
	}
	
	@IBAction func importFiles(_ sender: Any) {
		self.importFsysFiles(shouldImport: true, encode: true)
	}
	
	@IBAction func quickImport(_ sender: Any) {
		self.importFsysFiles(shouldImport: true, encode: false)
	}

	@IBAction func encodeOnly(_ sender: Any) {
		self.importFsysFiles(shouldImport: false, encode: true)
	}
	
	@IBAction func delete(_ sender: Any) {
		if !currentFile.exists {
			printg("exporting file in case of accidental deletion \(currentFile.fileName)")
			self.export(self)
		}
		printg("deleting file: \(currentFile.fileName)")
		XGISO.current.deleteFileAndPreserve(name: currentFile.fileName, save: true)
		GoDAlertViewController.displayAlert(title: "Deletion complete", text: "Deleted file \(currentFile.fileName) from the ISO.")
	}
	
	@IBOutlet var filesText: NSTextView!
	@IBOutlet var filename: NSTextField!
	@IBOutlet var filesize: NSTextField!
	
	var currentFile = XGFiles.dol

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ISO Explorer"
		table.setBackgroundColour(GoDDesign.colourClear())
		filesText.setBackgroundColour(GoDDesign.colourClear())
		setMetaData()
		filteredFileNames = allFileNames
		table.reloadData()
    }
	
	func setMetaData() {
		filename.stringValue = "File name: \(currentFile.fileName)"
		
		filesText.string = ""
		if let data = XGISO.current.dataForFile(filename: currentFile.fileName) {

			filesize.stringValue = "File size: \(data.length)"
			filesText.string = "-"

			if currentFile.fileType == .fsys {
				filesText.string = "No files found in archive."
				if data.length > 0 {
					filesize.stringValue = "File size: \(data.length.hexString())"
					let fsys = data.fsysData
					if game != .PBR {
						filename.stringValue += " GID: \(fsys.groupID)"
					}
					if fsys.numberOfEntries > 0 {
						filesText.string = ""
						for i in  0 ..< fsys.numberOfEntries {
							let filename = fsys.fileNameForFileWithIndex(index: i) ?? "-"
							var identifier = fsys.identifierForFile(index: i).hex()
							while identifier.count < 8 {
								identifier = "0" + identifier
							}
							filesText.string += "\n\(i): \(filename) (\(identifier))"
						}
					}
				}
			}
		}
	}
	
	override func numberOfRows(in tableView: NSTableView) -> Int {
		return filteredFileNames.count
	}
	
	override func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
		return 30
	}
	
	override func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		
		let file = filteredFileNames[row]
		
		let cell = (tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cell"), owner: self) ?? GoDTableCellView(title: "", colour: GoDDesign.colourWhite(), fontSize: 16, width: widthForTable())) as! GoDTableCellView
		
		cell.setTitle(file)
		cell.setBackgroundColour(GoDDesign.colourWhite())
		
		cell.identifier = NSUserInterfaceItemIdentifier(rawValue: "cell")
		cell.translatesAutoresizingMaskIntoConstraints = false
		
		cell.alphaValue = self.table.selectedRow == row ? 1 : 0.75
		if self.table.selectedRow == row {
			cell.addBorder(colour: GoDDesign.colourBlack(), width: 1)
			cell.titleField.textColor = GoDDesign.colourBlue()
		} else {
			cell.removeBorder()
			cell.titleField.textColor = GoDDesign.colourBlack()
		}
		
		return cell
	}
	
	override func tableView(_ tableView: GoDTableView, didSelectRow row: Int) {
		super.tableView(tableView, didSelectRow: row)
		if row >= 0 {
			let name = filteredFileNames[row]
			self.currentFile = .nameAndFolder(name, .ISOExport(name.removeFileExtensions()))
			self.setMetaData()
		}
	}

	override func searchBarBehaviourForTableView(_ tableView: GoDTableView) -> GoDSearchBarBehaviour {
		.onTextChange
	}

	override func tableView(_ tableView: GoDTableView, didSearchForText text: String) {
		defer {
			tableView.reloadData()
		}

		guard !text.isEmpty else {
			filteredFileNames = allFileNames
			return
		}

		filteredFileNames = allFileNames.filter({ (file) -> Bool in
			let searchTerms = text.split(separator: ",")
			return searchTerms.contains(where: { searchTerm in
				file.simplified.contains(String(searchTerm).simplified)
			})
		})
	}
}
















