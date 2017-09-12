//
//  ISAlertView.swift
//  iSpy
//
//  Created by StarsMmd on 30/04/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import UIKit

class XGAlertView: UIView {

	var buttonAction : ((Int) -> Void)!
	var doneButton = XGButton()
	
	var backView = UIView()
	
	var views   = [String : UIView ]()
	var metrics = [String : CGFloat]()
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	class func show(title: String!, message: String, doneButtonTitle: String!, otherButtonTitles: [String]!, buttonAction: ((_ buttonIndex: Int) -> Void)! ) {
		
		let alert = XGAlertView(title: title, message: message, doneButtonTitle: doneButtonTitle, otherButtonTitles: otherButtonTitles, buttonAction: buttonAction)
		alert.show()
	}
	
	convenience init(title: String!, message: String, doneButtonTitle: String!, otherButtonTitles: [String]!, buttonAction: ((_ buttonIndex: Int) -> Void)! ) {
		self.init()
		
		// alert main
		self.backgroundColor = UIColor.orange
		self.layer.cornerRadius = 10
		self.layer.borderColor = UIColor.black.cgColor
		self.layer.borderWidth = 2.0
		self.clipsToBounds = true
		self.translatesAutoresizingMaskIntoConstraints = false
		self.clipsToBounds = false
		self.layer.shadowOpacity = 0.9
		self.layer.shadowOffset = CGSize(width: 5, height: 5)
		self.layer.shadowColor = UIColor.black.cgColor
		self.layer.shadowRadius = 5
		
		let viewWidth = UIScreen.main.bounds.width
		views["self"] = self
		metrics["viewWidth"] = viewWidth * 0.6
		self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "[self(viewWidth)]", options: [], metrics: metrics, views: views))
		
		
		
		// background
		self.backView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
		self.backView.translatesAutoresizingMaskIntoConstraints = false
		
		// title
		let titleLabel = UILabel()
		titleLabel.text = title ?? "XG Tool"
		titleLabel.textAlignment = .center
		titleLabel.font = UIFont(name: "Helvetica", size: 30)
		titleLabel.adjustsFontSizeToFitWidth = true
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.isUserInteractionEnabled = false
		self.addSubview(titleLabel)
		views["title"] = titleLabel
		
		self.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.9, constant: 0))
		self.addConstraint(NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: titleLabel, attribute: .centerX, multiplier: 1, constant: 0))
		
		// message
		let messageView = UITextView()
		messageView.font = UIFont(name: "Helvetica", size: 20)
		messageView.text = message
		messageView.backgroundColor = UIColor.clear
		messageView.textAlignment = .center
		messageView.isUserInteractionEnabled = false
		messageView.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(messageView)
		views["message"] = messageView
		self.addConstraint(NSLayoutConstraint(item: messageView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.9, constant: 0))
		messageView.sizeToFit()
		metrics["messageHeight"] = 50
		
		
		// Buttons
		var buttons = [XGButton]()
		let buttonTitles = otherButtonTitles ?? []
		
		for i in 0 ... buttonTitles.count {
			
			var button = XGButton()
			var buttonIdentifier = ""
			
			if i < buttonTitles.count {
				button = newButton(buttonTitles[i], tag: i)
				buttonIdentifier = "button" + String(i)
				buttons.append(button)
			} else if (i >= buttonTitles.count) && (doneButtonTitle != nil) {
				self.doneButton = newButton(doneButtonTitle, tag: i)
				button = doneButton
				buttonIdentifier = "doneButton"
			}
			
			button.translatesAutoresizingMaskIntoConstraints = false
			
			self.addSubview(button)
			views[buttonIdentifier] = button
			
			self.addConstraint(NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.3, constant: 0))
			self.addConstraint(NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 75))
		}
		
		
		// Layout
		
		var formatString = "V:|-(10)-[title(60)]-(20)-[message(messageHeight)]-(30)-"
		
		for i in 0 ..< buttons.count {
			let buttonName = "button" + String(i)
			formatString = formatString + "["
			formatString = formatString + buttonName
			formatString = formatString + "]-(10)-"
		}
		
		if doneButtonTitle != nil {
			formatString = formatString + "[doneButton]-(20)-"
		}
		
		formatString = formatString + "|"
		
		self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: formatString, options: .alignAllCenterX, metrics: metrics, views: views))
		
		// button action
		self.buttonAction = buttonAction
		
	}
	
	func show() {
		
		let views = ["self" : self, "back" : backView]
		
		let window = UIApplication.shared.keyWindow
		window?.addSubview(backView)
		window?.addSubview(self)
		window?.addConstraint(NSLayoutConstraint(item: window!, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
		window?.addConstraint(NSLayoutConstraint(item: window!, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
		window?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[back]|", options: [], metrics: nil, views: views))
		window?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[back]|", options: [], metrics: nil, views: views))
		
	}
	
	func dismiss() {
		
		UIView.animate(withDuration: 0.25, animations: {
			
			self.alpha = 0
			self.backView.alpha = 0
			
		}, completion: { (Bool) -> Void in
			self.removeFromSuperview()
			self.backView.removeFromSuperview()
		})
		
	}

	func buttonTapped(_ sender: XGButton) {
		if sender == self.doneButton {
			self.dismiss()
			return
		} else {
			if self.buttonAction != nil {
				self.buttonAction(sender.tag)
			}
			self.dismiss()
		}
	}
	
	func newButton(_ title: String, tag: Int) -> XGButton {
		
		let button = XGButton()
		button.backgroundColor = UIColor.blue
		button.layer.borderColor = UIColor.white.cgColor
		button.layer.borderWidth = 2.0
		button.layer.cornerRadius = 10.0
		button.setTitleColor(UIColor.white, for: UIControlState())
		button.setTitle(title, for: UIControlState())
		button.addTarget(self, action: #selector(XGAlertView.buttonTapped(_:)), for: .touchUpInside)
		button.tag = tag
		
		button.titleLabel?.font = UIFont(name: "Helvetica", size: 30)
		button.titleLabel?.adjustsFontSizeToFitWidth = true
		
		button.translatesAutoresizingMaskIntoConstraints = false
		
		return button
	}
	
	
}














