//
//  XGFiles + image.swift
//  GoD Tool
//
//  Created by StarsMmd on 20/08/2017.
//
//

import Cocoa

extension XGFiles {
	var image : NSImage {
		get {
			if !self.exists {
				printg("Image file doesn't exist:", self.path)
			}
			return NSImage(contentsOfFile: self.path)!
		}
	}
}

extension XGMutableData {
	var texture : GoDTexture {
		get {
			return GoDTexture(data: self)
		}
	}
}

extension XGTrainerModels {
	var image : NSImage {
		let val = self.rawValue >= XGFolders.Trainers.files.count ? 0 : self.rawValue
		return XGFiles.trainerFace(val).image
	}
}

extension XGPokemon {
	var face : NSImage {
		get {
			return XGFiles.pokeFace(self.index).image
		}
	}
	
	var body : NSImage {
		get {
			return XGFiles.pokeBody(self.index).image
		}
	}
}

extension XGMoveTypes {
	var image : NSImage {
		get {
			return XGFiles.typeImage(self.rawValue).image
		}
	}
	
	static var shadowImage : NSImage {
		return XGFiles.nameAndFolder("type_shadow.png", .Types).image
	}
}

extension XGResources {
	var image : NSImage {
		get {
			return NSImage(contentsOfFile: self.path) ?? NSImage()
		}
	}
}


extension NSImage {
	var bitmap : [XGColour] {
		let imageWidth  = Int(self.size.width)
		let imageHeight = Int(self.size.height)
		
		let numberOfPixels = imageWidth * imageHeight
		var pixels = [UInt32](repeating: 0, count: numberOfPixels)
		
		let bytesPerPixel = 4
		let bytesPerRow = bytesPerPixel * imageWidth
		let bitsPerComponent = 8
		var rect = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)
		
		let colourSpace = CGColorSpaceCreateDeviceRGB()
		let info = CGBitmapInfo.byteOrder32Big.union(CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)).rawValue
		
		let context = CGContext(data: &pixels, width: imageWidth, height: imageHeight, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colourSpace, bitmapInfo: info)!
		
		let graphicsContext = NSGraphicsContext(cgContext: context, flipped: false)
		
		let imageAsCGRef = self.cgImage(forProposedRect: &rect, context: graphicsContext, hints: nil)!
		
		context.draw(imageAsCGRef, in: rect)
		
		return pixels.map({ (raw) -> XGColour in
			var currentColour = raw
			
			let red		  = Int(currentColour & 0xFF)
			
			currentColour =  currentColour >> 8
			let green	  = Int(currentColour & 0xFF)
			
			currentColour =  currentColour >> 8
			let blue	  = Int(currentColour & 0xFF)
			
			currentColour =  currentColour >> 8
			let alpha	  = Int(currentColour)
			
			return XGColour(red: red, green: green, blue: blue, alpha: alpha)
		})
	}
	
	var colourCount : Int {
		return self.colourCount(threshold: 0)
	}
	
	func colourCount(threshold: Int) -> Int {
		XGColour.colourThreshold = threshold
		let palette = XGTexturePalette()
		for colour in self.bitmap {
			if palette.indexForColour(colour) == nil {
				palette.append(colour)
			}
		}
		return palette.length
	}
	
	var texture : GoDTexture {
		return GoDTextureImporter.getTextureData(image: self)
	}
}
