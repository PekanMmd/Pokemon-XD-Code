//
//  GoDStructData.swift
//  GoD Tool
//
//  Created by Stars Momodu on 17/03/2021.
//

import Foundation

class GoDStructData: CustomStringConvertible {
	let fileData: XGMutableData
	let startOffset: Int
	var properties: GoDStruct
	private(set) var values: [GoDStructValues]

	static var null: GoDStructData {
		return GoDStructData()
	}

	static func staticString(_ value: String) -> GoDStructData {
		return staticValue(.string(property: .string(name: "", description: "", maxCharacterCount: 0, charLength: .char), rawValue: value))
	}

	static func staticValue(_ value: GoDStructValues) -> GoDStructData {
		return GoDStructData(startOffset: -1, properties: GoDStruct(name: "Set Value", format: [value.property]), values: [value])
	}

	init(fileData: XGMutableData = XGMutableData(),
				 startOffset: Int = 0,
				 properties: GoDStruct = .dummy,
				 values: [GoDStructValues] = []) {
		self.fileData = fileData
		self.startOffset = startOffset
		self.properties = properties
		self.values = values
	}

	init(properties: GoDStruct, fileData: XGMutableData, startOffset: Int) {
		self.fileData = fileData
		self.properties = properties
		self.startOffset = startOffset

		var currentOffset = startOffset
		func getValueForProperty(_ property: GoDStructProperties) -> GoDStructValues {
			guard currentOffset < fileData.length else {
				return .value(property: property, rawValue: -1)
			}
			switch property {
			case .subStruct(_, _, let properties):
				currentOffset += property.alignmentBytes(at: currentOffset)
				let startOffset = currentOffset
				currentOffset += properties.length
				return .subStruct(property: property, data: .init(properties: properties, fileData: fileData, startOffset: startOffset))

			case .array(_, _, let type, let entryCount):
				if let count = entryCount {
					let values = (0 ..< count).map { _ in
						return getValueForProperty(type)
					}
					return .array(property: property, rawValues: values)
				} else {
					currentOffset += property.alignmentBytes(at: currentOffset)
					var rawValues = [GoDStructValues]()
					
					while currentOffset < fileData.length - type.length {
						let nextValue = getValueForProperty(type)
						rawValues.append(nextValue)
						if case .pointer = type.type {
							let pointerValue: Int? = nextValue.rawValue()
							if pointerValue == nil || pointerValue == 0 {
								rawValues.removeLast()
								return .array(property: property, rawValues: rawValues)
							}
						} else if nextValue.rawValue() == 0 || nextValue.rawValue() == "" || nextValue.rawValue() == Float(0.0) {
							rawValues.removeLast()
							return .array(property: property, rawValues: rawValues)
						}

					}
					return .array(property: property, rawValues: rawValues)
				}
			case .float:
				currentOffset += property.alignmentBytes(at: currentOffset)
				let value = fileData.getWordAtOffset(currentOffset)
				currentOffset += property.length
				return .float(property: property, rawValue: value.hexToSignedFloat())

			case .string(_, _, let maxChars, let charLength):
				currentOffset += property.alignmentBytes(at: currentOffset)
				let string = fileData.getStringAtOffset(currentOffset, charLength: charLength, maxCharacters: maxChars)
				currentOffset += property.length
				return .string(property: property, rawValue: string)
			case .bitArray:
				currentOffset += property.alignmentBytes(at: currentOffset)
				let bytes = fileData.getByteStreamFromOffset(currentOffset, length: property.length)
				currentOffset += property.length
				var rawValues = [Bool]()
				bytes.forEach { (bitmask) in
					rawValues += bitmask.bitArray(count: 8, startWithLeastSignificantBit: false)
				}
				return .bitArray(property: property, rawValues: rawValues)
			case .bitMask(_, _, let length, let fields):
				currentOffset += property.alignmentBytes(at: currentOffset)
				let rawValue: Int
				switch length {
				case .char: rawValue = fileData.getByteAtOffset(currentOffset)
				case .short: rawValue = fileData.get2BytesAtOffset(currentOffset)
				case .word: rawValue = fileData.get4BytesAtOffset(currentOffset)
				}

				currentOffset += property.length
				var rawValues = [Int]()
				fields.forEach { (_, _, count, first, mod, div, scale) in
					var mask = 0
					for _ in 0 ..< count {
						mask = mask << 1
						mask += 1
					}
					let divValue = div == nil ? 1 : max(div!, 1)
					var newValue = ((rawValue >> first) & mask) / divValue * divValue
					if let modValue = mod {
						newValue = newValue % modValue
					}
					if let scaleValue = scale {
						newValue *= scaleValue
					}
					rawValues += [newValue]
				}
				return .bitMask(property: property, rawValues: rawValues)
			case .pointer(let subProperty, let offsetBy, _):
				currentOffset += property.alignmentBytes(at: currentOffset)
				let rawValue = fileData.get4BytesAtOffset(currentOffset) + offsetBy
				currentOffset += property.length

				guard rawValue != 0 else {
					return .pointer(property: property, rawValue: rawValue, value: GoDStructData.null)
				}
				guard  rawValue < fileData.length, rawValue > 0 else {
					return .pointer(property: property, rawValue: rawValue, value: GoDStructData.staticString("Error"))
				}
				let value = GoDStructData(properties: GoDStruct(name: subProperty.name, format: [subProperty]), fileData: fileData, startOffset: rawValue)
				return .pointer(property: property, rawValue: rawValue, value: value)
			case .vector:
				let x: Float = getValueForProperty(.float(name: "", description: "")).rawValue() ?? 0
				let y: Float = getValueForProperty(.float(name: "", description: "")).rawValue() ?? 0
				let z: Float = getValueForProperty(.float(name: "", description: "")).rawValue() ?? 0
				return .vector(property: property, rawValue: Vector3(v0: x, v1: y, v2: z))
			case .word, .short, .byte:
				currentOffset += property.alignmentBytes(at: currentOffset)
				let value: Int
				switch property.length {
				case 1: value = fileData.getByteAtOffset(currentOffset)
				case 2: value = fileData.get2BytesAtOffset(currentOffset)
				case 4: value = fileData.get4BytesAtOffset(currentOffset)
				default: assertionFailure("invalid property length: \(property.length)"); value = 0
				}
				currentOffset += property.length
				return .value(property: property, rawValue: value)
			}
		}

		values = properties.format.map { (property) in
			getValueForProperty(property)
		}
	}

