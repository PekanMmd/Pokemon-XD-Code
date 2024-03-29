//
//  XGMutableData.swift
//  XG Tool
//
//  Created by StarsMmd on 29/05/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

enum ByteLengths: Int {
	case char = 1
	case short = 2
	case word = 4
	
	var mask: Int {
		switch self {
		case .char: return 0xFF
		case .short: return 0xFFFF
		case .word: return 0xFFFFFFFF
		}
	}
}

class XGMutableData {
	
	var fsysData : XGFsys {
		return XGFsys(data: self)
	}
	
	var file = XGFiles.nameAndFolder("", .Documents)
	var data = Data()
	
	var string : String {
		for encoding : String.Encoding in [.utf8, .utf16, .utf32, .ascii, .unicode] {
			if let text = String(data: data, encoding: encoding) {
				return text
			}
		}
		return ""
	}

	func hexStream(grouping: UInt = 1, bytesPerRow: UInt = 16) -> String {
		var stream = ""
		byteStream.forEachIndexed { (index, byte) in
			var hex = byte.hex()
			if hex.length == 1 {
				hex = "0" + hex
			}
			stream += hex
			if bytesPerRow > 0 && index > 0 && index % Int(bytesPerRow) == 0 {
				stream += "\n"
			} else if grouping > 0 && index != length - 1 && index % Int(grouping) == grouping - 1 {
				stream += " "
			}
		}
		return stream
	}
	
	var rawBytes: [UInt8] {
		return data.rawBytes
	}
	
	var byteStream : [Int] {
		return getByteStreamFromOffset(0, length: length)
	}
	
	var charStream : [UInt8] {
		return rawBytes
	}
	
	var length : Int {
		return data.count
	}

	init() {}
	
	init(byteStream: [UInt8], file: XGFiles = XGFiles.nameAndFolder("", .Documents)) {
		data = Data(byteStream)
		self.file = file
	}

	convenience init(length: Int) {
		self.init(byteStream: [UInt8](repeating: 0, count: length))
	}
	
	convenience init(byteStream: [Int], file: XGFiles = XGFiles.nameAndFolder("", .Documents)) {
		self.init(byteStream: byteStream.map{ UInt8($0) }, file: file)
	}
	
	convenience init(contentsOfXGFile file: XGFiles) {
		self.init(contentsOfFile: file.path)
		self.file = file
	}
	
	init(contentsOfFile path: String) {
		let url = URL(fileURLWithPath: path)
		if let data = try? Data(contentsOf: url) {
			self.data = data
		}
	}

	convenience init(string: String, charLength: ByteLengths = .char) {
		self.init(length: string.length)
		writeString(string, at: 0, charLength: charLength, maxCharacters: nil, includeNullTerminator: false)
	}

	init(data: Data) {
		self.data = data
	}

	@discardableResult
	func save() -> Bool {
		return writeToFile(file)
	}

	@discardableResult
	func writeToFile(_ file: XGFiles) -> Bool {
		if data.write(to: file) {
			if XGSettings.current.verbose {
				printg("data successfully written to file:", file.path)
			}
			return true
		} else {
			if XGSettings.current.verbose {
				printg("data failed to be written to file:", file.path)
			}
			return false
		}
	}

	func duplicated() -> XGMutableData {
		return XGMutableData(byteStream: rawBytes, file: file)
	}
	
	var isNull: Bool {
		for byte in byteStream {
			if byte != 0 {
				return false
			}
		}
		return true
	}

	//MARK: - Get Bytes
	
	func getCharAtOffset(_ start : Int) -> UInt8 {
		if start < 0 || start + 1 > length {
			printg("Attempting to read byte from offset: \(start.hexString()), file: \(file.path), length: \(length.hexString())")
			return 0
		}
		
		return data[start]
	}
	
	func getByteAtOffset(_ start : Int) -> Int {
		return Int(getCharAtOffset(start))
	}

	func getValueAtOffset(_ start: Int, length: ByteLengths) -> Int {
		switch length {
		case .char:
			return getByteAtOffset(start)
		case .short:
			return get2BytesAtOffset(start)
		case .word:
			return get4BytesAtOffset(start)
		}
	}
	
