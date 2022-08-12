//
//  CMBreakPoints.swift
//  GoD Tool
//
//  Created by Stars Momodu on 10/11/2021.
//

import Foundation

extension XDBreakPointTypes {

	var addresses: [Int]? {
		switch self {
		case .onFrameAdvance:
			switch region {
			case .US: return [0x801bfd10]
			default: return nil
			}
		case .onWillRenderFrame:
			switch region {
			case .US: return [0x801c0130]
			default: return nil
			}
		case .onDidRNGRoll:
			switch region {
			case .US: return [0x801add08]
			default: return nil
			}
		case .onWillGetFlag:
			switch region {
			case .US: return nil
			default: return nil
			}
		case .onWillSetFlag:
			switch region {
			case .US: return nil
			default: return nil
			}
		case .onStepCount:
			switch region {
			case .US: return [0x8012ef58]
			default: return nil
			}
		case .onDidReadOrWriteSave:
			switch region {
			case .US: return [0x801d0a2c]
			default: return nil
			}
		case .onWillWriteSave:
			switch region {
			case .US: return [0x801d0110, 0x801d0118]
			default: return nil
			}
		case .onWillChangeMap:
			switch region {
			case .US: return [0x800ff730, 0x800ff58c]
			default: return nil
			}
		case .onDidChangeMap:
			switch region {
			case .US: return [0x800ff63c]
			default: return nil
			}
		case .onDidChangeMenuMap:
			switch region {
			case .US: return [0x800ff76c]
			default: return nil
			}
		case .onDidConfirmMoveSelection:
			switch region {
			case .US: return [0x80204f6c]
			default: return nil
			}
		case .onDidConfirmTurnSelection:
			switch region {
			case .US: return [0x8020505c]
			default: return nil
			}
		case .onWillUseMove:
			switch region {
			case .US: return [0x80212974]
			default: return nil
			}
		case .onMoveEnd:
			switch region {
			case .US: return [0x80212d68]
			default: return nil
			}
		case .onWillCallPokemon:
			switch region {
			case .US: return [0x80212db0]
			default: return nil
			}
		case .onPokemonWillSwitchIntoBattle:
			switch region {
			case .US: return nil
			default: return nil
			}
		case .onShadowPokemonEncountered:
			switch region {
			case .US: return nil
			default: return nil
			}
		case .onShadowPokemonFled:
			switch region {
			case .US: return nil
			default: return nil
			}
		case .onShadowPokemonDidEnterReverseMode:
			switch region {
			case .US: return nil
			default: return nil
			}
		case .onWillUseItem:
			switch region {
			case .US: return nil
			default: return nil
			}
		case .onWillUseCologne:
			switch region {
			case .US: return nil
			default: return nil
			}
		case .onWillUseTM:
			switch region {
			case .US: return nil
			default: return nil
			}
		case .onDidUseTM:
			switch region {
			case .US: return nil
			default: return nil
			}
		case .onWillGainExp:
			switch region {
			case .US: return nil
			default: return nil
			}
		case .onLevelUp:
			#warning("TODO: find a good way to break on level up")
			return nil
		case .onWillEvolve:
			switch region {
			case .US: return nil
			default: return nil
			}
		case .onDidEvolve:
			switch region {
			case .US: return nil
			default: return nil
			}
		case .onDidPurification:
			switch region {
			case .US: return nil
			default: return nil
			}
		case .onWillStartBattle:
			switch region {
			case .US: return nil
			default: return nil
			}
		case .onDidEndBattle:
			switch region {
			case .US: return nil
			default: return nil
			}
		case .onBattleWhiteout:
			switch region {
			case .US: return nil
			default: return nil
			}
		case .onBattleTurnStart:
			switch region {
			case .US: return nil
			default: return nil
			}
		case .onBattleTurnEnd:
			switch region {
			case .US: return nil
			default: return nil
			}
		case .onPokemonTurnStart:
			switch region {
			case .US: return nil
			default: return nil
			}
		case .onPokemonTurnEnd:
			switch region {
			case .US: return nil
			default: return nil
			}
		case .onBattleDamageOrHealing:
			switch region {
			case .US: return nil
			default: return nil
			}
		case .onPokemonDidFaint:
			switch region {
			case .US: return nil
			default: return nil
			}
		case .onWillAttemptPokemonCapture:
			switch region {
			case .US: return nil
			default: return nil
			}
		case .onDidSucceedPokemonCapture:
			switch region {
			case .US: return nil
			default: return nil
			}
		case .onDidFailPokemonCapture:
			switch region {
			case .US: return nil
			default: return nil
			}
		case .onMirorRadarActiveAtColosseum:
			switch region {
			case .US: return nil
			default: return nil
			}
		case .onMirorRadarActiveAtPokespot:
			switch region {
			case .US: return nil
			default: return nil
			}
		case .onMirorRadarLostSignal:
			switch region {
			case .US: return nil
			default: return nil
			}
		case .onSpotMonitorActivated:
			switch region {
			case .US: return nil
			default: return nil
			}
		case .onWildBattleGenerated:
			switch region {
			case .US: return nil
			default: return nil
			}
		case .onReceivedGiftPokemon:
			switch region {
			case .US: return nil
			default: return nil
			}
		case .onReceivedItem:
			#warning("TODO: research this")
			return nil
		case .onHealTeam:
			#warning("TODO: research this")
			return nil
		case .onNewGameStart:
			#warning("TODO: research this")
			return nil
		case .onDidPromptReleasePokemon:
			switch region {
			case .US: return [0x800557f0]
			default: return nil
			}
		case .onDidReleasePokemon:
			switch region {
			case .US: return [0x80055800]
			default: return nil
			}
		case .onPrint:
			switch region {
			case .US: return nil
			default: return nil
			}
		case .onSoftReset:
			switch region {
			case .US: return nil
			default: return nil
			}
		case .onInconsistentState:
			return nil
		case .yield:
			return nil
		case .forcedReturn:
			return nil
		case .clear:
			return nil
		}
	}

