//
//  GoDCodable.swift
//  GoD Tool
//
//  Created by Stars Momodu on 18/02/2021.
//

import Foundation

indirect enum GoDStructProperties {
	case byte(name: String)
	case short(name: String)
	case word(name: String)
	case subStruct(name: String, properties: [GoDStructProperties])
	case array(name: String, type: GoDStructProperties, count: Int)

	func alignmentBytes(at offset: Int) -> Int {
		switch self {
		case .subStruct(_, let properties):
			return properties.first?.alignmentBytes(at: offset) ?? 0
		case .array(_, let type, _):
			switch type {
			case .array:
				printg("Data table with nested arrays unsupported")
				assertionFailure()
				return 0
			default:
				return type.alignmentBytes(at: offset)
			}
		default:
			return offset % length
		}
	}

	var length: Int {
		switch self {
		case .byte : return 1
		case .short: return 2
		case .word : return 4
		case .subStruct(_, let properties):
			return properties.length
		case .array(_, let type, let count):
			return type.length * count
		}
	}
}

extension Array where Element == GoDStructProperties {
	var length: Int {
		var total = 0

		self.forEach {
			total += $0.alignmentBytes(at: total)
			total += $0.length
		}

		if total % 2 != 0 {
			total += 1
		}
		return total
	}
}

indirect enum GoDStructValues {
	case byte(name: String, value: Int)
	case short(name: String, value: Int)
	case word(name: String, value: Int)
	case subStruct(name: String, values: [GoDStructValues])
	case array(name: String, values: [GoDStructValues])
}

protocol GoDCodableDataTable: Codable {
	var index: Int? { get set }
	static var properties: [GoDStructProperties] { get }
	static func propertyHasWrapper(name: String) -> Bool
	static func tableStartOffset(fileData: XGMutableData) -> Int
}

extension GoDCodableDataTable {
	static var entryLength: Int {
		return properties.length
	}
	static func startOffsetForIndex(_ index: Int, fileData: XGMutableData) -> Int {
		return tableStartOffset(fileData: fileData) + (index * entryLength)
	}

	static func propertyHasWrapper(name: String) -> Bool {
		return false
	}

	static func dataForEntry(withIndex index: Int, fileData: XGMutableData) -> XGMutableData? {
		let startOffset = startOffsetForIndex(index, fileData: fileData)
		guard startOffset + entryLength <= fileData.length else {
			return nil
		}
		let bytestream = fileData.getByteStreamFromOffset(startOffset, length: entryLength)
		return XGMutableData(byteStream: bytestream)
	}

	static func JSONStringForEntry(withData data: XGMutableData) -> String? {
		var currentOffset = 0
		func getValueForProperty(_ property: GoDStructProperties) -> GoDStructValues {
			currentOffset += property.alignmentBytes(at: currentOffset)
			switch property {
			case .byte(let name):
				let value = GoDStructValues.byte(name: name, value: data.getByteAtOffset(currentOffset))
				currentOffset += property.length
				return value
			case .short(let name):
				let value = GoDStructValues.short(name: name, value: data.get2BytesAtOffset(currentOffset))
				currentOffset += property.length
				return value
			case .word(let name):
				let value = GoDStructValues.word(name: name, value: data.get4BytesAtOffset(currentOffset))
				currentOffset += property.length
				return value

			case .subStruct(let name, let properties):
				let values = properties.map{ getValueForProperty($0) }
				return .subStruct(name: name, values: values)

			case .array(let name, let type, let count):
				let values = (0 ..< count).map { _ in
					return getValueForProperty(type)
				}
				return .array(name: name, values: values)
			}
		}

		func dictionaryStringForStruct(_ values: [GoDStructValues]) -> String {
			var string = "{"
			values.forEach { value in
				switch value {
				case .byte(let name, let value), .short(let name, let value), .word(let name, let value):
					var valueSubstring = "\(value)"
					if propertyHasWrapper(name: name) {
						valueSubstring = "{\"value\":\(value)}"
					}
					string += "\"\(name)\":\(valueSubstring),"

				case .subStruct(let name, let values):
					string += "\"\(name)\":\(dictionaryStringForStruct(values)),"

				case .array(let name, let values):
					var valuesString = "["
					values.forEach {
						switch $0 {
						case .byte(_,  let value), .short(_,  let value), .word(_,  let value):
							valuesString += "\(value),"
						case .subStruct(_, let values), .array(_, let values):
							valuesString += "\(dictionaryStringForStruct(values)),"
						}
					}
					if let last = valuesString.last, last == "," {
						valuesString.removeLast()
					}
					valuesString += "]"
					string += "\"\(name)\":\(valuesString),"
				}
			}
			if let last = string.last, last == "," {
				string.removeLast()
			}
			return string + "}"
		}

		let propertyValues = properties.map { getValueForProperty($0) }
		let json = dictionaryStringForStruct(propertyValues)
		return json
	}

	static func JSONDataForEntry(withData data: XGMutableData) -> Data? {
		guard let string = JSONStringForEntry(withData: data) else {
			return nil
		}
		return string.data(using: .utf8)
	}

	static func loadEntry(index: Int, fileData: XGMutableData) -> Self? {
		guard let entryData = dataForEntry(withIndex: index, fileData: fileData) else {
			return nil
		}
		guard let data = JSONDataForEntry(withData: entryData) else {
			return nil
		}

		var entry = try? fromJSON(data: data)
		entry?.index = index
		return entry
	}

