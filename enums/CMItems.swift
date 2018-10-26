//
//  CMItems.swift
//  Colosseum Tool
//
//  Created by The Steez on 06/06/2018.
//

import Foundation

enum XGItems : XGDictionaryRepresentable {
	
	case item(Int)
	
	var index : Int {
		get {
			switch self {
			case .item(let i):
				if i > kNumberOfItems || i < 0 {
					return 0
				}
				return (i > kNumberOfItems && i < 0x250) ? i - 150 : i
			}
		}
	}
	
	var TMIndex : Int {
		return self.index >= XGTMs.tm(1).item.index && self.index <= XGTMs.tm(kNumberOfTMsAndHMs).item.index ? self.index - XGTMs.tm(1).item.index + 1 : -1
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
			return kFirstItemOffset + (index * kSizeOfItemData)
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
	
	static func pokeballs() -> [XGItems] {
		var items = [XGItems]()
		for i in 0 ... 12 {
			items.append(.item(i))
		}
		return items
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