	var standardReturnOffset: Int? {
		switch self {
		default:
			return nil
		}
	}

	var forcedReturnValueAddress: Int? {
		switch self {
		case .onWillGetFlag:
			switch region {
			case .US: return nil
			default: return nil
		}
		default:
			return nil
		}
	}
}

class BreakPointContext: Codable {
	fileprivate var forcedReturnValue: Int?

	init() {}
	init(process: XDProcess, registers: [Int: Int]) {}
	func getRegisters() -> [Int: Int] { return [:] }
}

class RenderFrameBufferContext: BreakPointContext {

	override init(process: XDProcess, registers: [Int: Int]) {
		super.init()
	}

	override func getRegisters() -> [Int: Int] {
		return [:]
	}

	required init(from decoder: Decoder) throws { fatalError("-") }
}

class RNGRollContext: BreakPointContext {
	var roll: UInt16 = 0

	override init(process: XDProcess, registers: [Int: Int]) {
		self.roll = UInt16(registers[3] ?? 0)
		super.init()
	}

	override func getRegisters() -> [Int: Int] {
		return [3: Int(roll)]
	}

	required init(from decoder: Decoder) throws { fatalError("-") }
}

//class GetFlagContext: BreakPointContext {
//	var flagID: Int
//
//	override init(process: XDProcess, registers: [Int: Int]) {
//		flagID = registers[3] ?? 0
//		super.init()
//	}
//
//	override func getRegisters() -> [Int: Int] {
//		return [3: flagID]
//	}
//
//	required init(from decoder: Decoder) throws { fatalError("-") }
//
//	func setReturnValue(_ to: Int) {
//		forcedReturnValue = to
//	}
//
//	func getForcedReturnValue() -> Int? {
//		return forcedReturnValue
//	}
//}
//
//class SetFlagContext: BreakPointContext {
//	var flagID: Int
//	var value: Int
//
//	override init(process: XDProcess, registers: [Int: Int]) {
//		flagID = registers[3] ?? 0
//		value = registers[4] ?? 0
//		super.init()
//	}
//
//	override func getRegisters() -> [Int: Int] {
//		return [3: flagID, 4: value]
//	}
//
//	required init(from decoder: Decoder) throws { fatalError("-") }
//}

class StepCounterContext: BreakPointContext {

	override init(process: XDProcess, registers: [Int: Int]) {
		super.init()
	}

	override func getRegisters() -> [Int: Int] {
		return [:]
	}

