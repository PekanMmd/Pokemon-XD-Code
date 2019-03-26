//
//  XGDoor.swift
//  GoD Tool
//
//  Created by The Steez on 24/03/2019.
//

import Foundation

let kSizeOfDoorData = 0x18

let kDoorFlagsOffset = 0x0
let kDoorUnknown1Offset = 0xa
let kDoorRoomIDOffset = 0xc
let kDoorIdentifierOffset = 0xe
let kDoorUnknown2Offset = 0x10
let kDoorFileIdentifierOffset = 0x14

class XGDoor {
	
	var index = 0
	
	var flags = [Int]()
	var unknown1 = 0
	var unknown2 = 0
	var identifier = 0
	var fileIdentifier : UInt32 = 0
	
	var roomID = 0
	var room : XGRoom? {
		return XGRoom.roomWithID(roomID)
	}
	
	init(index: Int) {
		
		let rel = XGFiles.common_rel.data!
		let start = CommonIndexes.Doors.startOffset + (index * kSizeOfDoorData)
		self.index = index
		
		flags = rel.getByteStreamFromOffset(start, length: 8)
		unknown1 = rel.get2BytesAtOffset(start + kDoorUnknown1Offset)
		unknown2 = rel.get2BytesAtOffset(start + kDoorUnknown2Offset)
		
		identifier = rel.get2BytesAtOffset(start + kDoorIdentifierOffset)
		fileIdentifier = rel.getWordAtOffset(start + kDoorFileIdentifierOffset)
		
		roomID = rel.get2BytesAtOffset(start + kDoorRoomIDOffset)
		
	}
	
	func save() {
		let rel = XGFiles.common_rel.data!
		let start = CommonIndexes.Doors.startOffset + (self.index * kSizeOfDoorData)
		
		rel.replaceBytesFromOffset(start, withByteStream: flags)
		rel.replace2BytesAtOffset(start + kDoorUnknown1Offset, withBytes: unknown1)
		rel.replace2BytesAtOffset(start + kDoorUnknown2Offset, withBytes: unknown2)
		
		rel.replace2BytesAtOffset(start + kDoorIdentifierOffset, withBytes: identifier)
		rel.replace2BytesAtOffset(start + kDoorRoomIDOffset, withBytes: roomID)
		
		rel.replaceWordAtOffset(start + kDoorFileIdentifierOffset, withBytes: fileIdentifier)
		
		rel.save()
	}
	
	
}













