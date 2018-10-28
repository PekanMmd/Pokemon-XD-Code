//
//  GoDBattleStylePopUpButton.swift
//  GoD Tool
//
//  Created by The Steez on 27/10/2018.
//

import Cocoa

class GoDBattleStylePopUpButton: GoDPopUpButton {

	var selectedValue : XGBattleStyles {
		return XGBattleStyles(rawValue: self.indexOfSelectedItem) ?? .none
	}
	
	func selectStyle(style: XGBattleStyles) {
		self.selectItem(at: style.rawValue)
	}
	
	override func setUpItems() {
		let values = ["None", "Single Battle", "Double Battle"]
		
		self.setTitles(values: values)
	}
    
}
