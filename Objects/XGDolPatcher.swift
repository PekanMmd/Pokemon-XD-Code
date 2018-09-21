//
//  XGDolPatcher.swift
//  XG Tool
//
//  Created by StarsMmd on 19/05/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

let kClassPatchOffsets	  = [0x13B78C,0x226574,0x226FE0,0x212750,0x214740]
let kNopInstruction		  : UInt32 = XGASM.nop.code
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


// let kNameRaterInstruction1 = kNopInstruction
let kNameRaterInstruction2 : UInt32 = 0x38600001
let kNameRaterInstruction3 : UInt32 = 0x38600000

// version 1
let kUnlimitedTutorMovesJumpInstruction = 0x0C
let kUnlimitedTutorMovesJumpOffsets		= [0x02DC, 0x0290]

// version 2
let kUnlimitedTutorMovesJumpInstructions = [0x006B,0x007D]
let kUnlimitedTutorMovesJumpOffsets2	 = [0x02B6, 0x0302]

let kShinyCalcPIDOffset1				= 0x147EE0
let kShinyCalcChanceOffset1				= 0x147EE6
let kShinyCalcPIDOffset2				= 0x1410CC
let kShinyCalcChanceOffset2				= 0x1410D2

let kShinyCalcOriginalPIDInstruction		: UInt32 = 0x7CA30278
let kShinyCalcOriginalChanceInstruction		= 0x0008

let kShinyCalcNewPIDInstruction				: UInt32 = 0x38600000

let kNumberOfDolPatches = 12

enum XGDolPatches : Int {
	
	case physicalSpecialSplitApply = 0
	case physicalSpecialSplitRemove
	case type9IndependentApply
	case betaStartersApply
	case betaStartersRemove
	case renameAllPokemonApply
	case unlimitedTutorMovesApply
	case shinyChanceEditingApply
	case shinyChanceEditingRemove
	case zeroForeignStringTables
	case decapitaliseNames
	case tradeEvolutions
	
	var name : String {
		get {
			switch self {
				case .physicalSpecialSplitApply : return "Apply the gen IV physical/special split."
				case .physicalSpecialSplitRemove : return "Remove the physical/special split."
				case .type9IndependentApply : return "Removes the dependecy on the ??? type allowing 1 additional type."
				case .betaStartersApply : return "Allows the player to start with 2 pokemon."
				case .betaStartersRemove : return "Revert to starting with 1 pokemon."
				case .renameAllPokemonApply	: return "Allows the name rater to rename all pokemon - Crashes parts of game"
				case .unlimitedTutorMovesApply : return "Allows the move tutor moves to be relearned."
				case .shinyChanceEditingApply : return "Removes shiny purification glitch by generating based on a fixed trainer ID."
				case .shinyChanceEditingRemove : return "shininess will be determined by trainer ID as usual."
				case .zeroForeignStringTables : return "Foreign string tables will be zeroed out for smaller compressed sizes."
				case .decapitaliseNames : return "Decapitalises a lot of text."
				case .tradeEvolutions : return "Trade Evolutions become level 40"
			}
		}
	}
	
}


class XGDolPatcher: NSObject {
	
	//Incorporates Physical/Special Split on all moves. The category is determined by byte 0x12 of the move's data.
	
	@objc class func isClassSplitImplemented() -> Bool {
		
		let dol = XGFiles.dol.data
		
		for offset in kClassPatchOffsets {
			let machineInstruction = dol.get4BytesAtOffset(offset)
			
			if machineInstruction == kNopInstruction {
				return true
			}
			
		}
		
		return false
	}
	
	@objc class func applyPhysicalSpecialSplitPatch() {
		
