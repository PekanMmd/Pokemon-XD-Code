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

	#if GAME_XD
	var treasure = [XGTreasure]()
	var isValid = true

	var script: XGScript? {
		let scriptFile = XGFiles.typeAndFsysName(.scd, file.fileName.removeFileExtensions())
		return scriptFile.exists ? scriptFile.scriptData : nil
	}
	#endif

	override convenience init(file: XGFiles) {
		self.init(file: file, checkScript: true)
	}

	init(file: XGFiles, checkScript: Bool) {
		super.init(file: file)

		#if GAME_XD
		if self.numberOfPointers < kNumberMapPointers {
			if settings.verbose {
				printg("Map: \(file.path) has the incorrect number of map pointers. Possibly a colosseum file.")
			}
			self.isValid = false
			return
		}
		#endif

		let firstIP = self.getPointer(index: MapRelIndexes.FirstInteractionLocation.rawValue)
		let numberOfIPs = self.getValueAtPointer(index: MapRelIndexes.NumberOfInteractionLocations.rawValue)

		for i in 0 ..< numberOfIPs {
			let startOffset = firstIP + (i * kSizeOfMapEntryLocation)
			if startOffset + 16 < file.fileSize {
				let ip = XGMapEntryLocation(file: file, index: i, startOffset: startOffset)
				entryLocations.append(ip)
			}
		}

		if let room = XGRoom.roomWithName(file.fileName.removeFileExtensions()) {
			self.roomID = room.roomID
		}

		#if GAME_XD
		for i in 0 ..< CommonIndexes.NumberTreasureBoxes.value {
			let treasure = XGTreasure(index: i)
			if treasure.roomID == self.roomID {
				self.treasure.append(treasure)
			}
		}

		let script = checkScript ? self.script : nil
		#endif

		let firstCharacter = self.getPointer(index: MapRelIndexes.FirstCharacter.rawValue)
		let numberOfCharacters = self.getValueAtPointer(index: MapRelIndexes.NumberOfCharacters.rawValue)

		for i in 0 ..< numberOfCharacters {
			let startOffset = firstCharacter + (i * kSizeOfCharacter)
			if startOffset + kSizeOfCharacter < file.fileSize {
				let character = XGCharacter(file: file, index: i, startOffset: startOffset)

				#if GAME_XD
				if character.isValid {
					if character.hasScript {
						if script != nil {
							if character.scriptIndex < script!.ftbl.count {
								character.scriptName = script!.ftbl[character.scriptIndex].name
							}
						}
					}
				} else {
					self.isValid = false
				}
				#endif

				characters.append(character)
			}
		}
	}

}