	required init(from decoder: Decoder) throws { fatalError("-") }
}

class SaveReadOrWriteContext: BreakPointContext {
	enum Status: Int, Codable {
		case cancelled = -1, previouslyLoadedCleanSave = 1, readSuccessfully = 3, wroteSuccessfully = 4, firstLoadNoSaveData = 5, unknown = -2
	}

	var status: Status

	override init(process: XDProcess, registers: [Int: Int]) {
		status = Status(rawValue: registers[3] ?? 0) ?? .unknown
		super.init()
	}

	override func getRegisters() -> [Int: Int] {
		return [3: status.rawValue]
	}

	required init(from decoder: Decoder) throws { fatalError("-") }
}

class MapOrMenuDidChangeContext: BreakPointContext {
	var newRoom: XGRoom
	private let isMenu: Bool

	init(process: XDProcess, registers: [Int: Int], isMenu: Bool) {
		newRoom = XGRoom.roomWithID(registers[isMenu ? 31: 28] ?? 0) ?? XGRoom(index: 0)
		self.isMenu = isMenu
		super.init()
	}

	override func getRegisters() -> [Int: Int] {
		let index = isMenu ? 31: 28
		return [index: newRoom.roomID]
	}

	required init(from decoder: Decoder) throws { fatalError("-") }
}

class MapWillChangeContext: BreakPointContext {
	var nextRoom: XGRoom

	override init(process: XDProcess, registers: [Int: Int]) {
		nextRoom = XGRoom.roomWithID(registers[3] ?? 0) ?? XGRoom(index: 0)
		super.init()
	}

	override func getRegisters() -> [Int: Int] {
		return [3: nextRoom.roomID]
	}

	required init(from decoder: Decoder) throws { fatalError("-") }
}

class BattleMoveSelectionContext: BreakPointContext {
	enum Targets: Int, Codable {
		case none = 0x0
		case topFoe = 0x1
		case topAlly = 0xC
		case bottomAlly = 0xD
		case bottomFoe = 0x10
	}

	let moveRoutinePointer: Int
	var move: XGMoves
	var targets: Targets
	var selectedMoveIndex: Int
	var pokemon: XDBattlePokemon

	override init(process: XDProcess, registers: [Int: Int]) {
		pokemon = XDBattlePokemon(file: process, offset: registers[3] ?? 0)
		moveRoutinePointer = registers[7] ?? 0
		move = .index( registers[8] ?? 0)
		targets = Targets(rawValue: registers[9] ?? 0) ?? .none
		if targets == .none {
			printg("Undocumented move targets case \(registers[9] ?? 0) for move \(move.name.string)")
		}
		selectedMoveIndex = registers[10] ?? 0
		super.init()
	}

	override func getRegisters() -> [Int: Int] {
		return [
			3: pokemon.battleDataOffset,
			8: move.index,
			9: targets.rawValue,
			10: selectedMoveIndex
		]
	}

	required init(from decoder: Decoder) throws { fatalError("-") }
}

class BattleTurnSelectionContext: BreakPointContext {
	enum Option: Codable {
		case fight(move: XGMoves)
		case item(item: XGItems)
		case switchPokemon(index: Int)
		case call
		case unknown(id: Int, parameter: Int)

		var optionID: Int {
			switch self {
			case .fight: return 19
			case .item: return 18
			case .switchPokemon: return 9
			case .call: return 10
			case .unknown(let id, _): return id
			}
		}

		var parameter: Int {
			switch self {
			case .fight(let move): return move.index
			case .item(let item): return item.index
			case .switchPokemon(let index): return index
			case .call: return 0
			case .unknown(_, let param): return param
			}
		}

		enum CodingKeys: String, CodingKey {
			case type, parameter
		}

		init(from decoder: Decoder) throws {
			let container = try decoder.container(keyedBy: CodingKeys.self)
			let type = try container.decode(Int.self, forKey: .type)
			let parameter = try container.decode(Int.self, forKey: .parameter)
			switch type {
			case 19: self = .fight(move: .index(parameter))
			case 18: self = .item(item: .index(parameter))
			case 9: self = .switchPokemon(index: parameter)
			case 10: self = .call
			default: self = .unknown(id: type, parameter: parameter)
			}
		}

