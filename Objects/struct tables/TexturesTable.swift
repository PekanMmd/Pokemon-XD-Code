//
//  TexturesTable.swift
//  GoD Tool
//
//  Created by Stars Momodu on 26/03/2021.
//

import Foundation

let textureInfoStruct = GoDStruct(name: "Texture Info", format: [
	.short(name: "Crop X", description: "Crops the image from this X position", type: .uint),
	.short(name: "Crop Y", description: "Crops the image from this Y position", type: .uint),
	.short(name: "Crop Width", description: "Crops the image to this width", type: .uint),
	.short(name: "Crop Height", description: "Crops the image to this height", type: .uint),
	.word(name: "File ID", description: "", type: .fsysFileIdentifier(fsysName: nil))
])

var textureStructMultiLanguage: GoDStruct {
	return GoDStruct(name: "Texture", format: [
		.word(name: "Unknown", description: "", type: .uintHex),
		.word(name: "Unknown 2", description: "", type: .uintHex),
		.subStruct(name: "US UK Info", description: "", property: textureInfoStruct),
		.subStruct(name: "German Info", description: "", property: textureInfoStruct),
		.subStruct(name: "French Info", description: "", property: textureInfoStruct),
		.subStruct(name: "Italian Info", description: "", property: textureInfoStruct),
		.subStruct(name: "Spanish Info", description: "", property: textureInfoStruct),
		.word(name: "Unknown 3", description: "", type: .uintHex)
	])
}

var textureStructSingleLanguage: GoDStruct {
	return GoDStruct(name: "Texture", format: [
		.word(name: "Unknown", description: "", type: .uintHex),
		.word(name: "Unknown 2", description: "", type: .uintHex),
		.subStruct(name: "JP Info", description: "", property: textureInfoStruct),
		.word(name: "Unknown 3", description: "", type: .uintHex)
	])
}

var texturesTable: GoDStructTable {
	#if GAME_XD
	let properties = region == .JP ? textureStructSingleLanguage : textureStructMultiLanguage
	#else
	let properties = region == .EU ? textureStructMultiLanguage : textureStructSingleLanguage
	#endif
	return GoDStructTable(file: .dol, properties: properties) { (file) -> Int in
		if let data = file.data {
			let asmOffset: Int
			#if GAME_XD
			switch region {
			case .US: asmOffset = 0x799c2
			case .EU: asmOffset = 0x7a18e
			case .JP: asmOffset = 0x77d92
			case .OtherGame: asmOffset = -1
			}
			#else
			switch region {
			case .US: asmOffset = 0x5a872
			case .EU: asmOffset = 0x5d04e
			case .JP: asmOffset = 0x59a4e
			case .OtherGame: asmOffset = -1
			}
			#endif
			let upper = data.get2BytesAtOffset(asmOffset)
			let lower = data.getHalfAtOffset(asmOffset + 4).signed()
			let RAMOffset = (upper << 16) + lower
			return RAMOffset - 0x80000000 - kDolTableToRAMOffsetDifference
		}
		return -1
	} numberOfEntriesInFile: { (file) -> Int in
		return game == .XD ? 0x3fb : 0x3da
	} nameForEntry: { (index, data) -> String? in
		if let firstSubTable: GoDStructData = data.get(region == .JP ? "JP Info" : "US UK Info"),
		   let fileIdentifier: Int = firstSubTable.get("File ID"),
		   let fsysData = XGISO.current.getFSYSForIdentifier(id: fileIdentifier.unsigned),
		   let index = fsysData.indexForIdentifier(identifier: fileIdentifier) {
			return fsysData.fileNameForFileWithIndex(index: index)
		}
		return nil
	}
}

let pokeFaceStruct = GoDStruct(name: "Pokeface", format: [
	.byte(name: "Regular or Shiny Image", description: "0x40 to crop for regular image, 0xC0 to crop for shiny image", type: .uintHex),
	.word(name: "Image File ID", description: "", type: .fsysFileIdentifier(fsysName: "Poke_face"))
])

let pokeFacesTable = CommonStructTable(index: .PokefaceTextures, properties: pokeFaceStruct) { (index, data) -> String? in
	let suffix: String
	if let type: Int = data.get("Regular or Shiny Image") {
		switch type {
		case 0x40: suffix = " Regular"
		case 0xC0: suffix = " Shiny"
		default: suffix = ""
		}
	} else {
		suffix = ""
	}
	if let fileID: Int = data.get("Image File ID") {
		return XGFiles.fsys("poke_face").fsysData.fileNameForFileWithIdentifier(fileID)?.appending(suffix)
	}
	return "Pokeface \(index)" + suffix
}
