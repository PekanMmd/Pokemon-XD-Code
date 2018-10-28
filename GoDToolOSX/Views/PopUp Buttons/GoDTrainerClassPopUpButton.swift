//
//  GoDTrainerClassPopUpButton.swift
//  GoD Tool
//
//  Created by The Steez on 27/10/2018.
//

import Cocoa

class GoDTrainerClassPopUpButton: GoDPopUpButton {

	var selectedValue : XGTrainerClass {
		return XGTrainerClass(index: self.indexOfSelectedItem)
	}
	
	func selectClass(tclass: XGTrainerClass) {
		self.selectItem(at: tclass.index)
	}
	
	override func setUpItems() {
		var values = [String]()
		
		for i in 0 ..< CommonIndexes.NumberOfTrainerClasses.value {
			values.append(XGTrainerClass(index: i).name.string.replacingOccurrences(of: "[07]{00}", with: ""))
		}
		
		self.setTitles(values: values)
	}
	
}
