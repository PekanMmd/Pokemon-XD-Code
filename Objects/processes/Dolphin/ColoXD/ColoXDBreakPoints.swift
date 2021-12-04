//
//  ColoXDBreakPoints.swift
//  GoD Tool
//
//  Created by Stars Momodu on 15/11/2021.
//

import Foundation

enum XDBreakPointTypes: Int, CaseIterable {
	case clear = 0
	case onFrameAdvance
	case onWillRenderFrame
	case onDidRNGRoll
	case onStepCount
	case onDidReadOrWriteSave
	case onWillWriteSave
	case onWillChangeMap
	case onDidChangeMap
	case onDidChangeMenuMap
	case onDidConfirmMoveSelection
	case onDidConfirmTurnSelection
	case onWillUseMove
	case onMoveEnd
	case onWillCallPokemon
	case onPokemonWillSwitchIntoBattle
	case onShadowPokemonEncountered
	case onShadowPokemonFled
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
	case onMirorRadarActiveAtColosseum
	case onMirorRadarActiveAtPokespot
	case onMirorRadarLostSignal
	case onSpotMonitorActivated
	case onWildBattleGenerated
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
}
