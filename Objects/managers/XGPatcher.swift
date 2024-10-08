//
//  XGPatcher.swift
//  XG Tool
//
//  Created by StarsMmd on 19/05/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

var kClassPatchOffsets: [Int] {
	switch region {
	case .US:
		return [0x8013e82c,0x80229614,0x8022A080,0x802157F0,0x802177e0]
	case .EU:
		return [0x801400f0,0x8022b458,0x8022bec4,0x80217634]
	default:
		return []
	}
}
let kNopInstruction		  : UInt32 = XGASM.nop.code
let kBranchInstruction1	  : UInt32 = 0x40820024
let kBranchInstruction2   : UInt32 = 0x40820014
let kBranchInstruction9   : UInt32 = 0x480000E4

var kColoLockedMoveIconIDRAMOffset: Int {
	switch region {
	case .US: return 0x094b0c
	default: return -1
	}
}

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

var kShinyCalcChanceRAMOffsets: (Int, Int) {
	// Colosseum has multiple shiny calcs in various functions so this is currently
	// only implemented for XD
	switch region {
	case .US: return (0x144172, 0x14af86)
	case .EU: return (0x145a36, 0x14c84a)
	case .JP: return (0x13f57e, 0x1462e2)
	case .OtherGame: return (-1, -1)
	}
}

let kShinyCalcOriginalPIDInstruction		: UInt32 = 0x7CA30278
let kShinyCalcOriginalChanceInstruction		= 0x0008

let kShinyCalcNewPIDInstruction				: UInt32 = 0x38600000

let kNumberOfDolPatches = 12

// XD
var shadowPokemonShininessRAMOffset: Int {
	switch region {
	case .US: return 0x1fc2b2
	case .EU: return 0x1fdfe6
	case .JP: return 0x1f6f76
	case .OtherGame: return 0
	}
}

let patches: [XGDolPatches] = game == .XD ? [
	.purgeUnusedText,
	.physicalSpecialSplitApply,
	.physicalSpecialSplitRemove,
	.disableSaveCorruption,
	.infiniteTMs,
	.expAll,
	.allowFemaleStarters,
	.betaStartersApply,
	.betaStartersRemove,
//	.switchPokemonAtEndOfTurn,
	.fixShinyGlitch,
	.replaceShinyGlitch,
	.allowShinyShadowPokemon,
	.shinyLockShadowPokemon,
	.alwaysShinyShadowPokemon,
	.gen6CritMultipliers,
	.gen7CritRatios,
	.tradeEvolutions,
	.removeItemEvolutions,
	.enableDebugLogs,
	.pokemonCanLearnAnyTM,
	.pokemonHaveMaxCatchRate,
	.removeEVCap,
	.allSingleBattles,
	.allDoubleBattles,
	.type9IndependentApply,
	.maxPokespotEntries,
	.preventPokemonRelease,
	.completeStrategyMemo,
	.disableBattleAnimations
] : [
	.physicalSpecialSplitApply,
	.disableSaveCorruption,
	.addSoftReset,
	.loadPCFromAnywhere,
	.removeShinyLocksFromGiftPokemon,
	.allowFemaleStarters,
	.infiniteTMs,
	.gen6CritMultipliers,
	.gen7CritRatios,
	.tradeEvolutions,
	.removeItemEvolutions,
	.allowShinyStarters,
	.shinyLockStarters,
	.alwaysShinyStarters,
	.enableDebugLogs,
	.noTypeIconForLockedMoves,
	.pokemonCanLearnAnyTM,
	.pokemonHaveMaxCatchRate,
	.allSingleBattles,
	.allDoubleBattles,
	.removeColbtlRegionLock
]

enum XGDolPatches: Int {
	
	case physicalSpecialSplitApply
	case physicalSpecialSplitRemove
	case type9IndependentApply
	case noTypeIconForLockedMoves
	case betaStartersApply
	case betaStartersRemove
	case renameAllPokemonApply
	case shinyChanceEditingApply
	case shinyChanceEditingRemove
	case purgeUnusedText
	case decapitaliseNames
	case tradeEvolutions
	case removeItemEvolutions
	case defaultMoveCategories
	case allowFemaleStarters
	case allowShinyStarters
	case shinyLockStarters
	case alwaysShinyStarters
	case allowShinyShadowPokemon
	case shinyLockShadowPokemon
	case alwaysShinyShadowPokemon
	case switchPokemonAtEndOfTurn
	case fixShinyGlitch
	case replaceShinyGlitch
	case infiniteTMs
	case enableDebugLogs
	case pokemonCanLearnAnyTM
	case pokemonHaveMaxCatchRate
	case removeEVCap
	case gen6CritMultipliers
	case gen7CritRatios
	case allSingleBattles
	case allDoubleBattles
	case freeSpaceInDol
	case deleteUnusedFiles
	case removeColbtlRegionLock
	case disableSaveCorruption
	case maxPokespotEntries
	case preventPokemonRelease
	case completeStrategyMemo
	case addSoftReset
	case loadPCFromAnywhere
	case removeShinyLocksFromGiftPokemon
	case disableBattleAnimations
	case expAll
	
