//
//  XGASM.swift
//  GoD Tool
//
//  Created by The Steez on 18/09/2018.
//

import Foundation

enum XGRegisters : UInt32 {
	
	case r0 = 0
	case r1
	case r2
	case r3
	case r4
	case r5
	case r6
	case r7
	case r8
	case r9
	case r10
	case r11
	case r12
	case r13
	case r14
	case r15
	case r16
	case r17
	case r18
	case r19
	case r20
	case r21
	case r22
	case r23
	case r24
	case r25
	case r26
	case r27
	case r28
	case r29
	case r30
	case r31
	case sp
	// special purpose registers
	case lr
	case ctr
	case srr0
	case srr1
	
	var value: UInt32 {
		switch self {
		case .sp  : return 1
		case .lr  : return 8
		case .ctr : return 9
		case .srr0: return 26
		case .srr1: return 27
		default:
			return self.rawValue
		}
	}
}

typealias ASM = [XGASM]

enum XGASM {

	case mr(XGRegisters, XGRegisters)
	case mr_(XGRegisters, XGRegisters) // same but affects condition register. denoted by 'mr.' normally
	
	case mfspr(XGRegisters, XGRegisters)
	case mflr(XGRegisters)
	case mfctr(XGRegisters)
	case mtspr(XGRegisters, XGRegisters)
	case mtlr(XGRegisters)
	case mtctr(XGRegisters)
	
	case cmpw(XGRegisters, XGRegisters)
	case cmplw(XGRegisters, XGRegisters)
	case cmpwi(XGRegisters, Int)
	case cmplwi(XGRegisters, UInt32)
	
	case li(XGRegisters, Int)
	case lis(XGRegisters, Int)
	
	case extsb(XGRegisters, XGRegisters)
	case extsh(XGRegisters, XGRegisters)
	
	case slw(XGRegisters, XGRegisters, XGRegisters)
	case srawi(XGRegisters, XGRegisters, UInt32)
	case rlwinm(XGRegisters, XGRegisters, UInt32, UInt32, UInt32)
	case rlwinm_(XGRegisters, XGRegisters, UInt32, UInt32, UInt32) // same but affects condition register. denoted by 'rlwinm.' normally
	
	case lha(XGRegisters, XGRegisters, Int)
	case lhax(XGRegisters, XGRegisters, XGRegisters)
	
	case lbz(XGRegisters, XGRegisters, Int)
	case lhz(XGRegisters, XGRegisters, Int)
	case lwz(XGRegisters, XGRegisters, Int)
	
	case lbzx(XGRegisters, XGRegisters, XGRegisters)
	case lhzx(XGRegisters, XGRegisters, XGRegisters)
	case lwzx(XGRegisters, XGRegisters, XGRegisters)
	
	case stb(XGRegisters, XGRegisters, Int)
	case sth(XGRegisters, XGRegisters, Int)
	case stw(XGRegisters, XGRegisters, Int)
	case stwu(XGRegisters, XGRegisters, Int)
	
	case stbx(XGRegisters, XGRegisters, XGRegisters)
	case sthx(XGRegisters, XGRegisters, XGRegisters)
	case stwx(XGRegisters, XGRegisters, XGRegisters)
	
	case lmw(XGRegisters, XGRegisters, Int)
	case stmw(XGRegisters, XGRegisters, Int)
	
	case add(XGRegisters, XGRegisters, XGRegisters)
	case addi(XGRegisters, XGRegisters, Int)
	case addis(XGRegisters, XGRegisters, Int)
	case addze(XGRegisters, XGRegisters)
	case sub(XGRegisters, XGRegisters, XGRegisters)
	case subi(XGRegisters, XGRegisters, Int)
	case neg(XGRegisters, XGRegisters)
	case mulli(XGRegisters, XGRegisters, Int)
	case mullw(XGRegisters, XGRegisters, XGRegisters)
	case divw(XGRegisters, XGRegisters, XGRegisters)
	case divwu(XGRegisters, XGRegisters, XGRegisters)
	case or(XGRegisters, XGRegisters, XGRegisters)
	case ori(XGRegisters, XGRegisters, UInt32)
	
	case b(Int)
	case bl(Int)
	case blr
	case beq(Int)
	case bne(Int)
	case blt(Int)
	case ble(Int)
	case bgt(Int)
	case bge(Int)
	
	case nop
	
