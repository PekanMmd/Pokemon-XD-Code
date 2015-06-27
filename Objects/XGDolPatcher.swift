//
//  XGDolPatcher.swift
//  XG Tool
//
//  Created by The Steez on 19/05/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//

import Foundation

let kClassPatchOffsets	  = [0x13B78C,0x226574,0x226FE0,0x212750,0x214740]
let kNopInstruction		  : UInt32 = 0x60000000
let kBranchInstruction1	  : UInt32 = 0x40820024
let kBranchInstruction2   : UInt32 = 0x40820014
let kBranchInstruction9   : UInt32 = 0x480000E4

let kMirrorCoatOffset1	  = 0x002DFCBC
let kMirrorCoatOffset2	  = 0x002DFCC0
let kMirrorCoatBranch	  : UInt32 = 0x4BE5BA91
let kMirrorBranchOrigin1  : UInt32 = 0x4BFE58a5
let kMirrorBranchOrigin2  : UInt32 = 0x4BE34D65
let kCounterOffset1		  = 0x002DFDD8
let kCounterOffset2		  = 0x002DFDDC
let kCounterBranch		  : UInt32 = 0x4BE5B975
let kCounterBranchOrigin1 : UInt32 = 0x4BFE5789
let kCounterBranchOrigin2 : UInt32 = 0x4BE34C49

let kBetaStartersFirstOffset  = 0x1CBCC8

let kBetaStartersInstruction1 : UInt32 = 0x4BF8390D
let kBetaStartersInstruction2 : UInt32 = 0x7FE3FB78
let kBetaStartersInstruction3 : UInt32 = 0x4BF83A2D

let kOriginalStartersInstruction1 : UInt32 = 0x90C10038
let kOriginalStartersInstruction2 : UInt32 = 0x9001003C
let kOriginalStartersInstruction3 : UInt32 = 0x4BF83D71

let kNameRaterOffset1 = 0x149DE4
let kNameRaterOffset2 = 0x149DE8
let kNameRaterOffset3 = 0x1B964C

//let kNameRaterInstruction1 = kNopInstruction
let kNameRaterInstruction2 : UInt32 = 38600001
let kNameRaterInstruction3 : UInt32 = 38600000

let kUnlimitedTutorMovesBranchOffset	= 0x0B8590
let kUnlimitedTutorMovesInjectionOffset = 0x2C55B4
let kTutorMovesBranchInstruction		: UInt32 = 0x4820D025
let kTutorMovesOriginalInstruction		: UInt32 = 0x7F03C378

let kShinyCalcPIDOffset1				= 0x147EE0
let kShinyCalcChanceOffset1				= 0x147EE6
let kShinyCalcPIDOffset2				= 0x1410CC
let kShinyCalcChanceOffset2				= 0x1410D2
let kShinyCalcRerollOffset1				= 0x13E5AC
let kShinyCalcRerollOffset2				= 0x1f7900

let kShinyCalcOriginalPIDInstruction		: UInt32 = 0x7CA30278
let kShinyCalcOriginalChanceInstruction		= 0x0008
let kShinyCalcOriginalRerollInstruction1	: UInt32 = 0x4181ff30
let kShinyCalcOriginalRerollInstruction2	: UInt32 = 0x57a0063E

let kShinyCalcNewPIDInstruction				: UInt32 = 0x38600000
//let kShinyCalcRerollInstruction1			= kNopInstruction
let kShinyCalcRerollInstruction2			: UInt32 = 0x5460063E



class XGDolPatcher: NSObject {
	
	//Incorporates Physical/Special Split on all moves. The category is determined by byte 0x12 of the move's data.
	
	class func isClassSplitImplemented() -> Bool {
		
		var dol = XGFiles.Dol.data
		
		for offset in kClassPatchOffsets {
			var machineInstruction = dol.get4BytesAtOffset(offset)
			
			if machineInstruction == kNopInstruction {
				return true
			}
			
		}
		
		return false
	}
	
	class func applyPhysicalSpecialSplitPatch() {
		
