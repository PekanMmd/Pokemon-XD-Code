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

class EcardCoder {
	
	private static let bitMaskForBitOfByteWithIndex = [0x80, 0x40, 0x20, 0x10, 0x8, 0x4, 0x2, 0x1]

	static func decode(file: XGFiles) -> XGMutableData? {
		guard let data = file.data else { return nil }
		return decode(data: data)
	}

	// Default "key" value is the one used in Colosseum
	static func decode(data: XGMutableData, key: Int = 4160) -> XGMutableData? {
		let output = XGMutableData(length: 0xb20)
		output.file = .nameAndFolder(data.file.fileName.removeFileExtensions() + "-decoded.bin", data.file.folder)

		var readPosition = 0

		/// **readLength** : number of bits to read
		func readBits(readLength: Int) -> Int {
			guard readLength > 0 else { return 0 }

			var mask = 0

			for _ in 0 ..< readLength {
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
		func decodeChunk(operation: Int, readLength: Int, baseCaseLoopCount: Int, chunkGroupIndex: Int? = nil) -> Bool {
			if readLength < 0x10 {
				var valid = true
				for i in 0 ..< baseCaseLoopCount {
					let bits = readBits(readLength: readLength)
					valid = valid && write(output: output, operation: operation, chunkGroupIndex: chunkGroupIndex, bitsAsMask: bits, loopCounter: i)
				}
				return valid
			} else {
				var byteBuffer = [Int]()
				while readLength - byteBuffer.count > 0 {
					let nextReadLength = min(readLength - byteBuffer.count, 0x10)
					let bits = readBits(readLength: nextReadLength)
					byteBuffer += bits.byteArrayU16
				}
				byteBuffer += [0,0]
				return write(output: output, operation: operation, chunkGroupIndex: chunkGroupIndex, bitsAsBuffer: byteBuffer)
			}
		}

		@discardableResult
		func decodeChunks(withParameters parameters: [(operation: Int, readLength: Int, loopCount: Int)], chunkGroupIndex: Int? = nil) -> Bool {
			for params in parameters {
				guard decodeChunk(operation: params.operation, readLength: params.readLength, baseCaseLoopCount: params.loopCount, chunkGroupIndex: chunkGroupIndex) else {
					return false
				}
			}
			return true
		}

		decodeChunk(operation: 0x0, readLength: 4, baseCaseLoopCount: 1)
		let firstOutput = output.getByteAtOffset(0)
		readPosition = 0

		if firstOutput == 1 {
			guard decodeChunks(withParameters: [
				(0x48, 4, 0x1),
				(0x49, 6, 0x1),
				(0x4a, 240, 0x1)
			]) else {
				return nil
			}
		} else if firstOutput == 0 {
			guard decodeChunks(withParameters: [
				(0x0, 4, 1),
				(0x1, 3, 1),
				(0x2, 2, 1),
				(0x3, 4, 1),
				(0x4, 4, 1),
				(0x5, 8, 1),
				(0x6, 192, 1),
				(0x7, 3, 1),
				(0x8, 3, 1),
				(0x9, 3, 1),
				(0xA, 112, 1),
				(0xB, 112, 1),
				(0xC, 112, 1),
				(0xD, 2, 1),
				(0xE, 3, 1),
				(0xF, 3, 1),
				(0x10, 4, 1),
				(0x11, 4, 1),
				(0x12, 4, 1),
				(0x13, 4, 1),
				(0x14, 4, 1),
				(0x15, 4, 1),
				(0x16, 4, 1),
				(0x17, 4, 1),
				(0x18, 4, 1),
				(0x19, 10, 1),
				(0x1A, 10, 1),
				(0x1B, 10, 1),
				(0x1C, 7, 1),
				(0x1D, 7, 1),
				(0x1E, 7, 1),
				(0x1F, 720, 1),
				(0x20, 720, 1),
				(0x21, 720, 1),
				(0x22, 720, 1),
				(0x23, 720, 1),
				(0x24, 720, 1),
				(0x25, 720, 1),
				(0x26, 720, 1),
				(0x27, 720, 1)
			]) else {
				return nil
			}
			for i in 0 ..< 9 {
				guard decodeChunks(withParameters: [
					(0x28, 80, 1),
					(0x29, 1, 1),
					(0x2A, 6, 4),
					(0x2B, 10, 4),
					(0x2C, 1, 1),
					(0x2D, 14, 1),
					(0x2E, 10, 1),
					(0x2F, 7, 1)
				], chunkGroupIndex: i) else {
					return nil
				}
			}
			for i in 0 ..< 0x24 {
				guard decodeChunks(withParameters: [
					(0x30, 9, 1),
					(0x31, 7, 1),
					(0x32, 7, 1),
					(0x33, 10, 4),
					(0x34, 11, 1),
					(0x35, 2, 1),
					(0x36, 6, 1),
					(0x37, 6, 1),
					(0x38, 6, 1),
					(0x39, 6, 1),
					(0x3A, 6, 1),
					(0x3B, 6, 1),
					(0x3C, 9, 1),
					(0x3D, 9, 1),
					(0x3E, 9, 1),
					(0x3F, 9, 1),
					(0x40, 9, 1),
					(0x41, 9, 1),
					(0x42, 9, 1),
					(0x43, 2, 1),
					(0x44, 6, 1),
					(0x45, 3, 1),
					(0x46, 6, 1),
					(0x47, 8, 1)
				], chunkGroupIndex: i) else {
					return nil
				}
			}
		} else {
			return nil
		}

		return output
	}

	@discardableResult
	private static func write(output: XGMutableData, operation: Int, chunkGroupIndex: Int? = nil, bitsAsMask: Int? = nil, loopCounter: Int? = nil, bitsAsBuffer: [Int]? = nil) -> Bool {

		return false
	}
}