	// convenience instructions - not real PPC instructions
	// from offset to offset
	case b_f(Int, Int)
	case bl_f(Int, Int)
	case beq_f(Int, Int)
	case bne_f(Int, Int)
	case blt_f(Int, Int)
	case ble_f(Int, Int)
	case bgt_f(Int, Int)
	case bge_f(Int, Int)
	
	// raw binary
	case raw(UInt32)
	
	var code : UInt32 {
		return codeAtOffset(0)
	}
	
	private func codeForAdd() -> UInt32 {
		switch self {
		case .add(let rd, let ra, let rb):
			return (UInt32(31) << 26) | (rd.value << 21) | (ra.value << 16) | (rb.value << 11) | (266 << 1)
		case .addi(let rd, let ra, let simm):
			return (UInt32(14) << 26) | (rd.value << 21) | (ra.value << 16) | (UInt32(bitPattern: Int32(simm)) & 0xFFFF)
		case .addis(let rd, let ra, let simm):
			return (UInt32(15) << 26) | (rd.value << 21) | (ra.value << 16) | (UInt32(bitPattern: Int32(simm)) & 0xFFFF)
		case .addze(let rd, let ra):
			return (UInt32(31) << 26) | (rd.value << 21) | (ra.value << 16) | (202 << 1)
		default:
			return 0
		}
	}
	
	private func codeForSub() -> UInt32 {
		switch self {
		case .sub(let rd, let ra, let rb):
			return (UInt32(31) << 26) | (rd.value << 21) | (rb.value << 16) | (ra.value << 11) | (40 << 1)
		case .subi(let rd, let ra, let simm):
			return XGASM.addi(rd, ra, -simm).code
		case .neg(let rd, let ra):
			return (UInt32(31) << 26) | (rd.value << 21) | (ra.value << 16) | (104 << 1)
		default:
			return 0
		}
	}
	
	private func codeForLoadImm() -> UInt32 {
		switch self {
		case .li(let rd, let simm):
			return XGASM.addi(rd, .r0, simm).code
		case .lis(let rd, let simm):
			return XGASM.addis(rd, .r0, simm).code
		default:
			return 0
		}
	}
	
	private func codeForExtend() -> UInt32 {
		switch self {
		case .extsb(let rd, let rs):
			return (UInt32(31) << 26) | (rs.value << 21) | (rd.value << 16) | (954 << 1)
		case .extsh(let rd, let rs):
			return (UInt32(31) << 26) | (rs.value << 21) | (rd.value << 16) | (922 << 1)
		default:
			return 0
		}
	}
	
	private func codeForLoad() -> UInt32 {
		switch self {
		case .lbz(let rd, let ra, let d):
			return (UInt32(34) << 26) | (rd.value << 21) | (ra.value << 16) | (UInt32(bitPattern: Int32(d)) & 0xFFFF)
		case .lha(let rd, let ra, let d):
			return (UInt32(42) << 26) | (rd.value << 21) | (ra.value << 16) | (UInt32(bitPattern: Int32(d)) & 0xFFFF)
		case .lhz(let rd, let ra, let d):
			return (UInt32(40) << 26) | (rd.value << 21) | (ra.value << 16) | (UInt32(bitPattern: Int32(d)) & 0xFFFF)
		case .lwz(let rd, let ra, let d):
			return (UInt32(32) << 26) | (rd.value << 21) | (ra.value << 16) | (UInt32(bitPattern: Int32(d)) & 0xFFFF)
		case .lbzx(let rd, let ra, let rb):
			return (UInt32(31) << 26) | (rd.value << 21) | (ra.value << 16) | (rb.value << 11) | (87 << 1)
		case .lhax(let rd, let ra, let rb):
			return (UInt32(31) << 26) | (rd.value << 21) | (ra.value << 16) | (rb.value << 11) | (343 << 1)
		case .lhzx(let rd, let ra, let rb):
			return (UInt32(31) << 26) | (rd.value << 21) | (ra.value << 16) | (rb.value << 11) | (279 << 1)
		case .lwzx(let rd, let ra, let rb):
			return (UInt32(31) << 26) | (rd.value << 21) | (ra.value << 16) | (rb.value << 11) | (23 << 1)
		default:
			return 0
		}
	}
	
