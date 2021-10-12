//
//  XDProcessCallbacks.swift
//  GoD Tool
//
//  Created by Stars Momodu on 08/10/2021.
//

import Foundation

class XDProcessSetup {

	private(set) var process: XDProcess?

	init() {}

	func launch(settings: [(key: DolphinSystems, value: String)] = [],
				autoSkipWarningScreen: Bool = false,
				autoCloseDolphinOnFinish: Bool = false,
				onStart: ((XDProcess) -> Bool)?,
				onFinish: (() -> Void)?) {
		XDProcess.launch(settings: settings,
						 autoSkipWarningScreen: autoSkipWarningScreen,
						 autoCloseDolphinOnFinish: autoCloseDolphinOnFinish,
						 onStart: { (process) -> Bool in
							self.process = process
							return onStart?(process) ?? true
						 }, onFinish: onFinish, callbacks: self)
	}

	var onFrame: ((XDProcess, XDGameState) -> Bool)? = nil
	var onRNGRoll: ((RNGRollContext, XDProcess, XDGameState) -> Bool)? = nil
	var onStep: ((XDProcess, XDGameState) -> Bool)? = nil
	var onDidLoadSave: ((SaveLoadedContext, XDProcess, XDGameState) -> Bool)? = nil
	var onWillWriteSave: ((XDProcess, XDGameState) -> Bool)? = nil
	var onWillChangeMap: ((MapWillChangeContext, XDProcess, XDGameState) -> Bool)? = nil
	var onDidChangeMap: ((MapDidChangeContext, XDProcess, XDGameState) -> Bool)? = nil
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
	var onPokemonFainted: ((PokemonFaintedContext, XDProcess, XDGameState) -> Bool)? = nil
	var onPokeballThrow: ((CaptureAttemptContext, XDProcess, XDGameState) -> Bool)? = nil
	var onCaptureSucceeded: ((CaptureAttemptedContext, XDProcess, XDGameState) -> Bool)? = nil
	var onCaptureFailed: ((CaptureAttemptedContext, XDProcess, XDGameState) -> Bool)? = nil
	var onMirorRadarActivated: ((XDProcess, XDGameState) -> Bool)? = nil
	var onMirorRadarSignalLost: ((XDProcess, XDGameState) -> Bool)? = nil
	var onSpotMonitorActivated: ((XDProcess, XDGameState) -> Bool)? = nil
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
