//
//  XGCharacterModels.swift
//  GoD Tool
//
//  Created by The Steez on 22/10/2017.
//
//

import Foundation

let kSizeOfCharacterModel = 0x34

let kCharacterModelFSYSIdentifier = 0x4 // corresponds to the id of the model's file in people_archive.fsys. This is the word at offset 0 of each of the file entry details in the fsys (also used to refer to the model in scripts)


class XGCharacterModels : NSObject {

	var index = 0
	var identifier = 0
	var name = ""
	var fsysIndex = -1
	var fileSize = -1
	
	var startOffset = 0
	
	var rawData : [Int] {
		return XGFiles.common_rel.data.getByteStreamFromOffset(self.startOffset, length: kSizeOfCharacterModel)
	}
	
	var modelData : XGMutableData {
		let file = XGFiles.fsys("people_archive.fsys").fsysData
		return file.decompressedDataForFileWithIndex(index: fsysIndex)!
	}
	
	init(index: Int) {
		super.init()
		
		self.index = index
		self.startOffset = CommonIndexes.CharacterModels.startOffset + (self.index * kSizeOfCharacterModel)
		self.identifier = Int(XGFiles.common_rel.data.get4BytesAtOffset(self.startOffset + kCharacterModelFSYSIdentifier))
		
		let file = XGFiles.fsys("people_archive.fsys")
		if file.exists {
			let fsys = file.fsysData
			let fsysIndex = fsys.indexForIdentifier(identifier: self.identifier)
			if fsysIndex >= 0 {
				self.name = fsys.fileNames[fsysIndex]
				self.fsysIndex = fsysIndex
				self.fileSize = fsys.sizeForFile(index: fsysIndex)
			}
		}
	}
	
}


enum XGCharacterMovements : CustomStringConvertible {
	
	case index(Int)
	
	var index : Int {
		switch self {
		case .index(let i):
			return i
		}
	}
	
	var description : String {
		return self.name
	}
	
	var name : String {
		let m = XGCharacterMovements.movementsList[self.index]
		if m != nil {
			return m!
		}
		return "Unknown_\(self.index)"
	}
	
	static var movementsList : [Int : String] {
		return [
			0x0A : "Sit",
			0x10 : "Stand Still",
			0x12 : "Jog Down, Walk Up",
			0x50 : "Walk Around",
		]
	}
	
}














