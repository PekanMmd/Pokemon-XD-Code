//
//  EcardCoder.swift
//  GoD Tool
//
//  Created by Stars Momodu on 23/08/2021.
//

import Foundation
extension Bool {
	var asInt: Int {
		return self ? 1 : 0
	}
}

enum EcardTableSections {
	case MetaData
	case Trainer
	case Pokemon
	case Stadium

	var numberOfEntries: Int {
		switch self {
		case .MetaData: return 1
		case .Trainer: return 9
		case .Pokemon: return 36
		case .Stadium: return 1
		}
	}

	var startOffset: Int {
		switch self {
		case .MetaData: return 0
		case .Trainer: return 940
		case .Pokemon: return 1300
		case .Stadium: return 2812
		}
	}

	var length: Int {
		switch self {
		case .MetaData: return 940
		case .Trainer: return 40
		case .Pokemon: return 42
		case .Stadium: return 36
		}
	}
}

enum EcardFields: Int {
	case CardTypeBattle = 0
	case MetaDataUnknown1 = 1
	case MetaDataUnknown2 = 2
	case MetaDataUnknown3 = 3
	case MetaDataUnknown4 = 4
	case MetaDataUnknown5 = 5
	case MetaDataCardName = 6
	case MetaDataPackID = 7
	case MetaDataUnknown7 = 8
	case MetaDataCardIndex = 9
	case MetaDataEasyDifficultyName = 10
	case MetaDataNormalDifficultyName = 11
	case MetaDataHardDifficultyName = 12
	case MetaDataUnknown9 = 13
	case MetaDataUnknown10 = 14
	case MetaDataUnknown11 = 15
	case MetaDataUnknown12 = 16
	case MetaDataUnknown13 = 17
	case MetaDataUnknown14 = 18
	case MetaDataUnknown15 = 19
	case MetaDataUnknown16 = 20
	case MetaDataUnknown17 = 21
	case MetaDataUnknown18 = 22
	case MetaDataUnknown19 = 23
	case MetaDataUnknown20 = 24
	case MetaDataUnknown21 = 25
	case MetaDataUnknown22 = 26
	case MetaDataUnknown23 = 27
	case MetaDataUnknown24 = 28
	case MetaDataUnknown25 = 29
	case MetaDataUnknown26 = 30
	case MetaDataBonusTrainer1Text1 = 31
	case MetaDataBonusTrainer2Text1 = 32
	case MetaDataBonusTrainer3Text1 = 33
	case MetaDataBonusTrainer1Text2 = 34
	case MetaDataBonusTrainer2Text2 = 35
	case MetaDataBonusTrainer3Text2 = 36
	case MetaDataBonusTrainer1Text3 = 37
	case MetaDataBonusTrainer2Text3 = 38
	case MetaDataBonusTrainer3Text3 = 39
	case TrainerName = 40
	case TrainerGender = 41
	case TrainerPokemonSlot = 42
	case TrainerItem = 43
	case TrainerUnknown = 44
	case TrainerAI = 45
	case TrainerID = 46
	case TrainerModel = 47
	case PokemonSpecies = 48
	case PokemonShadowID = 49
	case PokemonLevel = 50
	case PokemonMove = 51
	case PokemonUnknown = 52
	case PokemonAbilitySlot = 53
	case PokemonIVHP = 54
	case PokemonIVAttack = 55
	case PokemonIVDefense = 56
	case PokemonIVSpatk = 57
	case PokemonIVSpdef = 58
	case PokemonIVSpeed = 59
	case PokemonEVHP = 60
	case PokemonEVAttack = 61
	case PokemonEVDefense = 62
	case PokemonEVSpatk = 63
	case PokemonEVSpdef = 64
	case PokemonEVSpeed = 65
	case PokemonHappiness = 66
	case PokemonGender = 67
	case PokemonNature = 68
	case PokemonUnknown2 = 69
	case PokemonUnknown3 = 70
	case PokemonHeartGauge = 71
	case CardTypeStadium = 72
	case StadiumBattleField = 73
	case StadiumName = 74

