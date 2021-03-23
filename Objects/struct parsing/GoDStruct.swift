//
//  GoDStruct.swift
//  GoD Tool
//
//  Created by Stars Momodu on 17/03/2021.
//

import Foundation

struct GoDStruct {
	let name: String
	let format: [GoDStructProperties]

	var length: Int {
		var total = 0

		format.forEach {
			total += $0.alignmentBytes(at: total)
			total += $0.length
		}

		if total % 2 != 0 {
			total += 1
		}
		return total
	}

	static var dummy: GoDStruct {
		return .init(name: "Dummy", format: [])
	}

	func dummyValues() -> GoDStructData {
		return GoDStructData(properties: self, fileData: XGMutableData(length: length), startOffset: 0)
	}

	var CStructName: String {
		name.split(separator: " ").map{String($0).simplified.capitalized}.joined(separator: "")
	}

	var flattened: GoDStruct {
		var flatProperties = [GoDStructProperties]()

		func flatten(properties: [GoDStructProperties]) {
			properties.forEach { property in
				switch property {
				case .byte, .short,.word, .float, .string, .bitArray:
					flatProperties.append(property)
				case .subStruct(_, _, let property):
					flatProperties += property.flattened.format
				case .array(_, _, let property, let count):
					(0 ..< count).forEach { index in
						flatten(properties: [property])
					}
				}
			}
		}
		flatten(properties: format)

		return GoDStruct(name: name, format: flatProperties)
	}

	var CStruct: String {

		var subStructs = [String]()
		var string = "struct \(CStructName) {"

		func textForProperty(_ property: GoDStructProperties) -> String {
			switch property {
			case .byte(let name, _, let type):
				return (type.isSigned ? "int8_t " : "char ") + name.camelCaseBySpaces
			case .short(let name, _, let type):
				return (type.isSigned ? "int16_t " : "uint16_t ") + name.camelCaseBySpaces
			case .word(let name, _, let type):
				switch type {
				case .pointerToProperty(_, let property, _):
					var text = textForProperty(property).split(separator: " ")
					text[text.count - 1] = "*" + text[text.count - 1]
					return text.joined(separator: " ")
				case .stringPointer:
					return "char **" + name.camelCaseBySpaces
				default:
					return (type.isSigned ? "int32_t " : "uint32_t ") + name.camelCaseBySpaces
				}
			case .bitArray(let name, let description, _):
				return textForProperty(.array(name: name, description: description, property: .byte(name: "", description: "", type: .bitMask), count: property.length))
			case .float(let name, _):
				return "float " + name.camelCaseBySpaces
			case .string(let name, let description, let maxCharacterCount, let charLength):
				switch charLength {
				case .char:
					return textForProperty(.array(name: name, description: description, property: .byte(name: "", description: "", type: .uint), count: maxCharacterCount))
				case .short:
					return textForProperty(.array(name: name, description: description, property: .short(name: "", description: "", type: .uint), count: maxCharacterCount))
				case .word:
					return textForProperty(.array(name: name, description: description, property: .word(name: "", description: "", type: .uint), count: maxCharacterCount))
				}
			case .subStruct(let name, _, let property):
				subStructs.append(property.CStruct)
				return "struct " +  name.camelCaseBySpacesCapitalised + " " + name.camelCaseBySpaces
			case .array(let name, _, let property, let count):
				var prefix = ""
				switch property {
				case .byte(_, let description, let type):
					prefix = textForProperty(.byte(name: name, description: description, type: type))
				case .short(_, let description, let type):
					prefix = textForProperty(.short(name: name, description: description, type: type))
				case .word(_, let description, let type):
					prefix = textForProperty(.word(name: name, description: description, type: type))
				case .bitArray(_, let description, let bitFieldNames):
					prefix = textForProperty(.bitArray(name: name, description: description, bitFieldNames: bitFieldNames))
				case .float(_, let description):
					prefix = textForProperty(.float(name: name, description: description))
				case .string(_, let description, let maxCharacterCount, let charLength):
					prefix = textForProperty(.string(name: name, description: description, maxCharacterCount: maxCharacterCount, charLength: charLength))
				case .subStruct(_, let description, let property):
					prefix = textForProperty(.subStruct(name: name, description: description, property: property))
				case .array(_, let description, let property, let count):
					prefix = textForProperty(.array(name: name, description: description, property: property, count: count))
				}
				return prefix + "[\(count)]"
			}
		}
		format.forEach { (property) in
			let descriptionText = property.description.isEmpty ? "" : " // \(property.description)"
			string += "\n    " + textForProperty(property) + ";" + descriptionText
		}
		string += "\n};"

		var compoundedString = ""
		subStructs.forEach { (text) in
			compoundedString += text + "\n\n"
		}
		return compoundedString + string
	}

