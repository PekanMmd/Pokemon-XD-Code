//
//  NSViewExtensions.swift
//  GoD Tool
//
//  Created by StarsMmd on 29/06/2016.
//  Copyright © 2016 StarsMmd. All rights reserved.
//

import Cocoa

extension NSView {

	func setBackgroundColour(_ colour: XGColour) {
		setBackgroundColour(colour.NSColour)
	}
	
	func setBackgroundColour(_ colour: NSColor) {
		self.wantsLayer = true
		self.layer?.backgroundColor = colour.cgColor
	}

	func addBorder(colour: XGColour, width: CGFloat) {
		addBorder(colour: colour.NSColour, width: width)
	}
	
	func addBorder(colour: NSColor, width: CGFloat) {
		self.wantsLayer = true
		self.layer?.borderWidth = width
		self.layer?.borderColor = colour.cgColor
	}
	
	func removeBorder() {
		self.wantsLayer = true
		self.layer?.borderWidth = 0
	}
}

// MARK: - Constraints -
extension NSView {

	func pin(to view: NSView, padding: CGFloat = 0) {
		pinTop(to: view, padding: padding)
		pinBottom(to: view, padding: padding)
		pinLeading(to: view, padding: padding)
		pinTrailing(to: view, padding: padding)
	}

	func pinTop(to view: NSView, padding: CGFloat = 0) {
		topAnchor.constraint(equalTo: view.topAnchor, constant: padding).isActive = true
	}

	func pinBottom(to view: NSView, padding: CGFloat = 0) {
		bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding).isActive = true
	}

	func pinLeading(to view: NSView, padding: CGFloat = 0) {
		leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding).isActive = true
	}

	func pinTrailing(to view: NSView, padding: CGFloat = 0) {
		trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding).isActive = true
	}

	func pinTopToBottom(of view: NSView, padding: CGFloat = 0) {
		topAnchor.constraint(equalTo: view.bottomAnchor, constant: padding).isActive = true
	}

	func pinLeadingToTrailing(of view: NSView, padding: CGFloat = 0) {
		leadingAnchor.constraint(equalTo: view.trailingAnchor, constant: padding).isActive = true
	}

	func pinCenterX(to view: NSView, padding: CGFloat = 0) {
		centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: padding).isActive = true
	}

	func pinCenterY(to view: NSView, padding: CGFloat = 0) {
		centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: padding).isActive = true
	}

	func pinHeight(as height: CGFloat) {
		heightAnchor.constraint(equalToConstant: height).isActive = true
	}

	func pinWidth(as width: CGFloat) {
		widthAnchor.constraint(equalToConstant: width).isActive = true
	}

	func constrainWidthEqual(to view: NSView) {
		widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
	}

	func constrainHeightEqual(to view: NSView) {
		heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1).isActive = true
	}
}
