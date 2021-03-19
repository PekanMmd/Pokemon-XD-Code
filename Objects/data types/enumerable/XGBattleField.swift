//
//  XGBattleField.swift
//  GoD Tool
//
//  Created by The Steez on 28/10/2017.
//
//

import Foundation

let kSizeOfBattleFieldData = 0x18
let kBattleFieldRoomTypeOffset = 0x00
let kBattleFieldRoomIDOffset = 0x02

final class XGBattleField: NSObject, Codable {

	var roomTypeID = 0
	var roomID = 0
	var room: XGRoom? {
		return XGRoom.roomWithID(roomID)
	}
	
	var index = 0
	var startOffset = 0
	
	init(index: Int) {
		super.init()
		
		self.index = index
		startOffset = CommonIndexes.BattleFields.startOffset + (index * kSizeOfBattleFieldData)
		
		let data = XGFiles.common_rel.data!
		
		roomID = data.get2BytesAtOffset(startOffset + kBattleFieldRoomIDOffset)
		roomTypeID = data.getByteAtOffset(startOffset + kBattleFieldRoomTypeOffset)
	}
	

}

extension XGBattleField: XGEnumerable {
	var enumerableName: String {
		return room?.name ?? "-"
	}
	
	var enumerableValue: String? {
		return String(format: "%03d", index)
	}
	
	static var className: String {
		return "Battlefields"
	}
	
	static var allValues: [XGBattleField] {
		var values = [XGBattleField]()
		for i in 0 ..< CommonIndexes.NumberOfBattleFields.value {
			values.append(XGBattleField(index: i))
		}
		return values
	}
}
