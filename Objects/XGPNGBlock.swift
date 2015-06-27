//
//  XGPNGBlock.swift
//  XG Tool
//
//  Created by The Steez on 22/05/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//

import UIKit

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
	
	func append(pixel: XGColour) {
		pixels.append(pixel)
	}
   
}
