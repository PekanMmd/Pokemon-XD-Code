//
//  XDGameState.swift
//  GoD Tool
//
//  Created by Stars Momodu on 29/09/2021.
//

import Foundation

class ProcessState<T> {
	private var lazyValue: T?
	private let lazyInit: (XDProcess?) -> T?
	fileprivate var wasSet = false
	fileprivate var wasRead = true
	private weak var process: XDProcess?

	fileprivate init(process: XDProcess, lazyInit: @escaping (XDProcess?) -> T?) {
		self.process = process
		self.lazyInit = lazyInit
		wasRead = false
	}

	var value: T? {
		if !wasSet {
			lazyValue = lazyInit(process)
			wasRead = true
		}
		return lazyValue
	}

	func update(with newValue: T?) {
		lazyValue = newValue
		wasSet = true
	}

	fileprivate func write(process: XDProcess) {}
}

#if GAME_XD
class XDBattleState: ProcessState<XGBattle> {
	private static var kCurrentBattleIDRAMOffset: Int {
		switch region {
		case .US: return 0x804EB910
		default: return -1
		}
	}

	init(process: XDProcess) {
		super.init(process: process) { (process) -> XGBattle? in
			let battleID = process?.read2Bytes(atAddress: Self.kCurrentBattleIDRAMOffset) ?? 0
			if battleID > 0, battleID < CommonIndexes.NumberOfBattles.value {
				return XGBattle(index: battleID)
			} else {
				return nil
			}
		}
	}

	fileprivate override func write(process: XDProcess) {
		super.write(process: process)
		if wasSet,
		   let battle = self.value {
			let battleStart = CommonIndexes.Battles.startOffset + (battle.index * kSizeOfBattleData) + kRELtoRAMOffsetDifference
			if let battleData = process.read(atAddress: battleStart, length: kSizeOfBattleData) {

				battleData.replaceByteAtOffset(kBattleBattleTypeOffset, withByte: battle.battleType.rawValue)
				battleData.replaceByteAtOffset(kBattleTrainersPerSideOffset, withByte: battle.trainersPerSide)
				battleData.replaceByteAtOffset(kBattlePokemonPerPlayerOffset, withByte: battle.pokemonPerPlayer)
				battleData.replaceByteAtOffset(kBattleStyleOffset, withByte: battle.battleStyle.rawValue)
				battleData.replaceByteAtOffset(kBattleColosseumRoundOffset, withByte: battle.round.rawValue)
				battleData.replaceByteAtOffset(kBattleUnknown1Offset, withByte: battle.unknown ? 1 : 0)
				battleData.replaceByteAtOffset(kBattleUnknown2Offset, withByte: battle.unknown2)

				battleData.replace2BytesAtOffset(kBattleFieldOffset, withBytes: battle.battleField.index)
				battleData.replace2BytesAtOffset(kBattleBGMOffset, withBytes: battle.BGMusicID)

				battleData.replace2BytesAtOffset(kBattlePlayer1DeckIDOffset, withBytes: (battle.p1Deck ?? .DeckDarkPokemon).id)
				battleData.replace2BytesAtOffset(kBattlePlayer1TrainerIDOffset, withBytes: battle.p1TID)
				battleData.replaceByteAtOffset(kBattlePlayer1ControlOffset, withByte: battle.p1Controller.rawValue)

				battleData.replace2BytesAtOffset(kBattlePlayer2DeckIDOffset, withBytes: (battle.p2Deck ?? .DeckDarkPokemon).id)
				battleData.replace2BytesAtOffset(kBattlePlayer2TrainerIDOffset, withBytes: battle.p2TID)
				battleData.replaceByteAtOffset(kBattlePlayer2ControlOffset, withByte: battle.p2Controller.rawValue)

				battleData.replace2BytesAtOffset(kBattlePlayer3DeckIDOffset, withBytes: (battle.p3Deck ?? .DeckDarkPokemon).id)
				battleData.replace2BytesAtOffset(kBattlePlayer3TrainerIDOffset, withBytes: battle.p3TID)
				battleData.replaceByteAtOffset(kBattlePlayer3ControlOffset, withByte: battle.p3Controller.rawValue)

				battleData.replace2BytesAtOffset(kBattlePlayer4DeckIDOffset, withBytes: (battle.p4Deck ?? .DeckDarkPokemon).id)
				battleData.replace2BytesAtOffset(kBattlePlayer4TrainerIDOffset, withBytes: battle.p4TID)
				battleData.replaceByteAtOffset(kBattlePlayer4ControlOffset, withByte: battle.p4Controller.rawValue)
				process.write(battleData, atAddress: battleStart)
			}
		}
	}
}
#endif

