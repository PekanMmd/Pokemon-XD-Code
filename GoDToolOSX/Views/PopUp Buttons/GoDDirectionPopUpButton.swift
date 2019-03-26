//
//  GoDDirectionPopUpButton.swift
//  GoD Tool
//
//  Created by The Steez on 10/03/2019.
//

import Cocoa

class GoDDirectionPopUpButton: GoDPopUpButton {

	var selectedValue : XGElevatorDirections {
		return XGElevatorDirections(rawValue: self.indexOfSelectedItem) ?? .up
	}
	
	func selectDirection(_ direction: XGElevatorDirections) {
		self.selectItem(withTitle: direction.string)
	}
	
	override func setUpItems() {
		let directions : [XGElevatorDirections] =  [.up, .down]
		let values = directions.map { (d) -> String in
			return d.string
		}
		self.setTitles(values: values)
	}
	
}








