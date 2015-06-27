//
//  XGItem.swift
//  XG Tool
//
//  Created by The Steez on 31/05/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//

import Foundation

let kNumberOfItems				= 0x1BC
let kFirstItemOffset			= 0x1FEE4
let kSizeOfItemData				= 0x28
let kNumberOfFriendShipEffects	= 0x03

let kBagSlotOffset				 = 0x00
let kItemCantBeHeldOffset		 = 0x01
let kInBattleUseItemIDOffset	 = 0x04 // Items that can be used on your pokemon in battle
let kItemPriceOffset			 = 0x06
let kItemCouponCostOffset		 = 0x08
let kItemBattleHoldItemIDOffset  = 0x0B
let kItemNameIDOffset			 = 0x12
let kItemDescriptionIDOffset	 = 0x16
let kItemParameterOffset		 = 0x1B
let kFirstFriendshipEffectOffset = 0x24 // Signed Int

class XGItem: NSObject {

	var startOffset : Int {
		get{
			return kFirstItemOffset + (index * kSizeOfItemData)
		}
	}
	
	var index				= 0x0
	
	var bagSlot				= XGBagSlots.Items
	var inBattleUseID		= 0x0
	var price				= 0x0
	var couponPrice			= 0x0
	var holdItemID			= 0x0
	var nameID				= 0x0
	var descriptionID		= 0x0
	var parameter			= 0x0
	var friendShipEffects	= [Int](count: kNumberOfFriendShipEffects, repeatedValue: 0x0)
	var canBeHeld = false
	
	var name : XGString {
		get {
			return XGItems.Item(index).name
		}
	}
	
	var descriptionString : XGString {
		get {
			return XGItems.Item(index).descriptionString
		}
	}
	
	
	init(index: Int) {
		super.init()
		
		self.index = index
		
		let start = startOffset
		var data  = XGFiles.Common_rel.data
		
		var bSlot			= data.getByteAtOffset(start + kBagSlotOffset)
		bagSlot				= XGBagSlots(rawValue: bSlot) ?? XGBagSlots.Items
		inBattleUseID		= data.getByteAtOffset(start + kInBattleUseItemIDOffset)
		price				= data.get2BytesAtOffset(start + kItemPriceOffset)
		couponPrice			= data.get2BytesAtOffset(start + kItemCouponCostOffset)
		holdItemID			= data.getByteAtOffset(start + kItemBattleHoldItemIDOffset)
		nameID				= data.get2BytesAtOffset(start + kItemNameIDOffset)
		descriptionID		= data.get2BytesAtOffset(start + kItemDescriptionIDOffset)
		parameter			= data.getByteAtOffset(start + kItemParameterOffset)
		canBeHeld			= data.getByteAtOffset(start + kItemCantBeHeldOffset) == 0
		friendShipEffects	= data.getByteStreamFromOffset(start + kFirstFriendshipEffectOffset, length: kNumberOfFriendShipEffects)
		
		
	}
	
	func save() {
		
		var data = XGFiles.Common_rel.data
		let start = self.startOffset
		
		data.replaceByteAtOffset(start + kBagSlotOffset, withByte: bagSlot.rawValue)
		data.replaceByteAtOffset(start + kInBattleUseItemIDOffset, withByte: inBattleUseID)
		data.replace2BytesAtOffset(start + kItemPriceOffset, withBytes: price)
		data.replace2BytesAtOffset(start + kItemCouponCostOffset, withBytes: couponPrice)
		data.replaceByteAtOffset(start + kItemBattleHoldItemIDOffset, withByte: holdItemID)
		data.replace2BytesAtOffset(start + kItemNameIDOffset, withBytes: nameID)
		data.replace2BytesAtOffset(start + kItemDescriptionIDOffset, withBytes: descriptionID)
		data.replaceByteAtOffset(start + kItemParameterOffset, withByte: parameter)
		data.replaceByteAtOffset(start + kItemCantBeHeldOffset, withByte: canBeHeld ? 0 : 1)
		data.replaceBytesFromOffset(start + kFirstFriendshipEffectOffset, withByteStream: friendShipEffects)
		
	}
	
}

