		func encode(to encoder: Encoder) throws {
			var container = encoder.container(keyedBy: CodingKeys.self)
			try container.encode(optionID, forKey: .type)
			try container.encode(parameter, forKey: .parameter)
		}
	}

	let moveRoutinePointer: Int
	var pokemon: XDBattlePokemon
	var option: Option

	override init(process: XDProcess, registers: [Int: Int]) {
		pokemon = XDBattlePokemon(file: process, offset: registers[3] ?? 0)
		moveRoutinePointer = registers[7] ?? 0
		let parameter = registers[8] ?? 0
		let type = registers[5] ?? 0
		switch type {
		case  9: option = .switchPokemon(index: parameter)
		case 10: option = .call
		case 18: option = .item(item: .index(parameter))
		case 19: option = .fight(move: .index(parameter))
		default: option = .unknown(id: type, parameter: parameter)
		}
		super.init()
	}

	override func getRegisters() -> [Int: Int] {
		return [
			3: pokemon.battleDataOffset,
			5: option.optionID,
			8: option.parameter
		]
	}

	required init(from decoder: Decoder) throws { fatalError("-") }
}

class WillUseMoveContext: BreakPointContext {
	var move: XGMoves
	var attackingPokemon: XDBattlePokemon

	override init(process: XDProcess, registers: [Int: Int]) {
		move = .index(registers[24] ?? 0)
		attackingPokemon = XDBattlePokemon(file: process, offset: registers[28] ?? 0)
		super.init()
	}

	override func getRegisters() -> [Int: Int] {
		return [24: move.index, 28: attackingPokemon.battleDataOffset]
	}

	required init(from decoder: Decoder) throws { fatalError("-") }
}

class WillCallPokemonContext: BreakPointContext {
	var pokemon: XDBattlePokemon

	override init(process: XDProcess, registers: [Int: Int]) {
		pokemon = XDBattlePokemon(file: process, offset: registers[3] ?? 0)
		super.init()
	}

	override func getRegisters() -> [Int: Int] {
		return [3: pokemon.battleDataOffset]
	}

	required init(from decoder: Decoder) throws { fatalError("-") }
}