	var name: String {
		switch self {
		case .deleteUnusedFiles: return "Delete some unused files to free up some space in the ISO"
		case .freeSpaceInDol: return "Create some space in \(XGFiles.dol.fileName) which is needed for other assembly patches"
		case .physicalSpecialSplitApply : return "Apply the gen IV physical/special split and set moves to their default category"
		case .physicalSpecialSplitRemove : return "Remove the physical/special split"
		case .type9IndependentApply : return "Makes the battle engine treat the ??? type as regular type"
		case .noTypeIconForLockedMoves : return "When a shadow pokemon has locked moves the move doesn't show the ??? type icon"
		case .betaStartersApply : return "Allows the player to start with 2 pokemon"
		case .betaStartersRemove : return "Revert to starting with 1 pokemon"
		case .renameAllPokemonApply	: return "Allows the name rater to rename all pokemon - Crashes parts of game"
		case .shinyChanceEditingApply : return "Removes shiny purification glitch by generating based on a fixed trainer ID"
		case .shinyChanceEditingRemove : return "shininess will be determined by trainer ID as usual"
		case .purgeUnusedText : return "Removes foreign language text from the US version"
		case .decapitaliseNames : return "Decapitalises a lot of text"
		case .tradeEvolutions : return "Trade evolutions become level 40"
		case .removeItemEvolutions : return "Evolution stone evolutions become level 40"
		case .defaultMoveCategories: return "Sets the physical/special category for all moves to their expected values"
		case .allowFemaleStarters: return "Allow starter pokemon to be female"
		case .switchPokemonAtEndOfTurn: return "After a KO the next pokemon switches in at end of turn"
		case .fixShinyGlitch: return "Fix shiny glitch"
		case .replaceShinyGlitch: return "Return to the default shiny glitch behaviour"
		case .infiniteTMs: return "TMs can be reused infinitely"
		case .allowShinyStarters: return "Starter pokemon can be shiny"
		case .shinyLockStarters: return "Starter pokemon can never be shiny"
		case .alwaysShinyStarters: return "Starter pokemon are always shiny"
		case .allowShinyShadowPokemon: return "Shadow pokemon can be shiny"
		case .shinyLockShadowPokemon: return "Shadow pokemon can never be shiny"
		case .alwaysShinyShadowPokemon: return "Shadow pokemon are always shiny"
		case .enableDebugLogs: return "Enable Debug Logs (Only useful for script development)"
		case .pokemonCanLearnAnyTM: return "Any pokemon can learn any TM"
		case .pokemonHaveMaxCatchRate: return "All pokemon have the maximum catch rate of 255"
		case .removeEVCap: return "Allow pokemon to have an EV total above 510"
		case .gen6CritMultipliers: return "Gen 6+ critical hit multiplier (1.5x)"
		case .gen7CritRatios: return "Gen 7+ critical hit probablities"
		case .allSingleBattles: return "Set all battles to single battles"
		case .allDoubleBattles: return "Set all battles to double battles"
		case .removeColbtlRegionLock: return "Modify the ASM so it allows any region's colbtl.bin to be imported. Trades will be locked to whichever region's colbtl.bin was imported"
		case .disableSaveCorruption: return "Disables some save file checks to prevent the save from being corrupted"
		case .maxPokespotEntries: return "Change the max number of pokemon per pokespot from 3 to 100"
		case .preventPokemonRelease: return "Disables the ability to release Pokemon"
		case .completeStrategyMemo: return "All pokemon will be viewable in the strategy memo immediately"
		case .addSoftReset: return "Adds the ability to soft reset using B + X + Start button combo"
		case .loadPCFromAnywhere: return "Press R in the overworld to open the PC menu from anywhere (Make sure you don't softlock yourself)"
		case .removeShinyLocksFromGiftPokemon: return "Remove shiny locks from gift pokemon (espeon, umbreon, plusle, pikachu, celebi, hooh)"
		case .disableBattleAnimations: return "Disable attack animations during battles"
		case .expAll: return "All party pokemon gain exp without having to battle"
		}
	}	
}

class XGPatcher {

	/// Clears some unused function data from the assembly so those addresses can be used for our own ASM
	static func clearUnusedFunctionsInDol() {
		guard !checkIfUnusedFunctionsInDolWereCleared() else {
			printg("ASM space already created in \(XGFiles.dol.fileName)")
			return
		}
		if let data = XGFiles.dol.data,
		let start = kDolFreeSpaceStart,
		let end = kDolFreeSpaceEnd {
			var offset = start
			while offset < end {
				// replace with nops rather than zeroes so dolphin doesn't complain
				// when panic handlers aren't disabled
				data.replace4BytesAtOffset(offset, withBytes: 0x60000000)
				offset += 4
			}
			data.replaceWordAtOffset(start, withBytes: 0x0DE1E7ED)
			(1 ... 3).forEach {
				data.replaceWordAtOffset(start + ($0 * 4), withBytes: 0xFFFFFFFF)
			}
			data.save()
		}
	}

	static func checkIfUnusedFunctionsInDolWereCleared() -> Bool {
		if let data = XGFiles.dol.data, let start = kDolFreeSpaceStart {
			return data.getWordAtOffset(start) == 0x0DE1E7ED
		}
		return false
	}

	static func deleteUnusedFiles() {
		XGUtility.deleteSuperfluousFiles()
	}
	
	//Incorporates Physical/Special Split on all moves. The category is determined by byte 0x12 of the move's data.
	
	class func isClassSplitImplemented() -> Bool {
		
		guard game != .PBR, let dol = XGFiles.dol.data else {
			return game == .PBR
		}

		if game == .XD, region == .US {

			let offset = kClassPatchOffsets[0]
			let machineInstruction = dol.getWordAtOffset(offset)
			return machineInstruction == kNopInstruction

		} else if game == .Colosseum {
			switch region {
			case .US:
				return dol.getWordAtOffset(0x10c4ac - kDolToRAMOffsetDifference) == 0x8863001F
			case .EU:
				return dol.getWordAtOffset(0x10fac4 - kDolToRAMOffsetDifference) == 0x8863001F
			case .JP:
				return dol.getWordAtOffset(0x109e54 - kDolToRAMOffsetDifference) == 0x8863001F
			case .OtherGame:
				return false
			}

		}

		return false
	}
	
	class func applyPhysicalSpecialSplitPatch(setDefaultMoveCategories: Bool = false) {
		
		if game == .XD {

			guard region != .JP else {
				printg("This patch has not been implemented for this game region:", region.name)
				return
			}
			
			let dol = XGFiles.dol.data!
			for offset in kClassPatchOffsets {
				dol.replaceWordAtOffset(offset - kDolToRAMOffsetDifference, withBytes: kNopInstruction)
			}
			
			if region == .US {
				dol.replaceWordAtOffset(kMirrorCoatOffset1, withBytes: kNopInstruction)
				dol.replaceWordAtOffset(kMirrorCoatOffset2, withBytes: kMirrorCoatBranch)
				dol.replaceWordAtOffset(kCounterOffset1, withBytes: kNopInstruction)
				dol.replaceWordAtOffset(kCounterOffset2, withBytes: kCounterBranch)
			}
			dol.save()
			
		} else if game == .Colosseum {
			
			let typeGetCategory: Int
			let move17Offsets: [Int]
			let move23Offsets: [Int]
			let move30Offsets: [Int]
			let move31Offsets: [Int]

			switch region {
			case .US:
				typeGetCategory = 0x10c4a0
				move17Offsets = [0x232938,0x2324c8]
				move23Offsets = [0x24462c,0x2447b8]
				move30Offsets = [0x226c18]
				move31Offsets = [0x228b5c]
			case .EU:
				typeGetCategory = 0x10FAB8
				move17Offsets = [0x236FC8,0x237438]
				move23Offsets = [0x249154,0x2492e0]
				move30Offsets = [0x22b718]
				move31Offsets = [0x22d65c]
			case .JP:
				typeGetCategory = 0x109e48
				move17Offsets = [0x22E0D0,0x22DC60]
				move23Offsets = [0x23FDC4,0x23FF50]
				move30Offsets = [0x2223B0]
				move31Offsets = [0x2242f4]
			case .OtherGame:
				typeGetCategory = 0
				move17Offsets = []
				move23Offsets = []
				move30Offsets = []
				move31Offsets = []
			}

			XGAssembly.replaceRamASM(RAMOffset: typeGetCategory, newASM: [
				.mulli(.r0, .r3, 56),
				.lwz(.r3, .r13, -0x7a24),
				.add(.r3, .r3, .r0),
				.lbz(.r3, .r3, 0x1f), // move data get category (byte 0x1f which is unused in vanilla)
				.blr
			])
			for offset in move17Offsets {
				XGAssembly.replaceASM(startOffset: offset - kDolToRAMOffsetDifference, newASM: [0x7e238b78])
			}
			for offset in move23Offsets {
				XGAssembly.replaceASM(startOffset: offset - kDolToRAMOffsetDifference, newASM: [0x7ee3bb78])
			}
			for offset in move30Offsets {
				XGAssembly.replaceASM(startOffset: offset - kDolToRAMOffsetDifference, newASM: [0x7fc3f378])
			}
			for offset in move31Offsets {
				XGAssembly.replaceASM(startOffset: offset - kDolToRAMOffsetDifference, newASM: [0x7fe3fb78])
			}

		}

