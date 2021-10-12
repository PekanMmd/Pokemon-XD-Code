//
//  XDBattlePokemon.swift
//  GoD Tool
//
//  Created by Stars Momodu on 07/10/2021.
//

import Foundation

let kPartyPokemonSpeciesOffset = 0
let kPartyPokemonItemOffset = 2
let kPartyPokemonCurrentHPOffset = 4
let kPartyPokemonHappinessOffset = 6
let kPartyPokemonLevelCaughtOffset = 14
let kPartyPokemonPokeballOffset = 15
let kPartyPokemonLevelOffset = 17
let kPartyPokemonAbilityIndexOffset = 29
let kPartyPokemonTotalExpOffset = 32
let kPartyPokemonSIDOffset = 36
let kPartyPokemonTIDOffset = 38
let kPartyPokemonPIDOffset = 40
let kPartyPokemonOTNameOffset = 56
let kPartyPokemonNicknameOffset = 78
let kPartyPokemonNameOffset = 100
let kPartyPokemonRibbonsOffset = 124
let kPartyPokemonMove1Offset = 128
let kPartyPokemonMove1PPOffset = 130
let kPartyPokemonMove2Offset = 132
let kPartyPokemonMove2PPOffset = 134
let kPartyPokemonMove3Offset = 136
let kPartyPokemonMove3PPOffset = 138
let kPartyPokemonMove4Offset = 140
let kPartyPokemonMove4PPOffset = 142
let kPartyPokemonHPOffset = 144
let kPartyPokemonATKOffset = 146
let kPartyPokemonDEFOffset = 148
let kPartyPokemonSPAOffset = 150
let kPartyPokemonSPDOffset = 152
let kPartyPokemonSPEOffset = 154
let kPartyPokemonEVHPOffset = 156
let kPartyPokemonEVATKOffset = 158
let kPartyPokemonEVDEFOffset = 160
let kPartyPokemonEVSPAOffset = 162
let kPartyPokemonEVSPDOffset = 164
let kPartyPokemonEVSPEOffset = 166
let kPartyPokemonIVHPOffset = 168
let kPartyPokemonIVATKOffset = 169
let kPartyPokemonIVDEFOffset = 170
let kPartyPokemonIVSPAOffset = 171
let kPartyPokemonIVSPDOffset = 172
let kPartyPokemonIVSPEOffset = 173
let kPartyPokemonShadowIDOffset = 187

let kBattlePokemonCurrentType1Offset = 0x808
let kBattlePokemonCurrentType2Offset = 0x80a
let kBattlePokemonCurrentAbilityOffset = 0x80c

let kBattlePokemonCurrentATKStagesOffset = 0x7b0
let kBattlePokemonCurrentDEFStagesOffset = 0x7b1
let kBattlePokemonCurrentSPAStagesOffset = 0x7b2
let kBattlePokemonCurrentSPDStagesOffset = 0x7b3
let kBattlePokemonCurrentSPEStagesOffset = 0x7b4
let kBattlePokemonCurrentACCStagesOffset = 0x7b5
let kBattlePokemonCurrentEVAStagesOffset = 0x7b6

let kTrainerDeckIDOffset = 0
let kTrainerName1Offset = 4
let kTrainerName2Offset = 26
let kTrainerFirstPartyPokemonOffset = 48
let kSizeOfPartyPokemonData = 0xc4

class XDTrainer: Codable {
	var offset = 0

	var name: String?
	var deckID: Int?
	var partyPokemon: [XDPartyPokemon?]

	init(process: XDProcess, offset: Int) {
		self.offset = offset

		name = process.readString(RAMOffset: offset + kTrainerName1Offset, maxCharacters: 10)
		deckID = process.read4Bytes(atAddress: offset + kTrainerDeckIDOffset)
		var mons = [XDPartyPokemon?]()
		for i in 0 ..< 6 {
			let pokemonOffset = offset + kTrainerFirstPartyPokemonOffset + (i * kSizeOfPartyPokemonData)
			mons.append(XDPartyPokemon(process: process, offset: pokemonOffset))
		}
		partyPokemon = mons
	}

