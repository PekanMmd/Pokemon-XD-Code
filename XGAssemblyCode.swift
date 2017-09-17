//
//  XGAssemblyCode.swift
//  XGCommandLineTools
//
//  Created by StarsMmd on 02/03/2017.
//  Copyright © 2017 StarsMmd. All rights reserved.
//

import Foundation

typealias ASM = [UInt32]

let kColosseumDolToRamOffsetDifference = 0x3000

let kRELtoRAMOffsetDifference = 0xb18dc0 // add this value to a common_rel offset to get it's offset in RAM
let kDOLtoRAMOffsetDifference = 0x30a0   // add this value to a start.dol offset to get it's offset in RAM

let kRELDataStartOffset = 0x1CB0
let kRelFreeSpaceStart = 0x80590 + kRELtoRAMOffsetDifference

let kPickupTableInDolStartOffset = 0x2F0758

let moveEffectTableStartDOL = 0x414edf
let moveEffectTableStartRAM = 0x417edf

// function pointers in RAM
let kRAMListOfFunctionPointers = 0x2f8af8

let zz_move_get_priority = 0x13e7b8
let zz_before_battle_pokemon_get_ability = 0x2055c8
let zz_move_get_type = 0x13e870
let zz_move_get_category = 0x13e7f0
let zz_battle_pokemon_before_get_current_move_c = 0x204594

class XGAssembly {
	class func ASMfreeSpacePointer() -> Int {
		var offset = kRelFreeSpaceStart
		let rel = XGFiles.common_rel.data
		var value = rel.get4BytesAtOffset(offset - kRELtoRAMOffsetDifference)
		while value != 0 {
			offset = offset + 4
			value = rel.get4BytesAtOffset(offset - kRELtoRAMOffsetDifference)
		}
		return offset
	}
	
	class func revertDolInstructionFromOffset(offset: Int, length: Int) {
		
		let dol = XGFiles.dol.data
		
		for i in 0 ..< length {
			
			let off = offset + (i * 4)
			
			let original = XGFiles.original(.dol).data.get4BytesAtOffset(off)
			dol.replace4BytesAtOffset(off, withBytes: original)
			
		}
		dol.save()
	}
	
	class func revertDolInstructionAtOffsets(offsets: [Int]) {
		
		let dol = XGFiles.dol.data
		
		for offset in offsets {
			
			let original = XGFiles.original(.dol).data.get4BytesAtOffset(offset)
			dol.replace4BytesAtOffset(offset, withBytes: original)
			
		}
		dol.save()
	}
	
	class func replaceASM(startOffset: Int, newASM asm: ASM) {
		let dol = XGFiles.dol.data
		for i in 0 ..< asm.count {
			let offset = startOffset + (i * 4)
			let instruction = asm[i]
			dol.replace4BytesAtOffset(offset, withBytes: instruction)
		}
		dol.save()
	}
	
	class func replaceRELASM(startOffset: Int, newASM asm: ASM) {
		let rel = XGFiles.common_rel.data
		for i in 0 ..< asm.count {
			let offset = startOffset + (i * 4)
			let instruction = asm[i]
			rel.replace4BytesAtOffset(offset, withBytes: instruction)
		}
		rel.save()
	}
	
	class func revertASM(startOffset: Int, newASM asm: ASM) {
		for i in 0 ..< asm.count {
			let offset = startOffset + (i * 4)
			revertDolInstructionFromOffset(offset: offset, length: 1)
		}
	}
	
	class func removeASM(startOffset: Int, length: Int) {
		let asm = ASM(repeating: kNopInstruction, count: length)
		replaceASM(startOffset: startOffset, newASM: asm)
	}
	
	class func ramPointerOffsetFromR13(offset: Int) -> Int {
		let R13 = 0x4efe20
		return R13 + offset
	}
	
	class func getWordAtRamOffsetFromR13(offset: Int) -> Int {
		// this should be a pointer into common_rel
		let ram = XGFiles.nameAndFolder("xg ram.raw", .Reference).data
		return Int(ram.get4BytesAtOffset(ramPointerOffsetFromR13(offset: offset))) - kRELtoRAMOffsetDifference
	}
	
	class func createBranchAndLinkFrom(offset: Int, toOffset to: Int) -> UInt32 {
		return createBranchFrom(offset: offset, toOffset: to) + 1
	}
	
	class func printCreateBranchAndLinkFrom(offset: Int, toOffset to: Int) {
		print(String(format: "%x", createBranchAndLinkFrom(offset: offset, toOffset: to)))
	}
	
