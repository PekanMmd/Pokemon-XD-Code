//
//  XGItem.swift
//  XG Tool
//
//  Created by StarsMmd on 31/05/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

var kNumberOfItems: Int {
	return GoDDataTable.items.numberOfEntries // 465 in vanilla
}

final class XGItem: NSObject, XGIndexedValue, Codable {
	
	var index				= 0
	
	var battleUseFunctionID	= 0
	var fieldUseFunctionID	= 0
	var holdItemID			= 0
	var nameID				= 0
	var descriptionID		= 0
	var parameter			= 0
	var subParameter		= 0
	var healingParameter	= 0
	var ppParameter			= 0
	var subID				= 0
	var price				= 0
	var flingPower			= 0 // base power of the move fling when this item is held
	
	var unknown 			= 0
	var unknownBool			= false
	
	
	var friendshipEffects	= [0, 0, 0]
	
	var name : XGString {
		get {
			return getStringSafelyWithID(id: nameID)
		}
	}
	
	var descriptionString : XGString {
		get {
			return getStringSafelyWithID(id: descriptionID)
		}
	}
	
	init(index: Int) {
		super.init()
		
		self.index = index
		let data  = GoDDataTableEntry.items(index: self.index)
		
		price = data.getShort(0)
		nameID = data.getShort(2)
		descriptionID = data.getShort(4)
		unknown = data.getShort(6)
		holdItemID = data.getByte(8)
		parameter = data.getByte(9)
		flingPower = data.getByte(12)
		fieldUseFunctionID = data.getByte(16)
		battleUseFunctionID = data.getByte(17)
		unknownBool = data.getBool(18)
		subParameter = data.getByte(20)
		subID = data.getByte(25)
		healingParameter = data.getByte(33)
		ppParameter = data.getByte(34)
		friendshipEffects = [data.getSignedByte(35), data.getSignedByte(36), data.getSignedByte(37)]
	}
	
	func save() {
		
		let data  = GoDDataTableEntry.items(index: self.index)
		
		data.setShort(0, to: price)
		data.setShort(2, to: nameID)
		data.setShort(4, to: descriptionID)
		data.setShort(6, to: unknown)
		data.setByte(8, to: holdItemID)
		data.setByte(9, to: parameter)
		data.setByte(12, to: flingPower)
		data.setByte(16, to: fieldUseFunctionID)
		data.setByte(17, to: battleUseFunctionID)
		data.setBool(18, to: unknownBool)
		data.setByte(20, to: subParameter)
		data.setByte(25, to: subID)
		data.setByte(33, to: healingParameter)
		data.setByte(34, to: ppParameter)
		
		data.setSignedByte(35, to: friendshipEffects[0])
		data.setSignedByte(36, to: friendshipEffects[1])
		data.setSignedByte(37, to: friendshipEffects[2])
		
		data.save()
		
	}
	
}

extension XGItem: XGEnumerable {
	var enumerableName: String {
		return name.unformattedString.spaceToLength(20)
	}

	var enumerableValue: String? {
		return index.string
	}

	static var className: String {
		return "Items"
	}

	static var allValues: [XGItem] {
		return XGItems.allItems().map { $0.data }
	}
}

extension XGItem: XGDocumentable {

	var documentableName: String {
		return enumerableName + " - " + (enumerableValue ?? "")
	}

	static var DocumentableKeys: [String] {
		return ["index", "hex index", "name", "description", "price", "parameter", "friendship"]
	}

	func documentableValue(for key: String) -> String {
		switch key {
		case "index":
			return index.string
		case "hex index":
			return index.hexString()
		case "name":
			return name.unformattedString
		case "description":
			return descriptionString.unformattedString
		case "price":
			return price.string
		case "parameter":
			return parameter.string
		case "friendship":
			var text = ""
			friendshipEffects.forEach {
				text += $0.string + ", "
			}
			text.removeLast()
			return text
		default:
			return ""
		}
	}
}










