//
//  XGPokemon.swift
//  XG Tool
//
//  Created by StarsMmd on 01/06/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

enum XGItems {
	
	case index(Int)
	
	var index : Int {
		switch self {
		case .index(let i): return (i > CommonIndexes.NumberOfItems.value && i < 0x250) ? i - 150 : i
		}
	}
	
	var TMIndex : Int {
		return self.index >= XGTMs.tm(1).item.index && self.index <= XGTMs.tm(kNumberOfTMsAndHMs).item.index ? self.index - XGTMs.tm(1).item.index + 1 : -1
	}
	
	var scriptIndex : Int {
		// index used in scripts and pokemarts is different for key items
		return index >= 0x15e ? index + 150 : index
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
			return CommonIndexes.Items.startOffset + (safeIndex * kSizeOfItemData)
		}
	}
	
	var nameID : Int {
		get {
			let data  = XGFiles.common_rel.data!
			return Int(data.getWordAtOffset(startOffset + kItemNameIDOffset))
		}
	}
	
	var descriptionID : Int {
		get {
			let data  = XGFiles.common_rel.data!
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
			let table = XGFiles.typeAndFsysName(.msg, "pocket_menu").stringTable
			return table.stringSafelyWithID(descriptionID)
		}
	}
	
	var data : XGItem {
		get {
			return XGItem(index: self.index)
		}
	}
	
	static func allItems() -> [XGItems] {
		var items = [XGItems]()
		for i in 0 ..< CommonIndexes.NumberOfItems.value {
			items.append(.index(i))
		}
		return items
	}
	
	static func pokeballs() -> [XGItems] {
		var items = [XGItems]()
		for i in 0 ... 12 {
			items.append(.index(i))
		}
		return items
	}

	static func random() -> XGItems {
		var rand = 0
		while (rand == 0)
				|| (XGItems.index(rand).nameID == 0)
				|| (XGItems.index(rand).descriptionID == 0)
				|| (XGItems.index(rand).data.bagSlot.rawValue >= XGBagSlots.keyItems.rawValue)
				|| (XGItems.index(rand).data.price == 0) {
			rand = Int.random(in: 1 ..< kNumberOfItems)
		}
		return .index(rand)
	}
}

func allItems() -> [String : XGItems] {
	
	var dic = [String : XGItems]()
	
	for i in 0 ..< CommonIndexes.NumberOfItems.value {
		
		let a = XGItems.index(i)
		
		dic[a.name.string.simplified] = a
		
	}
	
	return dic
}

let items = allItems()

func item(_ name: String) -> XGItems {
	if settings.verbose && (items[name.simplified] == nil) { printg("couldn't find: " + name) }
	return items[name.simplified] ?? .index(0)
}

func allItemsArray() -> [XGItems] {
	var items : [XGItems] = []
	for i in 0 ..< CommonIndexes.NumberOfItems.value {
		items.append(XGItems.index(i))
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
		self = .index(index)
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(self.index, forKey: .index)
		try container.encode(self.name.string, forKey: .name)
	}
}

extension XGItems: XGEnumerable, Equatable {
	var enumerableName: String {
		return name.string.spaceToLength(20)
	}
	
	var enumerableValue: String? {
		return index.string
	}
	
	static var className: String {
		return "Items"
	}
	
	static var allValues: [XGItems] {
		return XGItems.allItems()
	}
	
	public static func != (lhs: Self, rhs: Self) -> Bool {
		lhs.enumerableValue != rhs.enumerableValue
	}
}




