//
//  XGColour.swift
//  XG Tool
//
//  Created by The Steez on 23/05/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//

import Foundation

class XGColour: NSObject {
	
	var red		= 0
	var green	= 0
	var blue	= 0
	var alpha	= false
	
	init(red: Int, green: Int, blue: Int, alpha: Int) {
		super.init()
		
		self.red   = red
		self.green = green
		self.blue  = blue
		self.alpha = alpha > 0
		
	}
	
	convenience init(bytes : Int) {
		// currently unused
		self.init(red: 0, green: 0, blue: 0, alpha: 0)
		
		var currentColour = bytes
		
		self.blue = Int(currentColour % 0x20)
		
		currentColour = currentColour / 0x20
		self.green = Int(currentColour % 0x20)
		
		currentColour = currentColour / 0x20
		self.red = Int(currentColour % 0x20)
		
		currentColour = currentColour / 0x20
		self.alpha = currentColour > 0
		
	}
	
	override func isEqual(_ object: Any?) -> Bool {
		
		if object == nil {
			return false
		}
		
		if (object! as AnyObject).isKind(of: XGColour.self) {
			let colour = object! as! XGColour
			
			if !colour.alpha && !self.alpha {
				// both are transparent so accept as equivalent. Helps with compression since all transparent pixels will have the same value.
				
				return true
			}
			
			return (colour.red == self.red) && (colour.green == self.green) && (colour.blue == self.blue) && (colour.alpha == self.alpha)
			
		}
		
		return false
	}
	
	func isEqual(to colour: XGColour, threshold: Int) -> Bool {
		
		func withinThreshold(c1: Int, c2: Int) -> Bool {
			return abs(c1 - c2) < threshold
		}
		
		if !colour.alpha && !self.alpha {
			// both are transparent so accept as equivalent. Helps with compression since all transparent pixels will have the same value.
			
			return true
		}
		
		return withinThreshold(c1: colour.red, c2: self.red) && withinThreshold(c1: colour.green, c2: self.green) && withinThreshold(c1: colour.blue, c2: self.blue) && (colour.alpha == self.alpha)
	}
	
	func convertTo16Bits() -> (Int, Int) {
		
		var value = 0
		
		let alpha = self.alpha ? 1 : 0
		value = alpha << 15
		
		value += red   << 10
		value += green << 5
		value += blue
		
		let value1 = value / 0x100
		let value2 = value % 0x100
		
		return (value1, value2)
		
	}
	
	
	class func none() -> XGColour {
		return XGColour(red: 0, green: 0, blue: 0, alpha: 0)
	}
	
	
}














