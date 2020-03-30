//
//  CMType.swift
//  Colosseum Tool
//
//  Created by The Steez on 06/06/2018.
//

import Foundation

let kFirstTypeOffset = region == .JP ? 0x344C40 : 0x358500
let kCategoryOffset = 0x0
let kTypeIconBigIDOffset = 0x02
let kTypeIconSmallIDOffset = 0x04 // not available in colosseum
let kTypeNameIDOffset = 0x4
let kFirstEffectivenessOffset = 0x9
let kSizeOfTypeData = 0x2C

let kNumberOfTypes = 0x12

// name id list in dol in colo 0x2e2458

final class XGType: NSObject, Codable {
	
	var index				 = 0
	var nameID				 = 0
	var category			 = XGMoveCategories.none
	var effectivenessTable	 = [XGEffectivenessValues]()
	
	var name : XGString {
		get {
			return XGFiles.common_rel.stringTable.stringSafelyWithID(self.nameID)
		}
	}
	
	var startOffset = 0
	
	init(index: Int) {
		super.init()
		
		let dol			= XGFiles.dol.data!
		self.index		= index
		startOffset		= kFirstTypeOffset + (index * kSizeOfTypeData)
		
		self.nameID		= dol.getWordAtOffset(startOffset + kTypeNameIDOffset).int
		self.category	= XGMoveCategories(rawValue: dol.getByteAtOffset(startOffset + kCategoryOffset))!
		
		var offset = startOffset + kFirstEffectivenessOffset
		
		for _ in 0 ..< kNumberOfTypes {
			
			let value = dol.getByteAtOffset(offset)
			let effectiveness = XGEffectivenessValues(rawValue: value)!
			effectivenessTable.append(effectiveness)
			
			offset += 2
			
		}
		
	}
	
	func save() {
		
		let dol = XGFiles.dol.data!
		
		dol.replaceByteAtOffset(startOffset + kCategoryOffset, withByte: self.category.rawValue)
		
		for i in 0 ..< self.effectivenessTable.count {
			
			let value = effectivenessTable[i].rawValue
			dol.replaceByteAtOffset(startOffset + kFirstEffectivenessOffset + (i * 2), withByte: value)
			// i*2 because each value is 2 bytes apart
			
		}
		
		dol.save()
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
		for i in 0 ..< kNumberOfTypes {
			values.append(XGType(index: i))
		}
		return values
	}
}