	func documentCStruct() {
		let file = XGFiles.nameAndFolder(CStructName + ".c", .nameAndFolder("C Structs", .Reference))
		printg("Documenting struct: \(name) to", file.path)
		XGUtility.saveString(CStruct, toFile: file)
	}
}

indirect enum GoDStructPropertyTypes {
	case uint // unsigned int (only positive values)
	case int // signed int (positive or negative values)
	case float, percentage, bool, bitMask, null
	case pokemonID, moveID, itemID, abilityID, natureID, genderID, typeID
	case moveCategory, typeEffectiveness, moveEffectID
	case genderRatio, expRate, evolutionMethod, moveTarget
	case battleBingoMysteryPanelType, contestAppeal, moveEffectType
	case trainerClassID, trainerModelID
	case pointerToProperty(file: XGFiles?, property: GoDStructProperties, offsetBy: Int), stringPointer(file: XGFiles?, offsetBy: Int)
	case indexOfEntryInTable(table: GoDStructTable, nameProperty: String?) // can use a single property as name or list whole struct if nil
	case fsysID, fsysFileIdentifier, fsysFileType
	case msgID(file: XGFiles?) // set file to nil to search through all available string tables
	case any

	case string, subStruct, array(type: GoDStructPropertyTypes)

	var isSigned: Bool {
		switch self {
		case .int: return true
		default: return false
		}
	}
}

indirect enum GoDStructProperties {
	case byte(name: String, description: String, type: GoDStructPropertyTypes)
	case short(name: String, description: String, type: GoDStructPropertyTypes)
	case word(name: String, description: String, type: GoDStructPropertyTypes)
	case float(name: String, description: String)
	case string(name: String, description: String, maxCharacterCount: Int, charLength: ByteLengths)
	case subStruct(name: String, description: String, property: GoDStruct)
	case array(name: String, description: String, property: GoDStructProperties, count: Int)
	case bitArray(name: String, description: String, bitFieldNames: [String?]) // first bit name in array is most significant bit (left most bit), nil for unused bits

	func alignmentBytes(at offset: Int) -> Int {
		switch self {
		case .subStruct(_, _, let properties):
			return properties.format.first?.alignmentBytes(at: offset) ?? 0
		case .array(_, _, let property, _):
			return property.alignmentBytes(at: offset)
		case .string(_, _, _, let charLength):
			return offset % charLength.rawValue
		case .bitArray:
				return 0
		default:
			return offset % length
		}
	}

	var length: Int {
		switch self {
		case .byte : return 1
		case .short: return 2
		case .word, .float: return 4
		case .bitArray(_, _, let names): return names.isEmpty ? 0 : (names.count - 1) / 8 + 1
		case .string(_, _, let maxLength, let charLength):
			return maxLength * charLength.rawValue
		case .subStruct(_, _, let properties):
			return properties.length
		case .array(_, _, let type, let count):
			return type.length * count
		}
	}

	var name: String {
		switch self {
		case .byte(let name, _, _),
			 .short(let name, _, _),
			 .word(let name, _, _),
			 .bitArray(let name, _, _),
			 .float(let name, _),
			 .string(let name, _, _, _),
			 .subStruct(let name, _, _),
			 .array(let name, _, _, _):
			return name
		}
	}

	var description: String {
		switch self {
		case .byte(_, let description, _),
			 .short(_, let description, _),
			 .word(_, let description, _),
			 .bitArray(_, let description, _),
			 .float(_, let description),
			 .string(_, let description, _, _),
			 .subStruct(_, let description, _),
			 .array(_, let description, _, _):
			return description
		}
	}

	var type: GoDStructPropertyTypes {
		switch self {
		case .byte(_, _, let type),
			 .short(_, _, let type),
			 .word(_, _, let type):
			return type
		case .bitArray:
			return .bool
		case .float:
			return .float
		case .string:
			return .string
		case .subStruct:
			return .subStruct
		case .array(_, _, let property, _):
			return .array(type: property.type)
		}
	}
}