	var info: (bits: Int, bytes: Int, arrayCount: Int, relativeOffset: Int, section: EcardTableSections) {
		switch self {
		case .CardTypeBattle: return (4,4,1,0, .MetaData)
		case .CardTypeStadium: return (4,4,1,0, .MetaData)

		case .MetaDataUnknown1: return (3,1,1,4, .MetaData)
		case .MetaDataUnknown2: return (2,1,1,5, .MetaData)
		case .MetaDataUnknown3: return (4,1,1,6, .MetaData)
		case .MetaDataUnknown4: return (4,1,1,7, .MetaData)
		case .MetaDataUnknown5: return (8,1,1,8, .MetaData)
		case .MetaDataCardName: return (192,24,1,10, .MetaData)
		case .MetaDataPackID: return (3,1,1,36, .MetaData)
		case .MetaDataUnknown7: return (3,1,1,37, .MetaData)
		case .MetaDataCardIndex: return (3,1,1,38, .MetaData)
		case .MetaDataEasyDifficultyName: return (112,14,1,40, .MetaData)
		case .MetaDataNormalDifficultyName: return (112,14,1,56, .MetaData)
		case .MetaDataHardDifficultyName: return (112,14,1,72, .MetaData)
		case .MetaDataUnknown9: return (2,1,1,88, .MetaData)
		case .MetaDataUnknown10: return (3,1,1,89, .MetaData)
		case .MetaDataUnknown11: return (3,1,1,90, .MetaData)
		case .MetaDataUnknown12: return (4,1,1,91, .MetaData)
		case .MetaDataUnknown13: return (4,1,1,92, .MetaData)
		case .MetaDataUnknown14: return (4,1,1,93, .MetaData)
		case .MetaDataUnknown15: return (4,1,1,94, .MetaData)
		case .MetaDataUnknown16: return (4,1,1,95, .MetaData)
		case .MetaDataUnknown17: return (4,1,1,96, .MetaData)
		case .MetaDataUnknown18: return (4,1,1,97, .MetaData)
		case .MetaDataUnknown19: return (4,1,1,98, .MetaData)
		case .MetaDataUnknown20: return (4,1,1,99, .MetaData)
		case .MetaDataUnknown21: return (10,2,1,100, .MetaData)
		case .MetaDataUnknown22: return (10,2,1,102, .MetaData)
		case .MetaDataUnknown23: return (10,2,1,104, .MetaData)
		case .MetaDataUnknown24: return (7,1,1,106, .MetaData)
		case .MetaDataUnknown25: return (7,1,1,107, .MetaData)
		case .MetaDataUnknown26: return (7,1,1,108, .MetaData)
		case .MetaDataBonusTrainer1Text1: return (720,90,1,110, .MetaData)
		case .MetaDataBonusTrainer2Text1: return (720,90,1,202, .MetaData)
		case .MetaDataBonusTrainer3Text1: return (720,90,1,294, .MetaData)
		case .MetaDataBonusTrainer1Text2: return (720,90,1,386, .MetaData)
		case .MetaDataBonusTrainer2Text2: return (720,90,1,478, .MetaData)
		case .MetaDataBonusTrainer3Text2: return (720,90,1,570, .MetaData)
		case .MetaDataBonusTrainer1Text3: return (720,90,1,662, .MetaData)
		case .MetaDataBonusTrainer2Text3: return (720,90,1,754, .MetaData)
		case .MetaDataBonusTrainer3Text3: return (720,90,1,846, .MetaData)

		case .TrainerName: return (80,10,1,0, .Trainer)
		case .TrainerGender: return (1,1,1,12, .Trainer)
		case .TrainerPokemonSlot: return (6,1,4,13, .Trainer)
		case .TrainerItem: return (10,2,4,20, .Trainer)
		case .TrainerUnknown: return (1,4,1,28, .Trainer)
		case .TrainerAI: return (14,2,1,32, .Trainer)
		case .TrainerID: return (10,2,1,34, .Trainer)
		case .TrainerModel: return (7,1,1,36, .Trainer)

		case .PokemonSpecies: return (9,2,1,0, .Pokemon)
		case .PokemonShadowID: return (7,1,1,2, .Pokemon)
		case .PokemonLevel: return (7,1,1,3, .Pokemon)
		case .PokemonMove: return (10,2,4,4, .Pokemon)
		case .PokemonUnknown: return (11,2,1,12, .Pokemon)
		case .PokemonAbilitySlot: return (2,1,1,14, .Pokemon)
		case .PokemonIVHP: return (6,1,1,15, .Pokemon)
		case .PokemonIVAttack: return (6,1,1,16, .Pokemon)
		case .PokemonIVDefense: return (6,1,1,17, .Pokemon)
		case .PokemonIVSpatk: return (6,1,1,18, .Pokemon)
		case .PokemonIVSpdef: return (6,1,1,19, .Pokemon)
		case .PokemonIVSpeed: return (6,1,1,20, .Pokemon)
		case .PokemonEVHP: return (9,2,1,22, .Pokemon)
		case .PokemonEVAttack: return (9,2,1,24, .Pokemon)
		case .PokemonEVDefense: return (9,2,1,26, .Pokemon)
		case .PokemonEVSpatk: return (9,2,1,28, .Pokemon)
		case .PokemonEVSpdef: return (9,2,1,30, .Pokemon)
		case .PokemonEVSpeed: return (9,2,1,32, .Pokemon)
		case .PokemonHappiness: return (9,1,1,34, .Pokemon)
		case .PokemonGender: return (2,1,1,36, .Pokemon)
		case .PokemonNature: return (6,1,1,37, .Pokemon)
		case .PokemonUnknown2: return (3,1,1,38, .Pokemon)
		case .PokemonUnknown3: return (6,1,1,39, .Pokemon)
		case .PokemonHeartGauge: return (8,1,1,40, .Pokemon)

		case .StadiumBattleField: return (6,4,1,0, .Stadium)
		case .StadiumName: return (240,30,1,4, .Stadium)
		}
	}
}

