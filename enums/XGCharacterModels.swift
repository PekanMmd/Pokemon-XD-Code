//
//  XGCharacterModels.swift
//  GoD Tool
//
//  Created by The Steez on 22/10/2017.
//
//

import Foundation

let kSizeOfCharacterModel = game == .XD ? 0x34 : 0x2c

// corresponds to the id of the model's file in people_archive.fsys. This is the word at offset 0 of each of the file entry details in the fsys (also used to refer to the model in scripts)
let kCharacterModelFSYSIdentifier = game == .XD ? 0x4 : 0xc
// 8 total, assuming they make up vertices of bound box
let kFirstBoundBoxVertexOffset = game == .XD ? 0x8 : 0x10


class XGCharacterModels : NSObject {

	@objc var index = 0
	@objc var identifier : UInt32 = 0
	@objc var name = ""
	@objc var fsysIndex = -1
	@objc var fileSize = -1
	
	var boundBox = [Float]()
	
	@objc var startOffset = 0
	
	@objc var archive : XGFsys? {
		if game == .XD {
			return XGFiles.fsys("people_archive").fsysData
		}
		let files = XGUtility.searchForFsysForIdentifier(id: identifier)
		if files.count > 0 {
			return files[0]
		}
		return nil
	}
	
	@objc var rawData : [Int] {
		return XGFiles.common_rel.data.getByteStreamFromOffset(self.startOffset, length: kSizeOfCharacterModel)
	}
	
	@objc var modelData : XGMutableData {
		return archive!.decompressedDataForFileWithIndex(index: fsysIndex)!
	}
	
	@objc init(index: Int) {
		super.init()
		
		let rel = XGFiles.common_rel.data
		
		self.index = index
		self.startOffset = CommonIndexes.CharacterModels.startOffset + (self.index * kSizeOfCharacterModel)
		self.identifier = rel.getWordAtOffset(self.startOffset + kCharacterModelFSYSIdentifier)
		
		if let arch = archive {
			let file = arch.file!
			if file.exists {
				let fsysIndex = arch.indexForIdentifier(identifier: self.identifier.int)
				if fsysIndex >= 0 {
					self.name = arch.fileNames[fsysIndex]
					self.fsysIndex = fsysIndex
					self.fileSize = arch.sizeForFile(index: fsysIndex)
				}
			}
		}
		
		for i in 0 ..< 8 {
			let offset = self.startOffset + (i * 4) + kFirstBoundBoxVertexOffset
			let f = rel.getWordAtOffset(offset).hexToSignedFloat()
			self.boundBox.append(f)
		}
	}
	
	func save() {
		let rel = XGFiles.common_rel.data
		
		rel.replaceWordAtOffset(self.startOffset + kCharacterModelFSYSIdentifier, withBytes: self.identifier)
		for i in 0 ..< 8 {
			let offset = self.startOffset + (i * 4) + kFirstBoundBoxVertexOffset
			let f = self.boundBox[i]
			rel.replaceWordAtOffset(offset, withBytes: f.floatToHex())
		}
		
		rel.save()
	}
	
	@objc class func modelWithIdentifier(id: Int) -> XGCharacterModels {
		for i in 0 ..< CommonIndexes.NumberOfCharacterModels.value {
			let model = XGCharacterModels(index: i)
			if model.identifier == id {
				return model
			}
		}
		return XGCharacterModels(index: 0)
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
			0x00 : "none",
			0x0A : "Sit",
			0x10 : "Stand Still",
			0x12 : "Jog Down, Walk Up",
			0x50 : "Walk Around",
		]
	}
	
}














