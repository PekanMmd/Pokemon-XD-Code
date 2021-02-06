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
let kEffectOffset				= game == .XD ? 0x1C : 0x1A

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

final class XGMove: NSObject, Codable {
	
	var startOffset	= 0x0
	var moveIndex		= 0x0
	
	var unusedString 		= 0
	var exclamationString 	= 0
	
	var nameID		= 0x0
	var descriptionID = 0x0
	var animationID   = 0x0
	var animation2ID	= 0x0
	
	var priority			= 0x0
	var pp				= 0x0
	var effect			= 0x0
	var effectAccuracy	= 0x0
	var basePower			= 0x0
	var accuracy			= 0x0
	var type			= XGMoveTypes.normal
	var target			= XGMoveTargets.selectedTarget
	var category		= XGMoveCategories.none
	
	var effectType		= XGMoveEffectTypes.none
	
	var contactFlag		= false
	var protectFlag		= false
	var magicCoatFlag	= false
	var snatchFlag		= false
	var mirrorMoveFlag	= false
	var kingsRockFlag	= false
	var soundBasedFlag	= false
	var HMFlag			= false
	
	var displayTypeMatchupFlag = 0

	var animationStringIDs = [Int]() // for pbr compatibility
	
	var name : XGString {
		get {
			return XGFiles.common_rel.stringTable.stringSafelyWithID(nameID)
		}
	}
	
	var mdescription : XGString {
		get {
			return XGFiles.dol.stringTable.stringSafelyWithID(descriptionID)
		}
	}
	
	var isShadowMove	: Bool {
		get {
			return XGMoves.index(self.moveIndex).isShadowMove
		}
	}
	
	init(index: Int) {
		super.init()
		
		let rel   = XGFiles.common_rel.data!
		
		self.moveIndex       = index

		let safeIndex = index < kNumberOfItems ? index : 0
		self.startOffset     = CommonIndexes.Moves.startOffset + (safeIndex * kSizeOfMoveData)
		
		self.contactFlag	 = rel.getByteAtOffset(startOffset + kContactFlagOffset)    == 1
		self.protectFlag	 = rel.getByteAtOffset(startOffset + kProtectFlagOffset)    == 1
		self.magicCoatFlag	 = rel.getByteAtOffset(startOffset + kMagicCoatFlagOffset)  == 1
		self.snatchFlag		 = rel.getByteAtOffset(startOffset + kSnatchFlagOffset)	    == 1
		self.mirrorMoveFlag	 = rel.getByteAtOffset(startOffset + kMirrorMoveFlagOffset) == 1
		self.kingsRockFlag	 = rel.getByteAtOffset(startOffset + kKingsRockFlagOffset)  == 1
		self.soundBasedFlag	 = rel.getByteAtOffset(startOffset + kSoundBasedFlagOffset) == 1
		self.HMFlag			 = rel.getByteAtOffset(startOffset + kHMFlagOffset)		    == 1
		
		self.type			 = XGMoveTypes.index(rel.getByteAtOffset(startOffset + kMoveTypeOffset))
		self.target			 = XGMoveTargets(rawValue: rel.getByteAtOffset(startOffset + kTargetsOffset)) ?? .selectedTarget
		self.category		 = XGMoveCategories(rawValue: rel.getByteAtOffset(startOffset + kMoveCategoryOffset)) ?? .none
		
		self.effect			 = rel.get2BytesAtOffset(startOffset + kEffectOffset)
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

	func save() {

		guard moveIndex > 0, moveIndex < kNumberOfMoves else {
			return
		}
		
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
		
		let rel = XGFiles.common_rel.data!
		
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
		
		rel.replace2BytesAtOffset(startOffset + kEffectOffset, withBytes: self.effect)
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
	
}

extension XGMove: XGEnumerable {
	var enumerableName: String {
		return name.string
	}
	
	var enumerableValue: String? {
		return String(format: "%03d", moveIndex)
	}
	
	static var enumerableClassName: String {
		return "Moves"
	}
	
	static var allValues: [XGMove] {
		var values = [XGMove]()
		for i in 0 ..< CommonIndexes.NumberOfMoves.value {
			values.append(XGMove(index: i))
		}
		return values
	}
}

extension XGMove: XGDocumentable {
	
	static var documentableClassName: String {
		return "Moves"
	}
	
	var isDocumentable: Bool {
		return descriptionID != 0
	}
	
	var documentableName: String {
		return enumerableName + " - " + (enumerableValue ?? "")
	}

	static var DocumentableKeys: [String] {
		return ["index", "hex index", "name", "description", "type", "base pp", "base power", "category", "accuracy", "priority", "effect", "effect accuracy", "targets", "is shadow move", "is HM", "makes contact", "can be protected", "reflected by magic coat", "stolen by snatch", "copyable by mirror move", "affected by king's rock", "is sound based"]
	}
	
	static var DocumentableKeysForXG: [String] {
		return ["index", "hex index", "name", "is shadow move", "description", "type", "base pp", "base power", "category", "accuracy", "priority", "effect", "effect accuracy", "targets", "makes contact", "can be protected", "reflected by magic bounce", "blocked by bulletproof", "boosted by mega launcher", "affected by king's rock", "is sound based"]
	}
	
	func documentableValue(for key: String) -> String {
		switch key {
		case "index":
			return moveIndex.string
		case "hex index":
			return moveIndex.hexString()
		case "name":
			return name.string
		case "description":
			return mdescription.string
		case "type":
			return type.name
		case "base pp":
			return pp.string
		case "base power":
			return basePower.string
		case "category":
			return category.string
		case "accuracy":
			return accuracy.string
		case "priority":
			return priority.string
		case "effect":
			return effect.string
		case "effect accuracy":
			return effectAccuracy.string
		case "targets":
			return target.string
		case "is shadow move":
			return isShadowMove.string
		case "is HM":
			return HMFlag.string
		case "makes contact":
			return contactFlag.string
		case "can be protected":
			return protectFlag.string
		case "reflected by magic coat", "reflected by magic bounce":
			return magicCoatFlag.string
		case "stolen by snatch", "blocked by bulletproof":
			return snatchFlag.string
		case "copyable by mirror move", "boosted by mega launcher":
			return mirrorMoveFlag.string
		case "affected by king's rock":
			return kingsRockFlag.string
		case "is sound based":
			return soundBasedFlag.string
		default:
			return ""
		}
	}
}