let kEcardHeader = [0x00, 0x30, 0x01, 0x02, 0x00, 0x01, 0x08, 0x10, 0x00, 0x00, 0x10, 0x12, 0xF0, 0xD2, 0x01, 0x00, 0x00, 0x04, 0x10, 0xEC, 0xB2, 0x19, 0x00, 0x00, 0x00, 0x08, 0x4E, 0x49, 0x4E, 0x54, 0x45, 0x4E, 0x44, 0x4F, 0x00, 0x22, 0x00, 0x09, 0x22, 0x90, 0x0F, 0x02, 0x02, 0x00, 0x00, 0x00, 0x9B, 0x2B, 0x83, 0x7C, 0x83, 0x50, 0x83, 0x82, 0x83, 0x93, 0x83, 0x52, 0x83, 0x8D, 0x83, 0x56, 0x83, 0x41, 0x83, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]

class EcardCoder {

	static func decode(file: XGFiles) -> XGMutableData? {
		guard let data = file.data else { return nil }
		return decode(input: data)
	}

	static func decode(input: XGMutableData) -> XGMutableData? {
		let output = XGMutableData(length: 0xb20)
		output.file = .nameAndFolder(input.file.fileName.removeFileExtensions() + "-decoded.bin", input.file.folder)
		let headerLength = input.length < 0x840 ? 0 : kEcardHeader.count
		let data = input.getSubDataFromOffset(headerLength, length: input.length - headerLength)

		var readPosition = 0

		/// **bitLength** : number of bits to read
		func readBits(bitLength: Int) -> Int {
			guard bitLength > 0 else { return 0 }

			var mask = 0

			for _ in 0 ..< bitLength {
				let isNegativeReadPosition = readPosition < 0
				let inBitPosition = 7 - (readPosition & 7) // read bits from left to right
				let inBytePosition = (readPosition >> 3) + (isNegativeReadPosition && inBitPosition.boolean).asInt

				let nextBit = (data.getByteAtOffset(inBytePosition) >> inBitPosition) & 0x1
				mask = ((mask & 0x7FFF) << 1) | nextBit

				readPosition += 1
			}

			return mask
		}

		func write(field: EcardFields, entryIndex: Int = 0, bitsAsMask: Int = 0, arrayCounter: Int = 0, bitsAsBuffer: [Int] = []) {
			// The game normally does validation on the fields like ensuring a pokemon id is a valid pokemon but we can skip that
			let info = field.info
			var value = bitsAsMask
			if field.rawValue == 7
				|| field.rawValue == 9
				|| (field.rawValue >= 0x10 && field.rawValue <= 0x18)
				|| field.rawValue == 0x2a
				|| (field.rawValue == 0x44 && field.rawValue & 0x20 == 0) {
				value -= 1
			} else if (field.rawValue >= 0x35 && field.rawValue <= 0x42)
				||  field.rawValue == 0x44 {
				let isRandom = value >> (field.info.bits - 1) == 1
				value = isRandom ? -1 : value
			} else if field.rawValue == 0x43 {
				value = (value >= 1 && value <= 3) ? value - 1 : 0
			} else if field.rawValue == 0x29 {
				value = value == 0 ? 1 : 0
			}
			let offset = info.section.startOffset + (entryIndex * info.section.length) + (arrayCounter * field.info.bytes) + info.relativeOffset
			switch field.info.bytes {
			case 1: output.replaceByteAtOffset(offset, withByte: value & 0xFF)
			case 2: output.replace2BytesAtOffset(offset, withBytes: value & 0xFFFF)
			case 4: output.replace4BytesAtOffset(offset, withBytes: value & 0xFFFFFFFF)
			default: output.replaceBytesFromOffset(offset, withByteStream: bitsAsBuffer)
			}
		}

		func decodeField(_ field: EcardFields, entryIndex: Int = 0) {
			let info = field.info
			if info.bits < 0x10 {
				for i in 0 ..< info.arrayCount {
					let bits = readBits(bitLength: info.bits)
					write(field: field, entryIndex: entryIndex, bitsAsMask: bits, arrayCounter: i)
				}
			} else {
				var byteBuffer = [Int]()
				while info.bits - (byteBuffer.count * 8) > 0 {
					let nextbitLength = min(info.bits - (byteBuffer.count * 8), 0x10)
					let bits = readBits(bitLength: nextbitLength)
					byteBuffer += bits.byteArrayU16
				}
				byteBuffer += [0,0]
				write(field: field, entryIndex: entryIndex, bitsAsBuffer: byteBuffer)
			}
		}

		func decodeFields(_ fields: [EcardFields], entryIndex: Int = 0) {
			for field in fields {
				decodeField(field, entryIndex: entryIndex)
			}
		}

		func decodeStadium() {
			decodeFields([
				.CardTypeStadium,
				.StadiumBattleField,
				.StadiumName
			])
		}

		func decodeMetaData() {
			decodeFields([
				.CardTypeBattle,
				.MetaDataUnknown1,
				.MetaDataUnknown2,
				.MetaDataUnknown3,
				.MetaDataUnknown4,
				.MetaDataUnknown5,
				.MetaDataCardName,
				.MetaDataPackID,
				.MetaDataUnknown7,
				.MetaDataCardIndex,
				.MetaDataEasyDifficultyName,
				.MetaDataNormalDifficultyName,
				.MetaDataHardDifficultyName,
				.MetaDataUnknown9,
				.MetaDataUnknown10,
				.MetaDataUnknown11,
				.MetaDataUnknown12,
				.MetaDataUnknown13,
				.MetaDataUnknown14,
				.MetaDataUnknown15,
				.MetaDataUnknown16,
				.MetaDataUnknown17,
				.MetaDataUnknown18,
				.MetaDataUnknown19,
				.MetaDataUnknown20,
				.MetaDataUnknown21,
				.MetaDataUnknown22,
				.MetaDataUnknown23,
				.MetaDataUnknown24,
				.MetaDataUnknown25,
				.MetaDataUnknown26,
				.MetaDataBonusTrainer1Text1,
				.MetaDataBonusTrainer1Text2,
				.MetaDataBonusTrainer1Text3,
				.MetaDataBonusTrainer2Text1,
				.MetaDataBonusTrainer2Text2,
				.MetaDataBonusTrainer2Text3,
				.MetaDataBonusTrainer3Text1,
				.MetaDataBonusTrainer3Text2,
				.MetaDataBonusTrainer3Text3
			])
		}

		func decodeTrainer(withIndex index: Int) {
			decodeFields([
				.TrainerName,
				.TrainerGender,
				.TrainerPokemonSlot,
				.TrainerItem,
				.TrainerUnknown,
				.TrainerAI,
				.TrainerID,
				.TrainerModel
			], entryIndex: index)
		}

		func decodePokemon(withIndex index: Int) {
			decodeFields([
				.PokemonSpecies,
				.PokemonShadowID,
				.PokemonLevel,
				.PokemonMove,
				.PokemonUnknown,
				.PokemonAbilitySlot,
				.PokemonIVHP,
				.PokemonIVAttack,
				.PokemonIVDefense,
				.PokemonIVSpatk,
				.PokemonIVSpdef,
				.PokemonIVSpeed,
				.PokemonEVHP,
				.PokemonEVAttack,
				.PokemonEVDefense,
				.PokemonEVSpatk,
				.PokemonEVSpdef,
				.PokemonEVSpeed,
				.PokemonHappiness,
				.PokemonGender,
				.PokemonNature,
				.PokemonUnknown2,
				.PokemonUnknown3,
				.PokemonHeartGauge
			], entryIndex: index)
		}

		decodeField(.CardTypeBattle)
		let cardType = output.get4BytesAtOffset(0)
		readPosition = 0

		if cardType == 1 {
			decodeStadium()
		} else if cardType == 0 {
			decodeMetaData()
			for i in 0 ..< EcardTableSections.Trainer.numberOfEntries {
				decodeTrainer(withIndex: i)
			}
			for i in 0 ..< EcardTableSections.Pokemon.numberOfEntries {
				decodePokemon(withIndex: i)
			}
		} else {
			return nil
		}

		return output
	}

