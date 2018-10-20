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
	case InputData(XGMutableData)
	
	var inputFile : XGFiles {
		get {
			switch self {
			case .Input(let file):
				return file
			case .InputData(let d):
				return d.file
			}
		}
	}
	
	var output : XGFiles {
		get {
			let name = inputFile.fileName
			return .lzss(name)
		}
	}
	
	var originalData : XGMutableData {
		get {
			switch self {
			case .Input(let f):
				return f.data
			case .InputData(let d):
				return d
			}
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
			let header = kLZSSbytes.charArray + originalData.length.charArray + (compressedStream.count + 0x10).charArray + 0.charArray
			compressedStream = header + compressedStream
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
		compressedData.save()
	}
	
	func decompress(file: XGFiles) {
		let d = decompressedData
		d.file = file
		d.save()
	}
	
}



