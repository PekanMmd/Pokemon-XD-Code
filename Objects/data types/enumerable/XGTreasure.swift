//
//  XGTreasure.swift
//  GoD Tool
//
//  Created by The Steez on 18/11/2017.
//
//

import Foundation

// all offsets are same for both games
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


final class XGTreasure: NSObject, Codable {
	
	var index = 0
	
	var quantity = 0
	var flag = 0
	var itemID = 0
	var item : XGItems {
		return XGItems.item(itemID)
	}
	
	var modelID = 0

	var model : String {
		return modelID == 0x24 ? "Chest" : "Sparkle"
	}
	
	var roomID = 0
	var room : XGRoom? {
		return XGRoom.roomWithID(roomID)
	}
	
	var xCoordinate : Float = 0.0
	var yCoordinate : Float = 0.0
	var zCoordinate : Float = 0.0
	var angle = 0
	
	var startOffset = 0
	
	init(index: Int) {
		super.init()
		
		self.index = index
		
		let data = XGFiles.common_rel.data!
		self.startOffset = CommonIndexes.TreasureBoxData.startOffset + index * kSizeOfTreasure
		
		self.modelID = data.getByteAtOffset(self.startOffset + kTreasureModelIDOffset)
		self.quantity = data.getByteAtOffset(self.startOffset + kTreasureQuantityOffset)
		self.itemID = data.get2BytesAtOffset(self.startOffset + kTreasureItemIDOffset)
		self.flag = data.get2BytesAtOffset(self.startOffset + kTreasureFlagOffset)
		self.roomID = data.get2BytesAtOffset(self.startOffset + kTreasureRoomIDOffset)
		self.xCoordinate = data.getWordAtOffset(self.startOffset + kTreasureXCoordOffset).hexToSignedFloat()
		self.yCoordinate = data.getWordAtOffset(self.startOffset + kTreasureYCoordOffset).hexToSignedFloat()
		self.zCoordinate = data.getWordAtOffset(self.startOffset + kTreasureZCoordOffset).hexToSignedFloat()
		self.angle = data.get2BytesAtOffset(self.startOffset + kTreasureAngleOffset)
	}
	
	func save() {
		let data = XGFiles.common_rel.data!
		
		data.replaceByteAtOffset(self.startOffset + kTreasureModelIDOffset, withByte: self.modelID)
		data.replaceByteAtOffset(self.startOffset + kTreasureQuantityOffset, withByte: self.quantity)
		data.replace2BytesAtOffset(self.startOffset + kTreasureItemIDOffset, withBytes: self.itemID)
		data.replace2BytesAtOffset(self.startOffset + kTreasureFlagOffset, withBytes: self.flag)
		data.replace2BytesAtOffset(self.startOffset + kTreasureRoomIDOffset, withBytes: self.roomID)
		data.replaceWordAtOffset(self.startOffset + kTreasureXCoordOffset, withBytes: self.xCoordinate.bitPattern)
		data.replaceWordAtOffset(self.startOffset + kTreasureYCoordOffset, withBytes: self.yCoordinate.bitPattern)
		data.replaceWordAtOffset(self.startOffset + kTreasureZCoordOffset, withBytes: self.zCoordinate.bitPattern)
		data.replace2BytesAtOffset(self.startOffset + kTreasureAngleOffset, withBytes: self.angle)
		
		data.save()
	}
	
}

extension XGTreasure: XGEnumerable {
	var enumerableName: String {
		return "Treasure " + String(format: "%03d", index)
	}
	
	var enumerableValue: String? {
		return item.name.string + " x" + quantity.string
	}
	
	static var enumerableClassName: String {
		return "Treasure"
	}
	
	static var allValues: [XGTreasure] {
		var values = [XGTreasure]()
		for i in 0 ..< CommonIndexes.NumberTreasureBoxes.value {
			values.append(XGTreasure(index: i))
		}
		return values
	}
}