	func write(process: XDProcess) {
		guard offset > 0 else { return }

		if let name = name {
			process.writeString(name, atAddress: offset + kTrainerName1Offset)
			process.writeString(name, atAddress: offset + kTrainerName2Offset)
		}
		if let deckID = deckID {
			process.write(deckID, atAddress: offset + kTrainerDeckIDOffset)
		}
		for i in 0 ..< 6 {
			partyPokemon[i]?.write(process: process)
		}
	}
}

class XDBattlePokemon: XDPartyPokemon {
	var battleDataOffset = 0
	var currentAbility: XGAbilities = .index(0)
	var currentType1: XGMoveTypes = .index(0)
	var currentType2: XGMoveTypes = .index(0)

	var attackModifer: XGStatStages = .neutral
	var defenseModifer: XGStatStages = .neutral
	var specialAttackModifer: XGStatStages = .neutral
	var specialDefenseModifer: XGStatStages = .neutral
	var speedModifer: XGStatStages = .neutral
	var accuracyModifer: XGStatStages = .neutral
	var evasionModifer: XGStatStages = .neutral

	var battleStateOffset: Int {
		return battleDataOffset + 1608
	}

	override init(process: XDProcess, offset: Int) {
		let partyDataOffset = process.read4Bytes(atAddress: offset) ?? 0
		super.init(process: process, offset: partyDataOffset + 4)
		if offset > 0 {
			battleDataOffset = offset
			currentAbility = .index(process.read2Bytes(atAddress: offset + kBattlePokemonCurrentAbilityOffset) ?? 0)
			currentType1 = .index(process.read2Bytes(atAddress: offset + kBattlePokemonCurrentType1Offset) ?? 0)
			currentType2 = .index(process.read2Bytes(atAddress: offset + kBattlePokemonCurrentType2Offset) ?? 0)

			attackModifer = XGStatStages(rawValue: process.readByte(atAddress: offset + kBattlePokemonCurrentATKStagesOffset) ?? 6) ?? .neutral
			defenseModifer = XGStatStages(rawValue: process.readByte(atAddress: offset + kBattlePokemonCurrentDEFStagesOffset) ?? 6) ?? .neutral
			specialAttackModifer = XGStatStages(rawValue: process.readByte(atAddress: offset + kBattlePokemonCurrentSPAStagesOffset) ?? 6) ?? .neutral
			specialDefenseModifer = XGStatStages(rawValue: process.readByte(atAddress: offset + kBattlePokemonCurrentSPDStagesOffset) ?? 6) ?? .neutral
			speedModifer = XGStatStages(rawValue: process.readByte(atAddress: offset + kBattlePokemonCurrentSPEStagesOffset) ?? 6) ?? .neutral
			accuracyModifer = XGStatStages(rawValue: process.readByte(atAddress: offset + kBattlePokemonCurrentACCStagesOffset) ?? 6) ?? .neutral
			evasionModifer = XGStatStages(rawValue: process.readByte(atAddress: offset + kBattlePokemonCurrentEVAStagesOffset) ?? 6) ?? .neutral
		}
	}

	override func write(process: XDProcess) {
		super.write(process: process)
		if battleDataOffset > 0 {
			process.write16(currentAbility.index, atAddress: battleDataOffset + kBattlePokemonCurrentAbilityOffset)
			process.write16(currentType1.index, atAddress: battleDataOffset + kBattlePokemonCurrentType1Offset)
			process.write16(currentType2.index, atAddress: battleDataOffset + kBattlePokemonCurrentType2Offset)
			
			process.write8(attackModifer.rawValue, atAddress: battleDataOffset + kBattlePokemonCurrentATKStagesOffset)
			process.write8(defenseModifer.rawValue, atAddress: battleDataOffset + kBattlePokemonCurrentDEFStagesOffset)
			process.write8(specialAttackModifer.rawValue, atAddress: battleDataOffset + kBattlePokemonCurrentSPAStagesOffset)
			process.write8(specialDefenseModifer.rawValue, atAddress: battleDataOffset + kBattlePokemonCurrentSPDStagesOffset)
			process.write8(speedModifer.rawValue, atAddress: battleDataOffset + kBattlePokemonCurrentSPEStagesOffset)
			process.write8(accuracyModifer.rawValue, atAddress: battleDataOffset + kBattlePokemonCurrentACCStagesOffset)
			process.write8(evasionModifer.rawValue, atAddress: battleDataOffset + kBattlePokemonCurrentEVAStagesOffset)
		}
	}

