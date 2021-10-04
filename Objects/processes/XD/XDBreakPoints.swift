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
	case onPokemonWillEnterBattle
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
	case onTeamBlackout
	case onNewGameStart
	case onPrint
	case onReset
	case onInconsistentState

	case forcedReturn = 0x7FFE
	case yield = 0x7FFF

	var address: Int? {
		switch self {
		case .onDidRNGRoll:
			switch region {
			case .US: return 0x8025ca34
			default: return nil
			}
		case .onWillGetFlag:
			switch region {
			case .US: return 0x801a0374
			default: return nil
			}
		case .onWillSetFlag:
			switch region {
			case .US: return 0x801a03a4 // r3 is flag id, r4 is value
			default: return nil
			}
		case .onFrameAdvance:
			switch region {
			case .US: return 0x802af65c
			default: return nil
			}
		case .onStepCount:
			switch region {
			case .US: return 0x8014f918
			default: return nil
			}
		case .onDidLoadSave:
			switch region {
			case .US: return 0x801ce874
			default: return nil
			}
		case .onWillWriteSave:
			switch region {
			case .US: return 0x801cd160
			default: return nil
			}
		case .onWillChangeMap:
			switch region {
			case .US: return 0x80120304
			default: return nil
			}
		case .onDidChangeMap:
			switch region {
			case .US: return 0x80120650
			default: return nil
			}
		case .onDidConfirmMoveSelection:
			switch region {
			case .US: return 0x802043d0 // r3 pokemon pointer, r7 move routine, r8 move id, r9 target mask, r10 move index
			default: return nil
			}
		case .onDidConfirmTurnSelection:
			switch region {
			case .US: return 0x8020446c // r3 pokemon pointer, r5 option type, r8 parameter
			default: return nil
			}
		case .onWillUseMove:
			switch region {
			case .US: return 0x8020ed04 // r4 is move id
			default: return nil
			}
		case .onMoveEnd:
			switch region {
			case .US: return 0x8020f0d0
			default: return nil
			}
		case .onWillCallPokemon:
			switch region {
			case .US: return 0x8020f104 //r3 battle pokemon pointer
			default: return nil
			}
		case .onPokemonWillEnterBattle:
			switch region {
			case .US: return 0x8021b388 //r3 trainer pointer, r30 battle pokemon pointer
			default: return nil
			}
		case .onShadowPokemonEncountered:
			switch region {
			case .US: return 0x802263ac // r29 battle pokemon pointer
			default: return nil
			}
		case .onShadowPokemonDidEnterReverseMode:
			switch region {
			case .US: return 0x802269a4 // r30 battle pokemon pointer
			default: return nil
			}
		case .onWillUseItem:
			switch region {
			case .US: return 0x8015f438 //r5 battle pokemon pointer, r6 item id
			default: return nil
			}
		case .onWillUseCologne:
			switch region {
			case .US: return 0x800a546c // r31 is party index of pokemon
			default: return nil
			}
		case .onWillUseTM:
			switch region {
			case .US: return 0x800a5094 // r30 hm index, r29 tm index, r25 item id
			default: return nil
			}
		case .onDidUseTM:
			switch region {
			case .US: return 0x800a5140 // r30 hm index, r29 tm index, r25 item id, party pokemon index r27, success/fail r26
			default: return nil
			}
		case .onWillGainExp:
			switch region {
			case .US: return 0x80212e80 // r18 exp, r19 battle pokemon pointer (init read only struct)
			default: return nil
			}
		case .onLevelUp:
			#warning("TODO: find a good way to break on level up")
			return nil
		case .onWillEvolve:
			switch region {
			case .US: return 0x80149cf0 // r4 evolved form, r3 battle pokemon pointer
			default: return nil
			}
		case .onDidEvolve:
			switch region {
			case .US: return 0x80149d5c // r22 evolved form, r27 battle pokemon pointer
			default: return nil
			}
		case .onDidPurification:
			switch region {
			case .US: return 0x8023370c // r31 battle pokemon pointer
			default: return nil
			}
		case .onWillStartBattle:
			switch region {
			case .US: return 0x801f0e94 // r3 battle id
			default: return nil
			}
		case .onDidEndBattle:
			switch region {
			case .US: return 0x801f11a4 // r3 battle result
			default: return nil
			}
		case .onBattleTurnStart:
			switch region {
			case .US: return 0x80209e88
			default: return nil
			}
		case .onBattleTurnEnd:
			switch region {
			case .US: return 0x80209f1c
			default: return nil
			}
		case .onPokemonTurnStart:
			switch region {
			case .US: return 0x80209b40 // r3 battle pokemon stats pointer
			default: return nil
			}
		case .onPokemonTurnEnd:
			switch region {
			case .US: return 0x80209c3c
			default: return nil
			}
		case .onPokemonDidFaint:
			switch region {
			case .US: return 0x80213b24 // r31 defending pokemon, r29 attacking pokemon
			default: return nil
			}
		case .onWillAttemptPokemonCapture:
			switch region {
			case .US: return 0x80219304 // r24 pokeball id, r29 catch rate, r19 species, r25 shadow id, r30 foe trainer, r20 max hp, r21 current hp, r26 battle pokemon data, r22 level, r23 room type
			default: return nil
			}
		case .onDidSucceedPokemonCapture:
			switch region {
			case .US: return 0x80219700 // r27 battle pokemon data, r28 number of shakes
			default: return nil
			}
		case .onDidFailPokemonCapture:
			switch region {
			case .US: return 0x80219798 // r27 battle pokemon data, r28 number of shakes
			default: return nil
			}
		case .onMirorRadarActive:
			return nil
		case .onMirorRadarLostSignal:
			return nil
		case .onSpotMonitorActivated:
			return nil
		case .onReceivedGiftPokemon:
			return nil
		case .onReceivedItem:
			return nil
		case .onHealTeam:
			return nil
		case .onTeamBlackout:
			return nil
		case .onNewGameStart:
			return nil
		case .onPrint:
			return nil
		case .onReset:
			return nil
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
			return address
		}
	}
}

class BreakPointContext: Codable {
	private var forcedReturnValue: Int?

	init() {}
	init(process: XDProcess, registers: [Int: Int]) {}
	func getRegisters() -> [Int: Int] { return [:] }

	func setReturnValue(_ to: Int) {
		forcedReturnValue = to
	}

	func getForcedReturnValue() -> Int? {
		return forcedReturnValue
	}
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
	private var forcedReturnValue: Int?

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
	var pokemonPointer: Int
	var move: XGMoves
	var targets: Targets
	var selectedMoveIndex: Int

	override init(process: XDProcess, registers: [Int: Int]) {
		pokemonPointer = registers[3] ?? 0
		moveRoutinePointer = registers[7] ?? 0
		move = .index( registers[8] ?? 0)
		targets = Targets(rawValue: registers[9] ?? 0) ?? .none
		selectedMoveIndex = registers[10] ?? 0
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
	var pokemonPointer: Int
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
