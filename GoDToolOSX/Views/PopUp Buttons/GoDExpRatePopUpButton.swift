//
//  GoDExpRatePopUpButton.swift
//  GoD Tool
//
//  Created by The Steez on 06/09/2017.
//
//

import Cocoa

class GoDExpRatePopUpButton: GoDPopUpButton {
	
	var selectedValue : XGExpRate {
		return XGExpRate(rawValue: self.indexOfSelectedItem) ?? .standard
	}
	
	func selectExpRate(rate: XGExpRate) {
		self.selectItem(withTitle: rate.string)
	}
	
	override func setUpItems() {
		var values = [String]()
		for i in 0 ... 5 {
			values.append(XGExpRate(rawValue: i)!.string)
		}
		
		self.setTitles(values: values)
	}
	
}
