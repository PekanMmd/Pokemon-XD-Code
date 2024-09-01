//
//  GoDTextureImporter.swift
//  GoD Tool
//
//  Created by The Steez on 12/09/2017.
//
//

import Foundation

class GoDTextureImporter {
	
	let texture: GoDTexture
	let newImage: XGImage
	
	var Palette  = XGTexturePalette()
	
	// number of pixels needed to be appended for width to be multiple of 8
	var requiredPixelsPerRow = 0
	var requiredPixelsPerCol = 0
	
	init(oldTextureData: GoDTexture, newImage: XGImage) {
		self.texture  = oldTextureData
		self.newImage = newImage
		
	}
	
	private func pixelsFromImage() -> [XGPNGBlock] {

		let image = newImage
		let imageWidth  = min(texture.width, image.width)
		let imageHeight = min(texture.height, image.height)
		
		requiredPixelsPerRow = (imageWidth % texture.blockWidth) == 0 ? 0 : texture.blockWidth - (imageWidth % texture.blockWidth)
		requiredPixelsPerCol = (imageHeight % texture.blockHeight) == 0 ? 0 : texture.blockHeight - (imageHeight % texture.blockHeight)
		
		let numberOfPixels = imageWidth * imageHeight
		
		let horizontalTiles = (imageWidth + requiredPixelsPerRow) / texture.blockWidth
		
		var pngblock = [XGPNGBlock]()
		
		var totalPixelCount = numberOfPixels + (imageHeight * requiredPixelsPerRow)
		totalPixelCount += requiredPixelsPerCol * (imageWidth + requiredPixelsPerRow)
		
		for _ in 0 ..< ( totalPixelCount  / (texture.blockWidth * texture.blockHeight)) {
			pngblock.append(XGPNGBlock())
		}

		let pixels = image.pixels.map {
			$0.RGBA32Representation
		}
		for i in 0 ..< numberOfPixels {
			
			let currentColour = i < pixels.count ? pixels[i] : [0,0,0,0]

			let alpha	  = Int(currentColour[0])
			let red		  = Int(currentColour[1])
			let green	  = Int(currentColour[2])
			let blue	  = Int(currentColour[3])

			let pixelColour = XGColour(red: red, green: green, blue: blue, alpha: alpha)
			
			let pixelColumn = i % imageWidth
			
			let row		= i / (imageWidth * texture.blockHeight)
			let column  = pixelColumn / texture.blockWidth
			
			let index = (row * horizontalTiles) + column
			
			pngblock[index].append(pixelColour)
			
			// if width isn't divisible by block size, extra transparent pixels are added
			if pixelColumn == (imageWidth - 1) {
				for _ in 0 ..< requiredPixelsPerRow {
					pngblock[index].append(XGColour.none())
				}
			}
			
		}
		
		// fills bottom rows if height not divisible by block height
		for block in pngblock {
			while block.length < (texture.blockHeight * texture.blockWidth) {
				block.append(XGColour.none())
			}
		}
		
		return pngblock.map(restructurePNGBlockForCMPR)
	}
	
	private func restructurePNGBlockForCMPR(_ block: XGPNGBlock) -> XGPNGBlock {
		guard texture.format == .CMPR else { return block }
		
		var sub4x4Blocks = [[XGColour]](repeating: [XGColour](), count: 4)
		let subBlockSize = 16
		let subBlockWidth = 4
		
		for pixelIndex in 0 ..< block.length {
			let colour = block[pixelIndex]
			var subBlockIndex = 0
			if pixelIndex % (subBlockWidth * 2) >= subBlockWidth {
				subBlockIndex += 1
			}
			if pixelIndex >= subBlockSize * 2 {
				subBlockIndex += 2
			}
			sub4x4Blocks[subBlockIndex].append(colour)
		}
		
		let restructuredBlock = XGPNGBlock()
		for subBlock in sub4x4Blocks {
			for colour in subBlock {
				restructuredBlock.append(colour)
			}
		}
		
		return restructuredBlock
	}
	
	private func convertPixelsToIndexedPixels(pixels: [XGPNGBlock]) -> [XGTextureBlock] {
		
		var textureBlocks = [XGTextureBlock]()
		
		for block in pixels {
			
			let tex = XGTextureBlock()
			
			for i in 0 ..< block.length {
				
				if texture.isIndexed {
					var index = Palette.indexForColour(block[i])
					if index == nil {
						
						if Palette.length < texture.paletteCount {
							Palette.append(block[i])
							index = Palette.indexForColour(block[i])
						} else {
							index = 0
						}
					}
					
					tex.append(index!)
				} else {
					tex.append(block[i].representation(format: texture.format))
				}
				
			}
			
			textureBlocks.append(tex)
		}
		
		while Palette.length < texture.paletteCount {
			Palette.append(XGColour.none())
		}
		
		return textureBlocks
	}
	
