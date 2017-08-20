//
//  XGPopoverField.swift
//  XG Tool
//
//  Created by The Steez on 23/06/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//

import UIKit

class XGPopoverField: UIView {
	
	var title = UILabel()
	var field = XGPopoverButton()
	
	var text : String {
		get {
			return self.field.titleLabel?.text ?? ""
		}
		
		set {
			self.field.titleLabel?.text = newValue
		}
	}
	
	init() {
		super.init(frame: CGRect.zero)
	}

	init(title: String, colour: UIColor, textColour: UIColor, height: CGFloat, width: CGFloat, popover: XGPopover, viewController: XGViewController) {
		super.init(frame: CGRect.zero)
		
		self.translatesAutoresizingMaskIntoConstraints = false
		self.backgroundColor = UIColor.clear
		self.field = XGPopoverButton(title: title, colour: colour, textColour: textColour, popover: popover, viewController: viewController)
		
		self.title.textColor = UIColor.black
		self.title.textAlignment = .center
		self.title.adjustsFontSizeToFitWidth = true
		self.title.translatesAutoresizingMaskIntoConstraints = false
		self.title.text = title
		
		self.addSubview(field)
		self.addSubview(self.title)
		let views = ["f" : field, "t" : self.title] as [String : Any]
		
		self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[t(30)][f]|", options: [.alignAllLeft, .alignAllRight], metrics: nil, views: views))
		
		let metrics = ["w" : width, "h" : height]
		self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[t(w)]|", options: [], metrics: metrics, views: views))
		self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[f(h)]", options: [], metrics: metrics, views: views))
		
	}

	required init?(coder aDecoder: NSCoder) {
	    super.init(coder: aDecoder)
	}

}