		if setDefaultMoveCategories {
			XGUtility.defaultMoveCategories()
		}
		
	}
	
	class func removePhysicalSpecialSplitPatch() {

		guard game == .XD else {
			printg("This patch has not been implemented for Pokemon Colosseum.")
			return
		}

		guard region == .US else {
			printg("This patch has not been implemented for this game region:", region.name)
			return
		}
		
		let dol = XGFiles.dol.data!
		
		for offset in kClassPatchOffsets {
			
			if offset == kClassPatchOffsets[0] {
				dol.replaceWordAtOffset(offset, withBytes: kBranchInstruction1)
			} else {
				dol.replaceWordAtOffset(offset, withBytes: kBranchInstruction2)
			}
			
		}
		
		dol.replaceWordAtOffset(kMirrorCoatOffset1, withBytes: kMirrorBranchOrigin1)
		dol.replaceWordAtOffset(kMirrorCoatOffset2, withBytes: kMirrorBranchOrigin2)
		dol.replaceWordAtOffset(kCounterOffset1, withBytes: kCounterBranchOrigin1)
		dol.replaceWordAtOffset(kCounterOffset2, withBytes: kCounterBranchOrigin2)
		
		dol.save()
		
	}
	
	//Allows the safe changing of type 9 (?) to another type, e.g. fairy.
	
	class func isType9Independent() -> Bool {

		guard game == .XD else {
			printg("This patch has not been implemented for Pokemon Colosseum.")
			return false
		}

		guard region == .US else {
			printg("This patch has not been implemented for this game region:", region.name)
			return false
		}

		if (game == .XD) {
			let dol = XGFiles.dol.data!
			return dol.getWordAtOffset(0x2C55B0) == kBranchInstruction9
		} else {
			return XGFiles.dol.data!.getWordAtOffset(kColoLockedMoveIconIDRAMOffset) == XGASM.li(.r0, 0).code
		}
	}
	
	class func removeType9Dependencies() {

		guard region == .US else {
			printg("This patch has not been implemented for this game region:", region.name)
			return
		}

		if (game == .XD) {
			let dol = XGFiles.dol.data!

			dol.replaceWordAtOffset(0x2C55B0, withBytes: kBranchInstruction9)
			dol.replaceWordAtOffset(0x031230, withBytes: 0x3B400000)


			let nopOffsets = [0x2C59FC, 0x2C5D8C, 0x2C8870, 0x2C895C]

			for offset in nopOffsets {
				dol.replaceWordAtOffset(offset, withBytes: kNopInstruction)
			}

			dol.save()
		} else {
			XGAssembly.replaceRamASM(RAMOffset: kColoLockedMoveIconIDRAMOffset, newASM: [.li(.r0, 0)])
		}
		
	}
	
	// Changes the starters from eevee to the beta jolteon and vaporeon which can be edited.
	class func enableBetaStarters() {

		guard game == .XD else {
			printg("This patch is for Pokemon XD: Gale of Darkness only.")
			return
		}
		
		let codeStartOffset: Int = {
			switch region {
			case .US: return 0x801CED68
			case .EU: return 0x801D083C
			case .JP: return 0x801C9C0C
			default: return 0
			}
		}()
		
		let demoStarterFunctionRAMOffsets: (Int,Int) = {
			switch region {
			case .US: return (0x80152674,0x8015279C)
			case .EU: return (0x80153f38,0x80154060)
			case .JP: return (0x8014D99C, 0x8014DAC4)
			default: return (0,0)
			}
		}()
		
		XGAssembly.replaceRamASM(RAMOffset: codeStartOffset, newASM: [
			.bl(demoStarterFunctionRAMOffsets.0),
			.mr(.r3, .r31),
			.bl(demoStarterFunctionRAMOffsets.1),
		])
	}
	
	class func disableBetaStarters() {

		guard game == .XD else {
			printg("This patch is for Pokemon XD: Gale of Darkness only.")
			return
		}
		
		let codeStartOffset: Int = {
			switch region {
			case .US: return 0x801CED68
			case .EU: return 0x801D083C
			case .JP: return 0x801C9C0C
			default: return 0
			}
		}()
		
		let starterFunctionRAMOffset: Int = {
			switch region {
			case .US: return 0x80152AE0
			case .EU: return 0x801543A4
			case .JP: return 0x8014DE08
			default: return 0
			}
		}()
		
		XGAssembly.replaceRamASM(RAMOffset: codeStartOffset, newASM: [
			.stw(.r6, .sp, 0x38),
			.stw(.r0, .sp, 0x3C),
			.bl(starterFunctionRAMOffset)
		])
	}
	
	// Clashes with move tutor somehow
	// Allows the name rater to nickname any pokemon
	
//	class func canRenameAnyPokemon() -> Bool {
//		let dol = XGFiles.dol.data!
//		return dol.getWordAtOffset(kNameRaterOffset1) == kNopInstruction
//	}
//	
	class func allowRenamingAnyPokemon() {
//		let dol = XGFiles.dol.data!
//		
//		dol.replaceWordAtOffset(kNameRaterOffset1, withBytes: kNopInstruction)
//		dol.replaceWordAtOffset(kNameRaterOffset2, withBytes: kNameRaterInstruction2)
//		dol.replaceWordAtOffset(kNameRaterOffset3, withBytes: kNameRaterInstruction3)
//		
//		dol.save()
	}
	
	
	class func removeShinyGlitch() {

		guard game != .Colosseum else {
			printg("This patch has not been implemented for Colosseum yet.")
			return
		}
		
		let codeStartOffset: Int = {
			switch region {
			case .US: return 0x1fa930
			case .EU: return 0x1fc664
			case .JP: return 0x1f55f4
			case .OtherGame: return 0
			}
		}()
		
		let getTrainerData: Int = {
			switch region {
			case .US: return 0x1cefb4
			case .EU: return 0x1d0a8c
			case .JP: return 0x1c9e54
			case .OtherGame: return 0
			}
		}()
		
		let trainerGetTID: Int = {
			switch region {
			case .US: return 0x14e118
			case .EU: return 0x14f9dc
			case .JP: return 0x149460
			case .OtherGame: return 0
			}
		}()
		
		let TIDRerollOffset: Int = {
			switch region {
			case .US: return 0x1fa9c8
			case .EU: return 0x1fc6fc
			case .JP: return 0x1f568c
			case .OtherGame: return 0
			}
		}()
		
