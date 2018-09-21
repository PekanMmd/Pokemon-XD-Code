//
//  XGButton.swift
//  XG Tool
//
//  Created by StarsMmd on 12/06/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import AppKit

class GoDButton: NSButton {

	init() {
		super.init(frame: CGRect.zero)
	}
	
	required init?(coder aDecoder: NSCoder) {
	    super.init(coder: aDecoder)
	}
	
	init(title: String, colour: NSColor, textColour: NSColor, buttonType: NSButton.ButtonType, target: NSObject, action: Selector) {
		super.init(frame: CGRect.zero)
		
		self.setUp(title: title, colour: colour, textColour: textColour, buttonType: buttonType, target: target, action: action)
		
	}
	
	func setUp(title: String, colour: NSColor, textColour: NSColor, buttonType: NSButton.ButtonType, target: NSObject, action: Selector) {
		
		self.translatesAutoresizingMaskIntoConstraints = false
		
		self.title = title
		self.setBackgroundColour(colour)
		self.setButtonType(buttonType)
		self.target = target
		self.action = action
		
	}

}













