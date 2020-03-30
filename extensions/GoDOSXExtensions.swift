//
//  GoDOSXExtensions.swift
//  GoD Tool
//
//  Created by The Steez on 28/08/2018.
//

import Cocoa

extension NSColor {
	var vec3 : [GLfloat] {
		return [Float(self.redComponent).gl, Float(self.greenComponent).gl, Float(self.blueComponent).gl]
	}
}

extension Float {
	var gl : GLfloat {
		return GLfloat(self)
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
	
	func imageData(fileType: NSBitmapImageRep.FileType) -> Data {
		return self.croppedImageData(fileType: fileType, width: self.width, height: self.height)
	}
	
	func croppedImageData(fileType: NSBitmapImageRep.FileType, width cWidth: Int, height cHeight: Int) -> Data {
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
			if self.format == .RGBA32 {
				
				// rg and ba values of rgba32 are separated within blocks so must restructure first
				let pix = self.data.getShortStreamFromOffset(textureStart, length: textureLength)
				var mergedPixels = [UInt32]()
				let blockCount = pix.count / 32 // 64 bytes per block, 4 pixelsperrow x 4 pixelspercolumn x 4 bytesperpixel
				
				for i in 0 ..< blockCount {
					let blockStart = i * 32
					for j in 0 ..< 16 {
						let rg = pix[blockStart + j]
						let ba = pix[blockStart + j + 16]
						let rgba = (UInt32(rg) << 16) + UInt32(ba)
						mergedPixels.append(rgba)
					}
				}
				
				colourPixels = mergedPixels.map({ (raw) -> NSColor in
					return XGColour(raw: raw, format: self.format).NSColour
				})
				
			} else if self.format == .CMPR {
				
				let subBlocks = self.data.getLongStreamFromOffset(textureStart, length: textureLength)
				let subsPerBlock = 4
				var blocks = [[XGColour]]()
				
				// decode one block per loop
				for i in stride(from: 0, to: subBlocks.count, by: subsPerBlock) {
					var sub4x4s = [(UInt32, UInt32)]()
					for j in 0 ... 3 {
						sub4x4s.append(subBlocks[i + j])
					}
					
					// decode each sub block
					let colourSub4x4s = sub4x4s.map({ (palette, indexes) -> [XGColour] in
						
						// get palette
						var hexPalette = [XGColour]()
						let hex1 = palette >> 16
						let hex2 = palette & 0xFFFF
						let colour1 = XGColour(raw: hex1, format: .RGB565)
						let colour2 = XGColour(raw: hex2, format: .RGB565)
						hexPalette.append(colour1)
						hexPalette.append(colour2)
						
						if hex1 > hex2 {
							let r1 = (2 * colour1.red + colour2.red) / 3
							let g1 = (2 * colour1.green + colour2.green) / 3
							let b1 = (2 * colour1.blue + colour2.blue) / 3
							let r2 = (2 * colour2.red + colour1.red) / 3
							let g2 = (2 * colour2.green + colour1.green) / 3
							let b2 = (2 * colour2.blue + colour1.blue) / 3
							
							let colour3 = XGColour(red: r1, green: g1, blue: b1, alpha: 0xFF)
							let colour4 = XGColour(red: r2, green: g2, blue: b2, alpha: 0xFF)
							
							hexPalette.append(colour3)
							hexPalette.append(colour4)
							
						} else {
							
							let r1 = (colour1.red + colour2.red) / 2
							let g1 = (colour1.green + colour2.green) / 2
							let b1 = (colour1.blue + colour2.blue) / 2
							
							let colour3 = XGColour(red: r1, green: g1, blue: b1, alpha: 0xFF)
							let colour4 = XGColour(red: 0, green: 0, blue: 0, alpha: 0)
							
							hexPalette.append(colour3)
							hexPalette.append(colour4)
							
						}
						
						// get indexes
						var indexedSub = [XGColour]()
						for i in 0 ... 15 {
							
							let nibbleIndex = UInt32(15 - i)
							let nibble = (indexes >> (nibbleIndex * 2)) & 0x3
							
							indexedSub.append(hexPalette[nibble.int])
							
						}
						
						return indexedSub
					})
					
					// arrange sub blocks into one block
					var block = [XGColour]()
					
					for subBlockRow in 0 ... 1 {
						let subBlock1 = colourSub4x4s[subBlockRow * 2]
						let subBlock2 = colourSub4x4s[subBlockRow * 2 + 1]
						for row in 0 ... 3 {
							for column in 0 ... 3 {
								let pixelIndex = row * 4 + column
								block.append(subBlock1[pixelIndex])
							}
							for column in 0 ... 3 {
								let pixelIndex = row * 4 + column
								block.append(subBlock2[pixelIndex])
							}
						}
					}
					
					blocks.append(block)
				}
				
				var pixels = [XGColour]()
				for block in blocks {
					pixels += block
				}
				colourPixels = pixels.map({ (c) -> NSColor in
					return c.NSColour
				})
				
			} else {
				colourPixels = self.pixels().map({ (raw) -> NSColor in
					return XGColour(raw: raw, format: self.format).NSColour
				})
			}
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
		
		let bitmap = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: cWidth, pixelsHigh: cHeight, bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: NSColorSpaceName.deviceRGB, bitmapFormat: NSBitmapImageRep.Format(rawValue: UInt(CGBitmapInfo.byteOrder32Big.union(CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)).rawValue)), bytesPerRow: bytesPerRow, bitsPerPixel: 32)!
		
		
		for index in 0 ..< pixelsPerRow * pixelsPerCol {
			
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
		
		let img = bitmap.representation(using: fileType, properties: [:])!
		
		return img
		
	}
	
