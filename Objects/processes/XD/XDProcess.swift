//
//  XDProcess.swift
//  GoD Tool
//
//  Created by Stars Momodu on 27/09/2021.
//

import Foundation

class XDProcess {

	let inputHandler = ControllerInputs()
	var playerInputs: [GCPad?] = [nil, nil, nil, nil]
	var isRunning: Bool {
		return process.isRunning
	}

	private var process: DolphinProcess
	private var JITCacheClearFlagOffset: Int?
	private var breakPointDataOffset: Int?
	private var controllerMirrorsOffset: Int?
	private var r13GlobalPointer: Int!

	private var breakPointEnableOffsets = [XDBreakPointTypes: [Int]]()

	private init(process: DolphinProcess) {
		self.process = process
	}

	func terminate() {
		process.terminate()
	}

	func pause() {
		process.pause()
	}

	func resume() {
		process.resume()
	}

	func read(atAddress address: Int, length: Int) -> XGMutableData? {
		return process.read(RAMOffset: address, length: length)
	}

	func readByte(atAddress address: Int) -> Int? {
		return process.readByte(RAMOffset: address)
	}

	func read2Bytes(atAddress address: Int) -> Int? {
		return process.read2Bytes(RAMOffset: address)
	}

	func read4Bytes(atAddress address: Int) -> Int? {
		return process.read4Bytes(RAMOffset: address)
	}

	func readChar(atAddress address: Int) -> UInt8? {
		return process.readChar(RAMOffset: address)
	}

	func readString(RAMOffset: Int, charLength: ByteLengths = .char, maxCharacters: Int? = nil) -> String {
		return process.readString(RAMOffset: RAMOffset, charLength: charLength, maxCharacters: maxCharacters)
	}

	func readShort(atAddress address: Int) -> UInt16? {
		return process.readShort(RAMOffset: address)
	}

	func readWord(atAddress address: Int) -> UInt32? {
		return process.readWord(RAMOffset: address)
	}

	func readPointerRelativeToR13(offset: Int) -> Int? {
		return read4Bytes(atAddress: r13GlobalPointer + offset)
	}

	@discardableResult
	func write(_ data: XGMutableData, atAddress address: Int) -> Bool {
		return process.write(data, atAddress: address)
	}

	@discardableResult
	func write(_ value: Int, atAddress address: Int) -> Bool {
		return process.write(value, atAddress: address)
	}

	@discardableResult
	func write(_ value: UInt8, atAddress address: Int) -> Bool {
		return process.write(value, atAddress: address)
	}

	@discardableResult
	func write8(_ value: Int, atAddress address: Int) -> Bool {
		return process.write8(value, atAddress: address)
	}

	@discardableResult
	func write(_ value: UInt16, atAddress address: Int) -> Bool {
		return process.write(value, atAddress: address)
	}

	@discardableResult
	func write16(_ value: Int, atAddress address: Int) -> Bool {
		return process.write16(value, atAddress: address)
	}

	@discardableResult
	func write(_ value: UInt32, atAddress address: Int) -> Bool {
		return process.write(value, atAddress: address)
	}

	@discardableResult
	func write(_ asm: ASM, atAddress address: Int) -> Bool {
		let result = process.write(asm, atAddress: address)
		if result {
			clearJITCache()
		}
		return result
	}

	func getBooleanFlag(_ flag: XDSFlags) -> Bool {
		return getBooleanFlag(flag.rawValue)
	}

	func getBooleanFlag(_ id: Int) -> Bool {
		return getFlag(id) == 1
	}

