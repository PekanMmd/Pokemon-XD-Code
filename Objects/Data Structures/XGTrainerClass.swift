//
//  XGTrainerClass.swift
//  XG Tool
//
//  Created by The Steez on 16/06/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//

import UIKit

let kFirstTrainerClassDataOffset	= 0xEA40
let kSizeOfTrainerClassEntry		= 0x0C
let kNumberOfTrainerClasses			= 0x33

// Prize money is payout * max pokemon level * 2
let kTrainerClassPayoutOffset		= 0x00
let kTrainerClassNameIDOffset		= 0x06

class XGTrainerClass: NSObject {
	
	var payout = 0
	var nameID = 0
	
	var tClass = XGTrainerClasses.None
	
	var name : String {
		get {
			return XGStringTable.common_rel().stringSafelyWithID(self.nameID).string
		}
	}
	
	var startOffset : Int {
		get {
			return kFirstTrainerClassDataOffset + (self.tClass.rawValue * kSizeOfTrainerClassEntry)
		}
	}
	
	init(tClass : XGTrainerClasses) {
		super.init()
		
		let rel = XGFiles.Common_rel.data
		let start = self.startOffset
		
		self.payout = rel.get2BytesAtOffset(start + kTrainerClassPayoutOffset)
		self.nameID = rel.get2BytesAtOffset(start + kTrainerClassNameIDOffset)
		
	}
	
	func save() {
		
		var rel = XGFiles.Common_rel.data
		let start = self.startOffset
		
		rel.replace2BytesAtOffset(start + kTrainerClassNameIDOffset, withBytes: self.nameID)
		rel.replace2BytesAtOffset(start + kTrainerClassPayoutOffset, withBytes: self.payout)
		rel.save()
	}
   
}



