	private func compressPixels(pixels: [XGPNGBlock]) -> [XGTextureBlock] {
		
		var textureBlocks = [XGTextureBlock]()
		let subBlockSize = 16
		
		for block in pixels {
			
			let tex = XGTextureBlock()
			
			for subBlockIndex in 0 ... 3 {
				
				var subBlockColours = [XGColour]()
				var uniqueColours = [Int]()
				let subBlockStartIndex = subBlockSize * subBlockIndex
				var hasTransparency = false
				
				for pixelIndex in subBlockStartIndex ..< subBlockStartIndex + subBlockSize {
					let colour = block[pixelIndex]
					hasTransparency = hasTransparency || colour.alpha < 0x80
					if colour.alpha >= 0x80 {
						uniqueColours.addUnique(colour.representation(format: .CMPR))
					}
					subBlockColours.append(colour)
				}
				
				if uniqueColours.count == 0 {
					// all transparent
					for _ in 0 ..< 4 {
						tex.append(0)
					}
					for _ in 0 ..< 4 {
						tex.append(0xFF)
					}
				} else if uniqueColours.count == 1 {
					let colour = uniqueColours[0]
					for _ in 0 ..< 2 {
						for byte in colour.byteArrayU16 {
							tex.append(byte)
						}
					}
					
					var indexes = 0
					for colour in subBlockColours {
						indexes = indexes << 2
						indexes |= colour.alpha < 0x80 ? 3 : 0
					}
					for byte in indexes.byteArray {
						tex.append(byte)
					}
					
				} else {
					func range(_ c0: XGColour, _ c1: XGColour) -> Int {
						let red = abs(c0.red - c1.red)
						let green = abs(c0.green - c1.green)
						let blue = abs(c0.blue - c1.blue)
						return red + green + blue
					}
					
					var bestC0 = 0
					var bestC1 = 0
					var greatestRange = 0
					for testC0 in uniqueColours.map({ XGColour(raw: $0, format: .RGB565) }) {
						for testC1 in uniqueColours.map({ XGColour(raw: $0, format: .RGB565) }) {
							let currentRange = range(testC0, testC1)
							if currentRange > greatestRange {
								greatestRange = currentRange
								bestC0 = testC0.RGB565Representation
								bestC1 = testC1.RGB565Representation
							}
						}
					}
					
					let hex1: Int
					let hex2: Int
					if hasTransparency {
						hex1 = min(bestC0, bestC1)
						hex2 = max(bestC0, bestC1)
					} else {
						hex1 = max(bestC0, bestC1)
						hex2 = min(bestC0, bestC1)
					}
					
					var hexPalette = [XGColour]()
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
					
					let indexesArray = subBlockColours.map { (colour) -> Int in
						if colour.alpha < 0x80 {
							return 3
						}
						var index = 0
						var minRange = 255 * 255 * 255
						for i in 0 ..< hexPalette.count {
							let currentRange = range(colour, hexPalette[i])
							if currentRange < minRange {
								minRange = currentRange
								index = i
							}
						}
						return index
					}
					
					var indexes = 0
					for index in indexesArray {
						indexes = indexes << 2
						indexes |= index
					}
					
					for colour in [colour1.RGB565Representation, colour2.RGB565Representation] {
						for byte in colour.byteArrayU16 {
							tex.append(byte)
						}
					}
					for byte in indexes.byteArray {
						tex.append(byte)
					}
				}
				
			}
			
			textureBlocks.append(tex)
		}
		
		return textureBlocks
	}
	
	private func byteStreamFromTexturePixels(pixels: [XGTextureBlock]) -> [Int] {
		
		var bytes = [Int]()
		
		for block in pixels {
			
			if texture.format.bitsPerPixel == 4 && texture.format != .CMPR {
				
				for i in 0 ..< block.length / 2 {
					let highBits = block[i * 2]
					let lowBits = block[(i * 2) + 1]
					let byte = highBits << 4 | lowBits
					bytes.append(byte)
				}
				
			} else {
				for i in 0 ..< block.length {
					let byte = block[i]
					bytes.append(byte)
				}
			}
		}
		
		return bytes
	}
	
	private func byteStreamFromPixels(pixels: [XGPNGBlock]) -> [Int] {
		
		var bytes = [Int]()
		
		for block in pixels {
			
			if texture.BPP == 4 {
				for i in 0 ..< (block.length / 2) {
					
					let raw1 = block[i * 2].representation(format: texture.format)
					let raw2 = block[(i * 2) + 1].representation(format: texture.format)
					bytes.append((raw1 << 4) | raw2)
				}
			} else {
				for i in 0 ..< block.length {
					
					let raw = block[i].representation(format: texture.format)
					
					if texture.BPP == 16 {
						bytes.append(raw >> 8)
						bytes.append(raw %  0x100)
					} else if texture.BPP == 32 {
						bytes.append(raw >> 24)
						bytes.append(raw >> 16 & 0xFF)
						bytes.append(raw >> 8 & 0xFF)
						bytes.append(raw & 0xFF)
					} else {
						bytes.append(raw)
					}
				}
			}
		}
		
		return bytes
		
	}
	
