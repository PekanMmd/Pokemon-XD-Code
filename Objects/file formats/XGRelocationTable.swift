//
//  XGRelocationTable.swift
//  GoD Tool
//
//  Created by The Steez on 19/10/2017.
//
//

import Foundation

let common = XGCommon()
class XGCommon: XGRelocationTable {
	
	init() {
		super.init(file: .common_rel)
		self.dataStart = Int(self.data!.getWordAtOffset(kCommonRELDataStartOffsetLocation))
	}
	
	var dictionary : [Int : (pointer: Int, value: Int)] {
		var dict = [Int : (Int, Int)]()
		for i in 0 ..< kNumberRelPointers {
			dict[i] = (self.getPointer(index: i), self.getValueAtPointer(index: i))
		}
		return dict
	}
	
}

let pocket = XGPocket()
class XGPocket : XGRelocationTable {
	init() {
		super.init(file: .pocket_menu)
	}
}


let kCommonRELDataStartOffsetLocation = 0x6c
let kRELDataStartOffsetLocation = 0x64
let kRELPointersStartOffsetLocation = 0x24
let kRELPointersHeaderPointerOffset = 0x28
let kRELPointersFirstPointerOffset = 0x8
let kRELSizeOfPointer = 0x10
let kRELPointerDataPointer1Offset = 0x4
let kRELPointerDataPointer2Offset = 0xc

class XGRelocationTable: NSObject {
	
	var file: XGFiles!
	var data: XGMutableData!
	
	var dataStart = 0
	var pointersStart = 0
	var firstPointer = 0
	var numberOfPointers = 0
	
	init(file: XGFiles) {
		super.init()
		
		self.file = file
		self.data = file.data
		
		if data != nil {
			self.dataStart = Int(data.getWordAtOffset(kRELDataStartOffsetLocation))
			self.pointersStart = Int(data.getWordAtOffset(kRELPointersStartOffsetLocation))
			self.firstPointer = pointersStart + kRELPointersFirstPointerOffset
			
			let pointersHeaderOffset = data.get4BytesAtOffset(kRELPointersHeaderPointerOffset)
			let pointersEnd = data.get4BytesAtOffset(pointersHeaderOffset + 0xc)
			var currentOffset = firstPointer
			var found = false
			while currentOffset < pointersEnd && !found {
				let val = data.get4BytesAtOffset(currentOffset)
				if val >= 0xca01 && val <= 0xcaff {
					found = true
				} else {
					numberOfPointers += 1
				}
				
				currentOffset += kRELSizeOfPointer
			}
			
		}
		
	}
	
	private var pointers = [Int : Int]()
	
	func getPointerOffset(index: Int) -> Int {
		return firstPointer + (index * kRELSizeOfPointer) + kRELPointerDataPointer1Offset
	}
	
	func getPointer(index: Int) -> Int {
		
		if pointers[index] == nil {
			let offset = firstPointer + (index * kRELSizeOfPointer) + kRELPointerDataPointer1Offset
			pointers[index] = Int(data.getWordAtOffset(offset)) + dataStart
		}
		
		return pointers[index] ?? 0
	}
	
	func getValueAtPointer(index: Int) -> Int {
		let startOffset = getPointer(index: index)
		return Int(data.getWordAtOffset(startOffset))
	}
	
	func setValueAtPointer(index: Int, newValue value: Int) {
		let startOffset = getPointer(index: index)
		data.replaceWordAtOffset(startOffset, withBytes: value.unsigned)
		data.save()
	}
	
	func replacePointer(index: Int, newAbsoluteOffset newOffset: Int) {
		let offset1 = firstPointer + (index * kRELSizeOfPointer) + kRELPointerDataPointer1Offset
		let offset2 = firstPointer + (index * kRELSizeOfPointer) + kRELPointerDataPointer2Offset
		
		for offset in [offset1, offset2] {
			data.replaceWordAtOffset(offset, withBytes: UInt32(newOffset - dataStart))
		}
		data.save()
		
		pointers[index] = newOffset
	}
	
	func allPointers() -> [Int] {
		var p = [Int]()
		
		for i in 0 ..< self.numberOfPointers {
			p.append(self.getPointer(index: i))
		}
		
		return p
	}

	func printPointers() {
		self.allPointers().forEachIndexed { (index, pointer) in
			printg(index, pointer.hexString())
		}
	}
}