		if game == .XD && region == .US {
			
			let dol = XGFiles.dol.data
			for offset in kClassPatchOffsets {
				dol.replace4BytesAtOffset(offset, withBytes: kNopInstruction)
			}
			
			dol.replace4BytesAtOffset(kMirrorCoatOffset1, withBytes: kNopInstruction)
			dol.replace4BytesAtOffset(kMirrorCoatOffset2, withBytes: kMirrorCoatBranch)
			dol.replace4BytesAtOffset(kCounterOffset1, withBytes: kNopInstruction)
			dol.replace4BytesAtOffset(kCounterOffset2, withBytes: kCounterBranch)
			dol.save()
			
		} else if game == .Colosseum && region == .US {
			
			let typeGetCategory = 0x10c4a0 // ram
			
			let move17Offsets = [0x232938,0x2324c8]
			let move23Offsets = [0x24462c,0x2447b8]
			let move30Offsets = [0x226c18]
			let move31Offsets = [0x228b5c]
			
			XGAssembly.replaceASM(startOffset: typeGetCategory - kColosseumDolToRamOffsetDifference, newASM: [
				// get move data pointer
				0x1c030038, // mulli r0, r3, 56
				0x806d85dc, // lwz	r3, -0x7A24 (r13)
				0x7c630214, // add	r3, r3, r0
				0x8863001F, // move data get category (byte 0x1f which is unused in vanilla)
				0x4e800020, // blr
				])
			for offset in move17Offsets {
				XGAssembly.replaceASM(startOffset: offset - kColosseumDolToRamOffsetDifference, newASM: [0x7e238b78])
			}
			for offset in move23Offsets {
				XGAssembly.replaceASM(startOffset: offset - kColosseumDolToRamOffsetDifference, newASM: [0x7ee3bb78])
			}
			for offset in move30Offsets {
				XGAssembly.replaceASM(startOffset: offset - kColosseumDolToRamOffsetDifference, newASM: [0x7fc3f378])
			}
			for offset in move31Offsets {
				XGAssembly.replaceASM(startOffset: offset - kColosseumDolToRamOffsetDifference, newASM: [0x7fe3fb78])
			}
			
			
		} else {
			printg("Physical/Special split isn't implemented for this game region.")
		}
		
	}
	
	@objc class func removePhysicalSpecialSplitPatch() {
		
		let dol = XGFiles.dol.data
		
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
	
	@objc class func isType9Independent() -> Bool {
		let dol = XGFiles.dol.data
		return dol.get4BytesAtOffset(0x2C55B0) == kBranchInstruction9
	}
	
	@objc class func removeType9Dependencies() {
		
		let dol = XGFiles.dol.data
		
		dol.replace4BytesAtOffset(0x2C55B0, withBytes: kBranchInstruction9)
		dol.replace4BytesAtOffset(0x031230, withBytes: 0x3B400000)
		
		
		let nopOffsets = [0x2C59FC, 0x2C5D8C, 0x2C8870, 0x2C895C]
		
		for offset in nopOffsets {
			dol.replace4BytesAtOffset(offset, withBytes: kNopInstruction)
		}
		
		dol.save()
		
	}
	
	// Changes the starters from eevee to the beta jolteon and vaporeon which can be edited.
	
	@objc class func areBetaStartersEnabled() -> Bool {
		let dol = XGFiles.dol.data
		return dol.get4BytesAtOffset(kBetaStartersFirstOffset) == kBetaStartersInstruction1
	}
	
	@objc class func enableBetaStarters() {
		
		let dol = XGFiles.dol.data
		
		let instructions = [kBetaStartersInstruction1, kBetaStartersInstruction2, kBetaStartersInstruction3]
		
		for i in 0 ..< 3 {
			let offset = i * 4
			dol.replace4BytesAtOffset(kBetaStartersFirstOffset + offset, withBytes: instructions[i])
		}
		
		dol.save()
	}
	
	@objc class func disableBetaStarters() {
		
		let dol = XGFiles.dol.data
		
		let instructions = [kOriginalStartersInstruction1, kOriginalStartersInstruction2, kOriginalStartersInstruction3]
		
		for i in 0 ..< 3 {
			let offset = i * 4
			dol.replace4BytesAtOffset(kBetaStartersFirstOffset + offset, withBytes: instructions[i])
		}
		