indirect enum GoDStructValues: CustomStringConvertible {
	case value(property: GoDStructProperties, rawValue: Int)
	case float(property: GoDStructProperties, rawValue: Float)
	case string(property: GoDStructProperties, rawValue: String)
	case subStruct(property: GoDStructProperties, data: GoDStructData)
	case array(property: GoDStructProperties, rawValues: [GoDStructValues])
	case bitArray(property: GoDStructProperties, rawValues: [Bool])

	var property: GoDStructProperties {
		switch self {
		case .value(let property, _), .float(let property, _), .string(let property, _), .subStruct(let property, _), .array(let property, _), .bitArray(let property, _):
			return property
		}
	}

	func value<T>() -> T? {
		switch self {
		case .value(_, rawValue: let rawValue):
			return rawValue as? T
		case .float(_, rawValue: let rawValue):
			return rawValue as? T
		case .string(_, let rawValue):
			return rawValue as? T
		case .subStruct(_, let data):
			return data as? T
		case .array(_, rawValues: let values):
			let mappedValues: [Any] = values.map { $0.value()! }
			return mappedValues as? T
		case .bitArray(_, let rawValues):
			return rawValues as? T
		}
	}

	func withUpdatedRawValue(_ newValue: Any) -> GoDStructValues {
		switch self {
		case .value(let property, let rawValue):
			return .value(property: property, rawValue: (newValue as? Int) ?? rawValue)
		case .float(let property, let rawValue):
			return .float(property: property, rawValue: (newValue as? Float) ?? rawValue)
		case .string(let property, let rawValue):
			return .string(property: property, rawValue: (newValue as? String) ?? rawValue)
		case .subStruct(let property, let rawValue):
			return .subStruct(property: property, data: (newValue as? GoDStructData) ?? rawValue)
		case .array(let property, let rawValue):
			return .array(property: property, rawValues: (newValue as? [GoDStructValues]) ?? rawValue)
		case .bitArray(let property, let rawValues):
			return .bitArray(property: property, rawValues: (newValue as? [Bool]) ?? rawValues)
		}
	}

	func withUpdatedProperty(_ newValue: GoDStructProperties) -> GoDStructValues {
		switch self {
		case .value(_, let rawValue):
			return .value(property: newValue, rawValue: rawValue)
		case .float(_, let rawValue):
			return .float(property: newValue, rawValue: rawValue)
		case .string(_, let rawValue):
			return .string(property: newValue, rawValue: rawValue)
		case .subStruct(_, let rawValue):
			return .subStruct(property: newValue, data: rawValue)
		case .array(_, let rawValue):
			return .array(property: newValue, rawValues: rawValue)
		case .bitArray(_, let rawValues):
			return .bitArray(property: newValue, rawValues: rawValues)
		}
	}

	var description: String {
		switch self {
		case .value( let property, let rawValue):
			var valueString: String
			switch property.type {
			case .null:
				return "None (0)"
			case .percentage:
				return "\(rawValue)%"
			case .float:
				valueString = String(UInt32(rawValue & 0xFFFFFFFF).hexToSignedFloat())
			case .bool:
				valueString = "\(rawValue == 0)"
			case .bitMask:
				valueString = rawValue.binary()
			case .pokemonID:
				if rawValue == 0 {
					valueString = "None"
				} else {
					valueString = rawValue < kNumberOfPokemon ? XGPokemon.index(rawValue).name.unformattedString : "Pokemon_\(rawValue)"
				}
				valueString += " (\(rawValue))"
			case .moveID:
				if rawValue == 0 {
					valueString = "None (0)"
				} else {
					if rawValue >= 0x8000 {
						#if GAME_PBR
						 // Will be replaced by a random move either from it's level-up learnset or learnable TMs
						if let type = PBRRandomMoveType(rawValue: rawValue & 0xf),
						   let style = PBRRandomMoveStyle(rawValue: (rawValue >> 4) & 0xf) {
							valueString =  XGMoves.randomMove(style, type).name.string
							valueString += " (\(rawValue.hexString()))"
						} else {
							valueString = "Move_\(rawValue)"
							valueString += " (\(rawValue))"
						}
						#else
						valueString = "Move_\(rawValue)"
						valueString += " (\(rawValue))"
						#endif
					} else {
						valueString = rawValue < kNumberOfMoves ? XGMoves.index(rawValue).name.unformattedString : "Move_\(rawValue)"
						valueString += " (\(rawValue))"
					}
				}
			case .itemID:
				if rawValue == 0 {
					valueString = "None"
				} else {
					valueString = rawValue < kNumberOfItems ? XGItems.index(rawValue).name.unformattedString : "Item_\(rawValue)"
				}
				valueString += " (\(rawValue))"
			case .abilityID:
				if rawValue == 0 {
					valueString = "None"
				} else {
					valueString = rawValue < kNumberOfAbilities ? XGAbilities.index(rawValue).name.unformattedString : "Ability_\(rawValue)"
				}
				valueString += " (\(rawValue))"
			case .natureID:
				valueString = XGNatures(rawValue: rawValue)?.string ?? "Nature_\(rawValue)"
				valueString += " (\(rawValue))"
			case .genderID:
				valueString = XGGenders(rawValue: rawValue)?.string ?? "Gender_\(rawValue)"
				valueString += " (\(rawValue))"
			case .typeID:
				valueString = rawValue < kNumberOfTypes ? XGMoveTypes.index(rawValue).name : "Type_\(rawValue)"
				valueString += " (\(rawValue))"
			case .moveCategory:
				valueString = XGMoveCategories(rawValue: rawValue)?.string ?? "MoveCategory_\(rawValue)"
				valueString += " (\(rawValue))"
			case .typeEffectiveness:
				valueString = XGEffectivenessValues(rawValue: rawValue)?.string ?? "TypeEffectiveness_\(rawValue)"
				valueString += " (\(rawValue))"
			case .moveEffectID:
				if rawValue == 0 {
					valueString = "No effect"
				} else if let moveEffectNames = XGFiles.nameAndFolder("Move Effects.json", .JSON).json as? [String], rawValue < moveEffectNames.count {
					valueString = moveEffectNames[rawValue]
				} else {
					valueString = "MoveEffect_\(rawValue)"
				}
				valueString += " (\(rawValue))"
			case .trainerClassID:
				if rawValue == 0 {
					valueString = "None"
				} else {
					#if GAME_PBR
					valueString = "TrainerClass_\(rawValue)"
					#else
					valueString = XGTrainerClasses(rawValue: rawValue)?.name.string ?? "TrainerClass_\(rawValue)"
					#endif
				}
				valueString += " (\(rawValue))"
			case .trainerModelID:
				if rawValue == 0 {
					valueString = "None"
				} else {
					valueString = XGTrainerModels(rawValue: rawValue)?.name ?? "TrainerModel_\(rawValue)"
				}
				valueString += " (\(rawValue))"
			case .genderRatio:
				valueString = XGGenderRatios(rawValue: rawValue)?.string ?? "GenderRatio_\(rawValue)"
				valueString += " (\(rawValue))"
			case .expRate:
				valueString = XGExpRate(rawValue: rawValue)?.string ?? "ExpRate_\(rawValue)"
				valueString += " (\(rawValue))"
			case .evolutionMethod:
				valueString = XGEvolutionMethods(rawValue: rawValue)?.string ?? "EvolutionMethod_\(rawValue)"
				valueString += " (\(rawValue))"
			case .moveEffectType:
				valueString = XGMoveEffectTypes(rawValue: rawValue)?.string ?? "MoveEffectType_\(rawValue)"
				valueString += " (\(rawValue))"
			case .contestAppeal:
				valueString = XGContestCategories(rawValue: rawValue)?.name ?? "ContestAppeal_\(rawValue)"
				valueString += " (\(rawValue))"
			case .moveTarget:
				valueString = XGMoveTargets(rawValue: rawValue)?.string ?? "MoveTargets_\(rawValue)"
				valueString += " (\(rawValue))"
			case .battleBingoMysteryPanelType:
				#if !GAME_XD
				valueString = "MysteryPanelType_\(rawValue)"
				#else
				valueString = XGBattleBingoItem(rawValue: rawValue)?.name ?? "MysteryPanelType_\(rawValue)"
				#endif
				valueString += " (\(rawValue))"
			case .stringPointer(let file, let offsetBy):
				if let data = file?.data, data.length < rawValue + property.length {
					valueString = data.getStringAtOffset(rawValue + offsetBy)
				} else {
					valueString = (rawValue + offsetBy).hexString()
				}
				valueString += " (\(rawValue.hexString()))"
			case .pointerToProperty(let file, let property, let offsetBy):
				#warning("TODO: properly encode/decode these")
				if let data = file?.data, data.length < rawValue + property.length {
					switch property {
					case .subStruct(_, _, let properties):
						let subStruct = GoDStructData(properties: properties, fileData: data, startOffset: rawValue + offsetBy)
						if subStruct.values.count > 0 {
							valueString = "\(GoDStructValues.subStruct(property: property, data: subStruct))"
						} else {
							valueString = (rawValue + offsetBy).hexString()
						}
					default:
						let subStruct = GoDStructData(properties: GoDStruct(name: "", format: [property]), fileData: data, startOffset: rawValue + offsetBy)
						if subStruct.values.count > 0 {
							valueString = "\(subStruct.values[0])"
						} else {
							valueString = (rawValue + offsetBy).hexString()
						}
					}
				} else {
					valueString = (rawValue + offsetBy).hexString()
					valueString += " (\(rawValue.hexString()))"
				}
			case .indexOfEntryInTable(let table, let nameProperty):
				if let structData = table.dataForEntry(rawValue) {
					if let property = nameProperty {
						if let value = structData.valueForPropertyWithName(property) {
							valueString = value.description
						} else {
							valueString = "\(table.properties.name), index \(rawValue)"
						}
						valueString += " (\(rawValue))"
					} else {
						valueString = structData.description
					}
				} else {
					valueString = "\(table.properties.name), index \(rawValue)"
					valueString += " (\(rawValue))"
				}
			case .fsysID:
				if rawValue == 0 {
					valueString = "None"
				} else {
					valueString = XGISO.current.getFSYSNameWithGroupID(rawValue) ?? "Fsys file: \(rawValue)"
				}
				valueString += " (\(rawValue))"
			case .fsysFileIdentifier:
				if rawValue == 0 {
					valueString = "None"
				} else {
					if let fsys = XGISO.current.getFSYSForIdentifier(id: rawValue.unsigned),
					   let fileIndex = fsys.indexForIdentifier(identifier: rawValue) {
						valueString = fsys.fileName + " -> " + (fsys.fileNameForFileWithIndex(index: fileIndex) ?? "File_\(fileIndex)")
					} else {
						valueString = "FileIdentifier_\(rawValue.hexString())"
					}
				}
				valueString += " (\(rawValue.hexString()))"
			case .fsysFileType:
				if rawValue == 0 {
					valueString = "None"
				} else {
					valueString = XGFileTypes(rawValue: rawValue)?.fileExtension ?? "FileType_\(rawValue)"
				}
				valueString += " (\(rawValue))"
			case .msgID(let file):
				if rawValue == 0 {
					valueString = "None"
				} else if let stringTable = file?.stringTable {
					valueString = stringTable.stringWithID(rawValue)?.unformattedString ?? "\(stringTable.file.fileName) MsgID \(rawValue.hexString())"
				} else {
					valueString = getStringWithID(id: rawValue)?.unformattedString ?? "MsgID \(rawValue.hexString())"
				}
				valueString += " (\(rawValue))"
			case .any:
				valueString = "\(rawValue.hexString())"
			case .subStruct, .array, .string:
				valueString = "invalid struct specification"
			case .uint:
				valueString = "\(rawValue)"
			case .int:
				switch property.length {
				case 1:
					var value = rawValue & 0xFF
					if value > 0x7F {
						value -= 0x100
					}
					valueString = "\(value)"
				case 2:
					var value = rawValue & 0xFFFF
					if value > 0x7FFF {
						value -= 0x10000
					}
					valueString = "\(value)"
				case 4:
					var value = rawValue & 0xFFFFFFFF
					if value > 0x7FFFFFFF {
						value -= 0x100000000
					}
					valueString = "\(value)"
				default:
					assertionFailure("invalid value size")
					valueString = "invalid value"
				}
			}
			return valueString
		case .float(_, let rawValue):
			return "\(rawValue)"
		case .string(_, let rawValue):
			return "\(rawValue)"
		case .subStruct(_, let data):
			return data.description
		case .array(let property, let rawValues):
			if case .null = property.type {
				return ""
			}
			var text = ""
			let valuePrefix = "    - "
			rawValues.forEach { (value) in
				text += "\n" + valuePrefix
				let valueStrings = "\(value)".split(separator: "\n")
				var extraSpacing = false
				if case .subStruct = value.property.type {
					extraSpacing = true
				}
				if case .array = value.property.type {
					extraSpacing = true
				}
				valueStrings.forEachIndexed { (index, substring) in
					if index > 0 {
						text += "".addRepeated(s: " ", count: valuePrefix.length)
					}
					text += String(substring) + (extraSpacing ? "\n" : "")
				}
			}
			return text
		case .bitArray(let property, let rawValues):
			if case .bitArray(_, _, let bitNames) = property {
				var text = ""
				let valuePrefix = "    - "
				bitNames.forEachIndexed { (index, name) in
					if index < rawValues.count, name != nil {
						text += "\n" + valuePrefix + (name ?? "unused") + " : \(rawValues[index] ? "Yes" : "No")"
					}
				}
				return text
			} else {
				return "Invalid Bit array (\(property.name)"
			}
		}
	}
}
