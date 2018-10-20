//
//  Move.swift
//  Mausoleum Move Tool
//
//  Created by StarsMmd on 26/12/2014.
//  Copyright (c) 2014 StarsMmd. All rights reserved.
// 

import Foundation

let kNumberOfMoves				= CommonIndexes.NumberOfMoves.value //0x0177
let kSizeOfMoveData				= 0x0038
let kFirstMoveOffset			= game == .XD ? 0xA2710 : 0x11E010

let kPriorityOffset				= 0x00
let kPPOffset					= 0x01
let kMoveTypeOffset				= 0x02
let kTargetsOffset				= 0x03
let kAccuracyOffset				= 0x04
let kEffectAccuracyOffset		= 0x05

let kContactFlagOffset			= 0x06
let kProtectFlagOffset			= 0x07
let kMagicCoatFlagOffset		= 0x08
let kSnatchFlagOffset			= 0x09
let kMirrorMoveFlagOffset		= 0x0A
let kKingsRockFlagOffset		= 0x0B
let kSoundBasedFlagOffset		= 0x10
let kHMFlagOffset				= 0x12

let kMoveCategoryOffset			= game == .XD ? 0x13 : 0x1F // added through hacking in colosseum
let kBasePowerOffset			= game == .XD ? 0x19 : 0x17
let kEffectOffset				= game == .XD ? 0x1D : 0x1B

let kMoveNameIDOffset			= 0x20
let kMoveDescriptionIDOffset	= 0x2C
let kAnimationIndexOffset		= game == .XD ? 0x1E : 0x1C
let kAnimation2IndexOffset		= 0x32

let kMoveEffectTypeOffset		= 0x34 // used by AI

let kMoveDisplaysTypeMatchupInSummaryScreenFlagOffset = 0x15 // XD only

let kMoveContestAppealJamIndexOffset = game == .XD ? 0x16 : 0x14 // probably an index into some other table
let kMoveContestAppealTypeOffset = game == .XD ? 0x17: 0x15 // beauty: 2, tough:5 etc.

//XD only string ids loaded during message "[Pokemon name] used move!"
// ID : 0x4f6d 20333
// File: fight.msg
// [0f] used[New Line][28][0e]
// first string is unused in message, second is exclamation point (parameter 0xe)
let kMoveUnusedStringIDOffset = 0x26
let kMoveExclamationPointStringIDOffset = 0x2a

class XGMove: NSObject, XGDictionaryRepresentable {
	
	@objc var startOffset		= 0x0
	@objc var moveIndex		= 0x0
	
	var unusedString = 0
	var exclamationString = 0
	
	@objc var nameID			= 0x0
	@objc var descriptionID   = 0x0
	@objc var animationID     = 0x0
	@objc var animation2ID	= 0x0
	
	@objc var priority		= 0x0
	@objc var pp				= 0x0
	@objc var effect			= 0x0
	@objc var effectAccuracy	= 0x0
	@objc var basePower		= 0x0
	@objc var accuracy		= 0x0
	var type			= XGMoveTypes.normal
	var target			= XGMoveTargets.selectedTarget
	var category		= XGMoveCategories.none
	
	var effectType		= XGMoveEffectTypes.none
	
	@objc var contactFlag		= false
	@objc var protectFlag		= false
	@objc var magicCoatFlag	= false
	@objc var snatchFlag		= false
	@objc var mirrorMoveFlag	= false
	@objc var kingsRockFlag	= false
	@objc var soundBasedFlag	= false
	@objc var HMFlag			= false
	
	@objc var displayTypeMatchupFlag = 0
	
	
	@objc var name : XGString {
		get {
			return XGFiles.common_rel.stringTable.stringSafelyWithID(nameID)
		}
	}
	
	@objc var mdescription : XGString {
		get {
			return XGFiles.dol.stringTable.stringSafelyWithID(descriptionID)
		}
	}
	
	@objc var isShadowMove	: Bool {
		get {
			return XGMoves.move(self.moveIndex).isShadowMove
		}
	}
	
	@objc init(index: Int) {
		super.init()
		
		let rel   = XGFiles.common_rel.data
		
		self.moveIndex       = index
		self.startOffset     = CommonIndexes.Moves.startOffset + (index * kSizeOfMoveData)
		
		self.contactFlag	 = rel.getByteAtOffset(startOffset + kContactFlagOffset)    == 1
		self.protectFlag	 = rel.getByteAtOffset(startOffset + kProtectFlagOffset)    == 1
		self.magicCoatFlag	 = rel.getByteAtOffset(startOffset + kMagicCoatFlagOffset)  == 1
		self.snatchFlag		 = rel.getByteAtOffset(startOffset + kSnatchFlagOffset)	    == 1
		self.mirrorMoveFlag	 = rel.getByteAtOffset(startOffset + kMirrorMoveFlagOffset) == 1
		self.kingsRockFlag	 = rel.getByteAtOffset(startOffset + kKingsRockFlagOffset)  == 1
		self.soundBasedFlag	 = rel.getByteAtOffset(startOffset + kSoundBasedFlagOffset) == 1
		self.HMFlag			 = rel.getByteAtOffset(startOffset + kHMFlagOffset)		    == 1
		
		self.type			 = XGMoveTypes(rawValue: rel.getByteAtOffset(startOffset + kMoveTypeOffset)) ?? .normal
		self.target			 = XGMoveTargets(rawValue: rel.getByteAtOffset(startOffset + kTargetsOffset)) ?? .selectedTarget
		self.category		 = XGMoveCategories(rawValue: rel.getByteAtOffset(startOffset + kMoveCategoryOffset)) ?? .none
		
		self.effect			 = rel.getByteAtOffset(startOffset + kEffectOffset)
		self.effectAccuracy	 = rel.getByteAtOffset(startOffset + kEffectAccuracyOffset)
		self.basePower		 = rel.getByteAtOffset(startOffset + kBasePowerOffset)
		self.accuracy		 = rel.getByteAtOffset(startOffset + kAccuracyOffset)
		self.pp				 = rel.getByteAtOffset(startOffset + kPPOffset)
		
		self.nameID		   = rel.getWordAtOffset(startOffset + kMoveNameIDOffset).int
		self.descriptionID = rel.getWordAtOffset(startOffset + kMoveDescriptionIDOffset).int
		self.animationID   = rel.get2BytesAtOffset(startOffset + kAnimationIndexOffset)
		self.animation2ID  = rel.get2BytesAtOffset(startOffset + kAnimation2IndexOffset)
		
		self.displayTypeMatchupFlag = rel.getByteAtOffset(startOffset + kMoveDisplaysTypeMatchupInSummaryScreenFlagOffset)
		
		let p			   = rel.getByteAtOffset(startOffset + kPriorityOffset)
		self.priority	   = p > 128 ? p - 256 : p
		
		self.effectType	   = XGMoveEffectTypes(rawValue: rel.getByteAtOffset(startOffset + kMoveEffectTypeOffset)) ?? .unknown
		
		self.unusedString = rel.get2BytesAtOffset(startOffset + kMoveUnusedStringIDOffset)
		self.exclamationString = rel.get2BytesAtOffset(startOffset + kMoveExclamationPointStringIDOffset)
		
	}

