//
//  Move.swift
//  Mausoleum Move Tool
//
//  Created by StarsMmd on 26/12/2014.
//  Copyright (c) 2014 StarsMmd. All rights reserved.
// 

import Foundation

var kNumberOfMoves: Int {
	return PBRDataTable.moves.numberOfEntries // 468 in vanilla
}

final class XGMove: NSObject, XGIndexedValue {
	
	var startOffset			: Int {
		return PBRDataTable.moves.offsetForEntryWithIndex(index)
	}
	var index				= 0x0
	var moveIndex: Int {
		return index
	}
	
	var nameID				= 0x0
	var descriptionID   	= 0x0
	var description2ID		= 0x0
	var animationID     	= 0x0 // Just for colo/xd compatibility
	var animation2ID		= 0x0 // Just for colo/xd compatibility
	var animationStringIDs: [Int] {
		guard index > 0 else {
			return []
		}

		let firstID = 0x48d + ((index - 1) * 3)
		return Array(firstID ..< firstID + 3)
	}
	
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

	var isShadowMove: Bool {
		return false
	}
	
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
		guard index >= 0 else {

			return
		}
		let data  = PBRDataTableEntry.moves(index: self.index)
		
		effect = data.getShort(0)
		let targets = data.getShort(2)
		target = XGMoveTargets(rawValue: targets) ?? .selectedTarget
		let appeal = data.getByte(6)
		contestAppeal = XGContestAppeals(rawValue: appeal) ?? .cool
		
		nameID = data.getShort(8)
		descriptionID = data.getShort(10)
		description2ID = data.getShort(12)
		
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
		guard index >= 0 else { return }

		let data  = PBRDataTableEntry.moves(index: index)
		
		data.setShort(0, to: effect)
		data.setShort(2, to: target.rawValue)
		data.setByte(6, to: contestAppeal.rawValue)
		data.setShort(8, to: nameID)
		data.setShort(10, to: descriptionID)
		data.setShort(12, to: description2ID)
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
	
}

extension XGMove: XGEnumerable {
	var enumerableName: String {
		return name.unformattedString.spaceToLength(20)
	}

	var enumerableValue: String? {
		return index.string
	}

	static var enumerableClassName: String {
		return "Moves"
	}

	static var allValues: [XGMove] {
		return XGMoves.allMoves().map { $0.data }
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
		return ["index", "hex index", "name", "description", "type", "base pp", "base power", "category", "accuracy", "priority", "effect", "effect accuracy", "targets", "is HM", "makes contact", "can be protected", "reflected by magic coat", "stolen by snatch", "copyable by mirror move", "affected by king's rock", "is sound based", "flag 6", "flag 7"]
	}

	func documentableValue(for key: String) -> String {
		switch key {
		case "index":
			return index.string
		case "hex index":
			return index.hexString()
		case "name":
			return name.unformattedString
		case "description":
			return mdescription.unformattedString
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
		case "flag 6":
			return flag6.string
		case "flag 7":
			return flag7.string
		default:
			return ""
		}
	}
}







