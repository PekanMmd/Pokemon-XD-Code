//
//  XDProcess.swift
//  GoD Tool
//
//  Created by Stars Momodu on 27/09/2021.
//

import Foundation

class XDProcess: ProcessIO {

	enum ProcessType {
		case Dolphin(dolphinFile: XGFiles?, isoFile: XGFiles?), GeckoUSB
	}

	var r13GlobalPointer: Int?

	private var process: ProcessIO
	private var JITCacheClearFlagOffset: Int?
	private var breakPointDataOffset: Int?
	private var controllerMirrorsOffset: Int?

	private var breakPointEnableOffsets = [XDBreakPointTypes: [Int]]()

	convenience init?(processType: ProcessType) {
		var process: ProcessIO?
		switch processType {
		case .Dolphin(let dolphinFile, let isoFile):
			process = DolphinProcess(isoFile: isoFile, dolphinFile: dolphinFile)
		case .GeckoUSB:
			break
		}
		guard let process = process else { return nil }
		self.init(process: process)
	}

	private init(process: ProcessIO) {
		self.process = process
	}

	// MARK: - Inputs
	let inputHandler = ControllerInputs()
	private(set) var playerInputs: [GCPad?] = [nil, nil, nil, nil]


	// MARK: - Process
	var isRunning: Bool {
		return process.isRunning
	}

	func terminate() {
		process.terminate()
	}

	func RAMDump(to file: XGFiles) {
		if let process = process as? DolphinProcess {
			let data = read(atAddress: 0, length: Int(process.kMEMSize))
			data?.writeToFile(file)
		}
	}

	// MARK: - State Saves
	var canUseSavedStates: Bool {
		return process.canUseSavedStates
	}

	func saveStateToSlot(_ slot: Int) {
		process.saveStateToSlot(slot)
	}

	func loadStateFromSlot(_ slot: Int) {
		process.loadStateFromSlot(slot)
		clearBreakPoint()
	}

	// MARK: - IO
	func read(atAddress address: UInt, length: UInt) -> XGMutableData? {
		return process.read(atAddress: address, length: length)
	}

	func readPointerRelativeToR13(offset: Int) -> Int? {
		guard let pointer = r13GlobalPointer else { return nil }
		return read4Bytes(atAddress: pointer + offset)
	}

	func readBattlePokemon(atAddress address: Int) -> XDBattlePokemon? {
		return XDBattlePokemon(file: self, offset: address)
	}

	func readPartyPokemon(atAddress address: Int) -> XDPartyPokemon? {
		return XDPartyPokemon(file: self, offset: address)
	}

	@discardableResult
	func write(_ data: XGMutableData, atAddress address: UInt) -> Bool {
		return process.write(data, atAddress: address)
	}

	// MARK: - Context
	func getBooleanFlag(_ flag: XDSFlags) -> Bool {
		return getBooleanFlag(flag.rawValue)
	}

	func getBooleanFlag(_ id: Int) -> Bool {
		return getFlag(id) == 1
	}

	func getFlag(_ flag: XDSFlags) -> Int? {
		return getFlag(flag.rawValue)
	}

