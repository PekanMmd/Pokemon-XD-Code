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

let multipliersTable = CommonStructTable(index: .NatureMultipliers, properties: multipliersStruct) { (index, data) -> String? in
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

let flagsTable = CommonStructTable(index: .GeneralFlags, properties: flagsStruct)
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

let SoundsTable = CommonStructTable(index: .SoundFiles, properties: SoundsStruct) { (index, data) -> String? in
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
	.short(name: "Sound File Index", description: "", type: .indexOfEntryInTable(table: SoundsTable, nameProperty: nil)),
	.word(name: "Unknown 2", description: "Unused?", type: .int)
])

let SoundsMetaDataTable = CommonStructTable(index: .SoundsMetaData, properties: SoundsMetaDataStruct) { (index, data) -> String? in
	if let fsysID: Int = data.get("Fsys ID"), let fsysName = XGISO.current.getFSYSNameWithGroupID(fsysID) {
		return fsysName
	}
	return nil
}
#endif

let aiWeightEffectsStruct = GoDStruct(name: "AI Weight Effect", format: [
	.word(name: "Effect", description: "", type: .int),
	.word(name: "Task Name ID", description: "", type: .msgID(file: nil)),
	.word(name: "Sub task Name ID", description: "", type: .msgID(file: nil)),
	.word(name: "Reason Name ID", description: "", type: .msgID(file: nil)),
	.word(name: "Unknown", description: "", type: .uint)
])
let aiWeightEffectsTable = CommonStructTable(index: .AIWeightEffects, properties: aiWeightEffectsStruct)

#if GAME_XD
let rgbaStruct = GoDStruct(name: "RGBA Colour", format: [
	.byte(name: "Red", description: "", type: .uintHex),
	.byte(name: "Green", description: "", type: .uintHex),
	.byte(name: "Blue", description: "", type: .uintHex),
	.byte(name: "Alpha", description: "", type: .uintHex),
])
let msgPalettesTable = CommonStructTable(index: .MsgPalettes, properties: rgbaStruct)


// Some pokemon use a different animation other than their idle animation in the summary screen.
// When showing a pokemon in the summary/pc this array is checked to see if that species should use
// a different animation id. Anything not in the list defaults to animation 0
let pokemonMenuAnimationsStruct = GoDStruct(name: "Pokemon Menu Animations", format: [
	.byte(name: "Animation ID", description: "The animation ID to use in the summary screen", type: .uint),
	.short(name: "Species ID", description: "The pokemon species this applies to", type: .pokemonID)
])
let pokemonMenuAnimationsTable = CommonStructTable(index: .PokemonMenuAnimations, properties: pokemonMenuAnimationsStruct)
#endif
