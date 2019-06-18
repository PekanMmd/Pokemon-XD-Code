//
//  XGTextureBlock.swift
//  XG Tool
//
//  Created by StarsMmd on 22/05/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

class XGTextureBlock: NSObject {
	
	private var pixels = [Int]()
	
	var length : Int {
		
		get {
			return self.pixels.count
		}
	}
	
	subscript(pos: Int) -> Int {
		
		return pixels[pos]
		
	}
	
	func append(_ byte: Int) {
		pixels.append(byte)
	}
   
}
