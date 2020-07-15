//
//  CMItems.swift
//  Colosseum Tool
//
//  Created by The Steez on 06/06/2018.
//

import Foundation

enum XGItems {
	
	case item(Int)
	
	var index : Int {
		switch self {
		case .item(let i): return (i > kNumberOfItems && i < 0x250) ? i - 151 : i
		}
	}
	
	var TMIndex : Int {
		return self.index >= XGTMs.tm(1).item.index && self.index <= XGTMs.tm(kNumberOfTMsAndHMs).item.index ? self.index - XGTMs.tm(1).item.index + 1 : -1
	}
	
	var scriptIndex : Int {
		// index used in scripts and pokemarts is different for key items
		return index >= 0x15e ? index + 151 : index
	}
	
	var description : String {
		return self.name.string
	}
	
	var hex : String {
		get {
			return String(format: "0x%x",self.index)
		}
	}
	
	var startOffset : Int {
		get{
			let safeIndex = index < kNumberOfItems ? index : 0
			return kFirstItemOffset + (safeIndex * kSizeOfItemData)
		}
	}
	
	var nameID : Int {
		get {
			let data  = XGFiles.dol.data!
			return Int(data.getWordAtOffset(startOffset + kItemNameIDOffset))
		}
	}
	
	var descriptionID : Int {
		get {
			let data  = XGFiles.dol.data!
			return Int(data.getWordAtOffset(startOffset + kItemDescriptionIDOffset))
		}
	}
	
	var name : XGString {
		get {
			let table = XGFiles.common_rel.stringTable
			return table.stringSafelyWithID(nameID)
		}
	}
	
	var descriptionString : XGString {
		get {
			let table = XGFiles.msg("pocket_menu").stringTable
			return table.stringSafelyWithID(descriptionID)
		}
	}
	
	var data : XGItem {
		get {
			return XGItem(index: self.index)
		}
	}
	
	static func allItems() -> [XGItems] {
		(0 ..< kNumberOfItems).map({ (index) -> XGItems in
			.item(index)
		})
	}
	
	static func pokeballs() -> [XGItems] {
		(0 ... 12).map({ (index) -> XGItems in
			.item(index)
		})
	}
	
}

func allItems() -> [String : XGItems] {
	
	var dic = [String : XGItems]()
	
	for i in 0 ..< kNumberOfItems {
		
		let a = XGItems.item(i)
		
		dic[a.name.string.simplified] = a
		
	}
	
	return dic
}

let items = allItems()

func item(_ name: String) -> XGItems {
	if items[name.simplified] == nil { printg("couldn't find: " + name) }
	return items[name.simplified] ?? .item(0)
}

func allItemsArray() -> [XGItems] {
	var items : [XGItems] = []
	for i in 0 ..< kNumberOfItems {
		items.append(XGItems.item(i))
	}
	return items
}

extension XGItems: Codable {
	enum CodingKeys: String, CodingKey {
		case index, name
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		let index = try container.decode(Int.self, forKey: .index)
		self = .item(index)
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(self.index, forKey: .index)
		try container.encode(self.name.string, forKey: .name)
	}
}

extension XGItems: XGEnumerable {
	var enumerableName: String {
		return name.string.spaceToLength(20)
	}
	
	var enumerableValue: String? {
		return index.string
	}
	
	static var enumerableClassName: String {
		return "Items"
	}
	
	static var allValues: [XGItems] {
		return XGItems.allItems()
	}
}