//class PokemonSwitchInContext: BreakPointContext {
//	var pokemon: XDBattlePokemon
//	var trainer: XDTrainer?
//	let trainerPointer: Int
//
//	override init(process: XDProcess, registers: [Int: Int]) {
//		pokemon = XDBattlePokemon(file: process, offset: registers[30] ?? 0)
//		trainerPointer = registers[3] ?? 0
//		trainer = XDTrainer(file: process, offset: trainerPointer)
//		super.init()
//	}
//
//	override func getRegisters() -> [Int: Int] {
//		return [3: trainerPointer, 30: pokemon.battleDataOffset]
//	}
//
//	required init(from decoder: Decoder) throws { fatalError("-") }
//}
//
//class ShadowPokemonEncounterContext: BreakPointContext {
//	var pokemon: XDBattlePokemon
//
//	override init(process: XDProcess, registers: [Int: Int]) {
//		pokemon = XDBattlePokemon(file: process, offset: registers[29] ?? 0)
//		super.init()
//	}
//
//	override func getRegisters() -> [Int: Int] {
//		return [29: pokemon.battleDataOffset]
//	}
//
//	required init(from decoder: Decoder) throws { fatalError("-") }
//}
//
//class ShadowPokemonFledContext: BreakPointContext {
//	var pokemon: XDPartyPokemon
//
//	override init(process: XDProcess, registers: [Int: Int]) {
//		pokemon = XDPartyPokemon(file: process, offset: registers[28] ?? 0)
//		super.init()
//	}
//
//	override func getRegisters() -> [Int: Int] {
//		return [28: pokemon.partyDataOffset]
//	}
//
//	required init(from decoder: Decoder) throws { fatalError("-") }
//}
//
//class ReverseModeContext: BreakPointContext {
//	var pokemon: XDBattlePokemon
//
//	override init(process: XDProcess, registers: [Int: Int]) {
//		pokemon = XDBattlePokemon(file: process, offset: registers[30] ?? 0)
//		super.init()
//	}
//
//	override func getRegisters() -> [Int: Int] {
//		return [30: pokemon.battleDataOffset]
//	}
//
//	required init(from decoder: Decoder) throws { fatalError("-") }
//}
//
//class UseItemContext: BreakPointContext {
//	var pokemon: XDBattlePokemon
//	var item: XGItems
//
//	override init(process: XDProcess, registers: [Int: Int]) {
//		pokemon = XDBattlePokemon(file: process, offset: registers[5] ?? 0)
//		item = .index(registers[6] ?? 0)
//		super.init()
//	}
//
//	override func getRegisters() -> [Int: Int] {
//		return [5: pokemon.battleDataOffset, 6: item.index]
//	}
//
//	required init(from decoder: Decoder) throws { fatalError("-") }
//}
//
//class UseCologneContext: BreakPointContext {
//	var partyPokemonIndex: Int
//
//	override init(process: XDProcess, registers: [Int: Int]) {
//		partyPokemonIndex = registers[31] ?? 0
//		super.init()
//	}
//
//	override func getRegisters() -> [Int: Int] {
//		return [31: partyPokemonIndex]
//	}
//
//	required init(from decoder: Decoder) throws { fatalError("-") }
//}
//
//class WillUseTMContext: BreakPointContext {
//	var tm: XGTMs
//	var hmIndex: Int
//	var item: XGItems
//
//	override init(process: XDProcess, registers: [Int: Int]) {
//		item = .index(registers[25] ?? 0)
//		tm = .tm(registers[29] ?? 0)
//		hmIndex = registers[30] ?? 0
//		super.init()
//	}
//
//	override func getRegisters() -> [Int: Int] {
//		return [25: item.index, 29: tm.index, 30: hmIndex]
//	}
//
//	required init(from decoder: Decoder) throws { fatalError("-") }
//}
//
//class DidUseTMContext: BreakPointContext {
//	var tm: XGTMs
//	var hmIndex: Int
//	var item: XGItems
//	var partyPokemonIndex: Int
//	var wasSuccessful: Bool
//
//	override init(process: XDProcess, registers: [Int: Int]) {
//		item = .index(registers[25] ?? 0)
//		wasSuccessful = (registers[26] ?? 0) == 1
//		partyPokemonIndex = registers[27] ?? 0
//		tm = .tm(registers[29] ?? 0)
//		hmIndex = registers[30] ?? 0
//		super.init()
//	}
//
//	override func getRegisters() -> [Int: Int] {
//		return [25: item.index, 29: tm.index, 30: hmIndex]
//	}
//
//	required init(from decoder: Decoder) throws { fatalError("-") }
//}
//
//class ExpGainContext: BreakPointContext {
//	let pokemon: XDBattlePokemon
//	var exp: Int
//
//	override init(process: XDProcess, registers: [Int: Int]) {
//		pokemon = XDBattlePokemon(file: process, offset: registers[19] ?? 0)
//		exp = registers[18] ?? 0
//		super.init()
//	}
//
//	override func getRegisters() -> [Int: Int] {
//		return [18: exp, 19: pokemon.battleDataOffset]
//	}
//
//	required init(from decoder: Decoder) throws { fatalError("-") }
//}
//
//class WillEvolveContext: BreakPointContext {
//	var pokemon: XDPartyPokemon
//	let pokemonOffset: Int
//	var evolvedForm: XGPokemon
//
//	override init(process: XDProcess, registers: [Int: Int]) {
//		pokemonOffset = registers[3] ?? 0
//		pokemon = XDPartyPokemon(file: process, offset: pokemonOffset)
//		evolvedForm = .index(registers[4] ?? 0)
//		super.init()
//	}
//
//	override func getRegisters() -> [Int: Int] {
//		return [3: pokemonOffset, 4: evolvedForm.index]
//	}
//
//	required init(from decoder: Decoder) throws { fatalError("-") }
//}
//
//class DidEvolveContext: BreakPointContext {
//	var pokemon: XDPartyPokemon
//
//	override init(process: XDProcess, registers: [Int: Int]) {
//		pokemon = XDPartyPokemon(file: process, offset: registers[27] ?? 0)
//		super.init()
//	}
//
//	override func getRegisters() -> [Int: Int] {
//		return [27: pokemon.partyDataOffset]
//	}
//
//	required init(from decoder: Decoder) throws { fatalError("-") }
//}
//
//class DidPurifyContext: BreakPointContext {
//	var pokemon: XDPartyPokemon
//	let pokemonOffset: Int
//
//	override init(process: XDProcess, registers: [Int: Int]) {
//		pokemonOffset = registers[31] ?? 0
//		pokemon = XDPartyPokemon(file: process, offset: pokemonOffset)
//		super.init()
//	}
//
//	override func getRegisters() -> [Int: Int] {
//		return [31: pokemonOffset]
//	}
//
//	required init(from decoder: Decoder) throws { fatalError("-") }
//}
//
//class BattleStartContext: BreakPointContext {
//	var battle: XGBattle?
//	let battleID: Int
//
//	override init(process: XDProcess, registers: [Int: Int]) {
//		battleID = registers[3] ?? 0
//		battle = XGBattle(index: battleID)
//		super.init()
//	}
//
//	override func getRegisters() -> [Int: Int] {
//		return [3: battleID]
//	}
//
//	required init(from decoder: Decoder) throws { fatalError("-") }
//}
//
//class BattleEndContext: BreakPointContext {
//	var result: XGBattleResult?
//
//	override init(process: XDProcess, registers: [Int: Int]) {
//		result = XGBattleResult(rawValue: registers[3] ?? 0) ?? .unknown1
//		super.init()
//	}
//
//	override func getRegisters() -> [Int: Int] {
//		var registers: [Int: Int] = [:]
//		if let result = result {
//			registers[3] = result.rawValue
//		}
//		return registers
//	}
//
//	required init(from decoder: Decoder) throws { fatalError("-") }
//}
//
//class TurnStartContext: BreakPointContext {
//	var pokemon: XDPartyPokemon
//	let pokemonPointer: Int
//
//	override init(process: XDProcess, registers: [Int: Int]) {
//		pokemonPointer = registers[3] ?? 0
//		pokemon = XDPartyPokemon(file: process, offset: pokemonPointer)
//		super.init()
//	}
//
//	override func getRegisters() -> [Int: Int] {
//		return [3: pokemonPointer]
//	}
//
//	required init(from decoder: Decoder) throws { fatalError("-") }
//}
//
//class BattleDamageHealingContext: BreakPointContext {
//	var attackingPokemon: XDBattlePokemon
//	var defendingPokemon: XDBattlePokemon
//
//	override init(process: XDProcess, registers: [Int: Int]) {
//		attackingPokemon = XDBattlePokemon(file: process, offset: registers[26] ?? 0)
//		defendingPokemon = XDBattlePokemon(file: process, offset: registers[29] ?? 0)
//		super.init()
//	}
//
//	override func getRegisters() -> [Int: Int] {
//		return [26: attackingPokemon.battleDataOffset, 29: defendingPokemon.battleDataOffset]
//	}
//
//	required init(from decoder: Decoder) throws { fatalError("-") }
//}
//
//class PokemonFaintedContext: BreakPointContext {
//	var attackingPokemon: XDBattlePokemon
//	var defendingPokemon: XDBattlePokemon
//
//	override init(process: XDProcess, registers: [Int: Int]) {
//		attackingPokemon = XDBattlePokemon(file: process, offset: registers[29] ?? 0)
//		defendingPokemon = XDBattlePokemon(file: process, offset: registers[31] ?? 0)
//		super.init()
//	}
//
//	override func getRegisters() -> [Int: Int] {
//		return [29: attackingPokemon.battleDataOffset, 31: defendingPokemon.battleDataOffset]
//	}
//
//	required init(from decoder: Decoder) throws { fatalError("-") }
//}
//
//class CaptureAttemptContext: BreakPointContext {
//	var pokemon: XDPartyPokemon
//	let pokemonOffset: Int
//	var pokeball: XGItems
//	var baseCatchRate: Int
//	var shadowID: Int
//	let shadowData: XGDeckPokemon
//	let foeTrainer: XDTrainer
//	var maxHP: Int
//	var currentHP: Int
//	var level: Int
//	var roomType: Int
//	var species: XGPokemon
//
//	override init(process: XDProcess, registers: [Int: Int]) {
//		species = .index(registers[19] ?? 0)
//		maxHP = registers[20] ?? 0
//		currentHP = registers[21] ?? 0
//		level = registers[22] ?? 0
//		roomType = registers[23] ?? 0
//		pokemonOffset = registers[26] ?? 0
//		pokemon = XDPartyPokemon(file: process, offset: pokemonOffset)
//		pokeball = .index(registers[24] ?? 0)
//		shadowID = registers[25] ?? 0
//		shadowData = .ddpk(shadowID)
//		baseCatchRate = registers[29] ?? 0
//		foeTrainer = XDTrainer(file: process, offset: registers[30] ?? 0)
//		super.init()
//	}
//
//	override func getRegisters() -> [Int: Int] {
//		return [
//			19: species.index,
//			20: maxHP,
//			21: currentHP,
//			22: level,
//			23: roomType,
//			24: pokeball.index,
//			25: shadowID,
//			26: pokemonOffset,
//			29: baseCatchRate
//		]
//	}
//
//	required init(from decoder: Decoder) throws { fatalError("-") }
//}
//
//class CaptureAttemptedContext: BreakPointContext {
//	var pokemon: XDBattlePokemon
//	let numberOfShakes: Int
//
//	override init(process: XDProcess, registers: [Int: Int]) {
//		pokemon = XDBattlePokemon(file: process, offset: registers[27] ?? 0)
//		numberOfShakes = registers[28] ?? 0
//		super.init()
//	}
//
//	override func getRegisters() -> [Int: Int] {
//		return [27: pokemon.battleDataOffset, 28: numberOfShakes]
//	}
//
//	required init(from decoder: Decoder) throws { fatalError("-") }
//}
//
//
//class ReceiveGiftPokemonContext: BreakPointContext {
//	let pokemon: XGGiftPokemon
//	var giftID: Int
//
//	override init(process: XDProcess, registers: [Int: Int]) {
//		giftID = registers[3] ?? 0
//		pokemon = XGGiftPokemonManager.giftWithID(giftID)
//		super.init()
//	}
//
//	override func getRegisters() -> [Int: Int] {
//		return [3: giftID]
//	}
//
//	required init(from decoder: Decoder) throws { fatalError("-") }
//}
//
//class PrintContext: BreakPointContext {
//	var offset: Int
//	let string: String
//
//	override init(process: XDProcess, registers: [Int: Int]) {
//		offset = registers[3] ?? 0
//		string = offset > 0x80000000 ? process.readString(atAddress: offset, charLength: .char) : ""
//		super.init()
//	}
//
//	override func getRegisters() -> [Int: Int] {
//		return [3: offset]
//	}
//
//	required init(from decoder: Decoder) throws { fatalError("-") }
//}
//
//class WildBattleContext: BreakPointContext {
//	var trainer: XDTrainer?
//	let trainerPointer: Int
//
//	override init(process: XDProcess, registers: [Int: Int]) {
//		trainerPointer = registers[26] ?? 0
//		trainer = XDTrainer(file: process, offset: trainerPointer)
//		super.init()
//	}
//
//	override func getRegisters() -> [Int: Int] {
//		return [26: trainerPointer]
//	}
//
//	required init(from decoder: Decoder) throws { fatalError("-") }
//}

class ConfirmPokemonReleaseContext: BreakPointContext {
	var shouldRelease: Bool
	var pokemon: XDPartyPokemon

	override init(process: XDProcess, registers: [Int: Int]) {
		shouldRelease = registers[3]?.boolean ?? false
		pokemon = XDPartyPokemon(file: process, offset: registers[31] ?? 0)
		super.init()
	}

	override func getRegisters() -> [Int: Int] {
		return [3: shouldRelease ? 1 : 0, 31: pokemon.partyDataOffset]
	}

	required init(from decoder: Decoder) throws { fatalError("-") }
}

class PokemonReleaseContext: BreakPointContext {
	var pokemon: XDPartyPokemon

	override init(process: XDProcess, registers: [Int: Int]) {
		pokemon = XDPartyPokemon(file: process, offset: registers[31] ?? 0)
		super.init()
	}

	override func getRegisters() -> [Int: Int] {
		return [31: pokemon.partyDataOffset]
	}

	required init(from decoder: Decoder) throws { fatalError("-") }
}
