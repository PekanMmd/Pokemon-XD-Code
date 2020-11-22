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
let kNumberOfRegisteredParties = game == .Colosseum ? 2 : 0 // confirm actual number

let kSizeOfBoxHeader = 0x10
let kSizeOfRegisteredPartyHeader = 0x30
let kMaxNameLength = 10
let kSaveFilePokemonSize = game == .Colosseum ? 0x138 : 0x0
let kSizeOfRegisteredPartData = game == .Colosseum ? 0xb18 : 0x0

let kSaveFilePlayerNameOffset = game == .Colosseum ? 0x78 : -1
let kSaveFilePartyPokemonStartOffset = game == .Colosseum ? 0xa8 : -1
let kSaveFilePCPokemonStartOffset = game == .Colosseum ? 0xb94 : -1
let kSaveFileRegisteredPokemonStartOffset = game == .Colosseum ? 0x19744 : -1

class XGSaveManager {

	enum SaveType {
		// TODO: maybe add support for gcis and such
		// for now requires a single save slot obtained through other means
		case decryptedSaveSlot(data: XGMutableData)
	}

	let saveType: SaveType
	let saveSlots: [XGSave]

	init(saveType: SaveType) {
		self.saveType = saveType
		switch saveType {
		case .decryptedSaveSlot(let data): saveSlots = [XGSave(decryptedSaveSlot: data)]
		}
	}

	func save() {
		switch saveType {
		case .decryptedSaveSlot(let data):
			data.save()
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
				let boxOffset = ((kSaveFilePokemonSize * kNumberOfPokemonPerPCBox) + kSizeOfBoxHeader) * box + kSaveFilePCPokemonStartOffset
				let pokemonOffset = (index * kSaveFilePokemonSize) + kSizeOfBoxHeader
				return boxOffset + pokemonOffset
			case .battleMode(let partyIndex, let index):
				let registeredOffset = kSaveFileRegisteredPokemonStartOffset + (kSizeOfRegisteredPartData * partyIndex)
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

	init(decryptedSaveSlot: XGMutableData) {
		data = decryptedSaveSlot
	}

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
}

let kSavePokemonSpeciesOffset = 0x0
let kSavePokemonIDOffset = 0x4
let kSavePokemonCaughtLocationOffset = 0xc
let kSavePokemonBallCaughtInOffset = 0xf
let kSavePokemonGenderOffset = 0x10
let kSavePokemonSIDOffset = 0x14
let kSavePokemonTIDOffset = 0x16
let kSavePokemonOTNameOffset = game == .Colosseum ? 0x18 : 0x0
let kSavePokemonNameOffset = game == .Colosseum ? 0x2e : 0x0
let kSavePokemonNicknameOffset = game == .Colosseum ? 0x44 : 0x0
let kSavePokemonEXPOffset = 0x5c
let kSavePokemonPartyDataLevelOffset = 0x60
let kSavePokemonPartDataRemainingSleepTurnsOffset = 0x65
let kSavePokemonPartDataBadPoisonTurnsOffset = 0x69
let kSavePokemonPartDataStatusOffset = 0x6b
let kSavePokemonPartDataStatusBitFieldOffset = 0x74
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

	var OTName: XGString {
		get {
			return data.readString(at: kSavePokemonOTNameOffset, length: kMaxNameLength)
		}
		set {
			data.writeString(newValue, at: kSavePokemonOTNameOffset)
		}
	}

	// Nickname and species name offset could be other way around, must confirm
	var name: XGString {
		get {
			return data.readString(at: kSavePokemonNameOffset, length: kMaxNameLength)
		}
		set {
			data.writeString(newValue, at: kSavePokemonNameOffset)
		}
	}

	var nickName: XGString {
		get {
			return data.readString(at: kSavePokemonNicknameOffset, length: kMaxNameLength)
		}
		set {
			data.writeString(newValue, at: kSavePokemonNicknameOffset)
		}
	}

	var species: XGPokemon {
		get {
			return .pokemon(data.get2BytesAtOffset(kSavePokemonSpeciesOffset))
		}
		set {
			data.replace2BytesAtOffset(kSavePokemonSpeciesOffset, withBytes: newValue.index)
		}
	}

	var move1: XGMoves {
		get {
			return .move(data.get2BytesAtOffset(kSavePokemonMove1Offset))
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
			return .move(data.get2BytesAtOffset(kSavePokemonMove2Offset))
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
			return .move(data.get2BytesAtOffset(kSavePokemonMove3Offset))
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
			return .move(data.get2BytesAtOffset(kSavePokemonMove4Offset))
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

	init(data: XGMutableData) {
		self.data = data
	}
}
