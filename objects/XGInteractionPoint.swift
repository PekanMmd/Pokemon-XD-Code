//
//  XGWarp.swift
//  GoD Tool
//
//  Created by The Steez on 29/10/2017.
//
//

import Cocoa

let kSizeOfInteractionPoint = 0x1C

let kIPMapIndexOffset = 0x13
let kIPMapIDOffset = 0xe
let kIPWarpTargetIndexOffset = 0x7
let kIPWarpTargetMapOffset = 0x2
let kIPTextIDOffset = 0xc
let kIPTypeOffset = 0xa


fileprivate var IPData = [XGInteractionPointData]()
fileprivate func getIPData() {
	if IPData.isEmpty {
		for i in 0 ..< CommonIndexes.NumberOfInteractionPoints.value {
			IPData.append(XGInteractionPointData(index: i))
		}
	}
}
var allInteractionPointData : [XGInteractionPointData] {
	getIPData()
	return IPData
}

class XGInteractionPointData: NSObject {
	
	@objc var index = 0
	@objc var startOffset = 0
	
	@objc var mapIndex = 0
	@objc var mapRoom : XGRoom!
	
	@objc var targetWarpIndex = 0
	@objc var targetWarpRoom : XGRoom!
	
	@objc var textID = 0
	@objc var text : XGString {
		return getStringSafelyWithID(id: textID)
	}
	
	@objc var IPType = 0
	
	@objc init(index: Int) {
		super.init()
		
		self.index = index
		self.startOffset = CommonIndexes.InteractionPoints.startOffset + (index * kSizeOfInteractionPoint)
		
		let rel = XGFiles.common_rel.data
		self.mapRoom = XGRoom.roomWithID(rel.get2BytesAtOffset(startOffset + kIPMapIDOffset))
		self.mapIndex = rel.getByteAtOffset(startOffset + kIPMapIndexOffset)
		self.targetWarpRoom = XGRoom.roomWithID(rel.get2BytesAtOffset(startOffset + kIPWarpTargetMapOffset))
		self.targetWarpIndex = rel.getByteAtOffset(startOffset + kIPWarpTargetIndexOffset)
		self.textID = rel.getWordAtOffset(startOffset + kIPTextIDOffset).int
		self.IPType = rel.get2BytesAtOffset(startOffset + kIPTypeOffset)
		
	}
	
	@objc class func dataForRoom(roomID: Int, IPIndex index: Int) -> XGInteractionPointData {
		return allInteractionPointData.filter({ (w) -> Bool in
			if w.mapRoom != nil {
				return w.mapRoom.roomID == roomID && w.mapIndex == index
			}
			return false
		})[0]
	}

}

let kSizeOfInteractionLocation = 0x10
let kIPAngleOffset = 0x0
let kILXOffset = 0x4
let kILYOffset = 0x8
let kILZOffset = 0xC

class XGInteractionLocation : NSObject {
	
	@objc var index = 0
	@objc var startOffset = 0
	
	@objc var xCoordinate : Float = 0
	@objc var yCoordinate : Float = 0
	@objc var zCoordinate : Float = 0
	@objc var angle = 0
	
	@objc var room : XGRoom {
		return XGRoom.roomWithName(self.file.fileName.removeFileExtensions())!
	}
	
	var file : XGFiles!
	@objc var rawData : [Int] {
		return file.data.getByteStreamFromOffset(startOffset, length: kSizeOfInteractionLocation)
	}
	
	@objc var interactionData : XGInteractionPointData {
		return XGInteractionPointData.dataForRoom(roomID: self.room.roomID, IPIndex: self.index)
	}
	
	init(file: XGFiles, index: Int, startOffset: Int) {
		super.init()
		
		self.index = index
		self.startOffset = startOffset
		self.file = file
		
		let data = file.data
		
		self.xCoordinate = data.getWordAtOffset(startOffset + kILXOffset).hexToSignedFloat()
		self.yCoordinate = data.getWordAtOffset(startOffset + kILYOffset).hexToSignedFloat()
		self.zCoordinate = data.getWordAtOffset(startOffset + kILZOffset).hexToSignedFloat()
		self.angle = data.get2BytesAtOffset(startOffset + kIPAngleOffset)
		
	}
	
	@objc func save() {
		let data = file.data
		
		data.replace2BytesAtOffset(startOffset + kIPAngleOffset, withBytes: self.angle)
		data.replaceWordAtOffset(startOffset + kILXOffset, withBytes: self.xCoordinate.bitPattern)
		data.replaceWordAtOffset(startOffset + kILYOffset, withBytes: self.yCoordinate.bitPattern)
		data.replaceWordAtOffset(startOffset + kILZOffset, withBytes: self.zCoordinate.bitPattern)
		
		data.save()
	}
	
}
