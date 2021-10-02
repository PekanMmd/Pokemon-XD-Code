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
	case onPlayerDidSelectMove
	case onAIDidSelectMove
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
		case .onPlayerDidSelectMove:
			return nil
		case .onAIDidSelectMove:
			#warning("TODO: Research this")
			return nil
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

class RNGRollState: Codable {
	var roll: UInt16
	init(process: XDProcess, registers: [Int: Int]) {
		self.roll = UInt16(registers[3] ?? 0)
	}

	func getRegisters() -> [Int: Int] {
		return [3: Int(roll)]
	}
}

class GetFlagState: Codable {
	var flagID: Int
	private var forcedReturnValue: Int?

	init(process: XDProcess, registers: [Int: Int]) {
		flagID = registers[3] ?? 0
	}

	func getRegisters() -> [Int: Int] {
		return [3: flagID]
	}

	func setReturnValue(_ to: Int) {
		forcedReturnValue = to
	}
}

class SetFlagState: Codable {
	var flagID: Int
	var value: Int

	init(process: XDProcess, registers: [Int: Int]) {
		flagID = registers[3] ?? 0
		value = registers[4] ?? 0
	}

	func getRegisters() -> [Int: Int] {
		return [3: flagID, 4: value]
	}
}

class SaveLoadedState: Codable {
	enum Status: Int, Codable {
		case cancelled = -1, success = 3, noSaveData = 5, unknown = -2
	}
	var status: Status
	init(process: XDProcess, registers: [Int: Int]) {
		status = Status(rawValue: registers[3] ?? 0) ?? .unknown
	}

	func getRegisters() -> [Int: Int] {
		return [3: status.rawValue]
	}
}

class MapChangeState: Codable {
	var nextRoomID: Int
	var startingPointIndex: Int

	init(process: XDProcess, registers: [Int: Int]) {
		nextRoomID = registers[3] ?? 0
		startingPointIndex = registers[5] ?? 0
	}

	func getRegisters() -> [Int: Int] {
		return [3: nextRoomID, 5: startingPointIndex]
	}
}
