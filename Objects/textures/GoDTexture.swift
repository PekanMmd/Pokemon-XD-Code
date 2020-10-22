//
//  GoDTexture.swift
//  GoD Tool
//
//  Created by The Steez on 12/09/2017.
//
//

import Foundation

let kTextureWidthOffset = 0x00
let kTextureHeightOffset = 0x02
let kTextureBPPOffset = 0x04      // bits per pixel
let kTextureIndexOffset = 0x5
let kTextureFormatOffset = 0xb
let kPaletteFormatOffset = 0xf
let kTexturePointerOffset = 0x28
let kPalettePointerOffset = 0x48

// The textures in poke_dance.fsys start with this data so it can be used to identify them.
// Those textures start at 0xA0 with some extra data added beforehand (probably used to animate it).
let kDancerBytes = [0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00]
let kDancerStartOffset = 0xC

class GoDTexture {

	var data : XGMutableData!
	
	var width = 0
	var height = 0
	var textureStart = 0
	var paletteStart = 0
	var format = GoDTextureFormats.C8
	var paletteFormat = 0
	
	var isIndexed : Bool {
		return format.isIndexed
	}
	
	var BPP : Int {
		return format.bitsPerPixel
	}
	
	var blockWidth : Int {
		return format.blockWidth
	}
	
	var blockHeight : Int {
		return format.blockHeight
	}
	
	var textureLength : Int {
		get {
			return self.isIndexed ? paletteStart - textureStart : data.length - textureStart
		}
	}
	
	var paletteLength : Int {
		return self.isIndexed ? (self.data.length - self.paletteStart) : 0
	}
	
	var paletteCount : Int {
		return paletteLength / 2
	}
	
	var file : XGFiles {
		get {
			return self.data.file
		}
		set {
			self.data.file = newValue
		}
	}

	var startOffset: Int {
		return isPokeDance ? data.get4BytesAtOffset(kDancerStartOffset) : 0x0
	}
	var isPokeDance: Bool {
		return data.length > kDancerBytes.count && data.getByteStreamFromOffset(0, length: kDancerBytes.count) == kDancerBytes
	}
	
	convenience init(file: XGFiles) {
		self.init(data: file.data!)
	}
	
	init(data: XGMutableData) {
		self.data = data
		self.setUp()
	}

	init(forImage image: XGImage, format: GoDTextureFormats, paletteFormat: GoDTextureFormats = .RGB565) {
		width = image.width
		height = image.height
		self.format = format
		textureStart = 0x80
		
		var requiredPixelsPerRow = self.width
		while requiredPixelsPerRow % format.blockWidth != 0 {
			requiredPixelsPerRow += 1
		}
		var requiredPixelsPerCol = self.height
		while requiredPixelsPerCol % format.blockHeight != 0 {
			requiredPixelsPerCol += 1
		}
		
		let requiredTextureBytes = requiredPixelsPerRow * requiredPixelsPerCol * self.BPP / 8
		let requiredPaletteBytes = format.paletteCount * paletteFormat.bitsPerPixel / 8
		
		if self.format.isIndexed {
			self.paletteFormat = paletteFormat.paletteID ?? GoDTextureFormats.RGB5A3.paletteID!
			self.paletteStart = 0x80 + requiredTextureBytes
		}
		
		self.data = XGMutableData(byteStream: [Int](repeating: 0, count: 0x80 + requiredTextureBytes + requiredPaletteBytes))
		
		self.writeMetaData()
	}
	
	func setUp() {
		
		self.width = data.get2BytesAtOffset(startOffset + kTextureWidthOffset)
		self.height = data.get2BytesAtOffset(startOffset + kTextureHeightOffset)
		self.textureStart = startOffset + Int(data.getWordAtOffset(startOffset + kTexturePointerOffset))
		self.paletteStart = startOffset + Int(data.getWordAtOffset(startOffset + kPalettePointerOffset))
		let formatIndex = data.getByteAtOffset(startOffset + kTextureFormatOffset)
		self.format = GoDTextureFormats(rawValue: formatIndex) ?? .C8
		self.paletteFormat = data.getByteAtOffset(startOffset + kPaletteFormatOffset)
		
	}
	
	func writeMetaData() {
		self.data.replace2BytesAtOffset(startOffset + kTextureWidthOffset, withBytes: self.width)
		self.data.replace2BytesAtOffset(startOffset + kTextureHeightOffset, withBytes: self.height)
		self.data.replaceByteAtOffset(startOffset + kTextureBPPOffset, withByte: self.BPP)
		self.data.replaceWordAtOffset(startOffset + kTexturePointerOffset, withBytes: UInt32(self.textureStart - startOffset))
		self.data.replaceWordAtOffset(startOffset + kPalettePointerOffset, withBytes: UInt32(self.paletteStart - startOffset))
		self.data.replaceByteAtOffset(startOffset + kTextureFormatOffset, withByte: self.format.rawValue)
		self.data.replaceByteAtOffset(startOffset + kPaletteFormatOffset, withByte: self.paletteFormat)
		self.data.replaceByteAtOffset(startOffset + kTextureIndexOffset, withByte: self.isIndexed ? 1 : 0)
	}
	
	func save() {
		self.writeMetaData()
		self.data.save()
	}
	
	func replaceTextureData(newBytes: [Int]) {
		self.data.replaceBytesFromOffset(self.textureStart, withByteStream: newBytes)
	}
	
	func replacePaletteData(newBytes: [Int]) {
		self.data.replaceBytesFromOffset(self.paletteStart, withByteStream: newBytes)
	}

	func palette() -> [Int] {
		return self.data.getShortStreamFromOffset(paletteStart, length: paletteLength)
	}

	func pixelData() -> [Int] {

		if BPP == 16 {
			return self.data.getShortStreamFromOffset(textureStart, length: self.textureLength)
		}
		if BPP == 4 {
			return self.data.getNibbleStreamFromOffset(textureStart, length: self.textureLength)
		}
		return self.data.getByteStreamFromOffset(textureStart, length: self.textureLength)
	}

	func pixelCharStream() -> [UInt8] {
		return self.data.getCharStreamFromOffset(textureStart, length: self.textureLength)
	}

	var image: XGImage {
		return self.croppedImage(width: self.width, height: self.height)
	}

	var pixels: [XGColour] {
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
			colourPixels = self.pixelData().map { (index) -> XGColour in
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
				colourPixels = self.pixelData().map({ (raw) -> XGColour in
					return XGColour(raw: raw, format: self.format)
				})
			}
		}
		return colourPixels
	}

	func croppedImage(width cWidth: Int, height cHeight: Int) -> XGImage {
		let colourPixels = pixels

		var pixelsPerRow = min(cWidth, width)
		var pixelsPerCol = min(cHeight, height)
		while pixelsPerRow % blockWidth != 0 {
			pixelsPerRow += 1
		}
		while pixelsPerCol % blockHeight != 0 {
			pixelsPerCol += 1
		}

		var markedPixels = [(x: Int, y: Int, colour: XGColour)]()

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

			markedPixels.append((x: x, y: y, colour: colour))
		}
		let orderedPixels = markedPixels
			.filter({ (p) -> Bool in
				return p.x < cWidth && p.y < cHeight
			})
			.sorted { (p1, p2) -> Bool in
			if p1.y == p2.y {
				return p1.x < p2.x
			}
			return p1.y < p2.y
		}.map { $0.colour }

		return XGImage(width: cWidth, height: cHeight, pixels: orderedPixels)

	}
}











