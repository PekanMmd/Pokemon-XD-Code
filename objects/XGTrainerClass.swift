//
//  XGTrainerClass.swift
//  XG Tool
//
//  Created by StarsMmd on 16/06/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

let kFirstTrainerClassDataOffset	= CommonIndexes.TrainerClasses.startOffset
let kSizeOfTrainerClassEntry		= 0x0C
let kNumberOfTrainerClasses			= CommonIndexes.NumberOfTrainerClasses.value

// Prize money is payout * max pokemon level * 2
let kTrainerClassPayoutOffset		= 0x00
let kTrainerClassNameIDOffset		= 0x04

class XGTrainerClass: NSObject {
	
	@objc var payout = 0
	@objc var nameID = 0
	
	var tClass = XGTrainerClasses.none
	
	@objc var name : XGString {
		get {
			return XGFiles.common_rel.stringTable.stringSafelyWithID(self.nameID)
		}
	}
	
	@objc var startOffset : Int {
		get {
			return kFirstTrainerClassDataOffset + (self.tClass.rawValue * kSizeOfTrainerClassEntry)
		}
	}
	
	@objc var dictionaryRepresentation : [String : AnyObject] {
		get {
			var dictRep = [String : AnyObject]()
			dictRep["name"] = self.name.string as AnyObject?
			dictRep["payout"] = self.payout as AnyObject?
			
			
			return dictRep
		}
	}
	
	@objc var readableDictionaryRepresentation : [String : AnyObject] {
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
		self.nameID = rel.get4BytesAtOffset(start + kTrainerClassNameIDOffset).int
		
	}
	
	@objc func save() {
		
		let rel = XGFiles.common_rel.data
		let start = self.startOffset
		
		rel.replaceWordAtOffset(start + kTrainerClassNameIDOffset, withBytes: UInt32(self.nameID))
		rel.replace2BytesAtOffset(start + kTrainerClassPayoutOffset, withBytes: self.payout)
		rel.save()
	}
   
}



















