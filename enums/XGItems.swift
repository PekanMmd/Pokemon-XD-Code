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
				case .item(let i): return (i > CommonIndexes.NumberOfItems.value && i < 0x250) ? i - 150 : i
			}
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
			return CommonIndexes.Items.startOffset + (index * kSizeOfItemData)
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
			let table = XGFiles.msg("pocket_menu").stringTable
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
	
	static func pokeballs() -> [XGItems] {
		var items = [XGItems]()
		for i in 0 ... 12 {
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
			let data  = XGFiles.original(.common_rel).data!
			return Int(data.getWordAtOffset(startOffset + kItemNameIDOffset))
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
	for i in 0 ..< CommonIndexes.NumberOfItems.value {
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