		dol.save()
	}
	
	// Clashes with move tutor somehow
	// Allows the name rater to nickname any pokemon
	
//	class func canRenameAnyPokemon() -> Bool {
//		let dol = XGFiles.Dol.data
//		return dol.get4BytesAtOffset(kNameRaterOffset1) == kNopInstruction
//	}
//	
	@objc class func allowRenamingAnyPokemon() {
//		let dol = XGFiles.Dol.data
//		
//		dol.replace4BytesAtOffset(kNameRaterOffset1, withBytes: kNopInstruction)
//		dol.replace4BytesAtOffset(kNameRaterOffset2, withBytes: kNameRaterInstruction2)
//		dol.replace4BytesAtOffset(kNameRaterOffset3, withBytes: kNameRaterInstruction3)
//		
//		dol.save()
	}
	
	
	@objc class func implementUnlimitedTutors() {
		
		let script = XGFiles.script("M3_cave_1F_2.scd").data
//		for i in [0,1] {
//			script.replaceByteAtOffset(kUnlimitedTutorMovesJumpOffsets[i], withByte: kUnlimitedTutorMovesJumpInstruction)
//			
//		}
		
		for i in [0,1] {
			script.replace2BytesAtOffset(kUnlimitedTutorMovesJumpOffsets2[i], withBytes: kUnlimitedTutorMovesJumpInstructions[i])
		}
		
		script.save()
	}
	
	
	@objc class func removeShinyGlitch() {
		// upon further inspection it seems this isn't necessary. I believe the player's tid is always used when generating shadow pokemon
		
		let dol = XGFiles.dol.data
		
		dol.replace4BytesAtOffset(kShinyCalcPIDOffset1, withBytes: kShinyCalcNewPIDInstruction)
		dol.replace4BytesAtOffset(kShinyCalcPIDOffset2, withBytes: kShinyCalcNewPIDInstruction)
		
		dol.save()
	}
	
	@objc class func replaceShinyGlitch() {
		let dol = XGFiles.dol.data
		
		dol.replace4BytesAtOffset(kShinyCalcPIDOffset1, withBytes: kShinyCalcOriginalPIDInstruction)
		dol.replace4BytesAtOffset(kShinyCalcPIDOffset2, withBytes: kShinyCalcOriginalPIDInstruction)
		
		dol.save()
	}
	
	@objc class func getShinyChance() -> Float {
		let dol = XGFiles.dol.data
		
		let val = Float(dol.get2BytesAtOffset(kShinyCalcChanceOffset1))
		return val / 0xFFFF * 100
		
	}
	
	@objc class func changeShinyChancePercentage(_ newValue: Float) {
		// Input the shiny chance as a percentage
		
		guard newValue < 50 else {
			printg("Shiny value can't be more than 50 because the number will be treated as negative")
			return
		}
		
		let dol = XGFiles.dol.data
		
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
		
//		XGAlertView(title: "Patch Complete", message: "The Patch has been applied", doneButtonTitle: "Swag", otherButtonTitles: nil, buttonAction: nil).show()
	}
	
	@objc class func zeroForeignStringTables() {
		
		if game == .XD {
			let tableOffsetsAndSizes = [ (0x7AAFC,0xD484), (0x87F80,0xD3BC), (0x9533C,0xD334), (0x6D874,0xD288) ]
			
			for i in 0 ..< tableOffsetsAndSizes.count {
				XGStringTable(file: .common_rel, startOffset: tableOffsetsAndSizes[i].0, fileSize: tableOffsetsAndSizes[i].1).purge()
			}
		} else {
			// clears colosseum debug string table
			XGStringTable.common_rel2().purge()
		}
		
		
	}
	
	@objc class func decapitalise() {
		
		for i in 0 ..< kNumberOfMoves {
			let name = XGMoves.move(i).name
			name.duplicateWithString(name.string.capitalized).replace()
		}
		