	private func codeForStore() -> UInt32 {
		switch self {
		case .stb(let rs, let ra, let d):
			return (UInt32(38) << 26) | (rs.value << 21) | (ra.value << 16) | (UInt32(bitPattern: Int32(d)) & 0xFFFF)
		case .sth(let rs, let ra, let d):
			return (UInt32(44) << 26) | (rs.value << 21) | (ra.value << 16) | (UInt32(bitPattern: Int32(d)) & 0xFFFF)
		case .stw(let rs, let ra, let d):
			return (UInt32(36) << 26) | (rs.value << 21) | (ra.value << 16) | (UInt32(bitPattern: Int32(d)) & 0xFFFF)
		case .stwu(let rs, let ra, let d):
			return (UInt32(37) << 26) | (rs.value << 21) | (ra.value << 16) | (UInt32(bitPattern: Int32(d)) & 0xFFFF)
		case .stbx(let rs, let ra, let rb):
			return (UInt32(31) << 26) | (rs.value << 21) | (ra.value << 16) | (rb.value << 11) | (215 << 1)
		case .sthx(let rs, let ra, let rb):
			return (UInt32(31) << 26) | (rs.value << 21) | (ra.value << 16) | (rb.value << 11) | (407 << 1)
		case .stwx(let rs, let ra, let rb):
			return (UInt32(31) << 26) | (rs.value << 21) | (ra.value << 16) | (rb.value << 11) | (151 << 1)
		default:
			return 0
		}
	}
	
	private func codeForLoadStoreMultiple() -> UInt32 {
		switch self {
		case .lmw(let rd, let ra, let d):
			return (UInt32(46) << 26) | (rd.value << 21) | (ra.value << 16) | (UInt32(bitPattern: Int32(d)) & 0xFFFF)
		case .stmw(let rd, let ra, let d):
			return (UInt32(47) << 26) | (rd.value << 21) | (ra.value << 16) | (UInt32(bitPattern: Int32(d)) & 0xFFFF)
		default:
			return 0
		}
	}
	
	private func codeForShift() -> UInt32 {
		switch self {
		case .slw(let rd, let ra, let rb):
			return (UInt32(31) << 26) | (rd.value << 21) | (ra.value << 16) | (rb.value << 11) | (24 << 1)
		case .srawi(let rd, let ra, let sh):
			return (UInt32(31) << 26) | (ra.value << 21) | (rd.value << 16) | (sh << 11) | (824 << 1)
		case .rlwinm(let rd, let ra, let sh, let mb, let me):
			return (UInt32(21) << 26) | (ra.value << 21) | (rd.value << 16) | (sh << 11) | (mb << 6) | (me << 1)
		case .rlwinm_(let rd, let ra, let sh, let mb, let me):
			return XGASM.rlwinm(rd,ra,sh,mb,me).code | 1
		default:
			return 0
		}
	}
	
	private func codeForOrMr() -> UInt32 {
		switch self {
		case .or(let rd, let ra, let rb):
			return (UInt32(31) << 26) | (ra.value << 21) | (rd.value << 16) | (rb.value << 11) | (444 << 1)
		case .ori(let rd, let ra, let uimm):
			return (UInt32(24) << 26) | (ra.value << 21) | (rd.value << 16) | (uimm & 0xFFFF)
		case .mr(let rd, let rs):
			return XGASM.or(rd, rs, rs).code
		case .mr_(let rd, let rs):
			return XGASM.mr(rd, rs).code | 1
		default:
			return 0
		}
	}
	
	private func codeFor() -> UInt32 {
		switch self {
			
		default:
			return 0
		}
	}
	
