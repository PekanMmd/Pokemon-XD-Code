//
//  CMProcessSetup.swift
//  GoD Tool
//
//  Created by Stars Momodu on 10/11/2021.
//

import Foundation

class CMProcessSetup {

	func launch(processType: XDProcess.ProcessType,
				autoSkipWarningScreen: Bool = false,
				onStart: ((XDProcess) -> Bool)?,
				onFinish: (() -> Void)?) {
		guard let xd = XDProcess(processType: processType) else {
			onFinish?()
			return
		}

		xd.begin(autoSkipWarningScreen: autoSkipWarningScreen,
				 onStart: onStart,
				 onFinish: onFinish,
				 callbacks: self)
	}

	var onFrame: ((XDProcess, XDGameState) -> Bool)? = nil
	var onWillRender: ((RenderFrameBufferContext, XDProcess, XDGameState) -> Bool)? = nil
	var onRNGRoll: ((RNGRollContext, XDProcess, XDGameState) -> Bool)? = nil
	var onStep: ((XDProcess, XDGameState) -> Bool)? = nil
	var onDidLoadSave: ((SaveLoadedContext, XDProcess, XDGameState) -> Bool)? = nil
	var onWillWriteSave: ((XDProcess, XDGameState) -> Bool)? = nil
	var onWillChangeMap: ((MapWillChangeContext, XDProcess, XDGameState) -> Bool)? = nil
	var onDidChangeMapOrMenu: ((MapOrMenuDidChangeContext, XDProcess, XDGameState) -> Bool)? = nil
	var onMoveSelectionConfirmed: ((BattleMoveSelectionContext, XDProcess, XDGameState) -> Bool)? = nil
	var onTurnSelectionConfirmed: ((BattleTurnSelectionContext, XDProcess, XDGameState) -> Bool)? = nil
	var onWillUseMove: ((WillUseMoveContext, XDProcess, XDGameState) -> Bool)? = nil
	var onMoveDidEnd: ((XDProcess, XDGameState) -> Bool)? = nil
	var onWillCallPokemon: ((WillCallPokemonContext, XDProcess, XDGameState) -> Bool)? = nil
	var onPokemonWillSwitchIn: ((PokemonSwitchInContext, XDProcess, XDGameState) -> Bool)? = nil
	var onShadowPokemonEncountered: ((ShadowPokemonEncounterContext, XDProcess, XDGameState) -> Bool)? = nil
	var onShadowPokemonFled: ((ShadowPokemonFledContext, XDProcess, XDGameState) -> Bool)? = nil
	var onPokemonDidEnterReverseMode: ((ReverseModeContext, XDProcess, XDGameState) -> Bool)? = nil
	var onWillUseItem: ((UseItemContext, XDProcess, XDGameState) -> Bool)? = nil
	var onWillUseCologne: ((UseCologneContext, XDProcess, XDGameState) -> Bool)? = nil
	var onWillUseTM: ((WillUseTMContext, XDProcess, XDGameState) -> Bool)? = nil
	var onDidUseTM: ((DidUseTMContext, XDProcess, XDGameState) -> Bool)? = nil
	var onWillGainExp: ((ExpGainContext, XDProcess, XDGameState) -> Bool)? = nil
//	var onLevelUp: ((XDProcess, XDGameState) -> Bool)? = nil
	var onWillEvolve: ((WillEvolveContext, XDProcess, XDGameState) -> Bool)? = nil
	var onDidEvolve: ((DidEvolveContext, XDProcess, XDGameState) -> Bool)? = nil
	var onPurification: ((DidPurifyContext, XDProcess, XDGameState) -> Bool)? = nil
	var onBattleStart: ((BattleStartContext, XDProcess, XDGameState) -> Bool)? = nil
	var onBattleEnd: ((BattleEndContext, XDProcess, XDGameState) -> Bool)? = nil
	var onTeamWhiteOut: ((XDProcess, XDGameState) -> Bool)? = nil
	var onTurnStart: ((TurnStartContext, XDProcess, XDGameState) -> Bool)? = nil
	var onTurnEnd: ((XDProcess, XDGameState) -> Bool)? = nil
	var onBattleDamageOrHealing: ((BattleDamageHealingContext, XDProcess, XDGameState) -> Bool)? = nil
	var onPokemonFainted: ((PokemonFaintedContext, XDProcess, XDGameState) -> Bool)? = nil
	var onPokeballThrow: ((CaptureAttemptContext, XDProcess, XDGameState) -> Bool)? = nil
	var onCaptureSucceeded: ((CaptureAttemptedContext, XDProcess, XDGameState) -> Bool)? = nil
	var onCaptureFailed: ((CaptureAttemptedContext, XDProcess, XDGameState) -> Bool)? = nil
	var onMirorRadarActivatedColosseum: ((XDProcess, XDGameState) -> Bool)? = nil
	var onMirorRadarActivatedPokespot: ((XDProcess, XDGameState) -> Bool)? = nil
	var onMirorRadarSignalLost: ((XDProcess, XDGameState) -> Bool)? = nil
	var onSpotMonitorActivated: ((XDProcess, XDGameState) -> Bool)? = nil
	var onWildBattleGenerated: ((WildBattleContext, XDProcess, XDGameState) -> Bool)? = nil
	var onWillGetFlag: ((GetFlagContext, XDProcess, XDGameState) -> Bool)? = nil
	var onWillSetFlag: ((SetFlagContext, XDProcess, XDGameState) -> Bool)? = nil
	var onReceiveGiftPokemon: ((ReceiveGiftPokemonContext, XDProcess, XDGameState) -> Bool)? = nil
//	var onReceiveItem: ((XDProcess, XDGameState) -> Bool)? = nil
//	var onTeamHealed: ((XDProcess, XDGameState) -> Bool)? = nil
//	var onNewGame: ((XDProcess, XDGameState) -> Bool)? = nil
	var onPrint: ((PrintContext, XDProcess, XDGameState) -> Bool)? = nil
}

extension Dictionary where Key: Equatable, Value: Equatable {
	func isIdenticalTo(_ other: Self) -> Bool {
		for (key, value) in self {
			if other[key] != value {
				return false
			}
		}
		return true
	}
}
