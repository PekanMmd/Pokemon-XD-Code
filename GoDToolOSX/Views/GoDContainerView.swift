//
//  GoDContainerView.swift
//  GoD Tool
//
//  Created by StarsMmd on 07/09/2017.
//
//

import Cocoa

class GoDContainerView: NSView {

	init() {
		super.init(frame: .zero)
		setup()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setup()
	}
	
	func setup() {
		self.wantsLayer = true
		self.layer?.borderColor = NSColor.controlHighlightColor.cgColor
		self.layer?.borderWidth = 1
		self.layer?.cornerRadius = 6
		self.translatesAutoresizingMaskIntoConstraints = false
	}
}
