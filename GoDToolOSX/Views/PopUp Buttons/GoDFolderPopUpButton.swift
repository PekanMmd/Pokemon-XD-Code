//
//  GoDFolderPopUpButton.swift
//  GoD Tool
//
//  Created by The Steez on 14/04/2019.
//

import Cocoa

class GoDFolderPopUpButton: GoDPopUpButton {

	var folder : XGFolders = .Documents {
		didSet {
			self.setUpItems()
		}
	}
	
	var selectedValue : XGFiles {
		return self.folder.files.sorted { $0.fileName < $1.fileName }[self.indexOfSelectedItem]
	}
	
	func selectItem(file: XGFiles) {
		self.selectItem(withTitle: file.fileName)
	}
	
	override func setUpItems() {
		self.setTitles(values: self.folder.files.map { $0.fileName }.sorted())
	}
    
}
