//
//  GoDTrainerView.swift
//  GoD Tool
//
//  Created by The Steez on 18/09/2017.
//
//

import Cocoa

class GoDTrainerView: NSView {
	
	init() {
		super.init(frame: .zero)
		self.translatesAutoresizingMaskIntoConstraints = false
		self.wantsLayer = true
		self.layer?.borderWidth = 1
		self.layer?.borderColor = GoDDesign.colourBlack().cgColor
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}

	var delegate : GoDTrainerViewController! {
		didSet {
			setUp()
		}
	}
	
	func setUp() {
		
		let trainer = self.delegate.currentTrainer
		self.setBackgroundColour(GoDDesign.colourRed())
		
	}
	
}