	static func encode(file: XGFiles) -> XGMutableData? {
		guard let data = file.data else { return nil }
		return encode(data: data)
	}

	static func encode(data inputData: XGMutableData) -> XGMutableData? {
		let output = XGMutableData()
		output.file = .nameAndFolder(inputData.file.fileName.removeFileExtensions() + "-decrypted.bin", inputData.file.folder)

		let data = XGMutableData(byteStream: inputData.rawBytes)

// 		Uncomment this when the ecard encoder works and test whether or not we can get away with adding our own English data in these headers
//		var info = EcardFields.MetaDataCardName.info
//		data.nullBytes(start: info.relativeOffset, length: info.bytes)
//		data.writeString("Colo Tool", at: info.relativeOffset, charLength: .short, maxCharacters: info.bytes / 2, includeNullTerminator: false)
//
//		info = EcardFields.MetaDataEasyDifficultyName.info
//		data.nullBytes(start: info.relativeOffset, length: info.bytes)
//		data.writeString("Easy", at: info.relativeOffset, charLength: .short, maxCharacters: info.bytes / 2, includeNullTerminator: false)
//		info = EcardFields.MetaDataNormalDifficultyName.info
//		data.nullBytes(start: info.relativeOffset, length: info.bytes)
//		data.writeString("Normal", at: info.relativeOffset, charLength: .short, maxCharacters: info.bytes / 2, includeNullTerminator: false)
//		info = EcardFields.MetaDataHardDifficultyName.info
//		data.nullBytes(start: info.relativeOffset, length: info.bytes)
//		data.writeString("Hard", at: info.relativeOffset, charLength: .short, maxCharacters: info.bytes / 2, includeNullTerminator: false)

		var writePosition = 7
		var currentByte = 0

		func writeBits(_ bits: [Int]) {
			for bit in bits {
				let nextBit = bit << writePosition
				currentByte |= nextBit

				if writePosition == 0 {
					output.appendBytes([currentByte])
					currentByte = 0
					writePosition = 7
				} else {
					writePosition -= 1
				}
			}
		}

		func encodeField(_ field: EcardFields, entryIndex: Int = 0) {
			let info = field.info
			for arrayCounter in 0 ..< info.arrayCount {
				let offset = info.section.startOffset + (entryIndex * info.section.length) + (arrayCounter * field.info.bytes) + info.relativeOffset
				var values = data.getByteStreamFromOffset(offset, length: info.bytes)

				if field.rawValue == 7
					|| field.rawValue == 9
					|| (field.rawValue >= 0x10 && field.rawValue <= 0x18)
					|| field.rawValue == 0x2a
					|| (field.rawValue == 0x44 && field.rawValue & 0x20 == 0) {
					values[0] = values[0] + 1
				} else if field.rawValue == 0x43 {
					values[0] = values[0] + 1
				} else if field.rawValue == 0x29 {
					values[0] = values[0] == 0 ? 1 : 0
				}

				var bits = [Int]()
				for value in values {
					bits += value.bits(count: 8, startWithLeastSignificantBit: false)
				}
				while bits.count < info.bits {
					bits = [0] + bits
				}
				let bitsToRemove = bits.count - info.bits
				bits = Array(bits[bitsToRemove ..< bits.count])
				writeBits(bits)
			}
		}

		func encodeFields(_ fields: [EcardFields], entryIndex: Int = 0) {
			for field in fields {
				encodeField(field, entryIndex: entryIndex)
			}
		}

		func encodeStadium() {
			encodeFields([
				.CardTypeStadium,
				.StadiumBattleField,
				.StadiumName
			])
		}

		func encodeMetaData() {
			encodeFields([
				.CardTypeBattle,
				.MetaDataUnknown1,
				.MetaDataUnknown2,
				.MetaDataUnknown3,
				.MetaDataUnknown4,
				.MetaDataUnknown5,
				.MetaDataCardName,
				.MetaDataPackID,
				.MetaDataUnknown7,
				.MetaDataCardIndex,
				.MetaDataEasyDifficultyName,
				.MetaDataNormalDifficultyName,
				.MetaDataHardDifficultyName,
				.MetaDataUnknown9,
				.MetaDataUnknown10,
				.MetaDataUnknown11,
				.MetaDataUnknown12,
				.MetaDataUnknown13,
				.MetaDataUnknown14,
				.MetaDataUnknown15,
				.MetaDataUnknown16,
				.MetaDataUnknown17,
				.MetaDataUnknown18,
				.MetaDataUnknown19,
				.MetaDataUnknown20,
				.MetaDataUnknown21,
				.MetaDataUnknown22,
				.MetaDataUnknown23,
				.MetaDataUnknown24,
				.MetaDataUnknown25,
				.MetaDataUnknown26,
				.MetaDataBonusTrainer1Text1,
				.MetaDataBonusTrainer1Text2,
				.MetaDataBonusTrainer1Text3,
				.MetaDataBonusTrainer2Text1,
				.MetaDataBonusTrainer2Text2,
				.MetaDataBonusTrainer2Text3,
				.MetaDataBonusTrainer3Text1,
				.MetaDataBonusTrainer3Text2,
				.MetaDataBonusTrainer3Text3
			])
		}

		func encodeTrainer(withIndex index: Int) {
			encodeFields([
				.TrainerName,
				.TrainerGender,
				.TrainerPokemonSlot,
				.TrainerItem,
				.TrainerUnknown,
				.TrainerAI,
				.TrainerID,
				.TrainerModel
			], entryIndex: index)
		}

		func encodePokemon(withIndex index: Int) {
			encodeFields([
				.PokemonSpecies,
				.PokemonShadowID,
				.PokemonLevel,
				.PokemonMove,
				.PokemonUnknown,
				.PokemonAbilitySlot,
				.PokemonIVHP,
				.PokemonIVAttack,
				.PokemonIVDefense,
				.PokemonIVSpatk,
				.PokemonIVSpdef,
				.PokemonIVSpeed,
				.PokemonEVHP,
				.PokemonEVAttack,
				.PokemonEVDefense,
				.PokemonEVSpatk,
				.PokemonEVSpdef,
				.PokemonEVSpeed,
				.PokemonHappiness,
				.PokemonGender,
				.PokemonNature,
				.PokemonUnknown2,
				.PokemonUnknown3,
				.PokemonHeartGauge
			], entryIndex: index)
		}

		let cardType = data.get4BytesAtOffset(0)

		if cardType == 1 {
			encodeStadium()
		} else if cardType == 0 {
			encodeMetaData()
			for i in 0 ..< EcardTableSections.Trainer.numberOfEntries {
				encodeTrainer(withIndex: i)
			}
			for i in 0 ..< EcardTableSections.Pokemon.numberOfEntries {
				encodePokemon(withIndex: i)
			}
		} else {
			return nil
		}

		if writePosition != 7 {
			output.appendBytes([currentByte])
		}

		output.insertBytes(bytes: kEcardHeader, atOffset: 0)
		var lastDummyValue = 0
		while output.length < 0x840 {
			output.appendBytes([lastDummyValue])
			lastDummyValue += 1
			if lastDummyValue == 256 { lastDummyValue = 0 }
		}

		return output
	}

	static func encrypt(file: XGFiles, toFile output: XGFiles? = nil) {
		let outputFile = output ?? .nameAndFolder(file.fileName.removeFileExtensions() + ".raw", file.folder)
		GoDShellManager.run(.nedcenc, args: [
			"-e",
			"-i",
			file.path,
			"-o",
			outputFile.path
		])
	}

	static func decrypt(file: XGFiles, toFile output: XGFiles? = nil) {
		let outputFile = output ?? .nameAndFolder(file.fileName.removeFileExtensions() + ".bin", file.folder)
		GoDShellManager.run(.nedcenc, args: [
			"-d",
			"-i",
			file.path,
			"-o",
			outputFile.path
		])
	}
}
