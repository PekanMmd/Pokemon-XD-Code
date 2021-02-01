//
//  XGRoomType.swift
//  GoD Tool
//
//  Created by Stars Momodu on 01/02/2021.
//

import Foundation

let kSizeOfRoomType = 0x18

class XGRoomType {
	var index: Int

	var startOffset: Int {
		return 0
	}

	init(index: Int) {
		self.index = index
	}

	func save() {

	}
}
