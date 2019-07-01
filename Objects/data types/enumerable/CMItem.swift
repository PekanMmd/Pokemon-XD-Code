//
//  CMItem.swift
//  Colosseum Tool
//
//  Created by The Steez on 06/06/2018.
//

import Foundation


let kNumberOfItems				= 0x18d
let kFirstItemOffset			= region == .JP ? 0x34D428 : 0x360ce8 // in start.dol for colosseum
let kSizeOfItemData				= 0x28
let kNumberOfFriendshipEffects	= 0x03

let kBagSlotOffset				 = 0x00
let kItemCantBeHeldOffset		 = 0x01 // also can't be thrown away?
let kInBattleUseItemIDOffset	 = 0x04 // Items that can be used on your pokemon in battle
let kItemPriceOffset			 = 0x06
let kItemCouponCostOffset		 = 0x08
let kItemBattleHoldItemIDOffset  = 0x0B
let kItemNameIDOffset			 = 0x10
let kItemDescriptionIDOffset	 = 0x14
let kItemParameterOffset		 = 0x1B
let kFirstFriendshipEffectOffset = 0x24 // Signed Int

let kItemFunctionInRAMPointerOffset = 0x20 // value is only filled in RAM at runtime and is empty in common_rel

class XGItem: NSObject, Codable {
	
	var startOffset : Int {
		get{
			return kFirstItemOffset + (index * kSizeOfItemData)
		}
	}
	
	var index				= 0x0
	
	var bagSlot				= XGBagSlots.items
	var inBattleUseID		= 0x0
	var price				= 0x0
	var couponPrice			= 0x0
	var holdItemID			= 0x0
	var nameID				= 0x0
	var descriptionID		= 0x0
	var parameter			= 0x0
	var friendshipEffects	= [Int](repeating: 0x0, count: kNumberOfFriendshipEffects)
	var canBeHeld = false
	
	var name : XGString {
		get {
			return XGItems.item(index).name
		}
	}
	
	var descriptionString : XGString {
		get {
			return XGItems.item(index).descriptionString
		}
	}
	
	
	init(index: Int) {
		super.init()
		
		self.index = index
		
		let start = startOffset
		let data  = XGFiles.dol.data!
		
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
		
		
	}
	
	func save() {
		
		let data = XGFiles.dol.data!
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
