//
//  File.swift
//  GoD Tool
//
//  Created by Stars Momodu on 16/11/2020.
//

import Foundation

let kNumberOfPokemonPerParty = 6
let kNumberOfPokemonPerPCBox = 30

let kNumberOfBoxes = game == .Colosseum ? 3 : 8
let kNumberOfRegisteredParties = game == .Colosseum ? 2 : 2 // confirm actual number

let kSizeOfBoxHeader = 0x14
let kSizeOfRegisteredPartyHeader = 0x30
let kMaxNameLength = 10
let kSaveFilePokemonSize = game == .Colosseum ? 0x138 : 0xc4
let kSizeOfRegisteredPartyData = game == .Colosseum ? 0xb18 : 0x0 // find for xd
let kSaveFilePCItemsOffset = game == .Colosseum ? 0x797C : 0x12ED8
let kSaveFileNumberOfItemsInPC = 235
let kSaveFileBagItemsOffset = game == .Colosseum ? -1 : 0x142f8 // find for colo

let kSaveFilePlayerNameOffset = game == .Colosseum ? 0x78 : 0x13db8
let kSaveFilePlayerSIDOffset = game == .Colosseum ? 0xA4 : 0x13de4
let kSaveFilePlayerTIDOffset = game == .Colosseum ? 0xA6 : 0x13de6
let kSaveFilePartyPokemonStartOffset = game == .Colosseum ? 0xa8 : 0x13de8
let kSaveFilePCBoxesStartOffset = game == .Colosseum ? 0xb90 : 0x7678
let kSaveFileRegisteredPokemonStartOffset = game == .Colosseum ? 0x19744 : -1 // find for xd

class XGSaveManager {

	enum SaveType {
		// TODO: maybe add support for gcis and such
		// for now requires a single save slot obtained through other means
		case decryptedSaveSlot
		case gciSaveData
	}

	let file: XGFiles
	let saveType: SaveType
	let latestSaveSlot: XGSave?

	init(file: XGFiles, saveType: SaveType) {
		self.file = file
		self.saveType = saveType
		switch saveType {
		case .decryptedSaveSlot:
			if file.exists, let data = file.data {
				latestSaveSlot = XGSave(decryptedSaveSlot: data)
			} else {
				latestSaveSlot = nil
			}
		case .gciSaveData:
			if file.exists {
				let rawFile = XGFiles.nameAndFolder(file.fileName + ".raw", file.folder)
				if !rawFile.exists {
					GoDShellManager.run(.gcitool, args: "extract \(file.path.escapedPath) \(rawFile.path.escapedPath)")
				}

				if rawFile.exists, let data = rawFile.data {
					latestSaveSlot = XGSave(decryptedSaveSlot: data)
				} else {
					latestSaveSlot = nil
				}
			} else {
				latestSaveSlot = nil
			}
		}
	}

	func save() {
		guard let saveSlot = latestSaveSlot else { return }
		let rawData = saveSlot.data
		switch saveType {
		case .decryptedSaveSlot:
			rawData.file = file
			rawData.save()
		case .gciSaveData:
			let rawFile = XGFiles.nameAndFolder(file.fileName + ".raw", file.folder)
			rawData.file = rawFile
			rawData.save()

			if rawFile.exists {
				GoDShellManager.run(.gcitool, args: "replace_all_slots --input_slot \(rawFile.path.escapedPath) --output_gci \(file.path.escapedPath)")
			}
		}
	}
}

class XGSave {

	enum XGSavePokemonSlot {
		case party(index: Int)
		case pc(box: Int, index: Int)
		case battleMode(partyIndex: Int, index: Int)

		var offset: Int {
			switch self {
			case .party(let index):
				return kSaveFilePartyPokemonStartOffset + (index * kSaveFilePokemonSize)
			case .pc(let box, let index):
				let boxOffset = ((kSaveFilePokemonSize * kNumberOfPokemonPerPCBox) + kSizeOfBoxHeader) * box + kSaveFilePCBoxesStartOffset
				let pokemonOffset = (index * kSaveFilePokemonSize) + kSizeOfBoxHeader
				return boxOffset + pokemonOffset
			case .battleMode(let partyIndex, let index):
				let registeredOffset = kSaveFileRegisteredPokemonStartOffset + (kSizeOfRegisteredPartyData * partyIndex)
				let pokemonOffset = (index * kSaveFilePokemonSize) + kSizeOfRegisteredPartyHeader
				return registeredOffset + pokemonOffset
			}
		}
	}