		XGAssembly.replaceRamASM(RAMOffset: codeStartOffset, newASM: [
			.li(.r3, 0),
			.li(.r4, 2),
			.bl(getTrainerData),
			.bl(trainerGetTID)
		])
		
		XGAssembly.replaceRamASM(RAMOffset: TIDRerollOffset, newASM: [
			.b_f(0, 0x2c)
		])
	}
	
	class func replaceShinyGlitch() {

		guard region != .JP else {
			printg("This patch has not been implemented for this game region:", region.name)
			return
		}
		
		guard game == .XD else {
			printg("This patch has not been implemented for Pokemon Colosseum")
			return
		}

		if XGFiles.dol.exists {

			let codeStartOffset: Int = {
				switch region {
				case .US: return 0x1fa930
				case .EU: return 0x1fc664
				case .JP: return -1
				case .OtherGame: return 0
				}
			}()

			let trainerGetValue: Int = {
				switch region {
				case .US: return 0x14d6e0
				case .EU: return 0x14efa4
				case .JP: return -1
				case .OtherGame: return 0
				}
			}()

			XGAssembly.replaceRamASM(RAMOffset: codeStartOffset, newASM: [
				.mr(.r3, .r28),
				.li(.r4, 2),
				.li(.r5, 0),
				.bl(trainerGetValue)
			])
		}
	}
	
	class func getShinyChance() -> Float? {
		guard game == .XD else {
			printg("Can't get shiny chance for this game:", game.name)
			return nil
		}
		guard let dol = XGFiles.dol.data else {
			return nil
		}
		
		let val = Float(dol.get2BytesAtOffset(kShinyCalcChanceRAMOffsets.0 - kDolToRAMOffsetDifference))
		return val / 0xFFFF * 100
		
	}
	
	class func changeShinyChancePercentage(_ newValue: Float) {
		// Input the shiny chance as a percentage

		guard game == .XD else {
			printg("This patch has not been implemented for this game:", game.name)
			return
		}
		
		guard newValue < 50 else {
			printg("Shiny value can't be more than 50 because the number will be treated as negative")
			return
		}
		
		guard let dol = XGFiles.dol.data else {
			return
		}
		
		var val = min(Int(newValue * 0xFFFF) / 100, 0x7FFF)
		val = max(val, 0)
		
		dol.replace2BytesAtOffset(kShinyCalcChanceRAMOffsets.0 - kDolToRAMOffsetDifference, withBytes: val)
		dol.replace2BytesAtOffset(kShinyCalcChanceRAMOffsets.1 - kDolToRAMOffsetDifference, withBytes: val)
		dol.save()

	}

	class func setType9BattleBingoPanelToUnusedPanel() {
		guard game != .Colosseum else {
			printg("This patch isn't for colosseum.")
			return
		}

		guard region == .US else {
			printg("This patch has not been implemented for this game region:", region.name)
			return
		}

		if let dol = XGFiles.dol.data {
			let type9BingoPanelType9Offset = 0x2E89BE
			dol.replace2BytesAtOffset(type9BingoPanelType9Offset, withBytes: 725)

			// replace the code that uses this texture in case it is actually used
			// set it to myster panel texture
			let blankPanelRAMOffsets = [0x095082, 0x095202]
			for offset in blankPanelRAMOffsets {
				dol.replace2BytesAtOffset(offset - kDolToRAMOffsetDifference, withBytes: 670)
			}
			dol.save()
		}
	}
	
	class func purgeUnusedText() {
		
		if game == .XD {
			guard region == .US else {
				printg("This patch has not been implemented for this game region:", region.name)
				return
			}

			let tableOffsetsAndSizes = [ (0x7AAFC,0xD484), (0x87F80,0xD3BC), (0x9533C,0xD334), (0x6D874,0xD288) ]
			
			for (offset, size) in tableOffsetsAndSizes {
				XGStringTable(file: .common_rel, startOffset: offset, fileSize: size).purge()

			}
		} else {
			// clears colosseum debug string table
			XGStringTable.common_rel2().purge()
		}
	}
	
	class func decapitalise() {
		
		for i in 0 ..< CommonIndexes.NumberOfMoves.value {
			let name = XGMoves.index(i).name
			if !name.duplicateWithString(name.string.capitalized).replace() {
				printg("Couldn't decapitalise name: \(name)")
			}
		}
		
		for i in 0 ..< kNumberOfItems {
			let name = XGItems.index(i).name
			if !name.duplicateWithString(name.string.capitalized).replace() {
				printg("Couldn't decapitalise name: \(name)")
			}
		}
		
		for i in 0 ..< CommonIndexes.NumberOfPokemon.value {
			let name = XGPokemon.index(i).name
			if !name.duplicateWithString(name.string.capitalized).replace() {
				printg("Couldn't decapitalise name: \(name)")
			}
		}
		
		for i in 0 ..< CommonIndexes.NumberOfTrainerClasses.value {
			let name = XGTrainerClasses(rawValue: i)!.name
			if !name.duplicateWithString(name.string.capitalized).replace() {
				printg("Couldn't decapitalise name: \(name)")
			}
		}
		
		for i in 0 ..< kNumberOfAbilities {
			let name = XGAbilities.index(i).name
			if !name.duplicateWithString(name.string.capitalized).replace() {
				printg("Couldn't decapitalise name: \(name)")
			}
		}
		
		
	}
	
	class func removeTradeEvolutions() {
		printg("Setting pokemon that require a trade to evolve to evolve at level 40 instead")
		
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

	class func removeItemEvolutions() {
		printg("Setting pokemon that require an item like an evolution stone to evolve to evolve at level 40 instead")

		for i in 0 ..< kNumberOfPokemon {
			let stats = XGPokemonStats(index: i)
			for j in 0 ..< kNumberOfEvolutions {
				if stats.evolutions[j].evolutionMethod == XGEvolutionMethods.evolutionStone {
					stats.evolutions[j].evolutionMethod = .levelUp
					stats.evolutions[j].condition = 40
					stats.save()
				}
			}
		}
	}
	
	class func alwaysShowShadowPokemonNature() {
		guard game == .XD && region == .US else {
			printg("This patch has not been implemented for this game region:", region.name)
			return
		}
		let shadowNatureStart = 0x0352d8 - kDolToRAMOffsetDifference
		XGAssembly.replaceASM(startOffset: shadowNatureStart, newASM: [.nop, .nop])
	}
	
	class func allowFemaleStarters() {
		for i in 0 ... 1 {
			let mon = XGDemoStarterPokemon(index: i)
			mon.gender = .random
			mon.save()
		}
	}

	class func setStarterShininess(to: XGShinyValues) {
		for i in 0 ... 1 {
			let mon = XGDemoStarterPokemon(index: i)
			mon.shinyValue = to
			mon.save()
		}
		if game == .XD {
			if region == .US {
				let mon = XGStarterPokemon()
				mon.shinyValue = to
				mon.save()
			} else {
				printg("Starter Eevee shiniess has not been implemented for this game region:", region.name)
			}
		}
	}