		var dol = XGFiles.Dol.data
		
		for offset in kClassPatchOffsets {
			
			dol.replace4BytesAtOffset(offset, withBytes: kNopInstruction)
			
		}
		dol.replace4BytesAtOffset(kMirrorCoatOffset1, withBytes: kNopInstruction)
		dol.replace4BytesAtOffset(kMirrorCoatOffset2, withBytes: kMirrorCoatBranch)
		dol.replace4BytesAtOffset(kCounterOffset1, withBytes: kNopInstruction)
		dol.replace4BytesAtOffset(kCounterOffset2, withBytes: kCounterBranch)
		
		dol.save()
		
	}
	
	class func removePhysicalSpecialSplitPatch() {
		
		var dol = XGFiles.Dol.data
		
		for offset in kClassPatchOffsets {
			
			if offset == kClassPatchOffsets[0] {
				dol.replace4BytesAtOffset(offset, withBytes: kBranchInstruction1)
			} else {
				dol.replace4BytesAtOffset(offset, withBytes: kBranchInstruction2)
			}
			
		}
		
		dol.replace4BytesAtOffset(kMirrorCoatOffset1, withBytes: kMirrorBranchOrigin1)
		dol.replace4BytesAtOffset(kMirrorCoatOffset2, withBytes: kMirrorBranchOrigin2)
		dol.replace4BytesAtOffset(kCounterOffset1, withBytes: kCounterBranchOrigin1)
		dol.replace4BytesAtOffset(kCounterOffset2, withBytes: kCounterBranchOrigin2)
		
		dol.save()
		
	}
	
	//Allows the safe changing of type 9 (?) to another type, e.g. fairy.
	
	class func isType9Independent() -> Bool {
		var dol = XGFiles.Dol.data
		return dol.get4BytesAtOffset(0x2C55B0) == kBranchInstruction9
	}
	
	class func removeType9Dependencies() {
		
		var dol = XGFiles.Dol.data
		
		dol.replace4BytesAtOffset(0x2C55B0, withBytes: kBranchInstruction9)
		
		
		var nopOffsets = [0x2C59FC, 0x2C5D8C, 0x2C8870, 0x2C895C]
		
		for offset in nopOffsets {
			dol.replace4BytesAtOffset(offset, withBytes: kNopInstruction)
		}
		
		dol.save()
		
	}
	
	// Changes the starters from eevee to the beta jolteon and vaporeon which can be edited.
	
	class func areBetaStartersEnabled() -> Bool {
		var dol = XGFiles.Dol.data
		return dol.get4BytesAtOffset(kBetaStartersFirstOffset) == kBetaStartersInstruction1
	}
	
	class func enableBetaStarters() {
		
		var dol = XGFiles.Dol.data
		
		let instructions = [kBetaStartersInstruction1, kBetaStartersInstruction2, kBetaStartersInstruction3]
		
		for var i = 0; i < 3; i++ {
			let offset = i * 4
			dol.replace4BytesAtOffset(kBetaStartersFirstOffset + offset, withBytes: instructions[i])
		}
		
		dol.save()
	}
	
	class func disableBetaStarters() {
		
		var dol = XGFiles.Dol.data
		
		let instructions = [kOriginalStartersInstruction1, kOriginalStartersInstruction2, kOriginalStartersInstruction3]
		
		for var i = 0; i < 3; i++ {
			let offset = i * 4
			dol.replace4BytesAtOffset(kBetaStartersFirstOffset + offset, withBytes: instructions[i])
		}
		
		dol.save()
	}
	
	// Allows the name rater to nickname any pokemon
	
	class func canRenameAnyPokemon() -> Bool {
		var dol = XGFiles.Dol.data
		return dol.get4BytesAtOffset(kNameRaterOffset1) == kNopInstruction
	}
	
	class func allowRenamingAnyPokemon() {
		var dol = XGFiles.Dol.data
		
