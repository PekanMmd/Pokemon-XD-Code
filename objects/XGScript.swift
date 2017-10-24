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
	var code = [UInt32]()
	
	var gvar = [Int]()
	var strg = [String]()
	var vect = [VECT]()
	var giri = [GIRI]()
	var arry = [[Int]]()
	
	
	init(file: XGFiles) {
		
		self.file = file
		
		let data = file.data
		
		func getStringAtOffset(_ offset: Int) -> String {
			
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
		
		self.FTBLStart = kScriptSizeOfTCOD
		self.HEADStart = FTBLStart + Int(data.get4BytesAtOffset(FTBLStart + kScriptSectionSizeOffset))
		self.CODEStart = HEADStart + Int(data.get4BytesAtOffset(HEADStart + kScriptSectionSizeOffset))
		self.GVARStart = CODEStart + Int(data.get4BytesAtOffset(CODEStart + kScriptSectionSizeOffset))
		self.STRGStart = GVARStart + Int(data.get4BytesAtOffset(GVARStart + kScriptSectionSizeOffset))
		self.VECTStart = STRGStart + Int(data.get4BytesAtOffset(STRGStart + kScriptSectionSizeOffset))
		self.GIRIStart = VECTStart + Int(data.get4BytesAtOffset(VECTStart + kScriptSectionSizeOffset))
		self.ARRYStart = GIRIStart + Int(data.get4BytesAtOffset(GIRIStart + kScriptSectionSizeOffset))
		
		self.code = data.getWordStreamFromOffset(CODEStart + kScriptSectionHeaderSize, length: GVARStart - (CODEStart + kScriptSectionHeaderSize))
		
		let numberFTBLEntries = Int(data.get4BytesAtOffset(FTBLStart + kScriptSectionEntriesOffset))
		let numberHEADEntries = Int(data.get4BytesAtOffset(HEADStart + kScriptSectionEntriesOffset))
		let numberCODEEntries = Int(data.get4BytesAtOffset(CODEStart + kScriptSectionEntriesOffset))
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
		
		
		
	}
	
	
}





