	class func setShadowPokemonShininess(to: XGShinyValues) {

		guard game == .XD else {
			printg("This patch is for Pokemon XD: Gale of Darkness only.")
			return
		}
		
		if let dol = XGFiles.dol.data {
			dol.replace2BytesAtOffset(shadowPokemonShininessRAMOffset - kDolToRAMOffsetDifference, withBytes: to.rawValue)
			#if GAME_XD
			dol.replace2BytesAtOffset(tradeShadowPokemonShininessRAMOffset - kDolToRAMOffsetDifference, withBytes: to.rawValue)
			#endif
			dol.save()
		}
	}
	
	class func gen6CritMultipliers() {
		if region != .US {
			printg("This patch has not been implemented for this game region:", region.name)
			return
		}
		
		let entryPoint1: (entryPoint: Int, source: XGRegisters, destination: XGRegisters, next: XGRegisters)? = {
			if game == .XD {
				switch region {
				case .US: return (0x8020dafc,.r31,.r27,.r26)
				default: return nil
				}
			}
			if game == .Colosseum {
				switch region {
				case .US: return (0x80227d14,.r31,.r27,.r25)
				default: return nil
				}
			}
			
			return nil
		}()
		let entryPoint2: (entryPoint: Int, source: XGRegisters, destination: XGRegisters, next: XGRegisters)? = {
			if game == .Colosseum {
				switch region {
				case .US: return (0x80211640,.r25,.r25,.r14)
				default: return nil
				}
			}
			
			return nil
		}()

		let criticalHitConstant = 2
		for constants in [entryPoint1, entryPoint2] {
			if let constants, let freespace = XGAssembly.ASMfreeSpaceRAMPointer() {
				let entryPoint = constants.entryPoint
				XGAssembly.replaceRamASM(RAMOffset: entryPoint, newASM: [
					.b(freespace),
					.nop,
					.mr(.r3, constants.next)
				])
				XGAssembly.replaceRamASM(RAMOffset: freespace, newASM: [
					.cmpwi(.r3, criticalHitConstant),
					.bne_l("is not critical hit"),
					
					.label("is critical hit"),
					.mulli(constants.destination, constants.source, 3),
					.srawi(constants.destination, constants.destination, 1),
					.b_l("end"),
					
					.label("is not critical hit"),
					.mr(constants.destination, constants.source),
					
					.label("end"),
					.b(constants.entryPoint + 4)
				])
			}
		}
	}
	
	class func gen7CritRatios() {
		if region == .EU || (game == .XD && region != .US) {
			printg("This patch has not been implemented for this game region:", region.name)
			return
		}

		let critRatiosStartOffset  = game == .XD ? 0x41dd20 : (region == .US ? 0x397c18 : 0x384388)
		//let numberCritRatiosOffset = critRatiosStartOffset + 8
		
		let dol = XGFiles.dol.data!
		dol.replaceBytesFromOffset(critRatiosStartOffset, withByteStream: [24,8,2,1,1])
		dol.save()
	}

	class func enableDebugLogs() {
		guard region == .US else {
			printg("This patch has not been implemented for this game region:", region.name)
			return
		}

		let GSLogOffset: Int
		let OSReportOffset: Int

		if game == .XD {
			switch region {
			case .US:
				GSLogOffset = 0x2a65cc
				OSReportOffset = 0x0abc80
			case .EU:
				GSLogOffset = -1
				OSReportOffset = -1
			case .JP:
				GSLogOffset = -1
				OSReportOffset = -1
			case .OtherGame:
				GSLogOffset = -1
				OSReportOffset = -1
			}
		} else {
			switch region {
			case .US:
				GSLogOffset = 0x0dd970
				OSReportOffset = 0x09c2e0
			case .EU:
				GSLogOffset = -1
				OSReportOffset = -1
			case .JP:
				GSLogOffset = -1
				OSReportOffset = -1
			case .OtherGame:
				GSLogOffset = -1
				OSReportOffset = -1
			}
		}
		XGAssembly.replaceRamASM(RAMOffset: GSLogOffset, newASM: [.b(OSReportOffset)])

		// remove FIFO error logging since it spams the output
		if game == .XD && region == .US {
			for first in [0x2aae4c, 0x2a85c4, 0x2a89cc, 0x2a8be0, 0x2a9104, 0x2a9308, 0x2a964c, 0x2a9874, 0x2a9a58, 0x2aa908] {
				for i in 0 ..< 4 {
					XGAssembly.replaceRamASM(RAMOffset: first + (i * 20), newASM: [.nop])
				}
			}
		}
	}

	class func enableScriptLogs() {
		guard game == .XD else {
			printg("This patch is for Pokemon XD: Gale of Darkness only.")
			return
		}

		guard region == .US else {
			printg("This patch has not been implemented for this game region:", region.name)
			return
		}

		let OSReportOffset = 0x0abc80
		let scriptGSLogOffsets = [0x1bce88, 0x1bcf28, 0x1bcfa0, 0x1bd018, 0x1bd098, 0x1bd118, 0x1bd168, 0x1bd204]
		for GSLogOffset in scriptGSLogOffsets {
			XGAssembly.replaceRamASM(RAMOffset: GSLogOffset, newASM: [.bl(OSReportOffset)])
		}
	}

	class func pokemonCanLearnAnyTM() {
		#warning("TODO: change the check in the ASM instead of updating data tables")
		for mon in allPokemonArray().map({ $0.stats }) {
			mon.learnableTMs = mon.learnableTMs.map{ _ in return true }
			mon.save()
		}
	}

	class func pokemonHaveMaxCatchRate() {
		printg("Setting all mons to have max catch rate")
		#warning("TODO: set via the ASM instead of updating data tables")
		for mon in allPokemonArray().map({ $0.stats }).filter({ $0.catchRate > 0 }) {
			mon.catchRate = 255
			mon.save()
		}
		#if GAME_XD
		for mon in XGDecks.DeckDarkPokemon.allActivePokemon {
			mon.shadowCatchRate = 255
			mon.save()
		}
		#else
		CMShadowData.allValues.forEach { (data) in
			data.catchRate = 255
			data.save()
		}
		#endif
	}

	class func removeEVCap() {
		guard game == .XD else {
			printg("This patch is for Pokemon XD: Gale of Darkness only.")
			return
		}

		guard region != .JP else {
			printg("This patch has not been implemented for this game region:", region.name)
			return
		}