	var description: String {
		guard values.count > 0 else {
			return "Null"
		}
		var text = "\n"
		values.forEach { (value) in
			if value.property.isNull {
				return
			}
			if let array: [Any] = value.value(), array.isEmpty {
				return
			} else {
				text += value.property.name + ": \(value)\n"
			}
		}
		return text
	}

	var flattenedValues: [GoDStructValues] {
		var flatValues = [GoDStructValues]()

		func flatten(values: [GoDStructValues]) {
			values.forEach { structValue in
				switch structValue.property {
				case .byte, .short,.word, .float, .string, .bitArray, .bitMask:
					flatValues.append(structValue)
				case .subStruct:
					if let data: GoDStructData = structValue.value() {
						flatten(values: data.values)
					}
				case .vector:
					if case .vector(let properties, let rawValue) = structValue {
						[rawValue.v0, rawValue.v1, rawValue.v2].forEach { (value) in
							flatten(values: [.float(property: .float(name: properties.name + ".x", description: ""), rawValue: value)])
						}
					}
				case .array:
					if case .array(_, let rawValues) = structValue {
						flatten(values: rawValues)
					}
				case .pointer:
					if case .pointer(let property, let rawValue, _) = structValue {
						flatten(values: [
							.value(property: .word(name: property.name, description: property.description, type: .pointer), rawValue: rawValue)
						])
					}
				}
			}
		}
		flatten(values: values)

		return flatValues
	}

	func flatten() {
		values = flattenedValues
		properties = properties.flattened
	}

