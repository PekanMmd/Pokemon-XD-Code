//
//  GoDTextureImporterViewController.swift
//  GoD Tool
//
//  Created by The Steez on 07/03/2019.
//

import Cocoa

class GoDTextureImporterViewController: GoDTableViewController {
	
	@IBOutlet var filenameField: NSTextField!
	@IBOutlet var detailsField: NSTextField!
	var currentFile : XGFiles?
	var importer : GoDTextureImporter?
	
	
	@IBOutlet var imageView: NSImageView!
	@IBOutlet var thresholdSlider: NSSlider!
	
	
	@IBAction func setColourThreshold(_ sender: NSSlider) {
		XGColour.colourThreshold = sender.integerValue
		self.loadImage()
	}
	
	@IBAction func save(_ sender: Any) {
		self.saveImage()
	}
	
	
	var fileList: [XGFiles] = {
		var allSupportedImages = [XGFiles]()
		for folder in XGFolders.ISOExport("").subfolders {
			allSupportedImages += folder.files.filter({ (file) -> Bool in
				let gtxFile = XGFiles.nameAndFolder(file.fileName.replacingOccurrences(of: file.fileExtension, with: ""), file.folder)
				return XGFileTypes.imageFormats.contains(file.fileType)
					&& gtxFile.exists && gtxFile.fileType == .gtx
			})
		}
		return allSupportedImages
	}()
	
	func loadImage() {
		if let current = currentFile, current.exists {
			let gtxFile = XGFiles.nameAndFolder(current.fileName.replacingOccurrences(of: current.fileExtension, with: ""), current.folder)
			if let data = gtxFile.data {
				let textureData = GoDTexture(data: data)
				importer = GoDTextureImporter(oldTextureData: textureData, newImage: XGImage(nsImage: current.image))
				importer?.replaceTextureData()
				imageView.image = importer?.texture.image.nsImage
				detailsField.stringValue = "Texture Format: \(textureData.format.name)"
					+ (textureData.isIndexed ? "\nPalette Format: \(textureData.paletteFormat.name)" : "")
					+ "\nMax Colours: \(textureData.isIndexed ? textureData.format.paletteCount.string : "None")"
					+ "\nColours in image: \(XGImage.loadImageData(fromFile: current)?.colourCount.string ?? "Unknowm")"
			}
		}
	}
	
	func saveImage() {
		if let imp = self.importer {
			imp.texture.save()
		}
	}
	
	override func numberOfRows(in tableView: NSTableView) -> Int {
		return max(fileList.count, 1)
	}
	
	override func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
		return 50
	}
	
	override func tableView(_ tableView: GoDTableView, didSelectRow row: Int) {
		super.tableView(tableView, didSelectRow: row)
		if row == -1 {
			return
		}
		let list = fileList
		if row < list.count {
			let file = list[row]
			self.filenameField.stringValue = file.fileName
			if file.exists {
				self.currentFile = file
				self.loadImage()
			}
		} else {
			self.table.reloadData()
		}
	}
	
	override func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		
		let cell = super.tableView(tableView, viewFor: tableColumn, row: row) as? GoDTableCellView
		cell?.setBackgroundColour(GoDDesign.colourWhite())
		
		if fileList.count == 0 {
			cell?.setTitle("No images to import. Export and decode some texture files from the ISO.")
		}
		
		let list = fileList
		if row < list.count, list[row].exists {
			let file = list[row]
			cell?.setTitle(file.fileName)
		} else {
			self.table.reloadData()
		}

		if self.table.selectedRow == row {
			cell?.addBorder(colour: GoDDesign.colourBlack(), width: 1)
		} else {
			cell?.removeBorder()
		}
		
		return cell
	}

}



