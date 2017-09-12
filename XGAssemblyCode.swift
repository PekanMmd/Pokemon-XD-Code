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

func revertDolInstructionFromOffset(offset: Int, length: Int) {
	
	let dol = XGFiles.dol.data
	
	for i in 0 ..< length {
		
		let off = offset + (i * 4)
		
		let original = XGFiles.original(.dol).data.get4BytesAtOffset(off)
		dol.replace4BytesAtOffset(off, withBytes: original)
		
	}
	dol.save()
}

func revertDolInstructionAtOffsets(offsets: [Int]) {
	
	let dol = XGFiles.dol.data
	
	for offset in offsets {
		
		let original = XGFiles.original(.dol).data.get4BytesAtOffset(offset)
		dol.replace4BytesAtOffset(offset, withBytes: original)
		
	}
	dol.save()
}

func paralysisHalvesSpped() {
	let dol = XGFiles.dol.data
	dol.replace4BytesAtOffset(0x203af8 - kDOLtoRAMOffsetDifference, withBytes: 0x56f7f87e)
	dol.save()
}

func replaceASM(startOffset: Int, newASM asm: ASM) {
	let dol = XGFiles.dol.data
	for i in 0 ..< asm.count {
		let offset = startOffset + (i * 4)
		let instruction = asm[i]
		dol.replace4BytesAtOffset(offset, withBytes: instruction)
	}
	dol.save()
}

func revertASM(startOffset: Int, newASM asm: ASM) {
	for i in 0 ..< asm.count {
		let offset = startOffset + (i * 4)
		revertDolInstructionFromOffset(offset: offset, length: 1)
	}
}

func removeASM(startOffset: Int, length: Int) {
	let asm = ASM(repeating: kNopInstruction, count: length)
	replaceASM(startOffset: startOffset, newASM: asm)
}

func ramPointerOffsetFromR13(offset: Int) -> Int {
	let R13 = 0x4efe20
	return R13 + offset
}

func getWordAtRamOffsetFromR13(offset: Int) -> Int {
	// this should be a pointer into common_rel
	let ram = XGFiles.nameAndFolder("xg ram.raw", .Reference).data
	return Int(ram.get4BytesAtOffset(ramPointerOffsetFromR13(offset: offset))) - kRELtoRAMOffsetDifference
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