	static func fromJSON(properties: GoDStruct, fileData: XGMutableData, startOffset: Int, jsonFile: XGFiles) -> GoDStructData? {
		guard jsonFile.exists else {
			printg("Couldn't decode json file: \(jsonFile.path)\nFile doesn't exist.")
			return nil
		}
		let jsonObject = jsonFile.json
		guard let jsonDict = jsonObject as? [String: Any] else {
			printg("Couldn't decode json file: \(jsonFile.path)\nInvalid json format.")
			return nil
		}

		return GoDStructData(properties: properties, fileData: fileData, startOffset: startOffset, jsonDict: jsonDict, originalFile: jsonFile)
	}

	private init?(properties: GoDStruct, fileData: XGMutableData, startOffset: Int, jsonDict: [String: Any], originalFile: XGFiles) {
		self.fileData = fileData
		self.properties = properties
		self.startOffset = startOffset

		var success = true
		var currentOffset = startOffset

		func loadProperties(_ properties: GoDStruct, fileData: XGMutableData, startOffset: Int, jsonDict: [String: Any], originalFile: XGFiles) -> [GoDStructValues] {
			var values = [GoDStructValues]()

			properties.format.forEach { property in
				guard let value = jsonDict[property.name] else {
					success = false
					printg("Couldn't decode json file: \(originalFile.path)\nMissing value for property: \(property.name).")
					return
				}
				currentOffset += property.alignmentBytes(at: currentOffset)
				switch property {
				case .byte, .short, .word, .pointer:
					guard let rawValue = value as? Int else {
						success = false
						printg("Couldn't decode json file: \(originalFile.path)\nInvalid integer number \(property.name) : \(value).")
						return
					}
					values.append(.value(property: property, rawValue: rawValue))
					currentOffset += property.length
				case .bitArray:
					guard let rawValues = value as? [Bool] else {
						success = false
						printg("Couldn't decode json file: \(originalFile.path)\nInvalid boolean values \(property.name) : \(value).")
						return
					}
					values.append(.bitArray(property: property, rawValues: rawValues))
					currentOffset += property.length
				case .vector:
					guard let fields = value as? [Float], fields.count == 3 else {
						success = false
						printg("Couldn't decode json file: \(originalFile.path)\nInvalid float vector values \(property.name) : \(value).")
						return
					}
					values.append(.vector(property: property, rawValue: Vector3(v0: fields[0], v1: fields[1], v2: fields[2])))
					currentOffset += property.length
				case .bitMask:
					guard let rawValues = value as? [Int] else {
						success = false
						printg("Couldn't decode json file: \(originalFile.path)\nInvalid integer values \(property.name) : \(value).")
						return
					}
					values.append(.bitMask(property: property, rawValues: rawValues))
					currentOffset += property.length
				case .float:
					guard let rawValue = value as? Float else {
						success = false
						printg("Couldn't decode json file: \(originalFile.path)\nInvalid decimal number \(property.name) : \(value).")
						return
					}
					values.append(.float(property: property, rawValue: rawValue))
					currentOffset += property.length
				case .string:
					guard let rawValue = value as? String else {
						success = false
						printg("Couldn't decode json file: \(originalFile.path)\nInvalid text string \(property.name) : \(value).")
						return
					}
					values.append(.string(property: property, rawValue: rawValue))
					currentOffset += property.length
				case .subStruct(_, _, let subProperties):
					guard let rawValue = value as? [String: Any] else {
						success = false
						printg("Couldn't decode json file: \(originalFile.path)\nInvalid dictionary \(property.name) : \(value).")
						return
					}
					guard let subStruct = GoDStructData(properties: subProperties, fileData: fileData, startOffset: currentOffset, jsonDict: rawValue, originalFile: originalFile) else {
						success = false
						return
					}
					values.append(.subStruct(property: property, data: subStruct))
				case .array(_, _, let subProperty, let count):
					guard let rawValue = value as? [Any] else {
						success = false
						printg("Couldn't decode json file: \(originalFile.path)\nInvalid array list \(property.name) : \(value).")
						return
					}
					guard rawValue.count == count else {
						success = false
						printg("Couldn't decode json file: \(originalFile.path)\nIncorrect array list length \(property.name) : \(value).")
						printg("Expected: \(count ?? 0), got: \(rawValue.count)")
						return
					}
					var arrayValues = [GoDStructValues]()
					rawValue.forEach {
						let addendum = loadProperties(GoDStruct(name: "", format: [subProperty]), fileData: fileData, startOffset: currentOffset, jsonDict: [subProperty.name : $0], originalFile: originalFile)
						guard addendum.count > 0 else {
							success = false
							return
						}
						arrayValues.append(addendum[0])
					}
					values.append(.array(property: property, rawValues: arrayValues))
				}
			}

			return values
		}

		self.values = loadProperties(properties, fileData: fileData, startOffset: startOffset, jsonDict: jsonDict, originalFile: originalFile)

		if !success {
			return nil
		}
	}

