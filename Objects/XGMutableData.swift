//
//  XGMutableData.swift
//  XG Tool
//
//  Created by The Steez on 29/05/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//

import UIKit

class XGMutableData: NSObject {
	
	var file = XGFiles.NameAndFolder("", .Documents)
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
	
	init?(contentsOfXGFile file: XGFiles) {
		super.init()
		self.data = NSMutableData(contentsOfFile: file.path) ?? NSMutableData()
		
		self.file = file
	}
	
	func save() -> Bool {
		return self.data.writeToFile(self.file.path, atomically: true)
	}
	
	func copyDataAtOffset(origin: Int, ofSize bytes: Int, toOffset target: Int) {
		
		var copy : UInt8 = 0x0
		
		for var i = 0; i < bytes; i++ {
			
			self.data.getBytes(&copy, range: NSMakeRange(origin + i, 1))
			self.data.replaceBytesInRange(NSMakeRange(target + i, 1), withBytes: &copy)
			
		}
		
	}
	
	//MARK: - Get Bytes
	
	func getCharAtOffset(start : Int) -> UInt8 {
		
		var byte : UInt8 = 0x0
		self.data.getBytes(&byte, range: NSMakeRange(start, 1))
		return byte ?? 0
		
	}
	
	func getByteAtOffset(start : Int) -> Int {
		
		var byte : UInt8 = 0x0
		self.data.getBytes(&byte, range: NSMakeRange(start, 1))
		return Int(byte ?? 0)
		
	}
	
	func get2BytesAtOffset(start : Int) -> Int {
		
		var bytes : UInt16 = 0x0
		self.data.getBytes(&bytes, range: NSMakeRange(start, 2))
		bytes = UInt16(bigEndian: bytes)
		return Int(bytes ?? 0)
		
	}
	
	func get4BytesAtOffset(start : Int) -> UInt32 {
		
		var bytes : UInt32 = 0x0
		self.data.getBytes(&bytes, range: NSMakeRange(start, 4))
		bytes = UInt32(bigEndian: bytes)
		return UInt32(bytes ?? 0)
		
	}
	
	func getByteStreamFromOffset(offset: Int, length: Int) -> [Int] {
		
		var byteStream = [Int]()
		
		for var i = 0; i < length; i++ {
			
			byteStream.append(self.getByteAtOffset(offset + i))
			
		}
		
		return byteStream
	}
	
	func getCharStreamFromOffset(offset: Int, length: Int) -> [UInt8] {
		
		var byteStream = [UInt8]()
		
		for var i = 0; i < length; i++ {
			
			byteStream.append(self.getCharAtOffset(offset + i))
			
		}
		
		return byteStream
	}
	
	
	
	//MARK: - Replace Bytes
	
	func replaceByteAtOffset(start : Int, withByte byte: Int) {
		
		var byte = UInt8(byte)
		self.data.replaceBytesInRange(NSMakeRange(start, 1), withBytes: &byte)
		
	}
	
	func replace2BytesAtOffset(start : Int, withBytes bytes: Int) {
		
		var bytes = UInt16(bytes)
		bytes = UInt16(bigEndian: bytes)
		self.data.replaceBytesInRange(NSMakeRange(start, 2), withBytes: &bytes)
		
	}
	
	func replace4BytesAtOffset(start : Int, withBytes bytes: UInt32) {
		
		var bytes = UInt32(bytes)
		bytes = UInt32(bigEndian: bytes)
		self.data.replaceBytesInRange(NSMakeRange(start, 4), withBytes: &bytes)
		
	}
	
	func replaceBytesFromOffset(offset: Int, withByteStream bytes: [Int]) {
		
		for var i = 0; i < bytes.count; i++ {
			
			self.replaceByteAtOffset(offset + i, withByte: bytes[i])
			
		}
	}
	
	func replaceBytesInRange(range: NSRange, withBytes bytes: UnsafePointer<Void>) {
		data.replaceBytesInRange(range, withBytes: bytes)
	}
	
	
	// append bytes
	func appendBytes(bytes: [UInt8]) {
		var byte : UInt8 = 0x0
		for b in bytes {
			byte = b
			data.appendBytes(&byte, length: 1)
		}
	}
	
	
	// delete bytes
	
	func deleteBytesInRange(range: NSRange) {
		data.replaceBytesInRange(range, withBytes: nil, length: 0)
	}
	
	
	
}

















