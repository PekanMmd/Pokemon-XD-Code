//
//  GoDDesign.swift
//  GoD Tool
//
//  Created by StarsMmd on 29/06/2016.
//  Copyright © 2016 StarsMmd. All rights reserved.
//

import AppKit

class GoDDesign: NSObject {
	
	//MARK: - Fonts
	class func fontOfSize(_ size: CGFloat) -> NSFont {
		return NSFont(name: "Helvetica", size: size)!
	}
	
	class func fontBoldOfSize(_ size: CGFloat) -> NSFont {
		return NSFont(name: "Helvetica Bold", size: size)!
	}
	
	
	//MARK: - Sizes
	class func sizeCornerRadius() -> CGFloat {
		return 12.0
	}
	
	class func sizeBottomButton() -> CGFloat {
		return 60.0
	}
	
	
	//MARK: - Colours
	
	class func colourFromHex(_ hex: Double) -> NSColor {
		let red   = CGFloat((hex  / 0x1000000) / 0xFF)
		let green = CGFloat(((hex / 0x10000).truncatingRemainder(dividingBy: 0x100)) / 0xFF)
		let blue  = CGFloat(((hex / 0x100).truncatingRemainder(dividingBy: 0x100)) / 0xFF)
		let alpha = CGFloat((hex.truncatingRemainder(dividingBy: 0x100))     / 0xFF)
		
		return NSColor(red: red, green: green, blue: blue, alpha: alpha)
	}
	
	class func colourClear() -> NSColor {
		return colourFromHex(0x00000000)
	}
	
	class func colourBlack() -> NSColor {
		return colourFromHex(0x000000FF)
	}
	
	class func colourWhite() -> NSColor {
		return colourFromHex(0xFFFFFFFF)
	}
	
	class func colourRed() -> NSColor {
		return colourFromHex(0xFC6848FF)
	}
	
	class func colourOrange() -> NSColor {
		return colourFromHex( 0xF7B409FF)
	}
	
	class func colourYellow() -> NSColor {
		return colourFromHex( 0xF8F888FF)
	}
	
	class func colourGreen() -> NSColor {
		return colourFromHex( 0xA8E79CFF)
	}
	
	class func colourBlue() -> NSColor {
		return colourFromHex( 0x70ACFFFF)
	}
	
	class func colourPurple() -> NSColor {
		return colourFromHex( 0xA030FFFF)
	}
	
	class func colourPink() -> NSColor {
		return colourFromHex( 0xFC80F6FF)
	}
	
	class func colourNavy() -> NSColor {
		return colourFromHex( 0x28276BFF)
	}
	
	class func colourLightBlack() -> NSColor {
		return colourFromHex( 0x282828FF)
	}
	
	class func colourGrey() -> NSColor {
		return colourFromHex( 0xC0C0C8FF)
	}
	
	class func colourDarkGrey() -> NSColor {
		return colourFromHex( 0xA0A0A8FF)
	}
	
	class func colourLightGrey() -> NSColor {
		return colourFromHex( 0xF0F0FCFF)
	}
	
	class func colourMainTheme() -> NSColor {
		return colourWhite()
	}
	
	class func colourBackground() -> NSColor {
		return colourLightGrey()
	}
	
	class func colourBlur() -> NSColor {
		return colourFromHex( 0x70ACFF80)
	}
	
	//MARK: - Dates
	class func dateFormatter() -> DateFormatter {
		let formatter = DateFormatter()
		formatter.dateStyle = .medium
		formatter.timeStyle = .short
		return formatter
	}
	
	//MARK: - Photos
	class func photoDefault() -> NSImage {
		let image = NSImage(named: "PhotoDefault")!
		return image
	}
	
}







