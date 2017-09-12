//
//  XGPNGBlock.swift
//  XG Tool
//
//  Created by StarsMmd on 22/05/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

class XGPNGBlock: NSObject {
	
	var pixels = [XGColour]()
	
	var length : Int {
		
		get {
			return self.pixels.count
		}
	}
	
	subscript(pos: Int) -> XGColour {
		
		return pixels[pos]
		
	}
	
	func append(_ pixel: XGColour) {
		pixels.append(pixel)
	}
   
}
