//
//  XGPokemon.swift
//  XG Tool
//
//  Created by StarsMmd on 01/06/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

enum XGItems : XGIndexedValue {
	
	case index(Int)
	
	var index : Int {
		switch self {
		case .index(let i): return  i
		}
	}
	
	var description : String {
		return self.name.string
	}
	
	var nameID : Int {
		return data.nameID
	}
	var name : XGString {
		return getStringSafelyWithID(id: nameID)
	}
	
	var data : XGItem {
		get {
			return XGItem(index: self.index)
		}
	}
	
	static func allItems() -> [XGItems] {
		var items = [XGItems]()
		for i in 0 ..< kNumberOfItems {
			items.append(.index(i))
		}
		return items
	}
	
	static func pokeballs() -> [XGItems] {
		var items = [XGItems]()
		for i in 0 ... 16 {
			items.append(.index(i))
		}
		return items
	}
}


func allItems() -> [String : XGItems] {
	
	var dic = [String : XGItems]()
	
	for i in 0 ..< kNumberOfItems {
		
		let a = XGItems.index(i)
		
		dic[a.name.unformattedString.simplified] = a
		
	}
	
	return dic
}

let items = allItems()

func item(_ name: String) -> XGItems {
	if items[name.simplified] == nil { printg("couldn't find: " + name) }
	return items[name.simplified] ?? .index(0)
}

func allItemsArray() -> [XGItems] {
	var items : [XGItems] = []
	for i in 0 ..< kNumberOfItems {
		items.append(XGItems.index(i))
	}
	return items
}

extension XGItems: XGEnumerable, Equatable {
	var enumerableName: String {
		return name.unformattedString.spaceToLength(20)
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