class XDCurrentRoomState: ProcessState<XGRoom> {
	static var kCurrentRoomIDRAMOffset: Int {
		if game == .XD {
			switch region {
			case .US: return 0x80814ab6
			default: return -1
			}
		} else {
			switch region {
			case .US: return 0x80478B1a
			default: return -1
			}
		}
	}

	init(process: XDProcess) {
		super.init(process: process) { (process) -> XGRoom? in
			let currentRoomID = process?.read2Bytes(atAddress: Self.kCurrentRoomIDRAMOffset) ?? 0
			return XGRoom.roomWithID(currentRoomID)
		}
	}

	override func write(process: XDProcess) {
		super.write(process: process)
		if wasSet{
			if let room = value {
				process.write16(room.roomID, atAddress: Self.kCurrentRoomIDRAMOffset)
			} else {
				process.write16(0, atAddress: Self.kCurrentRoomIDRAMOffset)
			}
		}
	}
}

#if GAME_XD
class XDLastMenuState: ProcessState<XGRoom> {
	static var kLastMenuIDRAMOffset: Int {
		switch region {
		case .US: return 0x80814cd8
		default: return -1
		}
	}

	init(process: XDProcess) {
		super.init(process: process) { (process) -> XGRoom? in
			let currentSubRoomID = process?.read4Bytes(atAddress: Self.kLastMenuIDRAMOffset) ?? 0
			return XGRoom.roomWithID(currentSubRoomID)
		}
	}

	override func write(process: XDProcess) {
		super.write(process: process)
		if wasSet {
			if let room = value {
				process.write(room.roomID, atAddress: Self.kLastMenuIDRAMOffset)
			} else {
				process.write(0, atAddress: Self.kLastMenuIDRAMOffset)
			}
		}
	}
}

class XDShadowDataState: ProcessState<[XDStoredShadowData]> {
	private static var kCurrentRoomIDRAMOffset: Int {
		switch region {
		case .US: return 0x80814ab6
		default: return -1
		}
	}

	init(process: XDProcess) {
		super.init(process: process) { (process) -> [XDStoredShadowData]? in
			let data = (0 ..< XGDecks.DeckDarkPokemon.DDPKEntries).map { (shadowID) -> XDStoredShadowData? in
				guard let process = process else { return nil }
				return XDStoredShadowData(process: process, index: shadowID)
			}
			guard !data.contains(where: { $0 == nil }) else { return nil }
			return data.map { $0! }
		}
	}

	override func write(process: XDProcess) {
		super.write(process: process)
		if wasSet,
		   let data = value {
			data.forEach { (shadowData) in
				shadowData.write(file: process)
			}
		}
	}

	func shadowData(id: Int) -> XDStoredShadowData? {
		guard let storedShadowData = value,
			  id > 0,
			  id < storedShadowData.count else { return nil }
		return storedShadowData[id]
	}

	func shadowData(pokemon: XDPartyPokemon) -> XDStoredShadowData? {
		return shadowData(id: pokemon.shadowID)
	}
}

class XDTrainerState: ProcessState<XDTrainer> {
	init(process: XDProcess) {
		super.init(process: process) { (process) -> XDTrainer? in
			guard let process = process,
				  let trainerDataOrigin = process.readPointerRelativeToR13(offset: -0x4728) else { return nil }
			let partyDataOffset = trainerDataOrigin + 320
			return XDTrainer(file: process, offset: partyDataOffset)
		}
	}

	override func write(process: XDProcess) {
		super.write(process: process)
		if wasSet,
		   let trainer = value {
			trainer.write(file: process)
		}
	}
}

class XDFlagsState {
	enum PokeSpotFlagTypes: Int {
		case rock, oasis, cave
	}
	private weak var process: XDProcess?

	init(process: XDProcess) {
		self.process = process
	}

	func getBooleanFlag(_ id: Int) -> Bool? {
		return process?.getBooleanFlag(id)
	}
	func getBooleanFlag(_ flag: XDSFlags) -> Bool? {
		return process?.getBooleanFlag(flag)
	}
	func getFlag(_ id: Int) -> Int? {
		return process?.getFlag(id)
	}
	func getFlag(_ flag: XDSFlags) -> Int? {
		return process?.getFlag(flag)
	}