	class func createBranchFrom(offset: Int, toOffset to: Int) -> UInt32 {
		return UInt32(18 << 26) + UInt32((to - offset) & 0x3FFFFFF)
	}
	
	class func printCreateBranchFrom(offset: Int, toOffset to: Int) {
		print(String(format: "%x", createBranchFrom(offset: offset, toOffset: to)))
	}
	
	class func powerPCBranchAndLinkToOffset(to: Int) -> UInt32 {
		return createBranchAndLinkFrom(offset: 0, toOffset: to) + 2
	}
	
	class func powerPCBranchLinkReturn() -> UInt32 {
		return 0x4e800020
	}
	
	class func powerPCBranchConditionalFromOffset(from: Int, toOffset to: Int, BO: UInt32, BI: UInt32) -> UInt32 {
		let difference =  (to - from)
		if difference > 0x7FFF || difference < -0xFFFF {
			print("conditional branch overflow")
		}
		return UInt32(16 << 26) + (BO << 21) + (BI << 16) + UInt32(difference & 0xFFFF)
	}
	
	class func powerPCBranchEqualFromOffset(from: Int, to: Int) -> UInt32 {
		return powerPCBranchConditionalFromOffset(from: from, toOffset: to, BO: 12, BI: 2)
	}
	
	class func powerPCBranchNotEqualFromOffset(from: Int, to: Int) -> UInt32 {
		return powerPCBranchConditionalFromOffset(from: from, toOffset: to, BO: 4, BI: 2)
	}
	
	class func powerPCBranchLessThanFromOffset(from: Int, to: Int) -> UInt32 {
		let difference =  (to - from)
		if difference > 0x7FFF || difference < -0xFFFF {
			print("conditional branch overflow")
		}
		return 0x41800000 + UInt32( (to - from) & 0xFFFF)
	}
	
	class func powerPCBranchGreaterThanOrEqualFromOffset(from: Int, to: Int) -> UInt32 {
		let difference =  (to - from)
		if difference > 0x7FFF || difference < -0xFFFF {
			print("conditional branch overflow")
		}
		return 0x40800000 + UInt32( (to - from) & 0xFFFF)
	}
	
	class func powerPCBranchLessThanOrEqualFromOffset(from: Int, to: Int) -> UInt32 {
		let difference =  (to - from)
		if difference > 0x7FFF || difference < -0xFFFF {
			print("conditional branch overflow")
		}
		return 0x40810000 + UInt32( (to - from) & 0xFFFF)
	}
	
	class func paralysisHalvesSpped() {
		let dol = XGFiles.dol.data
		dol.replace4BytesAtOffset(0x203af8 - kDOLtoRAMOffsetDifference, withBytes: 0x56f7f87e)
		dol.save()
	}
	
	class func infiniteUseTMs() {
		let dol = XGFiles.dol.data
		dol.replace4BytesAtOffset(0x0a5158 - kDOLtoRAMOffsetDifference, withBytes: 0x38000000)
		dol.save()
	}
	
	class func increaseNumberOfAbilities() {
		// only run this once!
		
		let dol = XGFiles.dol.data
		let abilityStart = 0x3FCC50
		
		let newAbilityEntryMultiplier : UInt32 = 0x1c830008
		let abilityMultiplierAddress = 0x1442b0 - kDOLtoRAMOffsetDifference
		
		let abilityGetName : UInt32 = 0x80630000
		let abilityGetNameAddress = 0x144290 - kDOLtoRAMOffsetDifference
		
		let abilityGetDescription : UInt32 = 0x80630004
		let abilityGetDescriptionAddress = 0x144278 - kDOLtoRAMOffsetDifference
		
		let sizeOfAbilityTable = 0x3A8
		let newNumberOfEntries = sizeOfAbilityTable / 8
		
		dol.replace4BytesAtOffset(abilityMultiplierAddress, withBytes: newAbilityEntryMultiplier)
		dol.replace4BytesAtOffset(abilityGetNameAddress, withBytes: abilityGetName)
		dol.replace4BytesAtOffset(abilityGetDescriptionAddress, withBytes: abilityGetDescription)
		
		
		var allabilities = [(UInt32,UInt32)]()
		
		for j in 0 ... kNumberOfAbilities {
			
			let offset = abilityStart + (j * 12)
			allabilities.append((dol.get4BytesAtOffset(offset + 4),dol.get4BytesAtOffset(offset + 8)))
			
		}
		
