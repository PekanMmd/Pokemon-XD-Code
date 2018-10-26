//
//  GoDEffectivenessPopUpButton.swift
//  GoD Tool
//
//  Created by The Steez on 26/10/2018.
//

import Cocoa

class GoDEffectivenessPopUpButton: GoDPopUpButton {

	var selectedValue : XGEffectivenessValues {
		return XGEffectivenessValues.fromIndex(self.indexOfSelectedItem)
	}
	
	func selectEffectiveness(eff: XGEffectivenessValues) {
		self.selectItem(withTitle: eff.string)
	}
	
	override func setUpItems() {
		var values = [String]()
		
		for i in 0 ... 3 {
			values.append(XGEffectivenessValues.fromIndex(i).string)
		}
		
		self.setTitles(values: values)
	}
	
    
}
