//
//  XDRExtensions.swift
//  GoD Tool
//
//  Created by StarsMmd on 05/09/2017.
//
//

import Cocoa

let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/XD-Randomiser"
let region = XGRegions(rawValue: XGFiles.iso.data.get4BytesAtOffset(0)) ?? .US
let game = XGGame.XD
var verbose = true

let date = Date(timeIntervalSinceNow: 0)
var logString = ""

func printg(_ args: Any...) {
	for arg in args {
		print(arg, separator: " ", terminator: " ")
	}
	print("") // automatically adds new line
	
	for arg in args {
		logString = logString + String(describing: arg) + " "
	}
	logString = logString + "\n"
	
	XGUtility.saveString(logString, toFile: .log(date))
	
}

extension GoDTexture {
	func importImage(file: XGFiles) {
		return
	}
	
	@objc func palette() -> [Int] {
		return []
	}
	
	@objc func pixels() -> [Int] {
		
		return []
	}
	
	@objc var pngData : Data {
		get {
			return Data()
		}
	}
	
	@objc var image : NSImage {
		get {
			return NSImage(data: self.pngData)!
		}
	}
	
	func saveImage(file: XGFiles) {
		return
	}
}

extension XGStringTable {
	@objc func replaceString(_ string: XGString, alert: Bool) -> Bool {
		
		let copyStream = self.stringTable.getCharStreamFromOffset(0, length: self.stringOffsets[string.id]!)
		
		let dataCopy = XGMutableData(byteStream: copyStream, file: self.file)
		
		let oldText = self.stringWithID(string.id)!
		let difference = string.dataLength - oldText.dataLength
		
		if difference <= self.extraCharacters {
			
			let stream = string.byteStream
			
			dataCopy.appendBytes(stream)
			
			
			let oldEnd = self.endOffsetForStringId(string.id)
			
			let newEnd = stringTable.getCharStreamFromOffset(oldEnd, length: fileSize - oldEnd)
			
			let endData = XGMutableData(byteStream: newEnd, file: self.file)
			
			dataCopy.appendBytes(endData.charStream)
			
			if string.dataLength > oldText.dataLength {
				
				for _ in 0 ..< difference {
					
					let currentOff = dataCopy.length - 1
					let range = NSMakeRange(currentOff, 1)
					
					dataCopy.deleteBytesInRange(range)
					
				}
				
				self.increaseOffsetsAfter(stringOffsets[string.id]!, byCharacters: difference)
			}
			
			if string.dataLength < oldText.dataLength {
				
				let difference = oldText.dataLength - string.dataLength
				var emptyByte : UInt8 = 0x0
				
				for _ in 0 ..< difference {
					
					dataCopy.data.append(&emptyByte, length: 1)
					
				}
				
				self.decreaseOffsetsAfter(stringOffsets[string.id]!, byCharacters: difference)
			}
			
			self.stringTable = dataCopy
			
			self.updateOffsets()
			self.save()
			
			stringsLoaded = false
			
			return true
			
		} else {
			
		}
		
		return false
	}
}