	func get2BytesAtOffset(_ start : Int) -> Int {
		if start < 0 || start + 2  > length {
			printg("Attempting to read 2 bytes from offset: \(start.hexString()), file: \(file.path), length: \(length.hexString())")
			return 0
		}

		return Int(data.subdata(in: start ..< start + 2).rawBytes.uint16)
	}

	func getHalfAtOffset(_ start : Int) -> UInt16 {
		if start < 0 || start + 2  > length {
			printg("Attempting to read 2 bytes from offset: \(start.hexString()), file: \(file.path), length: \(length.hexString())")
			return 0
		}

		return data.subdata(in: start ..< start + 2).rawBytes.uint16
	}
	
	func get4BytesAtOffset(_ start : Int) -> Int {
		if start < 0 || start + 4  > length {
			printg("Attempting to read 4 bytes from offset: \(start.hexString()), file: \(file.path), length: \(length.hexString())")
			return 0
		}

		return Int(data.subdata(in: start ..< start + 4).rawBytes.uint32)
	}
	
	func getWordAtOffset(_ start : Int) -> UInt32 {
		if start < 0 || start + 4  > length {
			printg("Attempting to read 4 bytes from offset: \(start.hexString()), file: \(file.path), length: \(length.hexString())")
			return 0
		}

		return data.subdata(in: start ..< start + 4).rawBytes.uint32
	}
	
	func getNibbleStreamFromOffset(_ offset: Int, length: Int) -> [Int] {
		if offset < 0 || offset + length > self.length {
			printg("Attempting to read \(length.hexString()) bytes from offset: \(offset.hexString()), file: \(file.path), length: \(self.length.hexString())")
			return .init(repeating: 0, count: length * 2)
		}
		
		// length in bytes, not number of nibbles
		var nibbles = [Int]()
		
		for byte in self.getByteStreamFromOffset(offset, length: length) {
			nibbles.append(byte >> 4)
			nibbles.append(byte % 16)
		}
		
		return nibbles
	}
	
	func getByteStreamFromOffset(_ offset: Int, length: Int) -> [Int] {
		if offset < 0 || offset + length > self.length {
			printg("Attempting to read \(length.hexString()) bytes from offset: \(offset.hexString()), file: \(file.path), length: \(self.length.hexString())")
			return .init(repeating: 0, count: length)
		}
		
		return data.subdata(in: offset ..< offset + length).map { Int($0) }
	}
	
	func getShortStreamFromOffset(_ offset: Int, length: Int) -> [Int] {
		if offset < 0 || offset + length > self.length {
			printg("Attempting to read \(length.hexString()) bytes from offset: \(offset.hexString()), file: \(file.path), length: \(self.length.hexString())")
			return .init(repeating: 0, count: length / 2)
		}
		
		// length in bytes, not number of shorts
		var byteStream = [Int]()
		for i in stride(from: 0, to: length, by: 2) {
			byteStream.append(get2BytesAtOffset(offset + i))
		}
		return byteStream
	}
	
	func getCharStreamFromOffset(_ offset: Int, length: Int) -> [UInt8] {
		if offset < 0 || offset + length > self.length {
			printg("Attempting to read \(length.hexString()) bytes from offset: \(offset.hexString()), file: \(file.path), length: \(self.length.hexString())")
			return .init(repeating: 0, count: length)
		}

		return data.subdata(in: offset ..< offset + length).rawBytes
	}
	
	func getWordStreamFromOffset(_ offset: Int, length: Int) -> [UInt32] {
		if offset < 0 || offset + length > self.length {
			printg("Attempting to read \(length.hexString()) bytes from offset: \(offset.hexString()), file: \(file.path), length: \(self.length.hexString())")
			return .init(repeating: 0, count: length / 4)
		}
		
		// length in bytes, not number of words
		var byteStream = [UInt32]()
		for i in stride(from: 0, to: length, by: 4) {
			byteStream.append(getWordAtOffset(offset + i))
		}
		return byteStream
	}
	
