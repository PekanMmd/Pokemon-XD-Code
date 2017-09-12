//
//  XGTrainerClass.swift
//  XG Tool
//
//  Created by StarsMmd on 16/06/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

let kFirstTrainerClassDataOffset	= 0xEA40
let kSizeOfTrainerClassEntry		= 0x0C
let kNumberOfTrainerClasses			= 0x33

// Prize money is payout * max pokemon level * 2
let kTrainerClassPayoutOffset		= 0x00
let kTrainerClassNameIDOffset		= 0x06

class XGTrainerClass: NSObject {
	
	var payout = 0
	var nameID = 0
	
	var tClass = XGTrainerClasses.none
	
	var name : XGString {
		get {
			return XGFiles.common_rel.stringTable.stringSafelyWithID(self.nameID)
		}
	}
	
	var startOffset : Int {
		get {
			return kFirstTrainerClassDataOffset + (self.tClass.rawValue * kSizeOfTrainerClassEntry)
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
			
			
			return ["\(self.tClass.rawValue) " + self.name.string : dictRep as AnyObject]
		}
	}
	
	init(tClass : XGTrainerClasses) {
		super.init()
		
		self.tClass = tClass
		
		let rel = XGFiles.common_rel.data
		let start = self.startOffset
		
		self.payout = rel.get2BytesAtOffset(start + kTrainerClassPayoutOffset)
		self.nameID = rel.get2BytesAtOffset(start + kTrainerClassNameIDOffset)
		
	}
	
	func save() {
		
		let rel = XGFiles.common_rel.data
		let start = self.startOffset
		
		rel.replace2BytesAtOffset(start + kTrainerClassNameIDOffset, withBytes: self.nameID)
		rel.replace2BytesAtOffset(start + kTrainerClassPayoutOffset, withBytes: self.payout)
		rel.save()
	}
   
}



















