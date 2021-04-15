//
//  GoDTextureImporterViewController.swift
//  GoD Tool
//
//  Created by The Steez on 07/03/2019.
//

import Cocoa

class GoDTextureImporterViewController: GoDTableViewController {
	
	@IBOutlet var filenameField: NSTextField!
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
		XGFileTypes.imageFormats.forEach { (type) in
			allSupportedImages += XGFiles.allFilesWithType(type)
		}
		return allSupportedImages.filter({ (ifile) -> Bool in
			return ifile.folder.files.contains(where: { (tfile) -> Bool in
				return XGFileTypes.textureFormats.contains(tfile.fileType) &&
				(ifile.fileName.removeFileExtensions() == tfile.fileName.removeFileExtensions())

			})
		}).sorted(by: { (f1, f2) -> Bool in
			f1.fileName < f2.fileName
		})
	}()
	
	func loadImage() {
		
		if let current = self.currentFile, current.exists {
			let tFile = current.folder.files.first { (tfile) -> Bool in
				return XGFileTypes.textureFormats.contains(tfile.fileType) &&
					tfile.fileName.removeFileExtensions() == current.fileName.removeFileExtensions()
			}
			if let textureFile = tFile, let data = textureFile.data {
				let textureData = GoDTexture(data: data)
				importer = GoDTextureImporter(oldTextureData: textureData, newImage: XGImage(nsImage: current.image))
				importer?.replaceTextureData()
				imageView.image = importer?.texture.image.nsImage
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
		}
		self.table.reloadData()
	}
	
	override func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		
		let cell = (tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cell"), owner: self) ?? GoDTableCellView(title: "", colour: GoDDesign.colourBlack(), fontSize: 12, width: widthForTable())) as! GoDTableCellView
		
		cell.identifier = NSUserInterfaceItemIdentifier(rawValue: "cell")
		cell.setBackgroundColour(GoDDesign.colourWhite())
		
		if fileList.count == 0 {
			cell.setTitle("No images to import. Make sure Game Files sub folders contain the texture (.gtx/.atx) and the corresponding .png")
		}
		
		let list = fileList
		if row < list.count {
			let file = list[row]
			if file.exists {
				cell.setTitle(file.fileName)
			} else {
				self.table.reloadData()
			}
		} else {
			self.table.reloadData()
		}
		
		return cell
	}

}



