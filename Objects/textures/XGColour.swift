//
//  XGColour.swift
//  XG Tool
//
//  Created by StarsMmd on 23/05/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

class XGColour: Codable {
	
	static var colourThreshold = 4
	
	var red		= 0
	var green	= 0
	var blue	= 0
	var alpha	= 0

	var hex: Int {
		return (red << 24) + (green << 16) + (blue << 8) + alpha
	}

	var hexString: String {
		return hex.hexString()
	}
	
	init(red: Int, green: Int, blue: Int, alpha: Int) {
		self.red   = red
		self.green = green
		self.blue  = blue
		self.alpha = alpha
	}
	
	func isEqual(to colour: XGColour) -> Bool {
		
		func withinThreshold(c1: Int, c2: Int) -> Bool {
			return abs(c1 - c2) <= max(XGColour.colourThreshold, 0)
		}
		
		if (colour.alpha == 0) && (self.alpha == 0) {
			// both are transparent so accept as equivalent. Helps with compression since all transparent pixels will have the same value.
			
			return true
		}
		
		return withinThreshold(c1: colour.red, c2: self.red) && withinThreshold(c1: colour.green, c2: self.green) && withinThreshold(c1: colour.blue, c2: self.blue) && (colour.alpha == self.alpha)
	}
	
	func representation(format: GoDTextureFormats) -> Int {
		switch format {
		case .I4:
			return I4Representation
		case .I8:
			return I8Representation
		case .IA4:
			return IA4Representaion
		case .IA8:
			return IA8Representaion
		case .RGB565:
			return RGB565Representation
		case .RGB5A3:
			return RGB5A3Representation
		case .RGBA32:
			return RGBA32IntRepresentation
		case .CMPR:
			return RGB565Representation
		default:
			return 0
		}
	}
	
	var I4Representation : Int {
		return (red + green + blue) / (3 * 0x11)
	}
	
	var I8Representation : Int {
		return (red + green + blue) / 3
	}
	
	var IA4Representaion : Int {
		return ((alpha / 0x11) << 4) + (red + green + blue) / (3 * 0x11)
	}
	
	var IA8Representaion : Int {
		return (alpha << 8) + ((red + green + blue) / 3 )
	}
	
	var RGB565Representation : Int {
		get {
			var value = 0
			
			value += (red / 8)   << 11
			value += (green / 4) << 5
			value += (blue / 8)
			
			return value
		}
	}
	
	var RGB5A3Representation : Int {
		get {
			var value = 0
			
			if alpha == 0xFF {
				value += 1 << 15
				value += (red / 8)   << 10
				value += (green / 8) << 5
				value += (blue / 8)
			} else {
				value += (alpha / 0x20) << 12
				value += (red / 0x11)   << 8
				value += (green / 0x11) << 4
				value += (blue / 0x11)
			}
			
			return value
		}
	}
	
	var RGBA32Representation : [UInt8] {
		return [alpha, red, green, blue].map({ (i) -> UInt8 in
			return UInt8(i)
		})
	}
	
	var RGBA32IntRepresentation : Int {
		return (alpha << 24) + (red << 16) + (green << 8) + blue
	}
	
	class func none() -> XGColour {
		return XGColour(red: 0, green: 0, blue: 0, alpha: 0)
	}
	
	convenience init(raw: Int, format: GoDTextureFormats? = nil) {
		self.init(red: 0, green: 0, blue: 0, alpha: 0)
		
		switch format {
		case nil:
			setStandardRGBA(raw: raw.unsigned)
		case .I4:
			setI4(raw: raw)
		case .I8:
			setI8(raw: raw)
		case .IA4:
			setIA4(raw: raw)
		case .IA8:
			setIA8(raw: raw)
		case .RGB565:
			setRGB565(raw: raw)
		case .RGB5A3:
			setRGB5A3(raw: raw)
		case .RGBA32:
			self.init(raw: raw.unsigned, format: .RGBA32)
		default:
			break
		}
	}
	