	let data: XGMutableData

	var playerName: XGString {
		get {
			return data.readString(at: kSaveFilePlayerNameOffset, length: kMaxNameLength)
		}
		set {
			data.writeString(newValue, at: kSaveFilePlayerNameOffset)
		}
	}

	var playerSID: Int {
		get { return data.get2BytesAtOffset(kSaveFilePlayerSIDOffset) }
		set { data.replace2BytesAtOffset(kSaveFilePlayerSIDOffset, withBytes: newValue) }
	}
	var playerTID: Int {
		get { return data.get2BytesAtOffset(kSaveFilePlayerTIDOffset) }
		set { data.replace2BytesAtOffset(kSaveFilePlayerTIDOffset, withBytes: newValue) }
	}

	init(decryptedSaveSlot: XGMutableData) {
		data = decryptedSaveSlot
	}

	#if GAME_COLO
	func readPokemon(slot: XGSavePokemonSlot) -> XGSavePokemon {
		readPokemonAtOffset(slot.offset)
	}

	func writePokemon(_ pokemon: XGSavePokemon, to slot: XGSavePokemonSlot) {
		writePokemon(pokemon, at: slot.offset)
	}

	func readPokemonAtOffset(_ offset: Int) -> XGSavePokemon {
		return XGSavePokemon(data: .init(byteStream: data.getCharStreamFromOffset(offset, length: kSaveFilePokemonSize)))
	}

	func writePokemon(_ pokemon: XGSavePokemon, at offset: Int) {
		data.replaceBytesFromOffset(offset, withByteStream: pokemon.data.charStream)
	}
	#endif

	func partyPokemonTable() -> SaveFilePokemonStructTable {
		return SaveFilePokemonStructTable(file: data.file, storage: .party)
	}
	
	func pcBoxPokemonTables() -> [SaveFilePokemonStructTable] {
		return (0 ..< kNumberOfBoxes).map { (index) -> SaveFilePokemonStructTable in
			SaveFilePokemonStructTable(file: data.file, storage: .pcBox(index: index))
		}
	}

	func pcItemStorageTable() -> GoDStructTable {
		return GoDStructTable(file: data.file, properties: itemStorageStruct) { (_) -> Int in
			return kSaveFilePCItemsOffset
		} numberOfEntriesInFile: { (_) -> Int in
			return kSaveFileNumberOfItemsInPC
		}

	}
}

