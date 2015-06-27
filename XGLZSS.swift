//
//  XGLZSS.swift
//  XG Tool
//
//  Created by The Steez on 02/06/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//


import Foundation

enum XGLZSS {
	
	case InputAndOutput(XGFiles, XGFiles)
	
	var input : XGFiles {
		get {
			switch self {
				case .InputAndOutput(let file, let _): return file
			}
		}
	}
	
	var output : XGFiles {
		get {
			switch self {
			case .InputAndOutput(let _, let file): return file
			}
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
			var compressor = XGLZSSWrapper()
			var bytes = compressor.compressFile(&stream, ofSize: stream.count)
			let length = compressor.outLength
			var compressedStream = [UInt8]()
			for var i : Int32 = 0; i < length; i++ {
				compressedStream.append(bytes[Int(i)])
			}
			var compressedData = XGMutableData(byteStream: compressedStream, file: output)
			return compressedData
		}
	}
	
	
}



