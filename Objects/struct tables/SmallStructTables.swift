//
//  SmallStructTables.swift
//  GoD Tool
//
//  Created by Stars Momodu on 18/03/2021.
//

import Foundation

let trainerClassesStruct = GoDStruct(name: "Trainer Class", format: [
	.short(name: "Payout", description: "The multiplier for the prize money", type: .uint),
	.word(name: "Name ID", description: "The msg ID for the trainer class name", type: .msgID(file: .common_rel)),
	.word(name: "Unknown", description: "Usually 5 but occasionally 8", type: .uintHex)
])

let trainerClassesTable =  CommonStructTable(index: CommonIndexes.TrainerClasses.rawValue, properties: trainerClassesStruct)

let peopleStruct = GoDStruct(name: "Character", format: [
	.short(name: "ID", description: "", type: .uintHex),
	.word(name: "Name ID", description: "", type: .msgID(file: .common_rel))
])

let peopleTable = CommonStructTable(index: .PeopleIDs, properties: peopleStruct)

let multipliersStruct = GoDStruct(name: "Multiplier", format: [
	.byte(name: "Numerator", description: "The top part of the fraction", type: .uint),
	.byte(name: "Denominator", description: "The bottom part of the fraction", type: .uint)
])

let multipliersTable = CommonStructTable(index: .Multipliers, properties: multipliersStruct) { (index, data) -> String? in
	if let numerator: Int = data.get("Numerator"),
	   let denominator: Int = data.get("Denominator") {
		if denominator == 100 {
			if numerator >= 100 {
				return "+\(numerator - 100)%"
			} else {
				return "-\(100 - numerator)%"
			}
		} else {
			return "\(numerator)/\(denominator)"
		}
	}
	return nil
}

let TMStruct = GoDStruct(name: "TM Or HM", format: [
	.byte(name: "Is HM", description: "", type: .bool),
	.word(name: "Move", description: "", type: .moveID)
])

let TMsTable = GoDStructTable(file: .dol, properties: TMStruct) { (_) -> Int in
	return kFirstTMListOffset
} numberOfEntriesInFile: { (_) -> Int in
	return 58
} nameForEntry: { (index, data) -> String? in
	if let move: Int = data.get("Move") {
		return XGMoves.index(move).name.unformattedString
	}
	return nil
}

#if GAME_XD
let tutorMoveStruct = GoDStruct(name: "Tutor Move", format: [
	.short(name: "Move ID", description: "", type: .moveID),
	.word(name: "Availability Flag", description: "The story progression flag value required to unlock this tutor move. (The required value is this value x10)", type: .uintHex),
	.word(name: "Already Taught Flag", description: "The flag for whether or not the move has already been taught", type: .uintHex)
])

let tutorMovesTable = CommonStructTable(index: .TutorMoves, properties: tutorMoveStruct)

let wzxStruct = GoDStruct(name: "WZX Animation", format: [
	.word(name: "Fsys ID", description: "", type: .fsysID),
	.word(name: "WZX File ID", description: "", type: .fsysFileIdentifier(fsysName: nil))
])

let wzxTable = GoDStructTable(file: .dol, properties: wzxStruct) { (_) -> Int in
	switch region {
	case .US: return 0x40d0f0
	case .EU: return 0x447a08
	case .JP: return 0x3ea7a0
	case .OtherGame: return -1
	}
} numberOfEntriesInFile: { (_) -> Int in
	0x577
} nameForEntry: { (index, data) -> String? in
	if let fsysID: Int = data.get("Fsys ID"), let fsysName = XGISO.current.getFSYSNameWithGroupID(fsysID) {
		return fsysName
	}
	return nil
}

let flagsStruct = GoDStruct(name: "Flags", format: [
	.bitArray(name: "Unknown Flags", description: "", bitFieldNames: [
		"Unknown 1",
		"Unknown 2",
		"Unknown 3",
		"Unknown 4",
		"Unknown 5",
		"Unknown 6",
		"Unknown 7",
		"Unknown 8",
	]),
	.short(name: "Value", description: "The value that is set in the save file. Always 0 in the game files.", type: .uint),
	.short(name: "Flag ID", description: "", type: .uintHex)
])

let flagsTable = CommonStructTable(index: .Flags, properties: flagsStruct)
#endif

#if GAME_XD
let SoundsStruct = GoDStruct(name: "Sounds", format: [
	.word(name: "Fsys ID", description: "", type: .fsysID),
	.word(name: "ISD File ID", description: "", type: .fsysFileIdentifier(fsysName: nil)),
	.word(name: "ISH File ID", description: "", type: .fsysFileIdentifier(fsysName: nil))
])
#else
let SoundsStruct = GoDStruct(name: "Sounds", format: [
	.word(name: "Samp File ID", description: "In bgm_archive.fsys", type: .fsysFileIdentifier(fsysName: nil)),
	.word(name: "Unknown", description: "", type: .uintHex)
])
#endif

let SoundsTable = CommonStructTable(index: .BGM, properties: SoundsStruct) { (index, data) -> String? in
	#if GAME_XD
	if let fsysID: Int = data.get("Fsys ID"), let fsysName = XGISO.current.getFSYSNameWithGroupID(fsysID) {
		return fsysName
	}
	#else
	if let fileIdentifier: Int = data.get("Samp File ID") {
		let fsys = XGFiles.fsys("bgm_archive").fsysData
		return fsys.fileNameForFileWithIdentifier(fileIdentifier)
	}
	#endif
	return nil
}

#if GAME_XD
let SoundsMetaDataStruct = GoDStruct(name: "Sounds Metadata", format: [
	.word(name: "Unknown", description: "", type: .uintHex),
	.short(name: "Sound Sub Index", description: "", type: .uint),
	.short(name: "Sound File Index", description: "", type: .indexOfEntryInTable(table: SoundsTable, nameProperty: nil))
])

let SoundsMetaDataTable = CommonStructTable(index: .SoundsMetaData, properties: SoundsMetaDataStruct) { (index, data) -> String? in
	if let fsysID: Int = data.get("Fsys ID"), let fsysName = XGISO.current.getFSYSNameWithGroupID(fsysID) {
		return fsysName
	}
	return nil
}
#endif


