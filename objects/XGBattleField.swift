//
//  XGBattleField.swift
//  GoD Tool
//
//  Created by The Steez on 28/10/2017.
//
//

import Cocoa

let kSizeOfBattleFieldData = 0x18
let kBattleFieldRoomIDOffset = 0x02

class XGBattleField: NSObject, Codable {
	
	@objc var roomID = 0
	@objc var room : XGRoom? {
		return XGRoom.roomWithID(roomID)
	}
	
	@objc var index = 0
	@objc var startOffset = 0
	
	@objc init(index: Int) {
		super.init()
		
		self.index = index
		self.startOffset = CommonIndexes.BattleFields.startOffset + (index * kSizeOfBattleFieldData)
		
		let data = XGFiles.common_rel.data!
		
		self.roomID = data.get2BytesAtOffset(startOffset + kBattleFieldRoomIDOffset)
		
	}
	

}