	func getFlag(_ flag: XDSFlags) -> Int? {
		return getFlag(flag.rawValue)
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

	func writeString(_ string: String, atAddress offset: Int, charLength: ByteLengths = .short, maxCharacters: Int? = nil, includeNullTerminator: Bool = true) {
		process.writeString(string, atAddress: offset, charLength: charLength, maxCharacters: maxCharacters, includeNullTerminator: includeNullTerminator)
	}

	class func launch(settings: [(key: DolphinSystems, value: String)] = [],
					  autoSkipWarningScreen: Bool = false,
					  autoCloseDolphinOnFinish: Bool = false,
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
			(callbacks.onRNGRoll, .onDidRNGRoll),
			(callbacks.onStep, .onStepCount),
			(callbacks.onDidLoadSave, .onDidLoadSave),
			(callbacks.onWillWriteSave, .onWillWriteSave),
			(callbacks.onWillChangeMap, .onWillChangeMap),
			(callbacks.onDidChangeMap, .onDidChangeMap),
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
			(callbacks.onPokemonFainted, .onPokemonDidFaint),
			(callbacks.onPokeballThrow, .onWillAttemptPokemonCapture),
			(callbacks.onCaptureSucceeded, .onDidSucceedPokemonCapture),
			(callbacks.onCaptureFailed, .onDidFailPokemonCapture),
			(callbacks.onMirorRadarActivated, .onMirorRadarActive),
			(callbacks.onMirorRadarSignalLost, .onMirorRadarLostSignal),
			(callbacks.onSpotMonitorActivated, .onSpotMonitorActivated),
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

		var xd: XDProcess!

		DolphinProcess.launch(refreshTimeMicroSeconds: 0,
							  settings: settings,
							  autoCloseDolphinOnFinish: autoCloseDolphinOnFinish)
		{ (process) in

			xd = XDProcess(process: process)

			xd.setupRAMForInjection(enabledBreakPoints: enabledBreakPoints)
			if autoSkipWarningScreen {
				sleep(5)
				xd.inputHandler.input([
					GCPad(duration: 1, tag: "write:origin"),
					GCPad(duration: 0.5, A: true, tag: "write:origin"),
					GCPad(duration: 1, tag: "write:origin"),
					GCPad(duration: 0.5, A: true, tag: "write:origin"),
					GCPad(duration: 1, tag: "write:origin"),
					GCPad(duration: 0.5, A: true, tag: "write:origin"),
				])

			}
			return onStart?(xd) ?? true

		} onUpdate: { (process) -> Bool in

			var shouldContinue = true

			xd.updatePlayerInputState()
			xd.elapseTime()

			if !xd.checkBreakPointPending(),
			   let breakPointType = xd.getBreakPointType() {

				xd.markBreakPointPending()

				var registers = xd.getBreakPointRegisters()
				xd.r13GlobalPointer = registers[13]
				let state = XDGameState(process: xd)

				var context = BreakPointContext()
				var forcedReturnValue: Int?

				switch breakPointType {
				case .onFrameAdvance:
					if let callback = callbacks.onFrame {
						shouldContinue = callback(xd, state)
					}
				case .onDidRNGRoll:
					if let callback = callbacks.onRNGRoll {
						let c = RNGRollContext(process: xd, registers: registers)
						shouldContinue = callback(c, xd, state); context = c
					}
				case .onStepCount:
					if let callback = callbacks.onStep {
						shouldContinue = callback(xd, state)
					}
				case .onDidLoadSave:
					if let callback = callbacks.onDidLoadSave {
						let c = SaveLoadedContext(process: xd, registers: registers)
						shouldContinue = callback(c, xd, state); context = c
					}
				case .onWillWriteSave:
					if let callback = callbacks.onWillWriteSave {
						shouldContinue = callback(xd, state)
					}
				case .onWillChangeMap:
					if let callback = callbacks.onWillChangeMap {
						let c = MapWillChangeContext(process: xd, registers: registers)
						shouldContinue = callback(c, xd, state); context = c
					}
				case .onDidChangeMap:
					if let callback = callbacks.onDidChangeMap {
						let c = MapDidChangeContext(process: xd, registers: registers)
						shouldContinue = callback(c, xd, state); context = c
					}
				case .onDidConfirmMoveSelection:
					if let callback = callbacks.onMoveSelectionConfirmed {
						let c = BattleMoveSelectionContext(process: xd, registers: registers)
						shouldContinue = callback(c, xd, state); context = c
					}
				case .onDidConfirmTurnSelection:
					if let callback = callbacks.onTurnSelectionConfirmed {
						let c = BattleTurnSelectionContext(process: xd, registers: registers)
						shouldContinue = callback(c, xd, state); context = c
					}
				case .onWillUseMove:
					if let callback = callbacks.onWillUseMove {
						let c = WillUseMoveContext(process: xd, registers: registers)
						shouldContinue = callback(c, xd, state); context = c
					}
				case .onMoveEnd:
					if let callback = callbacks.onMoveDidEnd {
						shouldContinue = callback(xd, state)
					}
				case .onWillCallPokemon:
					if let callback = callbacks.onWillCallPokemon {
						let c = WillCallPokemonContext(process: xd, registers: registers)
						shouldContinue = callback(c, xd, state); context = c
					}
				case .onPokemonWillSwitchIntoBattle:
					if let callback = callbacks.onPokemonWillSwitchIn {
						let c = PokemonSwitchInContext(process: xd, registers: registers)
						shouldContinue = callback(c, xd, state); context = c
					}
				case .onShadowPokemonEncountered:
					if let callback = callbacks.onShadowPokemonEncountered {
						let c = ShadowPokemonEncounterContext(process: xd, registers: registers)
						shouldContinue = callback(c, xd, state); context = c
					}
				case .onShadowPokemonFled:
					if let callback = callbacks.onShadowPokemonFled {
						let c = ShadowPokemonFledContext(process: xd, registers: registers)
						shouldContinue = callback(c, xd, state); context = c
					}
				case .onShadowPokemonDidEnterReverseMode:
					if let callback = callbacks.onPokemonDidEnterReverseMode {
						let c = ReverseModeContext(process: xd, registers: registers)
						shouldContinue = callback(c, xd, state); context = c
					}
				case .onWillUseItem:
					if let callback = callbacks.onWillUseItem {
						let c = UseItemContext(process: xd, registers: registers)
						shouldContinue = callback(c, xd, state); context = c
					}
				case .onWillUseCologne:
					if let callback = callbacks.onWillUseCologne {
						let c = UseCologneContext(process: xd, registers: registers)
						shouldContinue = callback(c, xd, state); context = c
					}
				case .onWillUseTM:
					if let callback = callbacks.onWillUseTM {
						let c = WillUseTMContext(process: xd, registers: registers)
						shouldContinue = callback(c, xd, state); context = c
					}
				case .onDidUseTM:
					if let callback = callbacks.onDidUseTM {
						let c = DidUseTMContext(process: xd, registers: registers)
						shouldContinue = callback(c, xd, state); context = c
					}
				case .onWillGainExp:
					if let callback = callbacks.onWillGainExp {
						let c = ExpGainContext(process: xd, registers: registers)
						shouldContinue = callback(c, xd, state); context = c
					}
				case .onWillEvolve:
					if let callback = callbacks.onWillEvolve {
						let c = WillEvolveContext(process: xd, registers: registers)
						shouldContinue = callback(c, xd, state); context = c
					}
				case .onDidEvolve:
					if let callback = callbacks.onDidEvolve {
						let c = DidEvolveContext(process: xd, registers: registers)
						shouldContinue = callback(c, xd, state); context = c
					}
				case .onDidPurification:
					if let callback = callbacks.onPurification {
						let c = DidPurifyContext(process: xd, registers: registers)
						shouldContinue = callback(c, xd, state); context = c
					}
				case .onWillStartBattle:
					if let callback = callbacks.onBattleStart {
						let c = BattleStartContext(process: xd, registers: registers)
						shouldContinue = callback(c, xd, state); context = c
					}
				case .onDidEndBattle:
					if let callback = callbacks.onBattleEnd {
						let c = BattleEndContext(process: xd, registers: registers)
						shouldContinue = callback(c, xd, state); context = c
					}
				case .onBattleWhiteout:
					if let callback = callbacks.onTeamWhiteOut {
						shouldContinue = callback(xd, state)
					}
				case .onBattleTurnStart:
					if let callback = callbacks.onTurnStart {
						let c = TurnStartContext(process: xd, registers: registers)
						shouldContinue = callback(c, xd, state); context = c
					}
				case .onBattleTurnEnd:
					if let callback = callbacks.onTurnEnd {
						shouldContinue = callback(xd, state)
					}
				case .onPokemonDidFaint:
					if let callback = callbacks.onPokemonFainted {
						let c = PokemonFaintedContext(process: xd, registers: registers)
						shouldContinue = callback(c, xd, state); context = c
					}
				case .onWillAttemptPokemonCapture:
					if let callback = callbacks.onPokeballThrow {
						let c = CaptureAttemptContext(process: xd, registers: registers)
						shouldContinue = callback(c, xd, state); context = c
					}
				case .onDidSucceedPokemonCapture:
					if let callback = callbacks.onCaptureSucceeded {
						let c = CaptureAttemptedContext(process: xd, registers: registers)
						shouldContinue = callback(c, xd, state); context = c
					}
				case .onDidFailPokemonCapture:
					if let callback = callbacks.onCaptureFailed {
						let c = CaptureAttemptedContext(process: xd, registers: registers)
						shouldContinue = callback(c, xd, state); context = c
					}
				case .onMirorRadarActive:
					if let callback = callbacks.onMirorRadarActivated {
						shouldContinue = callback(xd, state)
					}
				case .onMirorRadarLostSignal:
					if let callback = callbacks.onMirorRadarSignalLost {
						shouldContinue = callback(xd, state)
					}
				case .onSpotMonitorActivated:
					if let callback = callbacks.onSpotMonitorActivated {
						shouldContinue = callback(xd, state)
					}
				case .onWillGetFlag:
					if let callback = callbacks.onWillGetFlag {
						let c = GetFlagContext(process: xd, registers: registers)
						shouldContinue = callback(c, xd, state); context = c
						forcedReturnValue = c.getForcedReturnValue()
					}
				case .onWillSetFlag:
					if let callback = callbacks.onWillSetFlag {
						let c = SetFlagContext(process: xd, registers: registers)
						shouldContinue = callback(c, xd, state); context = c
					}
				case .onReceivedGiftPokemon:
					if let callback = callbacks.onReceiveGiftPokemon {
						let c = ReceiveGiftPokemonContext(process: xd, registers: registers)
						shouldContinue = callback(c, xd, state); context = c
					}
				case .onPrint:
					if let callback = callbacks.onPrint {
						let c = PrintContext(process: xd, registers: registers)
						shouldContinue = callback(c, xd, state); context = c
					}
				default:
					shouldContinue = true
				}

				if let value = forcedReturnValue {
					registers[3] = value
				}

				let updatedRegisters = context.getRegisters()
				if  !updatedRegisters.isIdenticalTo(registers) {
					xd.setBreakPointRegisters(context.getRegisters())
				}
				state.write(process: xd)

				if forcedReturnValue != nil, breakPointType.forcedReturnValueAddress != nil {
					xd.forceReturnValueForBreakPoint()
				} else {
					xd.clearBreakPoint()
				}
			}

			xd.writeControllers()

			return shouldContinue

		} onFinish: { (process) in
			onFinish?()
		}
	}

	func ASMfreeSpaceRAMPointer(numberOfBytes: Int = 0) -> Int? {
		// returns the next free instruction address (from dol file) as a pointer to ram
		guard let start = kRAMFreeSpaceStart, let end = kRAMFreeSpaceEnd else {
			printg("Couldn't find free space in dol, current iso isn't \(game.name).")
			return nil
		}

		if !checkIfUnusedFunctionsInDolWereCleared() {
			clearUnusedFunctionsInRAM()
		}

		guard let offsetValue = process.readWord(RAMOffset: start + 4)?.int else { return nil }
		var offset = offsetValue
		if offset != 0xFFFFFFFF {
			if offset >= 0x80000000 {
				offset -= 0x80000000
			}
		}
		if offset == 0xFFFFFFFF || offset < start + 16 || offset > end /* In case offset was mistakenly/incorrectly written to */ {
			offset = start + 16
		}
		while offset % 4 != 0 {
			offset += 1
		}

		let checkLength = numberOfBytes > 3 ? ((numberOfBytes / 4) + 1) * 4 : 16
		var data: XGMutableData?
		while offset + checkLength + 4 < end  {
			data = process.read(RAMOffset: offset, length: checkLength)
			if data == nil { return nil }
			if let values = data, !values.getWordStreamFromOffset(0, length: checkLength).contains(where: { $0 != 0x60000000 }) {
				let ramOffset = offset + 0x80000000
				process.write(ramOffset.unsigned, atAddress: start + 4)
				return ramOffset
			}
			offset += 4
		}
		
		return nil
	}

	func enableBreakPoint(_ bp: XDBreakPointTypes) {
		guard let offsets = breakPointEnableOffsets[bp] else { return }
		for offset in offsets {
			write(0x01000000, atAddress: offset)
		}
	}

	func disableBreakPoint(_ bp: XDBreakPointTypes) {
		guard let offsets = breakPointEnableOffsets[bp] else { return }
		for offset in offsets {
			write(0x00000000, atAddress: offset)
		}
	}

	/// The assembly will clear the break point and then skip the rest of that function.
	/// It will return a predetermined value rather than running the function.
	private func forceReturnValueForBreakPoint() {
		guard let offset = breakPointDataOffset else { return }
		write(0x01000000 + XDBreakPointTypes.forcedReturn.rawValue, atAddress: offset)
	}

	private func clearBreakPoint() {
		guard let offset = breakPointDataOffset else { return }
		write(0x01000000 + XDBreakPointTypes.clear.rawValue, atAddress: offset)
	}

	private func getBreakPointType() -> XDBreakPointTypes? {
		guard let offset = breakPointDataOffset,
			  let rawValue = read2Bytes(atAddress: offset + 2),
			  rawValue != XDBreakPointTypes.clear.rawValue else { return nil }
		return XDBreakPointTypes(rawValue: rawValue)
	}

	private func checkBreakPointPending() -> Bool {
		guard let offset = breakPointDataOffset else { return false }
		return read2Bytes(atAddress: offset) == 0x0200
	}

	private func markBreakPointPending() {
		guard let offset = breakPointDataOffset else { return }
		write16(0x0200, atAddress: offset)
	}

	private func getBreakPointRegisters() -> [Int: Int] {
		guard let offset = breakPointDataOffset else { return [:] }
		let breakPointsRegistersOffset = offset + 4
		var registers = [Int: Int]()
		for i in 1 ... 31 {
			let index = i == 3 ? 0 : i // r3 gets moved to r0 location. r0 is lost in process
			let value = read4Bytes(atAddress: breakPointsRegistersOffset + (index * 4))
			registers[i] = value
		}
		return registers
	}

	private func setBreakPointRegisters(_ registers: [Int: Int]) {
		guard let offset = breakPointDataOffset else { return }
		let breakPointsRegistersOffset = offset + 4
		for i in 1 ... 31 {
			if let value = registers[i] {
				let index = i == 3 ? 0 : i // r3 gets moved to r0 location. r0 is lost in process
				write(value, atAddress: breakPointsRegistersOffset + (index * 4))
			}
		}
	}

	/// Clears some unused function data from the assembly so those addresses can be used for our own ASM
	private func clearUnusedFunctionsInRAM() {
		guard !checkIfUnusedFunctionsInDolWereCleared() else {
			printg("ASM space already created in RAM")
			return
		}
		if let start = kRAMFreeSpaceStart,
		let end = kRAMFreeSpaceEnd {
			var offset = start
			while offset < end {
				// replace with nops rather than zeroes so dolphin doesn't complain
				// when panic handlers aren't disabled
				process.write([.nop], atAddress: offset)
				offset += 4
			}
			process.write(0x0DE1E7ED.unsigned, atAddress: start)
			(1 ... 3).forEach {
				process.write(0xFFFFFFFF.unsigned, atAddress: start + ($0 * 4))
			}
		}
	}

	private func checkIfUnusedFunctionsInDolWereCleared() -> Bool {
		guard let start = kRAMFreeSpaceStart else { return false }
		return process.readWord(RAMOffset: start) == 0x0DE1E7ED
	}

	private func clearJITCache() {
		if let offset = JITCacheClearFlagOffset {
			write("JIT!".data(), atAddress: offset)
		}
	}

	private var lastUpdateTime = 0.0
	private func elapseTime() {
		let previousTime = lastUpdateTime
		lastUpdateTime = Date.init(timeIntervalSinceNow: 0).timeIntervalSince1970
		guard previousTime != 0 else {
			return
		}
		let difference = lastUpdateTime - previousTime
		inputHandler.elapseTime(difference)
	}


	private func writeControllers() {
		inputHandler.nextInput.forEach { (controller) in
			writeController(controller, toMirrorOffset: !(controller.tag?.contains("write:origin") ?? false))
		}

	}

	private func writeController(_ controller: GCPad, toMirrorOffset: Bool = true) {
		guard let firstMirrorOffset = toMirrorOffset ? controllerMirrorsOffset : 0 else {
			return
		}

		let RAMAddress = toMirrorOffset ? firstMirrorOffset + ((controller.player.rawValue - 1) * 12): controller.player.startOffset
		process.write(controller.rawData, atAddress: RAMAddress)
	}

	private func readController(_ player: GameController, fromMirroredOffset: Bool = false) -> GCPad? {
		guard let firstMirrorOffset = fromMirroredOffset ? controllerMirrorsOffset : 0 else {
			return nil
		}

		let RAMAddress = fromMirroredOffset ? firstMirrorOffset + ((player.rawValue - 1) * 12) : player.startOffset
		if let data = process.read(RAMOffset: RAMAddress, length: 12) {
			return GCPad(rawData: data, player: player, tag: "Player Input: \(player.rawValue)")
		}
		return nil
	}

	private func updatePlayerInputState() {
		playerInputs = [readController(.p1), readController(.p2), readController(.p3), readController(.p4)]
	}

	/// Dolphin's JIT cache means overwriting assembly won't have an effect on the game until the cache is cleared
	/// We add some code that forces the cache to clear when we set a flag to say it's dirty
	private func setupRAMForInjection(enabledBreakPoints: [XDBreakPointTypes]) {
		// A location which gets called after the health and safety screen.
		// This function should be in a location which gets called regularly
		// so it can regularly check if we need to clear the JIT cache after a write.
		let injectionPoint: Int
		switch region {
		case .US:
			injectionPoint = 0x8005c72c
		default:
			assertionFailure()
			return
		}

		guard let freeSpace = ASMfreeSpaceRAMPointer() else {
			return
		}

		let clearRequiredFlag = "JIT!".data().getWordAtOffset(0)
		let cacheFlagOffset = freeSpace
		guard write(clearRequiredFlag, atAddress: cacheFlagOffset) else {
			return
		}

		let cacheCheckFunction = freeSpace + 4

		guard write([
			.bl(cacheCheckFunction)
		], atAddress: injectionPoint) else {
			return
		}

		let loadFlagOffsetInstructions = XGASM.loadImmediateShifted32bit(register: .r4, value: cacheFlagOffset.unsigned)
		let loadFlagInstructions = XGASM.loadImmediateShifted32bit(register: .r3, value: clearRequiredFlag)
		let ICFlashInvalidate = 0x800aad88

		guard write([
			.stwu(.sp, .sp, -0x10),
			.mflr(.r0),
			.stw(.r0, .sp, 0x14),

			// get value at cache flag offset
			loadFlagOffsetInstructions.0,
			loadFlagOffsetInstructions.1,
			.lwz(.r0, .r4, 0),

			// load value of flag when clear is required (i.e. JIT!)
			loadFlagInstructions.0,
			loadFlagInstructions.1,

			// return if cache clear hasn't been requested
			.cmplw(.r0, .r3),
			.bne_l("return"),

			// clear flag
			loadFlagOffsetInstructions.0,
			loadFlagOffsetInstructions.1,
			.li(.r3, 0),
			.stw(.r3, .r4, 0),

			// trigger cache clear
			.bl(ICFlashInvalidate),

			.label("return"),

			// overwritten instruction
			.li(.r0, 0),

			.lwz(.r0, .sp, 0x14),
			.mtlr(.r0),
			.addi(.sp, .sp, 0x10),
			.blr
		], atAddress: cacheCheckFunction) else {
			return
		}

		JITCacheClearFlagOffset = cacheFlagOffset // make sure to set this at the end so prior calls to clearJITCache() are skipped

		guard let breakPointsOffset = ASMfreeSpaceRAMPointer(numberOfBytes: 33 * 4) else {
			return
		}

		guard write([
			.raw(0x01000000),
		] + .init(repeating: .raw(0x10000000), count: 32), atAddress: breakPointsOffset) else {
			return
		}

		breakPointDataOffset = breakPointsOffset

		// enable logs
		let OSReport = 0x800abc80
		let GSLog = 0x802a65cc
		write([.b(OSReport)], atAddress: GSLog)

		for breakPointType in XDBreakPointTypes.allCases where breakPointType != .clear {
			writeAssemblyforBreakPoint(withType: breakPointType, isEnabled: enabledBreakPoints.contains(breakPointType), cacheCheckFunction: cacheCheckFunction)
		}
		setUpControllerMirrors()
	}

	private func writeAssemblyforBreakPoint(withType type: XDBreakPointTypes, isEnabled: Bool, cacheCheckFunction: Int) {
		guard let freeSpace = ASMfreeSpaceRAMPointer(),
			  let addresses = type.addresses,
			  let breakPointDataStart = breakPointDataOffset else {
			return
		}

		for address in addresses {
			guard let overwrittenInstruction = readWord(atAddress: address) else {
				continue
			}
			write([
				.b(freeSpace + 4) // first word is enabled flag
			], atAddress: address)

			// Bear in mind r0 is lost in the process
			// All other registers are preserved
			// The value in r3 is stored in the r0 slot
			let loadBreakPointOffset = XGASM.loadImmediateShifted32bit(register: .r3, value: breakPointDataStart.unsigned)
			let loadIsEnabledOffset = XGASM.loadImmediateShifted32bit(register: .r3, value: freeSpace.unsigned)
			write([
				// this address is a flag for whether or not this break point is currently enabled
				.raw(isEnabled ? 0x01000000 : 0x00),

				// preserve r3
				.mr(.r0, .r3),

				// check game has loaded sufficiently
				.cmpwi(.r13, 0),
				.beq_l("return"),

				// get address where this break point's status is set
				loadIsEnabledOffset.0,
				loadIsEnabledOffset.1,

				// check that this break point is currently enabled
				.lbz(.r3, .r3, 0),
				.cmpwi(.r3, 1),
				.bne_l("return"),

				// get address for general break point status
				loadBreakPointOffset.0,
				loadBreakPointOffset.1,

				// check the tool hasn't already broken elsewhere on another thread
				.lhz(.r3, .r3, 2),
				.cmpwi(.r3, 0),
				.bne_l("return"),

				// get address for general break point status
				loadBreakPointOffset.0,
				loadBreakPointOffset.1,

				// store all registers for reference in the tool's callback
				.stmw(.r0, .r3, 4),

				// write break point value for reference by tool's callback
				.li(.r0, type.rawValue),
				.sth(.r0, .r3, 2),

				// loop until tool clears the break point value
				.label("continue break"),

				// get address for general break point status
				loadBreakPointOffset.0,
				loadBreakPointOffset.1,

				// get current break point value
				.lhz(.r0, .r3, 2),

				.label("check breakpoint cleared"),

				// 0 means the break point has been unpaused by the tool
				.cmpwi(.r0, XDBreakPointTypes.clear.rawValue),
				.bne_l("check forced return"),

				// break point was cleared

				// clear instruction cache if necessary
				.stwu(.sp, .sp, -0x10),
				.mflr(.r0),
				.stw(.r0, .sp, 0x14),
				.bl(cacheCheckFunction),
				.lwz(.r0, .sp, 0x14),
				.mtlr(.r0),
				.addi(.sp, .sp, 0x10),

				// restore register state and resume code execution

				loadBreakPointOffset.0,
				loadBreakPointOffset.1,
				.lmw(.r0, .r3, 4),

				.label("return"),
				// restore r3
				.mr(.r3, .r0),

				.raw(overwrittenInstruction),
				.b(address + 4),

				.label("check forced return"),

				// The function we broke on will be skipped
				// and the return value will be side loaded into r3 before
				// jumping to its blr
				.cmpwi(.r0, XDBreakPointTypes.forcedReturn.rawValue),
				.bne_l("continue break"),

				// clear instruction cache if necessary
				.stwu(.sp, .sp, -0x10),
				.mflr(.r0),
				.stw(.r0, .sp, 0x14),
				.bl(cacheCheckFunction),
				.lwz(.r0, .sp, 0x14),
				.mtlr(.r0),
				.addi(.sp, .sp, 0x10),

				loadBreakPointOffset.0,
				loadBreakPointOffset.1,
				.li(.r0, XDBreakPointTypes.clear.rawValue),
				.sth(.r0, .r3, 2), // clear break point completely
				.lmw(.r0, .r3, 4), // restore register state
				.mr(.r3, .r0),

				.b(type.forcedReturnValueAddress ?? 0), // jump to end of function we broke on


			], atAddress: freeSpace)

		}
		breakPointEnableOffsets[type] = addresses
	}

	/// This allows the tool to inject controller inputs into a separate offset and
	/// those values will be masked with the actual in game input so both input
	/// types can be registered at once without overwriting each other
	private func setUpControllerMirrors() {
		guard let programmaticControllerWriteOffset = ASMfreeSpaceRAMPointer() else {
			return
		}
		let mirrorLength = 12
		let allMirrorsLength = mirrorLength * 4
		write(XGMutableData(length: 12 * 4), atAddress: programmaticControllerWriteOffset)
		let loadControllerOffset = XGASM.loadImmediateShifted32bit(register: .r6, value: programmaticControllerWriteOffset.unsigned)

		let patchedInputCopyFunction = programmaticControllerWriteOffset + allMirrorsLength
		let inputCopyBranch = 0x80104a30

		write([
			.bl(patchedInputCopyFunction)
		], atAddress: inputCopyBranch)

		write([
			loadControllerOffset.0,
			loadControllerOffset.1,
			.li(.r0, mirrorLength),
			.mullw(.r0, .r0, .r30), // r30 has the controller index currently being read
			.add(.r6, .r6, .r0),

			.b_l("loop_check"),

			.label("loop_start"),
			.subi(.r5, .r5, 1),

			.lbzx(.r0, .r4, .r5),
			.lbzx(.r7, .r6, .r5),
			.or(.r0, .r0, .r7),
			.stbx(.r0, .r3, .r5),

			.label("loop_check"),
			.cmpwi(.r5, 0),
			.bgt_l("loop_start"),

			.blr
		], atAddress: patchedInputCopyFunction)

		controllerMirrorsOffset = programmaticControllerWriteOffset
	}

	func getPokemonFromPointerOffset(_ pointer: Int) -> XDPartyPokemon? {
		if let offset =  read4Bytes(atAddress: pointer) {
			return getPokemonFromOffset(offset + 4)
		}
		return nil
	}

	func getPokemonFromOffset(_ offset: Int) -> XDPartyPokemon? {
		return XDPartyPokemon(process: self, offset: offset)
	}
}
