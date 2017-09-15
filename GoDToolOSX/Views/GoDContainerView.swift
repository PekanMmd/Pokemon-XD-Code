//
//  GoDContainerView.swift
//  GoD Tool
//
//  Created by StarsMmd on 07/09/2017.
//
//

import Cocoa

class GoDContainerView: NSView {

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		self.wantsLayer = true
		self.layer?.borderColor = GoDDesign.colourDarkGrey().cgColor
		self.layer?.borderWidth = 1
		self.layer?.cornerRadius = 6
		self.translatesAutoresizingMaskIntoConstraints = false
	}
    
}
