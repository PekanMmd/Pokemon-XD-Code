//
//  XGPokemon.swift
//  XG Tool
//
//  Created by StarsMmd on 01/06/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

enum XGItems : XGDictionaryRepresentable {
	
	case item(Int)
	
	var index : Int {
		get {
			switch self {
				case .item(let i): return i
			}
		}
	}
	
	var hex : String {
		get {
			return String(format: "0x%x",self.index)
		}
	}
	
	var startOffset : Int {
		get{
			return CommonIndexes.Items.startOffset + (index * kSizeOfItemData)
		}
	}
	
	var nameID : Int {
		get {
			let data  = XGFiles.common_rel.data
			return data.get2BytesAtOffset(startOffset + kItemNameIDOffset)
		}
	}
	
	var descriptionID : Int {
		get {
			let data  = XGFiles.common_rel.data
			return data.get2BytesAtOffset(startOffset + kItemDescriptionIDOffset)
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
			let table = XGFiles.stringTable("pocket_menu.msg").stringTable
			return table.stringSafelyWithID(descriptionID)
		}
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
		for i in 0 ..< CommonIndexes.NumberOfItems.value {
			items.append(.item(i))
		}
		return items
	}
	
}

enum XGOriginalItems {
	
	case item(Int)
	
	var index : Int {
		get {
			switch self {
			case .item(let i): return i
			}
		}
	}
	
	var startOffset : Int {
		get{
			return CommonIndexes.Items.startOffset + (index * kSizeOfItemData)
		}
	}
	
	var nameID : Int {
		get {
			let data  = XGFiles.original(.common_rel).data
			return data.get2BytesAtOffset(startOffset + kItemNameIDOffset)
		}
	}
	
	var name : XGString {
		get {
			let table = XGFiles.original(.common_rel).stringTable
			return table.stringSafelyWithID(nameID)
		}
	}
	
	static func allItems() -> [XGOriginalItems] {
		var items = [XGOriginalItems]()
		for i in 0 ..< CommonIndexes.NumberOfItems.value {
			items.append(.item(i))
		}
		return items
	}
	
}


func allItems() -> [String : XGItems] {
	
	var dic = [String : XGItems]()
	
	for i in 0 ..< CommonIndexes.NumberOfItems.value {
		
		let a = XGItems.item(i)
		
		dic[a.name.string.lowercased()] = a
		
	}
	
	return dic
}

let items = allItems()

func item(_ name: String) -> XGItems {
	if items[name.lowercased()] == nil { print("couldn't find: " + name) }
	return items[name.lowercased()] ?? .item(0)
}

func allItemsArray() -> [XGItems] {
	var items : [XGItems] = []
	for i in 0 ..< CommonIndexes.NumberOfItems.startOffset {
		items.append(XGItems.item(i))
	}
	return items
}

func allOriginalItemsArray() -> [XGOriginalItems] {
	var items : [XGOriginalItems] = []
	for i in 0 ..< CommonIndexes.NumberOfItems.value {
		items.append(XGOriginalItems.item(i))
	}
	return items
}








