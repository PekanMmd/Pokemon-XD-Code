//
//  XGRoom.swift
//  GoD Tool
//
//  Created by The Steez on 28/10/2017.
//
//

import Cocoa

let kSizeOfRoom = game == .XD ? 0x40 : 0x4C

let kRoomIDOffset = game == .XD ? 0x2 : 0x6
let kRoomNameIDOffset = game == .XD ? 0x18 : 0x24

class XGRoom: NSObject {
	
	@objc var nameID = 0
	@objc var location : String {
		return XGFiles.common_rel.stringTable.stringSafelyWithID(self.nameID).string
	}
	
	@objc var name : String {
		if game == .XD {
			let ids = XGFiles.json("Room IDs").json
			return (ids as! [String : String])[roomID.hexString()] ?? "-"
		} else {
			let start = CommonIndexes.RoomData.startOffset + (0x18 * index)
			let id =  XGFiles.common_rel.data!.getWordAtOffset(start + 4).int
			return XGFiles.common_rel.stringTable.stringSafelyWithID(id).string
		}
	}
	
	@objc var mapName : String {
		return getStringSafelyWithID(id: nameID).string
	}
	
	var map : XGMaps {
		let id = self.name.substring(from: 0, to: 2)
		return XGMaps(rawValue: id) ?? .Unknown
	}
	
	@objc var roomID = 0
	
	@objc var index = 0
	@objc var startOffset = 0
	
	@objc var rawData : [Int] {
		return XGFiles.common_rel.data!.getByteStreamFromOffset(startOffset, length: kSizeOfRoom)
	}

	@objc init(index: Int) {
		super.init()
		
		self.index = index
		self.startOffset = CommonIndexes.Rooms.startOffset + (index * kSizeOfRoom)
		
		let data = XGFiles.common_rel.data!
		
		self.roomID = data.get2BytesAtOffset(startOffset + kRoomIDOffset)
		self.nameID = data.getWordAtOffset(startOffset + kRoomNameIDOffset).int
		
	}
	
	@objc class func roomWithID(_ id: Int) -> XGRoom? {
		for i in 0 ..< CommonIndexes.NumberOfRooms.value {
			let room = XGRoom(index: i)
			if room.roomID == id {
				return room
			}
		}
		return nil
	}
	
	@objc class func roomWithName(_ name: String) -> XGRoom? {
		let ids = XGFiles.json("Room IDs").json as! [String : String]
		for (id, rname) in ids {
			if rname == name {
				return XGRoom.roomWithID(id.hexStringToInt())
			}
		}
		return nil
	}
	
}










