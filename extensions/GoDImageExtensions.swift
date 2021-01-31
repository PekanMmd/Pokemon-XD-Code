//
//  XGFiles + image.swift
//  GoD Tool
//
//  Created by StarsMmd on 20/08/2017.
//
//

#if canImport(Cocoa)
import Cocoa

extension XGFiles {
	var image: NSImage {
		if !self.exists {
			printg("Image file doesn't exist:", self.path)
		}
		return NSImage(contentsOfFile: self.path) ?? NSImage()
	}
}

extension XGTrainerModels {
	var image: NSImage {
		let val = self.rawValue >= XGFolders.Trainers.files.count ? 0 : self.rawValue
		return XGFiles.trainerFace(val).image
	}
}

extension XGPokemon {
	var face: NSImage {
		return XGFiles.pokeFace(self.index).image
	}

	var body: NSImage {
		return XGFiles.pokeBody(self.index).image
	}
}

extension XGMoveTypes {
	var image: NSImage {
		return XGFiles.typeImage(self.rawValue).image
	}

	static var shadowImage : NSImage {
		return XGFiles.nameAndFolder("type_shadow.png", .Types).image
	}
}

extension XGResources {
	var image: NSImage {
		get {
			return NSImage(contentsOfFile: self.path) ?? NSImage()
		}
	}
}

extension NSImage {
	var width: Int {
		return Int(size.width)
	}

	var height: Int {
		return Int(size.height)
	}
	
	var bitmap : [XGColour] {
		let imageWidth  = Int(self.size.width)
		let imageHeight = Int(self.size.height)

		let numberOfPixels = imageWidth * imageHeight
		var pixelData = [UInt32](repeating: 0, count: numberOfPixels)

		let bytesPerPixel = 4
		let bytesPerRow = bytesPerPixel * imageWidth
		let bitsPerComponent = 8
		var rect = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)

		let colourSpace = CGColorSpaceCreateDeviceRGB()
		let info = CGBitmapInfo.byteOrder32Big.union(CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)).rawValue

		let context = CGContext(data: &pixelData, width: imageWidth, height: imageHeight, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colourSpace, bitmapInfo: info)!

		let graphicsContext = NSGraphicsContext(cgContext: context, flipped: false)

		let imageAsCGRef = self.cgImage(forProposedRect: &rect, context: graphicsContext, hints: nil)!

		context.draw(imageAsCGRef, in: rect)

		return pixelData.map({ (raw) -> XGColour in
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
}

extension NSColor {
	var vec3: [Float] {
		return [Float(self.redComponent), Float(self.greenComponent), Float(self.blueComponent)]
	}
}

extension XGColour {
	var NSColour: NSColor {
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













