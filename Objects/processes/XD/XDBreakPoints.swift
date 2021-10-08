//
//  XDBreakPoints.swift
//  GoD Tool
//
//  Created by Stars Momodu on 29/09/2021.
//

import Foundation

enum XDBreakPointTypes: Int, CaseIterable {
	case onFrameAdvance = 1
	case onDidRNGRoll
	case onStepCount
	case onDidLoadSave
	case onWillWriteSave
	case onWillChangeMap
	case onDidChangeMap
	case onDidConfirmMoveSelection
	case onDidConfirmTurnSelection
	case onWillUseMove
	case onMoveEnd
	case onWillCallPokemon
	case onPokemonWillSwitchIntoBattle
	case onShadowPokemonEncountered
	case onShadowPokemonDidEnterReverseMode
	case onWillUseItem
	case onWillUseCologne
	case onWillUseTM
	case onDidUseTM
	case onWillGainExp
	case onLevelUp
	case onWillEvolve
	case onDidEvolve
	case onDidPurification
	case onWillStartBattle
	case onDidEndBattle
	case onBattleWhiteout
	case onBattleTurnStart
	case onBattleTurnEnd
	case onPokemonTurnStart
	case onPokemonTurnEnd
	case onPokemonDidFaint
	case onWillAttemptPokemonCapture
	case onDidSucceedPokemonCapture
	case onDidFailPokemonCapture
	case onMirorRadarActive
	case onMirorRadarLostSignal
	case onSpotMonitorActivated
	case onWillGetFlag
	case onWillSetFlag
	case onReceivedGiftPokemon
	case onReceivedItem
	case onHealTeam
	case onNewGameStart
	case onPrint
	case onSoftReset
	case onInconsistentState

	case forcedReturn = 0x7FFE
	case yield = 0x7FFF

