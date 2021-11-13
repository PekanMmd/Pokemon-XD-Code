//
//  XGMapRel.swift
//  GoD Tool
//
//  Created by Stars Momodu on 17/01/2021.
//

import Foundation

class XGMapRel: XGRelocationTable {

	var characters = [XGCharacter]()
	var entryLocations = [XGMapEntryLocation]()

	var roomID = 0

	var treasure = [XGTreasure]()

	var groupID = 0

	var script: XGScript? {
		let scriptFile = XGFiles.typeAndFsysName(.scd, data.file.fileName.removeFileExtensions())
		return scriptFile.exists ? scriptFile.scriptData : nil
	}

	convenience init(file: XGFiles, checkScript: Bool) {
		self.init(file: file)

		let data = file.data
		let groupDataOffset = getPointer(index: MapRelIndexes.groupData.rawValue)
		groupID = data?.get2BytesAtOffset(groupDataOffset + 8) ?? 0

		var firstEntryPoint = self.getPointer(index: MapRelIndexes.FirstWarpEntryLocation.rawValue)
		var numberOfEntryPoints = self.getValueAtPointer(index: MapRelIndexes.NumberOfWarpEntryLocations.rawValue)
		var usesAlternateRelFormat = false

		if game == .Colosseum {
			// check if it starts with an expected angle meaning it's an entry point
			let angleCheck = data?.getHalfAtOffset(firstEntryPoint).signed()
			switch angleCheck {
			case 0, 45, -45, 90, -90, 120, -120, 180, -180, 270, -270:
				usesAlternateRelFormat = false
			default:
				usesAlternateRelFormat = true
				firstEntryPoint = self.getPointer(index: 0)
				numberOfEntryPoints = self.getValueAtPointer(index: 1)
			}
			// check if number of entry points is to large, suggesting index is incorrect
			if numberOfEntryPoints > 20 {
				usesAlternateRelFormat = true
			}

		}

		for i in 0 ..< numberOfEntryPoints {
			let startOffset = firstEntryPoint + (i * kSizeOfMapEntryLocation)
			if startOffset + 16 < file.fileSize {
				let ip = XGMapEntryLocation(file: file, index: i, startOffset: startOffset)
				entryLocations.append(ip)
			} else {
				break
			}
		}

		if !fileDecodingMode, let room = XGRoom.roomWithName(file.fileName.removeFileExtensions()) {
			self.roomID = room.roomID
		}

		if !fileDecodingMode {
			for i in 0 ..< CommonIndexes.NumberTreasureBoxes.value {
				let treasure = XGTreasure(index: i)
				if treasure.roomID == self.roomID {
					self.treasure.append(treasure)
				}
			}
		}

		let script = checkScript ? self.script : nil

		var firstCharacter = self.getPointer(index: MapRelIndexes.FirstCharacter.rawValue)
		var numberOfCharacters = self.getValueAtPointer(index: MapRelIndexes.NumberOfCharacters.rawValue)

		if game == .Colosseum, usesAlternateRelFormat {
			firstCharacter = self.getPointer(index: 5)
			numberOfCharacters = self.getValueAtPointer(index: 6)
		}

		for i in 0 ..< numberOfCharacters {
			if game == .Colosseum, i > 30 {
				// if index is incorrect prevent looping for too long
				break
			}
			let startOffset = firstCharacter + (i * kSizeOfCharacter)
			if startOffset + kSizeOfCharacter < file.fileSize {
				let character = XGCharacter(file: file, index: i, startOffset: startOffset, groupID: groupID)

				if character.isValid {
					if character.hasScript,
					   let script = script {
						if character.scriptIndex < script.ftbl.count {
							character.scriptName = script.ftbl[character.scriptIndex].name
						}
					}
				} else {
					self.isValid = false
				}

				characters.append(character)
			}
		}
	}

}
