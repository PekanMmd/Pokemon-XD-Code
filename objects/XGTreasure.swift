//
//  XGTreasure.swift
//  GoD Tool
//
//  Created by The Steez on 18/11/2017.
//
//

import Cocoa

let kSizeOfTreasure = 0x1c

let kTreasureModelIDOffset = 0x0
let kTreasureQuantityOffset = 0x1
let kTreasureAngleOffset = 0x2
let kTreasureRoomIDOffset = 0x4
let kTreasureFlagOffset = 0x6
let kTreasureItemIDOffset = 0xE
let kTreasureXCoordOffset = 0x10
let kTreasureYCoordOffset = 0x14
let kTreasureZCoordOffset = 0x18


class XGTreasure: NSObject {
	
	@objc var index = 0
	
	@objc var quantity = 0
	@objc var flag = 0
	@objc var itemID = 0
	var item : XGItems {
		return XGItems.item(itemID)
	}
	
	@objc var modelID = 0

	@objc var model : String {
		return modelID == 0x24 ? "Chest" : "Sparkle"
	}
	
	@objc var roomID = 0
	@objc var room : XGRoom {
		return XGRoom.roomWithID(roomID)!
	}
	
	@objc var xCoordinate : Float = 0.0
	@objc var yCoordinate : Float = 0.0
	@objc var zCoordinate : Float = 0.0
	@objc var angle = 0
	
	@objc var startOffset = 0
	
	@objc init(index: Int) {
		super.init()
		
		self.index = index
		
		let data = XGFiles.common_rel.data
		self.startOffset = CommonIndexes.TreasureBoxData.startOffset + index * kSizeOfTreasure
		
		self.modelID = data.getByteAtOffset(self.startOffset + kTreasureModelIDOffset)
		self.quantity = data.getByteAtOffset(self.startOffset + kTreasureQuantityOffset)
		self.itemID = data.get2BytesAtOffset(self.startOffset + kTreasureItemIDOffset)
		self.flag = data.get2BytesAtOffset(self.startOffset + kTreasureFlagOffset)
		self.roomID = data.get2BytesAtOffset(self.startOffset + kTreasureRoomIDOffset)
		self.xCoordinate = data.get4BytesAtOffset(self.startOffset + kTreasureXCoordOffset).hexToSignedFloat()
		self.yCoordinate = data.get4BytesAtOffset(self.startOffset + kTreasureYCoordOffset).hexToSignedFloat()
		self.zCoordinate = data.get4BytesAtOffset(self.startOffset + kTreasureZCoordOffset).hexToSignedFloat()
		self.angle = data.get2BytesAtOffset(self.startOffset + kTreasureAngleOffset)
	}
	
	@objc func save() {
		let data = XGFiles.common_rel.data
		
		data.replaceByteAtOffset(self.startOffset + kTreasureModelIDOffset, withByte: self.modelID)
		data.replaceByteAtOffset(self.startOffset + kTreasureQuantityOffset, withByte: self.quantity)
		data.replace2BytesAtOffset(self.startOffset + kTreasureItemIDOffset, withBytes: self.itemID)
		data.replace2BytesAtOffset(self.startOffset + kTreasureFlagOffset, withBytes: self.flag)
		data.replace2BytesAtOffset(self.startOffset + kTreasureRoomIDOffset, withBytes: self.roomID)
		data.replace4BytesAtOffset(self.startOffset + kTreasureXCoordOffset, withBytes: self.xCoordinate.bitPattern)
		data.replace4BytesAtOffset(self.startOffset + kTreasureYCoordOffset, withBytes: self.yCoordinate.bitPattern)
		data.replace4BytesAtOffset(self.startOffset + kTreasureZCoordOffset, withBytes: self.zCoordinate.bitPattern)
		data.replace2BytesAtOffset(self.startOffset + kTreasureAngleOffset, withBytes: self.angle)
		
		data.save()
	}
	
}










