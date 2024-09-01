//
//  XGAssemblyCode.swift
//  XGCommandLineTools
//
//  Created by StarsMmd on 02/03/2017.
//  Copyright © 2017 StarsMmd. All rights reserved.
//

import Foundation

let kDolToRAMOffsetDifference: Int = {
	   // add this value to a start.dol offset to get its offset in RAM
	switch game {
	case .XD:
		return 0x30a0
	case .Colosseum:
		return 0x3000
	case .PBR:
		return 0x43A0
	}
}()

let kDolTableToRAMOffsetDifference: Int = {
 // add this value to a start.dol data table offset to get its offset in RAM
	switch game {
	case .XD:
		return 0x3000
	case .Colosseum:
		return 0x3000
	case .PBR:
		return 0x3F00
	}
}()

let kDolDataToRAMOffsetDifference: Int = {
	// add this value to a start.dol data offset (the values towards the end) to get its offset in RAM
	switch game {
	case .XD:
		return 0xCDE80
	case .Colosseum:
		assertionFailure("Not implemented")
		return -1
	case .PBR:
		assertionFailure("Not implemented")
		return 0x1CDFE0
	}
}()

let kDolToISOOffsetDifference: Int = {
	// add this value to a start.dol offset to get it's offset in the ISO
	switch game {
	case .XD:
		return 0x20300
	case .Colosseum:
		return 0x1EC00
	case .PBR:
		assertionFailure("Not implemented")
		return -1
	}
}()

let kDOLRAMToISOOffsetDifference: Int = {
	// add this value to a start.dol RAM offset to get it's offset in the ISO
	kDolToISOOffsetDifference - kDolToRAMOffsetDifference
}()

var kRELtoRAMOffsetDifference: Int {
	if region == .US {
		if game == .XD {
			return 0xb18dc0 // add this value to a common_rel offset to get it's offset in RAM,  XD US
		} else {
			return 0x7628A0
		}
	}
	#warning("TODO: find rel to ram offset for other regions and colosseum")
	assertionFailure("TODO: find rel to ram offset for other regions and colosseum")
	return -0x80000000
}
let kRELDataStartOffset = 0x1CB0 // XD US
let kRelFreeSpaceStart = 0x80590 + kRELtoRAMOffsetDifference // XD US

let kPickupTableInDolStartOffset = 0x2F0758 // XD US

fileprivate var kPBRDOLFreeSpaceStart: Int? {
	switch region {
	case .US: return 0x1D9474 - kDolToRAMOffsetDifference
	case .EU: return 0x1D4838 - kDolToRAMOffsetDifference
	case .JP: return 0x1CA57C - kDolToRAMOffsetDifference
	case .OtherGame: return nil
	}
}

fileprivate var kPBRDOLFreeSpaceEnd: Int? {
	switch region {
	case .US: return 0x1DEEDC - kDolToRAMOffsetDifference
	case .EU: return 0x1D9F68 - kDolToRAMOffsetDifference
	case .JP: return 0x1D0768 - kDolToRAMOffsetDifference
	case .OtherGame: return nil
	}
}

fileprivate var kXDDOLFreeSpaceStart: Int? {
	switch region {
	case .US: return 0xd39d0 - kDolToRAMOffsetDifference
	case .EU: return 0xd4fec - kDolToRAMOffsetDifference
	case .JP: return 0xcfef4 - kDolToRAMOffsetDifference
	case .OtherGame: return nil
	}
}

fileprivate var kXDDOLFreeSpaceEnd: Int? {
	switch region {
	case .US: return 0xd9c2c - kDolToRAMOffsetDifference
	case .EU: return 0xdb23c - kDolToRAMOffsetDifference
	case .JP: return 0xd614c - kDolToRAMOffsetDifference
	case .OtherGame: return nil
	}
}

fileprivate var kCOLDOLFreeSpaceStart: Int? {
	switch region {
	case .US: return 0xbe348 - kDolToRAMOffsetDifference
	case .EU: return 0xc1948 - kDolToRAMOffsetDifference
	case .JP: return 0xbb4a8 - kDolToRAMOffsetDifference
	case .OtherGame: return nil
	}
}

fileprivate var kCOLDOLFreeSpaceEnd: Int? {
	switch region {
	case .US: return 0xc459c - kDolToRAMOffsetDifference
	case .EU: return 0xc7b9c - kDolToRAMOffsetDifference
	case .JP: return 0xc16f8 - kDolToRAMOffsetDifference
	case .OtherGame: return nil
	}
}

let kDolFreeSpaceStart: Int? = {
	switch game {
	case .Colosseum: return kCOLDOLFreeSpaceStart
	case .XD: return kXDDOLFreeSpaceStart
	case .PBR: return kPBRDOLFreeSpaceStart
	}
}()

