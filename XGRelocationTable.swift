//
//  XGRelocationTable.swift
//  GoD Tool
//
//  Created by The Steez on 19/10/2017.
//
//

import Cocoa

let common = XGCommon()
class XGCommon : XGRelocationTable {
	
	@objc init() {
		super.init(file: XGFiles.common_rel)
		self.dataStart = Int(self.data.get4BytesAtOffset(kCommonRELDataStartOffsetLocation))
	}
	
	var dictionary : [Int : (Int, Int)] {
		var dict = [Int : (Int, Int)]()
		for i in 0 ..< kNumberRelPointers {
			dict[i] = (self.getPointer(index: i), self.getValueAtPointer(index: i))
		}
		return dict
	}
	
}

let pocket = XGPocket()
class XGPocket : XGRelocationTable {
	@objc init() {
		super.init(file: XGFiles.pocket_menu)
	}
}


let kCommonRELDataStartOffsetLocation = 0x6c
let kRELDataStartOffsetLocation = 0x64
let kRELPointersStartOffsetLocation = 0x24
let kRELPointersFirstPointerOffset = 0x8
let kRELSizeOfPointer = 0x10
let kRELPointerDataPointer1Offset = 0x4
let kRELPointerDataPointer2Offset = 0xc

class XGRelocationTable: NSObject {
	
	var file : XGFiles!
	@objc var data : XGMutableData!
	
	@objc var dataStart = 0
	@objc var pointersStart = 0
	@objc var firstPointer = 0
	
	init(file: XGFiles) {
		super.init()
		
		self.file = file
		self.data = file.data
		
		self.dataStart = Int(data.get4BytesAtOffset(kRELDataStartOffsetLocation))
		self.pointersStart = Int(data.get4BytesAtOffset(kRELPointersStartOffsetLocation))
		self.firstPointer = pointersStart + kRELPointersFirstPointerOffset
		
	}
	
	@objc var pointers = [Int : Int]()
	
	@objc func getPointerOffset(index: Int) -> Int {
		return firstPointer + (index * kRELSizeOfPointer) + kRELPointerDataPointer1Offset
	}
	
	@objc func getPointer(index: Int) -> Int {
		
		if pointers[index] == nil {
			let offset = firstPointer + (index * kRELSizeOfPointer) + kRELPointerDataPointer1Offset
			pointers[index] = Int(data.get4BytesAtOffset(offset)) + dataStart
		}
		
		return pointers[index] ?? 0
	}
	
	@objc func getValueAtPointer(index: Int) -> Int {
		let startOffset = getPointer(index: index)
		return Int(data.get4BytesAtOffset(startOffset))
	}
	
	@objc func setValueAtPointer(index: Int, newValue value: Int) {
		let startOffset = getPointer(index: index)
		data.replaceWordAtOffset(startOffset, withBytes: value.unsigned)
		data.save()
	}
	
	@objc func replacePointer(index: Int, newAbsoluteOffset newOffset: Int) {
		let offset1 = firstPointer + (index * kRELSizeOfPointer) + kRELPointerDataPointer1Offset
		let offset2 = firstPointer + (index * kRELSizeOfPointer) + kRELPointerDataPointer2Offset
		
		for offset in [offset1, offset2] {
			data.replaceWordAtOffset(offset, withBytes: UInt32(newOffset - dataStart))
		}
		data.save()
		
		pointers[index] = newOffset
	}
	

}