	func getLongStreamFromOffset(_ offset: Int, length: Int) -> [(UInt32, UInt32)] {
		if offset < 0 || offset + length > self.length {
			printg("Attempting to read \(length.hexString()) bytes from offset: \(offset.hexString()), file: \(file.path), length: \(self.length.hexString())")
			return .init(repeating: (0, 0), count: length / 8)
		}
		
		// length in bytes, not number of longs
		var byteStream = [(UInt32, UInt32)]()
		for i in stride(from: 0, to: length, by: 8) {
			byteStream.append((getWordAtOffset(offset + i), getWordAtOffset(offset + i + 4)))
		}
		return byteStream
	}

	func getSubDataFromOffset(_ offset: Int, length: Int) -> XGMutableData {
		let subData = Data(data.suffix(from: offset).prefix(length))
		let data = XGMutableData(data: subData)
		data.file = file
		return data
	}
	
	//MARK: - Replace Bytes
	
	func replaceByteAtOffset(_ start : Int, withByte byte: Int) {
		let byte = UInt8(byte & 0xFF)
		replaceCharAtOffset(start, withByte: byte)
		
	}

	func replaceCharAtOffset(_ start : Int, withByte byte: UInt8) {
		if start < 0 || start + 1 > length {
			printg("Attempting to write byte from offset: \(start.hexString()), file: \(file.path), length: \(length.hexString())")
			return
		}

		data[start] = byte

	}
	
	func replace2BytesAtOffset(_ start : Int, withBytes bytes: Int) {
		if start < 0 || start + 2 > length {
			printg("Attempting to write 2 bytes from offset: \(start.hexString()), file: \(file.path), length: \(length.hexString())")
			return
		}
		
		let byte1 = UInt8((bytes & 0xFF00) >> 8)
		let byte2 = UInt8(bytes & 0xFF)
		replaceBytesFromOffset(start, withByteStream: [byte1, byte2])
		
	}
	
	func replaceWordAtOffset(_ start : Int, withBytes newbytes: UInt32) {
		if start < 0 || start + 4 > length {
			printg("Attempting to write 4 bytes from offset: \(start.hexString()), file: \(file.path), length: \(length.hexString())")
			return
		}
		let byte1 = UInt8((newbytes & 0xFF000000) >> 24)
		let byte2 = UInt8((newbytes & 0xFF0000) >> 16)
		let byte3 = UInt8((newbytes & 0xFF00) >> 8)
		let byte4 = UInt8(newbytes & 0xFF)
		replaceBytesFromOffset(start, withByteStream: [byte1, byte2, byte3, byte4])
		
	}
	
	func replace4BytesAtOffset(_ start : Int, withBytes newbytes: Int) {
		if start < 0 || start + 4 > length {
			printg("Attempting to write 4 bytes from offset: \(start.hexString()), file: \(file.path), length: \(length.hexString())")
			return
		}
		let bytes = newbytes.unsigned
		let byte1 = UInt8((bytes & 0xFF000000) >> 24)
		let byte2 = UInt8((bytes & 0xFF0000) >> 16)
		let byte3 = UInt8((bytes & 0xFF00) >> 8)
		let byte4 = UInt8((bytes & 0xFF))
		replaceBytesFromOffset(start, withByteStream: [byte1, byte2, byte3, byte4])
		
	}
	
	func replaceBytesFromOffset(_ offset: Int, withByteStream bytes: [Int]) {
		if offset < 0 || offset + bytes.count > length {
			printg("Attempting to write \(bytes.count.hexString()) bytes from offset: \(offset.hexString()), file: \(file.path), length: \(length.hexString())")
			return
		}
		
		for i in 0 ..< bytes.count {
			replaceByteAtOffset(offset + i, withByte: bytes[i])
		}
	}

	func replaceBytesFromOffset(_ offset: Int, withByteStream bytes: [UInt8]) {
		replaceBytesFromOffset(offset, withByteStream: bytes.map{Int($0)})
	}

