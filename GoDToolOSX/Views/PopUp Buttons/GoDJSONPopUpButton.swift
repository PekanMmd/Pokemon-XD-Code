//
//  GoDJSONPopUpButton.swift
//  GoD Tool
//
//  Created by The Steez on 05/10/2017.
//
//

import Cocoa

class GoDJSONPopUpButton: GoDPopUpButton {
	
	var file : XGFiles {
		return XGFiles.nameAndFolder("", .JSON)
	}
	
	var selectedValue : Int {
		return self.indexOfSelectedItem
	}
	
	override func setUpItems() {
		var values = ["\(file.fileName) not found!"]
		
		if file.exists {
			
			values = file.json as! [String]
			
		}
		
		self.setTitles(values: values)
	}
	
}
