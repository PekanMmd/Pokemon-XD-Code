//
//  XGRoom.swift
//  GoD Tool
//
//  Created by The Steez on 28/10/2017.
//
//

import Cocoa

let kSizeOfRoom = game == .XD ? 0x40 : 0x4C

let kRoomIDOffset = game == .XD ? 0x2 : 0xe
let kRoomNameIDOffset = game == .XD ? 0x18 : 0x24
let kRoomGroupIDOffset = game == .XD ? 0x2e : 0x6 // groupid of fsys archive for room

class XGRoom: NSObject {
	
	@objc var nameID = 0
	@objc var location : String {
		return XGFiles.common_rel.stringTable.stringSafelyWithID(self.nameID).string
	}
	
	@objc var name : String {
		if game == .XD {
			if XGFiles.json("Room IDs").exists {
				let ids = XGFiles.json("Room IDs").json
				return (ids as! [String : String])[roomID.hexString()] ?? (ISO.getFSYSNameWithGroupID(self.groupID) ?? "-")
			} else {
				return ISO.getFSYSNameWithGroupID(self.groupID) ?? "-"
			}
		} else {
			return ISO.getFSYSNameWithGroupID(self.groupID) ?? "-"
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
	@objc var groupID = 0
	
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
		self.groupID = data.get2BytesAtOffset(startOffset + kRoomGroupIDOffset)
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
		if game == .XD {
			let ids = XGFiles.json("Room IDs").json as! [String : String]
			for (id, rname) in ids {
				if rname == name {
					return XGRoom.roomWithID(id.hexStringToInt())
				}
			}
		}
		for i in 0 ..< CommonIndexes.NumberOfRooms.value {
			let room = XGRoom(index: i)
			if room.name == name {
				return room
			}
		}
		return nil
	}
	
}




















