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
		
		self.initialise()
	}
	
	init() {
		super.init(frame: .zero, pullsDown: false)
		
		self.initialise()
	}
	
	func initialise() {
		self.removeAllItems()
		self.setUpItems()
	}
	
	func setUpItems() {
		return
	}
	
	func setTitles(values: [String]) {
		
		if self.itemTitles.count > 0 {
			self.removeAllItems()
		}
		
		var titles = values
		
		for i in 1 ..< titles.count {
			
			let original = titles[i]
			
			let previous = titles[0 ..< i]
			if previous.contains(original) {
				
				var current = original
				var counter = 2
				
				while previous.contains(current) {
					current = original + " (\(counter))"
					counter += 1
				}
				
				titles[i] = current
			}
			
		}
		
		self.addItems(withTitles: titles)
	}
	
}
