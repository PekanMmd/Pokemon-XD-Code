//
//  GoDAlertViewController.swift
//  GoD Tool
//
//  Created by The Steez on 15/09/2017.
//
//

import Cocoa

class GoDAlertViewController: GoDViewController {
	
	static var titleString = ""
	static var text = ""
	
	var textLabel = NSTextView(frame: .zero)
	
	class func setText(title: String, text: String) {
		self.titleString = title
		self.text = text
	}

    override func viewDidLoad() {
        super.viewDidLoad()

		textLabel.translatesAutoresizingMaskIntoConstraints = false
		self.textLabel.alignment = .center
		self.textLabel.string = GoDAlertViewController.text
		self.title = GoDAlertViewController.titleString
		self.addSubview(textLabel, name: "l")
		self.addConstraintAlignAllEdges(view1: self.view, view2: textLabel)
		self.textLabel.isEditable = false
		self.view.addConstraint(NSLayoutConstraint(item: self.view, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .width, multiplier: 1, constant: 300))
		self.view.addConstraint(NSLayoutConstraint(item: self.view, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .height, multiplier: 1, constant: 100))
		self.view.setBackgroundColour(GoDDesign.colourClear())
    }
	
	class func displayAlert(title: String, text: String) {
		XGThreadManager.manager.runInForegroundAsync {
			self.setText(title: title, text: text)
			printg("\nAlert: \(title)\n\(text)\n")
			appDelegate.performSegue("toAlertVC")
		}
	}
	
}