	required init(from decoder: Decoder) throws {
		fatalError("init(from:) has not been implemented")
	}
}

class XDPartyPokemon: Codable {
	var species: XGPokemon = .index(0)
	var item: XGItems = .index(0)
	var abilityInBattle: XGAbilities? = nil
	var usesSecondAbility = false
	var currentHP = 0
	var happiness = 0
	var level = 0
	var levelCaughtAt = 0
	var pokeballCaughtIn: XGItems = .index(0)
	var SID = 0
	var TID = 0
	var PID = 0
	var expTotal = 0
	var OTName = ""
	var nickname = ""
	var speciesName = ""
	var ribbons: [Bool] = []
	var move1: XGMoves = .index(0)
	var move1PP = 0
	var move2: XGMoves = .index(0)
	var move2PP = 0
	var move3: XGMoves = .index(0)
	var move3PP = 0
	var move4: XGMoves = .index(0)
	var move4PP = 0
	var maxHP = 0
	var attack = 0
	var defense = 0
	var specialAttack = 0
	var specialDefense = 0
	var speed = 0
	var EVHP = 0
	var EVattack = 0
	var EVdefense = 0
	var EVspecialAttack = 0
	var EVspecialDefense = 0
	var EVspeed = 0
	var IVHP = 0
	var IVattack = 0
	var IVdefense = 0
	var IVspecialAttack = 0
	var IVspecialDefense = 0
	var IVspeed = 0
	var shadowID = 0

	var partyDataOffset = 0

	var shadowDeckData: XGDeckPokemon {
		return .ddpk(shadowID)
	}

	var nature: XGNatures {
		get {
			return XGNatures(rawValue: PID % 25) ?? .hardy
		}
		set {
			PID = (PID / 25) * 25 + newValue.rawValue
		}
	}

	var ability: XGAbilities {
		if !usesSecondAbility || species.stats.ability2.index == 0 { return species.stats.ability1 }
		return species.stats.ability2
	}