	var addresses: [Int]? {
		switch self {
		case .onDidRNGRoll:
			switch region {
			case .US: return [0x8025ca34]
			default: return nil
			}
		case .onWillGetFlag:
			switch region {
			case .US: return [0x801a0374]
			default: return nil
			}
		case .onWillSetFlag:
			switch region {
			case .US: return [0x801a03a4]
			default: return nil
			}
		case .onFrameAdvance:
			switch region {
			case .US: return [0x802af65c]
			default: return nil
			}
		case .onStepCount:
			switch region {
			case .US: return [0x8014f918]
			default: return nil
			}
		case .onDidLoadSave:
			switch region {
			case .US: return [0x801ce874]
			default: return nil
			}
		case .onWillWriteSave:
			switch region {
			case .US: return [0x801cd160]
			default: return nil
			}
		case .onWillChangeMap:
			switch region {
			case .US: return [0x80120304]
			default: return nil
			}
		case .onDidChangeMap:
			switch region {
			case .US: return [0x80120650]
			default: return nil
			}
		case .onDidConfirmMoveSelection:
			switch region {
			case .US: return [0x802043d0]
			default: return nil
			}
		case .onDidConfirmTurnSelection:
			switch region {
			case .US: return [0x8020446c]
			default: return nil
			}
		case .onWillUseMove:
			switch region {
			case .US: return [0x8020ed90]
			default: return nil
			}
		case .onMoveEnd:
			switch region {
			case .US: return [0x8020f0d0]
			default: return nil
			}
		case .onWillCallPokemon:
			switch region {
			case .US: return [0x8020f104]
			default: return nil
			}
		case .onPokemonWillSwitchIntoBattle:
			switch region {
			case .US: return [0x8021b388]
			default: return nil
			}
		case .onShadowPokemonEncountered:
			switch region {
			case .US: return [0x802263ac]
			default: return nil
			}
		case .onShadowPokemonDidEnterReverseMode:
			switch region {
			case .US: return [0x802269a4]
			default: return nil
			}
		case .onWillUseItem:
			switch region {
			case .US: return [0x8015f438]
			default: return nil
			}
		case .onWillUseCologne:
			switch region {
			case .US: return [0x800a546c]
			default: return nil
			}
		case .onWillUseTM:
			switch region {
			case .US: return [0x800a5094]
			default: return nil
			}
		case .onDidUseTM:
			switch region {
			case .US: return [0x800a5140]
			default: return nil
			}
		case .onWillGainExp:
			switch region {
			case .US: return [0x80212e80]
			default: return nil
			}
		case .onLevelUp:
			#warning("TODO: find a good way to break on level up")
			return nil
		case .onWillEvolve:
			switch region {
			case .US: return [0x80149cf0]
			default: return nil
			}
		case .onDidEvolve:
			switch region {
			case .US: return [0x80149d5c]
			default: return nil
			}
		case .onDidPurification:
			switch region {
			case .US: return [0x8023370c]
			default: return nil
			}
		case .onWillStartBattle:
			switch region {
			case .US: return [0x801f0e94]
			default: return nil
			}
		case .onDidEndBattle:
			switch region {
			case .US: return [0x801f11a4]
			default: return nil
			}
		case .onBattleWhiteout:
			switch region {
			case .US: return [0x80209590]
			default: return nil
			}
		case .onBattleTurnStart:
			switch region {
			case .US: return [0x80209e88]
			default: return nil
			}
		case .onBattleTurnEnd:
			switch region {
			case .US: return [0x80209f1c]
			default: return nil
			}
		case .onPokemonTurnStart:
			switch region {
			case .US: return [0x80209b40]
			default: return nil
			}
		case .onPokemonTurnEnd:
			switch region {
			case .US: return [0x80209c3c]
			default: return nil
			}
		case .onPokemonDidFaint:
			switch region {
			case .US: return [0x80213b24]
			default: return nil
			}
		case .onWillAttemptPokemonCapture:
			switch region {
			case .US: return [0x80219304] 
			default: return nil
			}
		case .onDidSucceedPokemonCapture:
			switch region {
			case .US: return [0x80219700]
			default: return nil
			}
		case .onDidFailPokemonCapture:
			switch region {
			case .US: return [0x80219798]
			default: return nil
			}
		case .onMirorRadarActive:
			switch region {
			case .US: return [0x80296414, 0x80296680]
			default: return nil
			}
		case .onMirorRadarLostSignal:
			switch region {
			case .US: return [0x80295e50, 0x80295ed8]
			default: return nil
			}
		case .onSpotMonitorActivated:
			switch region {
			case .US: return [0x8005f49c]
			default: return nil
			}
		case .onReceivedGiftPokemon:
			switch region {
			case .US: return [0x801c86e0]
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
		case .onPrint:
			switch region {
			case .US: return [0x800abc80]
			default: return nil
			}
		case .onSoftReset:
			switch region {
			case .US: return [0x8005cb38]
			default: return nil
			}
		case .onInconsistentState:
			return nil
		case .forcedReturn:
			return nil
		case .yield:
			return nil
		}
	}

	var forcedReturnValueAddress: Int? {
		switch self {
		case .onWillGetFlag:
			switch region {
			case .US: return 0x801a03a0
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

class GetFlagContext: BreakPointContext {
	var flagID: Int

	override init(process: XDProcess, registers: [Int: Int]) {
		flagID = registers[3] ?? 0
		super.init()
	}

	override func getRegisters() -> [Int: Int] {
		return [3: flagID]
	}

	required init(from decoder: Decoder) throws { fatalError("-") }
}

class SetFlagContext: BreakPointContext {
	var flagID: Int
	var value: Int

	override init(process: XDProcess, registers: [Int: Int]) {
		flagID = registers[3] ?? 0
		value = registers[4] ?? 0
		super.init()
	}

	override func getRegisters() -> [Int: Int] {
		return [3: flagID, 4: value]
	}

	required init(from decoder: Decoder) throws { fatalError("-") }

	func setReturnValue(_ to: Int) {
		forcedReturnValue = to
	}

	func getForcedReturnValue() -> Int? {
		return forcedReturnValue
	}
}

class SaveLoadedContext: BreakPointContext {
	enum Status: Int, Codable {
		case cancelled = -1, success = 3, noSaveData = 5, unknown = -2
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

class MapWillChangeContext: BreakPointContext {
	var nextRoom: XGRoom
	var startingPointIndex: Int

	override init(process: XDProcess, registers: [Int: Int]) {
		nextRoom = XGRoom.roomWithID(registers[3] ?? 0) ?? XGRoom(index: 0)
		startingPointIndex = registers[5] ?? 0
		super.init()
	}

	override func getRegisters() -> [Int: Int] {
		return [3: nextRoom.roomID, 5: startingPointIndex]
	}

	required init(from decoder: Decoder) throws { fatalError("-") }
}

class MapDidChangeContext: BreakPointContext {
	let newRoom: XGRoom

	override init(process: XDProcess, registers: [Int: Int]) {
		let currentRoomID = process.read2Bytes(atAddress: kCurrentRoomIDRAMOffset) ?? 0
		newRoom = XGRoom.roomWithID(currentRoomID) ?? XGRoom(index: 0)
		super.init()
	}

	override func getRegisters() -> [Int: Int] {
		return [:]
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
	let pokemonPointer: Int
	var move: XGMoves
	var targets: Targets
	var selectedMoveIndex: Int
	var pokemon: XDBattlePokemon?

	override init(process: XDProcess, registers: [Int: Int]) {
		pokemonPointer = registers[3] ?? 0
		moveRoutinePointer = registers[7] ?? 0
		move = .index( registers[8] ?? 0)
		targets = Targets(rawValue: registers[9] ?? 0) ?? .none
		if targets == .none {
			printg("Undocumented move targets case \(registers[9] ?? 0) for move \(move.name.string)")
		}
		selectedMoveIndex = registers[10] ?? 0
		pokemon = XDBattlePokemon(pointerOffset: pokemonPointer, process: process)
		super.init()
	}

	override func getRegisters() -> [Int: Int] {
		return [
			3: pokemonPointer,
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
	let pokemonPointer: Int
	var pokemon: XDBattlePokemon?
	var option: Option

	override init(process: XDProcess, registers: [Int: Int]) {
		pokemonPointer = registers[3] ?? 0
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
		pokemon = XDBattlePokemon(pointerOffset: pokemonPointer, process: process)
		super.init()
	}

	override func getRegisters() -> [Int: Int] {
		return [
			3: pokemonPointer,
			5: option.optionID,
			8: option.parameter
		]
	}

	required init(from decoder: Decoder) throws { fatalError("-") }
}

class WillUseMoveContext: BreakPointContext {
	var move: XGMoves
	var attackingPokemon: XDBattlePokemon?
	let attackingPokemonPointer: Int

	override init(process: XDProcess, registers: [Int: Int]) {
		move = .index(registers[24] ?? 0)
		attackingPokemonPointer = registers[27] ?? 0
		attackingPokemon = XDBattlePokemon(pointerOffset: attackingPokemonPointer, process: process)
		super.init()
	}

	override func getRegisters() -> [Int: Int] {
		return [24: move.index, 27: attackingPokemonPointer]
	}

	required init(from decoder: Decoder) throws { fatalError("-") }
}

class WillCallPokemonContext: BreakPointContext {
	var pokemon: XDBattlePokemon?
	let pokemonPointer: Int

	override init(process: XDProcess, registers: [Int: Int]) {
		pokemonPointer = registers[3] ?? 0
		pokemon = XDBattlePokemon(pointerOffset: pokemonPointer, process: process)
		super.init()
	}

	override func getRegisters() -> [Int: Int] {
		return [3: pokemonPointer]
	}

	required init(from decoder: Decoder) throws { fatalError("-") }
}

class PokemonSwitchInContext: BreakPointContext {
	var pokemon: XDBattlePokemon?
	let pokemonPointer: Int
	var trainer: XDTrainer?
	let trainerPointer: Int

	override init(process: XDProcess, registers: [Int: Int]) {
		pokemonPointer = registers[30] ?? 0
		pokemon = XDBattlePokemon(pointerOffset: pokemonPointer, process: process)
		trainerPointer = registers[3] ?? 0
		trainer = XDTrainer(offset: trainerPointer, process: process)
		super.init()
	}

	override func getRegisters() -> [Int: Int] {
		return [3: trainerPointer, 30: pokemonPointer]
	}

	required init(from decoder: Decoder) throws { fatalError("-") }
}

class ShadowPokemonEncounterContext: BreakPointContext {
	var pokemon: XDBattlePokemon?
	let pokemonPointer: Int

	override init(process: XDProcess, registers: [Int: Int]) {
		pokemonPointer = registers[29] ?? 0
		pokemon = XDBattlePokemon(pointerOffset: pokemonPointer, process: process)
		super.init()
	}

	override func getRegisters() -> [Int: Int] {
		return [29: pokemonPointer]
	}

	required init(from decoder: Decoder) throws { fatalError("-") }
}

class ReverseModeContext: BreakPointContext {
	var pokemon: XDBattlePokemon?
	let pokemonPointer: Int

	override init(process: XDProcess, registers: [Int: Int]) {
		pokemonPointer = registers[30] ?? 0
		pokemon = XDBattlePokemon(pointerOffset: pokemonPointer, process: process)
		super.init()
	}

	override func getRegisters() -> [Int: Int] {
		return [30: pokemonPointer]
	}

	required init(from decoder: Decoder) throws { fatalError("-") }
}

class UseItemContext: BreakPointContext {
	var pokemon: XDBattlePokemon?
	let pokemonPointer: Int
	var item: XGItems

	override init(process: XDProcess, registers: [Int: Int]) {
		pokemonPointer = registers[5] ?? 0
		pokemon = XDBattlePokemon(pointerOffset: pokemonPointer, process: process)
		item = .index(registers[6] ?? 0)
		super.init()
	}

	override func getRegisters() -> [Int: Int] {
		return [5: pokemonPointer, 6: item.index]
	}

	required init(from decoder: Decoder) throws { fatalError("-") }
}

class UseCologneContext: BreakPointContext {
	var partyPokemonIndex: Int

	override init(process: XDProcess, registers: [Int: Int]) {
		partyPokemonIndex = registers[31] ?? 0
		super.init()
	}

	override func getRegisters() -> [Int: Int] {
		return [31: partyPokemonIndex]
	}

	required init(from decoder: Decoder) throws { fatalError("-") }
}

class WillUseTMContext: BreakPointContext {
	var tm: XGTMs
	var hmIndex: Int
	var item: XGItems

	override init(process: XDProcess, registers: [Int: Int]) {
		item = .index(registers[25] ?? 0)
		tm = .tm(registers[29] ?? 0)
		hmIndex = registers[30] ?? 0
		super.init()
	}

	override func getRegisters() -> [Int: Int] {
		return [25: item.index, 29: tm.index, 30: hmIndex]
	}

	required init(from decoder: Decoder) throws { fatalError("-") }
}

class DidUseTMContext: BreakPointContext {
	var tm: XGTMs
	var hmIndex: Int
	var item: XGItems
	var partyPokemonIndex: Int
	var wasSuccessful: Bool

	override init(process: XDProcess, registers: [Int: Int]) {
		item = .index(registers[25] ?? 0)
		wasSuccessful = (registers[26] ?? 0) == 1
		partyPokemonIndex = registers[27] ?? 0
		tm = .tm(registers[29] ?? 0)
		hmIndex = registers[30] ?? 0
		super.init()
	}

	override func getRegisters() -> [Int: Int] {
		return [25: item.index, 29: tm.index, 30: hmIndex]
	}

	required init(from decoder: Decoder) throws { fatalError("-") }
}

class ExpGainContext: BreakPointContext {
	let pokemon: XDBattlePokemon?
	let pokemonPointer: Int
	var exp: Int

	override init(process: XDProcess, registers: [Int: Int]) {
		pokemonPointer = registers[19] ?? 0
		pokemon = XDBattlePokemon(pointerOffset: pokemonPointer, process: process)
		exp = registers[18] ?? 0
		super.init()
	}

	override func getRegisters() -> [Int: Int] {
		return [18: exp, 19: pokemonPointer]
	}

	required init(from decoder: Decoder) throws { fatalError("-") }
}

class WillEvolveContext: BreakPointContext {
	var pokemon: XDBattlePokemon?
	let pokemonPointer: Int
	var evolvedForm: XGPokemon

	override init(process: XDProcess, registers: [Int: Int]) {
		pokemonPointer = registers[3] ?? 0
		pokemon = XDBattlePokemon(pointerOffset: pokemonPointer, process: process)
		evolvedForm = .index(registers[4] ?? 0)
		super.init()
	}

	override func getRegisters() -> [Int: Int] {
		return [3: pokemonPointer, 4: evolvedForm.index]
	}

	required init(from decoder: Decoder) throws { fatalError("-") }
}

class DidEvolveContext: BreakPointContext {
	var pokemon: XDBattlePokemon?
	let pokemonPointer: Int

	override init(process: XDProcess, registers: [Int: Int]) {
		pokemonPointer = registers[27] ?? 0
		pokemon = XDBattlePokemon(pointerOffset: pokemonPointer, process: process)
		super.init()
	}

	override func getRegisters() -> [Int: Int] {
		return [27: pokemonPointer]
	}

	required init(from decoder: Decoder) throws { fatalError("-") }
}

class DidPurifyContext: BreakPointContext {
	var pokemon: XDBattlePokemon?
	let pokemonPointer: Int

	override init(process: XDProcess, registers: [Int: Int]) {
		pokemonPointer = registers[31] ?? 0
		pokemon = XDBattlePokemon(pointerOffset: pokemonPointer, process: process)
		super.init()
	}

	override func getRegisters() -> [Int: Int] {
		return [31: pokemonPointer]
	}

	required init(from decoder: Decoder) throws { fatalError("-") }
}

class BattleStartContext: BreakPointContext {
	var battle: XGBattle?
	let battleID: Int

	override init(process: XDProcess, registers: [Int: Int]) {
		battleID = registers[3] ?? 0
		battle = XGBattle(index: battleID)
		super.init()
	}

	override func getRegisters() -> [Int: Int] {
		return [3: battleID]
	}

	required init(from decoder: Decoder) throws { fatalError("-") }
}

class BattleEndContext: BreakPointContext {
	var result: XGBattleResult?

	override init(process: XDProcess, registers: [Int: Int]) {
		result = XGBattleResult(rawValue: registers[3] ?? 0) ?? .unknown1
		super.init()
	}

	override func getRegisters() -> [Int: Int] {
		var registers: [Int: Int] = [:]
		if let result = result {
			registers[3] = result.rawValue
		}
		return registers
	}

	required init(from decoder: Decoder) throws { fatalError("-") }
}

class TurnStartContext: BreakPointContext {
	var pokemon: XDBattlePokemon?
	let pokemonPointer: Int

	override init(process: XDProcess, registers: [Int: Int]) {
		pokemonPointer = registers[3] ?? 0
		pokemon = XDBattlePokemon(offset: pokemonPointer, process: process)
		super.init()
	}

	override func getRegisters() -> [Int: Int] {
		return [3: pokemonPointer]
	}

	required init(from decoder: Decoder) throws { fatalError("-") }
}

class PokemonFaintedContext: BreakPointContext {
	var attackingPokemon: XDBattlePokemon?
	let attackingPokemonPointer: Int
	var defendingPokemon: XDBattlePokemon?
	let defendingPokemonPointer: Int

	override init(process: XDProcess, registers: [Int: Int]) {
		attackingPokemonPointer = registers[29] ?? 0
		attackingPokemon = XDBattlePokemon(pointerOffset: attackingPokemonPointer, process: process)
		defendingPokemonPointer = registers[31] ?? 0
		defendingPokemon = XDBattlePokemon(pointerOffset: defendingPokemonPointer, process: process)
		super.init()
	}

	override func getRegisters() -> [Int: Int] {
		return [29: attackingPokemonPointer, 31: defendingPokemonPointer]
	}

	required init(from decoder: Decoder) throws { fatalError("-") }
}

class CaptureAttemptContext: BreakPointContext {
	var pokemon: XDBattlePokemon?
	let pokemonOffset: Int
	var pokeball: XGItems
	var baseCatchRate: Int
	var shadowID: Int
	let shadowData: XGDeckPokemon
	let foeTrainer: XDTrainer
	var maxHP: Int
	var currentHP: Int
	var level: Int
	var roomType: Int
	private let species: XGPokemon

	override init(process: XDProcess, registers: [Int: Int]) {
		species = .index(registers[19] ?? 0)
		maxHP = registers[20] ?? 0
		currentHP = registers[21] ?? 0
		level = registers[22] ?? 0
		roomType = registers[23] ?? 0
		pokemonOffset = registers[26] ?? 0
		pokemon = XDBattlePokemon(offset: pokemonOffset, process: process)
		pokeball = .index(registers[24] ?? 0)
		shadowID = registers[25] ?? 0
		shadowData = .ddpk(shadowID)
		baseCatchRate = registers[29] ?? 0
		foeTrainer = XDTrainer(offset: registers[30] ?? 0, process: process)
		super.init()
	}

	override func getRegisters() -> [Int: Int] {
		return [
			19: pokemon?.species.index ?? species.index,
			20: maxHP,
			21: currentHP,
			22: level,
			23: roomType,
			24: pokeball.index,
			25: shadowID,
			26: pokemonOffset,
			29: baseCatchRate
		]
	}

	required init(from decoder: Decoder) throws { fatalError("-") }
}

class CaptureAttemptedContext: BreakPointContext {
	var pokemon: XDBattlePokemon?
	let pokemonOffset: Int
	let numberOfShakes: Int

	override init(process: XDProcess, registers: [Int: Int]) {
		pokemonOffset = registers[27] ?? 0
		pokemon = XDBattlePokemon(offset: pokemonOffset, process: process)
		numberOfShakes = registers[28] ?? 0
		super.init()
	}

	override func getRegisters() -> [Int: Int] {
		return [27: pokemonOffset, 28: numberOfShakes]
	}

	required init(from decoder: Decoder) throws { fatalError("-") }
}


class ReceiveGiftPokemonContext: BreakPointContext {
	let pokemon: XGGiftPokemon
	var giftID: Int

	override init(process: XDProcess, registers: [Int: Int]) {
		giftID = registers[3] ?? 0
		pokemon = XGGiftPokemonManager.giftWithID(giftID)
		super.init()
	}

	override func getRegisters() -> [Int: Int] {
		return [3: giftID]
	}

	required init(from decoder: Decoder) throws { fatalError("-") }
}

class PrintContext: BreakPointContext {
	var offset: Int
	let string: String

	override init(process: XDProcess, registers: [Int: Int]) {
		offset = registers[3] ?? 0
		string = offset > 0x80000000 ? process.readString(RAMOffset: offset, charLength: .char) : ""
		super.init()
	}

	override func getRegisters() -> [Int: Int] {
		return [3: offset]
	}

	required init(from decoder: Decoder) throws { fatalError("-") }
}