#if GAME_COLO
let kSavePokemonSpeciesOffset = 0x0
let kSavePokemonPIDOffset = 0x4
let kSavePokemonGameIDOffset = 0x8
let kSavePokemonCurrentGameRegionIDOffset = 0x9
let kSavePokemonOriginalGameRegionIDOffset = 0xa
let kSavePokemonGameLanguageIDOffset = 0xb
let kSavePokemonCaughtLocationOffset = 0xc
let kSavePokemonLevelCaughtOffset = 0xe
let kSavePokemonBallCaughtInOffset = 0xf
let kSavePokemonOTGenderOffset = 0x10
let kSavePokemonSIDOffset = 0x14
let kSavePokemonTIDOffset = 0x16
let kSavePokemonOTNameOffset = game == .Colosseum ? 0x18 : 0x0
let kSavePokemonNameOffset = game == .Colosseum ? 0x2e : 0x0
let kSavePokemonName2Offset = game == .Colosseum ? 0x44 : 0x0
let kSavePokemonEXPOffset = 0x5c
let kSavePokemonPartyDataLevelOffset = 0x60
let kSavePokemonPartyDataStatusOffset = 0x65
let kSavePokemonPartyDataBadPoisonTurnsOffset = 0x69
let kSavePokemonPartyDataRemainingSleepTurnsOffset = 0x6b
let kSavePokemonPartyDataStatusBitFieldOffset = 0x74
let kSavePokemonMove1Offset = 0x78
let kSavePokemonMove1PPOffset = 0x7a
let kSavePokemonMove2Offset = 0x7c
let kSavePokemonMove2PPOffset = 0x7e
let kSavePokemonMove3Offset = 0x80
let kSavePokemonMove3PPOffset = 0x82
let kSavePokemonMove4Offset = 0x84
let kSavePokemonMove4PPOffset = 0x86
let kSavePokemonHeldItemOffset = 0x88
let kSavePokemonCurrentHPOffset = 0x8a
let kSavePokemonMaxHPOffset = 0x8c
let kSavePokemonAttackOffset = 0x8e
let kSavePokemonDefenseOffset = 0x90
let kSavePokemonSpecialAttackOffset = 0x92
let kSavePokemonSpecialDefenseOffset = 0x94
let kSavePokemonSpeedOffset = 0x96
let kSavePokemonHPEVOffset = 0x98
let kSavePokemonAttackEVOffset = 0x9a
let kSavePokemonDefenseEVOffset = 0x9c
let kSavePokemonSpecialAttackEVOffset = 0x9e
let kSavePokemonSpecialDefenseEVOffset = 0xa0
let kSavePokemonSpeedEVOffset = 0xa2
let kSavePokemonHPIVOffset = 0xa4
let kSavePokemonAttackIVOffset = 0xa6
let kSavePokemonDefenseIVOffset = 0xa8
let kSavePokemonSpecialAttackIVOffset = 0xaa
let kSavePokemonSpecialDefenseIVOffset = 0xac
let kSavePokemonSpeedIVOffset = 0xae
let kSavePokemonHappinessOffset = 0xb0
let kSavePokemonContestStatsOffset = 0xb2
let kSavePokemonContestRanksOffset = 0xb7
let kSavePokemonContestLusterOffset = 0xbc
let kSavePokemonSpecialRibbonsOffset = 0xbd
let kSavePokemonUnusedRibbonsOffset = 0xc9
let kSavePokemonPokerusOffset = 0xca
let kSavePokemonFlagsOffset = 0xcb
let kSavePokemonUnkownGCFlagOffset = 0xce
let kSavePokemonMarksOffset = 0xcf
let kSavePokemonPokerusDaysRemainingOffset = 0xd0
let kSavePokemonUnkown1Offset = 0xd2
let kSavePokemonUnkown2Offset = 0xd4
let kSavePokemonShadowIDOffset = 0xd8
let kSavePokemonObedienceOffset = 0xf8
let kSavePokemonEncounterTypeOffset = 0xfb


class XGSavePokemon {

	let data: XGMutableData

	var species: XGPokemon {
		get {
			return .index(data.get2BytesAtOffset(kSavePokemonSpeciesOffset))
		}
		set {
			data.replace2BytesAtOffset(kSavePokemonSpeciesOffset, withBytes: newValue.index)
		}
	}

	var PID: UInt32 {
		get {
			return data.getWordAtOffset(kSavePokemonPIDOffset)
		}
		set {
			data.replaceWordAtOffset(kSavePokemonPIDOffset, withBytes: newValue)
		}
	}

	var gameID: Int {
		get {
			return data.getByteAtOffset(kSavePokemonGameIDOffset)
		}
		set {
			data.replaceByteAtOffset(kSavePokemonGameIDOffset, withByte: newValue)
		}
	}

	var currentGameRegion: Int {
		get {
			return data.getByteAtOffset(kSavePokemonCurrentGameRegionIDOffset)
		}
		set {
			data.replaceByteAtOffset(kSavePokemonCurrentGameRegionIDOffset, withByte: newValue)
		}
	}

	var originalGameRegion: Int {
		get {
			return data.getByteAtOffset(kSavePokemonOriginalGameRegionIDOffset)
		}
		set {
			data.replaceByteAtOffset(kSavePokemonOriginalGameRegionIDOffset, withByte: newValue)
		}
	}

	var gameLanguage: Int {
		get {
			return data.getByteAtOffset(kSavePokemonGameLanguageIDOffset)
		}
		set {
			data.replaceByteAtOffset(kSavePokemonGameLanguageIDOffset, withByte: newValue)
		}
	}

	var metLocation: Int {
		get {
			return data.get2BytesAtOffset(kSavePokemonCaughtLocationOffset)
		}
		set {
			data.replace2BytesAtOffset(kSavePokemonCaughtLocationOffset, withBytes: newValue)
		}
	}

	var levelMet: Int {
		get {
			return data.getByteAtOffset(kSavePokemonLevelCaughtOffset)
		}
		set {
			data.replaceByteAtOffset(kSavePokemonLevelCaughtOffset, withByte: newValue)
		}
	}

