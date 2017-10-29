//
//  XGRoom.swift
//  GoD Tool
//
//  Created by The Steez on 28/10/2017.
//
//

import Cocoa

let kSizeOfRoom = 0x40

let kRoomIDOffset = 0x2
let kRoomNameIDOffset = 0x18

class XGRoom: NSObject {
	
	var nameID = 0
	var name : String {
		return XGFiles.common_rel.stringTable.stringSafelyWithID(self.nameID).string
	}
	
	var roomID = 0
	
	var index = 0
	var startOffset = 0
	
	var rawData : [Int] {
		return XGFiles.common_rel.data.getByteStreamFromOffset(startOffset, length: kSizeOfRoom)
	}

	init(index: Int) {
		super.init()
		
		self.index = index
		self.startOffset = CommonIndexes.Rooms.startOffset + (index * kSizeOfRoom)
		
		let data = XGFiles.common_rel.data
		
		self.roomID = data.get2BytesAtOffset(startOffset + kRoomIDOffset)
		self.nameID = data.get4BytesAtOffset(startOffset + kRoomNameIDOffset).int
		
	}
	
	class func roomWithID(_ id: Int) -> XGRoom? {
		for i in 0 ..< CommonIndexes.NumberOfRooms.value {
			let room = XGRoom(index: i)
			if room.roomID == id {
				return room
			}
		}
		return nil
	}
	
}