		for i in 0 ..< newNumberOfEntries {
			
			let offset = abilityStart + (i * 8)
			
			if i < allabilities.count {
				
				dol.replace4BytesAtOffset(offset    , withBytes: allabilities[i].0)
				dol.replace4BytesAtOffset(offset + 4, withBytes: allabilities[i].1)
				
			} else {
				
				dol.replace4BytesAtOffset(offset    , withBytes: 0)
				dol.replace4BytesAtOffset(offset + 4, withBytes: 0)
				
			}
		}
		
		dol.replace4BytesAtOffset(0x41db38, withBytes: 0x74)
		
		dol.save()
		
	}
	
	class func gen6CriticalHitMultiplier() {
		
		let dol = XGFiles.dol.data
		
		let critMultsTo3 = [0x22a7a3,0x22a803,0x22a927,0x22a987,0x229d23,0x229d83,0x229e2f,0x229e8f,0x2155fb,0x21701b]
		let critMultsTo2  = [0x22a89b,0x22a9f3,0x229dfb,0x229edb,0x21702b,0x21703b]
		let valsTo1 = [0x22a807,0x22a98b,0x229d87,0x229e93]
		
		for offie in critMultsTo3 {
			dol.replaceByteAtOffset(offie - kDOLtoRAMOffsetDifference, withByte: 0x03)
		}
		
		for offie in critMultsTo2 {
			dol.replaceByteAtOffset(offie - kDOLtoRAMOffsetDifference, withByte: 0x02)
		}
		
		for offie in valsTo1 {
			dol.replaceByteAtOffset(offie - kDOLtoRAMOffsetDifference, withByte: 0x01)
		}
		
		let off1 = 0x20dafc - kDOLtoRAMOffsetDifference
		let instructions1 = [0x7F7F19D6,0x7f43d378,0x577BF87E]
		
		let off2 = 0x216d1c - kDOLtoRAMOffsetDifference
		let instructions2 = [0x7F3E19D6,0x7fe3fb78,0x5739F87E]
		
		for i in 0 ... 2 {
			
			let offset1 = off1 + (i * 4)
			dol.replace4BytesAtOffset(offset1, withBytes: UInt32(instructions1[i]))
			
			let offset2 = off2 + (i * 4)
			dol.replace4BytesAtOffset(offset2, withBytes: UInt32(instructions2[i]))
		}
		
		dol.save()
		
	}
	
	class func setDeoxysFormeToAttack() {
		
		let dol = XGFiles.dol.data
		
		for offset in [0x1D8F8C, 0x1D900C] {
			
			let off = offset - kDOLtoRAMOffsetDifference
			
			dol.replace4BytesAtOffset(off, withBytes: 0x54001838)
			
		}
		
		for offset in [0x1117F0,0x111840,0x1D8F88,0x1D9008] {
			
			let off = offset - kDOLtoRAMOffsetDifference
			
			dol.replace4BytesAtOffset(off, withBytes: 0x38000001)
			
		}
		
		dol.save()
		
	}
	
	class func shareEXPWithParty() {
		
		let dol = XGFiles.dol.data
		
		for offset in [0x212C48,0x212E04] {
			
			let off = offset - kDOLtoRAMOffsetDifference
			
			dol.replace4BytesAtOffset(off, withBytes: kNopInstruction)
			
		}
		
		dol.save()
		
	}
	
	class func determineShininessFrom0x1CForDeckPokemon() {
		
		let dol = XGFiles.dol.data
		
		if dol.get4BytesAtOffset(0x28bb30 - kDOLtoRAMOffsetDifference) == 0xA0DB001C {
			return
		}
		
		// make 1d load 2 bytes from 1c using values from r27 instead of r3 (given that r27 now points to deck data)
		dol.replace4BytesAtOffset(0x28bb30 - kDOLtoRAMOffsetDifference, withBytes: 0xA0DB001C)
		dol.replace4BytesAtOffset(0x28bb20 - kDOLtoRAMOffsetDifference, withBytes: 0x281B0000)
		dol.replace4BytesAtOffset(0x28bb28 - kDOLtoRAMOffsetDifference, withBytes: 0x38C00000)
		
		// remove use of r27 so we can steal it >=D
		dol.replace4BytesAtOffset(0x1fbee0 - kDOLtoRAMOffsetDifference, withBytes: kNopInstruction)
		
