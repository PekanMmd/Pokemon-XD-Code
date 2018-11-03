//
//  GoDTableCellView.swift
//  GoD Tool
//
//  Created by StarsMmd on 01/07/2016.
//  Copyright © 2016 StarsMmd. All rights reserved.
//

import AppKit

class GoDTableCellView: NSImageView {
	
	var titleField = NSTextField()
	var imageView = NSImageView()

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
	
	init(title: String, colour: NSColor, showsImage: Bool, image: NSImage?, background: NSImage?, fontSize: CGFloat, width: NSNumber) {
		super.init(frame: .zero)
		
		self.addConstraintWidth(view: self, width: width)
		
		self.identifier = NSUserInterfaceItemIdentifier(rawValue: "cell")
		
		self.imageAlignment = .alignCenter
		self.imageScaling   = .scaleAxesIndependently
		
		self.setTitleColour(colour)
		self.setTitle(title)
		if background != nil {
			self.setBackgroundImage(background!)
		}
		if image != nil {
			self.imageView.image = image!
		}
		
		self.translatesAutoresizingMaskIntoConstraints = false
		self.titleField.translatesAutoresizingMaskIntoConstraints = false
		self.imageView.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(titleField)
		self.addSubview(imageView)
		
		self.titleField.maximumNumberOfLines = title.contains("\n") ? 2 : 1
		self.titleField.isBezeled         = false
		self.titleField.isEditable        = false
		self.titleField.drawsBackground   = false
		self.titleField.refusesFirstResponder = true
		self.titleField.setBackgroundColour(GoDDesign.colourClear())
		self.titleField.font = GoDDesign.fontOfSize(fontSize)
		self.titleField.alignment = .center
		
		
		let views : [String : NSView] = ["t":titleField,"i":imageView]
		
		if showsImage {
		self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[i][t]|", options: [.alignAllTop,.alignAllBottom], metrics: nil, views: views))
		} else {
			self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[t]|", options: [], metrics: nil, views: views))
			self.imageView.isHidden = true
		}
		self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[i]|", options: [], metrics: nil, views: views))
		
		self.addConstraint(NSLayoutConstraint(item: self.imageView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: 0))
		
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	func setTitle(_ title: String) {
		self.titleField.maximumNumberOfLines = title.contains("\n") ? 2 : 1
		self.titleField.stringValue = title
	}
	
	func setTitleColour(_ colour: NSColor) {
		self.titleField.textColor = colour
	}
	
	func setBackgroundImage(_ image: NSImage) {
		self.image = image
	}
	
	func setImage(image: NSImage) {
		self.imageView.image = image
	}
}














