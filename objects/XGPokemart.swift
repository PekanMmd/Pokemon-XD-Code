//
//  XGPokemart.swift
//  GoD Tool
//
//  Created by The Steez on 01/11/2017.
//
//

import Cocoa

class XGPokemart: NSObject {
	
	var index = 0
	
	var items = [XGItems]()
	
	init(index: Int) {
		super.init()
		
		let data = pocket.data!
		
		let itemsStartPointer = data.get2BytesAtOffset( PocketIndexes.MartStartIndexes.startOffset + (index * 4) + 2)
		let itemsStart = PocketIndexes.MartItems.startOffset + (itemsStartPointer * 2)
		
		var nextItemOffset = itemsStart
		var nextItem = data.get2BytesAtOffset(nextItemOffset)
		while nextItem != 0 {
			self.items.append(.item(nextItem))
			nextItemOffset += 2
			nextItem = data.get2BytesAtOffset(nextItemOffset)
		}
		
		
	}

}
