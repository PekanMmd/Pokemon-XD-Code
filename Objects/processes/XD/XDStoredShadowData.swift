//
//  XDStoredShadowData.swift
//  GoD Tool
//
//  Created by Stars Momodu on 11/10/2021.
//

import Foundation

let kSizeOfStoredShadowData = 72

let kStoredShadowPokemonFlagsOffset = 0
let kStoredShadowPokemonExpOffset = 4

let kStoredShadowPokemonHappinessOffset = 24
let kStoredShadowPokemonSpeciesOffset = 26

let kStoredShadowPokemonStepCounterOffset = 32
let kStoredShadowPokemonHeartGaugeOffset = 36

let kStoredShadowPokemonShadowIDOffset = 62
let kStoredShadowPokemonAggressionOffset = 64


class XDStoredShadowData: Codable {
	var offset = 0

	var shadowID = 0
	var heartGauage = 0
	var species: XGPokemon = .index(0)
	var accumulatedExp = 0
	var accumulatedHappiness = 0
	var stepCounter = 0
	var aggression = XGShadowAggression.none
	var hasBeenEncountered: Bool = false
	var hasBeenCaught: Bool = false
	var hasBeenPurified: Bool = false

	var deckData: XGDeckPokemon {
		return .ddpk(shadowID)
	}

	convenience init?(process: XDProcess, index: Int) {
		guard let trainerDataOrigin = process.readPointerRelativeToR13(offset: -0x4728) else { return nil }
		let shadowDataOffset = trainerDataOrigin + 0xE380
		self.init(process: process, offset: shadowDataOffset + (index * kSizeOfStoredShadowData))
	}

	init(process: XDProcess, offset: Int) {
		self.offset = offset

		shadowID = process.read2Bytes(atAddress: offset + kStoredShadowPokemonShadowIDOffset) ?? 0
		heartGauage = process.read4Bytes(atAddress: offset + kStoredShadowPokemonHeartGaugeOffset) ?? 0
		species = .index(process.read2Bytes(atAddress: offset + kStoredShadowPokemonSpeciesOffset) ?? 0)
		accumulatedExp = process.read4Bytes(atAddress: offset + kStoredShadowPokemonExpOffset) ?? 0
		accumulatedHappiness = process.read2Bytes(atAddress: offset + kStoredShadowPokemonHappinessOffset) ?? 0
		stepCounter = process.read4Bytes(atAddress: offset + kStoredShadowPokemonStepCounterOffset) ?? 0
		aggression = XGShadowAggression(rawValue:  process.readByte(atAddress: offset + kStoredShadowPokemonAggressionOffset) ?? 0) ?? .none
		let flags = (process.readByte(atAddress: offset + kStoredShadowPokemonFlagsOffset) ?? 0).bitArray(count: 8)
		hasBeenEncountered = flags[5]
		hasBeenCaught = flags[6]
		hasBeenPurified = flags[7]


	}

	func write(process: XDProcess) {
		process.write16(shadowID, atAddress: offset + kStoredShadowPokemonShadowIDOffset)
		process.write(heartGauage, atAddress: offset + kStoredShadowPokemonHeartGaugeOffset)
		process.write16(species.index, atAddress: offset + kStoredShadowPokemonSpeciesOffset)
		process.write(accumulatedExp, atAddress: offset + kStoredShadowPokemonExpOffset)
		process.write16(accumulatedHappiness, atAddress: offset + kStoredShadowPokemonHappinessOffset)
		process.write(stepCounter, atAddress: offset + kStoredShadowPokemonStepCounterOffset)
		process.write8(aggression.rawValue, atAddress: offset + kStoredShadowPokemonAggressionOffset)
		let flags = [Bool](repeating: false, count: 5) + [hasBeenEncountered, hasBeenCaught, hasBeenPurified]
		process.write(flags.binaryBitsToInt(), atAddress: offset + kStoredShadowPokemonFlagsOffset)
	}

}
