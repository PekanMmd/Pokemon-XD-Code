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

	init(file: GoDReadable, offset: Int) {
		self.offset = offset

		shadowID = file.read2Bytes(atAddress: offset + kStoredShadowPokemonShadowIDOffset) ?? 0
		heartGauage = file.read4Bytes(atAddress: offset + kStoredShadowPokemonHeartGaugeOffset) ?? 0
		species = .index(file.read2Bytes(atAddress: offset + kStoredShadowPokemonSpeciesOffset) ?? 0)
		accumulatedExp = file.read4Bytes(atAddress: offset + kStoredShadowPokemonExpOffset) ?? 0
		accumulatedHappiness = file.read2Bytes(atAddress: offset + kStoredShadowPokemonHappinessOffset) ?? 0
		stepCounter = file.read4Bytes(atAddress: offset + kStoredShadowPokemonStepCounterOffset) ?? 0
		aggression = XGShadowAggression(rawValue:  file.readByte(atAddress: offset + kStoredShadowPokemonAggressionOffset) ?? 0) ?? .none
		let flags = (file.readByte(atAddress: offset + kStoredShadowPokemonFlagsOffset) ?? 0).bitArray(count: 8)
		hasBeenEncountered = flags[5]
		hasBeenCaught = flags[6]
		hasBeenPurified = flags[7]


	}

	func write(file: GoDWritable) {
		file.write16(shadowID, atAddress: offset + kStoredShadowPokemonShadowIDOffset)
		file.write(heartGauage, atAddress: offset + kStoredShadowPokemonHeartGaugeOffset)
		file.write16(species.index, atAddress: offset + kStoredShadowPokemonSpeciesOffset)
		file.write(accumulatedExp, atAddress: offset + kStoredShadowPokemonExpOffset)
		file.write16(accumulatedHappiness, atAddress: offset + kStoredShadowPokemonHappinessOffset)
		file.write(stepCounter, atAddress: offset + kStoredShadowPokemonStepCounterOffset)
		file.write8(aggression.rawValue, atAddress: offset + kStoredShadowPokemonAggressionOffset)
		let flags = [Bool](repeating: false, count: 5) + [hasBeenEncountered, hasBeenCaught, hasBeenPurified]
		file.write(flags.binaryBitsToInt(), atAddress: offset + kStoredShadowPokemonFlagsOffset)
	}

}
