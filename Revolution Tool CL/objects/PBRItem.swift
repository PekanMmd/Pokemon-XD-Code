//
//  XGItem.swift
//  XG Tool
//
//  Created by StarsMmd on 31/05/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

let kNumberOfItems				= PBRDataTable.tableWithID(19)!.numberOfEntries // 465

class XGItem: NSObject, XGDictionaryRepresentable {
	
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
	
	var unknownBool			= false
	
	
	var friendshipEffects	= [0, 0, 0]
	
	@objc var name : XGString {
		get {
			return getStringSafelyWithID(id: nameID)
		}
	}
	
	@objc var descriptionString : XGString {
		get {
			return getStringSafelyWithID(id: descriptionID)
		}
	}
	
	@objc init(index: Int) {
		super.init()
		
		self.index = index
		let data  = PBRDataTableEntry(index: index + 1, tableId: 19)
		
		price = data.getShort(0)
		nameID = data.getShort(2)
		descriptionID = data.getShort(4)
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
	
	@objc func save() {
		
		let data  = PBRDataTableEntry(index: self.index + 1, tableId: 19)
		
		data.setShort(0, to: price)
		data.setShort(2, to: nameID)
		data.setShort(4, to: descriptionID)
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
	
	
	@objc var dictionaryRepresentation : [String : AnyObject] {
		get {
			var dictRep = [String : AnyObject]()
			dictRep["name"] = self.name.string as AnyObject?
			dictRep["description"] = self.descriptionString.string as AnyObject?
			dictRep["holdItemID"] = self.holdItemID as AnyObject?
			dictRep["parameter"] = self.parameter as AnyObject?
			
			return dictRep
		}
	}
	
	@objc var readableDictionaryRepresentation : [String : AnyObject] {
		get {
			var dictRep = [String : AnyObject]()
			dictRep["description"] = self.descriptionString.string as AnyObject?
			dictRep["holdItemID"] = self.holdItemID as AnyObject?
			dictRep["parameter"] = self.parameter as AnyObject?
			
			return ["\(self.index) " + self.name.string : dictRep as AnyObject]
		}
	}
	
}

















