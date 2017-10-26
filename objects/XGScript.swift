//
//  XGScript.swift
//  XGCommandLineTools
//
//  Created by StarsMmd on 21/05/2016.
//  Copyright © 2016 StarsMmd. All rights reserved.
//

import Foundation

let kScriptSectionHeaderSize = 0x20
let kScriptSizeOfTCOD = 0x10
let kScriptFTBLSize = 0x8
let kScriptGVARSize = 0x8
let kScriptVECTSize = 0xc
let kScriptGIRISize = 0x8
let kScriptARRYPointerSize = 0x4

let kScriptSectionSizeOffset = 0x4
let kScriptSectionEntriesOffset = 0x10


typealias FTBL = (codeOffset: Int, name: String)
typealias GIRI = (groupID: Int, resourceID: Int)
typealias VECT = (x: Float, y: Float, z: Float)

class XGScript: NSObject {
	
	var file : XGFiles!
	
	var FTBLStart = 0
	var HEADStart = 0
	var CODEStart = 0
	
	var GVARStart = 0
	var STRGStart = 0
	var VECTStart = 0
	var GIRIStart = 0 // group id resource id
	var ARRYStart = 0
	
	var ftbl = [FTBL]()
	var code = [XGScriptInstruction]()
	
	var gvar = [XGScriptVar]()
	var strg = [String]()
	var vect = [VECT]()
	var giri = [GIRI]()
	var arry = [[XGScriptVar]]()
	
	
	init(file: XGFiles) {
		super.init()
		
		self.file = file
		
		let data = file.data
		
		self.FTBLStart = kScriptSizeOfTCOD
		self.HEADStart = FTBLStart + Int(data.get4BytesAtOffset(FTBLStart + kScriptSectionSizeOffset))
		self.CODEStart = HEADStart + Int(data.get4BytesAtOffset(HEADStart + kScriptSectionSizeOffset))
		self.GVARStart = CODEStart + Int(data.get4BytesAtOffset(CODEStart + kScriptSectionSizeOffset))
		self.STRGStart = GVARStart + Int(data.get4BytesAtOffset(GVARStart + kScriptSectionSizeOffset))
		self.VECTStart = STRGStart + Int(data.get4BytesAtOffset(STRGStart + kScriptSectionSizeOffset))
		self.GIRIStart = VECTStart + Int(data.get4BytesAtOffset(VECTStart + kScriptSectionSizeOffset))
		self.ARRYStart = GIRIStart + Int(data.get4BytesAtOffset(GIRIStart + kScriptSectionSizeOffset))
		
		let numberFTBLEntries = Int(data.get4BytesAtOffset(FTBLStart + kScriptSectionEntriesOffset))
//		let numberHEADEntries = Int(data.get4BytesAtOffset(HEADStart + kScriptSectionEntriesOffset))
//		let numberCODEEntries = Int(data.get4BytesAtOffset(CODEStart + kScriptSectionEntriesOffset))
		let numberGVAREntries = Int(data.get4BytesAtOffset(GVARStart + kScriptSectionEntriesOffset))
		let numberSTRGEntries = Int(data.get4BytesAtOffset(STRGStart + kScriptSectionEntriesOffset))
		let numberVECTEntries = Int(data.get4BytesAtOffset(VECTStart + kScriptSectionEntriesOffset))
		let numberGIRIEntries = Int(data.get4BytesAtOffset(GIRIStart + kScriptSectionEntriesOffset))
		let numberARRYEntries = Int(data.get4BytesAtOffset(ARRYStart + kScriptSectionEntriesOffset))
		
		for i in 0 ..< numberFTBLEntries {
			let start = FTBLStart + kScriptSectionHeaderSize + (i * kScriptFTBLSize)
			let codeOffset = Int(data.get4BytesAtOffset(start))
			let nameOffset = Int(data.get4BytesAtOffset(start + 0x4))
			let name = getStringAtOffset(nameOffset + kScriptSizeOfTCOD)
			self.ftbl.append((codeOffset,name))
		}
		
		for i in 0 ..< numberGVAREntries {
			let start = GVARStart + kScriptSectionHeaderSize + (i * kScriptGVARSize)
			self.gvar.append( XGScriptVar(type: data.get2BytesAtOffset(start), rawValue: data.get4BytesAtOffset(start + 4)) )
		}
		
		var strgPos = STRGStart + kScriptSectionHeaderSize
		for _ in 0 ..< numberSTRGEntries {
			let str = getStringAtOffset(strgPos)
			self.strg.append(str)
			strgPos += str.characters.count + 1
		}
		
		for i in 0 ..< numberVECTEntries {
			let start = VECTStart + kScriptSectionHeaderSize + (i * kScriptVECTSize)
			let x = data.get4BytesAtOffset(start).hexToSignedFloat()
			let y = data.get4BytesAtOffset(start + 4).hexToSignedFloat()
			let z = data.get4BytesAtOffset(start + 8).hexToSignedFloat()
			self.vect.append((x,y,z))
		}
		
		for i in 0 ..< numberGIRIEntries {
			let start = GIRIStart + kScriptSectionHeaderSize + (i * kScriptGIRISize)
			let groupID = Int(data.get4BytesAtOffset(start))
			let resourceID = Int(data.get4BytesAtOffset(start + 0x4))
			self.giri.append((groupID, resourceID))
		}
		
		for i in 0 ..< numberARRYEntries {
			
			let start = ARRYStart + kScriptSectionHeaderSize
			
			let startPointer = data.get4BytesAtOffset(start + (i * kScriptARRYPointerSize)).int
			let entries = data.get4BytesAtOffset(start + startPointer - 0x10).int
			
			var arr = [XGScriptVar]()
			for j in 0 ..< entries {
				let varStart = start + startPointer + (j * kScriptGVARSize)
				arr.append( XGScriptVar(type: data.get2BytesAtOffset(varStart), rawValue: data.get4BytesAtOffset(varStart + 4)) )
			}
			self.arry.append(arr)
		}
		
		var rawCode = data.getWordStreamFromOffset(CODEStart + kScriptSectionHeaderSize, length: GVARStart - (CODEStart + kScriptSectionHeaderSize))
		
		var codePointer = 0
		while codePointer < rawCode.count {
			let instruction = XGScriptInstruction(bytes: rawCode[codePointer], next: codePointer == (rawCode.count - 1) ? 0 : rawCode[codePointer + 1])
			self.code.append(instruction)
			codePointer += instruction.length
		}
		
		
	}
	
	
	func getStringAtOffset(_ offset: Int) -> String {
		
		let data = self.file.data
		
		var currentOffset = offset
		
		var currChar = 0x0
		var nextChar = 0x1
		
		let string = XGString(string: "", file: nil, sid: nil)
		
		while (nextChar != 0x00) {
			
			currChar = data.getByteAtOffset(currentOffset)
			currentOffset += 1
			
			string.append(.unicode(currChar))
			
			
			nextChar = data.getByteAtOffset(currentOffset)
			
		}
		
		return string.string
		
	}
	
	
}





















