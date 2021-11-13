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
let kPartyPokemonStatusOffset = 22
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
let kTrainerName1Offset = 0
let kTrainerName2Offset = 22
let kTrainerFirstPartyPokemonOffset = 48
let kSizeOfPartyPokemonData = 0xc4

class XDTrainer: Codable {
	var offset = 0

	var name: String?
	var deckID: Int?
	var partyPokemon: [XDPartyPokemon?]

	init(file: GoDReadable, offset: Int) {
		self.offset = offset

		name = file.readString(atAddress: offset + kTrainerName1Offset, charLength: .short, maxCharacters: 10)
		deckID = file.read4Bytes(atAddress: offset + kTrainerDeckIDOffset)
		var mons = [XDPartyPokemon?]()
		for i in 0 ..< 6 {
			let pokemonOffset = offset + kTrainerFirstPartyPokemonOffset + (i * kSizeOfPartyPokemonData)
			mons.append(XDPartyPokemon(file: file, offset: pokemonOffset))
		}
		partyPokemon = mons
	}

	func write(file: GoDWritable, offset: Int? = nil) {
		let writeOffset = offset ?? self.offset
		guard writeOffset > 0 else { return }

		if let name = name {
			file.writeString(name, atAddress: writeOffset + kTrainerName1Offset)
			file.writeString(name, atAddress: writeOffset + kTrainerName2Offset)
		}
		if let deckID = deckID {
			file.write(deckID, atAddress: writeOffset + kTrainerDeckIDOffset)
		}
		for i in 0 ..< 6 {
			let pokemonOffset = writeOffset + kTrainerFirstPartyPokemonOffset + (i * kSizeOfPartyPokemonData)
			partyPokemon[i]?.write(file: file, offset: pokemonOffset)
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

	override init(file: GoDReadable, offset: Int) {
		let partyDataOffset = file.read4Bytes(atAddress: offset) ?? 0
		super.init(file: file, offset: partyDataOffset + 4)
		if offset > 0 {
			battleDataOffset = offset
			currentAbility = .index(file.read2Bytes(atAddress: offset + kBattlePokemonCurrentAbilityOffset) ?? 0)
			currentType1 = .index(file.read2Bytes(atAddress: offset + kBattlePokemonCurrentType1Offset) ?? 0)
			currentType2 = .index(file.read2Bytes(atAddress: offset + kBattlePokemonCurrentType2Offset) ?? 0)

			attackModifer = XGStatStages(rawValue: file.readByte(atAddress: offset + kBattlePokemonCurrentATKStagesOffset) ?? 6) ?? .neutral
			defenseModifer = XGStatStages(rawValue: file.readByte(atAddress: offset + kBattlePokemonCurrentDEFStagesOffset) ?? 6) ?? .neutral
			specialAttackModifer = XGStatStages(rawValue: file.readByte(atAddress: offset + kBattlePokemonCurrentSPAStagesOffset) ?? 6) ?? .neutral
			specialDefenseModifer = XGStatStages(rawValue: file.readByte(atAddress: offset + kBattlePokemonCurrentSPDStagesOffset) ?? 6) ?? .neutral
			speedModifer = XGStatStages(rawValue: file.readByte(atAddress: offset + kBattlePokemonCurrentSPEStagesOffset) ?? 6) ?? .neutral
			accuracyModifer = XGStatStages(rawValue: file.readByte(atAddress: offset + kBattlePokemonCurrentACCStagesOffset) ?? 6) ?? .neutral
			evasionModifer = XGStatStages(rawValue: file.readByte(atAddress: offset + kBattlePokemonCurrentEVAStagesOffset) ?? 6) ?? .neutral
		}
	}

	override func write(file: GoDWritable, offset: Int? = nil) {
		super.write(file: file)
		let writeOffset = offset ?? battleDataOffset
		if writeOffset > 0 {
			if let offset = offset {
				file.write(partyDataOffset, atAddress: offset)
			}
			file.write16(currentAbility.index, atAddress: writeOffset + kBattlePokemonCurrentAbilityOffset)
			file.write16(currentType1.index, atAddress: writeOffset + kBattlePokemonCurrentType1Offset)
			file.write16(currentType2.index, atAddress: writeOffset + kBattlePokemonCurrentType2Offset)
			
			file.write8(attackModifer.rawValue, atAddress: writeOffset + kBattlePokemonCurrentATKStagesOffset)
			file.write8(defenseModifer.rawValue, atAddress: writeOffset + kBattlePokemonCurrentDEFStagesOffset)
			file.write8(specialAttackModifer.rawValue, atAddress: writeOffset + kBattlePokemonCurrentSPAStagesOffset)
			file.write8(specialDefenseModifer.rawValue, atAddress: writeOffset + kBattlePokemonCurrentSPDStagesOffset)
			file.write8(speedModifer.rawValue, atAddress: writeOffset + kBattlePokemonCurrentSPEStagesOffset)
			file.write8(accuracyModifer.rawValue, atAddress: writeOffset + kBattlePokemonCurrentACCStagesOffset)
			file.write8(evasionModifer.rawValue, atAddress: writeOffset + kBattlePokemonCurrentEVAStagesOffset)
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
	var status = XGNonVolatileStatusEffects.none
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

	init(file: GoDReadable, offset: Int) {
		partyDataOffset = offset
		if offset > 0 {
			species = .index(file.read2Bytes(atAddress: offset + kPartyPokemonSpeciesOffset) ?? 0)
			item = .index(file.read2Bytes(atAddress: offset + kPartyPokemonItemOffset) ?? 0)
			currentHP = file.read2Bytes(atAddress: offset + kPartyPokemonCurrentHPOffset) ?? 0
			status = XGNonVolatileStatusEffects(rawValue: file.readByte(atAddress: offset + kPartyPokemonStatusOffset) ?? 0) ?? .none
			happiness = file.read2Bytes(atAddress: offset + kPartyPokemonHappinessOffset) ?? 0
			level = file.readByte(atAddress: offset + kPartyPokemonLevelOffset) ?? 0
			levelCaughtAt = file.readByte(atAddress: offset + kPartyPokemonLevelCaughtOffset) ?? 0
			pokeballCaughtIn = .index(file.readByte(atAddress: offset + kPartyPokemonPokeballOffset) ?? 0)
			SID = file.read2Bytes(atAddress: offset + kPartyPokemonSIDOffset) ?? 0
			TID = file.read2Bytes(atAddress: offset + kPartyPokemonTIDOffset) ?? 0
			PID = file.read4Bytes(atAddress: offset + kPartyPokemonPIDOffset) ?? 0
			expTotal = file.read4Bytes(atAddress: offset + kPartyPokemonTotalExpOffset) ?? 0
			usesSecondAbility = (file.readByte(atAddress: offset + kPartyPokemonAbilityIndexOffset) ?? 0) == 1
			OTName = file.readString(atAddress: offset + kPartyPokemonOTNameOffset, charLength: .short, maxCharacters: 10)
			nickname = file.readString(atAddress: offset + kPartyPokemonNicknameOffset, charLength: .short, maxCharacters: 10)
			speciesName = file.readString(atAddress: offset + kPartyPokemonNameOffset, charLength: .short, maxCharacters: 10)
			ribbons = (file.read2Bytes(atAddress: offset + kPartyPokemonRibbonsOffset) ?? 0).bitArray(count: 16)
			move1 = .index(file.read2Bytes(atAddress: offset + kPartyPokemonMove1Offset) ?? 0)
			move1PP = file.readByte(atAddress: offset + kPartyPokemonMove1PPOffset) ?? 0
			move2 = .index(file.read2Bytes(atAddress: offset + kPartyPokemonMove2Offset) ?? 0)
			move2PP = file.readByte(atAddress: offset + kPartyPokemonMove2PPOffset) ?? 0
			move3 = .index(file.read2Bytes(atAddress: offset + kPartyPokemonMove3Offset) ?? 0)
			move3PP = file.readByte(atAddress: offset + kPartyPokemonMove3PPOffset) ?? 0
			move4 = .index(file.read2Bytes(atAddress: offset + kPartyPokemonMove4Offset) ?? 0)
			move4PP = file.readByte(atAddress: offset + kPartyPokemonMove4PPOffset) ?? 0
			maxHP = file.read2Bytes(atAddress: offset + kPartyPokemonHPOffset) ?? 0
			attack = file.read2Bytes(atAddress: offset + kPartyPokemonATKOffset) ?? 0
			defense = file.read2Bytes(atAddress: offset + kPartyPokemonDEFOffset) ?? 0
			specialAttack = file.read2Bytes(atAddress: offset + kPartyPokemonSPAOffset) ?? 0
			specialDefense = file.read2Bytes(atAddress: offset + kPartyPokemonSPDOffset) ?? 0
			speed = file.read2Bytes(atAddress: offset + kPartyPokemonSPEOffset) ?? 0
			EVHP = file.read2Bytes(atAddress: offset + kPartyPokemonEVHPOffset) ?? 0
			EVattack = file.read2Bytes(atAddress: offset + kPartyPokemonEVATKOffset) ?? 0
			EVdefense = file.read2Bytes(atAddress: offset + kPartyPokemonEVDEFOffset) ?? 0
			EVspecialAttack = file.read2Bytes(atAddress: offset + kPartyPokemonEVSPAOffset) ?? 0
			EVspecialDefense = file.read2Bytes(atAddress: offset + kPartyPokemonEVSPDOffset) ?? 0
			EVspeed = file.read2Bytes(atAddress: offset + kPartyPokemonEVSPEOffset) ?? 0
			IVHP = file.readByte(atAddress: offset + kPartyPokemonIVHPOffset) ?? 0
			IVattack = file.readByte(atAddress: offset + kPartyPokemonIVATKOffset) ?? 0
			IVdefense = file.readByte(atAddress: offset + kPartyPokemonIVDEFOffset) ?? 0
			IVspecialAttack = file.readByte(atAddress: offset + kPartyPokemonIVSPAOffset) ?? 0
			IVspecialDefense = file.readByte(atAddress: offset + kPartyPokemonIVSPDOffset) ?? 0
			IVspeed = file.readByte(atAddress: offset + kPartyPokemonIVSPEOffset) ?? 0
			shadowID = file.readByte(atAddress: offset + kPartyPokemonShadowIDOffset) ?? 0
		}
	}

	func write(file: GoDWritable, offset: Int? = nil) {
		let writeOffset = offset ?? partyDataOffset
		if writeOffset > 0 {
			file.write16(species.index, atAddress: writeOffset + kPartyPokemonSpeciesOffset)
			file.write16(item.index, atAddress: writeOffset + kPartyPokemonItemOffset)
			file.write16(currentHP, atAddress: writeOffset + kPartyPokemonCurrentHPOffset)
			file.write8(status.rawValue, atAddress: writeOffset + kPartyPokemonStatusOffset)
			file.write16(happiness, atAddress: writeOffset + kPartyPokemonHappinessOffset)
			file.write8(level, atAddress: writeOffset + kPartyPokemonLevelOffset)
			file.write8(levelCaughtAt, atAddress: writeOffset + kPartyPokemonLevelCaughtOffset)
			file.write8(pokeballCaughtIn.index, atAddress: writeOffset + kPartyPokemonPokeballOffset)
			file.write16(SID, atAddress: writeOffset + kPartyPokemonSIDOffset)
			file.write16(TID, atAddress: writeOffset + kPartyPokemonTIDOffset)
			file.write(PID, atAddress: writeOffset + kPartyPokemonPIDOffset)
			file.write(expTotal, atAddress: writeOffset + kPartyPokemonTotalExpOffset)
			file.write8(usesSecondAbility ? 1 : 0, atAddress: writeOffset + kPartyPokemonAbilityIndexOffset)
			file.writeString(OTName, atAddress: writeOffset + kPartyPokemonOTNameOffset, charLength: .short, maxCharacters: 10, includeNullTerminator: false)
			file.writeString(nickname, atAddress: writeOffset + kPartyPokemonNicknameOffset, charLength: .short, maxCharacters: 10, includeNullTerminator: false)
			file.writeString(speciesName, atAddress: writeOffset + kPartyPokemonNameOffset, charLength: .short, maxCharacters: 10, includeNullTerminator: false)
			file.write16(ribbons.binaryBitsToInt(), atAddress: writeOffset + kPartyPokemonRibbonsOffset)
			file.write16(move1.index, atAddress: writeOffset + kPartyPokemonMove1Offset)
			file.write8(move1PP, atAddress: writeOffset + kPartyPokemonMove1PPOffset)
			file.write16(move2.index, atAddress: writeOffset + kPartyPokemonMove2Offset)
			file.write8(move2PP, atAddress: writeOffset + kPartyPokemonMove2PPOffset)
			file.write16(move3.index, atAddress: writeOffset + kPartyPokemonMove3Offset)
			file.write8(move3PP, atAddress: writeOffset + kPartyPokemonMove3PPOffset)
			file.write16(move4.index, atAddress: writeOffset + kPartyPokemonMove4Offset)
			file.write8(move4PP, atAddress: writeOffset + kPartyPokemonMove4PPOffset)
			file.write16(maxHP, atAddress: writeOffset + kPartyPokemonHPOffset)
			file.write16(attack, atAddress: writeOffset + kPartyPokemonATKOffset)
			file.write16(defense, atAddress: writeOffset + kPartyPokemonDEFOffset)
			file.write16(specialAttack, atAddress: writeOffset + kPartyPokemonSPAOffset)
			file.write16(specialDefense, atAddress: writeOffset + kPartyPokemonSPDOffset)
			file.write16(speed, atAddress: writeOffset + kPartyPokemonSPEOffset)
			file.write16(EVHP, atAddress: writeOffset + kPartyPokemonEVHPOffset)
			file.write16(EVattack, atAddress: writeOffset + kPartyPokemonEVATKOffset)
			file.write16(EVdefense, atAddress: writeOffset + kPartyPokemonEVDEFOffset)
			file.write16(EVspecialAttack, atAddress: writeOffset + kPartyPokemonEVSPAOffset)
			file.write16(EVspecialDefense, atAddress: writeOffset + kPartyPokemonEVSPDOffset)
			file.write16(EVspeed, atAddress: writeOffset + kPartyPokemonEVSPEOffset)
			file.write8(IVHP, atAddress: writeOffset + kPartyPokemonIVHPOffset)
			file.write8(IVattack, atAddress: writeOffset + kPartyPokemonIVATKOffset)
			file.write8(IVdefense, atAddress: writeOffset + kPartyPokemonIVDEFOffset)
			file.write8(IVspecialAttack, atAddress: writeOffset + kPartyPokemonIVSPAOffset)
			file.write8(IVspecialDefense, atAddress: writeOffset + kPartyPokemonIVSPDOffset)
			file.write8(IVspeed, atAddress: writeOffset + kPartyPokemonIVSPEOffset)
			file.write8(shadowID, atAddress: writeOffset + kPartyPokemonShadowIDOffset)
		}
	}
}
