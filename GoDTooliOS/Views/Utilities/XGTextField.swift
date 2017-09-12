//
//  XGTextField.swift
//  XG Tool
//
//  Created by StarsMmd on 22/06/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import UIKit

class XGTextField: UIView, UITextFieldDelegate {
	
	var title = UILabel()
	var field = UITextField()
	
	var action : ( () -> Void  )!
	
	var text : String {
		get {
			return self.field.text!
		}
		
		set {
			self.field.text = newValue
		}
	}
	
	init() {
		super.init(frame: CGRect.zero)
		
		self.backgroundColor = UIColor.clear
		self.translatesAutoresizingMaskIntoConstraints = false
		
		self.field.clipsToBounds = false
		self.field.layer.shadowOpacity = 0.9
		self.field.layer.shadowOffset = CGSize(width: 5, height: 5)
		self.field.layer.shadowColor = UIColor.black.cgColor
		self.field.layer.shadowRadius = 5
		
		self.title.textColor = UIColor.black
		self.title.textAlignment = .center
		self.title.adjustsFontSizeToFitWidth = true
		self.title.translatesAutoresizingMaskIntoConstraints = false
		
		self.field.backgroundColor = UIColor.black
		self.field.textColor = UIColor.orange
		self.field.delegate = self
		self.field.adjustsFontSizeToFitWidth = true
		self.field.textAlignment = .center
		self.field.layer.cornerRadius = 10
		self.field.translatesAutoresizingMaskIntoConstraints = false
		
		self.title.text = "Text"
		self.field.text = "-"
		
		self.addSubview(field)
		self.addSubview(title)
		let views = ["f" : field, "t" : title] as [String : Any]
		
		self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[t(30)][f]|", options: [.alignAllLeft, .alignAllRight], metrics: nil, views: views))
		
	}
	
	convenience init(title: String, height: CGFloat, width: CGFloat, action: @escaping (() -> Void)) {
		self.init(title: title, text: "", height: height, width: width, action: action)
	}
	
	convenience init(title: String, text: String, height: CGFloat, width: CGFloat, action: @escaping (() -> Void)) {
		self.init()
		
		let views = ["t" : self.title, "f" : self.field] as [String : Any]
		let metrics = ["w" : width, "h" : height]
		self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[t(w)]|", options: [], metrics: metrics, views: views))
		self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[f(h)]", options: [], metrics: metrics, views: views))
		
		self.title.text = title
		self.field.text = text
		self.action = action
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		
		self.action()
		
	}
	
}
