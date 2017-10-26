//
//  XGRelocationTable.swift
//  GoD Tool
//
//  Created by The Steez on 19/10/2017.
//
//

import Cocoa

enum MapRelIndexes : Int {
	case FirstCharacter = 0
	case NumberOfCharacters = 1
}

let kSizeOfCharacter = 0x24
class XGCharacter : NSObject {
	
	let kModelOffset = 0x6
	let kCharacterIDOffset = 0x8
	let kHasScriptOffset = 0x14
	let kScriptIndexOffset = 0x16
	let kXOffset = 0x18
	let kYOffset = 0x1C
	let kZOffset = 0x20
	
	var model : XGCharacterModels!
	var characterID = 0
	
	var xCoordinate : Float = 0
	var yCoordinate : Float = 0
	var zCoordinate : Float = 0
	
	var hasScript = false
	var scriptIndex = 0
	var scriptName = "-"
	var characterIndex = 0
	var startOffset = 0
	
	var file : XGFiles!
	var rawData : [Int] {
		return file.data.getByteStreamFromOffset(startOffset, length: kSizeOfCharacter)
	}
	
	init(file: XGFiles, index: Int, startOffset: Int) {
		super.init()
		
		self.characterIndex = index
		self.startOffset = startOffset
		self.file = file
		
		let data = file.data
		let m = data.get2BytesAtOffset(startOffset + kModelOffset)
		self.model = XGCharacterModels(index: m)
		self.characterID = data.get2BytesAtOffset(startOffset + kCharacterIDOffset)
		self.hasScript = data.getByteAtOffset(startOffset + kHasScriptOffset) == 1
		self.scriptIndex = data.get2BytesAtOffset(startOffset + kScriptIndexOffset)
		
		self.xCoordinate = data.get4BytesAtOffset(startOffset + kXOffset).hexToSignedFloat()
		self.yCoordinate = data.get4BytesAtOffset(startOffset + kYOffset).hexToSignedFloat()
		self.zCoordinate = data.get4BytesAtOffset(startOffset + kZOffset).hexToSignedFloat()
	}
}

class XGMapRel : XGRelocationTable {
	
	var characters = [XGCharacter]()
	var script : XGScript!
	
	override init(file: XGFiles) {
		super.init(file: file)
		
		let scriptFile = XGFiles.script(file.fileName.replacingOccurrences(of: ".rel", with: ".scd"))
		if scriptFile.exists {
			self.script = scriptFile.scriptData
		}
		
		let firstCharacter = self.getPointer(index: MapRelIndexes.FirstCharacter.rawValue)
		let numberOfCharacters = self.getValueAtPointer(index: MapRelIndexes.NumberOfCharacters.rawValue)
		
		for i in 0 ..< numberOfCharacters {
			let character = XGCharacter(file: file, index: i, startOffset: firstCharacter + (i * kSizeOfCharacter))
			
			if character.hasScript {
				if self.script != nil {
					if character.scriptIndex < script.ftbl.count {
						character.scriptName = script.ftbl[character.scriptIndex].name
					}
				}
			}
			
			characters.append(character)
		}
	}
	
}

let kNumberRelPointers = 0x84
enum CommonIndexes : Int {
	case BattleBingo  = 0
	case NumberOfBingoCards = 1
	case PeopleIDs = 2 // 2 bytes at offset 0 person id 4 bytes at offset 4 string id for character name
	case NumberOfPeopleIDs = 3
	case PokespotRock = 12
	case PokespotRockEntries = 13
	case PokespotOasis = 15
	case PokespotOasisEntries = 16
	case PokespotCave = 18
	case PokespotCaveEntries = 19
	case PokespotAll = 21
	case PokespotAllEntries = 22
	case Maps = 50 // includes name id for room and room id used in scripts
	case Rooms = 58
	case ValidItems = 68 // list of items which are actually available
	case TotalNumberOfItems = 69
	case Items = 70
	case NumberOfItems = 71
	case CharacterModels = 84
	case NumberOfCharacterModels = 85
	case PokemonStats = 88
	case NumberOfPokemon = 89
	case Natures = 94
	case NumberOfNatures = 95
	case USStringTable = 116
	case Moves = 124
	case NumberOfMoves = 125
	case TutorMoves = 126
	case NumberOfTutorMoves = 127
	case Types = 130
	case NumberOfTypes = 131
	
	var startOffset : Int {
		return common.getPointer(index: self.rawValue)
	}
	
	var value : Int {
		return common.getValueAtPointer(index: self.rawValue)
	}
}

let common = XGCommon()
class XGCommon : XGRelocationTable {
	
	init() {
		super.init(file: XGFiles.common_rel)
		self.dataStart = Int(self.data.get4BytesAtOffset(kCommonRELDataStartOffsetLocation))
	}
	
}

enum PocketIndexes : Int {
	case MartStartIndexes  = 0
	case numberOfMarts = 1
	case MartGreetings = 2
	case numberOfMartGreetingSections = 3
	case MartItems = 4
	case numberOfMartItems = 5
	
	var startOffset : Int {
		return pocket.getPointer(index: self.rawValue)
	}
	
	var value : Int {
		return pocket.getValueAtPointer(index: self.rawValue)
	}
}

let pocket = XGPocket()
class XGPocket : XGRelocationTable {
	init() {
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
	var data : XGMutableData!
	
	var dataStart = 0
	var pointersStart = 0
	var firstPointer = 0
	
	init(file: XGFiles) {
		super.init()
		
		self.file = file
		self.data = file.data
		
		self.dataStart = Int(data.get4BytesAtOffset(kRELDataStartOffsetLocation))
		self.pointersStart = Int(data.get4BytesAtOffset(kRELPointersStartOffsetLocation))
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
	
	func getValueAtPointer(index: Int) -> Int {
		let startOffset = getPointer(index: index)
		return Int(data.get4BytesAtOffset(startOffset))
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
	

}