		let offsetsOf510: (plus: [Int], minus: [Int])
		switch region {
		case .US:
			offsetsOf510 = (plus: [0x140528, 0x140578, 0x04c2f8, 0x1603c0, 0x160420, 0x160558, 0x1605b8, 0x1609e0, 0x160a40, 0x160b78, 0x160bd8, 0x160d10, 0x160d70, 0x160ea8, 0x160f08], minus: [0x140580, 0x160428, 0x1605c0, 0x160a48, 0x160be0, 0x160d78, 0x160f10])
		case .EU:
			offsetsOf510 = (plus: [0x141dec, 0x141e3c, 0x04c34c, 0x161c70, 0x161cd0, 0x161e08, 0x161e68, 0x162290, 0x1622f0, 0x162428, 0x162488, 0x1625c0, 0x162620, 0x162758, 0x1627b8], minus: [0x141e44, 0x161cd8, 0x161e70, 0x1622f8, 0x162490, 0x162628, 0x1627c0])
		default:
			offsetsOf510 = ([],[])
			return
		}

		let newMaxEVs = 1530 // 255 x 6
		if let dol = XGFiles.dol.data {
			for offset in offsetsOf510.plus {
				dol.replace2BytesAtOffset(offset + 2 - kDolToRAMOffsetDifference, withBytes: newMaxEVs)
			}
			let negativeValue = Int(XGASM.subi(.r3, .r3, newMaxEVs).code & 0xFFFF)
			for offset in offsetsOf510.minus {
				dol.replace2BytesAtOffset(offset + 2 - kDolToRAMOffsetDifference, withBytes: negativeValue)
			}
			dol.save()
		}
	}

	class func preventSaveFileCorruption() {
		// based on https://github.com/dolphin-emu/dolphin/commit/49e6478817f17431612ab6246256fa83a1997d6f
		let saveCountRAMOffset: Int
		let memoryCardMatchOffset: Int

		if game == .XD {
			switch region {
			case .US:
				saveCountRAMOffset = 0x1cc304
				memoryCardMatchOffset = 0x1cc4b0
			case .EU:
				saveCountRAMOffset = 0x1cd764
				memoryCardMatchOffset = 0x1cd910
			case .JP:
				saveCountRAMOffset = 0x1c7984
				memoryCardMatchOffset = 0x1c7b30
			case .OtherGame:
				saveCountRAMOffset = -1
				memoryCardMatchOffset = -1
			}
		} else {
			switch region {
			case .US:
				saveCountRAMOffset = 0x1cfc2c
				memoryCardMatchOffset = 0x1cfc7c
			case .EU:
				saveCountRAMOffset = 0x1d429c
				memoryCardMatchOffset = 0x1d42ec
			case .JP:
				saveCountRAMOffset = 0x1cb5b8
				memoryCardMatchOffset = 0x1cb608
			case .OtherGame:
				saveCountRAMOffset = -1
				memoryCardMatchOffset = -1
			}
		}

		if game == .XD {
			XGAssembly.replaceRamASM(RAMOffset: saveCountRAMOffset, newASM: [.stw(.r7, .r5, 0x2c)])
		} else {
			XGAssembly.replaceRamASM(RAMOffset: saveCountRAMOffset, newASM: [.stw(.r0, .r5, 0x2c)])
		}

		XGAssembly.replaceRamASM(RAMOffset: memoryCardMatchOffset, newASM: [.nop])
	}

	class func setPokefaceCropDimensions(to length: Int) {
		guard game == .XD else {
			printg("Pokeface crop offsets are only available for Pokemon XD atm")
				return
		}
		guard region == .US else {
			printg("Pokeface crop offsets aren't implemented for this region", region.name)
			return
		}
		guard length <= 42 else {
			printg("Pokeface crop currently doesn't work for increased lengths. Needs more research.")
			return
		}
		let pokeFaceCropLengthRAMOffsets = [
			0x111352,
			0x111386,
			0x11138e,
			0x1113ba,
			0x1113c2,

			0x1115fa,
			0x11162e,
			0x111636,
			0x111656,
			0x111662
		]

		if let dol = XGFiles.dol.data {
			pokeFaceCropLengthRAMOffsets.forEach { (offset) in
				dol.replace2BytesAtOffset(offset - kDolToRAMOffsetDifference, withBytes: length)
			}
			dol.save()
		}
	}

	class func setAllBattlesTo(_ style: XGBattleStyles) {
		let battleStyle: XGBattleStyles = style == .single ? .single : .double
		XGBattle.allValues.forEach { (battle) in
			#if GAME_XD
			guard battle.p2Trainer?.deck != .DeckVirtual, battle.p2Trainer?.deck != .DeckBingo else {
				return
			}
			#endif
			battle.battleStyle = battleStyle
			battle.save()
		}
	}

	class func disableCStickMovement() {
		// Allows the CStick's functionality to be repurposed
		guard game == .XD else {
			printg("This patch is for Pokemon XD: Gale of Darkness only.")
			return
		}

		guard region == .US else {
			printg("This patch has not been implemented for this game region:", region.name)
			return
		}

		let cstickRAMOffsets = [
			0x14e930, // overworld
			0x14e95c, // overworld
			0x14e988,
			0x14e9b4,
//			0x10fef8, // menus
//			0x10fee8  // menus
		]
		for offset in cstickRAMOffsets {
			XGAssembly.replaceRamASM(RAMOffset: offset, newASM: [
				.li(.r3, 0)
			])
		}
	}

	class func unlockColbtlBin() {
		guard game == .Colosseum else {
			printg("This patch hasn't been implemented for Pokemon XD yet")
			return
		}

		// The game expects the GBA ROM to have a certain string to show it's the correct region
		// It expects US/PAL carts to have AXVE (this is the US id for Ruby but is used for all games)
		// Expects AXVJ for JP ROMs
		// This value isn't the one in the header of the GBA ROM, it's a separated instance further in
		// It's possible to edit the string in the GBA ROM to match but here we'll just
		// disable the check altogether so it will ignore the region. The injected ROM for trading
		// checks that the regions match anyway
		let regionStringCheckRAMOffset: Int
		if game == .Colosseum {
			switch region {
			case .US: regionStringCheckRAMOffset = 0x7448c
			case .EU: regionStringCheckRAMOffset = 0x77990
			case .JP: regionStringCheckRAMOffset = 0x735b0
			case .OtherGame: regionStringCheckRAMOffset = -1
			}
		} else {
			switch region {
			case .US: regionStringCheckRAMOffset = 0x0
			case .EU: regionStringCheckRAMOffset = 0x0
			case .JP: regionStringCheckRAMOffset = 0x0
			case .OtherGame: regionStringCheckRAMOffset = -1
			}
		}
		XGAssembly.replaceRamASM(RAMOffset: regionStringCheckRAMOffset, newASM: [.b_f(0, 12)])