		// store the deck data pointer in r27 so we can use it again later
		dol.replace4BytesAtOffset(0x1fbd00 - kDOLtoRAMOffsetDifference, withBytes: 0x7F5BD378)
		
		// load 1d into r6 before pid gen
		let offsets = [0x1fbef4,0x1fbfb8,0x1fc2b0]
		
		for offset in offsets {
			dol.replace4BytesAtOffset(offset - kDOLtoRAMOffsetDifference, withBytes: instructionToBranchToSameFunction(0x4808fdcd, originalOffset: 0x1fbd54, newOffset: UInt32(offset)))
		}
		
		// where the game read from 1d, now read from 1f
		dol.replace4BytesAtOffset(0x1fbd54 - kDOLtoRAMOffsetDifference, withBytes: instructionToBranchToSameFunction(0x4808fdc5, originalOffset: 0x1fbcec, newOffset: 0x1fbd54))
		
		// where the game read from 1f just load 0 instead
		dol.replace4BytesAtOffset(0x1fbcec - kDOLtoRAMOffsetDifference, withBytes: 0x38600000)
		
		
		dol.save()
		
	}
	
	class func instructionToBranchToSameFunction(_ inst: UInt32, originalOffset origin: UInt32, newOffset new: UInt32) -> UInt32 {
		// creates a new branch instruction using an existing one as the base
		// inst: the original instruction
		// origin: the offset of the original instruction
		// new: the offset where the new branch instruction will be located
		return inst - (new - origin)
		
	}
	
	class func switchDPKMStructureToShinyStyle() {
		// only do this once!
		
		let decks = [XGDecks.DeckStory,XGDecks.DeckColosseum,XGDecks.DeckVirtual,XGDecks.DeckHundred,XGDecks.DeckBingo,XGDecks.DeckImasugu,XGDecks.DeckSample]
		
		for deck in decks {
			for p in deck.allPokemon {
				
				p.priority   = p.shinyness.rawValue
				p.shinyness = .never
				p.save()
				
			}
		}
		
		XGAssembly.replaceASM(startOffset: 0x28bac0 - kDOLtoRAMOffsetDifference, newASM: [0x8863001f, kNopInstruction])
		
	}
	
	class func switchNextPokemonAtEndOfTurn() {
		// you no longer send in a new pokemon as soon as one faints. Now waits until end of turn. Still experimental!
		
		let switchlessStart = ASMfreeSpacePointer()
		let switchlessBranch = 0x20e36c
		let executeCodeRoutine = 0x1f3bec
		let intimidateRoutine = 0x225c04
		let unkownRoutine = 0x225ac8
		let battleEntryEffects = 0x226474
		let switchlessCode : ASM = [
			0x9421fff0,
			0x7c0802a6,
			0x3c808022,
			0x38600000,
			0x90010014,
			0x388475f8,
			0x38a00000,
			0x38c00000,
			createBranchAndLinkFrom(offset: switchlessStart + 0x20, toOffset: executeCodeRoutine),
			0x38600001,
			createBranchAndLinkFrom(offset: switchlessStart + 0x28, toOffset: intimidateRoutine),
			createBranchAndLinkFrom(offset: switchlessStart + 0x2c, toOffset: unkownRoutine),
			0x3c808022,
			0x38600000,
			0x38847588,
			0x38a00000,
			0x38c00000,
			createBranchAndLinkFrom(offset: switchlessStart + 0x44, toOffset: executeCodeRoutine),
			createBranchAndLinkFrom(offset: switchlessStart + 0x48, toOffset: battleEntryEffects),
			0x80010014,
			0x7c0803a6,
			0x38210010,
			0x38000002,
			0x980dbb14,
			0x4e800020
		]
		
		XGAssembly.replaceASM(startOffset: switchlessStart - kRELtoRAMOffsetDifference, newASM: switchlessCode)
		XGAssembly.replaceASM(startOffset: switchlessBranch - kDOLtoRAMOffsetDifference, newASM: [createBranchAndLinkFrom(offset: switchlessBranch, toOffset: switchlessStart)])
		
	}
}

func getRoutineStartForMoveEffect(index: Int) -> Int {
	let effectOffset = index * 4
	let pointerOffset = moveEffectTableStartDOL + effectOffset
	let pointer = XGFiles.dol.data.get4BytesAtOffset(pointerOffset) - 0x80000000
	return Int(pointer)
}

func getRoutinePointerForMove(move: XGMoves) -> Int {
	return getRoutineStartForMoveEffect(index: move.data.effect)
}

