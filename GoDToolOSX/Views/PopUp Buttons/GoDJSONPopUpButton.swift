//
//  GoDJSONPopUpButton.swift
//  GoD Tool
//
//  Created by The Steez on 05/10/2017.
//
//

import Cocoa

class GoDJSONPopUpButton: GoDPopUpButton {

	var startIndex: Int {
		return 0
	}

	var file : XGFiles {
		return XGFiles.nameAndFolder("", .JSON)
	}
	
	var selectedValue : Int {
		return self.indexOfSelectedItem
	}
	
	override func setUpItems() {
		var values = ["\(file.fileName) not found!"]
		
		if file.exists {
			if let jsonValues = file.json as? [String] {
				values = []
				for i in 0 ..< jsonValues.count {
					values.append(jsonValues[i] + " \(startIndex + i)")
				}
			}
		}
		
		self.setTitles(values: values)
	}
	
}