		// I'm not sure where this value gets set but at a certain point when the game is verifying
		// that all the regions match up it expects a certain value to be read from somewhere
		// Hardcoding this value seems to be fine though it means if the region is incorrect then
		// the game still attempts to open up the trade window and doesn't load anything from the GBA ROM
		// To prevent this we could hardcode the previous region string check to only accept the region
		// we're changing to
		let validResponseHardcodeRAMOffset: Int
		if game == .Colosseum {
			switch region {
			case .US: validResponseHardcodeRAMOffset = 0x939dc
			case .EU: validResponseHardcodeRAMOffset = 0x96f00
			case .JP: validResponseHardcodeRAMOffset = 0x9169c
			case .OtherGame: validResponseHardcodeRAMOffset = -1
			}
		} else {
			switch region {
			case .US: validResponseHardcodeRAMOffset = 0x0
			case .EU: validResponseHardcodeRAMOffset = 0x0
			case .JP: validResponseHardcodeRAMOffset = 0x0
			case .OtherGame: validResponseHardcodeRAMOffset = -1
			}
		}
		XGAssembly.replaceRamASM(RAMOffset: validResponseHardcodeRAMOffset, newASM: [.li(.r6, 0x23)])
	}

	// The game will check this many entries for a match in the pokespot table
	// when generating the battle for the encounter. It stops as soon as it finds
	// a match so it's fine to make this number really large as long as we don't
	// change the spawns at run time.
	static func setMaxPokespotEntriesPerSpot(to count: Int) {
		guard game == .XD else {
			printg("Couldn't apply patch. Pokespots are only in XD.")
				return
		}
		guard region == .US else {
			printg("Pokespot max entries patch is currently not available for this region:", region.name)
			return
		}
		let offset: Int
		switch region {
		case .US: offset = 0x1faf52
		case .EU: offset = -1
		case .JP: offset = -1
		case .OtherGame: offset = -1
		}
		if let dol = XGFiles.dol.data {
			dol.replace2BytesAtOffset(offset - kDolToRAMOffsetDifference, withBytes: count)
		}
	}
	
	static func preventPokemonRelease() {
		guard game == .XD else {
			printg("Patch not implemented for this game:", game.name)
				return
		}
		guard region == .US else {
			printg("Patch is currently not available for this region:", region.name)
			return
		}
		let offset: Int
		switch region {
		case .US: offset = 0x8005aa38
		case .EU: offset = -1
		case .JP: offset = -1
		case .OtherGame: offset = -1
		}
		
		XGAssembly.replaceRamASM(RAMOffset: offset, newASM: [.li(.r0, 0)])
	}
	
	static func completeStrategyMemo() {
		guard game == .XD else {
			printg("Patch not implemented for this game:", game.name)
				return
		}
		guard region == .US else {
			printg("Patch is currently not available for this region:", region.name)
			return
		}
		
		let getPokemonIDAtIndexFunctionRAMOffset = 0x80234b0c
		XGAssembly.replaceRamASM(RAMOffset: getPokemonIDAtIndexFunctionRAMOffset, newASM: [
			.addi(.r3, .r4, 1),
			.blr
		])

		let getPokemonCountFunctionRAMOffset = 0x80234b6c
		XGAssembly.replaceRamASM(RAMOffset: getPokemonCountFunctionRAMOffset, newASM: [
			.li(.r3, 0x19e),
			.blr
		])


		let getPokemonPIDFunctionRAMOffset = 0x80234a64
		XGAssembly.replaceRamASM(RAMOffset: getPokemonPIDFunctionRAMOffset, newASM: [
			.li(.r3, 0),
			.blr
		])


		let getPokemonTIDFunctionRAMOffset = 0x802349bc
		XGAssembly.replaceRamASM(RAMOffset: getPokemonTIDFunctionRAMOffset, newASM: [
			.li(.r3, 0),
			.blr
		])

		// Must disable sort as it isn't coded in a way that works with more than the default number of pokemon
		// Likely not allocating enough memory for the sort
		let memoSortFunctionRAMOffset = 0x80055948
		XGAssembly.replaceRamASM(RAMOffset: memoSortFunctionRAMOffset, newASM: [
			.blr
		])
	}
	
	static func addSoftReset() {
		guard game == .Colosseum else {
			printg("Patch not implemented for this game:", game.name)
			return
		}
		
		let resetBranchOffset: Int = {
			switch region {
			case .US: return 0x80005c50
			case .EU: return 0x80005d48
			case .JP: return 0x80005bcc
			case .OtherGame: return -1
			}
		}()
		let asm: ASM = [
			.b_f(0, 0x1c)
		]
		XGAssembly.replaceRamASM(RAMOffset: resetBranchOffset, newASM: asm)
		
		let resetCheckOffset: Int = {
			switch region {
			case .US: return 0x80005c6c
			case .EU: return 0x80005d64
			case .JP: return 0x80005be8
			case .OtherGame: return -1
			}
		}()
		let gsGetInput: Int = {
			switch region {
			case .US: return 0x800f7bc4
			case .EU: return 0x800fb244
			case .JP: return 0x800f588c
			case .OtherGame: return -1
			}
		}()
		let asm2: ASM = [
			.li(.r3, 1),
			.bl(gsGetInput),
			.andi_(.r0, .r3, 0x1600),
			.cmpwi(.r0, 0x1600),
			.nop
		]
		XGAssembly.replaceRamASM(RAMOffset: resetCheckOffset, newASM: asm2)
	}
	
	static func pressButtonCombinationToGoToPC(_ buttonCombination: [ControllerButtons]) {
		guard game == .Colosseum else {
			printg("Patch not implemented for this game:", game.name)
			return
		}
		guard !buttonCombination.isEmpty, let freeSpace = XGAssembly.ASMfreeSpaceRAMPointer() else {
			return
		}
		let buttonMask = buttonCombination.map(\.rawValue).reduce(0, |)
		
		let processEventsInjectionOffset: Int = {
			switch region {
			case .US: return 0x8012eda8
			case .EU: return 0x80132fd4
			case .JP: return 0x8012c4e4
			default: return -1
			}
		}()
		let runScriptAddress: Int = {
			switch region {
			case .US: return 0x8012bad0
			case .EU: return 0x8012fcfc
			case .JP: return 0x8012920c
			default: return -1
			}
		}()
		let gsGetInput: Int = {
			switch region {
			case .US: return 0x800f7bc4
			case .EU: return 0x800fb244
			case .JP: return 0x800f588c
			default: return -1
			}
		}()
		let getCurrentRoomID: Int = {
			switch region {
			case .US: return 0x800ff56c
			case .EU: return 0x80102a80
			case .JP: return 0x800fcf5c
			default: return -1
			}
		}()
		let asm: ASM = [
			.bl(gsGetInput),
			.mr(.r31, .r3),
			.cmpwi(.r3, buttonMask),
			.bne_f(0, 8),
			.b(freeSpace),
			.rlwinm_(.r0, .r31, 0, 19, 21),
		]
		XGAssembly.replaceRamASM(RAMOffset: processEventsInjectionOffset, newASM: asm)

		let lastWarpPointAddress: UInt32 = {
			switch region {
			case .US: return 0x80408378
			case .EU: return 0x804557f8
			case .JP: return 0x803f4A38
			default: return 0x0
			}
		}()
		
		let loadLastWarpPointInstructions = XGASM.loadImmediateShifted32bit(register: .r5, value: lastWarpPointAddress)
		let asm2: ASM = [
			.bl(getCurrentRoomID),
			.mr(.r4, .r3),
			// get most recent warp point
			loadLastWarpPointInstructions.0,
			loadLastWarpPointInstructions.1,
			.lwz(.r5, .r5, 0xc),
			.li(.r6, 0),
			.li(.r7, 0),
			.lis(.r3, 0x596),
			.addi(.r3, .r3, 13),
			.bl(runScriptAddress),
			.b(processEventsInjectionOffset + 0x14)
		]
		XGAssembly.replaceRamASM(RAMOffset: freeSpace, newASM: asm2)
	}
	
