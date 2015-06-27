//
//  Move.swift
//  Mausoleum Move Tool
//
//  Created by The Steez on 26/12/2014.
//  Copyright (c) 2014 Ovation International. All rights reserved.
// 

import UIKit

let kNumberOfMoves				= 0x0177
let kSizeOfMoveData				= 0x0038
let kFirstMoveOffset			= 0xA2710

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

let kMoveCategoryOffset			= 0x13
let kBasePowerOffset			= 0x19
let kEffectOffset				= 0x1D

let kMoveNameIDOffset			= 0x22
let kMoveDescriptionIDOffset	= 0x2E
let kAnimationIndexOffset		= 0x32

class XGMove: NSObject {
	
	var startOffset		= 0x0
	var moveIndex		= 0x0
	
	var moveName		= 0x0
	var moveDescription = 0x0
	var moveAnimation   = 0x0
	
	var priority		= 0x0
	var pp				= 0x0
	var effect			= 0x0
	var effectAccuracy	= 0x0
	var basePower		= 0x0
	var accuracy		= 0x0
	var type			= XGMoveTypes.Normal
	var target			= XGMoveTargets.SelectedTarget
	var category		= XGMoveCategories.None
	
	var contactFlag		= false
	var protectFlag		= false
	var magicCoatFlag	= false
	var snatchFlag		= false
	var mirrorMoveFlag	= false
	var kingsRockFlag	= false
	var soundBasedFlag	= false
	var HMFlag			= false
	
	var nameString : XGString {
		get {
			return XGMoves.Move(self.moveIndex).name
		}
	}
	
	var descriptionString : XGString {
		get {
			return XGMoves.Move(self.moveIndex).description
		}
	}
	
	var isShadowMove	: Bool {
		get {
			return XGMoves.Move(self.moveIndex).isShadowMove
		}
	}
	
	init(index: Int) {
		super.init()
		
		var rel   = XGFiles.Common_rel.data
		var table = XGStringTable.common_rel()
		
		self.moveIndex = index
		self.startOffset = kFirstMoveOffset + (index * kSizeOfMoveData)
		
		self.contactFlag	= rel.getByteAtOffset(startOffset + kContactFlagOffset)    == 1
		self.protectFlag	= rel.getByteAtOffset(startOffset + kProtectFlagOffset)    == 1
		self.magicCoatFlag	= rel.getByteAtOffset(startOffset + kMagicCoatFlagOffset)  == 1
		self.snatchFlag		= rel.getByteAtOffset(startOffset + kSnatchFlagOffset)	   == 1
		self.mirrorMoveFlag	= rel.getByteAtOffset(startOffset + kMirrorMoveFlagOffset) == 1
		self.kingsRockFlag	= rel.getByteAtOffset(startOffset + kKingsRockFlagOffset)  == 1
		self.soundBasedFlag	= rel.getByteAtOffset(startOffset + kSoundBasedFlagOffset) == 1
		self.HMFlag			= rel.getByteAtOffset(startOffset + kHMFlagOffset)		   == 1
		
		self.type			= XGMoveTypes(rawValue: rel.getByteAtOffset(startOffset + kMoveTypeOffset)) ?? .Normal
		self.target			= XGMoveTargets(rawValue: rel.getByteAtOffset(startOffset + kTargetsOffset)) ?? .SelectedTarget
		self.category		= XGMoveCategories(rawValue: rel.getByteAtOffset(startOffset + kMoveCategoryOffset)) ?? .None
		
		self.effect			= rel.getByteAtOffset(startOffset + kEffectOffset)
		self.effectAccuracy	= rel.getByteAtOffset(startOffset + kEffectAccuracyOffset)
		self.basePower		= rel.getByteAtOffset(startOffset + kBasePowerOffset)
		self.accuracy		= rel.getByteAtOffset(startOffset + kAccuracyOffset)
		self.priority		= rel.getByteAtOffset(startOffset + kPriorityOffset)
		self.pp				= rel.getByteAtOffset(startOffset + kPPOffset)
		
		self.moveName		= rel.get2BytesAtOffset(startOffset + kMoveNameIDOffset)
		self.moveDescription = rel.get2BytesAtOffset(startOffset + kMoveDescriptionIDOffset)
		self.moveAnimation  = rel.get2BytesAtOffset(startOffset + kAnimationIndexOffset)
		
	}

	func save() {
		
		var newContact	= contactFlag	 ? 1 : 0
		var newProtect	= protectFlag	 ? 1 : 0
		var newMagic	= magicCoatFlag	 ? 1 : 0
		var newSnatch	= snatchFlag	 ? 1 : 0
		var newMirror	= mirrorMoveFlag ? 1 : 0
		var newKings	= kingsRockFlag	 ? 1 : 0
		var newSound	= soundBasedFlag ? 1 : 0
		var newHM		= HMFlag		 ? 1 : 0
		
		var newTarget   = target.rawValue
		var newType		= type.rawValue
		var newCategory = category.rawValue
		
		var rel = XGFiles.Common_rel.data
		
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
		rel.replaceByteAtOffset(startOffset + kPriorityOffset, withByte: self.priority)
		
		rel.replace2BytesAtOffset(startOffset + kMoveNameIDOffset, withBytes: self.moveName)
		rel.replace2BytesAtOffset(startOffset + kMoveDescriptionIDOffset, withBytes: self.moveDescription)
		rel.replace2BytesAtOffset(startOffset + kAnimationIndexOffset, withBytes: self.moveAnimation)
		
		rel.save()
		
	}
	
}