	static func loadEntry(fromData entryData: XGMutableData) -> Self? {
		guard let data = JSONDataForEntry(withData: entryData) else {
			return nil
		}

		var entry = try? fromJSON(data: data)
		entry?.index = 0
		return entry
	}

	static func loadEntry(index: Int, file: XGFiles) -> Self? {
		guard let data = file.data else {
			return nil
		}
		return loadEntry(index: index, fileData: data)
	}

	func dataForEntry() -> XGMutableData? {
		let data = XGMutableData(byteStream: .init(repeating: 0, count: Self.entryLength))

		guard let jsonData = try? JSONRepresentation(),
			  let json = try? JSONSerialization.jsonObject(with: jsonData, options: []),
			  let dict = json as? [String: Any]
		else {
			return nil
		}

		var currentOffset = 0
		func writeProperties(_ properties: [GoDStructProperties], fromDictionary dict: [String: Any]) {
			properties.forEach { property in
				currentOffset += property.alignmentBytes(at: currentOffset)
				switch property {
				case .byte(let name):
					if Self.propertyHasWrapper(name: name) {
						if let subdict = dict[name] as? [String: Int], let value = subdict["value"] {
							var adjustedValue = value
							if adjustedValue < -0x80 {
								adjustedValue = -0x80
							}
							if adjustedValue < 0 {
								adjustedValue += 0x100
							}
							adjustedValue = adjustedValue & 0xFF
							data.replaceByteAtOffset(currentOffset, withByte: adjustedValue)
						}
					} else {
						if let value = dict[name] as? Int {
							var adjustedValue = value
							if adjustedValue < -0x80 {
								adjustedValue = -0x80
							}
							if adjustedValue < 0 {
								adjustedValue += 0x100
							}
							adjustedValue = adjustedValue & 0xFF
							data.replaceByteAtOffset(currentOffset, withByte: adjustedValue)
						}
					}
					currentOffset += property.length
				case .short(let name):
					if Self.propertyHasWrapper(name: name) {
						if let subdict = dict[name] as? [String: Int], let value = subdict["value"] {
							var adjustedValue = value
							if adjustedValue < -0x8000 {
								adjustedValue = -0x8000
							}
							if adjustedValue < 0 {
								adjustedValue += 0x10000
							}
							adjustedValue = adjustedValue & 0xFFFF
							data.replace2BytesAtOffset(currentOffset, withBytes: adjustedValue)
						}
					} else {
						if let value = dict[name] as? Int {
							var adjustedValue = value
							if adjustedValue < -0x8000 {
								adjustedValue = -0x8000
							}
							if adjustedValue < 0 {
								adjustedValue += 0x10000
							}
							adjustedValue = adjustedValue & 0xFFFF
							data.replace2BytesAtOffset(currentOffset, withBytes: adjustedValue)
						}
					}
					currentOffset += property.length
				case .word(let name):
					if Self.propertyHasWrapper(name: name) {
						if let subdict = dict[name] as? [String: Int], let value = subdict["value"] {
							var adjustedValue = value
							if adjustedValue < -0x80000000 {
								adjustedValue = -0x80000000
							}
							if adjustedValue < 0 {
								adjustedValue += 0x100000000
							}
							adjustedValue = adjustedValue & 0xFFFFFFFF
							data.replace4BytesAtOffset(currentOffset, withBytes: adjustedValue)
						}
					} else {
						if let value = dict[name] as? Int {
							var adjustedValue = value
							if adjustedValue < -0x80000000 {
								adjustedValue = -0x80000000
							}
							if adjustedValue < 0 {
								adjustedValue += 0x100000000
							}
							adjustedValue = adjustedValue & 0xFFFFFFFF
							data.replace4BytesAtOffset(currentOffset, withBytes: value)
						}
					}
					currentOffset += property.length

				case .subStruct(let name, let properties):
					if let subdict = dict[name] as? [String: Any] {
						writeProperties(properties, fromDictionary: subdict)
					} else {
						currentOffset += properties.length
					}

				case .array(let name, let type, let count):
					if let arrayValues = dict[name] as? [Any] {
						(0 ..< count).forEach {
							let subdict = ["name": arrayValues[$0]]
							switch type {
							case .byte: writeProperties([.byte(name: "name")], fromDictionary: subdict)
							case .short: writeProperties([.short(name: "name")], fromDictionary: subdict)
							case .word: writeProperties([.word(name: "name")], fromDictionary: subdict)

							case .subStruct(_, let properties):
								writeProperties([.subStruct(name: "name", properties: properties)], fromDictionary: subdict)
							case .array:
								printg("Data table with nested arrays unsupported")
								assertionFailure()
							}
						}

					}
				}
			}
		}

		writeProperties(Self.properties, fromDictionary: dict)
		return data
	}

	@discardableResult
	func saveEntry(toFile file: XGFiles, writeToDisc: Bool = true) -> Bool {
		if let fileData = file.data, let index = self.index, let data = dataForEntry() {
			let startOffset = Self.startOffsetForIndex(index, fileData: fileData)
			fileData.replaceData(data: data, atOffset: startOffset)
			if writeToDisc {
				return fileData.save()
			}
			return true
		}
		return false
	}
}