	func codeAtOffset(_ offset: Int) -> UInt32 {
		// split into sub functions so compiler can relax
		switch self {
			
		// add / subtract
		case .add:
			fallthrough
		case .addi:
			fallthrough
		case .addis:
			fallthrough
		case .addze:
			return codeForAdd()
			
		case .sub:
			fallthrough
		case .subi:
			fallthrough
		case .neg:
			return codeForSub()
			
		// load immediate
		case .li:
			fallthrough
		case .lis:
			return codeForLoadImm()
			
		// extend
		case .extsb:
			fallthrough
		case .extsh:
			return codeForExtend()
			
		// load and zero
		case .lbz:
			fallthrough
		case .lha:
			fallthrough
		case .lhz:
			fallthrough
		case .lwz:
			fallthrough
		// load and zero indexed
		case .lbzx:
			fallthrough
		case .lhax:
			fallthrough
		case .lhzx:
			fallthrough
		case .lwzx:
			return codeForLoad()
			
		// store
		case .stb:
			fallthrough
		case .sth:
			fallthrough
		case .stw:
			fallthrough
		case .stwu:
			fallthrough
		// store indexed
		case .stbx:
			fallthrough
		case .sthx:
			fallthrough
		case .stwx:
			return codeForStore()
			
		// load / store multiple
		case .lmw:
			fallthrough
		case .stmw:
			return codeForLoadStoreMultiple()
			
			
		// shift / rotate
		case .slw:
			fallthrough
		case .srawi:
			fallthrough
		case .rlwinm:
			fallthrough
		case .rlwinm_:
			return codeForShift()
			
		// or
		case .or:
			fallthrough
		case .ori:
			fallthrough
		// mr
		case .mr:
			fallthrough
		case .mr_:
			return codeForOrMr()
			
		// link register
		case .mfspr(let rd, let spr):
			return (UInt32(31) << 26) | (rd.value << 21) | (spr.value << 16) | (339 << 1)
		case .mflr(let rd):
			return XGASM.mfspr(rd, .lr).code
		case .mfctr(let rd):
			return XGASM.mfspr(rd, .ctr).code
		case .mtspr(let spr, let rs):
			return (UInt32(31) << 26) | (rs.value << 21) | (spr.value << 16) | (467 << 1)
		case .mtlr(let rs):
			return XGASM.mtspr(.lr, rs).code
		case .mtctr(let rs):
			return XGASM.mtspr(.ctr, rs).code
			
		// compare
		case .cmpw(let ra, let rb):
			return (UInt32(31) << 26) | (ra.value << 16) | (rb.value << 11)
		case .cmpwi(let ra, let simm):
			return (UInt32(11) << 26) | (ra.value << 16) | (UInt32(bitPattern: Int32(simm)) & 0xFFFF)
		case .cmplw(let ra, let rb):
			return (UInt32(31) << 26) | (ra.value << 16) | (rb.value << 11) | (32 << 1)
		case .cmplwi(let ra, let uimm):
			return (UInt32(10) << 26) | (ra.value << 16) | uimm
			
		// multiply / divide
		case .mulli(let rd, let ra, let simm):
			return (UInt32(7) << 26) | (rd.value << 21) | (ra.value << 16) | (UInt32(bitPattern: Int32(simm)) & 0xFFFF)
		case .mullw(let rd, let ra, let rb):
			return (UInt32(31) << 26) | (rd.value << 21) | (ra.value << 16) | (rb.value << 11) | (235 << 1)
		case .divw(let rd, let ra, let rb):
			return (UInt32(31) << 26) | (rd.value << 21) | (ra.value << 16) | (rb.value << 11) | (491 << 1)
		case .divwu(let rd, let ra, let rb):
			return (UInt32(31) << 26) | (rd.value << 21) | (ra.value << 16) | (rb.value << 11) | (459 << 1)
		
			
		// relative branches
		case .b_f(let o, let t):
			return 0x48000000 | (UInt32(bitPattern: Int32(t - o)) & 0x3FFFFFF)
		case .bl_f(let o, let t):
			return XGASM.b_f(o, t).code + 1
			
		// blr
		case .blr:
			return 0x4e800020
			
		// conditional relative branches
		case .beq_f(let o, let t):
			return 0x41820000 | (UInt32(bitPattern: Int32(t - o)) & 0xFFFF)
		case .bne_f(let o, let t):
			return 0x40820000 | (UInt32(bitPattern: Int32(t - o)) & 0xFFFF)
		case .blt_f(let o, let t):
			return 0x41800000 | (UInt32(bitPattern: Int32(t - o)) & 0xFFFF)
		case .ble_f(let o, let t):
			return 0x40810000 | (UInt32(bitPattern: Int32(t - o)) & 0xFFFF)
		case .bgt_f(let o, let t):
			return 0x41810000 | (UInt32(bitPattern: Int32(t - o)) & 0xFFFF)
		case .bge_f(let o, let t):
			return 0x40800000 | (UInt32(bitPattern: Int32(t - o)) & 0xFFFF)
		
		// absolute branches
		case .b(let target):
			return XGASM.b_f(offset, target).code
		case .bl(let target):
			return XGASM.bl_f(offset, target).code
		case .beq(let target):
			return XGASM.beq_f(offset, target).code
		case .bne(let target):
			return XGASM.bne_f(offset, target).code
		case .blt(let target):
			return XGASM.blt_f(offset, target).code
		case .ble(let target):
			return XGASM.ble_f(offset, target).code
		case .bgt(let target):
			return XGASM.bgt_f(offset, target).code
		case .bge(let target):
			return XGASM.bge_f(offset, target).code
			
		// nop
		case .nop:
			return 0x60000000
		
		// raw
		case .raw(let value):
			return value
		}
	}

}

























