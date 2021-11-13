//
//  CMBreakPoints.swift
//  GoD Tool
//
//  Created by Stars Momodu on 10/11/2021.
//

import Foundation

enum XDBreakPointTypes: Int, CaseIterable {
	case clear = 0
	case onFrameAdvance
	case onWillRenderFrame
	case onDidRNGRoll
	case onStepCount
	case onDidLoadSave
	case onWillWriteSave
	case onWillChangeMap
	case onDidChangeMapOrMenu
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
	case onBattleDamageOrHealing
	case onPokemonDidFaint
	case onWillAttemptPokemonCapture
	case onDidSucceedPokemonCapture
	case onDidFailPokemonCapture
	case onWillGetFlag
	case onWillSetFlag
	case onReceivedGiftPokemon
	case onReceivedItem
	case onHealTeam
	case onNewGameStart
	case onPrint
	case onSoftReset
	case onInconsistentState

	case yield = 0x7FFE
	case forcedReturn = 0x7FFF

	var addresses: [Int]? {
		switch self {
		case .onFrameAdvance:
			switch region {
			case .US: return nil
			default: return nil
			}
		case .onWillRenderFrame:
			switch region {
			case .US: return nil
			default: return nil
			}
		case .onDidRNGRoll:
			switch region {
			case .US: return nil
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
			case .US: return nil
			default: return nil
			}
		case .onDidLoadSave:
			switch region {
			case .US: return nil
			default: return nil
			}
		case .onWillWriteSave:
			switch region {
			case .US: return nil
			default: return nil
			}
		case .onWillChangeMap:
			switch region {
			case .US: return nil
			default: return nil
			}
		case .onDidChangeMapOrMenu:
			switch region {
			case .US: return nil
			default: return nil
			}
		case .onDidConfirmMoveSelection:
			switch region {
			case .US: return nil
			default: return nil
			}
		case .onDidConfirmTurnSelection:
			switch region {
			case .US: return nil
			default: return nil
			}
		case .onWillUseMove:
			switch region {
			case .US: return nil
			default: return nil
			}
		case .onMoveEnd:
			switch region {
			case .US: return nil
			default: return nil
			}
		case .onWillCallPokemon:
			switch region {
			case .US: return nil
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
