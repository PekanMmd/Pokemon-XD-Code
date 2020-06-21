//
//  XGItem.swift
//  XG Tool
//
//  Created by StarsMmd on 31/05/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

let kNumberOfItems				= CommonIndexes.NumberOfItems.value // 0x1bc
//let kFirstItemOffset			= 0x1FEE4
let kSizeOfItemData				= 0x28
let kNumberOfFriendshipEffects	= 0x03

let kBagSlotOffset				 = 0x00
let kItemCantBeHeldOffset		 = 0x01 // also can't be thrown away?
let kInBattleUseItemIDOffset	 = 0x04 // really more like a functional id which is compared with items that can be used rather than having passive uses
let kItemPriceOffset			 = 0x06
let kItemCouponCostOffset		 = 0x08
let kItemBattleHoldItemIDOffset  = 0x0B
let kItemNameIDOffset			 = 0x10
let kItemDescriptionIDOffset	 = 0x14
let kItemParameterOffset		 = 0x1B
let kFirstFriendshipEffectOffset = 0x24 // Signed Int

let kItemFunctionInRAMPointerOffset1 = 0x1C // value is only filled in RAM at runtime and is empty in common_rel
let kItemFunctionInRAMPointerOffset2 = 0x20 // value is only filled in RAM at runtime and is empty in common_rel

final class XGItem: NSObject, Codable {

	@objc var startOffset : Int {
		get{
			let safeIndex = index < kNumberOfItems ? index : 0
			return CommonIndexes.Items.startOffset + (safeIndex * kSizeOfItemData)
		}
	}
	
	@objc var index				= 0x0
	
	var scriptIndex : Int {
		// index used in scripts and pokemarts is different for key items
		return index >= 0x15e ? index + 150 : index
	}
	
	var bagSlot					= XGBagSlots.items
	@objc var inBattleUseID		= 0x0
	@objc var price				= 0x0
	@objc var couponPrice		= 0x0
	@objc var holdItemID		= 0x0
	@objc var nameID			= 0x0
	@objc var descriptionID		= 0x0
	@objc var parameter			= 0x0
	@objc var friendshipEffects	= [Int](repeating: 0x0, count: kNumberOfFriendshipEffects)
	@objc var canBeHeld 		= false // more appropriate name would be "consumable"
	
	var function1 : UInt32 		= 0x0
	var function2 : UInt32		= 0x0
	
	@objc var name : XGString {
		get {
			return XGItems.item(index).name
		}
	}
	
	@objc var descriptionString : XGString {
		get {
			return XGItems.item(index).descriptionString
		}
	}
	
	@objc convenience init(scriptIndex: Int) {
		self.init(index: scriptIndex >= kNumberOfItems ? scriptIndex - 150 : scriptIndex)
	}
	
	@objc init(index: Int) {
		super.init()
		
		self.index = index
		
		let start = startOffset
		let data  = XGFiles.common_rel.data!
		
		let bSlot			= data.getByteAtOffset(start + kBagSlotOffset)
		bagSlot				= XGBagSlots(rawValue: bSlot) ?? XGBagSlots.items
		inBattleUseID		= data.getByteAtOffset(start + kInBattleUseItemIDOffset)
		price				= data.get2BytesAtOffset(start + kItemPriceOffset)
		couponPrice			= data.get2BytesAtOffset(start + kItemCouponCostOffset)
		holdItemID			= data.getByteAtOffset(start + kItemBattleHoldItemIDOffset)
		nameID				= data.getWordAtOffset(start + kItemNameIDOffset).int
		descriptionID		= data.getWordAtOffset(start + kItemDescriptionIDOffset).int
		parameter			= data.getByteAtOffset(start + kItemParameterOffset)
		canBeHeld			= data.getByteAtOffset(start + kItemCantBeHeldOffset) == 0
		friendshipEffects	= data.getByteStreamFromOffset(start + kFirstFriendshipEffectOffset, length: kNumberOfFriendshipEffects)
		
		function1			= data.getWordAtOffset(start + kItemFunctionInRAMPointerOffset1)
		function2			= data.getWordAtOffset(start + kItemFunctionInRAMPointerOffset2)
		
	}
	
	@objc func save() {

		guard index > 0, index < kNumberOfItems else {
			return
		}

		let data = XGFiles.common_rel.data!
		let start = self.startOffset
		
		data.replaceByteAtOffset(start + kBagSlotOffset, withByte: bagSlot.rawValue)
		data.replaceByteAtOffset(start + kInBattleUseItemIDOffset, withByte: inBattleUseID)
		data.replace2BytesAtOffset(start + kItemPriceOffset, withBytes: price)
		data.replace2BytesAtOffset(start + kItemCouponCostOffset, withBytes: couponPrice)
		data.replaceByteAtOffset(start + kItemBattleHoldItemIDOffset, withByte: holdItemID)
		data.replaceWordAtOffset(start + kItemNameIDOffset, withBytes: UInt32(nameID))
		data.replaceWordAtOffset(start + kItemDescriptionIDOffset, withBytes: UInt32(descriptionID))
		data.replaceByteAtOffset(start + kItemParameterOffset, withByte: parameter)
		data.replaceByteAtOffset(start + kItemCantBeHeldOffset, withByte: canBeHeld ? 0 : 1)
		data.replaceBytesFromOffset(start + kFirstFriendshipEffectOffset, withByteStream: friendshipEffects)
		
		data.replaceWordAtOffset(start + kItemFunctionInRAMPointerOffset1, withBytes: function1)
		data.replaceWordAtOffset(start + kItemFunctionInRAMPointerOffset2, withBytes: function2)
		
		data.save()
		
	}
	
}

extension XGItem: XGEnumerable {
	var enumerableName: String {
		return name.string
	}
	
	var enumerableValue: String? {
		return String(format: "%03d", index)
	}
	
	static var enumerableClassName: String {
		return "Items"
	}
	
	static var allValues: [XGItem] {
		var values = [XGItem]()
		for i in 0 ..< CommonIndexes.NumberOfItems.value {
			values.append(XGItem(index: i))
		}
		return values
	}
}

extension XGItem: XGDocumentable {
	
	static var documentableClassName: String {
		return "Items"
	}
	
	var documentableName: String {
		return enumerableName + " - " + (enumerableValue ?? "")
	}
	
	static var DocumentableKeys: [String] {
		return ["index", "hex index", "name", "description", "bag slot", "price", "coupon price", "parameter", "friendship"]
	}
	
	func documentableValue(for key: String) -> String {
		switch key {
		case "index":
			return index.string
		case "hex index":
			return index.hexString()
		case "name":
			return name.string
		case "description":
			return descriptionString.string
		case "bag slot":
			return bagSlot.name
		case "price":
			return price.string
		case "coupon price":
			return couponPrice.string
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













