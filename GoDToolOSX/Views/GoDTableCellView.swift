//
//  GoDTableCellView.swift
//  GoD Tool
//
//  Created by StarsMmd on 01/07/2016.
//  Copyright © 2016 StarsMmd. All rights reserved.
//

import AppKit

class GoDTableCellView: NSImageView {
	
	let titleField = NSTextField()
	private let imageView = NSImageView()
	private var imageViewConstraint: NSLayoutConstraint? {
		willSet {
			imageViewConstraint?.isActive = false
		}
		didSet {
			imageViewConstraint?.isActive = true
		}
	}

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
	
	init(title: String, colour: NSColor, image: NSImage? = nil, background: NSImage? = nil, fontSize: CGFloat, width: NSNumber) {
		super.init(frame: .zero)
		
		addConstraintWidth(view: self, width: width)
		
		identifier = NSUserInterfaceItemIdentifier(rawValue: "cell")
		
		imageAlignment = .alignCenter
		imageScaling   = .scaleAxesIndependently
		
		setTitleColour(colour)
		setTitle(title)
		setBackgroundImage(background)
		imageView.image = image
		
		translatesAutoresizingMaskIntoConstraints = false
		titleField.translatesAutoresizingMaskIntoConstraints = false
		imageView.translatesAutoresizingMaskIntoConstraints = false
		addSubview(titleField)
		addSubview(imageView)
		
		titleField.maximumNumberOfLines = title.contains("\n") ? 2 : 1
		titleField.isBezeled         = false
		titleField.isEditable        = false
		titleField.drawsBackground   = false
		titleField.refusesFirstResponder = true
		titleField.setBackgroundColour(GoDDesign.colourClear())
		titleField.font = GoDDesign.fontOfSize(fontSize)
		titleField.alignment = .center
		
		
		let views : [String : NSView] = ["t":titleField,"i":imageView]

		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[i][t]|", options: [.alignAllTop,.alignAllBottom], metrics: nil, views: views))
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[i]|", options: [], metrics: nil, views: views))
		if image == nil {
			imageViewConstraint = imageView.widthAnchor.constraint(equalToConstant: 0)
		} else {
			imageViewConstraint = NSLayoutConstraint(item: self.imageView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: 0)
		}
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
	
	func setBackgroundImage(_ image: NSImage?) {
		self.image = image
	}
	
	func setImage(image: NSImage) {
		self.imageView.image = image
	}
}