	var pngData : Data {
		return imageData(fileType: .png)
	}
	
	var jpegData : Data {
		return imageData(fileType: .jpeg)
	}
	
	var bmpData : Data {
		return imageData(fileType: .bmp)
	}
	
	var image : NSImage {
		get {
			return NSImage(data: self.pngData)!
		}
	}
	
	func saveImage(file: XGFiles) {
		
		var path = file.path
		
		var fileType = NSBitmapImageRep.FileType.png
		switch file.fileType {
		case .png  : fileType = .png
		case .jpeg : fileType = .jpeg
		case .bmp  : fileType = .bmp
		default:
			printg("Cannot create file with image format \(file.fileType.fileExtension). Defaulting to .png")
			path += ".png"
		}
		
		do {
			try self.imageData(fileType: fileType).write(to: URL(fileURLWithPath: path))
		} catch {
			printg("Failed to save image data: \(path)")
		}
	}
	
	func saveCroppedImage(file: XGFiles, width: Int, height: Int) {
		
		var path = file.path
		
		var fileType = NSBitmapImageRep.FileType.png
		switch file.fileType {
		case .png  : fileType = .png
		case .jpeg : fileType = .jpeg
		case .bmp  : fileType = .bmp
		default:
			printg("Cannot create file with image format \(file.fileType.fileExtension). Defaulting to .png")
			path += ".png"
		}
		
		do {
			try self.croppedImageData(fileType: fileType, width: width, height: height).write(to: URL(fileURLWithPath: path))
		} catch {
			printg("Failed to save image data: \(path)")
		}
	}
	
}

extension XGStringTable {
	
	func replaceString(_ string: XGString, alert: Bool, save: Bool) -> Bool {
		return self.replaceString(string, alert: alert, save: save, increaseLength: false)
	}
	
	func replaceString(_ string: XGString, alert: Bool, save: Bool, increaseLength: Bool) -> Bool {
		
		if self.stringWithID(string.id) == nil {
			printg("String table '\(self.file.fileName)' doesn't contain string with id: \(string.id)")
			return false
		}
		
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
			if save {
				self.save()
			}
			
			return true
			
		} else {
			if increaseLength {
				if self.startOffset == 0 {
					if settings.verbose {
						printg("string was too long, adding \(difference + 0x50) bytes to table \(self.file.fileName)")
					}
					// add a little extra so it doesn't keep hitting this case every time there's even a 1 character increase
					self.stringTable.insertRepeatedByte(byte: 0, count: difference + 0x50, atOffset: stringTable.length)
					return self.replaceString(string, alert: alert, save: true, increaseLength: true)
				}
			}
		}
		
		printg("Couldn't replace string, not enough free space in string table: \(self.file.fileName)")
		if self.startOffset != 0 {
			printg("The size of this string table cannot be increased.")
		}
		return false
	}
}

extension NumberFormatter {
	
	class func byteFormatter() -> NumberFormatter {
		let format = NumberFormatter()
		format.minimum = 0x00
		format.maximum = 0xFF
		return format
	}
	
	class func shortFormatter() -> NumberFormatter {
		let format = NumberFormatter()
		format.minimum = 0x00
		format.maximum = 0xFFFF
		return format
	}
	
	class func signedByteFormatter() -> NumberFormatter {
		let format = NumberFormatter()
		format.minimum = -127
		format.maximum = 128
		return format
	}
	
}







