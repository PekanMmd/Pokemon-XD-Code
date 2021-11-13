//
//  XDProcess.swift
//  GoD Tool
//
//  Created by Stars Momodu on 10/11/2021.
//

import Foundation

extension XDProcess {

	var injectionPoint: Int {
		switch region {
		case .US: return 0x8005c72c
		default:
			assertionFailure()
			return -1
		}
	}

	var ICFlashInvalidate: Int {
		switch region {
		case .US: return 0x800aad88
		default:
			assertionFailure()
			return -1
		}
	}

	var OSReport: Int {
		switch region {
		case .US: return 0x800abc80
		default:
			assertionFailure()
			return -1
		}
	}

	var GSLog: Int {
		switch region {
		case .US: return 0x802a65cc
		default:
			assertionFailure()
			return -1
		}
	}

	var inputCopyBranch: Int {
		switch region {
		case .US: return 0x80104a30
		default:
			assertionFailure()
			return -1
		}
	}

	var yield: Int {
		switch region {
		case .US: return 0x801034e8
		default:
			assertionFailure()
			return -1
		}
	}

	func getFlag(_ id: Int) -> Int? {
		// Based on Ghidra decomp
		guard id < CommonIndexes.NumberOfFlags.value else { return nil }

		let flagsStart = CommonIndexes.Flags.startOffset + kRELtoRAMOffsetDifference
		let metaDataStart = CommonIndexes.FlagsMetaData.startOffset + kRELtoRAMOffsetDifference
		let flagOffset = flagsStart + (id * 6)
		guard let unknown1 = read2Bytes(atAddress: flagOffset + 2),
			  let unknown4o = readByte(atAddress: flagOffset) else {
			return nil
		}
		let unknown4 = unknown4o & 0x3f
		let unknown3 = unknown1 >> 5
		let unknown5 = unknown1 & 0x1f

		guard let unknownAddress = read4Bytes(atAddress: metaDataStart + (unknown4o >> 3 & 0x18) + 4),
			  unknownAddress > 0 else {
			return nil
		}

		if unknown4 < 2 {
			guard let unknownBaseValue = read4Bytes(atAddress: unknownAddress + (unknown3 * 4)) else { return nil }
			return (unknownBaseValue >> unknown5) & 1
		} else {
			let offset = unknown3 * 4
			guard let unknownA = read4Bytes(atAddress: unknownAddress + offset + 4),
				  let unknownB = read4Bytes(atAddress: unknownAddress + offset),
				  let unknownC = read4Bytes(atAddress: 0x8040b4a0 + (unknown4 * 4)) else { return nil }

			return ((unknownA << (0x20 - unknown5)) | (unknownB >> unknown5))
				& unknownC
		}
	}

