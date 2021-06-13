//
//  XGRoom.swift
//  GoD Tool
//
//  Created by The Steez on 28/10/2017.
//
//

import Foundation

let kSizeOfRoom: Int = {
	if game == .XD {
		return region == .JP ? 0x30 : 0x40
	} else {
		return region == .EU ? 0x5C : 0x4C
	}
}()

let kRoomIDOffset: Int = {
	if game == .XD {
		return 0x2
	} else {
		return region == .EU ? 0xA : 0xE
	}
}()

let kRoomNameIDOffset: Int = {
	if game == .XD {
		return region == .JP ? 0x1C : 0x18
	} else {
		return region == .EU ? 0x20 : 0x24
	}
}()

let kRoomGroupIDOffset: Int = {
	if game == .XD {
		return region == .JP ? 0x30 : 0x2E
	} else {
		return region == .EU ? 0x4A : 0x6
	}
}() // groupid of fsys archive for room

let kRoomTypeOffset = 0x0

final class XGRoom: NSObject, Codable {
	
	var nameID = 0
	var location: String {
		return XGFiles.common_rel.stringTable.stringSafelyWithID(self.nameID).string
	}
	
	var name: String {
		if XGFiles.json("Room IDs").exists {
			let ids = XGFiles.json("Room IDs").json
			return (ids as! [String : String])[roomID.hexString()] ?? (XGISO.current.getFSYSNameWithGroupID(self.groupID) ?? "-")
		} else {
			return XGISO.current.getFSYSNameWithGroupID(self.groupID) ?? "-"
		}
	}
	
	var mapName: String {
		return getStringSafelyWithID(id: nameID).string
	}

	var fsysFilename: String? {
		XGISO.current.getFSYSNameWithGroupID(groupID)
	}
	
	var map: XGMaps {
		let id = self.name.substring(from: 0, to: 2)
		return XGMaps(rawValue: id) ?? .Unknown
	}
	
	var roomID = 0
	var groupID = 0
	
	var index = 0
	var startOffset = 0
	
	var rawData : [Int] {
		return XGFiles.common_rel.data!.getByteStreamFromOffset(startOffset, length: kSizeOfRoom)
	}

	init(index: Int) {
		super.init()
		
		self.index = index
		self.startOffset = CommonIndexes.Rooms.startOffset + (index * kSizeOfRoom)
		
		let data = XGFiles.common_rel.data!
		
		self.roomID = data.get2BytesAtOffset(startOffset + kRoomIDOffset)
		self.groupID = data.get2BytesAtOffset(startOffset + kRoomGroupIDOffset)
		self.nameID = data.getWordAtOffset(startOffset + kRoomNameIDOffset).int
		
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
	
	class func roomWithName(_ name: String) -> XGRoom? {
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

	var script: XGFiles? {
		if let fsys = fsysFilename {
			return .typeAndFsysName(.scd, fsys.removeFileExtensions())
		}
		return nil
	}
	
}

extension XGRoom: XGEnumerable {
	var enumerableName: String {
		return name
	}
	
	var enumerableValue: String? {
		return String(format: "%03d", index)
	}
	
	static var className: String {
		return "Rooms"
	}
	
	static var allValues: [XGRoom] {
		var values = [XGRoom]()
		for i in 0 ..< CommonIndexes.NumberOfRooms.value {
			values.append(XGRoom(index: i))
		}
		return values
	}
}


















