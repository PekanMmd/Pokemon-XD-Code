//
//  GoDAlertViewController.swift
//  GoD Tool
//
//  Created by The Steez on 15/09/2017.
//
//

import Cocoa

class GoDAlertViewController: GoDViewController {
	
	
	var textLabel = NSTextField(frame: .zero)
	
	func setText(title: String, text: String) {
		self.title = title
		self.textLabel.stringValue = text
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.textLabel.alignment = .center
		self.textLabel.sizeToFit()
		let width = min(Float(self.textLabel.frame.width), 200)
		self.addSubview(textLabel, name: "l")
		self.addConstraintAlignAllEdges(view1: self.view, view2: textLabel)
		self.addConstraintWidth(view: self.view, width: NSNumber(value: width))
		self.textLabel.isEditable = false
		
    }
	
	func show(sender: GoDViewController) {
		sender.presentViewControllerAsModalWindow(self)
	}
	
	class func alert(title: String, text: String) -> GoDAlertViewController {
		let storyBoard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
		let alertView = storyBoard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "alert")) as! GoDAlertViewController
		alertView.setText(title: title, text: text)
		return alertView
	}
    
}









