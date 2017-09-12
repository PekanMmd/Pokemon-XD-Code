//
//  XGMutableData.swift
//  XG Tool
//
//  Created by StarsMmd on 29/05/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

class XGMutableData: NSObject {
	
	var file = XGFiles.nameAndFolder("", .Documents)
	var data = NSMutableData()
	
	var byteStream : [Int] {
		get {
			return getByteStreamFromOffset(0, length: length)
		}
	}
	
	var charStream : [UInt8] {
		get {
			return getCharStreamFromOffset(0, length: length)
		}
	}
	
	var length : Int {
		get {
			return data.length
		}
	}
	
	override init() {
		super.init()
	}
	
	init(byteStream: [UInt8], file: XGFiles) {
		super.init()
		
		self.data = NSMutableData(contentsOfFile: file.path) ?? NSMutableData()
		self.deleteBytesInRange(NSMakeRange(0, data.length))
		
		self.appendBytes(byteStream)
		
		self.file = file
		
	}
	
	init(contentsOfXGFile file: XGFiles) {
		super.init()
		self.file = file
		self.data = NSMutableData(contentsOfFile: file.path) ?? NSMutableData()
	}
	
	init(contentsOfFile file: String) {
		super.init()
		self.data = NSMutableData(contentsOfFile: file) ?? NSMutableData()
	}
	
	func save() {
		self.data.write(toFile: self.file.path, atomically: true)
	}
	
	func copyDataAtOffset(_ origin: Int, ofSize bytes: Int, toOffset target: Int) {
		
		var copy : UInt8 = 0x0
		
		for i in 0 ..< bytes {
			
			self.data.getBytes(&copy, range: NSMakeRange(origin + i, 1))
			self.data.replaceBytes(in: NSMakeRange(target + i, 1), withBytes: &copy)
			
		}
		
	}
	
	//MARK: - Get Bytes
	
	func getCharAtOffset(_ start : Int) -> UInt8 {
		
		var byte : UInt8 = 0x0
		self.data.getBytes(&byte, range: NSMakeRange(start, 1))
		return byte 
		
	}
	
	func getByteAtOffset(_ start : Int) -> Int {
		
		var byte : UInt8 = 0x0
		self.data.getBytes(&byte, range: NSMakeRange(start, 1))
		return Int(byte )
		
	}
	
	func get2BytesAtOffset(_ start : Int) -> Int {
		
		var bytes : UInt16 = 0x0
		self.data.getBytes(&bytes, range: NSMakeRange(start, 2))
		bytes = UInt16(bigEndian: bytes)
		return Int(bytes )
		
	}
	
	func get4BytesAtOffset(_ start : Int) -> UInt32 {
		
		var bytes : UInt32 = 0x0
		self.data.getBytes(&bytes, range: NSMakeRange(start, 4))
		bytes = UInt32(bigEndian: bytes)
		return UInt32(bytes )
		
	}
	
	func getByteStreamFromOffset(_ offset: Int, length: Int) -> [Int] {
		
		var byteStream = [Int]()
		
		for i in 0 ..< length {
			
			byteStream.append(self.getByteAtOffset(offset + i))
			
		}
		
		return byteStream
	}
	
	func getShortStreamFromOffset(_ offset: Int, length: Int) -> [Int] {
		
		var byteStream = [Int]()
		
		for i in stride(from: 0, to: length, by: 2) {
			
			byteStream.append(self.get2BytesAtOffset(offset + i))
			
		}
		
		return byteStream
	}
	
	func getCharStreamFromOffset(_ offset: Int, length: Int) -> [UInt8] {
		
		var byteStream = [UInt8]()
		
		for i in 0 ..< length {
			
			byteStream.append(self.getCharAtOffset(offset + i))
			
		}
		
		return byteStream
	}
	
	
	
	//MARK: - Replace Bytes
	
	func replaceByteAtOffset(_ start : Int, withByte byte: Int) {
		
		var byte = UInt8(byte)
		self.data.replaceBytes(in: NSMakeRange(start, 1), withBytes: &byte)
		
	}
	
	func replace2BytesAtOffset(_ start : Int, withBytes bytes: Int) {
		
		var bytes = UInt16(bytes)
		bytes = UInt16(bigEndian: bytes)
		self.data.replaceBytes(in: NSMakeRange(start, 2), withBytes: &bytes)
		
	}
	
	func replace4BytesAtOffset(_ start : Int, withBytes bytes: UInt32) {
		
		var bytes = UInt32(bytes)
		bytes = UInt32(bigEndian: bytes)
		self.data.replaceBytes(in: NSMakeRange(start, 4), withBytes: &bytes)
		
	}
	
	func replaceBytesFromOffset(_ offset: Int, withByteStream bytes: [Int]) {
		
		for i in 0 ..< bytes.count {
			
			self.replaceByteAtOffset(offset + i, withByte: bytes[i])
			
		}
	}
	
	func replaceBytesFromOffset(_ offset: Int, withShortStream bytes: [Int]) {
		
		for i in 0..<bytes.count {
			
			self.replace2BytesAtOffset(offset + (i*2), withBytes: bytes[i])
			
		}
	}
	
	func replaceBytesInRange(_ range: NSRange, withBytes bytes: UnsafeRawPointer) {
		data.replaceBytes(in: range, withBytes: bytes)
	}
	
	
	// append bytes
	func appendBytes(_ bytes: [UInt8]) {
		var byte : UInt8 = 0x0
		for b in bytes {
			byte = b
			data.append(&byte, length: 1)
		}
	}
	
	
	// delete bytes
	
	func deleteBytesInRange(_ range: NSRange) {
		data.replaceBytes(in: range, withBytes: nil, length: 0)
	}
	
	func deleteBytes(start: Int, count: Int) {
		let range = NSMakeRange(start, count)
		self.deleteBytesInRange(range)
	}
	
	func nullBytes(start: Int, length: Int) {
		let null = [Int](repeating: 0, count: length)
		self.replaceBytesFromOffset(start, withByteStream: null)
	}
	
	func setFolder(_ folder: XGFolders) {
		self.file = .nameAndFolder(self.file.fileName, folder)
	}
	
	func setFilename(_ filename: String) {
		self.file = .nameAndFolder(filename, self.file.folder)
	}
	
	
}

















