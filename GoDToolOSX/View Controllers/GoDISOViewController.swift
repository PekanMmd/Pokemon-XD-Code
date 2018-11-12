//
//  GoDISOViewController.swift
//  GoD Tool
//
//  Created by The Steez on 26/10/2018.
//

import Cocoa

class GoDISOViewController: GoDTableViewController {
	
	var isExporting = false
	func exportFiles(decode: Bool) {
		XGFolders.nameAndFolder("ISO Export", .Documents).createDirectory()
		
		if isExporting {
			return
		}
		isExporting = true
		
		if let data = ISO.dataForFile(filename: self.currentFile.fileName) {
			if data.length > 0 {
				data.file = self.currentFile
				if self.currentFile.fileType == .fsys {
					let fsysData = data.fsysData
					fsysData.extractFilesToFolder(folder: self.currentFile.folder, decode: decode)
				}
				data.save()
			}
		} else {
			GoDAlertViewController.displayAlert(title: "File export failed", text: "Couldn't export data for file \(self.currentFile.fileName) from the ISO.")
		}
		self.isExporting = false
	}
	
	@IBAction func export(_ sender: Any) {
		self.exportFiles(decode: true)
	}
	
	@IBAction func quickExport(_ sender: Any) {
		self.exportFiles(decode: false)
	}
	
	func importFsysFiles(encode: Bool) {
		XGFolders.nameAndFolder("ISO Export", .Documents).createDirectory()
		
		if currentFile.exists {
			if currentFile.fileType == .fsys {
				
				if encode {
					if game == .XD {
						for file in currentFile.folder.files {
							if file.fileType == .xds {
								XDSScriptCompiler.setFlags(disassemble: true, decompile: false, updateStrings: true, increaseMSG: true)
								XDSScriptCompiler.baseStringID = 1000
								if !XDSScriptCompiler.compile(textFile: file, toFile: .nameAndFolder(file.fileName.removeFileExtensions() + XGFileTypes.scd.fileExtension, file.folder)) {
									GoDAlertViewController.displayAlert(title: "Compilation Error", text: XDSScriptCompiler.error)
									return
								}
							}
							if file.fileType == .gtx || file.fileType == .atx {
								for image in currentFile.folder.files where image.fileType == .png {
									if image.fileName.removeFileExtensions() == file.fileName.removeFileExtensions() {
										file.texture.importImage(file: image)
									}
								}
							}
						}
					}
				}
				
				let fsysData = currentFile.fsysData
				for i in 0 ..< fsysData.numberOfEntries {
					let filename = fsysData.fileNames[i].removeFileExtensions() + fsysData.fileTypeForFile(index: i).fileExtension
					for file in currentFile.folder.files {
						if file.fileName == filename {
							if fsysData.isFileCompressed(index: i){
								fsysData.shiftAndReplaceFileWithIndexEfficiently(i, withFile: file.compress(), save: false)
							} else {
								fsysData.shiftAndReplaceFileWithIndexEfficiently(i, withFile: file, save: false)
							}
						}
					}
				}
				fsysData.save()
			}
			ISO.importFiles([currentFile])
		} else {
			printg("The file: \(currentFile.path) doesn't exit")
		}
		printg("import complete")
	}
	
	@IBAction func importFiles(_ sender: Any) {
		self.importFsysFiles(encode: true)
	}
	
	@IBAction func quickImport(_ sender: Any) {
		self.importFsysFiles(encode: false)
	}
	
	@IBAction func delete(_ sender: Any) {
		if !currentFile.exists {
			printg("exporting file in case of accidental deletion \(currentFile.fileName)")
			self.export(self)
		}
		printg("deleting file: \(currentFile.fileName)")
		ISO.deleteFileAndPreserve(name: currentFile.fileName, save: true)
		GoDAlertViewController.displayAlert(title: "Deletion complete", text: "Deleted file \(currentFile.fileName) from the ISO.")
	}
	
	@IBOutlet var filesText: NSTextView!
	@IBOutlet var filename: NSTextField!
	@IBOutlet var filesize: NSTextField!
	
	var currentFile = XGFiles.dol
	

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "ISO Explorer"
		self.table.setBackgroundColour(GoDDesign.colourClear())
		self.table.tableView.setBackgroundColour(GoDDesign.colourClear())
		self.filesText.setBackgroundColour(GoDDesign.colourClear())
		setMetaData()
    }
	
	func setMetaData() {
		filename.stringValue = "File name: \(currentFile.fileName)"
		
		filesText.string = ""
		if currentFile.fileType == .fsys {
			if let data = ISO.dataForFile(filename: currentFile.fileName) {
				if data.length > 0 {
					filesize.stringValue = "File size: \(data.length.hexString())"
					let fsys = data.fsysData
					if fsys.numberOfEntries > 0 {
						for i in  0 ..< fsys.numberOfEntries {
							var filename = fsys.fileNameForFileWithIndex(index: i)
							if filename.removeFileExtensions() == filename {
								filename += fsys.fileTypeForFile(index: i).fileExtension
							}
							filesText.string += "\n\(i): \(filename)"
						}
					} else {
						filesText.string = "No files."
					}
				} else {
					filesize.stringValue = "File size: -"
					filesText.string = "No data."
				}
			} else {
				filesize.stringValue = "File size: -"
				filesText.string = "No data."
			}
		}
	}
	
	
	
	override func numberOfRows(in tableView: NSTableView) -> Int {
		return ISO.allFileNames.count
	}
	
	override func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
		return 30
	}
	
	override func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		
		let file = ISO.allFileNames.sorted()[row]
		
		let cell = (tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cell"), owner: self) ?? GoDTableCellView(title: "", colour: GoDDesign.colourWhite(), showsImage: false, image: nil, background: nil, fontSize: 16, width: self.table.width)) as! GoDTableCellView
		
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
			let name = ISO.allFileNames.sorted()[row]
			self.currentFile = .nameAndFolder(name, .ISOExport(name.removeFileExtensions()))
			self.setMetaData()
		}
	}
}
















