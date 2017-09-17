//
//  XGCommon.swift
//  GoD Tool
//
//  Created by The Steez on 17/09/2017.
//
//

import Foundation

let kRELDataStartOffsetLocation = 0x6c
let kRELPointersStartOffsetLocation = 0x70
let kRELPointersFirstPointerOffset = 0x18
let kRELSizeOfPointer = 0x10
let kRELPointerDataPointer1Offset = 0x4
let kRELPointerDataPointer2Offset = 0xc

let kNumberRelPointers = 0x84

enum Common_relIndices : Int {
	case BattleBingo  = 0
	case PokespotRock = 12
	case PokespotOasis = 15
	case PokespotCave = 18
	case PokespotAll = 21
	case Items = 70
	case PokemonStats = 88
	case Natures = 94
	case USStringTable = 116
	case Moves = 124
	case TutorMoves = 126
	case Types = 130
	
	func startOffset() -> Int {
		return common.getPointer(index: self)
	}
}

let common = XGCommon()
class XGCommon: NSObject {
	
	var data : XGMutableData {
		return XGFiles.common_rel.data
	}
	var dataStart = 0
	var pointersStart = 0
	var firstPointer = 0
	
	override init() {
		super.init()
		
		self.dataStart = Int(data.get4BytesAtOffset(kRELDataStartOffsetLocation))
		self.pointersStart = dataStart + Int(data.get4BytesAtOffset(kRELPointersStartOffsetLocation))
		self.firstPointer = pointersStart + kRELPointersFirstPointerOffset
		
	}
	
	var pointers = [Int : Int]()
	
	func getPointer(index: Int) -> Int {
		
		if pointers[index] == nil {
			let offset = firstPointer + (index * kRELSizeOfPointer) + kRELPointerDataPointer1Offset
			pointers[index] = Int(data.get4BytesAtOffset(offset)) + dataStart
		}
		
		return pointers[index] ?? 0
	}
	
	func replacePointer(index: Int, newAbsoluteOffset newOffset: Int) {
		let offset1 = firstPointer + (index * kRELSizeOfPointer) + kRELPointerDataPointer1Offset
		let offset2 = firstPointer + (index * kRELSizeOfPointer) + kRELPointerDataPointer2Offset
		
		for offset in [offset1, offset2] {
			data.replace4BytesAtOffset(offset, withBytes: UInt32(newOffset - dataStart))
		}
		data.save()
		
		pointers[index] = newOffset
	}
	
	func getPointer(index: Common_relIndices) -> Int {
		return getPointer(index: index.rawValue)
	}
	
	func replacePointer(index: Common_relIndices, newAbsoluteOffset newOffset: Int) {
		replacePointer(index: index.rawValue, newAbsoluteOffset: newOffset)
	}
	

}