	static func fromCSV(properties: GoDStruct, fileData: XGMutableData, startOffset: Int, csvFile: XGFiles, row: Int) -> GoDStructData? {
		guard csvFile.exists else {
			printg("Couldn't decode csv file: \(csvFile.path)\nFile doesn't exist.")
			return nil
		}
		let text = csvFile.text

		return GoDStructData(properties: properties, fileData: fileData, startOffset: startOffset, csvText: text, originalFile: csvFile, row: row)
	}

	private init?(properties: GoDStruct, fileData: XGMutableData, startOffset: Int, csvText: String, originalFile: XGFiles, row: Int) {
		self.fileData = fileData
		self.properties = properties.flattened
		self.startOffset = startOffset

		let lines = csvText.replacingOccurrences(of: "\r", with: "").split(separator: "\n")
		let lineIndex = row + 1
		var line: String?
		if lineIndex < lines.count {
			line = String(lines[lineIndex])
		}

		var success = true

		func booleanRawValue(_ string: String) -> Bool? {
			switch string.lowercased() {
			case "true", "yes", "1": return true
			case "false", "no", "0": return false
			default: return nil
			}
		}

		func integerRawValue(_ string: String) -> Int? {
			if let booleanValue = booleanRawValue(string) {
				return booleanValue ? 1 : 0
			}
			if string.lowercased() == "null" {
				return 0
			}
			if let part = string.split(separator: " ").map({String($0)}).last {
				let unbracketed = part.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
				let stripped = unbracketed.simplifiedNumber // Removes % from percentage values, maybe other things added in future as well
				return stripped.integerValue
			}
			return nil
		}

		func splitCSV(_ csvText: String) -> [String] {
			var separatedValues = [String]()
			var currentValue = ""
			var ignoreCommas = false
			for character in csvText {
				switch character {
				case "\"":
					ignoreCommas.toggle()
				case ",":
					if !ignoreCommas {
						separatedValues.append(currentValue); currentValue = ""
					} else {
						fallthrough
					}
				default:
					currentValue += "\(character)"
				}
			}
			if currentValue.length > 0 {
				separatedValues.append(currentValue)
			}
			return separatedValues
		}

		func loadProperties(_ properties: GoDStruct, csvText: String) -> [GoDStructValues] {
			var values = [GoDStructValues]()
			var rawValuesWithName = splitCSV(csvText)
			// Remove First entry which is just the name added in front for convenience
			rawValuesWithName.removeFirst()
			let rawValues = rawValuesWithName.map{String($0)}.stack

			properties.format.forEach { property in
				guard !rawValues.isEmpty || property.length == 0 || property.type.isNull else {
					success = false
					printg("Couldn't decode csv file: \(originalFile.path) row: \(row). Invalid CSV data.")
					printg(csvText)
					return
				}

				switch property {
				case .byte, .short, .word, .pointer:
					if case .null = property.type {
						values.append(.value(property: property, rawValue: 0))
						return
					}

					let rawValueString = rawValues.pop()
					guard let rawValue = integerRawValue(rawValueString) else {
						printg("Couldn't decode csv file: \(originalFile.path) row: \(row). Invalid CSV data.")
						printg("Expected number, hex number or indexed value for property \(property.name). Got \(rawValueString).")
						printg("Expectation Examples: 150 | 0x96 | Mewtwo (150) | Mewtwo (0x96) ")
						printg(csvText)
						success = false
						return
					}
					if case .byteRange = property.type {
						let originalValue: Int
						if rawValue == 0 {
							originalValue = 0x80
						} else if rawValue > 0 {
							originalValue = Int(Double(rawValue) * 0x7F / 100) + 0x80
						} else {
							originalValue = 0x80 - Int(Double(rawValue.magnitude) * 0x80 / 100)
						}
						values.append(.value(property: property, rawValue: originalValue))
					} else {
						values.append(.value(property: property, rawValue: rawValue))
					}
				case .float:
					let rawValueString = rawValues.pop()
					guard let rawValue = Float(rawValueString) else {
						printg("Couldn't decode csv file: \(originalFile.path) row: \(row). Invalid CSV data.")
						printg("Expected decimal number value for property \(property.name). Got \(rawValueString).")
						printg("Expectation Examples: 12.345 ")
						printg(csvText)
						success = false
						return
					}
					values.append(.float(property: property, rawValue: rawValue))

				case .string:
					let rawValueString = rawValues.pop()
					values.append(.string(property: property, rawValue: rawValueString))

				case .bitArray(_, _, let bitFieldNames):
					var rawBools = [Bool]()
					bitFieldNames.forEach { name in
						guard name != nil else {
							// for unused bits assume they are unset
							rawBools.append(false)
							return
						}
						if !rawValues.isEmpty, let bitValue = booleanRawValue(rawValues.pop()) {
							rawBools.append(bitValue)
						} else {
							success = false
						}
					}
					values.append(.bitArray(property: property, rawValues: rawBools))
				case .bitMask(_, _, _, let bitFields):
					var rawInts = [Int]()
					bitFields.forEach {  fields in
						if !rawValues.isEmpty, let bitsValue = integerRawValue(rawValues.pop()) {
							rawInts.append(bitsValue)
						} else {
							success = false
						}
					}
					values.append(.bitMask(property: property, rawValues: rawInts))

				case .subStruct, .array, .vector:
					assertionFailure("Properties should be flattened before importing from csv")
					success = false
					return
				}
			}

			return values
		}

		guard let csvLine = line else {
			printg("Couldn't decode csv file: \(originalFile.path) row: \(row). Invalid CSV data.")
			printg("Not enough rows in data.")
			success = false
			return nil
		}

		self.values = loadProperties(properties.flattened, csvText: csvLine)

		if !success {
			return nil
		}
	}

