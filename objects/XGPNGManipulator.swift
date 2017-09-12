////
////  XGPNGManipulator.swift
////  XGCommandLineTools
////
////  Created by StarsMmd on 05/03/2017.
////  Copyright © 2017 StarsMmd. All rights reserved.
////
//
//import Foundation
//import Cocoa
//import ImageIO
//
//class XGImageTransformer {
//
//
//	class func transformImage(imageFilepath filepath: String, transformation: ((XGColour) -> XGColour)) {
//
//		let image = createImage(filepath: filepath)
//		pixelsFromCGImage(image: image!)
//
//
//	}
//
//	private class func createImage(filepath: String) -> CGImage? {
//		
//		
//		let url = NSURL(fileURLWithPath: filepath) as CFURL
//		let source = CGImageSourceCreateWithURL(url, nil)
//		
//		if source == nil {
//			print("image source doesn't exist: ", url)
//			return nil
//		}
//		
//		let ref = CGImageSourceCreateImageAtIndex(source!, 0, nil)
//		
//		if ref == nil {
//			print("couldn't create cg image: ", url)
//			return nil
//		}
//		
//		let pngdata = CGDataProvider(url: url)
//		let colourSpace = CGColorSpaceCreateDeviceRGB()
//		let info = CGBitmapInfo.byteOrder32Big.union(CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)).rawValue
//		
//		let image = CGImage(width: ref!.width, height: ref!.height, bitsPerComponent: 8, bitsPerPixel: 32, bytesPerRow: (ref!.width * 4), space: colourSpace, bitmapInfo: CGBitmapInfo(rawValue: info), provider: pngdata!, decode: nil, shouldInterpolate: false, intent: .defaultIntent)
//		
//		if image == nil {
//			print("couldn't create bitmap:", url)
//		}
//		
//		return image
//		
//	}
//	
//	private class func pixelsFromCGImage(image: CGImage)  {
//		
//		let imageAsCGRef = image
//		
//		let imageWidth  = imageAsCGRef.width
//		let imageHeight = imageAsCGRef.height
//		
//		let numberOfPixels = imageWidth * imageHeight
//		
//		var pixels = [UInt32](repeating: 0, count: numberOfPixels)
//		
//		let bytesPerPixel = 4
//		let bytesPerRow = bytesPerPixel * imageWidth
//		let bitsPerComponent = 8
//		
//		let colourSpace = CGColorSpaceCreateDeviceRGB()
//		let info = CGBitmapInfo.byteOrder32Big.union(CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)).rawValue
//		
//		let context = CGContext(data: &pixels, width: imageWidth, height: imageHeight, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colourSpace, bitmapInfo: info)!
//		
//		let rect = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)
//		
//		context.draw(imageAsCGRef, in: rect)
//		
//		for pixel in pixels {
//			print(String(format:"%08x",pixel))
//		}
//		
//	}
//	
//
//
//}
//
//
//
//
//
//
//
//
//
//
//
//
