//
//  GoDTrainerModelPopUpButton.swift
//  GoD Tool
//
//  Created by The Steez on 27/10/2018.
//

import Cocoa

class GoDTrainerModelPopUpButton: GoDPopUpButton {

	var selectedValue : XGTrainerModels {
		return XGTrainerModels(rawValue: self.indexOfSelectedItem) ?? .none
	}
	
	func selectModel(model: XGTrainerModels) {
		self.selectItem(withTitle: model.name)
	}
	
	override func setUpItems() {
		var values = [String]()
		
		for i in 0 ..< kNumberOfTrainerModels {
			values.append(XGTrainerModels(rawValue: i)!.name)
		}
		
		self.setTitles(values: values)
	}
    
}