	var ballCaughtWith: XGItems {
		get {
			return .index(data.getByteAtOffset(kSavePokemonBallCaughtInOffset))
		}
		set {
			data.replaceByteAtOffset(kSavePokemonBallCaughtInOffset, withByte: newValue.index)
		}
	}

	var OTGender: XGGenders {
		get {
			return data.getByteAtOffset(kSavePokemonOTGenderOffset) == 0 ? .male : .female
		}
		set {
			data.replaceByteAtOffset(kSavePokemonOTGenderOffset, withByte: newValue.rawValue)
		}
	}

	var OTSecretID: Int {
		get {
			return data.get2BytesAtOffset(kSavePokemonSIDOffset)
		}
		set {
			data.replace2BytesAtOffset(kSavePokemonSIDOffset, withBytes: newValue)
		}
	}

	var OTTrainerID: Int {
		get {
			return data.get2BytesAtOffset(kSavePokemonTIDOffset)
		}
		set {
			data.replace2BytesAtOffset(kSavePokemonTIDOffset, withBytes: newValue)
		}
	}

	var OTName: XGString {
		get {
			return data.readString(at: kSavePokemonOTNameOffset, length: kMaxNameLength)
		}
		set {
			data.writeString(newValue, at: kSavePokemonOTNameOffset)
		}
	}

	// Need to double check if these are always the same
	var name: XGString {
		get {
			return data.readString(at: kSavePokemonNameOffset, length: kMaxNameLength)
		}
		set {
			data.writeString(newValue, at: kSavePokemonNameOffset)
		}
	}

	var name2: XGString {
		get {
			return data.readString(at: kSavePokemonName2Offset, length: kMaxNameLength)
		}
		set {
			data.writeString(newValue, at: kSavePokemonName2Offset)
		}
	}

	var experience: Int {
		get {
			return data.get4BytesAtOffset(kSavePokemonEXPOffset)
		}
		set {
			data.replace4BytesAtOffset(kSavePokemonEXPOffset, withBytes: newValue)
		}
	}

	var level: Int {
		get {
			return data.getByteAtOffset(kSavePokemonPartyDataLevelOffset)
		}
		set {
			data.replaceByteAtOffset(kSavePokemonPartyDataLevelOffset, withByte: newValue)
		}
	}

	var status: XGStatusEffects {
		get {
			return XGStatusEffects(rawValue: data.get2BytesAtOffset(kSavePokemonPartyDataStatusOffset)) ?? .none
		}
		set {
			data.replace2BytesAtOffset(kSavePokemonPartyDataStatusOffset, withBytes: newValue.rawValue)
		}
	}

	var sleepTurnsRemaining: Int {
		get {
			return data.getByteAtOffset(kSavePokemonPartyDataRemainingSleepTurnsOffset)
		}
		set {
			data.replaceByteAtOffset(kSavePokemonPartyDataRemainingSleepTurnsOffset, withByte: newValue)
		}
	}

	var badPoisoningTurns: Int {
		get {
			return data.getByteAtOffset(kSavePokemonPartyDataBadPoisonTurnsOffset)
		}
		set {
			data.replaceByteAtOffset(kSavePokemonPartyDataBadPoisonTurnsOffset, withByte: newValue)
		}
	}

	var statusBitFields: Int {
		get {
			return data.get4BytesAtOffset(kSavePokemonPartyDataStatusBitFieldOffset)
		}
		set {
			data.replace4BytesAtOffset(kSavePokemonPartyDataStatusBitFieldOffset, withBytes: newValue)
		}
	}

	var move1: XGMoves {
		get {
			return .index(data.get2BytesAtOffset(kSavePokemonMove1Offset))
		}
		set {
			data.replace2BytesAtOffset(kSavePokemonMove1Offset, withBytes: newValue.index)
		}
	}

	var move1PP: Int {
		get {
			return data.get2BytesAtOffset(kSavePokemonMove1PPOffset)
		}
		set {
			data.replace2BytesAtOffset(kSavePokemonMove1PPOffset, withBytes: newValue)
		}
	}

	var move2: XGMoves {
		get {
			return .index(data.get2BytesAtOffset(kSavePokemonMove2Offset))
		}
		set {
			data.replace2BytesAtOffset(kSavePokemonMove2Offset, withBytes: newValue.index)
		}
	}