	init(process: XDProcess, offset: Int) {
		partyDataOffset = offset
		if offset > 0 {
			species = .index(process.read2Bytes(atAddress: offset + kPartyPokemonSpeciesOffset) ?? 0)
			item = .index(process.read2Bytes(atAddress: offset + kPartyPokemonItemOffset) ?? 0)
			currentHP = process.read2Bytes(atAddress: offset + kPartyPokemonCurrentHPOffset) ?? 0
			happiness = process.read2Bytes(atAddress: offset + kPartyPokemonHappinessOffset) ?? 0
			level = process.readByte(atAddress: offset + kPartyPokemonLevelOffset) ?? 0
			levelCaughtAt = process.readByte(atAddress: offset + kPartyPokemonLevelCaughtOffset) ?? 0
			pokeballCaughtIn = .index(process.readByte(atAddress: offset + kPartyPokemonPokeballOffset) ?? 0)
			SID = process.read2Bytes(atAddress: offset + kPartyPokemonSIDOffset) ?? 0
			TID = process.read2Bytes(atAddress: offset + kPartyPokemonTIDOffset) ?? 0
			PID = process.read4Bytes(atAddress: offset + kPartyPokemonPIDOffset) ?? 0
			expTotal = process.read4Bytes(atAddress: offset + kPartyPokemonTotalExpOffset) ?? 0
			usesSecondAbility = (process.readByte(atAddress: offset + kPartyPokemonAbilityIndexOffset) ?? 0) == 1
			OTName = process.readString(RAMOffset: offset + kPartyPokemonOTNameOffset, charLength: .short, maxCharacters: 10)
			nickname = process.readString(RAMOffset: offset + kPartyPokemonNicknameOffset, charLength: .short, maxCharacters: 10)
			speciesName = process.readString(RAMOffset: offset + kPartyPokemonNameOffset, charLength: .short, maxCharacters: 10)
			ribbons = (process.read2Bytes(atAddress: offset + kPartyPokemonRibbonsOffset) ?? 0).bitArray(count: 16)
			move1 = .index(process.read2Bytes(atAddress: offset + kPartyPokemonMove1Offset) ?? 0)
			move1PP = process.readByte(atAddress: offset + kPartyPokemonMove1PPOffset) ?? 0
			move2 = .index(process.read2Bytes(atAddress: offset + kPartyPokemonMove2Offset) ?? 0)
			move2PP = process.readByte(atAddress: offset + kPartyPokemonMove2PPOffset) ?? 0
			move3 = .index(process.read2Bytes(atAddress: offset + kPartyPokemonMove3Offset) ?? 0)
			move3PP = process.readByte(atAddress: offset + kPartyPokemonMove3PPOffset) ?? 0
			move4 = .index(process.read2Bytes(atAddress: offset + kPartyPokemonMove4Offset) ?? 0)
			move4PP = process.readByte(atAddress: offset + kPartyPokemonMove4PPOffset) ?? 0
			maxHP = process.read2Bytes(atAddress: offset + kPartyPokemonHPOffset) ?? 0
			attack = process.read2Bytes(atAddress: offset + kPartyPokemonATKOffset) ?? 0
			defense = process.read2Bytes(atAddress: offset + kPartyPokemonDEFOffset) ?? 0
			specialAttack = process.read2Bytes(atAddress: offset + kPartyPokemonSPAOffset) ?? 0
			specialDefense = process.read2Bytes(atAddress: offset + kPartyPokemonSPDOffset) ?? 0
			speed = process.read2Bytes(atAddress: offset + kPartyPokemonSPEOffset) ?? 0
			EVHP = process.read2Bytes(atAddress: offset + kPartyPokemonEVHPOffset) ?? 0
			EVattack = process.read2Bytes(atAddress: offset + kPartyPokemonEVATKOffset) ?? 0
			EVdefense = process.read2Bytes(atAddress: offset + kPartyPokemonEVDEFOffset) ?? 0
			EVspecialAttack = process.read2Bytes(atAddress: offset + kPartyPokemonEVSPAOffset) ?? 0
			EVspecialDefense = process.read2Bytes(atAddress: offset + kPartyPokemonEVSPDOffset) ?? 0
			EVspeed = process.read2Bytes(atAddress: offset + kPartyPokemonEVSPEOffset) ?? 0
			IVHP = process.readByte(atAddress: offset + kPartyPokemonIVHPOffset) ?? 0
			IVattack = process.readByte(atAddress: offset + kPartyPokemonIVATKOffset) ?? 0
			IVdefense = process.readByte(atAddress: offset + kPartyPokemonIVDEFOffset) ?? 0
			IVspecialAttack = process.readByte(atAddress: offset + kPartyPokemonIVSPAOffset) ?? 0
			IVspecialDefense = process.readByte(atAddress: offset + kPartyPokemonIVSPDOffset) ?? 0
			IVspeed = process.readByte(atAddress: offset + kPartyPokemonIVSPEOffset) ?? 0
			shadowID = process.readByte(atAddress: offset + kPartyPokemonShadowIDOffset) ?? 0
		}
	}

