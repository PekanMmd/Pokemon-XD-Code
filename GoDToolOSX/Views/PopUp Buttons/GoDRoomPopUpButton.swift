//
//  GoDRoomPopUpButton.swift
//  GoD Tool
//
//  Created by The Steez on 03/11/2018.
//

import Cocoa

var roomNames : [String] {
	var names = [String]()

	for i in 0 ..< CommonIndexes.NumberOfRooms.value {
		let room = XGRoom(index: i).name
		if room.length > 0 {
			names.append(room)
		}
	}

	return names.sorted()
}
let rooms = roomNames

class GoDRoomPopUpButton: GoDPopUpButton {

	var selectedValue : XGRoom {
		let name = rooms[self.indexOfSelectedItem]
		return XGRoom.roomWithName(name) ?? XGRoom(index: 0)
	}
	
	func selectItem(room: XGRoom) {
		self.selectItem(withTitle: room.name)
	}
	
	override func setUpItems() {
		self.setTitles(values: rooms)
	}
    
}
