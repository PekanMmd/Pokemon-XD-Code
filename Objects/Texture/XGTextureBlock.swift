//
//  XGTextureBlock.swift
//  XG Tool
//
//  Created by The Steez on 22/05/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//

import UIKit

class XGTextureBlock: NSObject {
	
	var pixels = [Int]()
	
	var length : Int {
		
		get {
			return self.pixels.count
		}
	}
	
	subscript(pos: Int) -> Int {
		
		return pixels[pos]
		
	}
	
	func append(pixel: Int) {
		pixels.append(pixel)
	}
   
}