	func write(process: XDProcess) {
		if partyDataOffset > 0 {
			process.write16(species.index, atAddress: partyDataOffset + kPartyPokemonSpeciesOffset)
			process.write16(item.index, atAddress: partyDataOffset + kPartyPokemonItemOffset)
			process.write16(currentHP, atAddress: partyDataOffset + kPartyPokemonCurrentHPOffset)
			process.write16(happiness, atAddress: partyDataOffset + kPartyPokemonHappinessOffset)
			process.write8(level, atAddress: partyDataOffset + kPartyPokemonLevelOffset)
			process.write8(levelCaughtAt, atAddress: partyDataOffset + kPartyPokemonLevelCaughtOffset)
			process.write8(pokeballCaughtIn.index, atAddress: partyDataOffset + kPartyPokemonPokeballOffset)
			process.write16(SID, atAddress: partyDataOffset + kPartyPokemonSIDOffset)
			process.write16(TID, atAddress: partyDataOffset + kPartyPokemonTIDOffset)
			process.write(PID, atAddress: partyDataOffset + kPartyPokemonPIDOffset)
			process.write(expTotal, atAddress: partyDataOffset + kPartyPokemonTotalExpOffset)
			process.write8(usesSecondAbility ? 1 : 0, atAddress: partyDataOffset + kPartyPokemonAbilityIndexOffset)
			process.writeString(OTName, atAddress: partyDataOffset + kPartyPokemonOTNameOffset, charLength: .short, maxCharacters: 10, includeNullTerminator: false)
			process.writeString(nickname, atAddress: partyDataOffset + kPartyPokemonNicknameOffset, charLength: .short, maxCharacters: 10, includeNullTerminator: false)
			process.writeString(speciesName, atAddress: partyDataOffset + kPartyPokemonNameOffset, charLength: .short, maxCharacters: 10, includeNullTerminator: false)
			process.write16(ribbons.binaryBitsToInt(), atAddress: partyDataOffset + kPartyPokemonRibbonsOffset)
			process.write16(move1.index, atAddress: partyDataOffset + kPartyPokemonMove1Offset)
			process.write8(move1PP, atAddress: partyDataOffset + kPartyPokemonMove1PPOffset)
			process.write16(move2.index, atAddress: partyDataOffset + kPartyPokemonMove2Offset)
			process.write8(move2PP, atAddress: partyDataOffset + kPartyPokemonMove2PPOffset)
			process.write16(move3.index, atAddress: partyDataOffset + kPartyPokemonMove3Offset)
			process.write8(move3PP, atAddress: partyDataOffset + kPartyPokemonMove3PPOffset)
			process.write16(move4.index, atAddress: partyDataOffset + kPartyPokemonMove4Offset)
			process.write8(move4PP, atAddress: partyDataOffset + kPartyPokemonMove4PPOffset)
			process.write16(maxHP, atAddress: partyDataOffset + kPartyPokemonHPOffset)
			process.write16(attack, atAddress: partyDataOffset + kPartyPokemonATKOffset)
			process.write16(defense, atAddress: partyDataOffset + kPartyPokemonDEFOffset)
			process.write16(specialAttack, atAddress: partyDataOffset + kPartyPokemonSPAOffset)
			process.write16(specialDefense, atAddress: partyDataOffset + kPartyPokemonSPDOffset)
			process.write16(speed, atAddress: partyDataOffset + kPartyPokemonSPEOffset)
			process.write16(EVHP, atAddress: partyDataOffset + kPartyPokemonEVHPOffset)
			process.write16(EVattack, atAddress: partyDataOffset + kPartyPokemonEVATKOffset)
			process.write16(EVdefense, atAddress: partyDataOffset + kPartyPokemonEVDEFOffset)
			process.write16(EVspecialAttack, atAddress: partyDataOffset + kPartyPokemonEVSPAOffset)
			process.write16(EVspecialDefense, atAddress: partyDataOffset + kPartyPokemonEVSPDOffset)
			process.write16(EVspeed, atAddress: partyDataOffset + kPartyPokemonEVSPEOffset)
			process.write8(IVHP, atAddress: partyDataOffset + kPartyPokemonIVHPOffset)
			process.write8(IVattack, atAddress: partyDataOffset + kPartyPokemonIVATKOffset)
			process.write8(IVdefense, atAddress: partyDataOffset + kPartyPokemonIVDEFOffset)
			process.write8(IVspecialAttack, atAddress: partyDataOffset + kPartyPokemonIVSPAOffset)
			process.write8(IVspecialDefense, atAddress: partyDataOffset + kPartyPokemonIVSPDOffset)
			process.write8(IVspeed, atAddress: partyDataOffset + kPartyPokemonIVSPEOffset)
			process.write8(shadowID, atAddress: partyDataOffset + kPartyPokemonShadowIDOffset)
		}
	}
}
