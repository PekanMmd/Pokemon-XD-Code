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

	private let process: DolphinProcess
	private var JITCacheClearFlagOffset: Int?
	private var breakPointDataOffset: Int?
	private var controllerMirrorsOffset: Int?

	private var breakPointEnableOffsets = [XDBreakPointTypes: Int]()

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

	func readShort(atAddress address: Int) -> UInt16? {
		return process.readShort(RAMOffset: address)
	}

	func readWord(atAddress address: Int) -> UInt32? {
		return process.readWord(RAMOffset: address)
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

	class func launch(settings: [(key: DolphinSystems, value: String)] = [],
					  autoSkipWarningScreen: Bool = false,
					  autoCloseDolphinOnFinish: Bool = false,
					  onStart: ((XDProcess) -> Bool)?,
					  onFinish: (() -> Void)?,

					  onRNGRoll: ((RNGRollState, XDProcess, XDGameState) -> Bool)? = nil
					  ) {

		guard region == .US else {
			printg("Couldn't launch XD process for region:", region.name)
			return
		}

		var enabledBreakPoints = [XDBreakPointTypes]()
		if let _ = onRNGRoll { enabledBreakPoints.append(.onDidRNGRoll) }

		var xd: XDProcess!
		DolphinProcess.launch(delaySeconds: 0,
							  refreshTimeMicroSeconds: 0,
							  settings: settings,
							  autoCloseDolphinOnFinish: autoCloseDolphinOnFinish)
		{ (process) in
			xd = XDProcess(process: process)
			xd.setupRAMForInjection(enabledBreakPoints: enabledBreakPoints)
			if autoSkipWarningScreen {
				sleep(5)
				xd.inputHandler.input(GCPad(A: true, tag: "write:origin"))
			}
			return onStart?(xd) ?? true

		} onUpdate: { (process) -> Bool in

			var shouldContinue = true

			xd.updatePlayerInputState()
			xd.elapseTime()

			if !xd.checkBreakPointPending(),
			   let breakPointType = xd.getBreakPointType(),
			   let state = XDGameState(process: xd) {

				xd.markBreakPointPending()

				var registers = xd.getBreakPointRegisters()
				var forceReturnValue: Bool = false

				switch breakPointType {
				case .onDidRNGRoll:
					if let callback = onRNGRoll {
						let rngState = RNGRollState(process: xd, registers: registers)
						shouldContinue = callback(rngState, xd, state)
						registers = rngState.getRegisters()
					}
				default:
					break
				}

				xd.setBreakPointRegisters(registers)
				state.write(process: xd)
				if forceReturnValue {
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

	/// Let the game continue running other threads even while the current break point is active
	func yieldBreakPointThread() {
		guard let offset = breakPointDataOffset else { return }
		write(0x01000000 + XDBreakPointTypes.yield.rawValue, atAddress: offset)
	}

	func enableBreakPoint(_ bp: XDBreakPointTypes) {
		guard let offset = breakPointEnableOffsets[bp] else { return }
		write(0x01000000, atAddress: offset)
	}

	func disableBreakPoint(_ bp: XDBreakPointTypes) {
		guard let offset = breakPointEnableOffsets[bp] else { return }
		write(0x00000000, atAddress: offset)
	}

	/// The assembly will clear the break point and then skip the rest of that function.
	/// It will return a predetermined value rather than running the function.
	private func forceReturnValueForBreakPoint() {
		guard let offset = breakPointDataOffset else { return }
		write(0x01000000 + XDBreakPointTypes.forcedReturn.rawValue, atAddress: offset)
	}

	private func clearBreakPoint() {
		guard let offset = breakPointDataOffset else { return }
		write(0x01000000, atAddress: offset)
	}

	private func getBreakPointType() -> XDBreakPointTypes? {
		guard let offset = breakPointDataOffset,
			  let rawValue = read2Bytes(atAddress: offset + 2) else { return nil }
		return XDBreakPointTypes(rawValue: rawValue)
	}

	private func checkBreakPointPending() -> Bool {
		guard let offset = breakPointDataOffset else { return false }
		return read2Bytes(atAddress: offset) == 0x0200
	}

	private func markBreakPointPending() {
		guard let offset = breakPointDataOffset else { return }
		write(.init(byteStream: [0x02, 0x00]), atAddress: offset)
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
		guard let firstMirrorOffset = toMirrorOffset ? controllerMirrorsOffset: 0 else {
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
			#warning("Find better offset and update asm")
			injectionPoint = 0x80186100
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
			.b(cacheCheckFunction)
		], atAddress: injectionPoint) else {
			return
		}

		let loadFlagOffsetInstructions = XGASM.loadImmediateShifted32bit(register: .r4, value: cacheFlagOffset.unsigned)
		let loadFlagInstructions = XGASM.loadImmediateShifted32bit(register: .r3, value: clearRequiredFlag)
		let ICFlashInvalidate = 0x800aad88

		guard write([
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
			.stw(.r3, .r0, 0),

			// trigger cache clear
			.bl(ICFlashInvalidate),

			.label("return"),

			// overwritten instruction
			.addi(.r0, .r28, 1),

			.b(injectionPoint + 4)
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

		for breakPointType in XDBreakPointTypes.allCases {
			writeAssemblyforBreakPoint(withType: breakPointType, isEnabled: enabledBreakPoints.contains(breakPointType))
		}
		setUpControllerMirrors()
	}

	private func writeAssemblyforBreakPoint(withType type: XDBreakPointTypes, isEnabled: Bool) {
		guard let freeSpace = ASMfreeSpaceRAMPointer(),
			  let address = type.address,
			  let forcedReturnValueAddress = type.forcedReturnValueAddress,
			  let overwrittenInstruction = readWord(atAddress: address),
			  let breakPointDataStart = breakPointDataOffset else {
			return
		}

		write([
			.b(freeSpace + 4) // first word is enabled flag
		], atAddress: address)

		// Bear in mind r0 is lost in the process
		// All other registers are preserved
		// The value in r3 is stored in the r0 slot
		let loadBreakPointOffset = XGASM.loadImmediateShifted32bit(register: .r3, value: breakPointDataStart.unsigned)
		let loadIsEnabledOffset = XGASM.loadImmediateShifted32bit(register: .r3, value: freeSpace.unsigned)
		let yieldFrame = 0x800b165c
		write([
			// This address is a flag for whether or not this break point is currently enabled
			.raw(isEnabled ? 0x01000000 : 0x00),

			// preserve r3
			.mr(.r0, .r3),

			// Get address where this break point's status is set
			loadIsEnabledOffset.0,
			loadIsEnabledOffset.1,

			// Check that this break point is currently enabled
			.lbz(.r3, .r3, 0),
			.cmpwi(.r3, 1),
			.bne_l("return"),

			// Get address for general break point status
			loadBreakPointOffset.0,
			loadBreakPointOffset.1,

			// Check the tool hasn't already broken elsewhere on another thread
			.lhz(.r3, .r3, 2),
			.cmpwi(.r3, 0),
			.bne_l("return"),

			// Get address for general break point status
			loadBreakPointOffset.0,
			loadBreakPointOffset.1,

			// Store all registers for reference in the tool's callback
			.stmw(.r0, .r3, 4),

			// Write break point value for reference by tool's callback
			.li(.r0, type.rawValue),
			.sth(.r0, .r3, 2),

			// loop until tool clears the break point value
			.label("continue break"),

			// Get address for general break point status
			loadBreakPointOffset.0,
			loadBreakPointOffset.1,

			// get current break point value
			.lhz(.r0, .r3, 2),

			// 0 means the break point has been unpaused by the tool
			.cmpwi(.r0, 0),
			.beq_l("end break"),

			// The function we broke on will be skipped
			// and the return value will be side loaded into r3 before
			// jumping to its blr
			.cmpwi(.r0, XDBreakPointTypes.forcedReturn.rawValue),
			.beq_l("force return value"),

			// The break point will let other threads keep running while it decides what to do
			.cmpwi(.r0, XDBreakPointTypes.yield.rawValue),
			.bne_l("continue break"),

			// Call thread yield
			.stwu(.sp, .sp, -0x10),
			.mflr(.r0),
			.stw(.r0, .sp, 0x14),
			.bl(yieldFrame),
			.lwz(.r0, .sp, 0x14),
			.mtlr(.r0),
			.addi(.sp, .sp, 0x10),

			// Break point is still paused
			.b_l("continue break"),

			// Restore register state and resume code execution
			.label("end break"),
			loadBreakPointOffset.0,
			loadBreakPointOffset.1,
			.lmw(.r0, .r3, 4),

			.label("return"),
			// restore r3
			.mr(.r3, .r0),

			.raw(overwrittenInstruction),
			.b(address + 4),

			.label("force return value"),
			loadBreakPointOffset.0,
			loadBreakPointOffset.1,
			.li(.r0, 0),
			.sth(.r0, .r3, 2), // clear break point completely
			.lmw(.r0, .r3, 4), // reload all registers though only r3 is important here
			.mr(.r3, .r0),

			.b(forcedReturnValueAddress),


		], atAddress: freeSpace)

		breakPointEnableOffsets[type] = freeSpace
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
}
