//
//  XGCharacter.swift
//  GoD Tool
//
//  Created by The Steez on 30/10/2017.
//
//

import Cocoa

let kCharacterFlagsOffset = 0x0
let kMovementOffset = 0x1
let kCharacterAngleOffset = 0x4
let kModelOffset = 0x6
let kCharacterIDOffset = 0x8
let kHasPassiveScriptOffset = 0x10
let kPassiveScriptIndexOffset = 0x12 // script in .scd file which continuously runs (similar to hero main always running)
let kHasScriptOffset = 0x14
let kScriptIndexOffset = 0x16 // script in .scd file which runs when character is interacted with
let kXOffset = 0x18
let kYOffset = 0x1C
let kZOffset = 0x20

let kSizeOfCharacter = 0x24
class XGCharacter : NSObject {
	
	@objc var model : XGCharacterModels!
	var movementType : XGCharacterMovements!
	@objc var characterID = 0
	
	@objc var nameID : Int {
		let start = CommonIndexes.PeopleIDs.startOffset + (self.characterID * 8)
		return XGFiles.common_rel.data.getWordAtOffset(start + 4).int
	}
	
	@objc var name : String {
		return XGFiles.common_rel.stringTable.stringSafelyWithID(self.nameID).string
	}
	
	override var description: String {
		get {
			return "\(self.characterID) - name: \(self.name) model: \(self.model.name)\n" + "coordinates: <\(self.xCoordinate),\(self.yCoordinate),\(self.zCoordinate)> angle: \(self.angle)\n" + "script: \(self.scriptName) (\(self.scriptIndex))\n"
		}
	}
	
	@objc var flags = 0
	var isVisible = false
	
	@objc var xCoordinate : Float = 0
	@objc var yCoordinate : Float = 0
	@objc var zCoordinate : Float = 0
	@objc var angle = 0
	
	@objc var hasScript = false
	@objc var scriptIndex = 0
	@objc var hasPassiveScript = false
	@objc var passiveScriptIndex = 0
	@objc var scriptName = "-"
	@objc var characterIndex = 0
	@objc var startOffset = 0
	
	var file : XGFiles!
	@objc var rawData : [Int] {
		return file.data.getByteStreamFromOffset(startOffset, length: kSizeOfCharacter)
	}
	
	override init() {
		super.init()
	}
	
	init(file: XGFiles, index: Int, startOffset: Int) {
		super.init()
		
		self.characterIndex = index
		self.startOffset = startOffset
		self.file = file
		
		let data = file.data
		let m = data.get2BytesAtOffset(startOffset + kModelOffset)
		self.model = XGCharacterModels(index: m)
		self.characterID = data.get2BytesAtOffset(startOffset + kCharacterIDOffset)
		self.hasScript = data.getByteAtOffset(startOffset + kHasScriptOffset) == 1
		self.scriptIndex = data.get2BytesAtOffset(startOffset + kScriptIndexOffset)
		self.hasPassiveScript = data.getByteAtOffset(startOffset + kHasPassiveScriptOffset) == 1
		self.passiveScriptIndex = data.get2BytesAtOffset(startOffset + kPassiveScriptIndexOffset)
		self.movementType = .index(data.getByteAtOffset(startOffset + kMovementOffset))
		
		self.xCoordinate = data.getWordAtOffset(startOffset + kXOffset).hexToSignedFloat()
		self.yCoordinate = data.getWordAtOffset(startOffset + kYOffset).hexToSignedFloat()
		self.zCoordinate = data.getWordAtOffset(startOffset + kZOffset).hexToSignedFloat()
		self.angle = data.get2BytesAtOffset(startOffset + kCharacterAngleOffset)
		
		self.flags = data.getByteAtOffset(startOffset + kCharacterFlagsOffset)
		self.isVisible = self.flags >> 7 == 1
	}
	
	@objc func save() {
		let data = file.data
		
		data.replace2BytesAtOffset(startOffset + kModelOffset, withBytes: self.model.index)
		data.replace2BytesAtOffset(startOffset + kCharacterIDOffset, withBytes: self.characterID)
		data.replaceByteAtOffset(startOffset + kHasScriptOffset, withByte: self.hasScript ? 1 : 0)
		data.replace2BytesAtOffset(startOffset + kPassiveScriptIndexOffset, withBytes: self.passiveScriptIndex)
		data.replaceByteAtOffset(startOffset + kHasPassiveScriptOffset, withByte: self.hasPassiveScript ? 1 : 0)
		data.replace2BytesAtOffset(startOffset + kScriptIndexOffset, withBytes: self.scriptIndex)
		data.replaceByteAtOffset(startOffset + kMovementOffset, withByte: self.movementType.index)
		
		data.replaceWordAtOffset(startOffset + kXOffset, withBytes: self.xCoordinate.bitPattern)
		data.replaceWordAtOffset(startOffset + kYOffset, withBytes: self.yCoordinate.bitPattern)
		data.replaceWordAtOffset(startOffset + kZOffset, withBytes: self.zCoordinate.bitPattern)
		data.replace2BytesAtOffset(startOffset + kCharacterAngleOffset, withBytes: self.angle)
		
		let flagsUpdated = (self.flags & 0x7F) | (self.isVisible ? 0x80 : 0x00)
		data.replaceByteAtOffset(startOffset + kCharacterFlagsOffset, withByte: flagsUpdated)
		
		data.save()
	}
}
