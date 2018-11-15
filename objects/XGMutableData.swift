//
//  XGMutableData.swift
//  XG Tool
//
//  Created by StarsMmd on 29/05/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

class XGMutableData: NSObject {
	
	@objc var fsysData : XGFsys {
		return XGFsys(data: self)
	}
	
	var file = XGFiles.nameAndFolder("", .Documents)
	@objc var data = NSMutableData()
	
	@objc var string : String {
		for encoding : String.Encoding in [.utf8, .utf16, .utf32, .ascii, .unicode] {
			if let text = String(bytesNoCopy: self.data.mutableBytes, length: self.data.length, encoding: encoding, freeWhenDone: false) {
				return text
			}
		}
		return ""
	}
	
	@objc var rawBytes : UnsafeRawPointer {
		return self.data.bytes
	}
	
	@objc var byteStream : [Int] {
		get {
			return getByteStreamFromOffset(0, length: length)
		}
	}
	
	@objc var charStream : [UInt8] {
		get {
			return getCharStreamFromOffset(0, length: length)
		}
	}
	
	@objc var length : Int {
		get {
			return data.length
		}
	}
	
	override init() {
		super.init()
	}
	
	init(byteStream: [UInt8], file: XGFiles) {
		super.init()
		
		self.data = NSMutableData()
		self.appendBytes(byteStream)
		self.file = file
		
	}
	
	init(contentsOfXGFile file: XGFiles) {
		super.init()
		
		self.file = file
		self.data = NSMutableData(contentsOfFile: file.path) ?? NSMutableData()
			
	}
	
	@objc init(contentsOfFile file: String) {
		super.init()
		self.data = NSMutableData(contentsOfFile: file) ?? NSMutableData()
	}
	
	@objc func save() {
		if !self.file.folder.exists {
			self.file.folder.createDirectory()
		}
		self.data.write(toFile: self.file.path, atomically: true)
	}
	
	@objc func copyDataAtOffset(_ origin: Int, ofSize bytes: Int, toOffset target: Int) {
		
		var copy : UInt8 = 0x0
		
		for i in 0 ..< bytes {
			
			self.data.getBytes(&copy, range: NSMakeRange(origin + i, 1))
			self.data.replaceBytes(in: NSMakeRange(target + i, 1), withBytes: &copy)
			
		}
		
	}
	
	//MARK: - Get Bytes
	
	@objc func getCharAtOffset(_ start : Int) -> UInt8 {
		
		if start < 0 || start + 1 > self.length {
			printg("Attempting to read byte from offset: \(start.hexString()), file: \(self.file.path), length: \(self.data.length.hexString())")
		}
		
		var byte : UInt8 = 0x0
		self.data.getBytes(&byte, range: NSMakeRange(start, 1))
		return byte 
		
	}
	
	@objc func getByteAtOffset(_ start : Int) -> Int {
		
		if start < 0 || start + 1 > self.length {
			printg("Attempting to read byte from offset: \(start.hexString()), file: \(self.file.path), length: \(self.data.length.hexString())")
		}
		
		var byte : UInt8 = 0x0
		self.data.getBytes(&byte, range: NSMakeRange(start, 1))
		return Int(byte )
		
	}
	
	@objc func get2BytesAtOffset(_ start : Int) -> Int {
		
		if start < 0 || start + 2  > self.length {
			printg("Attempting to read 2 bytes from offset: \(start.hexString()), file: \(self.file.path), length: \(self.data.length.hexString())")
		}
		
		var bytes : UInt16 = 0x0
		self.data.getBytes(&bytes, range: NSMakeRange(start, 2))
		bytes = UInt16(bigEndian: bytes)
		return Int(bytes )
		
	}
	
	@objc func get4BytesAtOffset(_ start : Int) -> Int {
		
		if start < 0 || start + 4 > self.length {
			printg("Attempting to read 4 bytes from offset: \(start.hexString()), file: \(self.file.path), length: \(self.data.length.hexString())")
		}
		
		return getWordAtOffset(start).int
	}
	
	@objc func getWordAtOffset(_ start : Int) -> UInt32 {
		
		if start < 0 || start + 4 > self.length {
			printg("Attempting to read 4 bytes from offset: \(start.hexString()), file: \(self.file.path), length: \(self.data.length.hexString())")
		}
		
		var bytes : UInt32 = 0x0
		self.data.getBytes(&bytes, range: NSMakeRange(start, 4))
		bytes = UInt32(bigEndian: bytes)
		return UInt32(bytes)
		
	}
	
	@objc func getNibbleStreamFromOffset(_ offset: Int, length: Int) -> [Int] {
		
		if offset < 0 || offset + length > self.length {
			printg("Attempting to read \(length.hexString()) bytes from offset: \(offset.hexString()), file: \(self.file.path), length: \(self.data.length.hexString())")
		}
		
		// length in bytes, not number of nibbles
		var nibbles = [Int]()
		
		for byte in self.getByteStreamFromOffset(offset, length: length) {
			nibbles.append(byte >> 4)
			nibbles.append(byte % 16)
		}
		
		return nibbles
	}
	
