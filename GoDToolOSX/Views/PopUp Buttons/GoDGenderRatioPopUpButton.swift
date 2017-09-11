//
//  GoDGenderRatioPopUpButton.swift
//  GoD Tool
//
//  Created by The Steez on 06/09/2017.
//
//

import Cocoa

class GoDGenderRatioPopUpButton: GoDPopUpButton {
	
	var selectedValue : XGGenderRatios {
		return XGGenderRatios.allRatios()[self.indexOfSelectedItem]
	}
	
	func selectGenderRatio(ratio: XGGenderRatios) {
		self.selectItem(withTitle: ratio.string)
	}
	
	override func setUpItems() {
		var values = [String]()
		
		for gr in XGGenderRatios.allRatios() {
			values.append(gr.string)
		}
		
		self.setTitles(values: values)
	}
	
}
