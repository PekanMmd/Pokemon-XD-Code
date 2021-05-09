//
//  main.swift
//  Revolution Tool
//
//  Created by The Steez on 24/12/2018.
//

import Foundation

loadISO(exitOnFailure: true)

// Expand pokemon tables
/*
// Edit these parameters as required ----
let numberOfEntriesToAdd = 10
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

	let modelFsysID = 0x7000 + (newSpeciesIndex * 2)
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
let RAMOffsets493 = [
	0x012ae6,
	0x0143fa,
	0x014576,
	0x014606,
	0x014892,
	0x0148d2,
	0x0149a6,
	0x014a1a,
	0x0159d6,
	0x015a3e,
	0x015aa6,
	0x015b0e,
	0x015b76,
	0x01a6f2,
	0x01cc8e,
	0x01f4be,
	0x01f592,
	0x01f666,
	0x01f73a,
	0x01f80e,
	0x01f8e2,
	0x01f99e,
	0x02142e,
	0x02149a,
	0x021506,
	0x021572,
	0x0215de,
	0x024762,
	0x0247ee,
	0x0248ba,

]

let RAMOffsets494 = [
	0x05ca92,
	0x05ca96,
	0x05cbde,
	0x05cc0e,
	0x05cdb6,
	0x05cc0e,
	0x05cd82,
	0x05cdb6,
	0x0aa152,
	0x102452,
	0x10254a,
	0x3b032a,
	0x3b0476,
	0x3b057a,
	0x3b065e,
	0x3b28ca,
	0x3b2992,
	0x3b2a72,
	0x3b5a0a,
	0x3b5b02,
	0x3b7cca,
	0x3b98b2,
	0x3b99ae,
	0x3b9a1a,
	0x3b9af6,
	0x3d2396,
	0x3d256e,
	0x3d29f6,
	0x3d4a6a,
	0x3d4b66,
	0x3d6162,
	0x3d61f2,
	0x3d6292,
	0x3d6d1e,
	0x3d6df2,
	0x3db0b2,
	0x3db0da,
	0x3dbe2a,
	0x3dce5e,
]

let RAMOffsets495 = [
	0x056c86,
	0x05b7aa,
	0x05ba86,
	0x05bdbe,
	0x05c142,
	0x05c416,
	0x05c6fa,
	0x10244a,
	0x102542,
	0x3db2c6,
	0x3db322,
]

// 601 is used to reference the substitute doll.
// These may need to be updated if adding a pokemon with id 601 interferes with substitute logic
let RAMOffsets601 = [
	0x0247f6,
	0x0248c2,
	0x16d442, // unsure if sub
	0x16d44a, // also unsure
]

// Edit code for mapping pokemon species to stats
// Wormadam and deoxys forms are moved to still be at the end
// so update the function to set the index to the new indexes
let firstWormadamInstructionRAMOffset = 0x3dd91a
let newWormadamShift = newEggIndex + 4
let firstDeoxysInstructionRAMOffset = 0x3dd902
let newDeoxysShift = newEggIndex + 1

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
	dol.replace2BytesAtOffset(firstWormadamInstructionRAMOffset - kDolToRAMOffsetDifference, withBytes: newWormadamShift)
	dol.replace2BytesAtOffset(firstDeoxysInstructionRAMOffset - kDolToRAMOffsetDifference, withBytes: newDeoxysShift)
	dol.save()
}*/


//// TODO: Remove this when done testing and then run above code on a clean ISO -----
//(0 ..< 12).forEach { (index) in
//	let rental = XGTrainerPokemon(index: index, file: .indexAndFsysName(33, "deck"))
//	rental.species = .index(492 + (11 - index))
//	rental.save()
//}
////-----

//XGPatcher.overrideHardcodedPokemonCount(newCount: GoDDataTable.pokemonBaseStats.numberOfEntries)
//XGPatcher.disableRentalPassChecksums()
//XGUtility.compileMainFiles()

