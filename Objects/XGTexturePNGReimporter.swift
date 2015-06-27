//
//  XGTexturePNGReimporter.swift
//  XG Tool
//
//  Created by The Steez on 22/05/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//

import UIKit

let kTexturePointerOffset = 0x28
let kPalettePointerOffset = 0x48

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
	
	var indexed = false
	
	init(oldTextureData: XGMutableData, newImage: UIImage) {
		super.init()
		
		self.texture  = oldTextureData
		self.texture.file = XGFiles.NameAndFolder(texture.file.fileName, .Output)
		self.newImage = newImage
		
		self.textureDataStartOffset = Int(texture.get4BytesAtOffset(kTexturePointerOffset))
		self.PaletteDataStartOffset = Int(texture.get4BytesAtOffset(kPalettePointerOffset))
		
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
		
		let imageAsCGRef = self.newImage.CGImage
		
		let imageWidth  = CGImageGetWidth(imageAsCGRef)
		let imageHeight = CGImageGetHeight(imageAsCGRef)
		
		let numberOfPixels = imageWidth * imageHeight
		
		self.horizontalTiles = Int(imageWidth / blockWidth)
		
		var pixels = [UInt32](count: numberOfPixels, repeatedValue: 0)
		
		let bytesPerPixel = 4
		let bytesPerRow = bytesPerPixel * imageWidth
		let bitsPerComponent = 8
		
		let colourSpace = CGColorSpaceCreateDeviceRGB()
		let info = CGBitmapInfo.ByteOrder32Big | CGBitmapInfo(CGImageAlphaInfo.PremultipliedLast.rawValue)
		
		let context = CGBitmapContextCreate(&pixels, imageWidth, imageHeight, bitsPerComponent, bytesPerRow, colourSpace, info)
		
		CGContextDrawImage(context, CGRectMake(0, 0, CGFloat(imageWidth), CGFloat(imageHeight)), imageAsCGRef)
		
		var pngblock = [XGPNGBlock]()
		
		for var j = 0; j < numberOfPixels / (blockWidth * blockHeight); j++ {
			pngblock.append(XGPNGBlock())
		}
		
		for var i = 0; i < numberOfPixels; i++ {
			
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
			
			let row		= i / (horizontalTiles * blockWidth * blockHeight)
			let column  = (i / blockWidth) % horizontalTiles
			
			let index = (row * horizontalTiles) + column
			
			pngblock[index].append(pixelColour)
			
		}
		
		return pngblock
	}
	
	private func convertPNGPixelsToIndexedPixels(pixels: [XGPNGBlock]) -> [XGTextureBlock] {
		
		var textureBlock = [XGTextureBlock]()
		
		for block in pixels {
			
			var tex = XGTextureBlock()
			
			for var i = 0; i < (blockWidth * blockHeight); i++ {
				
				
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
			
			for var i = 0; i < block.length; i++ {
				let byte = block[i]
				bytes.append(byte)
			}
		}
		
		return bytes
	}
	
	private func byteStreamFromPNGPixels(pixels: [XGPNGBlock]) -> [Int] {
		
		var bytes = [Int]()
		
		for block in pixels {
			
			for var i = 0; i < block.length; i++ {
				
				let (byte1, byte2) = block[i].convertTo16Bits()
				
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
			let texPixels = self.convertPNGPixelsToIndexedPixels(pngPixels)
			pixelBytes = byteStreamFromTexturePixels(texPixels)
			self.updatePalette()
		} else {
			pixelBytes = self.byteStreamFromPNGPixels(pngPixels)
		}
		
		texture.replaceBytesFromOffset(self.textureDataStartOffset, withByteStream: pixelBytes)
	}
	
	func updatePalette() {
		
		var bytes = [Int]()
		
		for var i = 0; i < 256; i++  {
			
			var colour = XGColour.none()
			
			if i < Palette.length {
				colour = Palette[i]
			}
			
			let (byte1, byte2) = colour.convertTo16Bits()
			
			bytes.append(byte1)
			bytes.append(byte2)
		}
		
		texture.replaceBytesFromOffset(PaletteDataStartOffset, withByteStream: bytes)
		
	}
	
	class func replaceTextureData(textureFile: XGFiles, withImage newImageFile: XGFiles) -> Bool {
		
		if !textureFile.exists || !newImageFile.exists {
			return false
		}
		
		var data  = textureFile.data
		var image = newImageFile.image
		
		let importer = XGTexturePNGReimporter(oldTextureData: data, newImage: image)
		importer.replaceTextureData()
			
		return importer.texture.save()
	}
	
   
}