		dol.replace4BytesAtOffset(kNameRaterOffset1, withBytes: kNopInstruction)
		dol.replace4BytesAtOffset(kNameRaterOffset2, withBytes: kNameRaterInstruction2)
		dol.replace4BytesAtOffset(kNameRaterOffset3, withBytes: kNameRaterInstruction3)
		
		dol.save()
	}
	
	
	// Allows Tutor Moves to be learned as many times as you like.
	
	class func areUnlimitedTutorsImplemented() -> Bool {
		var dol = XGFiles.Dol.data
		return dol.get4BytesAtOffset(kUnlimitedTutorMovesBranchOffset) == kTutorMovesBranchInstruction
	}
	
	class func implementUnlimitedTutors() {
		var dol = XGFiles.Dol.data
		
		dol.replace4BytesAtOffset(kUnlimitedTutorMovesBranchOffset, withBytes: kTutorMovesBranchInstruction)
		
		let instructions : [UInt32] = [0x806DB8D8, 0x28030000, 0x41820014, 0x3C630001, 0xA0030922, 0x7000F000, 0xB0030922, 0x7F03C378, 0x60000000, 0x4E800020]
		
		for var i = 0; i < instructions.count; i++ {
			var value = instructions[i]
			dol.data.appendBytes(&value, length: 4)
		}
		
		dol.save()
	}
	
	class func oneTimeTutorMoves() {
		if !areUnlimitedTutorsImplemented() {
			return
		}
		var dol = XGFiles.Dol.data
		dol.replace4BytesAtOffset(kUnlimitedTutorMovesBranchOffset, withBytes: kTutorMovesOriginalInstruction)
		dol.deleteBytesInRange(NSMakeRange(kUnlimitedTutorMovesInjectionOffset, 40))
	}
	
	// Used to change the probability of finding shinies and allows them to be generated decently.
	
	func isShinyLockRemoved() -> Bool {
		var dol = XGFiles.Dol.data
		return dol.get4BytesAtOffset(kShinyCalcRerollOffset1) == kNopInstruction
	}
	
	func removeShinyLock() {
		var dol = XGFiles.Dol.data
		
		dol.replace4BytesAtOffset(kShinyCalcRerollOffset1, withBytes: kNopInstruction)
		dol.replace4BytesAtOffset(kShinyCalcRerollOffset2, withBytes: kShinyCalcRerollInstruction2)
		dol.replace4BytesAtOffset(kShinyCalcPIDOffset1, withBytes: kShinyCalcNewPIDInstruction)
		dol.replace4BytesAtOffset(kShinyCalcPIDOffset2, withBytes: kShinyCalcNewPIDInstruction)
		
		dol.save()
	}
	
	func placeShinyLock() {
		var dol = XGFiles.Dol.data
		
		dol.replace4BytesAtOffset(kShinyCalcRerollOffset1, withBytes: kShinyCalcOriginalRerollInstruction1)
		dol.replace4BytesAtOffset(kShinyCalcRerollOffset2, withBytes: kShinyCalcOriginalRerollInstruction2)
		dol.replace4BytesAtOffset(kShinyCalcPIDOffset1, withBytes: kShinyCalcOriginalPIDInstruction)
		dol.replace4BytesAtOffset(kShinyCalcPIDOffset2, withBytes: kShinyCalcOriginalPIDInstruction)
		
		dol.save()
	}
	
	func getShinyChance() -> Float {
		var dol = XGFiles.Dol.data
		
		var val = Float(dol.get2BytesAtOffset(kShinyCalcChanceOffset1))
		return val / 0xFFFF
		
	}
	
	func changeShinyChance(newValue: Float) {
		// Input the shiny chance as a percentage
		
		var dol = XGFiles.Dol.data
		
		var val = Int(newValue * 0xFFFF) / 100
		
		if val > 0xFFFF {
			val = 0xFFFF
		}
		
		if val < 0 {
			val = 0
		}
		
		dol.replace2BytesAtOffset(kShinyCalcChanceOffset1, withBytes: val)
		dol.replace2BytesAtOffset(kShinyCalcChanceOffset2, withBytes: val)
		
		dol.save()
	}
	
	

}



















