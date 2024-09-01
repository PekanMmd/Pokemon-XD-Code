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
let kCharacterCollisionRadiusOffset = game == .XD ? 0x10 : 0x18
let kCharacterInteractionRadiusOffset = game == .XD ? 0x24 : -1


final class XGCharacterModel: NSObject, Codable {

	var index = 0
	var identifier : UInt32 = 0
	var name = ""
	var fileSize = -1
	var collisionRadius: Float = 0
	
	#if GAME_XD
	var interactionRadius: Float = 0
	#endif
	
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
		
		collisionRadius = rel.getWordAtOffset(self.startOffset + kCharacterCollisionRadiusOffset).hexToSignedFloat()
		#if GAME_XD
		interactionRadius = rel.getWordAtOffset(self.startOffset + kCharacterInteractionRadiusOffset).hexToSignedFloat()
		#endif
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
		rel.replaceWordAtOffset(self.startOffset + kCharacterCollisionRadiusOffset, withBytes: self.collisionRadius.floatToHex())
		#if GAME_XD
		rel.replaceWordAtOffset(self.startOffset + kCharacterInteractionRadiusOffset, withBytes: self.interactionRadius.floatToHex())
		#endif
		
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


enum XGCharacterMovements: Int, Codable, CustomStringConvertible {
	
	case none, randomWalk = 2, randomRotation = 3
	
	var description : String {
		return self.name
	}
	
	var name : String {
		switch self {
		case .none:
			return "None"
		case .randomWalk:
			return "Random Walk"
		case .randomRotation:
			return "Random Rotation"
		}
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