	func valueForPropertyWithName(_ name: String) -> GoDStructValues? {
		return self.values.first { (value) -> Bool in
			switch value.property {
			case .pointer(let subProperty, _, _):
				return subProperty.name.simplified == name.simplified
			default:
				return value.property.name.simplified == name.simplified
			}
		}
	}

	func get<T>(_ name: String) -> T? {
		return valueForPropertyWithName(name)?.value()
	}

	func update(_ propertyName: String, with newRawValue: Any) {
		var updatedValues = [GoDStructValues]()
		values.forEach { (value) in
			if value.property.name == propertyName {
				updatedValues.append(value.withUpdatedRawValue(newRawValue))
			} else {
				updatedValues.append(value)
			}
		}
		values = updatedValues
	}

	func set(_ propertyName: String, to newValue: GoDStructValues) {
		guard values.contains(where: { (comparisonValue) -> Bool in
			comparisonValue.property.name == propertyName
		}) else {
			values.append(newValue)
			return
		}
		var updatedValues = [GoDStructValues]()
		values.forEach { (value) in
			if value.property.name == propertyName {
				updatedValues.append(newValue)
			} else {
				updatedValues.append(value)
			}
		}
		values = updatedValues
	}

	func save(writeData: Bool = true) {
		guard startOffset >= 0 else {
			if settings.verbose {
				printg("Couldn't save struct data at offset \(startOffset) to file:", fileData.file.path)
			}
			return
		}
		var currentOffset = startOffset
		var subDataToWrite = [(offset: Int, data: GoDStructData)]()
		func writeValue(_ value: GoDStructValues) {
			switch value {
			case .value(let property, let rawValue):
				currentOffset += value.property.alignmentBytes(at: currentOffset)
				switch property.length {
				case 1:
					var adjustedValue = rawValue
					if adjustedValue < -0x80 {
						adjustedValue = -0x80
					}
					if adjustedValue < 0 {
						adjustedValue += 0x100
					}
					adjustedValue = adjustedValue & 0xFF
					fileData.replaceByteAtOffset(currentOffset, withByte: adjustedValue)
				case 2:
					var adjustedValue = rawValue
					if adjustedValue < -0x8000 {
						adjustedValue = -0x8000
					}
					if adjustedValue < 0 {
						adjustedValue += 0x10000
					}
					adjustedValue = adjustedValue & 0xFFFF
					fileData.replace2BytesAtOffset(currentOffset, withBytes: adjustedValue)
				case 4:
					var adjustedValue = rawValue
					if adjustedValue < -0x80000000 {
						adjustedValue = -0x80000000
					}
					if adjustedValue < 0 {
						adjustedValue += 0x100000000
					}
					adjustedValue = adjustedValue & 0xFFFFFFFF
					fileData.replace4BytesAtOffset(currentOffset, withBytes: adjustedValue)
				default: assertionFailure("invalid property length: \(property.length)")
				}
				currentOffset += property.length

			case .float(let property, let rawValue):
				writeValue(.value(property: property, rawValue: rawValue.floatToHex().int))

			case .bitArray(_, let rawValues):
				var currentByte = 0
				var currentBitPosition = 0
				for value in rawValues {
					currentByte = currentByte << 1
					if value { currentByte = currentByte | 1 }
					currentBitPosition += 1
					if currentBitPosition == 8 {
						writeValue(.value(property: .byte(name: "", description: "", type: .uintHex), rawValue: currentByte))
						currentBitPosition = 0
						currentByte = 0
					}
				}
				if currentBitPosition > 0 {
					writeValue(.value(property: .byte(name: "", description: "", type: .uintHex), rawValue: currentByte))
				}

			case .bitMask(let property, let rawValues):
				var combinedValue = 0
				if case .bitMask(_, _, _, let fields) = property {
					fields.forEachIndexed { (index, field) in
						if index < rawValues.count {
							var rawValue = rawValues[index]
							var mask = 0
							for _ in 0 ..< field.numberOfBits {
								mask = mask << 1
								mask += 1
							}
							rawValue = rawValue & mask
							rawValue = rawValue << field.firstBitIndexLittleEndian
							combinedValue = combinedValue | rawValue
						}
					}
				}
				switch property.length {
				case 1: writeValue(.value(property: .byte(name: "", description: "", type: .uintHex), rawValue: combinedValue))
				case 2: writeValue(.value(property: .short(name: "", description: "", type: .uintHex), rawValue: combinedValue))
				case 4: writeValue(.value(property: .word(name: "", description: "", type: .uintHex), rawValue: combinedValue))
				default: assertionFailure("Invalid property length")
				}

			case .string(.string(_, _, let maxCharacterCount, let charLength), let rawValue):
				var string = rawValue.unicodeRepresentation
				if let max = maxCharacterCount {
					while string.count < max {
						string += [0]
					}
					while string.count > max {
						string.removeLast()
					}
				}
				for i in 0 ..< string.count {
					writeValue(.value(property: GoDStructProperties.string(name: "", description: "", maxCharacterCount: 1, charLength: charLength), rawValue: string[i]))
				}
			case .string:
				assertionFailure("invalid value type written to struct data")
				return

			case .subStruct(_, let data):
				data.values.forEach{ writeValue($0) }

			case .array(_, let rawValues):
				rawValues.forEach { writeValue($0) }

			case .vector(_, let rawValue):
				[rawValue.v0, rawValue.v1, rawValue.v2].forEach { (float) in
					writeValue(.float(property: .float(name: "", description: ""), rawValue: float))
				}

			case .pointer(.pointer(_, let offsetBy, _), let rawValue, let value):
				writeValue(.value(property: .word(name: "", description: "", type: .pointer), rawValue: rawValue - offsetBy))
				subDataToWrite.append((offset: rawValue, data: value))
			case .pointer:
				assertionFailure("invalid value type written to struct data")
				return
			}
		}
		values.forEach{ writeValue($0) }
		subDataToWrite.forEach { (offset, data) in
			data.save(writeData: false)
		}
		if writeData {
			fileData.save()
		}
	}

