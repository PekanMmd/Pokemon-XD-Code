//
//  XGButtonField.swift
//  XG Tool
//
//  Created by StarsMmd on 23/06/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import UIKit

class XGButtonField: XGTextField {
	
	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		
		self.action()
		
		return false
	}
	
	convenience init(title: String, text: String, colour: UIColor, height: CGFloat, width: CGFloat, action: @escaping (() -> Void)) {
		self.init(title: title, text: text, height: height, width: width, action: action)
		
		self.field.backgroundColor  = colour
		self.field.textColor		= UIColor.black
	}
	

}



























