//
//  GoDStructData.swift
//  GoD Tool
//
//  Created by Stars Momodu on 17/03/2021.
//

import Foundation

class GoDStructData: CustomStringConvertible {
	var fileData: XGMutableData
	let startOffset: Int
	private let properties: GoDStruct
	private(set) var values: [GoDStructValues]

	subscript(_ name: String) -> GoDStructValues? {
		return valueForPropertyWithName(name)
	}

	init(properties: GoDStruct, fileData: XGMutableData, startOffset: Int) {
		self.fileData = fileData
		self.properties = properties
		self.startOffset = startOffset

		var currentOffset = startOffset
		func getValueForProperty(_ property: GoDStructProperties) -> GoDStructValues {
			switch property {
			case .subStruct(_, _, let properties):
				currentOffset += property.alignmentBytes(at: currentOffset)
				let startOffset = currentOffset
				currentOffset += properties.length
				return .subStruct(property: property, data: .init(properties: properties, fileData: fileData, startOffset: startOffset))

			case .array(_, _, let type, let count):
				let values = (0 ..< count).map { _ in
					return getValueForProperty(type)
				}
				return .array(property: property, rawValues: values)
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

			default:
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

	static func fromJSON(properties: GoDStruct, fileData: XGMutableData, startOffset: Int, jsonFile: XGFiles) -> GoDStructData? {
		guard jsonFile.exists else {
			printg("Couldn't encode json file: \(jsonFile.path)\nFile doesn't exist.")
			return nil
		}
		let jsonObject = jsonFile.json
		guard let jsonDict = jsonObject as? [String: Any] else {
			printg("Couldn't encode json file: \(jsonFile.path)\nInvalid json format.")
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
					printg("Couldn't encode json file: \(originalFile.path)\nMissing value for property: \(property.name).")
					return
				}
				currentOffset += property.alignmentBytes(at: currentOffset)
				switch property {
				case .byte, .short, .word:
					guard let rawValue = value as? Int else {
						success = false
						printg("Couldn't encode json file: \(originalFile.path)\nInvalid integer number \(property.name) : \(value).")
						return
					}
					values.append(.value(property: property, rawValue: rawValue))
					currentOffset += property.length
				case .float:
					guard let rawValue = value as? Float else {
						success = false
						printg("Couldn't encode json file: \(originalFile.path)\nInvalid decimal number \(property.name) : \(value).")
						return
					}
					values.append(.float(property: property, rawValue: rawValue))
					currentOffset += property.length
				case .string:
					guard let rawValue = value as? String else {
						success = false
						printg("Couldn't encode json file: \(originalFile.path)\nInvalid text string \(property.name) : \(value).")
						return
					}
					values.append(.string(property: property, rawValue: rawValue))
					currentOffset += property.length
				case .subStruct(_, _, let subProperties):
					guard let rawValue = value as? [String: Any] else {
						success = false
						printg("Couldn't encode json file: \(originalFile.path)\nInvalid dictionary \(property.name) : \(value).")
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
						printg("Couldn't encode json file: \(originalFile.path)\nInvalid array list \(property.name) : \(value).")
						return
					}
					guard rawValue.count == count else {
						success = false
						printg("Couldn't encode json file: \(originalFile.path)\nIncorrect array list length \(property.name) : \(value).")
						printg("Expected: \(count), got: \(rawValue.count)")
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

	var description: String {
		var text = "\n"
		values.forEach { (value) in
			if case .null = value.property.type {
				return
			}
			text += value.property.name + " : \(value)\n"
		}
		return text
	}

	func valueForPropertyWithName(_ name: String) -> GoDStructValues? {
		return self.values.first { (value) -> Bool in
			value.property.name == name
		}
	}

	func rawValueForPropertyWithName<T>(_ name: String) -> T? {
		return valueForPropertyWithName(name)?.value()
	}

	func setRawValue(_ newValue: Any, forPropertyWithName name: String) {
		var updatedValues = [GoDStructValues]()
		values.forEach { (value) in
			if value.property.name == name {
				updatedValues.append(value.withUpdatedRawValue(newValue))
			} else {
				updatedValues.append(value)
			}
		}
		values = updatedValues
	}

	func save(writeData: Bool = true) {
		var currentOffset = startOffset
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

			case .string(.string(_, _, let maxCharacterCount, let charLength), let rawValue):
				var string = rawValue.unicodeRepresentation
				while string.count < maxCharacterCount {
					string += [0]
				}
				for i in 0 ..< min(maxCharacterCount * charLength.rawValue, string.count) {
					writeValue(.value(property: GoDStructProperties.string(name: "", description: "", maxCharacterCount: 1, charLength: charLength), rawValue: string[i]))
				}

			case .subStruct(_, let data):
				data.values.forEach{ writeValue($0) }

			case .array(_, let rawValues):
				rawValues.forEach { writeValue($0) }

			default:
				assertionFailure("invalid value type written to struct data")
				return

			}
		}
		values.forEach{ writeValue($0) }
		if writeData {
			fileData.save()
		}
	}

	func JSONString() -> String {
		func dictionaryStringForStruct(_ values: [GoDStructValues], subStructName: String? = nil) -> String {
			var string = (subStructName != nil ? "\"\(subStructName!)\" : " : "")
			string += "{\n"
			values.forEachIndexed { (index, propertyValue) in
				switch propertyValue {
				case .value(let property, let rawValue):
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

				case .subStruct(let property, let data):
					"\(dictionaryStringForStruct(data.values, subStructName: property.name))".split(separator: "\n").forEach { (substring) in
						string += "    " + String(substring) + "\n"
					}
					string += ",\n"
				case .array(let property, let values):
					string += "    \"\(property.name)\" : [\n"
					values.forEach {
						switch $0 {
						case .value(_, let rawValue):
							string += "        \(rawValue),\n"
						case .float(_, let rawValue):
							string += "        \(rawValue),\n"
						case .string(_, let rawValue):
							string += "        \"\(rawValue)\",\n"
						case .subStruct(_, let data):
							"\(dictionaryStringForStruct(data.values))".split(separator: "\n").forEach { (substring) in
								string += "        " + String(substring) + "\n"
							}
							if let last = string.last, last == "\n" {
								string.removeLast()
							}
							string += ",\n"

						case .array:
							assertionFailure("invalid sub array")
							string += "invalid sub array\n"
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
		return dictionaryStringForStruct(values)
	}

	func JSONData() -> Data? {
		return JSONString().data(using: .utf8)
	}
}
