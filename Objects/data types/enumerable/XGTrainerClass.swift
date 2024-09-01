//
//  XGTrainerClass.swift
//  XG Tool
//
//  Created by StarsMmd on 16/06/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

let kSizeOfTrainerClassEntry		= 0x0C

// Prize money is payout * max pokemon level * 2
let kTrainerClassPayoutOffset		= 0x00
let kTrainerClassNameIDOffset		= 0x04

final class XGTrainerClass: NSObject, Codable {
	
	var payout = 0
	var nameID = 0
	
	var index = 0
	
	var name : XGString {
		get {
			return XGFiles.common_rel.stringTable.stringSafelyWithID(self.nameID)
		}
	}
	
	var startOffset : Int {
		get {
			return CommonIndexes.TrainerClasses.startOffset + (self.index * kSizeOfTrainerClassEntry)
		}
	}
	
	var dictionaryRepresentation : [String : AnyObject] {
		get {
			var dictRep = [String : AnyObject]()
			dictRep["name"] = self.name.string as AnyObject?
			dictRep["payout"] = self.payout as AnyObject?
			
			
			return dictRep
		}
	}
	
	var readableDictionaryRepresentation : [String : AnyObject] {
		get {
			var dictRep = [String : AnyObject]()
			dictRep["payout"] = self.payout as AnyObject?
			
			
			return ["\(self.index) " + self.name.string : dictRep as AnyObject]
		}
	}
	
	init(index: Int) {
		super.init()
		
		self.index = index
		
		let rel = XGFiles.common_rel.data!
		let start = self.startOffset
		
		
		self.payout = rel.get2BytesAtOffset(start + kTrainerClassPayoutOffset)
		self.nameID = rel.getWordAtOffset(start + kTrainerClassNameIDOffset).int
		
	}
	
	func save() {
		
		let rel = XGFiles.common_rel.data!
		let start = self.startOffset
		
		rel.replaceWordAtOffset(start + kTrainerClassNameIDOffset, withBytes: UInt32(self.nameID))
		rel.replace2BytesAtOffset(start + kTrainerClassPayoutOffset, withBytes: self.payout)
		rel.save()
	}
   
}

extension XGTrainerClass: XGEnumerable {
	var enumerableName: String {
		return name.string
	}
	
	var enumerableValue: String? {
		return String(format: "%02d", index)
	}
	
	static var className: String {
		return "Trainer Classes"
	}
	
	static var allValues: [XGTrainerClass] {
		var values = [XGTrainerClass]()
		for i in 0 ..< CommonIndexes.NumberOfTrainerClasses.value {
			values.append(XGTrainerClass(index: i))
		}
		return values
	}
}

















