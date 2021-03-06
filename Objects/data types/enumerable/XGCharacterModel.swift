//
//  XGCharacterModel.swift
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


final class XGCharacterModel: NSObject, Codable {

	var index = 0
	var identifier : UInt32 = 0
	var name = ""
	var fileSize = -1
	
	var boundBox = [Float]()
	
	var startOffset = 0

	var archiveName: String?
	var archive: XGFsys? {
		return searchForArchive()
	}
	
	var rawData : [Int] {
		return XGFiles.common_rel.data!.getByteStreamFromOffset(self.startOffset, length: kSizeOfCharacterModel)
	}
	
	var modelData: XGMutableData? {
		if let fsys = archive,
		   let index = fsys.indexForIdentifier(identifier: identifier.int) {
			return fsys.decompressedDataForFileWithIndex(index: index)
		}
		return nil
	}
	
	init(index: Int, archiveName: String? = nil, loadArchive: Bool = true) {
		super.init()
		
		let rel = XGFiles.common_rel.data!
		
		self.index = index
		let firstModelOffset = CommonIndexes.CharacterModels.startOffset
		self.startOffset = firstModelOffset + (self.index * kSizeOfCharacterModel)
		self.identifier = rel.getWordAtOffset(self.startOffset + kCharacterModelFSYSIdentifier)
		self.archiveName = archiveName
		
		if loadArchive, let arch = archive,
		   let fsysIndex = arch.indexForIdentifier(identifier: self.identifier.int),
		   fsysIndex >= 0 {
			self.name = arch.fileNameForFileWithIndex(index: fsysIndex) ?? "-"
			self.fileSize = arch.sizeForFile(index: fsysIndex)
		} else {
			self.name = "CharacterModel_\(index)"
		}
		
		for i in 0 ..< 8 {
			let offset = self.startOffset + (i * 4) + kFirstBoundBoxVertexOffset
			let f = rel.getWordAtOffset(offset).hexToSignedFloat()
			self.boundBox.append(f)
		}
	}

	private func searchForArchive() -> XGFsys? {
		if identifier == 0 {
			return nil
		}

		if let name = archiveName {
			return XGFiles.fsys(name.removeFileExtensions()).fsysData
		}
		if game == .XD || XGFiles.fsys("people_archive").fsysData.indexForIdentifier(identifier: identifier.int) != nil {
			return XGFiles.fsys("people_archive").fsysData
		}

		let files = XGUtility.searchForFsysForIdentifier(id: identifier)
		if files.count > 0 {
			return files[0]
		}
		return nil
	}
	
	func save() {
		let rel = XGFiles.common_rel.data!
		
		rel.replaceWordAtOffset(self.startOffset + kCharacterModelFSYSIdentifier, withBytes: self.identifier)
		for i in 0 ..< 8 {
			let offset = self.startOffset + (i * 4) + kFirstBoundBoxVertexOffset
			let f = self.boundBox[i]
			rel.replaceWordAtOffset(offset, withBytes: f.floatToHex())
		}
		
		rel.save()
	}
	
	class func modelWithIdentifier(id: Int, archiveName: String? = nil) -> XGCharacterModel {
		for i in 0 ..< CommonIndexes.NumberOfCharacterModels.value {
			let model = XGCharacterModel(index: i, archiveName: archiveName, loadArchive: false)
			if model.identifier == id {
				return model
			}
		}
		return XGCharacterModel(index: 0)
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

extension XGCharacterMovements: Codable {
	enum CodingKeys: String, CodingKey {
		case index
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		let index = try container.decode(Int.self, forKey: .index)
		self = XGCharacterMovements.index(index)
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(self.index, forKey: .index)
	}
}

extension XGCharacterModel: XGEnumerable {
	var enumerableName: String {
		return name
	}
	
	var enumerableValue: String? {
		return index.string
	}
	
	static var className: String {
		return "Character Models"
	}
	
	static var allValues: [XGCharacterModel] {
		var values = [XGCharacterModel]()
		for i in 0 ..< CommonIndexes.NumberOfCharacterModels.value {
			values.append(XGCharacterModel(index: i))
		}
		return values
	}
}










