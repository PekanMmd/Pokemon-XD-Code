//
//  XGTexturePalette.swift
//  XG Tool
//
//  Created by The Steez on 22/05/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//

import UIKit

class XGTexturePalette: NSObject {
	
	var palette = [XGColour]()
	
	var length : Int {
		
		get {
			return self.palette.count
		}
	}
	
	subscript(index: Int) -> XGColour {
		return palette[index]
	}
	
	func append(colour : XGColour) {
		self.palette.append(colour)
	}
	
	func indexForColour(colour: XGColour) -> Int? {
		
		for var i = 0; i < palette.count; i++ {
			
			if palette[i].isEqual(colour) {
				return i
			}
			
		}
		
		// Colour isn't in palette yet
		return nil
		
	}
   
}
