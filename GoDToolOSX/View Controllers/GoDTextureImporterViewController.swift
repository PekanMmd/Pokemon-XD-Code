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
	
	
	var fileList : [XGFiles] {
		return XGFolders.Import.files.filter({ (ifile) -> Bool in
			return XGFolders.Textures.files.contains(where: { (tfile) -> Bool in
				return (ifile.fileName.removeFileExtensions() == tfile.fileName.removeFileExtensions()) &&
					   (tfile.fileType == .gtx || tfile.fileType == .atx) &&
					   (ifile.fileType == .png || ifile.fileType == .bmp || ifile.fileType == .png)
			})
		}).sorted(by: { (f1, f2) -> Bool in
			f1.fileName < f2.fileName
		})
	}
	
	func loadImage() {
		
		if let current = self.currentFile {
			if current.exists {
				var textureFile = XGFiles.nameAndFolder(current.fileName.removeFileExtensions() + ".gtx", .Textures)
				if !textureFile.exists {
					textureFile = XGFiles.nameAndFolder(current.fileName.removeFileExtensions() + ".atx", .Textures)
				}
				if textureFile.exists {
					if let data = textureFile.data {
						let textureData = GoDTexture(data: data)
						self.importer = GoDTextureImporter(oldTextureData: textureData, newImage: current.image)
						self.importer!.replaceTextureData()
						self.imageView.image = self.importer?.texture.image
					}
				}
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
		
		let cell = (tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cell"), owner: self) ?? GoDTableCellView(title: "", colour: GoDDesign.colourBlack(), showsImage: true, image: nil, background: nil, fontSize: 12, width: self.table.width)) as! GoDTableCellView
		
		cell.identifier = NSUserInterfaceItemIdentifier(rawValue: "cell")
		cell.setBackgroundColour(GoDDesign.colourWhite())
		
		if fileList.count == 0 {
			if XGFolders.Import.files.count == 0 {
				cell.setTitle("No images to import.")
			} else {
				cell.setTitle("No textures match the images to import.")
			}
			return cell
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



