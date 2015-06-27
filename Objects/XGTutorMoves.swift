//
//  XGTutorMoves.swift
//  XG Tool
//
//  Created by The Steez on 09/06/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//

import UIKit

let kFirstTutorMoveDataOffset	= 0xA7918
let kSizeOfTutorMoveEntry		= 0x0C
let kNumberOfTutorMoveEntries	= 0x0C

let kTutorMoveMoveIndexOffset	= 0x00
let kAvailabilityFlagOffset		= 0x07

class XGTutorMoves: NSObject {
	
	var index	= 0x0
	
	var move	= XGMoves.Move(0)
	var flag	= 0x01
	
	var startOffset : Int {
		get {
			return kFirstTutorMoveDataOffset + (index * kSizeOfTutorMoveEntry)
		}
	}
	
	init(index: Int) {
		super.init()
		
		var rel			= XGFiles.Common_rel.data
		self.index		= index
		
		let start = startOffset
		
		let moveIndex = rel.get2BytesAtOffset(start + kTutorMoveMoveIndexOffset)
		self.move = .Move(moveIndex)
		self.flag = rel.getByteAtOffset(start + kAvailabilityFlagOffset)
		
	}
	
	func save() {
		
		var rel = XGFiles.Common_rel.data
		let start = startOffset
		
		rel.replaceByteAtOffset(start + kAvailabilityFlagOffset, withByte: self.flag)
		rel.replace2BytesAtOffset(start + kTutorMoveMoveIndexOffset, withBytes: move.index)
		
		rel.save()
	}
   
}
