	convenience init(raw: UInt32, format: GoDTextureFormats? = nil) {
		self.init(red: 0, green: 0, blue: 0, alpha: 0)
		
		switch format {
		case nil:
			setStandardRGBA(raw: raw)
		case .RGBA32:
			setRGBA32(raw: raw)
		case .I4:
			setI4(raw: raw.int)
		case .I8:
			setI8(raw: raw.int)
		case .IA4:
			setIA4(raw: raw.int)
		case .IA8:
			setIA8(raw: raw.int)
		case .RGB565:
			setRGB565(raw: raw.int)
		case .RGB5A3:
			setRGB5A3(raw: raw.int)
		default:
			break
		}
	}
	
	func setI4(raw: Int) {
		let value = raw * 0x11
		self.red = value
		self.green = value
		self.blue = value
		self.alpha = 0xFF
	}
	
	func setI8(raw: Int) {
		self.red = raw
		self.green = raw
		self.blue = raw
		self.alpha = 0xFF
	}
	
	func setIA4(raw: Int) {
		let value = (raw % 16) * 0x11
		self.red = value
		self.green = value
		self.blue = value
		self.alpha = (raw >> 4) * 0x11
	}
	
	func setIA8(raw: Int) {
		let value = (raw % 256)
		self.red = value
		self.green = value
		self.blue = value
		self.alpha = (raw >> 8)
	}
	
	func setRGB565(raw: Int) {
		var currentColour = raw
		
		self.blue = (currentColour % 0x20) * 8
		
		currentColour = currentColour >> 5
		self.green = (currentColour % 0x40) * 4
		
		currentColour = currentColour >> 6
		self.red = currentColour * 8
		
		self.alpha = 0xFF
	}
	
	func setRGB5A3(raw: Int) {
		
		let top = raw >> 15
		
		if top == 1 {
			var currentColour = raw & 0x7FFF
			
			self.blue = (currentColour % 0x20) * 8
			
			currentColour = currentColour >> 5
			self.green = (currentColour % 0x20) * 8
			
			currentColour = currentColour >> 5
			self.red = (currentColour % 0x20) * 8
			
			self.alpha = 0xFF
		} else {
			var currentColour = raw & 0x7FFF
			
			self.blue = (currentColour % 0x10) * 0x11
			
			currentColour = currentColour >> 4
			self.green = (currentColour % 0x10) * 0x11
			
			currentColour = currentColour >> 4
			self.red = (currentColour % 0x10) * 0x11
			
			currentColour = currentColour >> 4
			self.alpha = currentColour * 0x20
		}
		
	}
	
	func setRGBA32(raw: UInt32) {
		self.alpha   = ((raw >> 24) & 0xFF).int32
		self.red = ((raw >> 16) & 0xFF).int32
		self.green  = ((raw >>  8) & 0xFF).int32
		self.blue = ((raw) & 0xFF).int32
	}
	
	func setStandardRGBA(raw: UInt32) {
		self.red   = ((raw >> 24) & 0xFF).int32
		self.green = ((raw >> 16) & 0xFF).int32
		self.blue  = ((raw >>  8) & 0xFF).int32
		self.alpha = ((raw) & 0xFF).int32
	}

	var hsv: (hue: Double, saturation: Double, value: Double) {
		let r = Double(red)
		let g = Double(green)
		let b = Double(blue)

		let minV = min(r, g, b)
		let maxV = max(r, g, b)

		let delta = maxV - minV
		var hue: Double = 0

		if delta != 0 {
			if r == maxV {
				hue = (g - b) / delta
			}
			else if g == maxV {
				hue = 2 + (b - r) / delta
			}
			else {
				hue = 4 + (r - g) / delta
			}
			hue *= 60
			if hue < 0 {
				hue += 360
			}
			hue /= 360
		}
		let saturation = maxV == 0 ? 0 : (delta / maxV)
		let brightness = maxV

		return (hue: hue, saturation :saturation, value:brightness)
	}
}















