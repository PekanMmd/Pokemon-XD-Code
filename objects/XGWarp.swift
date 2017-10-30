//
//  XGWarp.swift
//  GoD Tool
//
//  Created by The Steez on 29/10/2017.
//
//

import Cocoa

let kSizeOfWarp = 0x1C
let kWarpIsValidOffset = 0x0
let kWarpFromOffset = 0x2
let kWarpFromIndexOffset = 0x7
let kWarpToOffset = 0xE
let kWarpToIndexOffset = 0x13

var warps = [XGWarp]()
var allWarps : [XGWarp] {
get {
	if warps.isEmpty {
		for i in 0 ..< CommonIndexes.NumberOfWarps.value {
			warps.append(XGWarp(index: i))
		}
	}
	return warps
}
}

class XGWarp: NSObject {
	
	var index = 0
	var startOffset = 0
	
	var warpFromIndex = 0
	var warpFromRoom : XGRoom!
	
	var warpToIndex = 0
	var warpToRoom : XGRoom!
	
	var warpIsValid = true
	
	override var description: String {
		if warpFromRoom == nil || warpToRoom == nil {
			return "-"
		}
		
		return "Warp: \(warpFromRoom.name)[\(self.warpFromIndex)] -> \(warpToRoom.name)[\(warpToIndex)]"
	}
	
	init(index: Int) {
		super.init()
		
		self.index = index
		self.startOffset = CommonIndexes.Warps.startOffset + (index * kSizeOfWarp)
		
		let rel = XGFiles.common_rel.data
		self.warpFromRoom = XGRoom.roomWithID(rel.get2BytesAtOffset(startOffset + kWarpFromOffset))
		self.warpFromIndex = rel.getByteAtOffset(startOffset + kWarpFromIndexOffset)
		self.warpToRoom = XGRoom.roomWithID(rel.get2BytesAtOffset(startOffset + kWarpToOffset))
		self.warpToIndex = rel.getByteAtOffset(startOffset + kWarpToIndexOffset)
		
		self.warpIsValid = rel.getByteAtOffset(startOffset + kWarpIsValidOffset) == 1
		
	}
	
	class func warpForRoom(roomID: Int, withIndex index: Int) -> XGWarp {
		return allWarps.filter({ (w) -> Bool in
			return w.warpFromRoom.roomID == roomID && w.warpFromIndex == index
		})[0]
	}

}

let kSizeOfWarpLocation = 0x10
class XGWarpLocation : NSObject {
	
	let kWarpTypeOffset = 0x0
	let kXOffset = 0x4
	let kYOffset = 0x8
	let kZOffset = 0xC
	
	var warpType : XGWarpTypes!
	var index = 0
	var startOffset = 0
	
	var sortedIndex = 0
	
	var xCoordinate : Float = 0
	var yCoordinate : Float = 0
	var zCoordinate : Float = 0
	
	var file : XGFiles!
	var rawData : [Int] {
		return file.data.getByteStreamFromOffset(startOffset, length: kSizeOfWarpLocation)
	}
	
	var squareDistanceFromCenter : Float {
		return pow(xCoordinate, 2) + pow(yCoordinate, 2) + pow(zCoordinate, 2)
	}
	
	var warp : XGWarp? {
		let room = XGRoom.roomWithName(self.file.fileName.removeFileExtensions())
		if room != nil {
			let warps = room!.warps
			
			if self.index < warps.count {
				let w = warps[self.sortedIndex]
				return w
			}
		}
		return nil
	}
	
	init(file: XGFiles, index: Int, startOffset: Int) {
		super.init()
		
		self.index = index
		self.startOffset = startOffset
		self.file = file
		
		let data = file.data
		
		let w = data.get2BytesAtOffset(startOffset + kWarpTypeOffset)
		self.warpType = XGWarpTypes.index(w)
		
		self.xCoordinate = data.get4BytesAtOffset(startOffset + kXOffset).hexToSignedFloat()
		self.yCoordinate = data.get4BytesAtOffset(startOffset + kYOffset).hexToSignedFloat()
		self.zCoordinate = data.get4BytesAtOffset(startOffset + kZOffset).hexToSignedFloat()
	}
	
	func save() {
		let data = file.data
		
		data.replace2BytesAtOffset(startOffset + kWarpTypeOffset, withBytes: self.warpType.index)
		data.replace4BytesAtOffset(startOffset + kXOffset, withBytes: self.xCoordinate.bitPattern)
		data.replace4BytesAtOffset(startOffset + kYOffset, withBytes: self.yCoordinate.bitPattern)
		data.replace4BytesAtOffset(startOffset + kZOffset, withBytes: self.zCoordinate.bitPattern)
		
		data.save()
	}
	
}
