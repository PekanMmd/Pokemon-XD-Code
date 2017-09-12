//
//  XGTextField.swift
//  XG Tool
//
//  Created by StarsMmd on 21/06/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class XGValueTextField: XGTextField {

	var min : Int!
	var max	: Int!
	
	var value : Int {
		get {
			return Int(self.text) ?? 0
		}
		
		set {
			self.text = String(newValue)
		}
	}
	
	override init() {
		super.init()
	}

	required init?(coder aDecoder: NSCoder) {
	    super.init(coder: aDecoder)
	}
	
	convenience init(title: String, min: Int?, max: Int?, height: CGFloat, width: CGFloat, action: @escaping ( () -> Void) ) {
		self.init(title: title, value: (min ?? 0), min: min, max: max, height: height, width: width, action: action )
	}
	
	convenience init(title: String, value: Int, min: Int?, max: Int?, height: CGFloat, width: CGFloat, action: @escaping ( () -> Void) ) {
		self.init(title: title, text: String(min ?? 0), height: height, width: width, action: action)
		
		self.field.keyboardType = .numbersAndPunctuation
		self.min = min
		self.max = max
		self.value = value
		
	}

	override func textFieldDidEndEditing(_ textField: UITextField) {
		
		let value = Int(field.text!)
		
		if value == nil {
			field.text = "0"
		}
		
		if min != nil {
			if value < min {
				self.value = min
			}
		}
		
		if max != nil {
			if value > max {
				self.value = max
			}
		}
		
		self.action()
	}
	
}






















