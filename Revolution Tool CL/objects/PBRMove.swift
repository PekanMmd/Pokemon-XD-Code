//
//  Move.swift
//  Mausoleum Move Tool
//
//  Created by StarsMmd on 26/12/2014.
//  Copyright (c) 2014 StarsMmd. All rights reserved.
// 

import Foundation

let kNumberOfMoves = PBRDataTable.moves.numberOfEntries // 468

class XGMove: NSObject, XGDictionaryRepresentable, XGIndexedValue {
	
	var startOffset			: Int {
		return PBRDataTable.moves.offsetForEntryWithIndex(self.index)
	}
	var index				= 0x0
	
	var nameID				= 0x0
	var descriptionID   	= 0x0
	var animationID     	= 0x0 // wzx file id
	
	var priority			= 0x0
	var pp					= 0x0
	var effect				= 0x0
	var effectAccuracy		= 0x0
	var basePower			= 0x0
	var accuracy			= 0x0
	var type				= XGMoveTypes.type(0)
	var target				= XGMoveTargets.selectedTarget
	var category			= XGMoveCategories.none
	var effectType			= XGMoveEffectTypes.none
	var contestAppeal		= XGContestAppeals.cool
	
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
		let data  = PBRDataTableEntry.moves(index: self.index)
		
		effect = data.getShort(0)
		let targets = data.getShort(2)
		self.target = XGMoveTargets(rawValue: targets) ?? .selectedTarget
		let appeal = data.getByte(6)
		self.contestAppeal = XGContestAppeals(rawValue: appeal) ?? .cool
		
		nameID = data.getShort(8)
		descriptionID = data.getShort(10)
		animationID = data.getShort(12)
		
		category = XGMoveCategories(rawValue: data.getByte(14)) ?? .none
		basePower = data.getByte(15)
		type = XGMoveTypes.type(data.getByte(16))
		accuracy = data.getByte(17)
		pp = data.getByte(18)
		effectAccuracy = data.getByte(19)
		priority = data.getSignedByte(20)
		effectType = XGMoveEffectTypes(rawValue: data.getByte(22)) ?? .none
		
		
		let flags = data.getByte(21).bitArray(count: 8)
		contactFlag = flags[0]
		protectFlag = flags[1]
		magicCoatFlag = flags[2]
		snatchFlag = flags[3]
		mirrorMoveFlag = flags[4]
		kingsRockFlag = flags[5]
		flag6 = flags[6]
		flag7 = flags[7]
		// unsure of the use of flags 6-7 but my best guess is that 7 is set on moves that some pokemon have a unique animation for such as blastoise using its cannons in the hydropump animation.
		
		
		
	}

	@objc func save() {
		
		let data  = PBRDataTableEntry.moves(index: self.index)
		
		data.setShort(0, to: effect)
		data.setShort(2, to: self.target.rawValue)
		data.setByte(6, to: contestAppeal.rawValue)
		data.setShort(8, to: nameID)
		data.setShort(10, to: descriptionID)
		data.setShort(12, to: animationID)
		data.setByte(14, to: category.rawValue)
		data.setByte(15, to: basePower)
		data.setByte(16, to: type.rawValue)
		data.setByte(17, to: accuracy)
		data.setByte(18, to: pp)
		data.setByte(19, to: effectAccuracy)
		data.setSignedByte(20, to: priority)
		data.setByte(22, to: effectType.rawValue)
		let flags = [contactFlag, protectFlag, magicCoatFlag, snatchFlag, mirrorMoveFlag, kingsRockFlag, flag6, flag7]
		data.setByte(21, to: flags.binaryBitsToInt())
		
		data.save()
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