func getRoutineEndPointerForMove(move: XGMoves) -> Int {
	return getRoutineStartForMoveEffect(index: move.data.effect + 1)
}


func getFunctionPointerWithIndex(index: Int) -> Int {
	let ram = XGFiles.nameAndFolder("xg ram.raw", .Reference).data
	return Int(ram.get4BytesAtOffset(kRAMListOfFunctionPointers + (index * 4)))
}

func getFunctionPointerForStatusMove(move: XGMoves) -> Int {
	// can be used for moves which just set up a status effect like safeguard, reflect and mist
	// other moves don't seem to have a clear method of finding the function pointer
	let ram = XGFiles.nameAndFolder("xg ram.raw", .Reference).data
	
	let routine = getRoutinePointerForMove(move: move)
	// 3 seems to work for simple set up status moves
	let functionIndex = ram.getByteAtOffset(routine + 3)
	
	return getFunctionPointerWithIndex(index: functionIndex)
	
}

func printRoutineForMove(move: XGMoves) {
	let routineStart = getRoutinePointerForMove(move: move)
//	let routineEnd = getRoutineEndPointerForMove(move: move)
//	let length = routineEnd - routineStart > 0 ? routineEnd - routineStart : 50
	let ram = XGFiles.nameAndFolder("xg ram.raw", .Reference).data
//	var routine = ram.getByteStreamFromOffset(routineStart, length: length)
	var routine = ram.getByteStreamFromOffset(routineStart, length: 4)
	
	var i = 4
	var endFound = false
	while !endFound {
		
		let next = ram.getByteAtOffset(routineStart + i)
		routine.append(next)
		
		if routine[i] == 15 && routine[i - 1] == 65 && routine[i - 2] == 65 && routine[i - 3] == 128 {
			endFound = true
		}
		
		i += 1
	}
	
	
	
	print("routine: ", routine)
	
//	print("function guess for variable power move [0]: ", getFunctionPointerWithIndex(index: routine[0]).hexString())
//	print("function guess for status effect move [2]: ", getFunctionPointerWithIndex(index: routine[2]).hexString())
//	print("function guess for status effect move [3]: ", getFunctionPointerWithIndex(index: routine[3]).hexString())
	
	for i in 0 ..< routine.count {
		
		if i < (routine.count - 6) {
			if routine[i] == 29 && routine[i + 1] == 18 {
				let effect = routine[i + 5]
				print("check false for status effect on foe: ", effect)
			}
			
			if routine[i] == 29 && routine[i + 1] == 17 {
				let effect = routine[i + 5]
				print("check false for status effect on user: ", effect)
			}
			
			if routine[i] == 30 && routine[i + 1] == 18 {
				let effect = routine[i + 5]
				print("check true for status effect on foe: ", effect)
			}
			
			if routine[i] == 30 && routine[i + 1] == 17 {
				let effect = routine[i + 5]
				print("check true for status effect on user: ", effect)
			}
		}
		
		if i < (routine.count - 3) {
			if routine[i] == 2 && routine[i + 1] == 4 {
				let index = routine[i + 2]
				print("initial function: ", getFunctionPointerWithIndex(index: index).hexString())
			}
		}
		
		if i < (routine.count - 3) {
			if routine[i] == 128 && routine[i + 1] == 65 && routine[i + 2] == 92 && routine[i + 3] == 147 {
				print("move fail routine")
			}
			if routine[i] == 128 && routine[i + 1] == 65 && routine[i + 2] == 65 && routine[i + 3] == 15 {
				print("end of routine")
			}
		}
	}
	
}



// colosseum shiny stuff
//let dol = XGFiles.dol.data
//
////shiny
//dol.replace4BytesAtOffset(0x8012442c - kColosseumDolToRamOffsetDifference, withBytes: 0x3B60FFFF)
//
//// female starter espeon
//dol.replace4BytesAtOffset(0x80130b1c - kColosseumDolToRamOffsetDifference, withBytes: 0x38800001)
//
//// shiny glitch
//dol.replace4BytesAtOffset(0x801248a8 - kColosseumDolToRamOffsetDifference, withBytes: 0x3B800000)
//
////dol.replace4BytesAtOffset(0x80124844 - kColosseumDolToRamOffsetDifference, withBytes: 0x38600008)
//dol.replace4BytesAtOffset(0x80124844 - kColosseumDolToRamOffsetDifference, withBytes: 0x38608000)
//
//dol.save()