	@objc func save() {
		
		let newContact	= contactFlag	 ? 1 : 0
		let newProtect	= protectFlag	 ? 1 : 0
		let newMagic	= magicCoatFlag	 ? 1 : 0
		let newSnatch	= snatchFlag	 ? 1 : 0
		let newMirror	= mirrorMoveFlag ? 1 : 0
		let newKings	= kingsRockFlag	 ? 1 : 0
		let newSound	= soundBasedFlag ? 1 : 0
		let newHM		= HMFlag		 ? 1 : 0
		
		let newTarget   = target.rawValue
		let newType		= type.rawValue
		let newCategory = category.rawValue
		
		let rel = XGFiles.common_rel.data
		
		rel.replaceByteAtOffset(startOffset + kContactFlagOffset, withByte: newContact)
		rel.replaceByteAtOffset(startOffset + kProtectFlagOffset, withByte: newProtect)
		rel.replaceByteAtOffset(startOffset + kMagicCoatFlagOffset, withByte: newMagic)
		rel.replaceByteAtOffset(startOffset + kSnatchFlagOffset, withByte: newSnatch)
		rel.replaceByteAtOffset(startOffset + kMirrorMoveFlagOffset, withByte: newMirror)
		rel.replaceByteAtOffset(startOffset + kKingsRockFlagOffset, withByte: newKings)
		rel.replaceByteAtOffset(startOffset + kSoundBasedFlagOffset, withByte: newSound)
		rel.replaceByteAtOffset(startOffset + kHMFlagOffset, withByte: newHM)
		
		rel.replaceByteAtOffset(startOffset + kTargetsOffset, withByte: newTarget)
		rel.replaceByteAtOffset(startOffset + kMoveTypeOffset, withByte: newType)
		rel.replaceByteAtOffset(startOffset + kMoveCategoryOffset, withByte: newCategory)
		
		rel.replaceByteAtOffset(startOffset + kEffectOffset, withByte: self.effect)
		rel.replaceByteAtOffset(startOffset + kBasePowerOffset, withByte: self.basePower)
		rel.replaceByteAtOffset(startOffset + kAccuracyOffset, withByte: self.accuracy)
		rel.replaceByteAtOffset(startOffset + kPPOffset, withByte: self.pp)
		rel.replaceByteAtOffset(startOffset + kEffectAccuracyOffset, withByte: self.effectAccuracy)
		rel.replaceByteAtOffset(startOffset + kPriorityOffset, withByte: self.priority < 0 ? 256 + self.priority : self.priority)
		
		rel.replaceWordAtOffset(startOffset + kMoveNameIDOffset, withBytes: UInt32(self.nameID))
		rel.replaceWordAtOffset(startOffset + kMoveDescriptionIDOffset, withBytes:UInt32( self.descriptionID))
		rel.replace2BytesAtOffset(startOffset + kAnimationIndexOffset , withBytes: self.animationID)
		rel.replace2BytesAtOffset(startOffset + kAnimation2IndexOffset, withBytes: self.animation2ID)
		
		rel.replaceByteAtOffset(startOffset + kMoveDisplaysTypeMatchupInSummaryScreenFlagOffset, withByte: self.displayTypeMatchupFlag)
		
		rel.replaceByteAtOffset(startOffset + kMoveEffectTypeOffset, withByte: self.effectType.rawValue)
		
		rel.replace2BytesAtOffset(startOffset + kMoveUnusedStringIDOffset, withBytes: self.unusedString)
		rel.replace2BytesAtOffset(startOffset + kMoveExclamationPointStringIDOffset, withBytes: self.exclamationString)
		
		rel.save()
		
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
			dictRep["displaysTypeMatchUpInSummaryScreenFlag"] = self.displayTypeMatchupFlag as AnyObject?
			
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
			dictRep["displaysTypeMatchUpInSummaryScreenFlag"] = self.displayTypeMatchupFlag as AnyObject?
			
			dictRep["type"] = self.type.name as AnyObject?
			dictRep["target"] = self.target.string as AnyObject?
			dictRep["category"] = self.category.string as AnyObject?
			
			return ["\(self.moveIndex) " + self.name.string : dictRep as AnyObject]
		}
	}
	
	
}











