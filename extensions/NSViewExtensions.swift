//
//  NSViewExtensions.swift
//  GoD Tool
//
//  Created by StarsMmd on 29/06/2016.
//  Copyright © 2016 StarsMmd. All rights reserved.
//

import AppKit


extension NSView {
	
	@objc func setBackgroundColour(_ colour: NSColor) {
		self.wantsLayer = true
		self.layer?.backgroundColor = colour.cgColor
	}
	
	@objc func addBorder(colour: NSColor, width: CGFloat) {
		self.wantsLayer = true
		self.layer?.borderWidth = width
		self.layer?.borderColor = colour.cgColor
	}
	
	@objc func removeBorder() {
		self.wantsLayer = true
		self.layer?.borderWidth = 0
	}
}