		for i in 0 ..< CommonIndexes.NumberOfItems.value {
			let name = XGItems.item(i).name
			name.duplicateWithString(name.string.capitalized).replace()
		}
		
		for i in 0 ..< kNumberOfPokemon {
			let name = XGPokemon.pokemon(i).name
			name.duplicateWithString(name.string.capitalized).replace()
		}
		
		for i in 0 ..< kNumberOfTrainerClasses {
			let name = XGTrainerClasses(rawValue: i)!.name
			name.duplicateWithString(name.string.capitalized).replace()
		}
		
		for i in 0 ..< kNumberOfAbilities {
			let name = XGAbilities.ability(i).name
			name.duplicateWithString(name.string.capitalized).replace()
		}
		
		
	}
	
	@objc class func removeTradeEvolutions() {
		
		for i in 0 ..< kNumberOfPokemon {
			
			let stats = XGPokemonStats(index: i)
			
			for j in 0 ..< kNumberOfEvolutions {
				if (stats.evolutions[j].evolutionMethod == XGEvolutionMethods.trade) || (stats.evolutions[j].evolutionMethod == XGEvolutionMethods.tradeWithItem) {
					stats.evolutions[j].evolutionMethod = .levelUp
					stats.evolutions[j].condition = 40
					stats.save()
				}
			}
			
		}
		
	}
	
	class func alwaysShowShadowPokemonNature() {
		if game == .XD {
			if region == .US {
				// can always see shadow pokemon nature
				let shadowNatureStart = 0x0352d8 - kDOLtoRAMOffsetDifference
				XGAssembly.replaceASM(startOffset: shadowNatureStart, newASM: [kNopInstruction, kNopInstruction])
			} else {
				printg("path \"always show shadow pokemon nature\" isn't available for this region.")
			}
		}
	}
	
	class func allowFemaleStarters() {
		for i in 0 ... 1 {
			let mon = XGDemoStarterPokemon(index: i)
			mon.gender = .random
			mon.save()
		}
	}
	
	class func gen7CritRatios() {
		if region == .EU {
			return
		}
		if game == .XD && region != .US {
			return
		}
		let critRatiosStartOffset  = game == .XD ? 0x41dd20 : (region == .US ? 0x397c18 : 0x384388)
		//let numberCritRatiosOffset = critRatiosStartOffset + 8
		
		let dol = XGFiles.dol.data
		dol.replaceBytesFromOffset(critRatiosStartOffset, withByteStream: [24,8,2,1,1])
		dol.save()
	}
	
	class func applyPatch(_ patch: XGDolPatches) {
		
		if region == .EU {
			printg("EU support not ready for patch:",patch.name)
			return
		}
		
		switch patch {
			case .betaStartersApply				: XGDolPatcher.enableBetaStarters()
			case .betaStartersRemove			: XGDolPatcher.disableBetaStarters()
			case .physicalSpecialSplitApply		: XGDolPatcher.applyPhysicalSpecialSplitPatch()
			case .physicalSpecialSplitRemove	: XGDolPatcher.removePhysicalSpecialSplitPatch()
			case .renameAllPokemonApply			: XGDolPatcher.allowRenamingAnyPokemon()
			case .shinyChanceEditingApply		: XGDolPatcher.removeShinyGlitch()
			case .shinyChanceEditingRemove		: XGDolPatcher.replaceShinyGlitch()
			case .type9IndependentApply			: XGDolPatcher.removeType9Dependencies()
			case .unlimitedTutorMovesApply		: XGDolPatcher.implementUnlimitedTutors()
			case .zeroForeignStringTables		: XGDolPatcher.zeroForeignStringTables()
			case .decapitaliseNames				: XGDolPatcher.decapitalise()
			case .tradeEvolutions				: XGDolPatcher.removeTradeEvolutions()
		}
		
//		XGAlertView(title: "Patch Complete", message: "The Patch has been applied", doneButtonTitle: "Swag", otherButtonTitles: nil, buttonAction: nil).show()
		printg("patch applied: ", patch.name)
		
	}
	
	
}



