	func JSONString(useRawValue: Bool = true) -> String {
		func jsonStringForValues(_ values: [GoDStructValues], subStructName: String? = nil) -> String {
			var string = (subStructName != nil ? "\"\(subStructName!)\" : " : "")
			string += "{\n"
			values.forEachIndexed { (index, propertyValue) in
				switch propertyValue {
				case .value(let property, let rawValue), .pointer(let property, let rawValue, _):
					switch property.type {
					case .bool:
						string += "    \"\(property.name)\" : \(rawValue != 0),\n"
					default:
						string += "    \"\(property.name)\" : \(rawValue),\n"
					}

				case .float(let property, let rawValue):
					string += "    \"\(property.name)\" : \(rawValue),\n"

				case .string(let property, let rawValue):
					string += "    \"\(property.name)\" : \"\(rawValue)\",\n"

				case .bitArray(let property, let rawValues):
					string += "    \"\(property.name)\" : \(rawValues),\n"

				case .bitMask(let property, let rawValues):
					string += "    \"\(property.name)\" : \(rawValues),\n"

				case.vector(let property, let rawValue):
					let rawValueAsArray = [rawValue.v0, rawValue.v1, rawValue.v2]
					string += "    \"\(property.name)\" : \(rawValueAsArray),\n"

				case .subStruct(let property, let data):
					"\(jsonStringForValues(data.values, subStructName: property.name))".split(separator: "\n").forEach { (substring) in
						string += "    " + String(substring) + "\n"
					}
					string += ",\n"
				case .array(let property, let values):
					string += "    \"\(property.name)\" : [\n"
					values.forEach {
						switch $0 {
						case .value(_, let rawValue), .pointer(_, let rawValue, _):
							if useRawValue {
								string += "        \(rawValue),\n"
							} else {
								var value = $0.description.split(separator: "(").first ?? "-"
								while value.last == " " {
									value.removeLast()
								}
								if value.isEmpty { value = "-" }
								string += "        \"\(value)\",\n"
							}
						case .float(_, let rawValue):
							string += "        \(rawValue),\n"
						case .string(_, let rawValue):
							string += "        \"\(rawValue)\",\n"
						case .bitArray(let property, let rawValues):
							string += "    \"\(property.name)\" : \(rawValues),\n"
						case .bitMask(let property, let rawValues):
							string += "    \"\(property.name)\" : \(rawValues),\n"
						case.vector(let property, let rawValue):
							let rawValueAsArray = [rawValue.v0, rawValue.v1, rawValue.v2]
							string += "    \"\(property.name)\" : \(rawValueAsArray),\n"

						case .subStruct(_, let data):
							"\(jsonStringForValues(data.values))".split(separator: "\n").forEach { (substring) in
								string += "        " + String(substring) + "\n"
							}
							if let last = string.last, last == "\n" {
								string.removeLast()
							}
							string += ",\n"

						case .array(_, let rawValues):
							"\(jsonStringForValues(rawValues))".split(separator: "\n").forEach { (substring) in
								string += "        " + String(substring) + "\n"
							}
							if let last = string.last, last == "\n" {
								string.removeLast()
							}
							string += ",\n"
						}
					}
					if let last = string.last, last == "\n" {
						string.removeLast()
					}
					if let last = string.last, last == "," {
						string.removeLast()
					}
					string += "\n    ],\n"
				}
			}
			if let last = string.last, last == "\n" {
				string.removeLast()
			}
			if let last = string.last, last == "," {
				string.removeLast()
			}
			string += "\n}"
			return string
		}
		return jsonStringForValues(values)
	}

	func JSONData(useRawValue: Bool = true) -> Data? {
		return JSONString(useRawValue: useRawValue).data(using: .utf8)
	}

	func jsonObject(useRawValue: Bool = true) -> AnyObject? {
		if let data = JSONData(useRawValue: useRawValue) {
			let object = try? JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
			if object == nil {
				printg("Invalid JSON data for struct data")
			}
			return object
		} else {
			return [String: String]() as AnyObject
		}
	}
}
