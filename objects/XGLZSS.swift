//
//  XGLZSS.swift
//  XG Tool
//
//  Created by StarsMmd on 02/06/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//


import Foundation

enum XGLZSS {
	
	case Input(XGFiles)
	
	var input : XGFiles {
		get {
			switch self {
				case .Input(let file): return file
			}
		}
	}
	
	var output : XGFiles {
		get {
			let name = input.fileName + ".lzss"
			return .lzss(name)
		}
	}
	
	var originalData : XGMutableData {
		get {
			return self.input.data
		}
	}
	
	var compressedData : XGMutableData {
		get {
			var stream  = originalData.charStream
			let compressor = XGLZSSWrapper()
			let bytes = compressor.compressFile(&stream, ofSize: Int32(stream.count))
			let length = compressor.outLength
			var compressedStream = [UInt8]()
			for i : Int32 in 0 ..< length {
				compressedStream.append((bytes?[Int(i)])!)
			}
			let compressedData = XGMutableData(byteStream: compressedStream, file: output)
			return compressedData
		}
	}
	
	var decompressedData : XGMutableData {
		get {
			var stream  = originalData.charStream
			let compressor = XGLZSSWrapper()
			let bytes = compressor.decompressFile(&stream, ofSize: Int32(stream.count), decompressedSize: 0xFFFFFFF)
			let length = compressor.outLength
			var decompressedStream = [UInt8]()
			for i : Int32 in 0 ..< length {
				decompressedStream.append((bytes?[Int(i)])!)
			}
			let compressedData = XGMutableData(byteStream: decompressedStream, file: output)
			return compressedData
		}
	}
	
	func compress() {
		if !self.input.exists {
			printg("file doesn't exist: ", self.input.path)
			return
		}
		compressedData.save()
	}
	
	func decompress(file: XGFiles) {
		if !self.input.exists {
			printg("file doesn't exist: ", self.input.path)
			return
		}
		let d = decompressedData
		d.file = file
		d.save()
	}
	
}



