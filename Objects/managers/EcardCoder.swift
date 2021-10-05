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


enum EcardFieldTypes: Int {
	case CardTypeBattle = 0
	case MetaDataUnknown1 = 1
	case MetaDataUnknown2 = 2
	case MetaDataUnknown3 = 3
	case MetaDataUnknown4 = 4
	case MetaDataUnknown5 = 5
	case MetaDataCardName = 6
	case MetaDataUnknown6 = 7
	case MetaDataUnknown7 = 8
	case MetaDataUnknown8 = 9
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
	case MetaDataBonusTrainer1Text2 = 32
	case MetaDataBonusTrainer1Text3 = 33
	case MetaDataBonusTrainer2Text1 = 34
	case MetaDataBonusTrainer2Text2 = 35
	case MetaDataBonusTrainer2Text3 = 36
	case MetaDataBonusTrainer3Text1 = 37
	case MetaDataBonusTrainer3Text2 = 38
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

}

class EcardCoder {

	static func decode(file: XGFiles) -> XGMutableData? {
		guard let data = file.data else { return nil }
		return decode(input: data)
	}

	// Default "key" value is the one used in Colosseum
	static func decode(input: XGMutableData, key: Int = 4160) -> XGMutableData? {
		let output = XGMutableData(length: 0xb20)
		output.file = .nameAndFolder(input.file.fileName.removeFileExtensions() + "-decoded.bin", input.file.folder)
		let data = input.getSubDataFromOffset(0x51, length: input.length - 0x51)

		var readPosition = 0

		/// **bitLength** : number of bits to read
		func readBits(bitLength: Int) -> Int {
			guard bitLength > 0 else {
				return 0
			}

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

		@discardableResult
		func decodeField(fieldType: EcardFieldTypes, bitLength: Int, arrayCount: Int, entryIndex: Int? = nil) -> Bool {
			if bitLength < 0x10 {
				var valid = true
				for i in 0 ..< arrayCount {
					let bits = readBits(bitLength: bitLength)
					valid = valid && write(output: output, fieldType: fieldType, entryIndex: entryIndex, bitsAsMask: bits, arrayCounter: i)
				}
				return valid
			} else {
				var byteBuffer = [Int]()
				while bitLength - (byteBuffer.count * 8) > 0 {
					let nextbitLength = min(bitLength - (byteBuffer.count * 8), 0x10)
					let bits = readBits(bitLength: nextbitLength)
					byteBuffer += bits.byteArrayU16
				}
				byteBuffer += [0,0]
				return write(output: output, fieldType: fieldType, entryIndex: entryIndex, bitsAsBuffer: byteBuffer)
			}
		}

		@discardableResult
		func decodeFields(withParameters parameters: [(fieldType: EcardFieldTypes, bitLength: Int, loopCount: Int)], entryIndex: Int? = nil) -> Bool {
			var valid = true
			for params in parameters {
				valid = valid && decodeField(fieldType: params.fieldType, bitLength: params.bitLength, arrayCount: params.loopCount, entryIndex: entryIndex)
			}
			return valid
		}

		@discardableResult
		func decodeStadium() -> Bool {
			return decodeFields(withParameters: [
				(.CardTypeStadium, 4, 0x1),
				(.StadiumBattleField, 6, 0x1),
				(.StadiumName, 240, 0x1)
			])
		}

		@discardableResult
		func decodeMetaData() -> Bool {
			return decodeFields(withParameters: [
				(.CardTypeBattle, 4, 1),
				(.MetaDataUnknown1, 3, 1),
				(.MetaDataUnknown2, 2, 1),
				(.MetaDataUnknown3, 4, 1),
				(.MetaDataUnknown4, 4, 1),
				(.MetaDataUnknown5, 8, 1),
				(.MetaDataCardName, 192, 1),
				(.MetaDataUnknown6, 3, 1),
				(.MetaDataUnknown7, 3, 1),
				(.MetaDataUnknown8, 3, 1),
				(.MetaDataEasyDifficultyName, 112, 1),
				(.MetaDataNormalDifficultyName, 112, 1),
				(.MetaDataHardDifficultyName, 112, 1),
				(.MetaDataUnknown9, 2, 1),
				(.MetaDataUnknown10, 3, 1),
				(.MetaDataUnknown11, 3, 1),
				(.MetaDataUnknown12, 4, 1),
				(.MetaDataUnknown13, 4, 1),
				(.MetaDataUnknown14, 4, 1),
				(.MetaDataUnknown15, 4, 1),
				(.MetaDataUnknown16, 4, 1),
				(.MetaDataUnknown17, 4, 1),
				(.MetaDataUnknown18, 4, 1),
				(.MetaDataUnknown19, 4, 1),
				(.MetaDataUnknown20, 4, 1),
				(.MetaDataUnknown21, 10, 1),
				(.MetaDataUnknown22, 10, 1),
				(.MetaDataUnknown23, 10, 1),
				(.MetaDataUnknown24, 7, 1),
				(.MetaDataUnknown25, 7, 1),
				(.MetaDataUnknown26, 7, 1),
				(.MetaDataBonusTrainer1Text1, 720, 1),
				(.MetaDataBonusTrainer1Text2, 720, 1),
				(.MetaDataBonusTrainer1Text3, 720, 1),
				(.MetaDataBonusTrainer2Text1, 720, 1),
				(.MetaDataBonusTrainer2Text2, 720, 1),
				(.MetaDataBonusTrainer2Text3, 720, 1),
				(.MetaDataBonusTrainer3Text1, 720, 1),
				(.MetaDataBonusTrainer3Text2, 720, 1),
				(.MetaDataBonusTrainer3Text3, 720, 1)
			])
		}

		@discardableResult
		func decodeTrainer(withIndex index: Int) -> Bool {
			return decodeFields(withParameters: [
				(.TrainerName, 80, 1),
				(.TrainerGender, 1, 1),
				(.TrainerPokemonSlot, 6, 4),
				(.TrainerItem, 10, 4),
				(.TrainerUnknown, 1, 1),
				(.TrainerAI, 14, 1),
				(.TrainerID, 10, 1),
				(.TrainerModel, 7, 1)
			], entryIndex: index)
		}

		@discardableResult
		func decodePokemon(withIndex index: Int) -> Bool {
			return decodeFields(withParameters: [
				(.PokemonSpecies, 9, 1),
				(.PokemonShadowID, 7, 1),
				(.PokemonLevel, 7, 1),
				(.PokemonMove, 10, 4),
				(.PokemonUnknown, 11, 1),
				(.PokemonAbilitySlot, 2, 1),
				(.PokemonIVHP, 6, 1),
				(.PokemonIVAttack, 6, 1),
				(.PokemonIVDefense, 6, 1),
				(.PokemonIVSpatk, 6, 1),
				(.PokemonIVSpdef, 6, 1),
				(.PokemonIVSpeed, 6, 1),
				(.PokemonEVHP, 9, 1),
				(.PokemonEVAttack, 9, 1),
				(.PokemonEVDefense, 9, 1),
				(.PokemonEVSpatk, 9, 1),
				(.PokemonEVSpdef, 9, 1),
				(.PokemonEVSpeed, 9, 1),
				(.PokemonHappiness, 9, 1),
				(.PokemonGender, 2, 1),
				(.PokemonNature, 6, 1),
				(.PokemonUnknown2, 3, 1),
				(.PokemonUnknown3, 6, 1),
				(.PokemonHeartGauge, 8, 1)
			], entryIndex: index)
		}

		decodeField(fieldType: .CardTypeBattle, bitLength: 4, arrayCount: 1)
		let cardType = output.get4BytesAtOffset(0)
		readPosition = 0

		if cardType == 1 {
			decodeStadium()
		} else if cardType == 0 {
			decodeMetaData()
			for i in 0 ..< 9 {
				decodeTrainer(withIndex: i)
			}
			for i in 0 ..< 0x24 {
				decodePokemon(withIndex: i)
			}
		} else {
			return nil
		}

		return output
	}

	/// This function is used to read individual fields such as strings or values from the structs saved on the cards
	/// Different fieldTypes are used to perform different types of validation to make sure the card was read correctly
	/// The values are things like checking pokemon ids and item ids fall within valid ranges
	@discardableResult
	private static func write(output: XGMutableData, fieldType: EcardFieldTypes, entryIndex: Int? = nil, bitsAsMask: Int? = nil, arrayCounter: Int? = nil, bitsAsBuffer: [Int]? = nil) -> Bool {

		let charValue  = (bitsAsMask ?? 0) & 0xFF
		let shortValue = (bitsAsMask ?? 0) & 0xFFFF
		let wordValue  = (bitsAsMask ?? 0) & 0xFFFFFFFF
		let stringValue = bitsAsBuffer ?? []
		let multiplier = entryIndex ?? 0
		let loop = arrayCounter ?? 0

		switch fieldType.rawValue {
		case 0x1:
			output.replaceByteAtOffset(4, withByte: charValue)
			guard charValue != 0, charValue <= 5 else {
				return false
			}
		case 0x2:
			output.replaceByteAtOffset(5, withByte: charValue)
			guard charValue != 0, charValue <= 3 else {
				return false
			}
		case 0x3:
			output.replaceByteAtOffset(6, withByte: charValue)
			guard charValue != 0, charValue <= 9 else {
				return false
			}
		case 0x4:
			output.replaceByteAtOffset(7, withByte: charValue)
			guard charValue != 0 else {
				return false
			}
		case 0x5:
			output.replaceByteAtOffset(8, withByte: charValue)
		case 0x6:
			output.replaceBytesFromOffset(10, withByteStream: stringValue)
		case 0x7:
			output.replaceByteAtOffset(0x24, withByte: charValue - 1)
			guard charValue >= 0, charValue <= 5 else {
				return false
			}
		case 0x8:
			output.replaceByteAtOffset(0x25, withByte: charValue)
		case 0x9:
			output.replaceByteAtOffset(0x26, withByte: charValue - 1)
			guard charValue >= 1, charValue <= 5 else {
				return false
			}
		case 0xa:
			output.replaceBytesFromOffset(0x28, withByteStream: stringValue)
		case 0xb:
			output.replaceBytesFromOffset(0x38, withByteStream: stringValue)
		case 0xc:
			output.replaceBytesFromOffset(0x48, withByteStream: stringValue)
		case 0xd:
			output.replaceByteAtOffset(0x58, withByte: charValue)
			guard charValue >= 1, charValue <= 3 else {
				return false
			}
		case 0xe:
			output.replaceByteAtOffset(0x59, withByte: charValue)
			guard charValue >= 1, charValue <= 6 else {
				return false
			}
		case 0xf:
			output.replaceByteAtOffset(0x5a, withByte: charValue)
			guard charValue >= 1, charValue <= 5 else {
				return false
			}
		case 0x10:
			output.replaceByteAtOffset(0x5b, withByte: charValue - 1)
			guard charValue >= 0, charValue <= 9 else {
				return false
			}
		case 0x11:
			output.replaceByteAtOffset(0x5c, withByte: charValue - 1)
			guard charValue >= 0, charValue <= 9 else {
				return false
			}
		case 0x12:
			output.replaceByteAtOffset(0x5d, withByte: charValue - 1)
			guard charValue >= 0, charValue <= 9 else {
				return false
			}
		case 0x13:
			output.replaceByteAtOffset(0x5e, withByte: charValue - 1)
			guard charValue >= 0, charValue <= 9 else {
				return false
			}
		case 0x14:
			output.replaceByteAtOffset(0x5f, withByte: charValue - 1)
			guard charValue >= 0, charValue <= 9 else {
				return false
			}
		case 0x15:
			output.replaceByteAtOffset(0x60, withByte: charValue - 1)
			guard charValue >= 0, charValue <= 9 else {
				return false
			}
		case 0x16:
			output.replaceByteAtOffset(0x61, withByte: charValue - 1)
			guard charValue >= 0, charValue <= 9 else {
				return false
			}
		case 0x17:
			output.replaceByteAtOffset(0x62, withByte: charValue - 1)
			guard charValue >= 0, charValue <= 9 else {
				return false
			}
		case 0x18:
			output.replaceByteAtOffset(0x63, withByte: charValue - 1)
			guard charValue >= 0, charValue <= 9 else {
				return false
			}
		case 0x19:
			output.replace2BytesAtOffset(0x64, withBytes: shortValue)
			guard shortValue >= 0, shortValue < (0x2f * 7) else {
				return false
			}
		case 0x1a:
			output.replace2BytesAtOffset(0x66, withBytes: shortValue)
			guard shortValue >= 0, shortValue < (0x2f * 7) else {
				return false
			}
		case 0x1b:
			output.replace2BytesAtOffset(0x68, withBytes: shortValue)
			guard shortValue >= 0, shortValue < (0x2f * 7) else {
				return false
			}
		case 0x1c:
			output.replaceByteAtOffset(0x6a, withByte: charValue)
			switch charValue {
			case 0: fallthrough
			case 0xd: fallthrough
			case 0x12: fallthrough
			case 0x19: fallthrough
			case 0x1a: fallthrough
			case 0x1b: fallthrough
			case 0x1c: fallthrough
			case 0x1d: fallthrough
			case 0x1e: fallthrough
			case 0x20: fallthrough
			case 0x24: return true
			default: return false
			}
		case 0x1d:
			output.replaceByteAtOffset(0x6b, withByte: charValue)
			switch charValue {
			case 0: fallthrough
			case 0xd: fallthrough
			case 0x12: fallthrough
			case 0x19: fallthrough
			case 0x1a: fallthrough
			case 0x1b: fallthrough
			case 0x1c: fallthrough
			case 0x1d: fallthrough
			case 0x1e: fallthrough
			case 0x20: fallthrough
			case 0x24: return true
			default: return false
			}
		case 0x1e:
			output.replaceByteAtOffset(0x6c, withByte: charValue)
			switch charValue {
			case 0: fallthrough
			case 0xd: fallthrough
			case 0x12: fallthrough
			case 0x19: fallthrough
			case 0x1a: fallthrough
			case 0x1b: fallthrough
			case 0x1c: fallthrough
			case 0x1d: fallthrough
			case 0x1e: fallthrough
			case 0x20: fallthrough
			case 0x24: return true
			default: return false
			}
		case 0x1f:
			output.replaceBytesFromOffset(0x6e, withByteStream: stringValue)
		case 0x20:
			output.replaceBytesFromOffset(0x182, withByteStream: stringValue)
		case 0x21:
			output.replaceBytesFromOffset(0x296, withByteStream: stringValue)
		case 0x22:
			output.replaceBytesFromOffset(0xca, withByteStream: stringValue)
		case 0x23:
			output.replaceBytesFromOffset(0x1de, withByteStream: stringValue)
		case 0x24:
			output.replaceBytesFromOffset(0x2f2, withByteStream: stringValue)
		case 0x25:
			output.replaceBytesFromOffset(0x126, withByteStream: stringValue)
		case 0x26:
			output.replaceBytesFromOffset(0x23a, withByteStream: stringValue)
		case 0x27:
			output.replaceBytesFromOffset(0x34e, withByteStream: stringValue)
		case 0x28:
			output.replaceBytesFromOffset((0xeb + (multiplier * 10)) * 4, withByteStream: stringValue)
		case 0x29:
			output.replaceByteAtOffset((0xee + (multiplier * 10)) * 4, withByte: wordValue == 0 ? 1 : 0)
		case 0x2a:
			output.replaceByteAtOffset(loop + (multiplier * 0x28) + 0x3b9, withByte: charValue - 1)
			guard charValue >= 0, charValue <= 0x24 else {
				return false
			}
		case 0x2b:
			output.replace2BytesAtOffset((loop * 2) + (multiplier * 0x28) + 0x3be, withBytes: shortValue)
			guard shortValue >= 0, shortValue < (0x2f * 7) else {
				return false
			}
		case 0x2c:
			output.replace4BytesAtOffset(((multiplier * 10) + 0xf2) * 4, withBytes: wordValue)
		case 0x2d:
			output.replace2BytesAtOffset(((multiplier * 10) + 0xf3) * 4, withBytes: shortValue)
			guard shortValue == 0 || shortValue >= 0x6 || shortValue <= 0x50 else {
				return false
			}
		case 0x2e:
			output.replace2BytesAtOffset((multiplier * 0x28) + 0x3ce, withBytes: shortValue)
			guard ((output.getByteAtOffset(0x5b) != multiplier)
			&& (output.getByteAtOffset(0x5c) != multiplier)
			&& (output.getByteAtOffset(0x5d) != multiplier))
					|| shortValue <= 999 else {
				return false
			}
		case 0x2f:
			output.replaceByteAtOffset(((multiplier * 10) + 0xf4) * 4, withByte: charValue)
			guard true else {
				return false
			} // Lots of gaps in the table at RAM offset 80269470. CBA to validate within all valid range
		case 0x30:
			output.replace2BytesAtOffset((multiplier * 0x2a) + 0x514, withBytes: shortValue)
			guard shortValue >= 0, shortValue <= 411 else {
				return false
			}
		case 0x31:
			output.replaceByteAtOffset((multiplier * 0x2a) + 0x516, withByte: charValue)
			guard (charValue == 0)
			|| ((charValue >= 0x44)
			&& (charValue <= 0x60)) else {
				return false
			}
		case 0x32:
			output.replaceByteAtOffset((multiplier * 0x2a) + 0x517, withByte: charValue)
		case 0x33:
			output.replace2BytesAtOffset((loop * 2) + (multiplier * 0x2a) + 0x518, withBytes: shortValue)
			guard charValue >= 0, charValue <= 0x47 * 5 else {
				return false
			}
		case 0x34:
			output.replace2BytesAtOffset((multiplier * 0x2a) + 0x520, withBytes: shortValue)
			guard shortValue >= 0, shortValue < (0x2f * 7) else {
				return false
			}
		case 0x35:
			output.replaceByteAtOffset((multiplier * 0x2a) + 0x522, withByte: wordValue > -1 && wordValue < 2 ? charValue : 0xFF)
		case 0x36:
			output.replaceByteAtOffset((multiplier * 0x2a) + 0x523, withByte: wordValue > -1 && wordValue < 0x20 ? charValue : 0xFF)
		case 0x37:
			output.replaceByteAtOffset((multiplier * 0x2a) + 0x524, withByte: wordValue > -1 && wordValue < 0x20 ? charValue : 0xFF)
		case 0x38:
			output.replaceByteAtOffset((multiplier * 0x2a) + 0x525, withByte: wordValue > -1 && wordValue < 0x20 ? charValue : 0xFF)
		case 0x39:
			output.replaceByteAtOffset((multiplier * 0x2a) + 0x526, withByte: wordValue > -1 && wordValue < 0x20 ? charValue : 0xFF)
		case 0x3a:
			output.replaceByteAtOffset((multiplier * 0x2a) + 0x527, withByte: wordValue > -1 && wordValue < 0x20 ? charValue : 0xFF)
		case 0x3b:
			output.replaceByteAtOffset((multiplier * 0x2a) + 0x528, withByte: wordValue > -1 && wordValue < 0x20 ? charValue : 0xFF)
		case 0x3c:
			output.replace2BytesAtOffset((multiplier * 0x2a) + 0x52a, withBytes: wordValue > -1 && wordValue < 0x100 ? shortValue : 0xFFFF)
		case 0x3d:
			output.replace2BytesAtOffset((multiplier * 0x2a) + 0x52c, withBytes: wordValue > -1 && wordValue < 0x100 ? shortValue : 0xFFFF)
		case 0x3e:
			output.replace2BytesAtOffset((multiplier * 0x2a) + 0x52e, withBytes: wordValue > -1 && wordValue < 0x100 ? shortValue : 0xFFFF)
		case 0x3f:
			output.replace2BytesAtOffset((multiplier * 0x2a) + 0x530, withBytes: wordValue > -1 && wordValue < 0x100 ? shortValue : 0xFFFF)
		case 0x40:
			output.replace2BytesAtOffset((multiplier * 0x2a) + 0x532, withBytes: wordValue > -1 && wordValue < 0x100 ? shortValue : 0xFFFF)
		case 0x41:
			output.replace2BytesAtOffset((multiplier * 0x2a) + 0x534, withBytes: wordValue > -1 && wordValue < 0x100 ? shortValue : 0xFFFF)
		case 0x42:
			output.replace2BytesAtOffset((multiplier * 0x2a) + 0x536, withBytes: wordValue > -1 && wordValue < 0x100 ? shortValue : 0xFFFF)
		case 0x43:
			if wordValue >= 1, wordValue <= 3 {
				output.replaceByteAtOffset((multiplier * 0x2a) + 0x538, withByte: wordValue - 1)
			} else {
				output.replaceByteAtOffset((multiplier * 0x2a) + 0x538, withByte: 0)
			}
		case 0x44:
			if wordValue & 0x20 == 0 {
				output.replaceByteAtOffset((multiplier * 0x2a) + 0x539, withByte: charValue - 1)
				guard (charValue - 1) >= 0, (charValue - 1) <= 0x18 else {
					return false

				}
			} else {
				output.replaceByteAtOffset((multiplier * 0x2a) + 0x539, withByte: 0xFF)
			}
		case 0x45:
			output.replaceByteAtOffset((multiplier * 0x2a) + 0x53a, withByte: charValue)
			guard charValue <= 3 else {
				return false
			}
		case 0x46:
			output.replaceByteAtOffset((multiplier * 0x2a) + 0x53b, withByte: charValue)
			guard charValue <= 4 else {
				return false
			}
		case 0x47:
			output.replaceByteAtOffset((multiplier * 0x2a) + 0x53c, withByte: charValue)
		case 0x49:
			output.replace4BytesAtOffset(0x2bf * 4, withBytes: wordValue)
			guard true else {
				return false
			} // Lots of gaps in the table at RAM offset 80269abc. CBA to validate within all valid range
		case 0x4a:
			output.replaceBytesFromOffset(0x2c0 * 4, withByteStream: stringValue)
		default:
			output.replace4BytesAtOffset(0, withBytes: wordValue)
			guard charValue >= 0, charValue <= 1 else {
				return false
			}
		}

		return true
	}
}
