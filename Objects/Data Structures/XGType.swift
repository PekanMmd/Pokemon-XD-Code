//
//  XGTypeData.swift
//  XG Tool
//
//  Created by The Steez on 19/05/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//

import UIKit

let kFirstTypeOffset = 0xA7C30

let kCategoryOffset = 0x0
let kTypeNameIDOffset = 0xA
let kFirstEffectivenessOffset = 0xD
let kSizeOfTypeData = 0x30

let kNumberOfTypes = 0x12

class XGType: NSObject {
	
	var index				 = 0
	var nameID				 = 0
	var category			 = XGMoveCategories.None
	var effectivenessTable	 = [XGEffectivenessValues]()
	var type				 = XGMoveTypes.Normal
	
	var startOffset = 0
	
	init(index: Int) {
		super.init()
		
		var rel			= XGFiles.Common_rel.data
		self.index		= index
		startOffset		= kFirstTypeOffset + (index * kSizeOfTypeData)
		
		
		self.type		= XGMoveTypes(rawValue: index)!
		self.nameID		= rel.get2BytesAtOffset(startOffset + kTypeNameIDOffset)
		self.category	= XGMoveCategories(rawValue: rel.getByteAtOffset(startOffset + kCategoryOffset))!
		
		var offset = startOffset + kFirstEffectivenessOffset
		
		for var i = 0; i < kNumberOfTypes; i++ {
			
			var value = rel.getByteAtOffset(offset)
			var effectiveness = XGEffectivenessValues(rawValue: value)!
			effectivenessTable.append(effectiveness)
			
			offset += 2
			
		}
		
	}
	
	func save() {
		
		var rel = XGFiles.Common_rel.data
		
		rel.replaceByteAtOffset(startOffset + kCategoryOffset, withByte: self.category.rawValue)
		
		for var i = 0; i < self.effectivenessTable.count; i++ {
			
			var value = effectivenessTable[i].rawValue
			rel.replaceByteAtOffset(startOffset + kFirstEffectivenessOffset + (i * 2), withByte: value)
			// i*2 because each value is 2 bytes apart
			
		}
		
		rel.save()
	}
	
	
}











