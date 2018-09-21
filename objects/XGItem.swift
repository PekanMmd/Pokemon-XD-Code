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
let kInBattleUseItemIDOffset	 = 0x04 // Items that can be used on your pokemon in battle
let kItemPriceOffset			 = 0x06
let kItemCouponCostOffset		 = 0x08
let kItemBattleHoldItemIDOffset  = 0x0B
let kItemNameIDOffset			 = 0x12
let kItemDescriptionIDOffset	 = 0x16
let kItemParameterOffset		 = 0x1B
let kFirstFriendshipEffectOffset = 0x24 // Signed Int

let kItemFunctionInRAMPointerOffset1 = 0x1C // value is only filled in RAM at runtime and is empty in common_rel
let kItemFunctionInRAMPointerOffset2 = 0x20 // value is only filled in RAM at runtime and is empty in common_rel

class XGItem: NSObject, XGDictionaryRepresentable {

	@objc var startOffset : Int {
		get{
			return CommonIndexes.Items.startOffset + (index * kSizeOfItemData)
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
	@objc var canBeHeld 		= false
	
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
		let data  = XGFiles.common_rel.data
		
		let bSlot			= data.getByteAtOffset(start + kBagSlotOffset)
		bagSlot				= XGBagSlots(rawValue: bSlot) ?? XGBagSlots.items
		inBattleUseID		= data.getByteAtOffset(start + kInBattleUseItemIDOffset)
		price				= data.get2BytesAtOffset(start + kItemPriceOffset)
		couponPrice			= data.get2BytesAtOffset(start + kItemCouponCostOffset)
		holdItemID			= data.getByteAtOffset(start + kItemBattleHoldItemIDOffset)
		nameID				= data.get2BytesAtOffset(start + kItemNameIDOffset)
		descriptionID		= data.get2BytesAtOffset(start + kItemDescriptionIDOffset)
		parameter			= data.getByteAtOffset(start + kItemParameterOffset)
		canBeHeld			= data.getByteAtOffset(start + kItemCantBeHeldOffset) == 0
		friendshipEffects	= data.getByteStreamFromOffset(start + kFirstFriendshipEffectOffset, length: kNumberOfFriendshipEffects)
		
		function1			= data.get4BytesAtOffset(start + kItemFunctionInRAMPointerOffset1)
		function2			= data.get4BytesAtOffset(start + kItemFunctionInRAMPointerOffset2)
		
	}
	
	@objc func save() {
		
		let data = XGFiles.common_rel.data
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
		data.replaceBytesFromOffset(start + kFirstFriendshipEffectOffset, withByteStream: friendshipEffects)
		
		data.replace4BytesAtOffset(start + kItemFunctionInRAMPointerOffset1, withBytes: function1)
		data.replace4BytesAtOffset(start + kItemFunctionInRAMPointerOffset2, withBytes: function2)
		
		data.save()
		
	}
	
	
	@objc var dictionaryRepresentation : [String : AnyObject] {
		get {
			var dictRep = [String : AnyObject]()
			dictRep["name"] = self.name.string as AnyObject?
			dictRep["description"] = self.descriptionString.string as AnyObject?
			dictRep["inBattleUseID"] = self.inBattleUseID as AnyObject?
			dictRep["price"] = self.price as AnyObject?
			dictRep["couponPrice"] = self.couponPrice as AnyObject?
			dictRep["holdItemID"] = self.holdItemID as AnyObject?
			dictRep["parameter"] = self.parameter as AnyObject?
			dictRep["canBeHeld"] = self.canBeHeld as AnyObject?
			
			dictRep["bagSlot"] = self.bagSlot.dictionaryRepresentation as AnyObject?
			
			var friendshipEffectsArray = [AnyObject]()
			for a in friendshipEffects {
				friendshipEffectsArray.append(a as AnyObject)
			}
			dictRep["friendshipEffects"] = friendshipEffectsArray as AnyObject?
			
			return dictRep
		}
	}
	
	@objc var readableDictionaryRepresentation : [String : AnyObject] {
		get {
			var dictRep = [String : AnyObject]()
			dictRep["description"] = self.descriptionString.string as AnyObject?
			dictRep["inBattleUseID"] = self.inBattleUseID as AnyObject?
			dictRep["price"] = self.price as AnyObject?
			dictRep["couponPrice"] = self.couponPrice as AnyObject?
			dictRep["holdItemID"] = self.holdItemID as AnyObject?
			dictRep["parameter"] = self.parameter as AnyObject?
			dictRep["canBeHeld"] = self.canBeHeld as AnyObject?
			
			dictRep["bagSlot"] = self.bagSlot.name as AnyObject?
			
			dictRep["friendshipEffects"] = friendshipEffects as AnyObject?
			
			return ["\(self.index) " + self.name.string : dictRep as AnyObject]
		}
	}
	
}

