	static func removeShinyLocks() {
		if game == .Colosseum {
			let espeon = XGDemoStarterPokemon(index: 0)
			espeon.shinyValue = .random
			espeon.save()
			let umbreon = XGDemoStarterPokemon(index: 1)
			umbreon.shinyValue = .random
			umbreon.save()
			let plusle = CMGiftPokemon(index: 0)
			plusle.shinyValue = .random
			plusle.save()
			let hooh = CMGiftPokemon(index: 1)
			hooh.shinyValue = .random
			hooh.save()
			let celebi = CMGiftPokemon(index: 2)
			celebi.shinyValue = .random
			celebi.save()
			let pikachu = CMGiftPokemon(index: 3)
			pikachu.shinyValue = .random
			pikachu.save()
		}
	}
	
	static func disableBattleAnimations() {
		guard game == .XD else {
			printg("Patch not implemented for this game:", game.name)
			return
		}
		guard region == .US else {
			printg("Patch not implemented for this game region:", region.name)
			return
		}
		if game == .XD {
			let offset: Int = {
				switch region {
				case .US:
					return 0x80205eb4
				case .EU:
					return 0
				case .JP:
					return 0
				case .OtherGame:
					return 0
				}
			}()
			XGAssembly.replaceRamASM(RAMOffset: offset, newASM: [.nop])
		}
	}
	
	class func expAll() {
		guard game == .XD else {
			printg("Patch not implemented for this game:", game.name)
			return
		}
		guard region == .US else {
			printg("Patch not implemented for this game region:", region.name)
			return
		}

		// skip exp split
		let expSplitRAMOffset = 0x80212c94
		XGAssembly.replaceRamASM(RAMOffset: expSplitRAMOffset, newASM: [
			.nop,
			.rlwinm(.r3, .r0, 31, 17, 31),
			.mr(.r0, .r3)
		])

		// skip battle participation check
		let expParticipationRAMOffset = 0x80212dec
		XGAssembly.replaceRamASM(RAMOffset: expParticipationRAMOffset, newASM: [
			.nop
		])

		// skip exp gain messages
		let expGainRAMOffset = 0x80212f6c
		XGAssembly.replaceRamASM(RAMOffset: expGainRAMOffset, newASM: [
			.nop,
			.mr(.r27, .r3),
			.nop
		])
	}
		
	class func applyPatch(_ patch: XGDolPatches) {
		
		switch patch {
		case .freeSpaceInDol				: XGPatcher.clearUnusedFunctionsInDol()
		case .betaStartersApply				: XGPatcher.enableBetaStarters()
		case .betaStartersRemove			: XGPatcher.disableBetaStarters()
		case .physicalSpecialSplitApply		: XGPatcher.applyPhysicalSpecialSplitPatch(setDefaultMoveCategories: true)
		case .physicalSpecialSplitRemove	: XGPatcher.removePhysicalSpecialSplitPatch()
		case .renameAllPokemonApply			: XGPatcher.allowRenamingAnyPokemon()
		case .shinyChanceEditingApply		: XGPatcher.removeShinyGlitch()
		case .shinyChanceEditingRemove		: XGPatcher.replaceShinyGlitch()
		case .type9IndependentApply			: XGPatcher.removeType9Dependencies() // xd
		case .noTypeIconForLockedMoves		: XGPatcher.removeType9Dependencies() // colo
		case .purgeUnusedText				: XGPatcher.purgeUnusedText()
		case .decapitaliseNames				: XGPatcher.decapitalise()
		case .tradeEvolutions				: XGPatcher.removeTradeEvolutions()
		case .removeItemEvolutions			: XGPatcher.removeItemEvolutions()
		case .defaultMoveCategories			: XGUtility.defaultMoveCategories()
		case .allowFemaleStarters			: XGPatcher.allowFemaleStarters()
		case .switchPokemonAtEndOfTurn		: XGAssembly.switchNextPokemonAtEndOfTurn()
		case .fixShinyGlitch				: XGPatcher.removeShinyGlitch()
		case .replaceShinyGlitch			: XGPatcher.replaceShinyGlitch()
		case .infiniteTMs					: XGAssembly.infiniteUseTMs()
		case .allowShinyStarters			: XGPatcher.setStarterShininess(to: .random)
		case .shinyLockStarters				: XGPatcher.setStarterShininess(to: .never)
		case .alwaysShinyStarters			: XGPatcher.setStarterShininess(to: .always)
		case .allowShinyShadowPokemon		: XGPatcher.setShadowPokemonShininess(to: .random)
		case .shinyLockShadowPokemon		: XGPatcher.setShadowPokemonShininess(to: .never)
		case .alwaysShinyShadowPokemon		: XGPatcher.setShadowPokemonShininess(to: .always)
		case .enableDebugLogs				: XGPatcher.enableDebugLogs()
		case .pokemonCanLearnAnyTM			: XGPatcher.pokemonCanLearnAnyTM()
		case .pokemonHaveMaxCatchRate		: XGPatcher.pokemonHaveMaxCatchRate()
		case .removeEVCap					: XGPatcher.removeEVCap()
		case .gen6CritMultipliers			: XGPatcher.gen6CritMultipliers()
		case .gen7CritRatios				: XGPatcher.gen7CritRatios()
		case .allDoubleBattles				: XGPatcher.setAllBattlesTo(.double)
		case .allSingleBattles				: XGPatcher.setAllBattlesTo(.single)
		case .deleteUnusedFiles				: XGPatcher.deleteUnusedFiles()
		case .removeColbtlRegionLock		: XGPatcher.unlockColbtlBin()
		case .disableSaveCorruption			: XGPatcher.preventSaveFileCorruption()
		case .maxPokespotEntries			: XGPatcher.setMaxPokespotEntriesPerSpot(to: 100)
		case .preventPokemonRelease			: XGPatcher.preventPokemonRelease()
		case .completeStrategyMemo			: XGPatcher.completeStrategyMemo()
		case .addSoftReset					: XGPatcher.addSoftReset()
		case .loadPCFromAnywhere			: XGPatcher.pressButtonCombinationToGoToPC([.R])
		case .removeShinyLocksFromGiftPokemon : XGPatcher.removeShinyLocks()
		case .disableBattleAnimations		: XGPatcher.disableBattleAnimations()
		case .expAll						: XGPatcher.expAll()
		}
		
		printg("patch applied: ", patch.name, "\nDon't forget to rebuild the ISO after.")
		
	}
	
	
}



