	// MARK: - Launch
	func begin(autoSkipWarningScreen: Bool = false,
			   onStart: ((XDProcess) -> Bool)?,
			   onFinish: (() -> Void)?,
			   callbacks: XDProcessSetup) {

		guard region == .US else {
			printg("Couldn't launch XD process for region:", region.name)
			onFinish?()
			return
		}

		var enabledBreakPoints = [XDBreakPointTypes]()
		let breakPoints: [(Any?, XDBreakPointTypes)] = [
			(callbacks.onFrame, .onFrameAdvance),
			(callbacks.onWillRender, .onWillRenderFrame),
			(callbacks.onRNGRoll, .onDidRNGRoll),
			(callbacks.onStep, .onStepCount),
			(callbacks.onDidLoadSave, .onDidLoadSave),
			(callbacks.onWillWriteSave, .onWillWriteSave),
			(callbacks.onWillChangeMap, .onWillChangeMap),
			(callbacks.onDidChangeMapOrMenu, .onDidChangeMapOrMenu),
			(callbacks.onMoveSelectionConfirmed, .onDidConfirmMoveSelection),
			(callbacks.onTurnSelectionConfirmed, .onDidConfirmTurnSelection),
			(callbacks.onWillUseMove, .onWillUseMove),
			(callbacks.onMoveDidEnd, .onMoveEnd),
			(callbacks.onWillCallPokemon, .onWillCallPokemon),
			(callbacks.onPokemonWillSwitchIn, .onPokemonWillSwitchIntoBattle),
			(callbacks.onShadowPokemonEncountered, .onShadowPokemonEncountered),
			(callbacks.onShadowPokemonEncountered, .onShadowPokemonFled),
			(callbacks.onPokemonDidEnterReverseMode, .onShadowPokemonDidEnterReverseMode),
			(callbacks.onWillUseItem, .onWillUseItem),
			(callbacks.onWillUseCologne, .onWillUseCologne),
			(callbacks.onWillUseTM, .onWillUseTM),
			(callbacks.onDidUseTM, .onDidUseTM),
			(callbacks.onWillGainExp, .onWillGainExp),
			(callbacks.onWillEvolve, .onWillEvolve),
			(callbacks.onDidEvolve, .onDidEvolve),
			(callbacks.onPurification, .onDidPurification),
			(callbacks.onBattleStart, .onWillStartBattle),
			(callbacks.onBattleEnd, .onDidEndBattle),
			(callbacks.onTeamWhiteOut, .onBattleWhiteout),
			(callbacks.onTurnStart, .onBattleTurnStart),
			(callbacks.onTurnEnd, .onBattleTurnEnd),
			(callbacks.onBattleDamageOrHealing, .onBattleDamageOrHealing),
			(callbacks.onPokemonFainted, .onPokemonDidFaint),
			(callbacks.onPokeballThrow, .onWillAttemptPokemonCapture),
			(callbacks.onCaptureSucceeded, .onDidSucceedPokemonCapture),
			(callbacks.onCaptureFailed, .onDidFailPokemonCapture),
			(callbacks.onMirorRadarActivatedColosseum, .onMirorRadarActiveAtColosseum),
			(callbacks.onMirorRadarActivatedPokespot, .onMirorRadarActiveAtPokespot),
			(callbacks.onMirorRadarSignalLost, .onMirorRadarLostSignal),
			(callbacks.onSpotMonitorActivated, .onSpotMonitorActivated),
			(callbacks.onWildBattleGenerated, .onWildBattleGenerated),
			(callbacks.onWillGetFlag, .onWillGetFlag),
			(callbacks.onWillSetFlag, .onWillSetFlag),
			(callbacks.onReceiveGiftPokemon, .onReceivedGiftPokemon),
			(callbacks.onPrint, .onPrint),
		]
		for (callback, breakPoint) in breakPoints {
			if let _ = callback {
				enabledBreakPoints.append(breakPoint)
			}
		}

		var inputTimer: Timer?
		let inputLoop = { (timer: Timer) in
			XGThreadManager.manager.runInBackgroundAsyncNamed(queue: "XD_Process_inputs") { [weak self] in
				if let process = self {
					process.writeControllers()
					process.elapseTime()
				} else {
					return
				}
			}
		}

		begin { [weak self] (process) in
			guard let self = self else { return false }

			self.setupRAMForInjection(enabledBreakPoints: enabledBreakPoints)
			if autoSkipWarningScreen {
				sleep(8)
				self.inputHandler.input([
					GCPad(duration: 0.5, A: true, tag: "write:origin"),
					GCPad(duration: 2, tag: "write:origin"),
					GCPad(duration: 0.5, A: true, tag: "write:origin"),
				])

			}

			inputTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: inputLoop)

			return onStart?(self) ?? true

		} onUpdate: { [weak self] (process) -> Bool in
			guard let self = self else { return false }
			var shouldContinue = true

			if !self.checkBreakPointPending(),
			   let breakPointType = self.getBreakPointType() {

				self.markBreakPointPending()
				self.updatePlayerInputState()

				var registers = self.getBreakPointRegisters()
				self.r13GlobalPointer = registers[13]
				let state = XDGameState(process: self)

				var context = BreakPointContext()
				var forcedReturnValue: Int?

				switch breakPointType {
				case .onFrameAdvance:
					if let callback = callbacks.onFrame {
						shouldContinue = callback(self, state)
					}
				case .onWillRenderFrame:
					if let callback = callbacks.onWillRender {
						let c = RenderFrameBufferContext(process: self, registers: registers)
						shouldContinue = callback(c, self, state); context = c
					}
				case .onDidRNGRoll:
					if let callback = callbacks.onRNGRoll {
						let c = RNGRollContext(process: self, registers: registers)
						shouldContinue = callback(c, self, state); context = c
					}
				case .onStepCount:
					if let callback = callbacks.onStep {
						shouldContinue = callback(self, state)
					}
				case .onDidLoadSave:
					if let callback = callbacks.onDidLoadSave {
						let c = SaveLoadedContext(process: self, registers: registers)
						shouldContinue = callback(c, self, state); context = c
					}
				case .onWillWriteSave:
					if let callback = callbacks.onWillWriteSave {
						shouldContinue = callback(self, state)
					}
				case .onWillChangeMap:
					if let callback = callbacks.onWillChangeMap {
						let c = MapWillChangeContext(process: self, registers: registers)
						shouldContinue = callback(c, self, state); context = c
					}
				case .onDidChangeMapOrMenu:
					if let callback = callbacks.onDidChangeMapOrMenu {
						let c = MapOrMenuDidChangeContext(process: self, registers: registers)
						shouldContinue = callback(c, self, state); context = c
					}
				case .onDidConfirmMoveSelection:
					if let callback = callbacks.onMoveSelectionConfirmed {
						let c = BattleMoveSelectionContext(process: self, registers: registers)
						shouldContinue = callback(c, self, state); context = c
					}
				case .onDidConfirmTurnSelection:
					if let callback = callbacks.onTurnSelectionConfirmed {
						let c = BattleTurnSelectionContext(process: self, registers: registers)
						shouldContinue = callback(c, self, state); context = c
					}
				case .onWillUseMove:
					if let callback = callbacks.onWillUseMove {
						let c = WillUseMoveContext(process: self, registers: registers)
						shouldContinue = callback(c, self, state); context = c
					}
				case .onMoveEnd:
					if let callback = callbacks.onMoveDidEnd {
						shouldContinue = callback(self, state)
					}
				case .onWillCallPokemon:
					if let callback = callbacks.onWillCallPokemon {
						let c = WillCallPokemonContext(process: self, registers: registers)
						shouldContinue = callback(c, self, state); context = c
					}
				case .onPokemonWillSwitchIntoBattle:
					if let callback = callbacks.onPokemonWillSwitchIn {
						let c = PokemonSwitchInContext(process: self, registers: registers)
						shouldContinue = callback(c, self, state); context = c
					}
				case .onShadowPokemonEncountered:
					if let callback = callbacks.onShadowPokemonEncountered {
						let c = ShadowPokemonEncounterContext(process: self, registers: registers)
						shouldContinue = callback(c, self, state); context = c
					}
				case .onShadowPokemonFled:
					if let callback = callbacks.onShadowPokemonFled {
						let c = ShadowPokemonFledContext(process: self, registers: registers)
						shouldContinue = callback(c, self, state); context = c
					}
				case .onShadowPokemonDidEnterReverseMode:
					if let callback = callbacks.onPokemonDidEnterReverseMode {
						let c = ReverseModeContext(process: self, registers: registers)
						shouldContinue = callback(c, self, state); context = c
					}
				case .onWillUseItem:
					if let callback = callbacks.onWillUseItem {
						let c = UseItemContext(process: self, registers: registers)
						shouldContinue = callback(c, self, state); context = c
					}
				case .onWillUseCologne:
					if let callback = callbacks.onWillUseCologne {
						let c = UseCologneContext(process: self, registers: registers)
						shouldContinue = callback(c, self, state); context = c
					}
				case .onWillUseTM:
					if let callback = callbacks.onWillUseTM {
						let c = WillUseTMContext(process: self, registers: registers)
						shouldContinue = callback(c, self, state); context = c
					}
				case .onDidUseTM:
					if let callback = callbacks.onDidUseTM {
						let c = DidUseTMContext(process: self, registers: registers)
						shouldContinue = callback(c, self, state); context = c
					}
				case .onWillGainExp:
					if let callback = callbacks.onWillGainExp {
						let c = ExpGainContext(process: self, registers: registers)
						shouldContinue = callback(c, self, state); context = c
					}
				case .onWillEvolve:
					if let callback = callbacks.onWillEvolve {
						let c = WillEvolveContext(process: self, registers: registers)
						shouldContinue = callback(c, self, state); context = c
					}
				case .onDidEvolve:
					if let callback = callbacks.onDidEvolve {
						let c = DidEvolveContext(process: self, registers: registers)
						shouldContinue = callback(c, self, state); context = c
					}
				case .onDidPurification:
					if let callback = callbacks.onPurification {
						let c = DidPurifyContext(process: self, registers: registers)
						shouldContinue = callback(c, self, state); context = c
					}
				case .onWillStartBattle:
					if let callback = callbacks.onBattleStart {
						let c = BattleStartContext(process: self, registers: registers)
						shouldContinue = callback(c, self, state); context = c
					}
				case .onDidEndBattle:
					if let callback = callbacks.onBattleEnd {
						let c = BattleEndContext(process: self, registers: registers)
						shouldContinue = callback(c, self, state); context = c
					}
				case .onBattleWhiteout:
					if let callback = callbacks.onTeamWhiteOut {
						shouldContinue = callback(self, state)
					}
				case .onBattleTurnStart:
					if let callback = callbacks.onTurnStart {
						let c = TurnStartContext(process: self, registers: registers)
						shouldContinue = callback(c, self, state); context = c
					}
				case .onBattleTurnEnd:
					if let callback = callbacks.onTurnEnd {
						shouldContinue = callback(self, state)
					}
				case .onBattleDamageOrHealing:
					if let callback = callbacks.onBattleDamageOrHealing {
						let c = BattleDamageHealingContext(process: self, registers: registers)
						shouldContinue = callback(c, self, state); context = c
					}
				case .onPokemonDidFaint:
					if let callback = callbacks.onPokemonFainted {
						let c = PokemonFaintedContext(process: self, registers: registers)
						shouldContinue = callback(c, self, state); context = c
					}
				case .onWillAttemptPokemonCapture:
					if let callback = callbacks.onPokeballThrow {
						let c = CaptureAttemptContext(process: self, registers: registers)
						shouldContinue = callback(c, self, state); context = c
					}
				case .onDidSucceedPokemonCapture:
					if let callback = callbacks.onCaptureSucceeded {
						let c = CaptureAttemptedContext(process: self, registers: registers)
						shouldContinue = callback(c, self, state); context = c
					}
				case .onDidFailPokemonCapture:
					if let callback = callbacks.onCaptureFailed {
						let c = CaptureAttemptedContext(process: self, registers: registers)
						shouldContinue = callback(c, self, state); context = c
					}
				case .onMirorRadarActiveAtColosseum:
					if let callback = callbacks.onMirorRadarActivatedColosseum {
						shouldContinue = callback(self, state)
					}
				case .onMirorRadarActiveAtPokespot:
					if let callback = callbacks.onMirorRadarActivatedPokespot {
						shouldContinue = callback(self, state)
					}
				case .onMirorRadarLostSignal:
					if let callback = callbacks.onMirorRadarSignalLost {
						shouldContinue = callback(self, state)
					}
				case .onSpotMonitorActivated:
					if let callback = callbacks.onSpotMonitorActivated {
						shouldContinue = callback(self, state)
					}
				case .onWildBattleGenerated:
					if let callback = callbacks.onWildBattleGenerated {
						let c = WildBattleContext(process: self, registers: registers)
						shouldContinue = callback(c, self, state); context = c
					}
				case .onWillGetFlag:
					if let callback = callbacks.onWillGetFlag {
						let c = GetFlagContext(process: self, registers: registers)
						shouldContinue = callback(c, self, state); context = c
						forcedReturnValue = c.getForcedReturnValue()
					}
				case .onWillSetFlag:
					if let callback = callbacks.onWillSetFlag {
						let c = SetFlagContext(process: self, registers: registers)
						shouldContinue = callback(c, self, state); context = c
					}
				case .onReceivedGiftPokemon:
					if let callback = callbacks.onReceiveGiftPokemon {
						let c = ReceiveGiftPokemonContext(process: self, registers: registers)
						shouldContinue = callback(c, self, state); context = c
					}
				case .onPrint:
					if let callback = callbacks.onPrint {
						let c = PrintContext(process: self, registers: registers)
						shouldContinue = callback(c, self, state); context = c
					}
				default:
					shouldContinue = true
				}

				if let value = forcedReturnValue {
					registers[3] = value
				}

				let updatedRegisters = context.getRegisters()
				if  !updatedRegisters.isIdenticalTo(registers) {
					self.setBreakPointRegisters(context.getRegisters())
				}
				state.write(process: self)

				if forcedReturnValue != nil, breakPointType.forcedReturnValueAddress != nil {
					self.forceReturnValueForBreakPoint()
				} else {
					self.clearBreakPoint()
				}
			}

			return shouldContinue

		} onFinish: { (process) in
			inputTimer?.invalidate()
			onFinish?()
		}
	}
}