	func replaceBytesFromOffset(_ offset: Int, withNibbleStream nibbles: [Int]) {
		if offset < 0 || offset + (nibbles.count / 2) > length {
			printg("Attempting to write \((nibbles.count / 2).hexString()) bytes from offset: \(offset.hexString()), file: \(file.path), length: \(length.hexString())")
			return
		}

		var currentByte = 0
		for i in 0 ..< nibbles.count {
			currentByte = currentByte << 4
			currentByte = currentByte | (nibbles[i] & 0xF)
			if (i % 2 == 1) || (i == nibbles.count - 1) {
				replaceByteAtOffset(offset + (i / 2), withByte: currentByte)
				currentByte = 0
			}
		}
	}
	
	func replaceBytesFromOffset(_ offset: Int, withShortStream bytes: [Int]) {
		if offset < 0 || offset + (bytes.count * 2) > self.length {
			printg("Attempting to write \(bytes.count * 2) bytes from offset: \(offset.hexString()), file: \(file.path), length: \(self.length.hexString())")
			return
		}
		
		for i in 0 ..< bytes.count {
			self.replace2BytesAtOffset(offset + (i*2), withBytes: bytes[i])
		}
	}

	func replaceBytesFromOffset(_ offset: Int, withWordStream bytes: [UInt32]) {
		if offset < 0 || offset + (bytes.count * 4) > self.length {
			printg("Attempting to write \(bytes.count * 4) bytes from offset: \(offset.hexString()), file: \(file.path), length: \(self.length.hexString())")
			return
		}

		for i in 0 ..< bytes.count {
			self.replaceWordAtOffset(offset + (i*4), withBytes: bytes[i])
		}
	}
	
	func replaceData(data: XGMutableData, atOffset offset: Int) {
		replaceBytesFromOffset(offset, withByteStream: data.byteStream)
	}
	
	
	// append bytes
	func appendBytes(_ bytes: [UInt8]) {
		data.append(contentsOf: bytes)
	}

	func appendBytes(_ bytes: [Int]) {
		appendBytes(bytes.map { UInt8($0) })
	}

	func appendData(_ data: XGMutableData) {
		self.data.append(data.data)
	}
	
	// insert bytes
	func insertByte(byte: Int, atOffset offset: Int) {
		if offset < 0 || offset > length {
			printg("Attempting to insert byte at offset: \(offset.hexString()), file: \(file.path), length: \(length.hexString())")
			return
		}
		data.insert(UInt8(byte), at: offset)
	}
	
	func insertBytes(bytes: [Int], atOffset offset: Int) {
		if offset < 0 || offset > length {
			printg("Attempting to insert \(bytes.count) bytes at offset: \(offset.hexString()), file: \(file.path), length: \(length.hexString())")
			return
		}
		data.insert(contentsOf: bytes.map { UInt8($0) }, at: offset)
	}

	func insertBytes(bytes: [UInt8], atOffset offset: Int) {
		if offset < 0 || offset > length {
			printg("Attempting to insert \(bytes.count) bytes at offset: \(offset.hexString()), file: \(file.path), length: \(length.hexString())")
			return
		}
		data.insert(contentsOf: bytes, at: offset)
	}
	
	func insertData(data: XGMutableData, atOffset offset: Int) {
		insertBytes(bytes: data.charStream, atOffset: offset)
	}

	func insertRepeatedByte(byte: UInt8, count: Int, atOffset offset: Int) {
		insertBytes(bytes: .init(repeating: byte, count: count), atOffset: offset)
	}
	
	// delete bytes
	func deleteBytes(start: Int, count: Int) {
		if start < 0 || start + count > length {
			printg("Attempting to delete \(count) bytes at offset: \(start.hexString()), file: \(file.path), length: \(length.hexString())")
			return
		}
		data.removeSubrange(start ..< start + count)
	}
	
	func nullBytes(start: Int, length: Int) {
		if start < 0 || start + length > self.length {
			printg("Attempting to null \(length.hexString()) bytes at offset: \(start.hexString()), file: \(file.path), length: \(length.hexString())")
			return
		}
		replaceBytesFromOffset(start, withByteStream: [UInt8](repeating: 0, count: length))
	}
	
