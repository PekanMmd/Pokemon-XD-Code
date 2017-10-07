//
//  GoDTargetsPopUpButton.swift
//  GoD Tool
//
//  Created by The Steez on 03/10/2017.
//
//

import Cocoa

class GoDTargetsPopUpButton: GoDPopUpButton {

	var selectedValue : XGMoveTargets {
		return XGMoveTargets(rawValue: self.indexOfSelectedItem) ?? .selectedTarget
	}
	
	func selectTarget(target: XGMoveTargets) {
		self.selectItem(withTitle: target.string)
	}
	
	override func setUpItems() {
		var values = [String]()
		
		for i in 0 ... 7 {
			values.append(XGMoveTargets(rawValue: i)!.string)
		}
		
		self.setTitles(values: values)
	}
	
}
