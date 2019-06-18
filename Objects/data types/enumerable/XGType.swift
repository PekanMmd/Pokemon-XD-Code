//
//  XGTypeData.swift
//  XG Tool
//
//  Created by StarsMmd on 19/05/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

//let kFirstTypeOffset = 0xA7C30
let kCategoryOffset = 0x0
let kTypeIconBigIDOffset = 0x02
let kTypeIconSmallIDOffset = 0x04
let kTypeNameIDOffset = 0x8
let kFirstEffectivenessOffset = 0xD
let kSizeOfTypeData = 0x30

let kNumberOfTypes = CommonIndexes.NumberOfTypes.value


final class XGType: NSObject, Codable {
	
	@objc var index			 = 0
	@objc var nameID		 = 0
	var category			 = XGMoveCategories.none
	var effectivenessTable	 = [XGEffectivenessValues]()
	
	var iconBigID   = 0
	var iconSmallID = 0
	
	@objc var name : XGString {
		get {
			return XGFiles.common_rel.stringTable.stringSafelyWithID(self.nameID)
		}
	}
	
	@objc var startOffset = 0
	
	@objc init(index: Int) {
		super.init()
		
		let rel			= XGFiles.common_rel.data!
		self.index		= index
		startOffset		= CommonIndexes.Types.startOffset + (index * kSizeOfTypeData)
		
		self.nameID		= rel.getWordAtOffset(startOffset + kTypeNameIDOffset).int
		self.category	= XGMoveCategories(rawValue: rel.getByteAtOffset(startOffset + kCategoryOffset))!
		
		self.iconBigID   = rel.get2BytesAtOffset(startOffset + kTypeIconBigIDOffset)
		self.iconSmallID = rel.get2BytesAtOffset(startOffset + kTypeIconSmallIDOffset)
		
		var offset = startOffset + kFirstEffectivenessOffset
		
		for _ in 0 ..< kNumberOfTypes {
			
			let value = rel.getByteAtOffset(offset)
			let effectiveness = XGEffectivenessValues(rawValue: value)!
			effectivenessTable.append(effectiveness)
			
			offset += 2
			
		}
		
	}
	
	@objc func save() {
		
		let rel = XGFiles.common_rel.data!
		
		rel.replaceByteAtOffset(startOffset + kCategoryOffset, withByte: self.category.rawValue)
		rel.replaceWordAtOffset(startOffset + kTypeNameIDOffset, withBytes: UInt32(self.nameID))
		rel.replace2BytesAtOffset(startOffset + kTypeIconBigIDOffset, withBytes: self.iconBigID)
		rel.replace2BytesAtOffset(startOffset + kTypeIconSmallIDOffset, withBytes: self.iconSmallID)
		
		for i in 0 ..< self.effectivenessTable.count {
			
			let value = effectivenessTable[i].rawValue
			rel.replaceByteAtOffset(startOffset + kFirstEffectivenessOffset + (i * 2), withByte: value)
			// i*2 because each value is 2 bytes apart
			
		}
		
		rel.save()
	}
	
	
}

extension XGType: XGEnumerable {
	var enumerableName: String {
		return name.string
	}
	
	var enumerableValue: String? {
		return String(format: "%02d", index)
	}
	
	static var enumerableClassName: String {
		return "Types"
	}
	
	static var allValues: [XGType] {
		var values = [XGType]()
		for i in 0 ..< CommonIndexes.NumberOfTypes.value {
			values.append(XGType(index: i))
		}
		return values
	}
}








