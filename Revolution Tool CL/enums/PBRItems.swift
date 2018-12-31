//
//  XGPokemon.swift
//  XG Tool
//
//  Created by StarsMmd on 01/06/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

enum XGItems : XGDictionaryRepresentable, XGIndexedValue {
	
	case item(Int)
	
	var index : Int {
		switch self {
		case .item(let i): return  i
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
	
	var dictionaryRepresentation: [String : AnyObject] {
		get {
			return ["Value" : self.index as AnyObject]
		}
	}
	
	var readableDictionaryRepresentation: [String : AnyObject] {
		get {
			return ["Value" : self.name.string as AnyObject]
		}
	}
	
	static func allItems() -> [XGItems] {
		var items = [XGItems]()
		for i in 0 ..< kNumberOfItems {
			items.append(.item(i))
		}
		return items
	}
	
}


func allItems() -> [String : XGItems] {
	
	var dic = [String : XGItems]()
	
	for i in 0 ..< kNumberOfItems {
		
		let a = XGItems.item(i)
		
		dic[a.name.unformattedString.simplified] = a
		
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