	//MARK: - search for data
	func occurencesOfBytes(_ bytes: [Int]) -> [Int] {
		let searchData = XGMutableData(byteStream: bytes)
		return self.occurencesOfData(searchData)
	}
	
	func occurencesOfData(_ data: XGMutableData) -> [Int] {
		var offsets = [Int]()
		let searchData = data.data
		var currentStart = 0
		
		while true {
			let resultRange = self.data.range(of: searchData, options: [], in: currentStart ..< length)
			if let resultOffset = resultRange?.startIndex {
				offsets.append(resultOffset)
				currentStart = resultOffset + 1
			} else {
				break
			}
		}
		
		return offsets
	}
	
	func search(for data: XGMutableData, fromOffset: Int = 0) -> Int? {
		let searchRange: Range<Data.Index> = fromOffset ..< self.length
		guard let resultRange = self.data.range(of: data.data, options: [], in: searchRange) else {
			return nil
		}
		return Int(resultRange.startIndex)
	}

	// MARK: - Strings

	func getStringAtOffset(_ offset: Int, charLength: ByteLengths = .char, maxCharacters: Int? = nil) -> String {
		if offset < 0 || offset + (2 * charLength.rawValue) > length {
			printg("Attempting to read string at offset: \(offset.hexString()), file: \(file.path), length: \(length.hexString())")
			return ""
		}

		var currentOffset = offset

		var currChar = 0x0
		var nextChar = 0x1
		var characterCounter = 0

		let string = XGString(string: "", file: nil, sid: nil)

		while nextChar != 0x00 && (maxCharacters == nil || characterCounter < maxCharacters!) {
			currChar = self.getValueAtOffset(currentOffset, length: charLength)
			currentOffset += charLength.rawValue
			characterCounter += 1

			string.append(.unicode(currChar))
			nextChar = self.getValueAtOffset(currentOffset, length: charLength)
		}

		return string.string
	}

	func writeString(_ string: String, at offset: Int, charLength: ByteLengths = .short, maxCharacters: Int? = nil, includeNullTerminator: Bool = true) {
		if offset < 0 || offset + (2 * charLength.rawValue) > length {
			printg("Attempting to write string at offset: \(offset.hexString()), file: \(file.path), length: \(length.hexString())")
			return
		}

		var unicodeRepresentation = string.unicodeRepresentation
		if !includeNullTerminator {
			unicodeRepresentation.removeLast()
		}

		unicodeRepresentation.forEachIndexed { (index, unicode) in
			guard maxCharacters == nil || index < maxCharacters! else { return }
			let currentOffset = offset + (index * charLength.rawValue)
			switch charLength {
			case .char:	replaceByteAtOffset(currentOffset, withByte: unicode)
			case .short: replace2BytesAtOffset(currentOffset, withBytes: unicode)
			case .word: replace4BytesAtOffset(currentOffset, withBytes: unicode)
			}
		}
	}

	func readString(at offset: Int, length: Int) -> XGString {
		let bytes = getShortStreamFromOffset(offset, length: length * 2)
		let string = XGString(string: "", file: nil, sid: nil)
		for value in bytes where value != 0 {
			string.append(.unicode(value))
		}
		return string
	}

	func writeString(_ string: XGString, at offset: Int) {
		replaceBytesFromOffset(offset, withByteStream: string.byteStream)
	}
}

extension XGMutableData: GoDReadable {
	func read(atAddress address: UInt, length: UInt) -> XGMutableData? {
		if (Int(address) + Int(length) > self.length) {
			return nil
		}
		return getSubDataFromOffset(Int(address), length: Int(length))
	}
}

extension XGMutableData: GoDWritable {
	func write(_ data: XGMutableData, atAddress address: UInt) -> Bool {
		if (Int(address) + data.length > length) {
			return false
		}
		replaceData(data: data, atOffset: Int(address))
		return true
	}
}















