//
//  GoDPopUpButton.swift
//  GoD Tool
//
//  Created by The Steez on 06/09/2017.
//
//

import Cocoa

class GoDPopUpButton: NSPopUpButton {

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		
		self.removeAllItems()
		self.setUpItems()
	}
	
	func setUpItems() {
		return
	}
	
}
