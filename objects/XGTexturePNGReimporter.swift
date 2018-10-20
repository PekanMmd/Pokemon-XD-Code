////
////  XGTexturePNGReimporter.swift
////  XG Tool
////
////  Created by StarsMmd on 22/05/2015.
////  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import UIKit

//let kTexturePointerOffset = 0x28
//let kPalettePointerOffset = 0x48

class XGTexturePNGReimporter: NSObject {
	
	var texture  = XGMutableData()
	var newImage = UIImage()
	
	var Palette  = XGTexturePalette()
	
	var textureDataStartOffset = 0x80
	var PaletteDataStartOffset = 0x00
	
	// number of blocks that tile horizontally across the image
	var horizontalTiles = 0
	var blockWidth  = 0
	var blockHeight = 0
	
	// number of pixels needed to be appended for width to be multiple of 8
	var requiredPixelsPerRow = 0
	
	var indexed = false
	
	init(oldTextureData: XGMutableData, newImage: UIImage) {
		super.init()
		
		self.texture  = oldTextureData
		self.newImage = newImage
		
		self.textureDataStartOffset = Int(texture.getWordAtOffset(kTexturePointerOffset))
		self.PaletteDataStartOffset = Int(texture.getWordAtOffset(kPalettePointerOffset))
		
		if PaletteDataStartOffset != 0 {
			self.blockWidth  = 8
			self.blockHeight = 4
			indexed = true
		} else {
			self.blockWidth  = 4
			self.blockHeight = 4
		}
		
	}
	
	private func pixelsFromPNGImage() -> [XGPNGBlock] {
		
		let imageAsCGRef = self.newImage.cgImage
		
		let imageWidth  = imageAsCGRef!.width
		let imageHeight = imageAsCGRef!.height
		
		requiredPixelsPerRow = (imageWidth % 8) == 0 ? 0 : 8 - (imageWidth % 8)
		
		let numberOfPixels = imageWidth * imageHeight
		
		self.horizontalTiles = Int( (imageWidth + requiredPixelsPerRow) / blockWidth)
		
		var pixels = [UInt32](repeating: 0, count: numberOfPixels)
		
		let bytesPerPixel = 4
		let bytesPerRow = bytesPerPixel * imageWidth
		let bitsPerComponent = 8
		
		let colourSpace = CGColorSpaceCreateDeviceRGB()
		let info = CGBitmapInfo.byteOrder32Big.union(CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)).rawValue
		
		let context = CGContext(data: &pixels, width: imageWidth, height: imageHeight, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colourSpace, bitmapInfo: info)
		
		let rect = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)
		
		context?.draw(imageAsCGRef!, in: rect)
		//		CGContextDrawImage(context, CGRect(0, 0, CGFloat(imageWidth), CGFloat(imageHeight)), imageAsCGRef)
		
		var pngblock = [XGPNGBlock]()
		
		let totalPixelCount = numberOfPixels + (imageHeight * requiredPixelsPerRow)
		
		for _ in 0 ..< ( totalPixelCount  / (blockWidth * blockHeight)) {
			pngblock.append(XGPNGBlock())
		}
		
		for i in 0 ..< numberOfPixels {
			
			var currentColour = pixels[i]
			
			let red		  = Int((currentColour % 0x100) / 8)
			
			currentColour =  currentColour / 0x100
			let green	  = Int((currentColour % 0x100) / 8)
			
			currentColour =  currentColour / 0x100
			let blue	  = Int((currentColour % 0x100) / 8)
			
			// alpha value is only 1 bit so anything over 0 is considered 100% opaque.
			currentColour =  currentColour / 0x100
			let alpha	  = Int((currentColour % 0x100))
			
			let pixelColour = XGColour(red: red, green: green, blue: blue, alpha: alpha)
			
			let pixelColumn = i % imageWidth
			
			let row		= i / (imageWidth * blockHeight)
			let column  = pixelColumn / blockWidth
			
			let index = (row * horizontalTiles) + column
			
			pngblock[index].append(pixelColour)
			
			// if width isn't divisible by block size, extra transparent pixels are added
			if pixelColumn == (imageWidth - 1) {
				for _ in 0 ..< requiredPixelsPerRow {
					pngblock[index].append(XGColour.none())
				}
			}
			
		}
		
		return pngblock
	}
	
	private func convertPNGPixelsToIndexedPixels(pixels: [XGPNGBlock]) -> [XGTextureBlock] {
		
		var textureBlock = [XGTextureBlock]()
		
		for block in pixels {
			
			let tex = XGTextureBlock()
			
			for i in 0 ..< (blockWidth * blockHeight) {
				
				var index = Palette.indexForColour(block[i])
				if index == nil {
					
					if Palette.length < 256 {
						Palette.append(block[i])
						index = Palette.indexForColour(block[i])
					} else {
						index = 0
					}
				}
				
				tex.append(index!)
				
			}
			
			textureBlock.append(tex)
		}
		
		return textureBlock
	}
	
	private func byteStreamFromTexturePixels(pixels: [XGTextureBlock]) -> [Int] {
		
		var bytes = [Int]()
		
		for block in pixels {
			
			for i in 0 ..< block.length {
				let byte = block[i]
				bytes.append(byte)
			}
		}
		
		return bytes
	}
	
	private func byteStreamFromPNGPixels(pixels: [XGPNGBlock]) -> [Int] {
		
		var bytes = [Int]()
		
		for block in pixels {
			
			for i in 0 ..< block.length {
				
				let (byte1, byte2) = (0,0)
				
				bytes.append(byte1)
				bytes.append(byte2)
			}
		}
		
		return bytes
		
	}
	
	private func replaceTextureData() {
		
		let pngPixels = self.pixelsFromPNGImage()
		var pixelBytes = [Int]()
		if indexed {
			let texPixels = self.convertPNGPixelsToIndexedPixels(pixels: pngPixels)
			pixelBytes = byteStreamFromTexturePixels(pixels: texPixels)
			self.updatePalette()
		} else {
			pixelBytes = self.byteStreamFromPNGPixels(pixels: pngPixels)
		}
		
		texture.replaceBytesFromOffset(self.textureDataStartOffset, withByteStream: pixelBytes)
	}
	
	func updatePalette() {
		
		var bytes = [Int]()
		
		for i in 0 ..< 256  {
			
			var colour = XGColour.none()
			
			if i < Palette.length {
				colour = Palette[i]
			}
			
			let (byte1, byte2) = (0,0)
			
			bytes.append(byte1)
			bytes.append(byte2)
		}
		
		texture.replaceBytesFromOffset(PaletteDataStartOffset, withByteStream: bytes)
		
	}
	
	class func replaceTextureData(textureFile: XGFiles, withImage newImageFile: XGFiles) {
		
		if !textureFile.exists || !newImageFile.exists {
			return
		}
		
		let data  = textureFile.data
		let image = newImageFile.image
		
		let importer = XGTexturePNGReimporter(oldTextureData: data, newImage: image)
		importer.replaceTextureData()
		
		importer.texture.save()
	}
	
	
}













