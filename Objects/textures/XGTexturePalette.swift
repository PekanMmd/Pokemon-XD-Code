//
//  XGTexturePalette.swift
//  XG Tool
//
//  Created by StarsMmd on 22/05/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

class XGTexturePalette: NSObject {
	
	private var palette = [XGColour]()
	
	var length : Int {
		
		get {
			return self.palette.count
		}
	}
	
	subscript(index: Int) -> XGColour {
		return self.palette[index]
	}
	
	func append(_ colour : XGColour) {
		self.palette.append(colour)
	}
	
	func indexForColour(_ colour: XGColour) -> Int? {
		
		for i in 0 ..< palette.count {
			
			if self.palette[i].isEqual(to: colour) {
				return i
			}
			
		}
		
		// Colour isn't in palette yet
		return nil
		
	}
   
}