let kDolFreeSpaceEnd: Int? = {
	switch game {
	case .Colosseum: return kCOLDOLFreeSpaceEnd
	case .XD: return kXDDOLFreeSpaceEnd
	case .PBR: return kPBRDOLFreeSpaceEnd
	}
}()

let kRAMFreeSpaceStart: Int? = {
	guard let start = kDolFreeSpaceStart else {
		return nil
	}
	return start + kDolToRAMOffsetDifference
}()

let kRAMFreeSpaceEnd: Int? = {
	guard let end = kDolFreeSpaceEnd else {
		return nil
	}
	return end + kDolToRAMOffsetDifference
}()

let moveEffectTableStartRAM = 0x417edf // XD US
let moveEffectTableStartDOL = moveEffectTableStartRAM - kDolTableToRAMOffsetDifference // XD US

// function pointers in RAM
let kRAMListOfFunctionPointers = 0x2f8af8 // XD US

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
	
	class func replaceASM(startOffset: Int, newASM asm: ASM) {
		
		var labels = [String : Int]()
		var currentOffset = startOffset + kDolToRAMOffsetDifference
		for inst in asm {
			switch inst {
			case .label(let name):
				labels[name] = currentOffset
			default:
				currentOffset += 4
			}
		}
		
		let dol = XGFiles.dol.data!
		currentOffset = startOffset + kDolToRAMOffsetDifference
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
				dol.replaceWordAtOffset(currentOffset - kDolToRAMOffsetDifference, withBytes: code)
				currentOffset += 4
			default:
				let code = inst.codeAtOffset(currentOffset)
				dol.replaceWordAtOffset(currentOffset - kDolToRAMOffsetDifference, withBytes: code)
				currentOffset += 4
			}
			
		}
		dol.save()
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
		printg(String(format: "%x", createBranchAndLinkFrom(offset: offset, toOffset: to)))
	}
	
	class func createBranchFrom(offset: Int, toOffset to: Int) -> UInt32 {
		return UInt32(18 << 26) + UInt32((to - offset) & 0x3FFFFFF)
	}
	
	class func printCreateBranchFrom(offset: Int, toOffset to: Int) {
		printg(String(format: "%x", createBranchFrom(offset: offset, toOffset: to)))
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
		guard game == .XD && region == .US else {
			printg("This patch has not been implemented for this game region:", region.name)
			return
		}
		
		var currentValue = 0xFFFF
		var currentOffset = 0x4eeb90 - kDolDataToRAMOffsetDifference
		let dol = XGFiles.dol.data!
		for _ in 0 ..< 4 {
			dol.replace2BytesAtOffset(currentOffset, withBytes: currentValue)
			currentOffset += 2
			currentValue /= divisor
		}
		dol.save()
	}
	
	class func paralysisHalvesSpeed() {
		guard game == .XD && region == .US else {
			printg("This patch has not been implemented for this game region:", region.name)
			return
		}

		let dol = XGFiles.dol.data!
		dol.replaceWordAtOffset(0x203af8 - kDolToRAMOffsetDifference, withBytes: 0x56f7f87e)
		dol.save()
	}
	
	class func setFirsHM(_ tm: XGTMs) {
		guard game == .XD && region == .US else {
			printg("This patch has not been implemented for this game region:", region.name)
			return
		}

		let off1 = 0x15e92c - kDolToRAMOffsetDifference
		let off2 = 0x15e948 - kDolToRAMOffsetDifference
		// i.e. for tm51 to be first hm compare with 50
		let compareIndex = tm.index - 1
		let ins1 = [XGASM.cmpwi(.r3, compareIndex)]
		let ins2 = [XGASM.subi(.r0, .r3, compareIndex)]
		replaceASM(startOffset: off1, newASM: ins1)
		replaceASM(startOffset: off2, newASM: ins2)
	}
	
	class func createC2GeckoCode(asm: ASM, atRAMAddress address: Int) -> [UInt32] {
		let offset = (address & 0xFFFFFF).unsigned
		var instructions = ASM()
		// replace bl instructions with bla
		asm.forEach { instruction in
			switch instruction {
			case .b(let offset):
				instructions.append(.ba(offset))
			case .bl(let offset):
				instructions.append(.bla(offset))
			default:
				instructions.append(instruction)
			}
		}
		var values = instructions.wordStreamAtRAMOffset(address)
		if values.count % 2 == 0 {
			values.append(XGASM.nop.code)
		}
		values.append(0)
		return [
			0xC2000000 | offset,
			values.count.unsigned / 2
		] + values
	}

	class func createC2GeckoCodeString(asm: ASM, atRAMAddress address: Int) -> String {
		let code = createC2GeckoCode(asm: asm, atRAMAddress: address)
		var codeText = ""
		for i in 0 ..< (code.count / 2) {
			let leftCode = code[i * 2]
			let rightCode = code[(i * 2) + 1]
			codeText += "\(leftCode.hex()) \(rightCode.hex())\n"
		}
		return codeText
	}
}