	var move2PP: Int {
		get {
			return data.get2BytesAtOffset(kSavePokemonMove2PPOffset)
		}
		set {
			data.replace2BytesAtOffset(kSavePokemonMove2PPOffset, withBytes: newValue)
		}
	}

	var move3: XGMoves {
		get {
			return .index(data.get2BytesAtOffset(kSavePokemonMove3Offset))
		}
		set {
			data.replace2BytesAtOffset(kSavePokemonMove3Offset, withBytes: newValue.index)
		}
	}

	var move3PP: Int {
		get {
			return data.get2BytesAtOffset(kSavePokemonMove3PPOffset)
		}
		set {
			data.replace2BytesAtOffset(kSavePokemonMove3PPOffset, withBytes: newValue)
		}
	}

	var move4: XGMoves {
		get {
			return .index(data.get2BytesAtOffset(kSavePokemonMove4Offset))
		}
		set {
			data.replace2BytesAtOffset(kSavePokemonMove4Offset, withBytes: newValue.index)
		}
	}

	var move4PP: Int {
		get {
			return data.get2BytesAtOffset(kSavePokemonMove4PPOffset)
		}
		set {
			data.replace2BytesAtOffset(kSavePokemonMove4PPOffset, withBytes: newValue)
		}
	}

	var heldItem: XGItems {
		get {
			return .index(data.get2BytesAtOffset(kSavePokemonHeldItemOffset))
		}
		set {
			data.replace2BytesAtOffset(kSavePokemonHeldItemOffset, withBytes: newValue.index)
		}
	}

	var currentHP: Int {
		get {
			return data.get2BytesAtOffset(kSavePokemonCurrentHPOffset)
		}
		set {
			data.replace2BytesAtOffset(kSavePokemonCurrentHPOffset, withBytes: newValue)
		}
	}

	var maxHP: Int {
		get {
			return data.get2BytesAtOffset(kSavePokemonMaxHPOffset)
		}
		set {
			data.replace2BytesAtOffset(kSavePokemonMaxHPOffset, withBytes: newValue)
		}
	}

	var attack: Int {
		get {
			return data.get2BytesAtOffset(kSavePokemonAttackOffset)
		}
		set {
			data.replace2BytesAtOffset(kSavePokemonAttackOffset, withBytes: newValue)
		}
	}

	var defense: Int {
		get {
			return data.get2BytesAtOffset(kSavePokemonDefenseOffset)
		}
		set {
			data.replace2BytesAtOffset(kSavePokemonDefenseOffset, withBytes: newValue)
		}
	}

	var specialAttack: Int {
		get {
			return data.get2BytesAtOffset(kSavePokemonSpecialAttackOffset)
		}
		set {
			data.replace2BytesAtOffset(kSavePokemonSpecialAttackOffset, withBytes: newValue)
		}
	}

	var specialDefense: Int {
		get {
			return data.get2BytesAtOffset(kSavePokemonSpecialDefenseOffset)
		}
		set {
			data.replace2BytesAtOffset(kSavePokemonSpecialDefenseOffset, withBytes: newValue)
		}
	}

	var speed: Int {
		get {
			return data.get2BytesAtOffset(kSavePokemonSpeedOffset)
		}
		set {
			data.replace2BytesAtOffset(kSavePokemonSpeedOffset, withBytes: newValue)
		}
	}

	var HPEVs: Int {
		get {
			return data.get2BytesAtOffset(kSavePokemonHPEVOffset)
		}
		set {
			data.replace2BytesAtOffset(kSavePokemonHPEVOffset, withBytes: newValue)
		}
	}

	var attackEVs: Int {
		get {
			return data.get2BytesAtOffset(kSavePokemonAttackEVOffset)
		}
		set {
			data.replace2BytesAtOffset(kSavePokemonAttackEVOffset, withBytes: newValue)
		}
	}

	var defenseEVs: Int {
		get {
			return data.get2BytesAtOffset(kSavePokemonDefenseEVOffset)
		}
		set {
			data.replace2BytesAtOffset(kSavePokemonDefenseEVOffset, withBytes: newValue)
		}
	}

	var specialAttackEVs: Int {
		get {
			return data.get2BytesAtOffset(kSavePokemonSpecialAttackEVOffset)
		}
		set {
			data.replace2BytesAtOffset(kSavePokemonSpecialAttackEVOffset, withBytes: newValue)
		}
	}

