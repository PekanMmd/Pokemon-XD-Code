//
//  XGAssemblyCode.swift
//  XGCommandLineTools
//
//  Created by StarsMmd on 02/03/2017.
//  Copyright © 2017 StarsMmd. All rights reserved.
//

import Foundation

let kColosseumDolToRamOffsetDifference = 0x3000
let kColosseumDolToISOOffsetDifference = 0x1EC00

let kRELtoRAMOffsetDifference = 0xb18dc0 // add this value to a common_rel offset to get it's offset in RAM
let kDOLtoRAMOffsetDifference = 0x30a0   // add this value to a start.dol offset to get its offset in RAM
let kDOLTableToRAMOffsetDifference = 0x3000 // add this value to a start.dol data table offset to get its offset in RAM
let kDOLDataToRAMOffsetDifference = 0xCDE80 // add this value to a start.dol data offset (the values towards the end) to get its offset in RAM
let kDOLtoISOOffsetDifference = 0x20300 // add this value to a start.dol offset to get it's offset in the ISO

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
	
	class func instructionToBranchToSameFunction(_ inst: UInt32, originalOffset origin: UInt32, newOffset new: UInt32) -> UInt32 {
		// creates a new branch instruction using an existing one as the base
		// inst: the original instruction
		// origin: the offset of the original instruction
		// new: the offset where the new branch instruction will be located
		return inst - (new - origin)
		
	}
	
	class func ASMfreeSpacePointer() -> Int {
		// returns the next free instruction address (from common_rel) as a pointer to ram
		
		var offset = kRelFreeSpaceStart
		let rel = XGFiles.common_rel.data!
		var value = (rel.getWordAtOffset(offset - kRELtoRAMOffsetDifference), rel.getWordAtOffset(offset + 4 - kRELtoRAMOffsetDifference), rel.getWordAtOffset(offset + 8 - kRELtoRAMOffsetDifference), rel.getWordAtOffset(offset + 12 - kRELtoRAMOffsetDifference))
		while value != (0,0,0,0) {
			offset = offset + 4
			value = (rel.getWordAtOffset(offset - kRELtoRAMOffsetDifference), rel.getWordAtOffset(offset + 4 - kRELtoRAMOffsetDifference), rel.getWordAtOffset(offset + 8 - kRELtoRAMOffsetDifference), rel.getWordAtOffset(offset + 12 - kRELtoRAMOffsetDifference))
		}
		return offset
	}
	
	class func revertDolInstructionFromOffset(offset: Int, length: Int) {
		
		let dol = XGFiles.dol.data!
		
		for i in 0 ..< length {
			
			let off = offset + (i * 4)
			
			let original = XGFiles.original(.dol).data!.getWordAtOffset(off)
			dol.replaceWordAtOffset(off, withBytes: original)
			
		}
		dol.save()
	}
	
	class func revertDolInstructionAtOffsets(offsets: [Int]) {
		
		let dol = XGFiles.dol.data!
		
		for offset in offsets {
			
			let original = XGFiles.original(.dol).data!.getWordAtOffset(offset)
			dol.replaceWordAtOffset(offset, withBytes: original)
			
		}
		dol.save()
	}
	
	class func replaceASM(startOffset: Int, newASM asm: ASM) {
		
		var labels = [String : Int]()
		var currentOffset = startOffset + kDOLtoRAMOffsetDifference
		for inst in asm {
			switch inst {
			case .label(let name):
				labels[name] = currentOffset
			default:
				currentOffset += 4
			}
		}
		
		let dol = XGFiles.dol.data!
		currentOffset = startOffset + kDOLtoRAMOffsetDifference
		for inst in asm {
			switch inst {
			case .label:
				break
			case .b_l: fallthrough
			case .bl_l: fallthrough
			case .beq_l: fallthrough
			case .bne_l: fallthrough
			case .blt_l: fallthrough
			case .ble_l: fallthrough
			case .bgt_l: fallthrough
			case .bge_l:
				let code = inst.instructionForBranchToLabel(labels: labels).codeAtOffset(currentOffset)
				dol.replaceWordAtOffset(currentOffset - kDOLtoRAMOffsetDifference, withBytes: code)
				currentOffset += 4
			default:
				let code = inst.codeAtOffset(currentOffset)
				dol.replaceWordAtOffset(currentOffset - kDOLtoRAMOffsetDifference, withBytes: code)
				currentOffset += 4
			}
			
		}
		dol.save()
	}
	
	class func replaceRELASM(startOffset: Int, newASM asm: ASM) {
		let ramOffset = startOffset > kRELtoRAMOffsetDifference ? kRELtoRAMOffsetDifference : 0
		
		var labels = [String : Int]()
		var currentOffset = startOffset - ramOffset + kRELtoRAMOffsetDifference
		for inst in asm {
			switch inst {
			case .label(let name):
				labels[name] = currentOffset
			default:
				currentOffset += 4
			}
		}
		
		
		let rel = XGFiles.common_rel.data!
		currentOffset = startOffset - ramOffset + kRELtoRAMOffsetDifference
		for inst in asm {
			switch inst {
			case .label:
				break
			case .b_l: fallthrough
			case .bl_l: fallthrough
			case .beq_l: fallthrough
			case .bne_l: fallthrough
			case .blt_l: fallthrough
			case .ble_l: fallthrough
			case .bgt_l: fallthrough
			case .bge_l:
				let code = inst.instructionForBranchToLabel(labels: labels).codeAtOffset(currentOffset)
				rel.replaceWordAtOffset(currentOffset - kRELtoRAMOffsetDifference, withBytes: code)
				currentOffset += 4
			default:
				let code = inst.codeAtOffset(currentOffset)
				rel.replaceWordAtOffset(currentOffset - kRELtoRAMOffsetDifference, withBytes: code)
				currentOffset += 4
			}
			
		}
		rel.save()
	}
	
	class func replaceASM(startOffset: Int, newASM asm: [UInt32]) {
		let dol = XGFiles.dol.data!
		for i in 0 ..< asm.count {
			let offset = startOffset + (i * 4)
			let instruction = asm[i]
			dol.replaceWordAtOffset(offset, withBytes: instruction)
		}
		dol.save()
	}
	
	class func replaceRELASM(startOffset: Int, newASM asm: [UInt32]) {
		let ramOffset = startOffset > kRELtoRAMOffsetDifference ? kRELtoRAMOffsetDifference : 0
		let rel = XGFiles.common_rel.data!
		for i in 0 ..< asm.count {
			let offset = startOffset + (i * 4) - ramOffset
			let instruction = asm[i]
			rel.replaceWordAtOffset(offset, withBytes: instruction)
		}
		rel.save()
	}
	
	class func replaceRamASM(RAMOffset: Int, newASM asm: [XGASM]) {
		if RAMOffset > kRELtoRAMOffsetDifference {
			replaceRELASM(startOffset: RAMOffset - kRELtoRAMOffsetDifference, newASM: asm)
		} else {
			replaceASM(startOffset: RAMOffset - kDOLtoRAMOffsetDifference, newASM: asm)
		}
	}
	
	class func revertASM(startOffset: Int, newASM asm: [UInt32]) {
		for i in 0 ..< asm.count {
			let offset = startOffset + (i * 4)
			revertDolInstructionFromOffset(offset: offset, length: 1)
		}
	}
	
	class func removeASM(startOffset: Int, length: Int) {
		let asm = [UInt32](repeating: kNopInstruction, count: length)
		replaceASM(startOffset: startOffset, newASM: asm)
	}
	
	class func ramPointerOffsetFromR13(offset: Int) -> Int {
		let R13 = 0x4efe20
		return R13 + offset
	}
	
	class func getWordAtRamOffsetFromR13(offset: Int) -> Int {
		// this should be a pointer into common_rel
		let ram = XGFiles.nameAndFolder("xg ram.raw", .Resources).data!
		return Int(ram.getWordAtOffset(ramPointerOffsetFromR13(offset: offset)))
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
		let diff = UInt32(difference & 0xFFFF)
		return UInt32(16 << 26) + (BO << 21) + (BI << 16) + diff
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
	
	class func setProtectRepeatChanceQuotient(_ divisor: Int) {
		var currentValue = 0xFFFF
		var currentOffset = 0x4eeb90 - kDOLDataToRAMOffsetDifference
		let dol = XGFiles.dol.data!
		for _ in 0 ..< 4 {
			dol.replace2BytesAtOffset(currentOffset, withBytes: currentValue)
			currentOffset += 2
			currentValue /= divisor
		}
		dol.save()
	}
	
	class func paralysisHalvesSpeed() {
		let dol = XGFiles.dol.data!
		dol.replaceWordAtOffset(0x203af8 - kDOLtoRAMOffsetDifference, withBytes: 0x56f7f87e)
		dol.save()
	}
	
	class func setFirsHM(_ tm: XGTMs) {
		let off1 = 0x15e92c - kDOLtoRAMOffsetDifference
		let off2 = 0x15e948 - kDOLtoRAMOffsetDifference
		// i.e. for tm51 to be first hm compare with 50
		let compareIndex = tm.index - 1
		let ins1 = [XGASM.cmpwi(.r3, compareIndex)]
		let ins2 = [XGASM.subi(.r0, .r3, compareIndex)]
		replaceASM(startOffset: off1, newASM: ins1)
		replaceASM(startOffset: off2, newASM: ins2)
	}
	
	class func setShadowMovesUseHMFlag() {
		
		if game == .XD && region == .US {
			if !shadowMovesUseHMFlag {
				for move in allMovesArray() {
					let data = move.data
					data.HMFlag = move.isShadowMove
					data.save()
				}
				
				let shadowPPstart = ASMfreeSpacePointer()
				let shadowPPCodeStart = 0x146f28
				let checkShadowMove = 0x13e514 // get hm flag but could use any function you like
				let notShadow = 0x146f50
				let (lis, addi) = XGASM.loadImmediateShifted32bit(register: .r0, value: shadowPPstart.unsigned)
				let endBranch = 0x146f78
					
				// shadow move check function branches to hm flag
				XGAssembly.replaceASM(startOffset: 0x13d048, newASM: [.bl(checkShadowMove)])
				
				replaceASM(startOffset: shadowPPCodeStart - kDOLtoRAMOffsetDifference, newASM: [
					.mr(.r29, .r3),
					.bl(checkShadowMove),
					.cmpwi(.r3, 1),
					.bne(notShadow),
					.mr(.r4, .r29),
					 lis,
					.rlwinm(.r4, .r4, 2, 0 , 29), // multiply by 4
					 addi,
					.add(.r3, .r4, .r0),
					.b(endBranch)
					])
				
				let rel = XGFiles.common_rel.data!
				var currentOffset = shadowPPstart
				for i in 0 ..< CommonIndexes.NumberOfMoves.value {
					rel.replaceWordAtOffset(currentOffset, withBytes: (i.unsigned << 16) + (5 << 8))
					currentOffset += 4
				}
				rel.save()
			}
		}
	}
	
	class func infiniteUseTMs() {
		let dol = XGFiles.dol.data!
		dol.replaceWordAtOffset(0x0a5158 - kDOLtoRAMOffsetDifference, withBytes: 0x38000000)
		dol.save()
	}
	
	class func increaseNumberOfAbilities() {
		// only run this once!
		
		let dol = XGFiles.dol.data!
		let abilityStart = 0x3FCC50
		
		let newAbilityEntryMultiplier : UInt32 = 0x1c830008
		let abilityMultiplierAddress = 0x1442b0 - kDOLtoRAMOffsetDifference
		
		let abilityGetName : UInt32 = 0x80630000
		let abilityGetNameAddress = 0x144290 - kDOLtoRAMOffsetDifference
		
		let abilityGetDescription : UInt32 = 0x80630004
		let abilityGetDescriptionAddress = 0x144278 - kDOLtoRAMOffsetDifference
		
		let sizeOfAbilityTable = 0x3A8
		let newNumberOfEntries = sizeOfAbilityTable / 8
		
		dol.replaceWordAtOffset(abilityMultiplierAddress, withBytes: newAbilityEntryMultiplier)
		dol.replaceWordAtOffset(abilityGetNameAddress, withBytes: abilityGetName)
		dol.replaceWordAtOffset(abilityGetDescriptionAddress, withBytes: abilityGetDescription)
		
		
		var allabilities = [(UInt32,UInt32)]()
		
		for j in 0 ... kNumberOfAbilities {
			
			let offset = abilityStart + (j * 12)
			allabilities.append((dol.getWordAtOffset(offset + 4),dol.getWordAtOffset(offset + 8)))
			
		}
		
		for i in 0 ..< newNumberOfEntries {
			
			let offset = abilityStart + (i * 8)
			
			if i < allabilities.count {
				
				dol.replaceWordAtOffset(offset    , withBytes: allabilities[i].0)
				dol.replaceWordAtOffset(offset + 4, withBytes: allabilities[i].1)
				
			} else {
				
				dol.replaceWordAtOffset(offset    , withBytes: 0)
				dol.replaceWordAtOffset(offset + 4, withBytes: 0)
				
			}
		}
		
		dol.replaceWordAtOffset(0x41db38, withBytes: 0x74)
		
		dol.save()
		
	}
	
	class func gen6CriticalHitMultiplier() {
		
		let dol = XGFiles.dol.data!
		
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
			dol.replaceWordAtOffset(offset1, withBytes: instructions1[i].unsigned)
			
			let offset2 = off2 + (i * 4)
			dol.replaceWordAtOffset(offset2, withBytes: instructions2[i].unsigned)
		}
		
		dol.save()
		
	}
	
	class func setDeoxysForme(to forme: XGDeoxysFormes) {
		
		// outdated. could simply return the required form id from the
		// function that calculates deoxys form based on game.
		// this function is found in ram at offset 0x80140128
		
		// cosmetic only
		
		let dol = XGFiles.dol.data!
		
		for offset in [0x1D8F8C, 0x1D900C] {
			
			let off = offset - kDOLtoRAMOffsetDifference
			dol.replaceWordAtOffset(off, withBytes: 0x54001838)
		}
		
		for offset in [0x1117F0,0x111840,0x1D8F88,0x1D9008] {
			
			let off = offset - kDOLtoRAMOffsetDifference
			dol.replaceWordAtOffset(off, withBytes: UInt32(0x38000000 + forme.rawValue))
		}
		
		dol.save()
		
	}
	
	class func shareEXPWithParty() {
		
		let dol = XGFiles.dol.data!
		
		for offset in [0x212C48,0x212E04] {
			
			let off = offset - kDOLtoRAMOffsetDifference
			dol.replaceWordAtOffset(off, withBytes: kNopInstruction)
		}
		
		dol.save()
		
	}
	
	class func determineShininessFrom0x1CForDeckPokemon() {
		
		let dol = XGFiles.dol.data!
		
		if dol.getWordAtOffset(0x28bb30 - kDOLtoRAMOffsetDifference) == 0xA0DB001C {
			return
		}
		
		// make 1d load 2 bytes from 1c using values from r27 instead of r3 (given that r27 now points to deck data)
		dol.replaceWordAtOffset(0x28bb30 - kDOLtoRAMOffsetDifference, withBytes: 0xA0DB001C)
		dol.replaceWordAtOffset(0x28bb20 - kDOLtoRAMOffsetDifference, withBytes: 0x281B0000)
		dol.replaceWordAtOffset(0x28bb28 - kDOLtoRAMOffsetDifference, withBytes: 0x38C00000)
		
		// remove use of r27 so we can steal it >=D
		dol.replaceWordAtOffset(0x1fbee0 - kDOLtoRAMOffsetDifference, withBytes: kNopInstruction)
		
		// store the deck data pointer in r27 so we can use it again later
		dol.replaceWordAtOffset(0x1fbd00 - kDOLtoRAMOffsetDifference, withBytes: 0x7F5BD378)
		
		// load 1d into r6 before pid gen
		let offsets = [0x1fbef4,0x1fbfb8]
		
		for offset in offsets {
			dol.replaceWordAtOffset(offset - kDOLtoRAMOffsetDifference, withBytes: instructionToBranchToSameFunction(0x4808fdcd, originalOffset: 0x1fbd54, newOffset: UInt32(offset)))
		}
		
		// where the game read from 1d, now read from 1f
		dol.replaceWordAtOffset(0x1fbd54 - kDOLtoRAMOffsetDifference, withBytes: instructionToBranchToSameFunction(0x4808fdc5, originalOffset: 0x1fbcec, newOffset: 0x1fbd54))
		
		// where the game read from 1f just load 0 instead
		dol.replaceWordAtOffset(0x1fbcec - kDOLtoRAMOffsetDifference, withBytes: 0x38600000)
		
		
		dol.save()
		
	}
	
	class func switchDPKMStructureToShinyStyle() {
		// only do this once!
		
		if game == .XD {
			if region == .US { // remove once other region offsets are found
				let decks = TrainerDecksArray
				
				for deck in decks {
					for p in deck.allPokemon {
						
						p.priority   = p.shinyness.rawValue
						p.shinyness = .never
						p.save()
						
					}
				}
				
				if region == .US {
					XGAssembly.replaceASM(startOffset: 0x28bac0 - kDOLtoRAMOffsetDifference, newASM: [0x8863001f, kNopInstruction])
				}
			}
		}
		
	}
	
	class func fixShinyGlitch() {
		// generated deck pokemon are given the player's tid
		
		if game == .XD {
			if region == .US {
				
				let shinyStart = 0x1fa930
				let getTrainerData = 0x1cefb4
				let trainerGetTID = 0x14e118
				replaceASM(startOffset: shinyStart - kDOLtoRAMOffsetDifference, newASM: [
					0x38600000, // li r3, 0
					0x38800002, // li r4, 2
					createBranchAndLinkFrom(offset: shinyStart + 0x8, toOffset: getTrainerData),
					createBranchAndLinkFrom(offset: shinyStart + 0xc, toOffset: trainerGetTID),
				])
				
				printg("shiny glitch fixed")
			} else if region == .EU {
				
				let shinyStart = 0x1fc650
				let getTrainerData = 0x1d0a8c
				let trainerGetTID = 0x14f9dc
				replaceASM(startOffset: shinyStart - kDOLtoRAMOffsetDifference, newASM: [
					0x38600000, // li r3, 0
					0x38800002, // li r4, 2
					createBranchAndLinkFrom(offset: shinyStart + 0x8, toOffset: getTrainerData),
					createBranchAndLinkFrom(offset: shinyStart + 0xc, toOffset: trainerGetTID),
				])
				
			} else {
				printg("shiny glitch can't be fixed for JP region yet")
			}
		}
	}
	
	class func setShadowPokemonShininess(value: XGShinyValues) {
		// gens deck pokemon with shiny always set to value
		
		if game == .XD {
			if region == .JP {
				printg("shadow pokemon shininess can't be changed for JP region yet")
				return
			}
			
			var startOffset = 0x0
			
			if region == .US {
				startOffset = 0x1fc2b0
			}
			if region == .EU {
				startOffset = 0x1fdfe4
			}
			
			replaceASM(startOffset: startOffset - kDOLtoRAMOffsetDifference, newASM: [0x38c00000 + UInt32(value.rawValue)])
			
			printg("shadow pokemon shininess set to", value.string)
		}
	}
	
	class func switchNextPokemonAtEndOfTurn() {
		// you no longer send in a new pokemon as soon as one faints. Now waits until end of turn. Still experimental!
		// pretty much a copy and paste of all the code that would be called at the end of the move routine with just a few lines of code where the switching happens being omitted. Not a very elegant solution but effective.
		
		if game == .XD && region == .US {
			let switchlessStart = ASMfreeSpacePointer()
			let switchless2Start = switchlessStart + 0x74
			let switchlessBranch = 0x20e36c
			let executeCodeRoutine = 0x1f3bec
			let intimidateRoutine = 0x225c04
			let unkownRoutine = 0x225ac8
			let battleEntryEffects = 0x226474
			let animSoundCallback = 0x2236a8
			let switchlessCode : [UInt32] = [
				0x9421fff0,
				0x7c0802a6,
				0x3c808022,
				0x38600000,
				0x90010014,
				0x388475f8,
				0x38a00000,
				0x38c00000,
				createBranchAndLinkFrom(offset: switchlessStart + 0x20, toOffset: executeCodeRoutine),
				
				createBranchAndLinkFrom(offset: switchlessStart + 0x24, toOffset: switchless2Start),
				
				0x3c608041,
				0x386369f0,
				createBranchAndLinkFrom(offset: switchlessStart + 0x30, toOffset: animSoundCallback),
				0x38600001,
				createBranchAndLinkFrom(offset: switchlessStart + 0x38, toOffset: intimidateRoutine),
				createBranchAndLinkFrom(offset: switchlessStart + 0x3c, toOffset: unkownRoutine),
				0x3c808022,
				0x38600000,
				0x38847588,
				0x38a00000,
				0x38c00000,
				createBranchAndLinkFrom(offset: switchlessStart + 0x54, toOffset: executeCodeRoutine),
				createBranchAndLinkFrom(offset: switchlessStart + 0x58, toOffset: battleEntryEffects),
				0x80010014,
				0x7c0803a6,
				0x38210010,
				0x38000002,
				0x980dbb14,
				0x4e800020
			]
			
			let moveRoutineGetPosition = 0x2236f8
			let getPokemonPointer = 0x1efcac
			let getCurrentMove = 0x148d64
			let getAllyTrainerNumber = 0x1f7688
			let getFoeTrainerNumber = 0x1f7640
			let unknown = 0x1f87ac
			let setAppropriateBattleResult = 0x1f3dac
			let moveRoutineUpdatePosition = 0x2236dc
			let switchless2Code : [UInt32] = [
				0x9421ffe0,
				0x7c0802a6,
				0x90010024,
				0xbf61000c,
				createBranchAndLinkFrom(offset: switchless2Start + 0x10, toOffset: moveRoutineGetPosition),
				0x80a30001,
				0x38600011,
				0x38800000,
				0x3005ffff,
				0x7c002910,
				0x541f063e,
				createBranchAndLinkFrom(offset: switchless2Start + 0x2c, toOffset: getPokemonPointer),
				0x7c7e1b78,
				createBranchAndLinkFrom(offset: switchless2Start + 0x34, toOffset: getCurrentMove),
				0x7c601b78,
				0x38600000,
				0x7c1b0378,
				createBranchAndLinkFrom(offset: switchless2Start + 0x44, toOffset: getAllyTrainerNumber),
				0x547d063e,
				0x38600000,
				createBranchAndLinkFrom(offset: switchless2Start + 0x50, toOffset: getFoeTrainerNumber),
				0x547c063e,
				0x38600005,
				0x38800000,
				createBranchAndLinkFrom(offset: switchless2Start + 0x60, toOffset: getPokemonPointer),
				0x7fa4eb78,
				0x7f85e378,
				createBranchAndLinkFrom(offset: switchless2Start + 0x6c, toOffset: unknown),
				0x28030000,
				0x40820010,
				0x38600000,
				0x38800002,
				createBranchAndLinkFrom(offset: switchless2Start + 0x80, toOffset: setAppropriateBattleResult),
				0x38600004,
				0x38800000,
				createBranchAndLinkFrom(offset: switchless2Start + 0x8c, toOffset: getPokemonPointer),
				0x7fa4eb78,
				0x7f85e378,
				createBranchAndLinkFrom(offset: switchless2Start + 0x98, toOffset: unknown),
				0x28030000,
				0x40820010,
				0x38600000,
				0x38800003,
				createBranchAndLinkFrom(offset: switchless2Start + 0xac, toOffset: setAppropriateBattleResult),
				0x38600005,
				createBranchAndLinkFrom(offset: switchless2Start + 0xb4, toOffset: moveRoutineUpdatePosition),
				0xbb61000c,
				0x80010024,
				0x7c0803a6,
				0x38210020,
				powerPCBranchLinkReturn()
				
			]
			
			XGAssembly.replaceRELASM(startOffset: switchlessStart - kRELtoRAMOffsetDifference, newASM: switchlessCode + switchless2Code)
			XGAssembly.replaceASM(startOffset: switchlessBranch - kDOLtoRAMOffsetDifference, newASM: [createBranchAndLinkFrom(offset: switchlessBranch, toOffset: switchlessStart)])
		}
		
	}
	
	class func routineForSingleStatBoost(stat: XGStats, stages: XGStatStages) -> [Int] {
		return [0x2f, 0xff, 0x01, 0x60, 0x1e, stat.rawValue + stages.rawValue, 0x29, 0x80, 0x41, 0x44, 0x39,]
	}
	
	class func routineForTargetStatDrop(stat: XGStats, stages: XGStatStages) -> [Int] {
		return [0x2f, 0xff, 0x01, 0x60, 0x1e, stat.rawValue + stages.rawValue, 0x29, 0x80, 0x41, 0x44, 0xcd,]
	}
	
	class func routineForMultipleStatBoosts(RAMOffset: Int, boosts: [(stat: XGStats, stages: XGStatStages)], affectsUser: Bool) -> [Int] {
		return routineForMultipleStatBoosts(RAMOffset: RAMOffset, boosts: boosts, isSecondaryEffect: false, affectsUser: affectsUser)
	}
	
	class func routineForMultipleStatBoosts(RAMOffset: Int, boosts: [(stat: XGStats, stages: XGStatStages)], isSecondaryEffect: Bool, affectsUser: Bool) -> [Int] {
		// MULTI STAT BOOST
		// intro
		// --> stat checks
		// check stat + #end of stat checks (0 ... n)
		// check stat + 0x804167d9 (no stats can be boosted so fail)
		// --> end of stat checks
		// mask
		// --> loop start of current boost
		// start boost + #end of current boost
		// mid boost + #end of current boost
		// end boost
		// -->
		// outro
		
		if boosts.isEmpty {
			return [Int]()
		}
		
		let posBoosts = boosts.filter { (boost : (stat: XGStats, stages: XGStatStages)) -> Bool in
			return boost.stages.trueValue > 0
		}
		
		let stats = boosts.map { (boost: (stat: XGStats, stages: XGStatStages)) -> XGStats in
			return boost.stat
		}
		
		let intro = !isSecondaryEffect ? [0x00, 0x2, 0x4] : [Int]() // move animation
		let animation = !isSecondaryEffect ? [0x0a, 0x0b, 0x4] : [Int]() // move animation 2
		let mask = [0x2f, 0x80, 0x4e, 0xb9, 0x6c, 0x00, 0x49, 0x11, XGStats.maskForStats(stats: stats), 0x00]
		let midBoost = [0x2a, 0x00, 0x80, 0x4e, 0x85, 0xc5, 0x02,]
		let endBoostPositive = [0x14, 0x80, 0x2f, 0x8f, 0xc8, 0x3a, 0x00, 0x40,]
		let endBoostNegative = [0x14, 0x80, 0x2f, 0x8f, 0xe0, 0x3a, 0x00, 0x40,]
		let outro = [0x13, 0x00, 0x00, 0x0b, 0x04, 0x29, 0x80, 0x41, 0x41, 0x0f,]
		
		let sizeOfCheckStat = 9
		let sizeOfStatBoost = 31
		let statCheckEnd = RAMOffset + (posBoosts.count * sizeOfCheckStat) + intro.count
		
		func checkStat(stat: XGStats, stages: XGStatStages, final: Bool) -> [Int] {
			let comp = stages.trueValue > 0 ? 0x3 : 0x2
			
			// comparisons
			// 0 beq
			// 1 bne
			// 2 ble
			// 3 bge
			// 5 branch if equals negation?
			
			return [0x21, 0x11, final ? 0x00 : comp, stat.rawValue, stages.trueValue > 0 ? 0x0c : 0x00]
		}
		
		func boostStart(stat: XGStats, stages: XGStatStages) -> [Int] {
			
			// if set then even if mist is active or the user has the ability clear body/white smoke,
			// the stat buff/nerf will still occur. e.g. superpower
			let notAffectedByClearBodyOrMistMask = 0x80
			
			// if set the stat buff/nerf will be applied to the pokemon that used the move,
			// otherwise it will be applied to the pokemon that was targeted by the move
			let affectsUserMask = 0x40
			
			// if set, the stat buff/nerf will still activate even if the move was protected against.
			// Probably doesn't apply to any moves but used for abilities like intimidate
			//let activatesThroughProtectMask = 0x20
			
			// if set, when the stat buff/nerf fails (e.g. blocked by mist or an ability),
			// an appropriate message is displayed to explain that it failed.
			let showsAnimationOnFailureMask = 0x1
			
			var flagsMask = 0x0
			if !isSecondaryEffect { flagsMask += showsAnimationOnFailureMask }
			if affectsUser || (stages.trueValue > 0) { flagsMask += notAffectedByClearBodyOrMistMask }
			if affectsUser { flagsMask += affectsUserMask }
			
			
			return [0x2f, 0xff, 0x01, 0x60, 0x1e, stages.rawValue + stat.rawValue, 0x8a, flagsMask,]
		}
		
		var routine = intro
		
		if posBoosts.count > 1 {
			for i in 0 ..< posBoosts.count - 1 {
				routine += checkStat(stat: posBoosts[i].stat, stages: posBoosts[i].stages, final: false) + intAsByteArray(statCheckEnd)
			}
		}
		if posBoosts.count > 0 {
			routine += checkStat(stat: posBoosts.last!.stat, stages: posBoosts.last!.stages, final: true) + intAsByteArray(0x804167d9)
		}
		
		routine += animation
		routine += mask
		
		var currentEndOffset = statCheckEnd + animation.count + mask.count + sizeOfStatBoost
		for boost in boosts {
			routine += boostStart(stat: boost.stat, stages: boost.stages) + intAsByteArray(currentEndOffset)
			routine += midBoost + intAsByteArray(currentEndOffset)
			routine += boost.stages.trueValue > 0 ? endBoostPositive : endBoostNegative
			
			currentEndOffset += sizeOfStatBoost
		}
		
		routine += outro
		
		return routine
	}
	
	class func hitWithSecondaryEffectOpenEnded(effect: Int) -> [Int] {
		var end = [Int]()
		
		if effect >= 0x16 && effect <= 0x1c {
			end = [0x2f, 0xff, 0x01, 0x60, 0x1e, 0x10 + effect - 0x15]
		}
		
		if effect >= 0x4f && effect <= 0x55 {
			end = [0x2f, 0xff, 0x01, 0x60, 0x1e, 0x10 + effect - 0x4e]
		}
		
		return [0x2f, 0x80, 0x4e, 0x85, 0xc3, effect,] + end
		
	}
	
	class func routineHitAllWithSecondaryEffect(effect: Int) -> [Int] {
		
		return hitWithSecondaryEffectOpenEnded(effect: effect) + [0x29, 0x80, 0x41, 0x58, 0xfb]
	}
	
	class func routineHitWithSecondaryEffect(effect: Int) -> [Int] {
		
		return hitWithSecondaryEffectOpenEnded(effect: effect) + [0x29, 0x80, 0x41, 0x40, 0x90]
	}
	
	class func routineHitAndBranchToRoutine(routineOffsetRAM offset: Int) -> [Int] {
		return routineRegularHitOpenEnded() + [0x29] + intAsByteArray(offset)
	}
	
	class func routineHitAndStatChange(routineOffsetRAM offset: Int, boosts: [((stat: XGStats, stages: XGStatStages))], affectsUser: Bool) -> [Int] {
		let regularHit = routineRegularHitOpenEnded()
		let statStart = offset + regularHit.count
		
		return regularHit + routineForMultipleStatBoosts(RAMOffset: statStart, boosts: boosts, isSecondaryEffect: true, affectsUser: affectsUser)
	}
	
	class func routineRegularHitOpenEnded() -> [Int] {
		return [0x00, 0x02, 0x04, 0x05, 0x06, 0x07, 0x08, 0x2f, 0x80, 0x4e, 0xb9, 0x78, 0x00, 0x0a, 0x0b, 0x00, 0x0f, 0x5d, 0x12, 0x3b, 0x0c, 0x12, 0x0e, 0x13, 0x00, 0x40, 0x10, 0x13, 0x00, 0x50, 0x0d, 0x12, 0x0b, 0x04, 0x16, 0x1a, 0x12, 0x00, 0x00, 0x00, 0x00, 0x00, 0x2f, 0x80, 0x4e, 0xb9, 0x47, 0x00, 0x84, 0x84, 0x84,
			// after move, rough skin, poison touch, life orb etc.
			0x2f, 0x80, 0x4e, 0xb9, 0x47, 0x00, 0x4a, 0x00, 0x00,
			// special updated jump if status, jump to end of move routine, requires updating asm routine
			0x1e, 0x11, 0x00, 0x00, 0x00, 0xff, 0x80, 0x41, 0x41, 0x18,
		]
	}
	
	
	class func getRoutineStartForMoveEffect(index: Int) -> Int {
		let effectOffset = index * 4
		let pointerOffset = moveEffectTableStartDOL + effectOffset
		let pointer = XGFiles.dol.data!.getWordAtOffset(pointerOffset) - 0x80000000
		return Int(pointer)
	}
	
	class func routineDataForMoveEffect(effect: Int) -> [Int] {
		var start = getRoutineStartForMoveEffect(index: effect)
		var routine =  [Int]()
		var file : XGFiles!
		
		if start - kRELtoRAMOffsetDifference > 0 {
			// in common_rel
			file = XGFiles.common_rel
			start = start - kRELtoRAMOffsetDifference
			
		} else {
			// in dol
			file = XGFiles.dol
			start = start - kDOLtoRAMOffsetDifference + 0xa0
			
		}
		
		let data = file.data!
		
		routine = data.getByteStreamFromOffset(start, length: 4)
		
		// just educated guesses but not guaranteed to be the correct end
		// there's no real marker for the end
		// the code just follows the branches and jumps from routine to routine
		// until the routine ending function is hit
		var i = 4
		var endFound = false
		while !endFound {
			
			routine.append(data.getByteAtOffset(start + i))
			
			if routine[i] == 15 && routine[i - 1] == 65 && routine[i - 2] == 65 && routine[i - 3] == 128 {
				endFound = true
			}
			
			if routine[i] == 57 && routine[i - 1] == 68 && routine[i - 2] == 65 && routine[i - 3] == 128 {
				endFound = true
			}
			
//			if routine[i] == 0x90 && routine[i - 1] == 64 && routine[i - 2] == 65 && routine[i - 3] == 128 {
//				endFound = true
//			}
			
			if routine[i] == 0xcd && routine[i - 1] == 68 && routine[i - 2] == 65 && routine[i - 3] == 128 {
				endFound = true
			}
			
			if routine[i] == 0xc8 && routine[i - 1] == 87 && routine[i - 2] == 65 && routine[i - 3] == 128 {
				endFound = true
			}
			
			if routine[i] == 0xe8 && routine[i - 1] == 64 && routine[i - 2] == 65 && routine[i - 3] == 128 {
				endFound = true
			}
			
			if routine[i] == 0xcd && routine[i - 1] == 0x45 && routine[i - 2] == 65 && routine[i - 3] == 128 {
				endFound = true
			}
			
//			if data.getByteAtOffset(start + i + 1) == 0x0 && data.getByteAtOffset(start + i + 2) == 0x2 && data.getByteAtOffset(start + i + 3) == 0x4 {
//				endFound = true
//			}
//			
//			if data.getByteAtOffset(start + i + 1) == 0x0 && data.getByteAtOffset(start + i + 2) == 0x1 && data.getByteAtOffset(start + i + 3) == 0x80 {
//				endFound = true
//			}
			
			i += 1
		}
		
		
		return routine
		
	}
	
	class func routineDataForMove(move: XGMoves) -> [Int] {
		return routineDataForMoveEffect(effect: move.data.effect)
	}
	
	class func setMoveEffectRoutine(effect: Int, fileOffset: Int, moveToREL rel: Bool, newRoutine routine: [Int]?) {
		let effectOffset = effect * 4
		let pointerOffset = moveEffectTableStartDOL + effectOffset
		let RAMOffset = UInt32(fileOffset + (rel ? kRELtoRAMOffsetDifference : kDOLTableToRAMOffsetDifference)) + 0x80000000
		
		let dol = XGFiles.dol.data!
		dol.replaceWordAtOffset(pointerOffset, withBytes: RAMOffset)
		dol.save()
		
		if routine != nil {
			let file = rel ? XGFiles.common_rel.data! : XGFiles.dol.data!
			file.replaceBytesFromOffset(fileOffset, withByteStream: routine!)
			file.save()
		}
	}
	
	class func setMoveEffectRoutineRAMOffset(effect: Int, RAMOffset offset: UInt32) {
		let effectOffset = effect * 4
		let pointerOffset = moveEffectTableStartDOL + effectOffset
		let RAMOffset = offset + (offset > 0x80000000 ? 0 : 0x80000000)
		
		let dol = XGFiles.dol.data!
		dol.replaceWordAtOffset(pointerOffset, withBytes: RAMOffset)
		dol.save()
	}
	
	
	class func newStatBoostRoutine(effect: Int, boosts: [(stat: XGStats, stages: XGStatStages)], RAMOffset: Int?, affectsUser: Bool) -> [Int] {
		
		var routine = [Int]()
		let offset = RAMOffset ?? ASMfreeSpacePointer()
		
		if boosts.count == 1 {
			if affectsUser {
				routine = routineForSingleStatBoost(stat: boosts[0].stat, stages: boosts[0].stages)
			} else {
				routine = routineForTargetStatDrop(stat: boosts[0].stat, stages: boosts[0].stages)
			}
		} else {
			routine = routineForMultipleStatBoosts(RAMOffset: 0x80000000 + offset, boosts: boosts, isSecondaryEffect: false, affectsUser: affectsUser)
		}
		
		return routine
		
	}
	
	class func startOffsetForMoveRoutineFunction(index: Int) -> UInt32 {
		let firstPointer = 0x2f8af8 - kDOLTableToRAMOffsetDifference
		return XGFiles.dol.data!.getWordAtOffset(firstPointer + (4 * index))
	}
	
	class func intAsByteArray(_ i: Int) -> [Int] {
		var val = i
		var array = [0,0,0,0]
		for j in [3,2,1,0] {
			array[j] = val % 0x100
			val = val >> 8
		}
		return array
	}
	
	class func intAsByteArray(_ i: UInt32) -> [Int] {
		var val = i
		var array = [0,0,0,0]
		for j in [3,2,1,0] {
			array[j] = Int(val % 0x100)
			val = val >> 8
		}
		return array
	}
}






// colosseum shiny stuff
//let dol = XGFiles.dol.data!
//
////shiny
//dol.replaceWordAtOffset(0x8012442c - kColosseumDolToRamOffsetDifference, withBytes: 0x3B60FFFF)
//
//// female starter espeon
//dol.replaceWordAtOffset(0x80130b1c - kColosseumDolToRamOffsetDifference, withBytes: 0x38800001)
//
//// shiny glitch
//dol.replaceWordAtOffset(0x801248a8 - kColosseumDolToRamOffsetDifference, withBytes: 0x3B800000)
//
// shiny chance
////dol.replaceWordAtOffset(0x80124844 - kColosseumDolToRamOffsetDifference, withBytes: 0x38600008)
//
//dol.save()




