//
//  PBRAbilitiesManager.swift
//  GoD Tool
//
//  Created by Stars Momodu on 18/04/2021.
//

import Foundation

struct PBRAbilityData {
	let index: Int
	let unknownID: Int
	let nameStringID: Int
	let descriptionStringID: Int

	var name: XGString {
		return nameStringID.stringIDToString()
	}

	var description: XGString {
		return descriptionStringID.stringIDToString()
	}
}

class PBRAbilitiesManager {

	static var shared = PBRAbilitiesManager()
	static func reload() {
		shared = PBRAbilitiesManager()
	}

	var entries: [PBRAbilityData]?

	private init() {
		guard let data = XGFiles.indexAndFsysName(region == .JP ? 17 : 23, "common").data else {
			printg("Couldn't load abilities list from common.fsys")
			return
		}

		entries = [PBRAbilityData]()

		let numberOfEntries = data.get4BytesAtOffset(0)
//		let unknown1 = data.get4BytesAtOffset(4) // 4 by default
//		let stringsStartOffset = data.get4BytesAtOffset(8) // 0x30 by default
//		let stringsLength = data.get4BytesAtOffset(12)
		let msgIDsStartOffset = data.get4BytesAtOffset(16)
//		let msgIDsLength = data.get4BytesAtOffset(20)
		let entryPointersOffset = data.get4BytesAtOffset(24)
//		let numberOfEntries2 = data.get4BytesAtOffset(28)
//		let entriesStartOffset = data.get4BytesAtOffset(32)

		for i in 0 ..< numberOfEntries {
			let entryPointerOffset = entryPointersOffset + (i * 4)
			let entryDataOffset = data.get4BytesAtOffset(entryPointerOffset)
			let stringDataOffset = data.get4BytesAtOffset(entryDataOffset)

			let abilityIndex = data.get4BytesAtOffset(entryDataOffset + 4)
			let unknownIDOffset = stringDataOffset
//			let stringOffset = stringDataOffset + 2
			let id = data.get2BytesAtOffset(unknownIDOffset)
//			let string = data.getStringAtOffset(stringOffset, charLength: .char, maxCharacters: nil)

			let msgIDsOffset = msgIDsStartOffset + (abilityIndex * 4)
			let nameID = data.get2BytesAtOffset(msgIDsOffset)
			let descriptionID = data.get2BytesAtOffset(msgIDsOffset + 2)

			entries?.append(.init(index: abilityIndex, unknownID: id, nameStringID: nameID, descriptionStringID: descriptionID))
		}
		entries?.sort(by: { (a1, a2) -> Bool in
			return a1.index < a2.index
		})
	}

	func getAbility(_ index: Int) -> PBRAbilityData? {
		guard let entryData = entries,  index < entryData.count else { return nil }
		return entryData[index]
	}

	func addAbility(nameID: Int, descriptionID: Int, unknownID: Int) {
		entries?.append(.init(index: entries?.count ?? 0, unknownID: unknownID, nameStringID: nameID, descriptionStringID: descriptionID))
		save()
	}

	func data() -> XGMutableData? {
		guard let entryData = entries else { return nil }

		func align(_ value: Int) -> Int {
			var aligned = value
			while aligned % 16 != 0 {
				aligned += 1
			}
			return aligned
		}

		let headerLength = 0x30
		let entryCount = entryData.count
		let stringLength = 2 + "TOKUSEI_000".count + 1 // 2 for unknown id and 1 for null terminator byte
		let stringsLength = stringLength * entryCount
		let alignedStringsLength = align(stringsLength)
		let msgIDsLength = entryCount * 4
		let alignedMSGIDsLength = align(msgIDsLength)
		let entriesLength = 8 * entryCount
		let alignedEntriesLength = align(entriesLength)
		let alignedEntryPointersLength = alignedMSGIDsLength

		let totalLength = headerLength + alignedStringsLength + alignedMSGIDsLength + alignedEntriesLength + alignedEntryPointersLength
		let fileData = XGMutableData(length: totalLength)
		fileData.file = XGFiles.indexAndFsysName(region == .JP ? 17 : 23, "common")

		fileData.replace4BytesAtOffset(0, withBytes: entryCount)
		fileData.replace4BytesAtOffset(4, withBytes: 4)
		fileData.replace4BytesAtOffset(8, withBytes: 0x30)
		fileData.replace4BytesAtOffset(12, withBytes: stringsLength)
		fileData.replace4BytesAtOffset(16, withBytes: headerLength + alignedStringsLength)
		fileData.replace4BytesAtOffset(20, withBytes: msgIDsLength)
		fileData.replace4BytesAtOffset(24, withBytes: headerLength + alignedStringsLength + alignedMSGIDsLength + alignedEntriesLength)
		fileData.replace4BytesAtOffset(28, withBytes: entryCount)
		fileData.replace4BytesAtOffset(32, withBytes: headerLength + alignedStringsLength + alignedMSGIDsLength)

		entryData.forEachIndexed { (index, entry) in
			let stringDataStartOffset = headerLength + (index * stringLength)
			fileData.replace2BytesAtOffset(stringDataStartOffset, withBytes: entry.unknownID)
			fileData.writeString("TOKUSEI_" + String(format: "%03d", entry.index), at: stringDataStartOffset + 2, charLength: .char)

			let msgIDsDataStartOffset = headerLength + alignedStringsLength + (entry.index * 4)
			fileData.replace2BytesAtOffset(msgIDsDataStartOffset, withBytes: entry.nameStringID)
			fileData.replace2BytesAtOffset(msgIDsDataStartOffset + 2, withBytes: entry.descriptionStringID)

			let entryStartOffset = headerLength + alignedStringsLength + alignedMSGIDsLength + (index * 8)
			fileData.replace4BytesAtOffset(entryStartOffset, withBytes: stringDataStartOffset)
			fileData.replace4BytesAtOffset(entryStartOffset + 4, withBytes: entry.index)

			let pointerOffset = headerLength + alignedStringsLength + alignedMSGIDsLength + alignedEntriesLength + (index * 4)
			fileData.replace4BytesAtOffset(pointerOffset, withBytes: entryStartOffset)
		}
		
		return fileData
	}

	func save() {
		data()?.save()
	}
	
}
