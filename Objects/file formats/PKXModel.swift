//
//  PKXModel.swift
//  GoD Tool
//
//  Created by Stars Momodu on 08/04/2021.
//

import Foundation

class PKXModel {

	var data: XGMutableData
	var gameFormat: XGGame {
		return data.getWordAtOffset(0x20) == 0xFFFFFFFF ? .XD : .Colosseum
	}
	var isTrainer: Bool {
		// I've only looked at a few so not sure how accuracte this is
		// I haven't seen a clear pattern for distinguishing the two
		// And it's possible there isn't really a difference
		return data.getByteAtOffset(0x1c) == 0 && data.get4BytesAtOffset(0x14) == 0
	}
	var pokemonSpecies: XGPokemon? {
		// Not all pokemon have this set
		let index = data.get2BytesAtOffset(0x18)
		guard index > 0 else { return nil }
		return .index(index)
	}

	lazy var shinyFilter: (modifiers: (red: Int, green: Int, blue: Int, unused: Int), colour: XGColour) = {
		let shinyStartOffset = game == .XD ? 0x70 : data.length - 0x14
		let mods = data.getWordStreamFromOffset(shinyStartOffset, length: 16).map{$0.int}
		var rawColour = data.getWordAtOffset(shinyStartOffset + 16)
		if game == .Colosseum {
			// ARGB
			rawColour = ((rawColour & 0xFF000000) >> 24) + ((rawColour & 0xFFFFFF) << 8)
		}
		return (
			modifiers: (red: mods[0], green: mods[1], blue: mods[2], unused: 0),
			colour: XGColour(raw: rawColour, format:.RGBA32)
		)
	}()

	lazy var particleData: XGMutableData? = {
		let gpt1Length = data.get4BytesAtOffset(gameFormat == .XD ? 8 : 4)
		guard gpt1Length > 0 else { return nil }
		var datLength = data.get4BytesAtOffset(0)
		while datLength % 0x20 != 0 {
			datLength += 1
		}
		var gpt1Start = gameFormat == .XD ? 0xE60 : 0x40 + datLength

		let gpt1Data = data.getSubDataFromOffset(gpt1Start, length: gpt1Length)
		gpt1Data.file = .nameAndFolder(data.file.fileName + ".gpt1", data.file.folder)
		return gpt1Data
	}()

	lazy var datModel: DATModel = {
		let datLength = data.get4BytesAtOffset(0)
		var gpt1Length = data.get4BytesAtOffset(gameFormat == .XD ? 8 : 4)
		while gpt1Length % 0x20 != 0 {
			gpt1Length += 1
		}
		var datStart = gameFormat == .XD ? 0xE60 + gpt1Length : 0x40

		let datData = data.getSubDataFromOffset(datStart, length: datLength)
		datData.file = .nameAndFolder(data.file.fileName + ".dat", data.file.folder)
		return DATModel(data: datData)
	}()

	lazy var animationsMetaData: [String: Int] = {
		var gpt1Length = data.get4BytesAtOffset(gameFormat == .XD ? 8 : 4)
		while gpt1Length % 0x20 != 0 {
			gpt1Length += 1
		}
		var datLength = data.get4BytesAtOffset(0)
		while datLength % 0x20 != 0 {
			datLength += 1
		}

		let firstMetaDataOffset = gameFormat == .XD ? 0x84 : 0x40 + datLength + gpt1Length
		let kSizeOfAnimationMetaData = 0xD0
		let kAnimationMetaDataAnimationIndexOffset = 0x90
		let names = isTrainer ? pkxMetaDataTrainerAnimationNames : pkxMetaDataPokemonAnimationNames
		var metaData = [String: Int]()
		for i in 0 ..< names.count {
			let offset = firstMetaDataOffset + (i * kSizeOfAnimationMetaData)
			if offset + kSizeOfAnimationMetaData <= data.length {
				metaData[names[i]] = data.getByteAtOffset(offset + kAnimationMetaDataAnimationIndexOffset)
			}
		}
		return metaData
	}()


	convenience init?(file: XGFiles) {
		guard let data = file.data else { return nil }
		self.init(data: data)
	}

	init(data: XGMutableData) {
		self.data = data
	}

	var pkxMetaDataPokemonAnimationNames: [String] {
		if gameFormat == .XD {
			return [
				""
			]
		} else {
			return [
				""
			]
		}
	}

	var pkxMetaDataTrainerAnimationNames: [String] {
		if gameFormat == .XD {
			return [
				"Idle",
				"Pokeball Throw",
				"Victory",
				"Battle Intro",
				"Frustrated",
				"Victory",
				"Unused 1",
				"Unused 2",
				"Unused 3",
				"Unused 4",
				"Defeat",
				"Unused 5",
				"Unused 6",
				"Unused 7",
				"Unused 8",
				"Unused 9",
				"Unused 10",

			]
		} else {
			return [
				"Idle",
				"Pokeball Throw",
				"Victory",
				"Unknown 1",
				"Unknown 2",
				"Victory",
				"Battle Intro",
				"Unused 1",
				"Unused 2",
				"Hit by Shadow Pokemon 1",
				"Hit by Shadow Pokemon 2",
				"Defeat",
				"Unused 3",
				"Unused 4",
				"Unused 5",
				"Unused 6",
				"Unused 7",
				"Unused 8",
			]
		}
	}

}
