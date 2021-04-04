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

	var largestAlignment: Int {
		var largestAlignment = 0

		format.forEach { (property) in
			switch property {
			case .byte, .short, .word, .float, .vector, .string, .bitArray, .bitMask, .array, .pointer:
				largestAlignment = max(largestAlignment, property.largestAlignment)
			case .subStruct(_, _, let subStruct):
				largestAlignment = max(largestAlignment, subStruct.largestAlignment)
			}
		}
		
		return largestAlignment
	}

	var length: Int {
		var total = 0

		format.forEach {
			let alignmentBytes = $0.alignmentBytes(at: total)
			total += alignmentBytes
			total += $0.length
		}

		if largestAlignment > 1 {
			while total % largestAlignment != 0 {
				total += 1
			}
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
				case .byte, .short,.word, .float, .string, .bitArray, .bitMask:
					flatProperties.append(property)
				case .pointer(let property, _, let isShort):
					if isShort {
						flatten(properties: [.short(name: property.name, description: property.description, type: .pointer)])
					} else {
						flatten(properties: [.word(name: property.name, description: property.description, type: .pointer)])
					}
				case .vector(let name, let description):
					flatten(properties: [
						.float(name: name + ".x", description: description),
						.float(name: name + ".y", description: description),
						.float(name: name + ".z", description: description)
					])
				case .subStruct(_, _, let structProperty):
					// The same property but with the name update to include the struct it is in
					let prefix = structProperty.name + " "
					flatProperties += structProperty.flattened.format.map{ (property) -> GoDStructProperties in
						switch property {
						case .byte(let name, let description, let type):
							return .byte(name: prefix + name, description: description, type: type)
						case .short(let name, let description, let type):
							return .short(name: prefix + name, description: description, type: type)
						case .word(let name, let description, let type):
							return .word(name: prefix + name, description: description, type: type)
						case .float(let name, let description):
							return .float(name: prefix + name, description: description)
						case .string(let name, let description, let maxCharacterCount, let charLength):
							return .string(name: prefix + name, description: description, maxCharacterCount: maxCharacterCount, charLength: charLength)
						case .subStruct(let name, let description, let property):
							let subProperty = GoDStruct(name: "\(prefix)\(structProperty.name)", format: property.format)
							return .subStruct(name: prefix + name, description: description, property: subProperty)
						case .array(let name, let description, let property, let count):
							return .array(name: prefix + name, description: description, property: property, count: count)
						case .bitArray(let name, let description, let bitFieldNames):
							return .bitArray(name: prefix + name, description: description, bitFieldNames: bitFieldNames)
						case .bitMask(let name, let description, let values):
							return .bitMask(name: prefix + name, description: description, values: values)
						case .vector(let name, let description):
							return .vector(name: prefix + name, description: description)
						case .pointer(_, _, let isShort):
							if isShort {
								return .short(name: prefix + property.name, description: property.description, type: .pointer)
							} else {
								return .word(name: prefix + property.name, description: property.description, type: .pointer)
							}
						}
					}
				case .array(let name, _, let property, let entryCount):
					// The same property but with the name update to include the array name and index
					if let count = entryCount {
						let propertyList = (0 ..< count).map { (index) -> GoDStructProperties in
							let subName = "\(name) \(index + 1)"
							switch property {
							case .byte(_, let description, let type):
								return .byte(name: subName, description: description, type: type)
							case .short(_, let description, let type):
								return .short(name: subName, description: description, type: type)
							case .word(_, let description, let type):
								return .word(name: subName, description: description, type: type)
							case .float(_, let description):
								return .float(name: subName, description: description)
							case .string(_, let description, let maxCharacterCount, let charLength):
								return .string(name: subName, description: description, maxCharacterCount: maxCharacterCount, charLength: charLength)
							case .subStruct(_, let description, let subProperty):
								let subProperty = GoDStruct(name: "\(property.name) \(index + 1)", format: subProperty.format)
								return .subStruct(name: subName, description: description, property: subProperty)
							case .array(_, let description, let property, let count):
								return .array(name: subName, description: description, property: property, count: count)
							case .bitArray(_, let description, let bitFieldNames):
								return .bitArray(name: subName, description: description, bitFieldNames: bitFieldNames)
							case .bitMask(_, let description, let values):
								return .bitMask(name: subName, description: description, values: values)
							case .vector(_, let description):
								return .vector(name: subName, description: description)
							case .pointer(_, _, let isShort):
								if isShort {
									return .short(name: subName, description: property.description, type: .pointer)
								} else {
									return .word(name: subName, description: property.description, type: .pointer)
								}
							}
						}
						flatten(properties: propertyList)
					} else {
						assertionFailure("Can't flatten an array without a fixed size")
						flatProperties.append(property)
					}
				}
			}
		}
		flatten(properties: format)

		return GoDStruct(name: name, format: flatProperties)
	}

	var CStruct: String {

		var subStructs = [(name: String, text: String)]()
		var string = "struct \(CStructName) {"

		func textForProperty(_ property: GoDStructProperties) -> String {
			switch property {
			case .byte(let name, _, let type):
				return (type.isSigned ? "int8_t " : "char ") + name.camelCaseBySpaces
			case .short(let name, _, let type):
				return (type.isSigned ? "int16_t " : "uint16_t ") + name.camelCaseBySpaces
			case .word(let name, _, let type):
				return (type.isSigned ? "int32_t " : "uint32_t ") + name.camelCaseBySpaces
			case .bitArray(let name, let description, _):
				return textForProperty(.array(name: name, description: description, property: .byte(name: "", description: "", type: .bitMask), count: property.length))
			case .bitMask(let name, let description, _):
				return textForProperty(.byte(name: name, description: description, type: .uintHex))
			case .float(let name, _):
				return "float " + name.camelCaseBySpaces
			case .vector(let name, let description):
				return textForProperty(.array(name: name, description: description, property: .float(name: "", description: ""), count: 3))
			case .string(let name, let description, let maxCharacterCount, let charLength):
				if let count = maxCharacterCount {
					switch charLength {
					case .char:
						return textForProperty(.array(name: name, description: description, property: .byte(name: "", description: "", type: .uintHex), count: count))
					case .short:
						return textForProperty(.array(name: name, description: description, property: .short(name: "", description: "", type: .uintHex), count: count))
					case .word:
						return textForProperty(.array(name: name, description: description, property: .word(name: "", description: "", type: .uintHex), count: count))
					}
				} else {
					return "char *" + name.camelCaseBySpaces
				}
			case .subStruct(let name, _, let property):
				if !subStructs.contains(where: { (name, _) -> Bool in
					name == property.CStructName
				}) {
					subStructs.append((property.CStructName, property.CStruct))
				}
				return "struct " +  property.CStructName.camelCaseBySpacesCapitalised + " " + name.camelCaseBySpaces
			case .array(let name, _, let property, let count):
				let subProperty: GoDStructProperties
				switch property {
				case .byte(_, let description, let type):
					subProperty = .byte(name: name, description: description, type: type)
				case .short(_, let description, let type):
					subProperty = .short(name: name, description: description, type: type)
				case .word(_, let description, let type):
					subProperty = .word(name: name, description: description, type: type)
				case .bitArray(_, let description, let bitFieldNames):
					subProperty = .bitArray(name: name, description: description, bitFieldNames: bitFieldNames)
				case .bitMask(_, let description, let bitFields):
					subProperty = .bitMask(name: name, description: description, values: bitFields)
				case .float(_, let description):
					subProperty = .float(name: name, description: description)
				case .string(_, let description, let maxCharacterCount, let charLength):
					subProperty = .string(name: name, description: description, maxCharacterCount: maxCharacterCount, charLength: charLength)
				case .subStruct(_, let description, let property):
					subProperty = .subStruct(name: name, description: description, property: property)
				case .vector(_, let description):
					subProperty = .vector(name: name, description: description)
				case .array(_, let description, let property, let count):
					subProperty = .array(name: name, description: description, property: property, count: count)
				case .pointer:
					subProperty = property
				}
				if let size = count {
					return textForProperty(subProperty) + "[\(size)]"
				} else {
					return textForProperty(.pointer(property: subProperty, offsetBy: 0, isShort: false))
				}
			case .pointer(let subProperty, _, let isShort):
				if isShort {
					return textForProperty(.short(name: subProperty.name + " Pointer", description: subProperty.description, type: .pointer))
				} else {
					var text = textForProperty(subProperty).split(separator: " ")
					text[text.count - 1] = "*" + text[text.count - 1]
					return text.joined(separator: " ")
				}
			}
		}
		format.forEach { (property) in
			let descriptionText = property.description.isEmpty ? "" : " // \(property.description)"
			string += "\n    " + textForProperty(property) + ";" + descriptionText
		}
		string += "\n};"

		var compoundedString = ""
		subStructs.forEach { (_, text) in
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
	case uint, uintHex // unsigned int (only positive values)
	case int // signed int (positive or negative values)
	case float, percentage, angle, bool, bitMask, null
	case pokemonID, moveID, itemID, abilityID, natureID, genderID, typeID
	case moveCategory, typeEffectiveness, moveEffectID, shininess
	case genderRatio, expRate, evolutionMethod, moveTarget
	case battleStyle, battleType, roomID, battleFieldID, deckID, trainerID
	case colosseumRound, playerController, itemPocket, scriptFunction(scriptFile: XGFiles)
	case battleBingoMysteryPanelType, contestAppeal, moveEffectType, eggGroup
	case trainerClassID, trainerModelID, interactionMethod, scriptMarker
	case indexOfEntryInTable(table: GoDStructTableFormattable, nameProperty: String?) // can use a single property as name or list whole struct if nil
	case fsysID, fsysFileIdentifier(fsysName: String?), fsysFileType
	case msgID(file: XGFiles?) // set file to nil to search through all available string tables
	case pkxTrainerID, pkxPokemonID
	case any

	case pointer, string, vector, subStruct, array(type: GoDStructPropertyTypes)

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
	case vector(name: String, description: String)
	case string(name: String, description: String, maxCharacterCount: Int?, charLength: ByteLengths) // char count doesn't include null byte, nil to read until null
	case subStruct(name: String, description: String, property: GoDStruct)
	case array(name: String, description: String, property: GoDStructProperties, count: Int?)
	case bitArray(name: String, description: String, bitFieldNames: [String?]) // first bit name in array is most significant bit (left most bit), nil for unused bits
	case bitMask(name: String, description: String, values: [(name: String, type: GoDStructPropertyTypes, numberOfBits: Int, firstBitIndexLittleEndian: Int)])
	case pointer(property: GoDStructProperties, offsetBy: Int, isShort: Bool)

	func alignmentBytes(at offset: Int) -> Int {
		switch self {
		case .subStruct(_, _, let properties):
			return properties.format.first?.alignmentBytes(at: offset) ?? 0
		case .array(_, _, let property, _):
			return property.alignmentBytes(at: offset)
		case .string(_, _, _, let charLength):
			return offset % charLength.rawValue
		case .vector:
			return 4
		case .bitArray, .bitMask:
				return 0
		default:
			var bytesToNextAlignment = length - (offset % length)
			if bytesToNextAlignment >= length {
				bytesToNextAlignment -= length
			}
			return bytesToNextAlignment
		}
	}

	var largestAlignment: Int {
		switch self {
		case .byte, .short, .word, .float, .pointer:
			return length
		case .string, .bitArray, .bitMask:
			return 1
		case .vector:
			return 4
		case .subStruct(_, _, let property):
			return property.largestAlignment
		case .array(_, _, let property, _):
			return property.largestAlignment
		}
	}

	var length: Int {
		switch self {
		case .byte, .bitMask : return 1
		case .short: return 2
		case .word, .float: return 4
		case .vector:
			return 12
		case .bitArray(_, _, let names): return names.isEmpty ? 0 : (names.count - 1) / 8 + 1
		case .string(_, _, let maxLength, let charLength):
			if let length = maxLength {
				return length * charLength.rawValue
			} else {
				return 1
			}
		case .subStruct(_, _, let properties):
			return properties.length
		case .array(_, _, let type, let count):
			return (type.length *? count) ?? 0
		case .pointer(_, _, let isShort):
			return isShort ? 2 : 4
		}
	}

	var name: String {
		switch self {
		case .byte(let name, _, _),
			 .short(let name, _, _),
			 .word(let name, _, _),
			 .bitArray(let name, _, _),
			 .bitMask(let name, _, _),
			 .float(let name, _),
			 .vector(let name, _),
			 .string(let name, _, _, _),
			 .subStruct(let name, _, _),
			 .array(let name, _, _, _):
			return name
		case .pointer(let property, _, _):
			return "Pointer->" + property.name
		}
	}

	var description: String {
		switch self {
		case .byte(_, let description, _),
			 .short(_, let description, _),
			 .word(_, let description, _),
			 .bitArray(_, let description, _),
			 .bitMask(_, let description, _),
			 .float(_, let description),
			 .vector(_, let description),
			 .string(_, let description, _, _),
			 .subStruct(_, let description, _),
			 .array(_, let description, _, _):
			return description
		case .pointer(let property, _, _):
			return property.description
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
		case .bitMask:
			return .uintHex
		case .float:
			return .float
		case .string:
			return .string
		case .vector:
			return .vector
		case .subStruct:
			return .subStruct
		case .array(_, _, let property, _):
			return .array(type: property.type)
		case .pointer(let property, _, _):
			return property.type
		}
	}

	var isNull: Bool {
		switch type {
		case .null: return true
		case .array(type: .null): return true
		default: return false
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
	case bitMask(property: GoDStructProperties, rawValues: [Int])
	case pointer(property: GoDStructProperties, rawValue: Int, value: GoDStructData)
	case vector(property: GoDStructProperties, rawValue: Vector3)

	var property: GoDStructProperties {
		switch self {
		case .value(let property, _), .float(let property, _), .string(let property, _), .subStruct(let property, _), .array(let property, _), .bitArray(let property, _), .bitMask(let property, _), .pointer(let property, _, _), .vector(let property, _):
			return property
		}
	}

	func value<T>() -> T? {
		switch self {
		case .value(property: .word(_, _, type: .pointer), 0),
			 .value(property: .short(_, _, type: .pointer), 0):
			return nil
		case .value(_, rawValue: let rawValue):
			return rawValue as? T
		case .float(_, rawValue: let rawValue):
			return rawValue as? T
		case .string(_, let rawValue):
			return rawValue as? T
		case .vector(_, let rawValue):
			return rawValue as? T
		case .subStruct(_, let data):
			return data as? T
		case .array(_, let values):
			let mappedValues: [Any] = values.map { $0.value() }
			return mappedValues as? T
		case .bitArray(let properties, let rawValues):
			if case .bitArray(_, _, let bitFieldNames) = properties, bitFieldNames.count == rawValues.count {
				var bitFieldsDict = [String: Bool]()
				(0 ..< bitFieldNames.count).forEach { (index) in
					if let name = bitFieldNames[index] {
						let value = rawValues[index]
						bitFieldsDict[name] = value
					}
				}
				if let results = bitFieldsDict as? T {
					return results
				}
			}
			return rawValues as? T
		case .bitMask(_, let rawValues):
			return rawValues as? T
		case .pointer(_, let rawValue, let value):
			guard rawValue > 0 else { return nil }
			return
				(value as? T) // the struct data being pointed to
				?? (value.values.count > 0 ? value.values[0].value() : nil) // or the actual individual value contained in that struct
		}
	}

	func rawValue<T>() -> T? {
		switch self {
		case .pointer(_, let rawValue, _):
			return rawValue as? T
		default:
			return value()
		}
	}

	func withUpdatedRawValue(_ newValue: Any) -> GoDStructValues {
		switch self {
		case .value(let property, let rawValue):
			return .value(property: property, rawValue: (newValue as? Int) ?? rawValue)
		case .float(let property, let rawValue):
			return .float(property: property, rawValue: (newValue as? Float) ?? rawValue)
		case .vector(let property, let rawValue):
			return .vector(property: property, rawValue: (newValue as? Vector3) ?? rawValue)
		case .string(let property, let rawValue):
			return .string(property: property, rawValue: (newValue as? String) ?? rawValue)
		case .subStruct(let property, let rawValue):
			return .subStruct(property: property, data: (newValue as? GoDStructData) ?? rawValue)
		case .array(let property, let rawValue):
			return .array(property: property, rawValues: (newValue as? [GoDStructValues]) ?? rawValue)
		case .bitArray(let property, let rawValues):
			return .bitArray(property: property, rawValues: (newValue as? [Bool]) ?? rawValues)
		case .bitMask(let property, let rawValues):
			return .bitMask(property: property, rawValues: (newValue as? [Int]) ?? rawValues)
		case .pointer(let property, let rawValue, let value):
			return .pointer(property: property, rawValue: newValue as? Int ?? rawValue, value: value)
		}
	}

	func withUpdatedProperty(_ newValue: GoDStructProperties) -> GoDStructValues {
		switch self {
		case .value(_, let rawValue):
			return .value(property: newValue, rawValue: rawValue)
		case .float(_, let rawValue):
			return .float(property: newValue, rawValue: rawValue)
		case .vector(_, let rawValue):
			return .vector(property: newValue, rawValue: rawValue)
		case .string(_, let rawValue):
			return .string(property: newValue, rawValue: rawValue)
		case .subStruct(_, let rawValue):
			return .subStruct(property: newValue, data: rawValue)
		case .array(_, let rawValue):
			return .array(property: newValue, rawValues: rawValue)
		case .bitArray(_, let rawValues):
			return .bitArray(property: newValue, rawValues: rawValues)
		case .bitMask(_, let rawValues):
			return .bitMask(property: newValue, rawValues: rawValues)
		case .pointer(_, let rawValue, let value):
			return .pointer(property: property, rawValue: rawValue, value: value)
		}
	}

	var description: String {
		switch self {
		case .value(let property, let rawValue):
			var valueString: String
			switch property.type {
			case .null:
				return "None (0)"
			case .percentage:
				return "\(rawValue)%"
			case .angle:
				return "\(rawValue)°"
			case .float:
				valueString = String(UInt32(rawValue & 0xFFFFFFFF).hexToSignedFloat())
			case .vector:
				valueString = "\(rawValue.hexString())"
			case .bool:
				valueString = "\(rawValue != 0)"
			case .bitMask:
				valueString = rawValue.binary()
				valueString += " (\(rawValue))"
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
				} else if game == .Colosseum, rawValue >= 0x8000 || rawValue < 0 {
					valueString = "Random (\(rawValue.hexString()))"
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
			case .shininess:
				valueString = XGShinyValues(rawValue: rawValue)?.string ?? "ShinyValue_\(rawValue)"
				valueString += " (\(rawValue.hexString()))"
			case .moveEffectID:
				if rawValue == 0 {
					valueString = "No effect"
				} else if let moveEffectNames = XGFiles.nameAndFolder("Move Effects.json", .JSON).json as? [String], rawValue < moveEffectNames.count {
					valueString = "\"" + moveEffectNames[rawValue] + "\""
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
					valueString = XGTrainerClasses(rawValue: rawValue)?.name.unformattedString ?? "TrainerClass_\(rawValue)"
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
			case .eggGroup:
				valueString = XGEggGroups(rawValue: rawValue)?.name ?? "EggGroup_\(rawValue)"
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
			case .battleStyle:
				#if !GAME_COLO
				valueString = XGBattleStyles(rawValue: rawValue)?.name ?? "BattleStyle_\(rawValue)"
				valueString += " (\(rawValue))"
				#else
				let table = battleStylesTable
				valueString = "\(table.assumedNameForEntry(index: rawValue)) (\(rawValue))"
				#endif
			case .battleType:
				#if !GAME_PBR
				valueString = XGBattleTypes(rawValue: rawValue)?.name ?? "BattleType_\(rawValue)"
				valueString += " (\(rawValue))"
				#else
				valueString = "(\(rawValue))"
				#endif
			case .colosseumRound:
				#if !GAME_PBR
				valueString = XGColosseumRounds(rawValue: rawValue)?.name ?? "ColosseumRound_\(rawValue)"
				valueString += " (\(rawValue))"
				#else
				valueString = "(\(rawValue))"
				#endif
			case .itemPocket:
				#if !GAME_PBR
				valueString = XGBagSlots(rawValue: rawValue)?.name ?? "ItemPocket_\(rawValue)"
				valueString += " (\(rawValue))"
				#else
				valueString = "(\(rawValue))"
				#endif
			case .roomID:
				#if !GAME_PBR
				valueString = rawValue == 0 ? "None" : (XGRoom.roomWithID(rawValue)?.name ?? "Room_\(rawValue)")
				valueString += " (\(rawValue))"
				#else
				valueString = "(\(rawValue))"
				#endif
			case .battleFieldID:
				#if !GAME_PBR
				valueString = XGBattleField(index: rawValue).room?.name ?? "Room_\(rawValue)"
				valueString += " (\(rawValue))"
				#else
				valueString = "(\(rawValue))"
				#endif
			case .deckID:
				#if !GAME_PBR
				if rawValue > 0 {
				valueString = XGDecks.deckWithID(rawValue)?.fileName ?? "Deck_\(rawValue)"
				} else {
					valueString = "None"
				}
				valueString += " (\(rawValue))"
				#else
				valueString = "(\(rawValue))"
				#endif
			case .playerController:
				#if !GAME_PBR
				valueString = XGTrainerController(rawValue: rawValue)?.string ?? "Player_\(rawValue)"
				valueString += " (\(rawValue))"
				#else
				valueString = "(\(rawValue))"
				#endif
			case .interactionMethod:
				#if !GAME_PBR
				valueString = XGInteractionMethods(rawValue: rawValue)?.name ?? "InteractionMethod_\(rawValue)"
				valueString += " (\(rawValue))"
				#else
				valueString = "(\(rawValue))"
				#endif
			case .scriptMarker:
				switch rawValue {
				case 0x100: valueString = "Current Script"
				case 0x596: valueString = "Common Script"
				default: valueString = "Script_\(rawValue.hexString())"
				}
				valueString += " (\(rawValue.hexString()))"
			case .scriptFunction(let scriptFile):
				let scriptData = scriptFile.scriptData
				if rawValue < scriptData.ftbl.count {
					let ftblEntry = scriptData.ftbl[rawValue]
					valueString = "\(scriptFile.fileName) Script -> " + ftblEntry.name + " (\(rawValue))"
				} else {
					valueString = "\(scriptFile.fileName) Script -> Function \(rawValue) (\(rawValue.hexString()))"
				}
			case .battleBingoMysteryPanelType:
				#if !GAME_XD
				valueString = "MysteryPanelType_\(rawValue)"
				#else
				valueString = XGBattleBingoItem(rawValue: rawValue)?.name ?? "MysteryPanelType_\(rawValue)"
				#endif
				valueString += " (\(rawValue))"
			case .trainerID:
				#if GAME_COLO
				if rawValue == 0 {
					valueString = "None (\(rawValue))"
				} else if rawValue < CommonIndexes.NumberOfTrainers.value {
					valueString = XGTrainer(index: rawValue).name.unformattedString
					valueString += " (\(rawValue))"
				} else {
					valueString = "(\(rawValue))"
				}
				#else
				valueString = "(\(rawValue))"
				#endif
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
						let name = table.assumedNameForEntry(index: rawValue)
						valueString = "\(name) (\(rawValue))"
					}
				} else {
					let name = table.assumedNameForEntry(index: rawValue)
					valueString = "\(name) (\(rawValue))"
				}
			case .fsysID:
				if rawValue == 0 {
					valueString = "None"
				} else {
					valueString = XGISO.current.getFSYSNameWithGroupID(rawValue) ?? "Fsys file: \(rawValue)"
				}
				valueString += " (\(rawValue))"
			case .fsysFileIdentifier(let fsysName):
				if rawValue == 0 {
					valueString = "None"
				} else {
					var fileFound = false
					let mainIdentifier = rawValue & 0xFFFFFF00 // remove last byte so .rdat models can be found without their subIndex
					valueString = ""
					if let fsysFileName = fsysName, fsysFileName.length > 0 {
						let fsysFile = XGFiles.fsys(fsysFileName.removeFileExtensions()).fsysData
						if let fileIndex = fsysFile.indexForIdentifier(identifier: mainIdentifier) {
							fileFound = true
							valueString = fsysFile.fileName + " -> " + (fsysFile.fileNameForFileWithIndex(index: fileIndex) ?? "File_\(fileIndex)")
						}
					}
					if !fileFound, let fsys = XGISO.current.getFSYSForIdentifier(id: rawValue.unsigned),
					   let fileIndex = fsys.indexForIdentifier(identifier: mainIdentifier) {
						fileFound = true
						valueString = fsys.fileName + " -> " + (fsys.fileNameForFileWithIndex(index: fileIndex) ?? "File_\(fileIndex)")
					} else if !fileFound {
						valueString = "FileIdentifier_\(rawValue.hexString())"
					}
				}
				if valueString.length > 0 {
					valueString += " "
				}
				valueString += "(\(rawValue.hexString()))"
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
					valueString = "\"" + (stringTable.stringWithID(rawValue)?.unformattedString ?? getStringWithID(id: rawValue)?.unformattedString ?? "MsgID \(rawValue.hexString())") + "\""
				} else {
					valueString = "\"" + (getStringWithID(id: rawValue)?.unformattedString ?? "MsgID \(rawValue.hexString())") + "\""
				}
				valueString += " (\(rawValue.hexString()))"
			case .pkxTrainerID:
				#if GAME_PBR
				valueString = "(\(rawValue))"
				#else
				let table = pkxTrainerModelsTable
				valueString = "\(table.assumedNameForEntry(index: rawValue)) \(rawValue)"
				#endif
			case .pkxPokemonID:
				#if GAME_PBR
				valueString = "(\(rawValue))"
				#else
				let table = pkxPokemonModelsTable
				valueString = "\(table.assumedNameForEntry(index: rawValue)) (\(rawValue))"
				#endif
			case .any:
				valueString = "\(rawValue.hexString())"
			case .subStruct, .array, .string:
				valueString = "invalid struct specification"
			case .uintHex:
				valueString = "\(rawValue)"
				valueString += " (\(rawValue.hexString()))"
			case .uint:
				valueString = "\(rawValue)"
			case .pointer:
				if rawValue == 0 {
					valueString = "Null"
				} else {
					valueString = "\(rawValue.hexString())"
				}
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
			return "\"\(rawValue)\""
		case .subStruct(_, let data):
			return data.description
		case .array(let property, let rawValues):
			if case .null = property.type {
				return ""
			}
			if rawValues.isEmpty {
				return "\n-"
			}
			var text = ""
			let valuePrefix = "  - "
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
				if case .pointer = value.property.type {
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
		case .bitMask(let property, let rawValues):
			if case .bitMask(_, _, let bitFields) = property {
				var text = ""
				let valuePrefix = "    - "
				bitFields.forEachIndexed { (index, field) in
					if index < rawValues.count {
						let value = GoDStructValues.value(property: GoDStructProperties.byte(name: field.name, description: "", type: field.type), rawValue: rawValues[index]).description
						text += "\n" + valuePrefix + field.name + " : \(value)"
					}
				}
				return text
			} else {
				return "Invalid Bit array (\(property.name)"
			}
		case .vector(_, let rawValue):
			return "<\(rawValue.v0), \(rawValue.v1), \(rawValue.v2)>"
		case .pointer(_, let rawValue, let value):
			let valuePrefix = " -> "
			var text = "@\(rawValue.hexString())\n" + valuePrefix
			let valueStrings = "\(value)".split(separator: "\n")
			valueStrings.forEachIndexed { (index, substring) in
				if index > 0 {
					text += "".addRepeated(s: " ", count: valuePrefix.length)
				}
				text += String(substring) + "\n"
			}
			return text
		}
	}
}
