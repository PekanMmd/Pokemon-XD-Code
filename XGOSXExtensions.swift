//
//  XGOSXExtensions.swift
//  GoD Tool
//
//  Created by StarsMmd on 20/08/2017.
//
//

import Cocoa

let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/GoD-Tool"

extension XGColour {
	var NSColour : NSColor {
		return NSColor(calibratedRed: CGFloat(red) / 31, green: CGFloat(green) / 31, blue: CGFloat(blue) / 31, alpha: CGFloat(alpha ? 1 : 0))
	}
}

extension GoDTexture {
	func importImage(file: XGFiles) {
		GoDTextureImporter.replaceTextureData(texture: self, withImage: file)
	}
	
	func palette() -> [Int] {
		return self.data.getShortStreamFromOffset(paletteStart, length: 0x200)
	}
	
	func pixels() -> [Int] {
		return self.data.getByteStreamFromOffset(textureStart, length: paletteStart - textureStart)
	}
	
	var pngData : Data {
		get {
			let palette = self.palette().map { (rgba16) -> NSColor in
				return XGColour(bytes: rgba16).NSColour
			}
			
			let colourPixels = self.pixels().map { (index) -> NSColor in
				return palette[index]
			}
			
			
			var pixelsPerRow = width
			while pixelsPerRow % 8 != 0 {
				pixelsPerRow += 1
			}
			let bytesPerRow = pixelsPerRow * 4
			
			let bitmap = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: width, pixelsHigh: height, bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: NSDeviceRGBColorSpace, bitmapFormat: NSBitmapFormat(rawValue: UInt(CGBitmapInfo.byteOrder32Big.union(CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)).rawValue)), bytesPerRow: bytesPerRow, bitsPerPixel: 32)!
			
			
			for index in 0 ..< pixelsPerRow * height {
				
				let rowsPerBlock = 4
				let columnsPerBlock = 8
				let pixelsPerBlock = rowsPerBlock * columnsPerBlock
				let blocksPerRow = pixelsPerRow / columnsPerBlock
				
				let indexOfBlock = index / pixelsPerBlock
				let indexInBlock = index % pixelsPerBlock
				let rowInBlock = indexInBlock / columnsPerBlock
				let columnInBlock = indexInBlock % columnsPerBlock
				let rowOfBlock = indexOfBlock / blocksPerRow
				let columnOfBlock = indexOfBlock % blocksPerRow
				
				let colour = colourPixels[index]
				let x = (columnOfBlock * columnsPerBlock) + columnInBlock
				let y = (rowOfBlock * rowsPerBlock) + rowInBlock
				
				bitmap.setColor(colour, atX: x, y: y)
				
			}
			
			let img = bitmap.representation(using: NSPNGFileType, properties: [:])!
			
			return img
		}
	}
	
	var image : NSImage {
		get {
			return NSImage(data: self.pngData)!
		}
	}
	
	func saveImage(file: XGFiles) {
		
		do {
			try self.pngData.write(to: URL(fileURLWithPath: file.path))
		} catch {
			
		}
		
		
	}
}

extension XGStringTable {
	func replaceString(_ string: XGString, alert: Bool) -> Bool {
		
		let copyStream = self.stringTable.getCharStreamFromOffset(0, length: self.stringOffsets[string.id]!)
		
		let dataCopy = XGMutableData(byteStream: copyStream, file: self.file)
		
		let oldText = self.stringWithID(string.id)!
		let difference = string.length - oldText.length
		
		if difference <= self.extraCharacters {
			
			let stream = string.byteStream
			
			dataCopy.appendBytes(stream)
			
			
			let oldEnd = self.endOffsetForStringId(string.id)
			
			let newEnd = stringTable.getCharStreamFromOffset(oldEnd, length: fileSize - oldEnd)
			
			let endData = XGMutableData(byteStream: newEnd, file: self.file)
			
			dataCopy.appendBytes(endData.charStream)
			
			if string.length > oldText.length {
				
				for _ in 0 ..< difference {
					
					let currentOff = dataCopy.length - 1
					let range = NSMakeRange(currentOff, 1)
					
					dataCopy.deleteBytesInRange(range)
					
				}
				
				self.increaseOffsetsAfter(stringOffsets[string.id]!, byCharacters: difference)
			}
			
			if string.length < oldText.length {
				
				let difference = oldText.length - string.length
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
