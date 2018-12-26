//
//  Move.swift
//  Mausoleum Move Tool
//
//  Created by StarsMmd on 26/12/2014.
//  Copyright (c) 2014 StarsMmd. All rights reserved.
// 

import Foundation

let kNumberOfMoves			= PBRDataTable.tableWithID(30)!.numberOfEntries // 468

class XGMove: NSObject, XGDictionaryRepresentable {
	
	var startOffset			= 0x0
	var index				= 0x0
	
	var nameID				= 0x0
	var descriptionID   	= 0x0
	var animationID     	= 0x0
	
	var priority			= 0x0
	var pp					= 0x0
	var effect				= 0x0
	var effectAccuracy		= 0x0
	var basePower			= 0x0
	var accuracy			= 0x0
	var type				= XGMoveTypes.normal
	var target				= XGMoveTargets.selectedTarget
	var category			= XGMoveCategories.none
	var effectType			= XGMoveEffectTypes.none
	
	var contactFlag		= false
	var protectFlag		= false
	var magicCoatFlag	= false
	var snatchFlag		= false
	var mirrorMoveFlag	= false
	var kingsRockFlag	= false
	var soundBasedFlag	= false
	var HMFlag			= false
	var flag6			= false
	var flag7			= false
	
	var unknown1		= 0
	var unknown2		= 0
	var unknown3		= 0
	
	@objc var name : XGString {
		get {
			return getStringSafelyWithID(id: nameID)
		}
	}
	
	@objc var mdescription : XGString {
		get {
			return getStringSafelyWithID(id: descriptionID)
		}
	}
	
	
	@objc init(index: Int) {
		super.init()
		
		self.index = index
		let data  = PBRDataTableEntry(index: self.index + 1, tableId: 30)
		
		nameID = data.getShort(0)
		descriptionID = data.getShort(2)
		animationID = data.getShort(4)
		
		category = XGMoveCategories(rawValue: data.getByte(6)) ?? .none
		basePower = data.getByte(7)
		type = XGMoveTypes(rawValue: data.getByte(8)) ?? .normal
		accuracy = data.getByte(9)
		pp = data.getByte(10)
		effectAccuracy = data.getByte(11)
		priority = data.getSignedByte(12)
		effectType = XGMoveEffectTypes(rawValue: data.getByte(14)) ?? .none
		
		let flags = data.getByte(13).bitArray(count: 8)
		contactFlag = flags[0]
		protectFlag = flags[1]
		magicCoatFlag = flags[2]
		snatchFlag = flags[3]
		mirrorMoveFlag = flags[4]
		kingsRockFlag = flags[5]
		flag6 = flags[6]
		flag7 = flags[7]
		
		// flags 6-7 may be used for something like affecting how the
		// announcer reacts to it or my best guess is they are moves that
		// some pokemon have a unique animation for such as blastoise using
		// its cannons in the hydropump animation
		// 6/7 are 0/1 for a few really powerful or special moves
		
		unknown1 = data.getShort(16)
		unknown2 = data.getShort(18)
		unknown3 = data.getByte(22)
		
	}

	@objc func save() {
		
		
	}
	
	@objc var dictionaryRepresentation : [String : AnyObject] {
		get {
			var dictRep = [String : AnyObject]()
			dictRep["name"] = self.name.string as AnyObject?
			dictRep["description"] = self.mdescription.string as AnyObject?
			dictRep["moveAnimation"] = self.animationID as AnyObject?
			dictRep["priority"] = self.priority as AnyObject?
			dictRep["pp"] = self.pp as AnyObject?
			dictRep["effect"] = self.effect as AnyObject?
			dictRep["effectAccuracy"] = self.effectAccuracy as AnyObject?
			dictRep["basePower"] = self.basePower as AnyObject?
			dictRep["accuracy"] = self.accuracy as AnyObject?
			dictRep["contactFlag"] = self.contactFlag as AnyObject?
			dictRep["protectFlag"] = self.protectFlag as AnyObject?
			dictRep["magicCoatFlag"] = self.magicCoatFlag as AnyObject?
			dictRep["snatchFlag"] = self.snatchFlag as AnyObject?
			dictRep["mirrorMoveFlag"] = self.mirrorMoveFlag as AnyObject?
			dictRep["kingsRockFlag"] = self.kingsRockFlag as AnyObject?
			dictRep["soundBasedFlag"] = self.soundBasedFlag as AnyObject?
			dictRep["HMFlag"] = self.HMFlag as AnyObject?
			
			dictRep["type"] = self.type.dictionaryRepresentation as AnyObject?
			dictRep["target"] = self.target.dictionaryRepresentation as AnyObject?
			dictRep["category"] = self.category.dictionaryRepresentation as AnyObject?
			
			return dictRep
		}
	}
	
	@objc var readableDictionaryRepresentation : [String : AnyObject] {
		get {
			var dictRep = [String : AnyObject]()
			dictRep["description"] = self.mdescription.string as AnyObject?
			dictRep["moveAnimation"] = (XGFiles.nameAndFolder("Original Moves.json", .JSON).json as! [String])[self.animationID] as AnyObject?
			dictRep["priority"] = self.priority as AnyObject?
			dictRep["pp"] = self.pp as AnyObject?
			dictRep["effect"] = self.effect as AnyObject?
			dictRep["effectAccuracy"] = self.effectAccuracy as AnyObject?
			dictRep["basePower"] = self.basePower as AnyObject?
			dictRep["accuracy"] = self.accuracy as AnyObject?
			dictRep["contactFlag"] = self.contactFlag as AnyObject?
			dictRep["protectFlag"] = self.protectFlag as AnyObject?
			dictRep["magicCoatFlag"] = self.magicCoatFlag as AnyObject?
			dictRep["snatchFlag"] = self.snatchFlag as AnyObject?
			dictRep["mirrorMoveFlag"] = self.mirrorMoveFlag as AnyObject?
			dictRep["kingsRockFlag"] = self.kingsRockFlag as AnyObject?
			dictRep["soundBasedFlag"] = self.soundBasedFlag as AnyObject?
			dictRep["HMFlag"] = self.HMFlag as AnyObject?
			
			dictRep["type"] = self.type.name as AnyObject?
			dictRep["target"] = self.target.string as AnyObject?
			dictRep["category"] = self.category.string as AnyObject?
			
			return ["\(self.index) " + self.name.string : dictRep as AnyObject]
		}
	}
	
	
}











