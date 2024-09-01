//
//  GoDInputViewController.swift
//  GoD Tool
//
//  Created by Stars Momodu on 11/06/2024.
//

import Cocoa

class GoDInputViewController: GoDViewController, NSTextFieldDelegate {
	
	var textLabel = NSTextView(frame: .zero)
	var inputField = NSTextField(frame: .zero)
	var confirmButton = NSButton(frame: .zero)
	
	private var confirmAction: ((String?) -> Void)?
	
	override func loadView() {
		self.view = NSView()
	}
	
	func setText(title: String, text: String, action: @escaping (String?) -> Void) {
		self.title = title
		textLabel.string = text
		confirmAction = action
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		textLabel.translatesAutoresizingMaskIntoConstraints = false
		self.textLabel.alignment = .center
		self.addSubview(textLabel, name: "l")
		self.addSubview(inputField, name: "i")
		self.addSubview(confirmButton, name: "b")
		self.textLabel.isEditable = false
		self.view.addConstraint(NSLayoutConstraint(item: self.view, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .width, multiplier: 1, constant: 300))
		self.view.addConstraint(NSLayoutConstraint(item: self.view, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .height, multiplier: 1, constant: 150))
		self.view.setBackgroundColour(GoDDesign.colourClear())
		confirmButton.title = "Confirm"
		inputField.intValue = 0
		inputField.alignment = .center
		inputField.delegate = self
		self.addConstraintAlignTopEdges(view1: view, view2: textLabel, constant: -10)
		addConstraintAlignTopEdge(view1: inputField, toBottomEdgeOf: textLabel, constant: 10)
		addConstraintAlignTopEdge(view1: confirmButton, toBottomEdgeOf: inputField, constant: 10)
		self.addConstraintAlignBottomEdges(view1: view, view2: confirmButton, constant: 10)
		self.addConstraintAlignLeftAndRightEdges(view1: view, view2: textLabel, constant: -10)
		self.addConstraintAlignLeftAndRightEdges(view1: view, view2: inputField, constant: -10)
		self.addConstraintAlignCenterX(view1: view, view2: confirmButton)
		confirmButton.action = #selector(confirm)
	}
	
	@objc
	func confirm(_ sender: Any) {
		confirmAction?(inputField.stringValue)
	}
}
