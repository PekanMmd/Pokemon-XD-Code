//
//  XDBattlePokemon.swift
//  GoD Tool
//
//  Created by Stars Momodu on 07/10/2021.
//

import Foundation

let kBattlePokemonSpeciesOffset = 4
let kBattlePokemonItemOffset = 6
let kBattlePokemonCurrentHPOffset = 8
let kBattlePokemonHappinessOffset = 10
let kBattlePokemonLevelCaughtOffset = 18
let kBattlePokemonPokeballOffset = 19
let kBattlePokemonLevelOffset = 20
let kBattlePokemonSIDOffset = 40
let kBattlePokemonTIDOffset = 42
let kBattlePokemonPIDOffset = 44
let kBattlePokemonOTNameOffset = 60
let kBattlePokemonNicknameOffset = 82
let kBattlePokemonNameOffset = 104
let kBattlePokemonRibbonsOffset = 128
let kBattlePokemonMove1Offset = 132
let kBattlePokemonMove1PPOffset = 134
let kBattlePokemonMove2Offset = 136
let kBattlePokemonMove2PPOffset = 138
let kBattlePokemonMove3Offset = 140
let kBattlePokemonMove3PPOffset = 142
let kBattlePokemonMove4Offset = 144
let kBattlePokemonMove4PPOffset = 146
let kBattlePokemonHPOffset = 148
let kBattlePokemonATKOffset = 150
let kBattlePokemonDEFOffset = 152
let kBattlePokemonSPAOffset = 154
let kBattlePokemonSPDOffset = 156
let kBattlePokemonSPEOffset = 158
let kBattlePokemonEVHPOffset = 160
let kBattlePokemonEVATKOffset = 162
let kBattlePokemonEVDEFOffset = 164
let kBattlePokemonEVSPAOffset = 166
let kBattlePokemonEVSPDOffset = 168
let kBattlePokemonEVSPEOffset = 170
let kBattlePokemonIVHPOffset = 172
let kBattlePokemonIVATKOffset = 173
let kBattlePokemonIVDEFOffset = 174
let kBattlePokemonIVSPAOffset = 175
let kBattlePokemonIVSPDOffset = 176
let kBattlePokemonIVSPEOffset = 177

let kTrainerDeckIDOffset = 0
let kTrainerName1Offset = 4
let kTrainerName2Offset = 26
let kTrainerFirstPartyPokemonOffset = 48
let kSizeOfPartyPokemonData = 0xc4

class XDTrainer: Codable {
	var name: String?
	var deckID: Int?
	var party: [XDBattlePokemon?]

	init(offset: Int, process: XDProcess) {
		name = process.readString(RAMOffset: offset + kTrainerName1Offset, maxCharacters: 10)
		deckID = process.read4Bytes(atAddress: offset + kTrainerDeckIDOffset)
		var mons = [XDBattlePokemon?]()
		for i in 0 ..< 6 {
			let pokemonOffset = offset + kTrainerFirstPartyPokemonOffset + (i * kSizeOfPartyPokemonData)
			mons.append(XDBattlePokemon(offset: pokemonOffset, process: process))
		}
		party = mons
	}

	func write(offset: Int, process: XDProcess) {
		if let name = name {
			process.writeString(name, atAddress: offset + kTrainerName1Offset)
			process.writeString(name, atAddress: offset + kTrainerName2Offset)
		}
		if let deckID = deckID {
			process.write(deckID, atAddress: offset + kTrainerDeckIDOffset)
		}
		for i in 0 ..< 6 {
			let pokemonOffset = offset + kTrainerFirstPartyPokemonOffset + (i * kSizeOfPartyPokemonData)
			party[i]?.write(offset: pokemonOffset, process: process)
		}
	}
}

class XDBattlePokemon: Codable {
	var species: XGPokemon = .index(0)

	convenience init?(pointerOffset: Int, process: XDProcess) {
		guard let offset = process.read4Bytes(atAddress: pointerOffset) else {
			return nil
		}
		self.init(offset: offset, process: process)
	}

	init?(offset: Int, process: XDProcess) {
		guard let speciesIndex = process.read2Bytes(atAddress: offset + kBattlePokemonSpeciesOffset) else {
			return nil
		}
		if speciesIndex == 0 {
			return nil
		}
		species = .index(speciesIndex)
	}

	func write(pointerOffset: Int, process: XDProcess) {
		guard let offset = process.read4Bytes(atAddress: pointerOffset) else { return }
		write(offset: offset, process: process)
	}

	func write(offset: Int, process: XDProcess) {
		process.write16(species.index, atAddress: offset + kBattlePokemonSpeciesOffset)
	}
}