	var specialDefenseEVs: Int {
		get {
			return data.get2BytesAtOffset(kSavePokemonSpecialDefenseEVOffset)
		}
		set {
			data.replace2BytesAtOffset(kSavePokemonSpecialDefenseEVOffset, withBytes: newValue)
		}
	}

	var speedEVs: Int {
		get {
			return data.get2BytesAtOffset(kSavePokemonSpeedEVOffset)
		}
		set {
			data.replace2BytesAtOffset(kSavePokemonSpeedEVOffset, withBytes: newValue)
		}
	}

	var HPIVs: Int {
		get {
			return data.get2BytesAtOffset(kSavePokemonHPIVOffset)
		}
		set {
			data.replace2BytesAtOffset(kSavePokemonHPIVOffset, withBytes: newValue)
		}
	}

	var attackIVs: Int {
		get {
			return data.get2BytesAtOffset(kSavePokemonAttackIVOffset)
		}
		set {
			data.replace2BytesAtOffset(kSavePokemonAttackIVOffset, withBytes: newValue)
		}
	}

	var defenseIVs: Int {
		get {
			return data.get2BytesAtOffset(kSavePokemonDefenseIVOffset)
		}
		set {
			data.replace2BytesAtOffset(kSavePokemonDefenseIVOffset, withBytes: newValue)
		}
	}

	var specialAttackIVs: Int {
		get {
			return data.get2BytesAtOffset(kSavePokemonSpecialAttackIVOffset)
		}
		set {
			data.replace2BytesAtOffset(kSavePokemonSpecialAttackIVOffset, withBytes: newValue)
		}
	}

	var specialDefenseIVs: Int {
		get {
			return data.get2BytesAtOffset(kSavePokemonSpecialDefenseIVOffset)
		}
		set {
			data.replace2BytesAtOffset(kSavePokemonSpecialDefenseIVOffset, withBytes: newValue)
		}
	}

	var speedIVs: Int {
		get {
			return data.get2BytesAtOffset(kSavePokemonSpeedIVOffset)
		}
		set {
			data.replace2BytesAtOffset(kSavePokemonSpeedIVOffset, withBytes: newValue)
		}
	}

	var happiness: Int {
		get {
			return data.get2BytesAtOffset(kSavePokemonHappinessOffset)
		}
		set {
			data.replace2BytesAtOffset(kSavePokemonHappinessOffset, withBytes: newValue)
		}
	}

	var contestStats: [Int] {
		get {
			return data.getByteStreamFromOffset(kSavePokemonContestStatsOffset, length: 5)
		}
		set {
			data.replaceBytesFromOffset(kSavePokemonContestStatsOffset, withByteStream: newValue)
		}
	}

	var contestRanks: [Int] {
		get {
			return data.getByteStreamFromOffset(kSavePokemonContestRanksOffset, length: 5)
		}
		set {
			data.replaceBytesFromOffset(kSavePokemonContestRanksOffset, withByteStream: newValue)
		}
	}

	var contestLuster: Int {
		get {
			return data.getByteAtOffset(kSavePokemonContestLusterOffset)
		}
		set {
			data.replaceByteAtOffset(kSavePokemonContestLusterOffset, withByte: newValue)
		}
	}

	var specialRibbons: Int {
		get {
			return data.getByteAtOffset(kSavePokemonSpecialRibbonsOffset)
		}
		set {
			data.replaceByteAtOffset(kSavePokemonSpecialRibbonsOffset, withByte: newValue)
		}
	}

	var unusedRibbons: Int {
		get {
			return data.getByteAtOffset(kSavePokemonUnusedRibbonsOffset)
		}
		set {
			data.replaceByteAtOffset(kSavePokemonUnusedRibbonsOffset, withByte: newValue)
		}
	}

	var pokerusStatus: Int {
		get {
			return data.getByteAtOffset(kSavePokemonPokerusOffset)
		}
		set {
			data.replaceByteAtOffset(kSavePokemonPokerusOffset, withByte: newValue)
		}
	}

	var flags: [Int] {
		get {
			return data.getByteStreamFromOffset(kSavePokemonFlagsOffset, length: 3)
		}
		set {
			data.replaceBytesFromOffset(kSavePokemonFlagsOffset, withByteStream: newValue)
		}
	}

	var GCUnknown: Int {
		get {
			return data.getByteAtOffset(kSavePokemonUnkownGCFlagOffset)
		}
		set {
			data.replaceByteAtOffset(kSavePokemonUnkownGCFlagOffset, withByte: newValue)
		}
	}

