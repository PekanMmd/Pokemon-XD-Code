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
let kSaveFilePartyPokemonStartOffset = game == .Colosseum ? 0xa4 : -1
let kSaveFilePCPokemonStartOffset = game == .Colosseum ? 0xb90 : -1
let kSaveFileRegisteredPokemonStartOffset = game == .Colosseum ? 0x19740 : -1

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

let kSavePokemonSpeciesOffset = 0x4
let kSavePokemonOTNameOffset = game == .Colosseum ? 0x1c : 0x0
let kSavePokemonNameOffset = game == .Colosseum ? 0x32 : 0x0
let kSavePokemonNicknameOffset = game == .Colosseum ? 0x48 : 0x0
let kSavePokemonMove1Offset = 0x7c
let kSavePokemonMove1PPOffset = 0x7e
let kSavePokemonMove2Offset = 0x80
let kSavePokemonMove2PPOffset = 0x82
let kSavePokemonMove3Offset = 0x84
let kSavePokemonMove3PPOffset = 0x86
let kSavePokemonMove4Offset = 0x88
let kSavePokemonMove4PPOffset = 0x8a

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