	func replaceTextureData() {
		
		let pngPixels = self.pixelsFromImage()
		var pixelBytes = [Int]()
		
		if texture.isIndexed {
			let texPixels = self.convertPixelsToIndexedPixels(pixels: pngPixels)
			pixelBytes = byteStreamFromTexturePixels(pixels: texPixels)
			self.updatePalette()
		} else if texture.format == .RGBA32 {
			let bytes = self.byteStreamFromPixels(pixels: pngPixels)
			var splitBytes = [Int]()
			// ar and gb values of rgba32 are separated within blocks so must restructure first
			let blockCount = bytes.count / 64 // 64 bytes per block, 4 pixelsperrow x 4 pixelspercolumn x 4 bytesperpixel
			
			for i in 0 ..< blockCount {
				let blockStart = i * 64
				var blockARs = [Int]()
				var blockGBs = [Int]()
				for j in 0 ..< 16 {
					let currentPixel = blockStart + (j * 4)
					blockARs.append(bytes[currentPixel])
					blockARs.append(bytes[currentPixel + 1])
					blockGBs.append(bytes[currentPixel + 2])
					blockGBs.append(bytes[currentPixel + 3])
				}
				splitBytes += blockARs + blockGBs
			}
			
			pixelBytes = splitBytes
			
		} else if texture.format == .CMPR {
			
			let compressedBlocks = compressPixels(pixels: pngPixels)
			pixelBytes = byteStreamFromTexturePixels(pixels: compressedBlocks)
			
			
		} else {
			pixelBytes = self.byteStreamFromPixels(pixels: pngPixels)
		}
		
		
		texture.replaceTextureData(newBytes: pixelBytes)
	}
	
	func updatePalette() {
		
		var bytes = [Int]()
		
		for i in 0 ..< texture.paletteCount  {
			
			var colour = XGColour.none()
			
			if i < Palette.length {
				colour = Palette[i]
				let raw = colour.representation(format: texture.paletteFormat)
				
				bytes.append(raw >> 8)
				bytes.append(raw %  0x100)
			}
			
			
		}
		
		texture.replacePaletteData(newBytes: bytes)
		
	}
	
	class func replaceTextureData(texture: GoDTexture, withImage newImage: XGImage, save: Bool = true) {
		
		let importer = GoDTextureImporter(oldTextureData: texture, newImage: newImage)
		importer.replaceTextureData()
		
		if save {
			importer.texture.save()
		}
	}
	
	class func getTextureData(image: XGImage, format: GoDTextureFormats, paletteFormat: GoDTextureFormats?) -> GoDTexture {
		
		let texture  = GoDTexture(forImage: image, format: format, paletteFormat: paletteFormat ?? .IA8)
		
		let importer = GoDTextureImporter(oldTextureData: texture, newImage: image)
		importer.replaceTextureData()
		
		return importer.texture
	}
	
	class func getTextureData(image: XGImage) -> GoDTexture {
		
		let colourCount = image.colourCount
		var format = GoDTextureFormats.C8
		
		if colourCount <= GoDTextureFormats.C4.paletteCount {
			format = .C4
		} else if colourCount <= GoDTextureFormats.C8.paletteCount {
			format = .C8
		} else if image.colourCount(threshold: 8) <= GoDTextureFormats.C8.paletteCount {
			format = .C8
		} else if image.colourCount(threshold: 16) <= GoDTextureFormats.C8.paletteCount {
			format = .C8
		} else {
			format = .RGB5A3
		}
		
		return getTextureData(image: image, format: format, paletteFormat: format.isIndexed ? .RGB5A3 : nil)
	}
	
	class func getMultiFormatTextureData(image: XGImage) -> [GoDTexture] {
		
		var textures = [GoDTexture]()
		
		for format in [GoDTextureFormats.C8, .C4, .RGB5A3, .RGBA32, GoDTextureFormats.CMPR] {
			var colourThreshold = 0
			if format == .C4 || format == .C8 {
				while image.colourCount(threshold: colourThreshold) > format.paletteCount && colourThreshold <= 24 {
					colourThreshold += 4
				}
			}
			XGColour.colourThreshold = colourThreshold
			
			let texture = getTextureData(image: image, format: format, paletteFormat: format.isIndexed ? .RGB5A3 : nil)
			textures.append(texture)
		}
		
		return textures
	}
	
}