	func begin(onStart: ((ProcessIO) -> Bool)?, onUpdate: ((ProcessIO) -> Bool)?, onFinish: ((ProcessIO?) -> Void)?) {
		process.begin(onStart: onStart, onUpdate: onUpdate, onFinish: onFinish)
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

		guard let offsetValue = process.readWord(atAddress: start + 4)?.int else { return nil }
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
			data = process.read(atAddress: offset, length: checkLength)
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
	func forceReturnValueForBreakPoint() {
		guard let offset = breakPointDataOffset else { return }
		write(0x01000000 + XDBreakPointTypes.forcedReturn.rawValue, atAddress: offset)
	}

	func clearBreakPoint() {
		guard let offset = breakPointDataOffset else { return }
		write(0x01000000 + XDBreakPointTypes.clear.rawValue, atAddress: offset)
	}

	func getBreakPointType() -> XDBreakPointTypes? {
		guard let offset = breakPointDataOffset,
			  let rawValue = read2Bytes(atAddress: offset + 2),
			  rawValue != XDBreakPointTypes.clear.rawValue else { return nil }
		return XDBreakPointTypes(rawValue: rawValue)
	}

	func checkBreakPointPending() -> Bool {
		guard let offset = breakPointDataOffset else { return false }
		return read2Bytes(atAddress: offset) == 0x0200
	}

	func markBreakPointPending() {
		guard let offset = breakPointDataOffset else { return }
		write16(0x0200, atAddress: offset)
	}

	func yieldThread() {
		guard let offset = breakPointDataOffset else { return }
		write16(XDBreakPointTypes.yield.rawValue, atAddress: offset + 2)
	}

	func getBreakPointRegisters() -> [Int: Int] {
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

	func setBreakPointRegisters(_ registers: [Int: Int]) {
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
	func clearUnusedFunctionsInRAM() {
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
		return process.readWord(atAddress: start) == 0x0DE1E7ED
	}

	private func clearJITCache() {
		if let offset = JITCacheClearFlagOffset {
			write("JIT!".data(), atAddress: offset)
		}
	}

	private var lastUpdateTime = 0.0
	func elapseTime() {
		let previousTime = lastUpdateTime
		lastUpdateTime = Date.init(timeIntervalSinceNow: 0).timeIntervalSince1970
		guard previousTime != 0 else {
			return
		}
		let difference = lastUpdateTime - previousTime
		inputHandler.elapseTime(difference)
	}


	func writeControllers() {
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
		if let data = process.read(atAddress: RAMAddress, length: 12) {
			return GCPad(rawData: data, player: player, tag: "Player Input: \(player.rawValue)")
		}
		return nil
	}

	func updatePlayerInputState() {
		playerInputs = [readController(.p1), readController(.p2), readController(.p3), readController(.p4)]
	}

	/// Dolphin's JIT cache means overwriting assembly won't have an effect on the game until the cache is cleared
	/// We add some code that forces the cache to clear when we set a flag to say it's dirty
	func setupRAMForInjection(enabledBreakPoints: [XDBreakPointTypes]) {
		// A location which gets called after the health and safety screen.
		// This function should be in a location which gets called regularly
		// so it can regularly check if we need to clear the JIT cache after a write.

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

			// This function lets other threads keep running if we keep a thread paused for a while.
			// Can be used for things like letting the battle camera keep moving around dynamically
			// while pausing the battle for a noticeable length of time like to make a network request

			let returnAddress = type.standardReturnOffset ?? address + 4
			let preReturnInstruction: XGASM = type.standardReturnOffset != nil ? .nop : .raw(overwrittenInstruction)

			write([
				// this address is a flag for whether or not this break point is currently enabled
				.raw(isEnabled ? 0x01000000 : 0x00),

				// preserve link register state
				.stwu(.sp, .sp, -0x20),
				.mflr(.r0),
				.stw(.r0, .sp, 0x24),

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

				// Check if the break point has been unpaused by the tool
				.cmpwi(.r0, XDBreakPointTypes.clear.rawValue),
				.bne_l("check forced return"),

				// break point was cleared

				// clear instruction cache if necessary

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

				.lwz(.r0, .sp, 0x24),
				.mtlr(.r0),
				.addi(.sp, .sp, 0x20),

				preReturnInstruction,
				.b(returnAddress),

				.label("check forced return"),

				// The function we broke on will be skipped
				// and the return value will be side loaded into r3 before
				// jumping to its blr
				.cmpwi(.r0, XDBreakPointTypes.forcedReturn.rawValue),
				.bne_l("check yield thread"),

				// clear instruction cache if necessary
				.bl(cacheCheckFunction),

				loadBreakPointOffset.0,
				loadBreakPointOffset.1,
				.li(.r0, XDBreakPointTypes.clear.rawValue),
				.sth(.r0, .r3, 2), // clear break point completely
				.lmw(.r0, .r3, 4), // restore register state
				.mr(.r3, .r0),

				.lwz(.r0, .sp, 0x24),
				.mtlr(.r0),
				.addi(.sp, .sp, 0x20),

				.b(type.forcedReturnValueAddress ?? 0), // jump to end of function we broke on

				// Check if the break point has been unpaused by the tool
				.label("check yield thread"),

				// This will let other threads keep running even if the current one continues to stay paused
				.cmpwi(.r0, XDBreakPointTypes.clear.rawValue),
				.bne_l("continue break"),

				.bl(yield),

				.b_l("continue break")

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
