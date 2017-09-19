//
//  XGOSXExtensions.swift
//  GoD Tool
//
//  Created by StarsMmd on 20/08/2017.
//
//

import Cocoa

let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/GoD-Tool"

typealias TrainerInfo = (name:String,location:String,hasShadow: Bool,trainerModel:XGTrainerModels,index:Int,deck:XGDecks)
extension XGTrainer {
	var trainerInfo : TrainerInfo {
		var name = self.trainerClass.name
		return (self.trainerClass.name.string + " " + self.name.string, self.locationString,self.hasShadow,self.trainerModel,self.index,self.deck)
	}
}

extension XGColour {
	var NSColour : NSColor {
		return NSColor(calibratedRed: CGFloat(red) / 0xFF, green: CGFloat(green) / 0xFF, blue: CGFloat(blue) / 0xFF, alpha: CGFloat(alpha) / 0xFF)
	}
}

extension GoDTexture {
	func importImage(file: XGFiles) {
		GoDTextureImporter.replaceTextureData(texture: self, withImage: file)
	}
	
	func palette() -> [Int] {
		return self.data.getShortStreamFromOffset(paletteStart, length: paletteLength)
	}
	
	func pixels() -> [Int] {
		
		if BPP == 16 {
			return self.data.getShortStreamFromOffset(textureStart, length: self.textureLength)
		}
		if BPP == 4 {
			return self.data.getNibbleStreamFromOffset(textureStart, length: self.textureLength)
		}
		return self.data.getByteStreamFromOffset(textureStart, length: self.textureLength)
	}
	
	var pngData : Data {
		get {
			let palette = self.palette().map { (raw) -> NSColor in
				var pFormat = GoDTextureFormats.RGB5A3
				if self.paletteFormat == 0 {
					pFormat = .IA8
				}
				if self.paletteFormat == 1 {
					pFormat = .RGB565
				}
				return XGColour(raw: raw, format: pFormat).NSColour
			}
			
			var colourPixels = [NSColor]()
			if isIndexed {
				colourPixels = self.pixels().map { (index) -> NSColor in
					return palette[index]
				}
			} else {
				colourPixels = self.pixels().map({ (raw) -> NSColor in
					return XGColour(raw: raw, format: self.format).NSColour
				})
			}
			
			
			
			var pixelsPerRow = width
			var pixelsPerCol = height
			while pixelsPerRow % blockWidth != 0 {
				pixelsPerRow += 1
			}
			while pixelsPerCol % blockHeight != 0 {
				pixelsPerCol += 1
			}
			let bytesPerRow = pixelsPerRow * 4
			
			let bitmap = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: width, pixelsHigh: height, bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: NSDeviceRGBColorSpace, bitmapFormat: NSBitmapFormat(rawValue: UInt(CGBitmapInfo.byteOrder32Big.union(CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)).rawValue)), bytesPerRow: bytesPerRow, bitsPerPixel: 32)!
			
			
			for index in 0 ..< pixelsPerRow * height {
				
				let rowsPerBlock = self.blockHeight
				let columnsPerBlock = self.blockWidth
				
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
