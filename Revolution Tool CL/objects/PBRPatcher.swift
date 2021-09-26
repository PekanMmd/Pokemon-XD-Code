//
//  PBRPatcher.swift
//  GoD Tool
//
//  Created by Stars Momodu on 11/07/2020.
//

import Foundation

let patches: [XGDolPatches] = [
	.freeSpaceInDol,
	.gen7CritRatios,
	.disableRentalPassChecksums,
	.disableBlurEffect,
	.add1PokemonEntry,
	.add10PokemonEntries,
	.add100PokemonEntries
]

enum XGDolPatches: Int {

	case freeSpaceInDol
	case gen7CritRatios
	case gen6CriticalHitMultipliers
	case disableRentalPassChecksums
	case disableBlurEffect
	case unlockSaveFileBoxes
	case moveTypeMatchupsTable
	case add1PokemonEntry
	case add10PokemonEntries
	case add100PokemonEntries

	var name: String {
		switch self {
		case .unlockSaveFileBoxes: return "Unlock save file. Links a DS to the save file which lets you use pokemon in your box to create battle passes."
		case .freeSpaceInDol: return "Create some space in \(XGFiles.dol.fileName) which van be used for adding new assembly assembly instructions."
		case .gen7CritRatios: return "Update the critical hit ratios to gen 7 odds"
		case .gen6CriticalHitMultipliers: return "Critical hits deal 1.5x damage, 2.25x with Sniper"
		case .disableRentalPassChecksums: return "Disable legality checks on battle passes"
		case .disableBlurEffect: return "Remove the blur effect from the games rendering"
		case .moveTypeMatchupsTable: return "Move type matchups table to a large area so more matchups can be added. The tool does this automatically when editing type matchups."
		case .add1PokemonEntry: return "Add 1 extra pokemon slot to the game"
		case .add10PokemonEntries: return "Add 10 extra pokemon slots to the game"
		case .add100PokemonEntries: return "Add 100 extra pokemon slots to the game"
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

	/// Removes the code for rental pass validation checks
	/// allowing the space to be reused for the type matchups table
	static func moveTypeMatchupsTableToPassValidationFunction() {
		let rentalPassStartOffset: Int
		switch region {
		case .EU: rentalPassStartOffset = 0x1317cc - kDolToRAMOffsetDifference
		case .JP: rentalPassStartOffset = -1
		case .US: rentalPassStartOffset = -1
		case .OtherGame: rentalPassStartOffset = -1
		}
		guard PBRTypeManager.typeMatchupDataDolOffset != rentalPassStartOffset + 8 else {
			// already been moved
			return
		}
		guard region == .EU else {
			printg("Couldn't move type match ups table. Not implemented for region: \(region.name)")
			return
		}

		// rental pass validation checks just pass immediately
		XGAssembly.replaceASM(startOffset: rentalPassStartOffset, newASM: [
			.li(.r3, 1),
			.blr
		])

		let newEntriesCount = 0x84 // The number of type matchup entries that can fit in this function after stubbing it out
		PBRTypeManager.moveTypeMatchupTableToDolOffset(rentalPassStartOffset + 8, newEntryCount: newEntriesCount)
	}

	static func gen7CritRatios() {
		let critRatiosStartOffset: Int
		switch region {
		case .US: critRatiosStartOffset = 0x44AAF0
		case .JP: critRatiosStartOffset = 0x4359F0
		case .EU: critRatiosStartOffset = 0x475010
		case .OtherGame: critRatiosStartOffset = 0
		}

		let dol = XGFiles.dol.data!
		dol.replaceBytesFromOffset(critRatiosStartOffset, withByteStream: [24,8,2,1,1])
		dol.save()
	}

	static func disableRentalPassChecksums() {
		printg("Disabling rental pass checksums")
		guard region == .EU else {
			printg("Couldn't disable rental pass checksums. Not implemented for region: \(region.name)")
			return
		}
		XGAssembly.replaceASM(startOffset: 0x3DAF40 - kDolToRAMOffsetDifference, newASM: [
			.b_f(0, 0x2c)
		])
		XGAssembly.replaceASM(startOffset: 0x3dda20 - kDolToRAMOffsetDifference, newASM: [
			.b_f(0, 0x2c)
		])

		XGAssembly.replaceASM(startOffset: 0x3de140 - kDolToRAMOffsetDifference, newASM: [
			.b_f(0, 0x24)
		])

		XGAssembly.replaceASM(startOffset: 0x3db6bc - kDolToRAMOffsetDifference, newASM: [
			.b_f(0, 0x30)
		])

		XGAssembly.replaceASM(startOffset: 0x3db568 - kDolToRAMOffsetDifference, newASM: [
			.b_f(0, 0x30)
		])

		XGAssembly.replaceASM(startOffset: 0x3DA370 - kDolToRAMOffsetDifference, newASM: [
			.li(.r3, 0)
		])
	}

	static func gen6CriticalHitMultipliers() {
		guard region == .EU else {
			printg("This patch hasn't been implemented for this region yet:", region.name)
			return
		}
		let damageMultipliersOffset: Int
		switch region {
		case .US: damageMultipliersOffset = -1
		case .EU: damageMultipliersOffset = 0x3c85f4
		case .JP: damageMultipliersOffset = -1
		case .OtherGame: damageMultipliersOffset = -1
		}

		// These values have to be whole numbers so we will have to divide the damage by 4 after the multipliers are applied
		// In order to get the proper 1.5x and 2.25x multipliers
		XGAssembly.replaceRamASM(RAMOffset: damageMultipliersOffset, newASM: [
			.li(.r30, 6), // regular crit multiplier
			.cmpwi(.r30, 6),
		])
		XGAssembly.replaceRamASM(RAMOffset: damageMultipliersOffset + 0x24, newASM: [
			.li(.r30, 9) // sniper crit multiplier
		])

		let damageCalcOffset: Int
		let calcDamageBoostFunctionOffset: Int
		switch region {
		case .US:
			damageCalcOffset = -1
			calcDamageBoostFunctionOffset = -1
		case .EU:
			damageCalcOffset = 0x3cad5c
			calcDamageBoostFunctionOffset = 0x3c6178
		case .JP:
			damageCalcOffset = -1
			calcDamageBoostFunctionOffset = -1
		case .OtherGame:
			damageCalcOffset = -1
			calcDamageBoostFunctionOffset = -1
		}

		// Rewrite the assembly to be more concise so we can squeeze in 2 extra instructions for dividing the
		// multiplied value by 4
		XGAssembly.replaceRamASM(RAMOffset: damageCalcOffset, newASM: [
			// shortened code
			.rlwinm(.r3, .r3, 2, 22, 29),
			.stw(.r30, .sp, 8),
			.add(.r7, .r31, .r3),
			.mr(.r3, .r28),
			.mr(.r4, .r31),
			.lwz(.r0, .r31, 0x2150),
			.stw(.r0, .sp, 12),
			.rlwinm(.r9, .r29, 0, 24, 31),

			.lwz(.r8, .r31, 0x2154),
			.lwz(.r10, .r31, 0x64),
			.lwz(.r6, .r7, 0x01BC),
			.lwz(.r5, .r31, 0x3044),
			.lwz(.r7, .r31, 0x0180),
			.bl(calcDamageBoostFunctionOffset),

			// updated code for crit multipliers
			.lwz(.r0, .r31, 0x2150), // get crit multiplier
			.cmpwi(.r0, 1),
			.mullw(.r0, .r3, .r0), // multiply damage by our updated multipliers
			.beq_l("end of crit multiplier"),
			.li(.r4, 4),
			.divw(.r0, .r0, .r4), // divided result by 4

			.label("end of crit multiplier"),
			.stw(.r0, .r31, 0x2144), // store damage

			// rearranged code. moved these instructions just for readability
			.mr(.r3, .r31),
			.lwz(.r4, .r31, 0x64)
		])
	}

	static func overrideHardcodedPokemonCount(newCount count: Int) {
		guard region == .EU else {
			printg("Couldn't override hard coded pokemon count for game region \(region.name)")
			return
		}
		XGAssembly.replaceASM(startOffset: 0x56c0c - kDolToRAMOffsetDifference, newASM: [.cmpwi(.r0, count)])

		for offset in [0x5b704 , 0x5b9b4 , 0x5c09c , 0x5c348] {
			XGAssembly.replaceASM(startOffset: offset - kDolToRAMOffsetDifference, newASM: [.cmpwi(.r4, count)])
		}
	}

	static func isClassSplitImplemented() -> Bool {
		// for colo/xd compatibility
		return true
	}

	static func disableBlurEffect() {
		let bloomStrengthOffset: Int
		switch region {
		case .EU: bloomStrengthOffset = 0x473ea8
		case .US: bloomStrengthOffset = 0x449990
		case .JP: bloomStrengthOffset = 0x434910
		case .OtherGame: bloomStrengthOffset = 0
		}
		if let dol = XGFiles.dol.data {
			dol.replace4BytesAtOffset(bloomStrengthOffset, withBytes: 0)
			dol.save()
		}
	}

	static func hidePlayer2TeamPreview() {
		let nopRAMAddresses = [
			0x80154a48,
			0x80154a5c,
			0x80154a70,
			0x80154a84,
			0x80154a98,
			0x80154aac,
			0x80154ad4,
			0x80154ae8,
			0x80154b10,
			0x80154b24,
			0x80154b4c,
			0x80154b60,
			0x80154b88,
			0x80154b9c,
			0x80154bc4,
			0x80154bd8,
			0x80154c00,
			0x80154c14,
			0x80154c30,
			0x80154c4c,
			0x80154c68,
			0x80154c84,
			0x80154ca0,
			0x80154cbc,
			0x80154844,
			0x8015485c,
			0x80154874,
			0x8015488c,
			0x801548a4,
			0x801548bc
		]

		for address in nopRAMAddresses {
			XGAssembly.replaceRamASM(RAMOffset: address & 0xFFFFFF, newASM: [.nop])
		}
	}

	static func unlockSaveFile() {
		guard environment == .Windows else {
			printg("The save file decrypting tool is only available on Windows.")
			return
		}

		XGFolders.setUpFolderFormat()
		guard XGFiles.saveData.exists else {
			printg("Please place your save file at \(XGFiles.saveData.path) then try again.")
			return
		}
		printg("Decrypting save file \(XGFiles.saveData.path) using PbrSaveTool")
		GoDShellManager.run(.pbrSaveTool, inputRedirectFile: .nameAndFolder("pbrsavetool_decrypt", .Resources))
		guard XGFiles.decryptedSaveData.exists, let saveData = XGFiles.decryptedSaveData.data else {
			printg("Couldn't load decrypted save at \(XGFiles.decryptedSaveData.path)")
			return
		}

		printg("Linking a random DS TID and SID to the save file.")
		// SID and TID are randomly generated so we can put any non zero value here
		saveData.replaceByteAtOffset(0x12860, withByte: 1) // TID second byte
		saveData.replaceByteAtOffset(0x12865, withByte: 1) // SID second byte
		saveData.replaceByteAtOffset(0x12866, withByte: 1) // SID first byte
		saveData.replaceByteAtOffset(0x12867, withByte: 1) // TID first byte
		saveData.save()

		printg("Encrypting save file \(XGFiles.saveData.path) using PbrSaveTool")
		GoDShellManager.run(.pbrSaveTool, inputRedirectFile: .nameAndFolder("pbrsavetool_encrypt", .Resources))
		printg("Done.")
	}

	static func increasePokemonTotal(by increase: Int) {
		guard region != .JP else {
			printg("Increasing the number of pokemon hasn't been implemented for \(region.name) yet")
			return
		}
		printg("Increasing number of pokemon in game by \(increase).\nThis may take a while...")
		// Expand pokemon tables
		// Edit these parameters as required ----
		let numberOfEntriesToAdd = increase
		let copyMon = pokemon("omanyte")
		let newSpeciesIndexesWithGenderDifferences: [Int] = [] // needs some work before these are usable
		// --------------------------------------

		let icons = GoDDataTable.pokemonIcons
		let models = GoDDataTable.pokemonModels
		let baseStats = GoDDataTable.pokemonBaseStats
		let bodies = GoDDataTable.pokemonBodies
		let faces = GoDDataTable.pokemonFaces
		let levelUpMoves = GoDDataTable.levelUpMoves
		let evolutions = GoDDataTable.evolutions
		let menu_face = XGFiles.fsys("menu_face").fsysData
		let menu_pokemon = XGFiles.fsys("menu_pokemon").fsysData

		let copyFsys = XGFiles.fsys("pkx_\(String(format: "%03d", copyMon.baseIndex))").data!
		let copyMonStats = baseStats.entryWithIndex(copyMon.index)!.data
		let copyMonIconsIndex = copyMon.stats.facesEntry.getShort(4)
		let copyMonIcons = icons.entryWithIndex(copyMonIconsIndex)!.data
		let copyMonModels = models.entryWithIndex(copyMon.stats.firstModelIndex)!.data
		let copyMonFaces = faces.entryWithIndex(copyMon.baseIndex)!.data
		let copyMonBodies = bodies.entryWithIndex(copyMon.baseIndex)!.data
		let copyMonMoves = levelUpMoves.entryWithIndex(copyMon.index)!.data
		let copyMonEvos = evolutions.entryWithIndex(copyMon.index)!.data

		let copyMonFaceIndex = menu_face.indexForIdentifier(identifier: copyMonIcons.get4BytesAtOffset(0))!
		let faceImage = XGFiles.indexAndFsysName(copyMonFaceIndex, "menu_face").data!
		faceImage.file = .nameAndFsysName("(null)", "menu_face")
		let copyMonBodyIndex = menu_face.indexForIdentifier(identifier: copyMonIcons.get4BytesAtOffset(0))!
		let bodyImage = XGFiles.indexAndFsysName(copyMonBodyIndex, "menu_pokemon").data!
		bodyImage.file = .nameAndFsysName("(null)", "menu_pokemon")

		let oldTotal = baseStats.numberOfEntries
		let firstNewIndex = oldTotal - 7 // keep egg, bad egg, wormadam and deoxys stats at the end of the table

		if !GSFsys.shared.entries.contains(where: { (entry) -> Bool in
			return entry.name == "pkx_egg.fsys"
		}) {
			let oldEggFile = XGFiles.nameAndFolder("pkx_600.fsys", .ISOFiles)
			let oldSubstituteFile = XGFiles.nameAndFolder("pkx_601.fsys", .ISOFiles)
			oldEggFile.rename("pkx_egg.fsys")
			oldSubstituteFile.rename("pkx_sub.fsys")
			GSFsys.shared.renameEntry(withName: "pkx_600.fsys", to: "pkx_egg.fsys")
			GSFsys.shared.renameEntry(withName: "pkx_601.fsys", to: "pkx_sub.fsys")
			GSFsys.shared.data().save()
		}

		for i in 0 ..< numberOfEntriesToAdd {
			guard let modelFsysID = GSFsys.shared.nextFreeFsysID() else {
				printg("Couldn't add model file for pokemon with id \(oldTotal + i)")
				continue
			}

			let newSpeciesIndex = firstNewIndex + i
			let hasGenderDifferences = newSpeciesIndexesWithGenderDifferences.contains(newSpeciesIndex)
			let newModelIndex = models.numberOfEntries
			let newIconsIndex = icons.numberOfEntries

			let newMonIcons = copyMonIcons.duplicated()
			let newFaceID = (newSpeciesIndex * 2) + 0x7800
			let newBodyID = (newSpeciesIndex * 2) + 0x6800

			menu_face.addFile(faceImage, fileType: .gtx, compress: true, shortID: newFaceID)
			newMonIcons.replace2BytesAtOffset(0, withBytes: newFaceID)
			if hasGenderDifferences {
				menu_face.addFile(faceImage, fileType: .gtx, compress: true, shortID: newFaceID + 1)
				newMonIcons.replace2BytesAtOffset(8, withBytes: newFaceID + 1)
			} else {
				newMonIcons.replace2BytesAtOffset(8, withBytes: newFaceID)
			}

			menu_pokemon.addFile(bodyImage, fileType: .gtx, compress: true, shortID: newBodyID)
			newMonIcons.replace2BytesAtOffset(4, withBytes: newBodyID)
			if hasGenderDifferences {
				menu_pokemon.addFile(bodyImage, fileType: .gtx, compress: true, shortID: newBodyID + 1)
				newMonIcons.replace2BytesAtOffset(12, withBytes: newBodyID + 1)
			} else {
				newMonIcons.replace2BytesAtOffset(12, withBytes: newBodyID)
			}

			let modelRegularID = 0x7000 + (newSpeciesIndex * 2)
			let modelShinyID = 0x6000 + (newSpeciesIndex * 2)

			let newMonModels = copyMonModels.duplicated()
			newMonModels.replace2BytesAtOffset(6, withBytes: modelFsysID)
			newMonModels.replace2BytesAtOffset(8, withBytes: modelRegularID)
			newMonModels.replace2BytesAtOffset(12, withBytes: modelShinyID)
			newMonModels.replace2BytesAtOffset(20, withBytes: newSpeciesIndex)
			models.addEntry(data: newMonModels)

			copyFsys.file = .fsys("pkx_\(newSpeciesIndex)" + (hasGenderDifferences ? "_m" : ""))
			let newFsys = XGFsys(data: copyFsys)
			newFsys.setIdentifier(modelRegularID, fileType: .sdr, forFileWithIndex: 0)
			newFsys.setIdentifier(modelShinyID, fileType: .sdr, forFileWithIndex: 1)
			XGISO.current.addFile(newFsys.data, fsysID: modelFsysID)

			if hasGenderDifferences {
				let newMonModels = copyMonModels.duplicated()
				newMonModels.replaceByteAtOffset(0, withByte: newMonModels.getByteAtOffset(0) + 0x4) // This flag is set on all female variants
				newMonModels.replace2BytesAtOffset(6, withBytes: modelFsysID + 1)
				newMonModels.replace2BytesAtOffset(8, withBytes: modelRegularID + 1)
				newMonModels.replace2BytesAtOffset(12, withBytes: modelShinyID + 1)
				newMonModels.replace2BytesAtOffset(20, withBytes: newSpeciesIndex)
				models.addEntry(data: newMonModels)

				copyFsys.file = .fsys("pkx_\(newSpeciesIndex)_f")
				let newFsys = XGFsys(data: copyFsys)
				newFsys.setIdentifier(modelRegularID + 1, fileType: .sdr, forFileWithIndex: 0)
				newFsys.setIdentifier(modelShinyID + 1, fileType: .sdr, forFileWithIndex: 1)
				XGISO.current.addFile(newFsys.data, fsysID: modelFsysID + 1)
			}

			let newMonStats = copyMonStats.duplicated()
			newMonStats.replace2BytesAtOffset(28, withBytes: newModelIndex)
			if let nameID = PBRStringManager.addString("[0xF001][0xF101]Pokemon\(newSpeciesIndex)") {
				newMonStats.replace2BytesAtOffset(24, withBytes: nameID)
			}

			let newMonFaces = copyMonFaces.duplicated()
			newMonFaces.replace2BytesAtOffset(2, withBytes: newSpeciesIndex)
			newMonFaces.replace2BytesAtOffset(4, withBytes: newIconsIndex)

			let newMonBodies = copyMonBodies.duplicated()
			newMonBodies.replace2BytesAtOffset(2, withBytes: newSpeciesIndex)
			newMonBodies.replace2BytesAtOffset(4, withBytes: newIconsIndex)

			let newMonMoves = copyMonMoves.duplicated()
			let newMonEvos = copyMonEvos.duplicated()

			baseStats.insertEntry(newMonStats, at: newSpeciesIndex)
			levelUpMoves.insertEntry(newMonMoves, at: newSpeciesIndex)
			evolutions.insertEntry(newMonEvos, at: newSpeciesIndex)
			faces.insertEntry(newMonFaces, at: newSpeciesIndex)
			bodies.insertEntry(newMonBodies, at: newSpeciesIndex)
			icons.addEntry(data: newMonIcons)

		}

		printg("Saving updated tables")

		icons.save()
		models.save()
		baseStats.save()
		faces.save()
		bodies.save()
		levelUpMoves.save()
		evolutions.save()
		menu_face.save()
		menu_pokemon.save()
		XGUtility.importFileToISO(menu_face.file, save: false)
		XGUtility.importFileToISO(menu_pokemon.file, save: false)

		printg("Updating game data...")

		// Egg and bad egg data are moved to still at the end of the stats table
		// so update any references to them in the ASM code to the new indexes
		let newEggIndex = firstNewIndex + numberOfEntriesToAdd
		let newBadEggIndex = newEggIndex + 1
		let newLastPokemonIndex = newEggIndex - 1

		if let eggFaces = faces.entryWithIndex(newEggIndex) {
			eggFaces.setWord(0, to: newEggIndex.unsigned)
			eggFaces.save()
		}
		if let eggBodies = bodies.entryWithIndex(newEggIndex) {
			eggBodies.setWord(0, to: newEggIndex.unsigned)
			eggBodies.save()
		}

		if let eggModel = models.entryWithIndex(644) {
			eggModel.setSignedShort(0x14, to: newEggIndex)
			eggModel.save()
		}

		// Edit code for setting pokemon species to eggs or alt forms
		let RAMOffsets493: [Int]
		switch region {
		case .EU:
		RAMOffsets493 = [
			0x012ae6, 0x0143fa, 0x014576, 0x014606, 0x014892, 0x0148d2, 0x0149a6, 0x014a1a, 0x0159d6, 0x015a3e, 0x015aa6, 0x015b0e, 0x015b76, 0x01a6f2, 0x01cc8e, 0x01f4be, 0x01f592, 0x01f666, 0x01f73a, 0x01f80e, 0x01f8e2, 0x01f99e, 0x02142e, 0x02149a, 0x021506, 0x021572, 0x0215de, 0x024762, 0x0247ee, 0x0248ba
		]
		case .US:
			RAMOffsets493 = [
				0x124a2, 0x13e1e, 0x13ff6, 0x14086, 0x14332, 0x14372, 0x1443a, 0x144aa, 0x1560a, 0x15672, 0x156da, 0x15742, 0x157aa, 0x1b93a, 0x1ee36, 0x218c2, 0x219d2, 0x21ae2, 0x21bf2, 0x21d02, 0x21e12, 0x21f0a, 0x23bb6, 0x23c2a, 0x23c9e, 0x23d12, 0x23d86, 0x26f42, 0x26fce, 0x2709a,
	]
		case .JP:
			RAMOffsets493 = []
		default:
			RAMOffsets493 = []
		}

		let RAMOffsets494: [Int]
		switch region {
		case .EU:
			RAMOffsets494 = [
				0x05ca92, 0x05ca96, 0x05cbde, 0x05cc0e, 0x05cdb6, 0x05cc0e, 0x05cd82, 0x05cdb6, 0x0aa152, 0x102452, 0x10254a, 0x3b032a, 0x3b0476, 0x3b057a, 0x3b065e, 0x3b28ca, 0x3b2992, 0x3b2a72, 0x3b5a0a, 0x3b5b02, 0x3b7cca, 0x3b98b2, 0x3b99ae, 0x3b9a1a, 0x3b9af6, 0x3d2396, 0x3d256e, 0x3d29f6, 0x3d4a6a, 0x3d4b66, 0x3d6162, 0x3d61f2, 0x3d6292, 0x3d6d1e, 0x3d6df2, 0x3db0b2, 0x3db0da, 0x3dbe2a, 0x3dce5e
			]
		case .US:
			RAMOffsets494 = [
				0x5e582, 0x5e586, 0x5e6ce, 0x5e6fe, 0x5e8a6, 0x5e6fe, 0x5e872, 0x5e8a6, 0xab4fe, 0x104db6, 0x104eae, 0x3b3a16, 0x3b3b62, 0x3b3c66, 0x3b3d4a, 0x3b5fb6, 0x3b607e, 0x3b615e, 0x3b90ea, 0x3b91e2, 0x3bb38a, 0x3bcf5e, 0x3bd05a, 0x3bd0c6, 0x3bd1a2, 0x3d59f2, 0x3d5bca, 0x3d603e, 0x3d80aa, 0x3d81a6, 0x3d97a2, 0x3d9832, 0x3d98d2, 0x3da35e, 0x3da432, 0x3de6e2, 0x3de70a, 0x3df45a, 0x3e048e,
			]
		case .JP:
			RAMOffsets494 = []
		default:
			RAMOffsets494 = []
		}

		let RAMOffsets495: [Int]
		switch region {
		case .EU:
			RAMOffsets495 = [
				0x056c86, 0x05b7aa, 0x05ba86, 0x05bdbe, 0x05c142, 0x05c416, 0x05c6fa, 0x10244a, 0x102542, 0x3db2c6, 0x3db322
			]
		case .US:
			RAMOffsets495 = [
				0x58ce6, 0x5d29a, 0x5d576, 0x5d8ae, 0x5dc32, 0x5df06, 0x5e1ea, 0x104dae, 0x104ea6, 0x3de8f6, 0x3de952,
			]
		case .JP:
			RAMOffsets495 = []
		default:
			RAMOffsets495 = []
		}

		// 601 is used to reference the substitute doll.
		// These may need to be updated if adding a pokemon with id 601 interferes with substitute logic
		let RAMOffsets601: [Int]
		switch region {
		case .EU:
			RAMOffsets601 = [
				0x0247f6,
				0x0248c2,
				0x16d442, // unsure if sub
				0x16d44a // also unsure
			]
		case .US:
			RAMOffsets601 = [
				0x26fd6, 0x270a2, 0x171db6, 0x171dbe,
			]
		case .JP:
			RAMOffsets601 = []
		default:
			RAMOffsets601 = []
		}

		// Edit code for mapping pokemon species to stats
		// Wormadam and deoxys forms are moved to still be at the end
		// so update the function to set the index to the new indexes
		let firstWormadamInstructionRAMOffset = 0x3dd91a
		let newWormadamShift = newEggIndex + 4
		let firstDeoxysInstructionRAMOffset = 0x3dd902
		let newDeoxysShift = newEggIndex + 1
		let newSubstituteIndex = newEggIndex + 107

		if let dol = XGFiles.dol.data {
			for offset in RAMOffsets493 {
				dol.replace2BytesAtOffset(offset - kDolToRAMOffsetDifference, withBytes: newLastPokemonIndex)
			}
			for offset in RAMOffsets494 {
				dol.replace2BytesAtOffset(offset - kDolToRAMOffsetDifference, withBytes: newEggIndex)
			}
			for offset in RAMOffsets495 {
				dol.replace2BytesAtOffset(offset - kDolToRAMOffsetDifference, withBytes: newBadEggIndex)
			}
//			for offset in RAMOffsets601 {
//				dol.replace2BytesAtOffset(offset - kDolToRAMOffsetDifference, withBytes: newSubstituteIndex)
//			}
			dol.replace2BytesAtOffset(firstWormadamInstructionRAMOffset - kDolToRAMOffsetDifference, withBytes: newWormadamShift)
			dol.replace2BytesAtOffset(firstDeoxysInstructionRAMOffset - kDolToRAMOffsetDifference, withBytes: newDeoxysShift)
			dol.save()
		}

		XGPatcher.overrideHardcodedPokemonCount(newCount: GoDDataTable.pokemonBaseStats.numberOfEntries)
		printg("done")
	}

	class func applyPatch(_ patch: XGDolPatches) {
		switch patch {
		case .unlockSaveFileBoxes: XGPatcher.unlockSaveFile()
		case .freeSpaceInDol: XGPatcher.clearUnusedFunctionsInDol()
		case .gen7CritRatios: XGPatcher.gen7CritRatios()
		case .gen6CriticalHitMultipliers: XGPatcher.gen6CriticalHitMultipliers()
		case .disableRentalPassChecksums: XGPatcher.disableRentalPassChecksums()
		case .disableBlurEffect: XGPatcher.disableBlurEffect()
		case .moveTypeMatchupsTable: XGPatcher.moveTypeMatchupsTableToPassValidationFunction()
		case .add1PokemonEntry: XGPatcher.increasePokemonTotal(by: 1)
		case .add10PokemonEntries: XGPatcher.increasePokemonTotal(by: 10)
		case .add100PokemonEntries: XGPatcher.increasePokemonTotal(by: 100)
		}
	}
}