	@objc func getByteStreamFromOffset(_ offset: Int, length: Int) -> [Int] {
		
		if offset < 0 || offset + length > self.length {
			printg("Attempting to read \(length.hexString()) bytes from offset: \(offset.hexString()), file: \(self.file.path), length: \(self.data.length.hexString())")
		}
		
		var byteStream = [Int]()
		
		for i in 0 ..< length {
			
			byteStream.append(self.getByteAtOffset(offset + i))
			
		}
		
		return byteStream
	}
	
	@objc func getShortStreamFromOffset(_ offset: Int, length: Int) -> [Int] {
		
		if offset < 0 || offset + length > self.length {
			printg("Attempting to read \(length.hexString()) bytes from offset: \(offset.hexString()), file: \(self.file.path), length: \(self.data.length.hexString())")
		}
		
		// length in bytes, not number of shorts
		
		var byteStream = [Int]()
		
		for i in stride(from: 0, to: length, by: 2) {
			
			byteStream.append(self.get2BytesAtOffset(offset + i))
			
		}
		
		return byteStream
	}
	
	@objc func getCharStreamFromOffset(_ offset: Int, length: Int) -> [UInt8] {
		
		if offset < 0 || offset + length > self.length {
			printg("Attempting to read \(length.hexString()) bytes from offset: \(offset.hexString()), file: \(self.file.path), length: \(self.data.length.hexString())")
		}
		
		var byteStream = [UInt8]()
		
		for i in 0 ..< length {
			
			byteStream.append(self.getCharAtOffset(offset + i))
			
		}
		
		return byteStream
	}
	
	@objc func getWordStreamFromOffset(_ offset: Int, length: Int) -> [UInt32] {
		
		if offset < 0 || offset + length > self.length {
			printg("Attempting to read \(length.hexString()) bytes from offset: \(offset.hexString()), file: \(self.file.path), length: \(self.data.length.hexString())")
		}
		
		// length in bytes, not number of words
		
		var byteStream = [UInt32]()
		
		for i in stride(from: 0, to: length, by: 4) {
			
			byteStream.append(self.getWordAtOffset(offset + i))
			
		}
		
		return byteStream
	}
	
	//MARK: - Replace Bytes
	
	@objc func replaceByteAtOffset(_ start : Int, withByte byte: Int) {
		
		if start < 0 || start + 1 > self.length {
			printg("Attempting to write byte from offset: \(start.hexString()), file: \(self.file.path), length: \(self.data.length.hexString())")
		}
		
		var byte = UInt8(byte & 0xFF)
		self.data.replaceBytes(in: NSMakeRange(start, 1), withBytes: &byte)
		
	}
	
	@objc func replace2BytesAtOffset(_ start : Int, withBytes bytes: Int) {
		
		if start < 0 || start + 2 > self.length {
			printg("Attempting to write 2 bytes from offset: \(start.hexString()), file: \(self.file.path), length: \(self.data.length.hexString())")
		}
		
		var bytes = UInt16(bytes & 0xFFFF)
		bytes = UInt16(bigEndian: bytes)
		self.data.replaceBytes(in: NSMakeRange(start, 2), withBytes: &bytes)
		
	}
	
	@objc func replaceWordAtOffset(_ start : Int, withBytes newbytes: UInt32) {
		
		if start < 0 || start + 4 > self.length {
			printg("Attempting to write 4 bytes from offset: \(start.hexString()), file: \(self.file.path), length: \(self.data.length.hexString())")
		}
		
		var bytes = UInt32(newbytes)
		bytes = UInt32(bigEndian: bytes)
		self.data.replaceBytes(in: NSMakeRange(start, 4), withBytes: &bytes)
		
	}
	
	@objc func replace4BytesAtOffset(_ start : Int, withBytes newbytes: Int) {
		
		if start < 0 || start + 4 > self.length {
			printg("Attempting to write 4 bytes from offset: \(start.hexString()), file: \(self.file.path), length: \(self.data.length.hexString())")
		}
		
		var bytes = newbytes.unsigned
		bytes = UInt32(bigEndian: bytes)
		self.data.replaceBytes(in: NSMakeRange(start, 4), withBytes: &bytes)
		
	}
	
	@objc func replaceBytesFromOffset(_ offset: Int, withByteStream bytes: [Int]) {
		
		if offset < 0 || offset + bytes.count > self.length {
			printg("Attempting to write \(bytes.count) bytes from offset: \(offset.hexString()), file: \(self.file.path), length: \(self.data.length.hexString())")
		}
		
		for i in 0 ..< bytes.count {
			
			self.replaceByteAtOffset(offset + i, withByte: bytes[i])
			
		}
	}
	
