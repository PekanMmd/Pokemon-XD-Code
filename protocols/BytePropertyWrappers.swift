//
//  BytePropertyWrappers.swift
//  GoD Tool
//
//  Created by Stars Momodu on 04/02/2021.
//

import Foundation

@propertyWrapper
struct UnsignedByte {
	var _value: UInt8

	var wrappedValue: UInt8 {
		get { return _value }
		set { _value = newValue }
	}

	var projectedValue: Int {
		return Int(_value)
	}

	init(wrappedValue value: UInt8) {
		_value = value
	}
}

@propertyWrapper
struct SignedByte {
	var _value: UInt8

	var wrappedValue: UInt8 {
		get { return _value }
		set { _value = newValue }
	}

	var projectedValue: Int {
		var signed = Int(_value)
		if signed > 0x7F {
			signed = signed - 0x100
		}
		return signed
	}

	init(wrappedValue value: UInt8) {
		_value = value
	}
}

@propertyWrapper
struct UnsignedShort {
	var _value: UInt16

	var wrappedValue: UInt16 {
		get { return _value }
		set { _value = newValue }
	}

	var projectedValue: Int {
		return Int(_value)
	}

	init(wrappedValue value: UInt16) {
		_value = value
	}
}

@propertyWrapper
struct SignedShort {
	var _value: UInt16

	var wrappedValue: UInt16 {
		get { return _value }
		set { _value = newValue }
	}

	var projectedValue: Int {
		var signed = Int(_value)
		if signed > 0x7FFF {
			signed = signed - 0x10000
		}
		return signed
	}

	init(wrappedValue value: UInt16) {
		_value = value
	}
}

@propertyWrapper
struct UnsignedWord {
	var _value: UInt32

	var wrappedValue: UInt32 {
		get { return _value }
		set { _value = newValue }
	}

	var projectedValue: Int {
		return Int(_value)
	}

	init(wrappedValue value: UInt32) {
		_value = value
	}
}

@propertyWrapper
struct SignedWord {
	var _value: UInt32

	var wrappedValue: UInt32 {
		get { return _value }
		set { _value = newValue }
	}

	var projectedValue: Int {
		return _value.int32
	}

	init(wrappedValue value: UInt32) {
		_value = value
	}
}
