//
//  StandardPropertyWrappers.swift
//  GoD Tool
//
//  Created by Stars Momodu on 20/02/2021.
//

import Foundation

@propertyWrapper
struct Boolean: Codable {
	var value: Int

	var wrappedValue: Int {
		get { return value }
		set { value = newValue == 0 ? 0 : 1 }
	}

	var projectedValue: Bool {
		return value != 0
	}

	init(wrappedValue value: Int) {
		self.value = value == 0 ? 0 : 1
	}
}

@propertyWrapper
struct UTF8String: Codable {
	var value: [Int]

	var wrappedValue: [Int] {
		get { return value }
		set { value = newValue }
	}

	var projectedValue: String {
		let data = XGMutableData(byteStream: value)
		return String(data: data.data, encoding: .utf8) ?? ""
	}

	init(wrappedValue value: [Int]) {
		self.value = value
	}
}

@propertyWrapper
struct UTF16String: Codable {
	var value: [Int]

	var wrappedValue: [Int] {
		get { return value }
		set { value = newValue }
	}

	var projectedValue: String {
		let data = XGMutableData(byteStream: value)
		return String(data: data.data, encoding: .utf16) ?? ""
	}

	init(wrappedValue value: [Int]) {
		self.value = value
	}
}

@propertyWrapper
struct BitMask: Codable {
	var value: Int
	var count: Int

	var wrappedValue: Int {
		get { return value }
		set { value = newValue }
	}

	var projectedValue: [Bool] {
		return value.bitArray(count: count)
	}

	init(wrappedValue value: Int, _ count: Int) {
		self.value = value
		self.count = count
	}
}
