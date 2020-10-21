//
//  GoDOSXExtensions.swift
//  GoD Tool
//
//  Created by The Steez on 28/08/2018.
//

#if ENV_OSX
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

extension XGFileTypes {
	var NSFileType: NSBitmapImageRep.FileType {
		switch self {
		case .png: return .png
		case .jpeg: return .jpeg
		case .bmp: return .bmp
		default: assertionFailure("Not an image format"); return .png
		}
	}

}
#endif

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

	func imageData(fileType: XGFileTypes) -> Data {
		return self.croppedImageData(fileType: fileType, width: self.width, height: self.height)
	}

	func croppedImageData(fileType: XGFileTypes, width cWidth: Int, height cHeight: Int) -> Data {
		let palette = self.palette().map { (raw) -> XGColour in
			var pFormat = GoDTextureFormats.RGB5A3
			if self.paletteFormat == 0 {
				pFormat = .IA8
			}
			if self.paletteFormat == 1 {
				pFormat = .RGB565
			}
			return XGColour(raw: raw, format: pFormat)
		}

		var colourPixels = [XGColour]()
		if isIndexed {
			colourPixels = self.pixels().map { (index) -> XGColour in
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

				colourPixels = mergedPixels.map({ (raw) -> XGColour in
					return XGColour(raw: raw, format: self.format)
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
				colourPixels = pixels

			} else {
				colourPixels = self.pixels().map({ (raw) -> XGColour in
					return XGColour(raw: raw, format: self.format)
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

			bitmap.setColor(colour.NSColour, atX: x, y: y)

		}

		#if ENV_OSX
		let img = bitmap.representation(using: fileType.NSFileType, properties: [:]) ?? Data()
		#else
		let img = bitmap.representation(using: fileType, properties: [:])
		#endif

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
		do {
			try self.imageData(fileType: file.fileType).write(to: URL(fileURLWithPath: file.path))
		} catch {
			printg("Failed to save image data: \(file.path)")
		}
	}

	func saveCroppedImage(file: XGFiles, width: Int, height: Int) {
		do {
			try self.croppedImageData(fileType: file.fileType, width: width, height: height).write(to: URL(fileURLWithPath: file.path))
		} catch {
			printg("Failed to save image data: \(file.path)")
		}
	}

}








