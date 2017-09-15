//
//  XGiOSExtensions.swift
//  GoD Tool
//
//  Created by StarsMmd on 20/08/2017.
//
//

import Foundation

let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]

extension GoDTexture {
	func importImage(file: XGFiles) {
		XGTexturePNGReimporter.replaceTextureData(textureFile: self.file, withImage: file)
	}
	
	func saveImage(file: XGFiles) {
		return
	}
}

extension XGStringTable {
	func replaceString(_ string: XGString, alert: Bool) -> Bool {
		
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
			
			if alert {
								XGAlertView(title: "String Replacement", message: "The string replacement was successful.", doneButtonTitle: "Sweet", otherButtonTitles: nil, buttonAction: nil).show()
			}
			
			stringsLoaded = false
			
			return true
			
		} else {
			if alert {
								XGAlertView(title: "String Replacement", message: "The new string was too long. String replacement was aborted.", doneButtonTitle: "Cool", otherButtonTitles: nil, buttonAction: nil).show()
			}
		}
		
		return false
	}
}