	var mirorBLocation: XGRoom? {
		guard let roomID = getFlag(.mirorbLocation) else { return nil }
		return XGRoom.roomWithID(roomID)
	}

	var storyProgress: XGStoryProgress? {
		guard let storyFlag = process?.getFlag(.story) else { return nil }
		return XGStoryProgress(rawValue: storyFlag)
	}

	func getSpawnAtPokespot(_ spot: PokeSpotFlagTypes) -> XGPokemon? {
		let flag: XDSFlags
		switch spot {
		case .rock: flag = .currentPokespotSpawnRock
		case .oasis: flag = .currentPokespotSpawnOasis
		case .cave: flag = .currentPokespotSpawnCave
		}
		guard let species = process?.getFlag(flag) else { return nil }
		return .index(species)
	}

	func getSnacksAtPokespot(_ spot: PokeSpotFlagTypes) -> Int? {
		let flag: XDSFlags
		switch spot {
		case .rock: flag = .currentPokespotSnacksRock
		case .oasis: flag = .currentPokespotSnacksOasis
		case .cave: flag = .currentPokespotSnacksCave
		}
		return  process?.getFlag(flag)
	}
}

extension XDStoredShadowData {
	convenience init?(process: XDProcess, index: Int) {
		guard let trainerDataOrigin = process.readPointerRelativeToR13(offset: -0x4728) else { return nil }
		let shadowDataOffset = trainerDataOrigin + 0xE380
		self.init(file: process, offset: shadowDataOffset + (index * kSizeOfStoredShadowData))
	}
}

class XDGameState {

	// Reading and writing too much in each break cycle causes too much lag
	// When multiple breakpoints are triggered in quick succession.
	// Load everything lazily instead and only write things that were referenced.
	let battleState: XDBattleState?
	let currentRoomState: XDCurrentRoomState?
	let lastMenuState: XDLastMenuState?
	let shadowDataState: XDShadowDataState?
	let trainerState: XDTrainerState?
	let flagsState: XDFlagsState?

	init(process: XDProcess) {
		battleState = XDBattleState(process: process)
		currentRoomState = XDCurrentRoomState(process: process)
		lastMenuState = XDLastMenuState(process: process)
		shadowDataState = XDShadowDataState(process: process)
		trainerState = XDTrainerState(process: process)
		flagsState = XDFlagsState(process: process)
	}

	func write(process: XDProcess) {
		battleState?.write(process: process)
		currentRoomState?.write(process: process)
		shadowDataState?.write(process: process)
		trainerState?.write(process: process)
	}
}
#else
class XDShadowDataState: ProcessState<[XDStoredShadowData]> {

	init(process: XDProcess) {
		super.init(process: process) { (process) -> [XDStoredShadowData]? in
			return []
		}
	}

	override func write(process: XDProcess) {
	}

	func shadowData(id: Int) -> XDStoredShadowData? {
		return nil
	}

	func shadowData(pokemon: XDPartyPokemon) -> XDStoredShadowData? {
		return nil
	}
}

class XDGameState {

	var battleState: XDBattleState?
	var currentRoomState: XDCurrentRoomState?
	var shadowDataState: XDShadowDataState?
	var trainerState: XDTrainerState?
	var flagsState: XDFlagsState?

	init(process: XDProcess) {

	}

	func write(process: XDProcess) {
		
	}
}

class XDTrainerState: ProcessState<XDTrainer> {
	init(process: XDProcess) {
		super.init(process: process) { (process) -> XDTrainer? in
			return nil
		}
	}

	override func write(process: XDProcess) {

	}
}

class XDFlagsState: ProcessState<XDSFlags> {
	init(process: XDProcess) {
		super.init(process: process) { (process) -> XDSFlags? in
			return nil
		}
	}

	override func write(process: XDProcess) {

	}
}

class XDBattleState: ProcessState<XGBattle> {
	init(process: XDProcess) {
		super.init(process: process) { (process) -> XGBattle? in
			return nil
		}
	}

	override func write(process: XDProcess) {

	}
}

extension XDStoredShadowData {
	convenience init?(process: XDProcess, index: Int) {
		return nil
	}
}
#endif
