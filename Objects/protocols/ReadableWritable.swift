//
//  ReadableWritable.swift
//  GoD Tool
//
//  Created by Stars Momodu on 28/10/2021.
//

import Foundation

typealias GoDReadWritable = GoDReadable & GoDWritable

protocol GoDReadable {
	func read(atAddress address: UInt, length: UInt) -> XGMutableData?
}

protocol GoDWritable {
	@discardableResult
	func write(_ data: XGMutableData, atAddress address: UInt) -> Bool
}

extension GoDReadable {
	func read(atAddress address: Int, length: Int) -> XGMutableData? {
		return read(atAddress: UInt(address), length: UInt(length))
	}

	func readByte(atAddress address: Int) -> Int? {
		return read(atAddress: address, length: 1)?.getByteAtOffset(0)
	}

	func read2Bytes(atAddress address: Int) -> Int? {
		return read(atAddress: address, length: 2)?.get2BytesAtOffset(0)
	}

	func read4Bytes(atAddress address: Int) -> Int? {
		return read(atAddress: address, length: 4)?.get4BytesAtOffset(0)
	}

	func readChar(atAddress address: Int) -> UInt8? {
		return read(atAddress: address, length: 1)?.getCharAtOffset(0)
	}

	func readShort(atAddress address: Int) -> UInt16? {
		return read(atAddress: address, length: 2)?.getHalfAtOffset(0)
	}

	func readWord(atAddress address: Int) -> UInt32? {
		return read(atAddress: address, length: 4)?.getWordAtOffset(0)
	}

	func readString(atAddress address: Int, charLength: ByteLengths = .char, maxCharacters: Int? = nil) -> String {
		var currentOffset = address

		var currChar: Int? = 0x0
		var nextChar: Int? = 0x1
		var characterCounter = 0

		let string = XGString(string: "", file: nil, sid: nil)

		while nextChar != 0x00 && nextChar != nil && (maxCharacters == nil || characterCounter < maxCharacters!) {
			switch charLength {
			case .char: currChar = Int(readChar(atAddress: currentOffset) ?? 0)
			case .short: currChar = Int(readShort(atAddress: currentOffset) ?? 0)
			case .word: currChar = Int(readWord(atAddress: currentOffset) ?? 0)
			}
			currentOffset += charLength.rawValue
			characterCounter += 1

			string.append(.unicode(currChar ?? 0))
			switch charLength {
			case .char: nextChar = Int(readChar(atAddress: currentOffset) ?? 0)
			case .short: nextChar = Int(readShort(atAddress: currentOffset) ?? 0)
			case .word: nextChar = Int(readWord(atAddress: currentOffset) ?? 0)
			}
		}

		return string.string
	}
}

extension GoDWritable {

	@discardableResult
	func write(_ data: XGMutableData, atAddress address: Int) -> Bool {
		return write(data, atAddress: UInt(address))
	}

	@discardableResult
	func write(_ value: Int, atAddress address: Int) -> Bool {
		return write(value.unsigned, atAddress: address)
	}

	@discardableResult
	func write8(_ value: Int, atAddress address: Int) -> Bool {
		return write(UInt8(value & 0xFFFF), atAddress: address)
	}

	@discardableResult
	func write(_ value: UInt8, atAddress address: Int) -> Bool {
		let data = XGMutableData(byteStream: [value])
		return write(data, atAddress: address)
	}

	@discardableResult
	func write16(_ value: Int, atAddress address: Int) -> Bool {
		return write(UInt16(value & 0xFFFF), atAddress: address)
	}

	@discardableResult
	func write(_ value: UInt16, atAddress address: Int) -> Bool {
		let data = XGMutableData(byteStream: Int(value).byteArrayU16)
		return write(data, atAddress: address)
	}

	@discardableResult
	func write(_ value: UInt32, atAddress address: Int) -> Bool {
		let data = XGMutableData(byteStream: value.charArray)
		return write(data, atAddress: address)
	}

	@discardableResult
	func write(_ asm: ASM, atAddress address: Int) -> Bool {
		let bytes = asm.wordStreamAtRAMOffset(address)
		let data = XGMutableData(length: bytes.count * 4)
		data.replaceBytesFromOffset(0, withWordStream: bytes)
		return write(data, atAddress: address)
	}

	func writeString(_ string: String, atAddress offset: Int, charLength: ByteLengths = .short, maxCharacters: Int? = nil, includeNullTerminator: Bool = true) {
		var unicodeRepresentation = string.unicodeRepresentation
		if !includeNullTerminator {
			unicodeRepresentation.removeLast()
		}

		unicodeRepresentation.forEachIndexed { (index, unicode) in
			guard maxCharacters == nil || index < maxCharacters! else { return }
			let currentOffset = offset + (index * charLength.rawValue)
			let data: XGMutableData
			switch charLength {
			case .char: data = XGMutableData(byteStream: [UInt8(unicode & 0xFF)])
			case .short: data = XGMutableData(byteStream: (unicode & 0xFFFF).byteArrayU16)
			case .word: data = XGMutableData(byteStream: (unicode & 0xFF).byteArray)
			}
			write(data, atAddress: currentOffset)
		}
	}
}