	@objc func replaceBytesFromOffset(_ offset: Int, withShortStream bytes: [Int]) {
		
		if offset < 0 || offset + bytes.count > self.length {
			printg("Attempting to write \(bytes.count * 2) bytes from offset: \(offset.hexString()), file: \(self.file.path), length: \(self.data.length.hexString())")
		}
		
		for i in 0 ..< bytes.count {
			
			self.replace2BytesAtOffset(offset + (i*2), withBytes: bytes[i])
			
		}
	}
	
	@objc func replaceBytesInRange(_ range: NSRange, withBytes bytes: UnsafeRawPointer) {
		data.replaceBytes(in: range, withBytes: bytes)
	}
	
	
	// append bytes
	@objc func appendBytes(_ bytes: [UInt8]) {
		var byte : UInt8 = 0x0
		for b in bytes {
			byte = b
			data.append(&byte, length: 1)
		}
	}
	
	@objc func increaseLength(by length: Int) {
		data.increaseLength(by: length)
	}
	
	// insert bytes
	
	@objc func insertByte(byte: Int, atOffset offset: Int) {
		
		if offset < 0 || offset > self.length {
			printg("Attempting to insert byte at offset: \(offset.hexString()), file: \(self.file.path), length: \(self.data.length.hexString())")
		}
		
		let range = NSMakeRange(offset, 0)
		var b = UInt8(byte)
		self.data.replaceBytes(in: range, withBytes: &b, length: 1)
	}
	
	@objc func insertBytes(bytes: [Int], atOffset offset: Int) {
		
		if offset < 0 || offset > self.length {
			printg("Attempting to insert \(bytes.count) bytes at offset: \(offset.hexString()), file: \(self.file.path), length: \(self.data.length.hexString())")
		}
		
		let charStream = bytes.map { (b) -> UInt8 in
			return UInt8(b)
		}
		let newData = XGMutableData(byteStream: charStream, file: .nameAndFolder("", .Documents))
		self.insertData(data: newData, atOffset: offset)
	}
	
	@objc func insertData(data: XGMutableData, atOffset offset: Int) {
		
		if offset < 0 || offset > self.length {
			printg("Attempting to insert \(data.length) bytes at offset: \(offset.hexString()), file: \(self.file.path), length: \(self.data.length.hexString())")
		}
		
		self.data.replaceBytes(in: NSMakeRange(offset, 0), withBytes: data.rawBytes, length: data.length)
	}
	
	@objc func insertRepeatedByte(byte: Int, count: Int, atOffset offset: Int) {
		
		if offset < 0 || offset > self.length {
			printg("Attempting to insert \(count) bytes at offset: \(offset.hexString()), file: \(self.file.path), length: \(self.data.length.hexString())")
		}
		
		let bytes = [Int](repeating: byte, count: count)
		self.insertBytes(bytes: bytes, atOffset: offset)
		
	}
	
	// delete bytes
	
	@objc func deleteBytesInRange(_ range: NSRange) {
		data.replaceBytes(in: range, withBytes: nil, length: 0)
	}
	
	@objc func deleteBytes(start: Int, count: Int) {
		
		if start < 0 || start + count > self.length {
			printg("Attempting to delete \(count) bytes at offset: \(start.hexString()), file: \(self.file.path), length: \(self.data.length.hexString())")
		}
		
		let range = NSMakeRange(start, count)
		self.deleteBytesInRange(range)
	}
	
	@objc func nullBytes(start: Int, length: Int) {
		
		if start < 0 || start + length > self.length {
			printg("Attempting to null \(length) bytes at offset: \(start.hexString()), file: \(self.file.path), length: \(self.data.length.hexString())")
		}
		
		let null = [Int](repeating: 0, count: length)
		self.replaceBytesFromOffset(start, withByteStream: null)
	}
	
	func setFolder(_ folder: XGFolders) {
		self.file = .nameAndFolder(self.file.fileName, folder)
	}
	
	@objc func setFilename(_ filename: String) {
		self.file = .nameAndFolder(filename, self.file.folder)
	}
	
	func getStringAtOffset(_ offset: Int) -> String {
		
		if offset < 0 || offset + 2 > self.length {
			printg("Attempting to read string at offset: \(offset.hexString()), file: \(self.file.path), length: \(self.data.length.hexString())")
		}
		
		
		var currentOffset = offset
		
		var currChar = 0x0
		var nextChar = 0x1
		
		let string = XGString(string: "", file: nil, sid: nil)
		
		while (nextChar != 0x00) {
			currChar = self.getByteAtOffset(currentOffset)
			currentOffset += 1
			
			string.append(.unicode(currChar))
			nextChar = self.getByteAtOffset(currentOffset)
		}
		
		return string.string
	}
	
	
}

















