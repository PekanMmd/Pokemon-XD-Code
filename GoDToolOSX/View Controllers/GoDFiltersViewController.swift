//
//  GoDFiltersViewController.swift
//  GoD Tool
//
//  Created by Stars Momodu on 17/08/2021.
//

import Cocoa

class GoDFiltersViewController: GoDTableViewController {

	@IBOutlet var filenameField: NSTextField!
	var currentFile: XGFiles?
	var currentImage: XGImage?
	var currentDatModel: DATModel?

	@IBOutlet var imageView: NSImageView!
	@IBOutlet var filteredImageView: NSImageView!
	@IBOutlet var filterSelectorPopUp: GoDFilterPopUpButton!

	override func viewDidLoad() {
		super.viewDidLoad()
		filterSelectorPopUp.select(GoDFiltersManager.Filters.none)
	}

	@IBAction func didSelectFilter(_ sender: Any) {
		if let image = currentImage {
			let filteredImage = image.copy()
			filterSelectorPopUp.selectedValue.apply(to: filteredImage)
			filteredImageView.image = filteredImage.nsImage
		}
	}

	@IBAction func save(_ sender: Any) {
		currentDatModel?.applyFilter(filterSelectorPopUp.selectedValue)
		currentDatModel?.save()
	}

	lazy var fileList: [XGFiles] = {
		var allSupportedImages = [XGFiles]()
		for folder in XGFolders.ISOExport("").subfolders {
			allSupportedImages += folder.files.filter({ (file) -> Bool in
				let parts = file.fileName.split(separator: ".")
				return parts.count == 3
				&& parts[1] == "wzx"
				&& parts[2] == "dat"
			})
		}
		return allSupportedImages
	}()

	lazy var filteredFileList = fileList

	override func numberOfRows(in tableView: NSTableView) -> Int {
		return max(filteredFileList.count, 1)
	}

	override func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
		return 50
	}

	override func tableView(_ tableView: GoDTableView, didSelectRow row: Int) {
		super.tableView(tableView, didSelectRow: row)
		if row == -1 {
			return
		}

		currentDatModel = nil
		currentImage = nil
		currentFile = nil

		let list = filteredFileList
		if row < list.count {
			let file = list[row]
			self.filenameField.stringValue = file.path
			if file.exists {
				self.currentFile = file
				switch file.fileType {
				case .dat:
					if let data = file.data {
						currentFile = file
						currentDatModel = DATModel(data: data)
						currentImage = currentDatModel?.vertexColourProfile
					}
				default:
					break
				}
			}
		} else {
			self.table.reloadData()
		}
		filenameField.stringValue = currentFile?.fileName ?? "-"
		imageView.image = currentImage?.nsImage
		filteredImageView.image = currentImage?.nsImage
		filterSelectorPopUp.select(GoDFiltersManager.Filters.none)
	}

	override func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {

		let cell = super.tableView(tableView, viewFor: tableColumn, row: row) as? GoDTableCellView
		cell?.setBackgroundColour(GoDDesign.colourWhite())

		if filteredFileList.count == 0 {
			cell?.setTitle("No images to import. Export and decode some texture files from the ISO.")
		}

		let list = filteredFileList
		if row < list.count, list[row].exists {
			let file = list[row]
			cell?.setTitle(file.path)
		} else {
			self.table.reloadData()
		}

		return cell
	}

	override func tableView(_ tableView: GoDTableView, didSearchForText text: String) {
		defer {
			tableView.reloadData()
		}

		guard !text.isEmpty else {
			filteredFileList = fileList
			return
		}

		filteredFileList = fileList.filter({ (file) -> Bool in
			file.fileName.simplified.contains(text.simplified)
		})
	}

	override func searchBarBehaviourForTableView(_ tableView: GoDTableView) -> GoDSearchBarBehaviour {
		return .onEndEditing
	}
}
