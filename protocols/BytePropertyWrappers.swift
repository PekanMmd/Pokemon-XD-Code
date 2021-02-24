//
//  BytePropertyWrappers.swift
//  GoD Tool
//
//  Created by Stars Momodu on 04/02/2021.
//

import Foundation

@propertyWrapper
struct UnsignedByte: Codable {
	var value: Int

	var wrappedValue: Int {
		get { return value }
		set { value = newValue }
	}

	var projectedValue: UInt8 {
		return UInt8(value & 0xFF)
	}

	init(wrappedValue value: Int) {
		self.value = value
	}
}

@propertyWrapper
struct SignedByte: Codable {
	var value: Int

	var wrappedValue: Int {
		get { return value }
		set { value = newValue }
	}

	var projectedValue: Int8 {
		var signed = value
		while signed > 0x7F {
			signed = signed - 0x100
		}
		if signed < -0x80 {
			signed = -0x80
		}
		return Int8(signed)
	}

	init(wrappedValue value: Int) {
		self.value = value
	}
}

@propertyWrapper
struct UnsignedShort: Codable {
	var value: Int

	var wrappedValue: Int {
		get { return value }
		set { value = newValue }
	}

	var projectedValue: UInt16 {
		return UInt16(value & 0xFFFF)
	}

	init(wrappedValue value: Int) {
		self.value = value
	}
}

@propertyWrapper
struct SignedShort: Codable {
	var value: Int

	var wrappedValue: Int {
		get { return value }
		set { value = newValue }
	}

	var projectedValue: Int16 {
		var signed = value
		while signed > 0x7FFF {
			signed = signed - 0x10000
		}
		if signed < -0x8000 {
			signed = -0x8000
		}
		return Int16(signed)
	}

	init(wrappedValue value: Int) {
		self.value = value
	}
}

@propertyWrapper
struct UnsignedWord: Codable {
	var value: Int

	var wrappedValue: Int {
		get { return value }
		set { value = newValue }
	}

	var projectedValue: UInt32 {
		return UInt32(value & 0xFFFFFFFF)
	}

	init(wrappedValue value: Int) {
		self.value = value
	}
}

@propertyWrapper
struct SignedWord: Codable {
	var value: Int

	var wrappedValue: Int {
		get { return value }
		set { value = newValue }
	}

	var projectedValue: Int32 {
		var signed = value
		while signed > 0x7FFFFFFF {
			signed = signed - 0x100000000
		}
		if signed < -0x80000000 {
			signed = -0x80000000
		}
		return Int32(signed)
	}

	init(wrappedValue value: Int) {
		self.value = value
	}
}
