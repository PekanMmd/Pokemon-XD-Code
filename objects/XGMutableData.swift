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
		return String(bytesNoCopy: self.data.mutableBytes, length: self.data.length, encoding: .ascii, freeWhenDone: false) ?? ""
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
		
		var byte : UInt8 = 0x0
		self.data.getBytes(&byte, range: NSMakeRange(start, 1))
		return byte 
		
	}
	
	@objc func getByteAtOffset(_ start : Int) -> Int {
		
		var byte : UInt8 = 0x0
		self.data.getBytes(&byte, range: NSMakeRange(start, 1))
		return Int(byte )
		
	}
	
	@objc func get2BytesAtOffset(_ start : Int) -> Int {
		
		var bytes : UInt16 = 0x0
		self.data.getBytes(&bytes, range: NSMakeRange(start, 2))
		bytes = UInt16(bigEndian: bytes)
		return Int(bytes )
		
	}
	
	@objc func get4BytesAtOffset(_ start : Int) -> UInt32 {
		
		var bytes : UInt32 = 0x0
		self.data.getBytes(&bytes, range: NSMakeRange(start, 4))
		bytes = UInt32(bigEndian: bytes)
		return UInt32(bytes )
		
	}
	
	@objc func getNibbleStreamFromOffset(_ offset: Int, length: Int) -> [Int] {
		// length in bytes, not number of nibbles
		var nibbles = [Int]()
		
		for byte in self.getByteStreamFromOffset(offset, length: length) {
			nibbles.append(byte >> 4)
			nibbles.append(byte % 16)
		}
		
		return nibbles
	}
	
	@objc func getByteStreamFromOffset(_ offset: Int, length: Int) -> [Int] {
		
		var byteStream = [Int]()
		
		for i in 0 ..< length {
			
			byteStream.append(self.getByteAtOffset(offset + i))
			
		}
		
		return byteStream
	}
	
	@objc func getShortStreamFromOffset(_ offset: Int, length: Int) -> [Int] {
		// length in bytes, not number of shorts
		
		var byteStream = [Int]()
		
		for i in stride(from: 0, to: length, by: 2) {
			
			byteStream.append(self.get2BytesAtOffset(offset + i))
			
		}
		
		return byteStream
	}
	
	@objc func getCharStreamFromOffset(_ offset: Int, length: Int) -> [UInt8] {
		if verbose && (offset + length) > self.length {
			printg("attempting to read data outside of data length")
			return []
		}
		
		var byteStream = [UInt8]()
		
		for i in 0 ..< length {
			
			byteStream.append(self.getCharAtOffset(offset + i))
			
		}
		
		return byteStream
	}
	
	@objc func getWordStreamFromOffset(_ offset: Int, length: Int) -> [UInt32] {
		// length in bytes, not number of words
		
		var byteStream = [UInt32]()
		
		for i in stride(from: 0, to: length, by: 4) {
			
			byteStream.append(self.get4BytesAtOffset(offset + i))
			
		}
		
		return byteStream
	}
	
	//MARK: - Replace Bytes
	
	@objc func replaceByteAtOffset(_ start : Int, withByte byte: Int) {
		
		var byte = UInt8(byte)
		self.data.replaceBytes(in: NSMakeRange(start, 1), withBytes: &byte)
		
	}
	
	@objc func replace2BytesAtOffset(_ start : Int, withBytes bytes: Int) {
		
		var bytes = UInt16(bytes)
		bytes = UInt16(bigEndian: bytes)
		self.data.replaceBytes(in: NSMakeRange(start, 2), withBytes: &bytes)
		
	}
	
	@objc func replace4BytesAtOffset(_ start : Int, withBytes bytes: UInt32) {
		
		var bytes = UInt32(bytes)
		bytes = UInt32(bigEndian: bytes)
		self.data.replaceBytes(in: NSMakeRange(start, 4), withBytes: &bytes)
		
	}
	
	@objc func replaceBytesFromOffset(_ offset: Int, withByteStream bytes: [Int]) {
		
		for i in 0 ..< bytes.count {
			
			self.replaceByteAtOffset(offset + i, withByte: bytes[i])
			
		}
	}
	
	@objc func replaceBytesFromOffset(_ offset: Int, withShortStream bytes: [Int]) {
		
		for i in 0..<bytes.count {
			
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
		let range = NSMakeRange(offset, 0)
		var b = UInt8(byte)
		self.data.replaceBytes(in: range, withBytes: &b, length: 1)
	}
	
	@objc func insertBytes(bytes: [Int], atOffset offset: Int) {
		for i in 0 ..< bytes.count {
			insertByte(byte: bytes[i], atOffset: offset + i)
		}
	}
	
	@objc func insertData(data: XGMutableData, atOffset offset: Int) {
		self.data.replaceBytes(in: NSMakeRange(offset, 0), withBytes: data.rawBytes, length: data.length)
	}
	
	@objc func insertRepeatedByte(byte: Int, count: Int, atOffset offset: Int) {
		for _ in 0 ..< count {
			insertByte(byte: byte, atOffset: offset)
		}
	}
	
	// delete bytes
	
	@objc func deleteBytesInRange(_ range: NSRange) {
		data.replaceBytes(in: range, withBytes: nil, length: 0)
	}
	
	@objc func deleteBytes(start: Int, count: Int) {
		let range = NSMakeRange(start, count)
		self.deleteBytesInRange(range)
	}
	
	@objc func nullBytes(start: Int, length: Int) {
		let null = [Int](repeating: 0, count: length)
		self.replaceBytesFromOffset(start, withByteStream: null)
	}
	
	func setFolder(_ folder: XGFolders) {
		self.file = .nameAndFolder(self.file.fileName, folder)
	}
	
	@objc func setFilename(_ filename: String) {
		self.file = .nameAndFolder(filename, self.file.folder)
	}
	
	
}

