	var markings: Int {
		get {
			return data.getByteAtOffset(kSavePokemonMarksOffset)
		}
		set {
			data.replaceByteAtOffset(kSavePokemonMarksOffset, withByte: newValue)
		}
	}

	var pokerusDaysRemaining: Int {
		get {
			return data.getByteAtOffset(kSavePokemonPokerusDaysRemainingOffset)
		}
		set {
			data.replaceByteAtOffset(kSavePokemonPokerusDaysRemainingOffset, withByte: newValue)
		}
	}

	var unknown1: Int {
		get {
			return data.get2BytesAtOffset(kSavePokemonUnkown1Offset)
		}
		set {
			data.replace2BytesAtOffset(kSavePokemonUnkown1Offset, withBytes: newValue)
		}
	}

	var unknown2: Int {
		get {
			return data.get2BytesAtOffset(kSavePokemonUnkown2Offset)
		}
		set {
			data.replace2BytesAtOffset(kSavePokemonUnkown2Offset, withBytes: newValue)
		}
	}

	var shadowID: Int {
		get {
			return data.get2BytesAtOffset(kSavePokemonShadowIDOffset)
		}
		set {
			data.replace2BytesAtOffset(kSavePokemonShadowIDOffset, withBytes: newValue)
		}
	}

	var obedience: Int {
		get {
			return data.getByteAtOffset(kSavePokemonObedienceOffset)
		}
		set {
			data.replaceByteAtOffset(kSavePokemonObedienceOffset, withByte: newValue)
		}
	}

	var encounterType: Int {
		get {
			return data.getByteAtOffset(kSavePokemonEncounterTypeOffset)
		}
		set {
			data.replaceByteAtOffset(kSavePokemonEncounterTypeOffset, withByte: newValue)
		}
	}

	init(data: XGMutableData) {
		self.data = data
	}

	func copyFrom(_ from: XGSavePokemon) {
		species = from.species
		PID = from.PID
		gameID = from.gameID
		currentGameRegion = from.currentGameRegion
		originalGameRegion = from.originalGameRegion
		gameLanguage = from.gameLanguage
		metLocation = from.metLocation
		levelMet = from.levelMet
		ballCaughtWith = from.ballCaughtWith
		OTGender = from.OTGender
		OTSecretID = from.OTSecretID
		OTTrainerID = from.OTTrainerID
		OTName = from.OTName
		name = from.name
		name2 = from.name2
		experience = from.experience
		level = from.level
		sleepTurnsRemaining = from.sleepTurnsRemaining
		badPoisoningTurns = from.badPoisoningTurns
		status = from.status
		statusBitFields = from.statusBitFields
		move1 = from.move1
		move1PP = from.move1PP
		move2 = from.move2
		move2PP = from.move2PP
		move3 = from.move3
		move3PP = from.move3PP
		move4 = from.move4
		move4PP = from.move4PP
		heldItem = from.heldItem
		currentHP = from.currentHP
		maxHP = from.maxHP
		attack = from.attack
		defense = from.defense
		specialAttack = from.specialAttack
		specialDefense = from.specialDefense
		speed = from.speed
		HPEVs = from.HPEVs
		attackEVs = from.attackEVs
		defenseEVs = from.defenseEVs
		specialAttackEVs = from.specialAttackEVs
		specialDefenseEVs = from.specialDefenseEVs
		speedEVs = from.speedEVs
		HPIVs = from.HPIVs
		attackIVs = from.attackIVs
		defenseIVs = from.defenseIVs
		specialAttackIVs = from.specialAttackIVs
		specialDefenseIVs = from.specialDefenseIVs
		speedIVs = from.speedIVs
		happiness = from.happiness
		contestStats = from.contestStats
		contestRanks = from.contestRanks
		contestLuster = from.contestLuster
		specialRibbons = from.specialRibbons
		unusedRibbons = from.unusedRibbons
		pokerusStatus = from.pokerusStatus
		flags = from.flags
		GCUnknown = from.GCUnknown
		markings = from.markings
		pokerusDaysRemaining = from.pokerusDaysRemaining
		unknown1 = from.unknown1
		unknown2 = from.unknown2
		shadowID = from.shadowID
		obedience = from.obedience
		encounterType = from.encounterType
	}
}

#endif
