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
	
	@IBAction func addFile(_ sender: Any) {
		let panel = NSOpenPanel()
		panel.allowsMultipleSelection = false
		panel.canChooseDirectories = false
		panel.canChooseFiles = true
		panel.canDownloadUbiquitousContents = false
		panel.canResolveUbiquitousConflicts = false
		panel.isAccessoryViewDisclosed = false
		panel.resolvesAliases = true
		panel.begin { (result) in
			if result == .OK {
				let urls = panel.urls
				if let url = urls.first {
					self.addFile(withUrl: url)
				}
			}
		}
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
	
	@IBOutlet weak var addFileButton: NSButton!
	
	
	var currentFile = XGFiles.dol

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ISO Explorer"
		table.setBackgroundColour(GoDDesign.colourClear())
		filesText.setBackgroundColour(GoDDesign.colourClear())
		addFileButton.isHidden = true
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
			cell.titleField.textColor = GoDDesign.colourBlue().NSColour
		} else {
			cell.removeBorder()
			cell.titleField.textColor = GoDDesign.colourBlack().NSColour
		}
		
		return cell
	}
	
	override func tableView(_ tableView: GoDTableView, didSelectRow row: Int) {
		super.tableView(tableView, didSelectRow: row)
		if row >= 0 {
			let name = filteredFileNames[row]
			self.currentFile = .nameAndFolder(name, .ISOExport(name.removeFileExtensions()))
			addFileButton.isHidden = currentFile.fileType != .fsys
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
	
	private func addFile(withUrl url: URL) {
		let input = GoDInputViewController()
		input.setText(
			title: "Input file identifier",
			text: "Select a unique identifier for the new file. Use 4 hexadecimal digits.") { id in
				if self.isExporting {
					return
				}
				self.isExporting = true
				guard self.currentFile.fileType == .fsys else { return }
				if let identifier = id?.hexValue, identifier > 0, identifier < 0x10000 {
					let fsys = self.currentFile.fsysData
					if fsys.files.count == 0 {
						self.dismiss(input)
						GoDAlertViewController.displayAlert(title: "Error", text: "Adding files to an empty fsys archive is unsupported.")
					} else {
						let newFile = XGFiles.path(url.path)
						fsys.addFile(newFile, fileType: newFile.fileType, compress: true, shortID: identifier)
						fsys.save()
						XGUtility.importFileToISO(self.currentFile, encode: false, save: true)
						self.dismiss(input)
						self.setMetaData()
					}
				} else {
					self.dismiss(input)
					GoDAlertViewController.displayAlert(title: "Invalid file identifier", text: "File identifier must be a unique number between 1-4 hexadecimal digits.")
				}
				self.isExporting = false
			}
		presentAsModalWindow(input)
	}
}
















