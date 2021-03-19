//
//  XGPokemart.swift
//  GoD Tool
//
//  Created by The Steez on 01/11/2017.
//
//

import Foundation

final class XGPokemart: NSObject, Codable {
	
	var index = 0
	
	var items = [XGItems]()
	var firstItemIndex = 0
	var itemsStartOffset : Int {
		get {
			return PocketIndexes.MartItems.startOffset + (firstItemIndex * 2)
		}
	}
	
	init(index: Int) {
		super.init()
		
		let data = pocket.data!
		
		self.index = index
		self.firstItemIndex = data.get2BytesAtOffset(PocketIndexes.MartStartIndexes.startOffset + (index * 4) + 2)
		
		var nextItemOffset = itemsStartOffset
		var nextItem = data.get2BytesAtOffset(nextItemOffset)
		while nextItem != 0 {
			self.items.append(.index(nextItem))
			nextItemOffset += 2
			nextItem = data.get2BytesAtOffset(nextItemOffset)
		}
	}
	
	func save() {
		let data = pocket.data!
		data.replace2BytesAtOffset(PocketIndexes.MartStartIndexes.startOffset + (index * 4) + 2, withBytes: self.firstItemIndex)
		
		var nextItemOffset = itemsStartOffset
		for item in self.items {
			data.replace2BytesAtOffset(nextItemOffset, withBytes: item.scriptIndex)
			nextItemOffset += 2
		}
		data.replace2BytesAtOffset(nextItemOffset, withBytes: 0)
		
		data.save()
	}

}

extension XGPokemart: XGEnumerable {
	var enumerableName: String {
		return "Mart " + String(format: "%03d", index)
	}
	
	var enumerableValue: String? {
		return nil
	}
	
	static var className: String {
		return "Pokemarts"
	}
	
	static var allValues: [XGPokemart] {
		var values = [XGPokemart]()
		for i in 0 ..< PocketIndexes.numberOfMarts.value {
			values.append(XGPokemart(index: i))
		}
		return values
	}
}

extension XGPokemart: XGDocumentable {
	
	var documentableName: String {
		return "Mart \(self.index)"
	}
	
	static var DocumentableKeys: [String] {
		return ["items"]
	}
	
	func documentableValue(for key: String) -> String {
		switch key {
		case "item":
			var itemsString = ""
			for item in items {
				itemsString += "\n" + item.name.string
			}
			return itemsString
		default: return ""
		}
	}
	
	
}

