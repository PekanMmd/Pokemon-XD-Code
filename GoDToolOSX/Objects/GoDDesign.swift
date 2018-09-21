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
	@objc class func fontOfSize(_ size: CGFloat) -> NSFont {
		return NSFont(name: "Helvetica", size: size)!
	}
	
	@objc class func fontBoldOfSize(_ size: CGFloat) -> NSFont {
		return NSFont(name: "Helvetica Bold", size: size)!
	}
	
	
	//MARK: - Sizes
	@objc class func sizeCornerRadius() -> CGFloat {
		return 12.0
	}
	
	@objc class func sizeBottomButton() -> CGFloat {
		return 60.0
	}
	
	
	//MARK: - Colours
	
	@objc class func colourFromHex(_ hex: Double) -> NSColor {
		let red   = CGFloat((hex  / 0x1000000) / 0xFF)
		let green = CGFloat(((hex / 0x10000).truncatingRemainder(dividingBy: 0x100)) / 0xFF)
		let blue  = CGFloat(((hex / 0x100).truncatingRemainder(dividingBy: 0x100)) / 0xFF)
		let alpha = CGFloat((hex.truncatingRemainder(dividingBy: 0x100))     / 0xFF)
		
		return NSColor(red: red, green: green, blue: blue, alpha: alpha)
	}
	
	@objc class func colourClear() -> NSColor {
		return colourFromHex(0x00000000)
	}
	
	@objc class func colourBlack() -> NSColor {
		return colourFromHex(0x000000FF)
	}
	
	@objc class func colourWhite() -> NSColor {
		return colourFromHex(0xFFFFFFFF)
	}
	
	@objc class func colourRed() -> NSColor {
		return colourFromHex(0xFC6848FF)
	}
	
	@objc class func colourLightOrange() -> NSColor {
		return colourFromHex( 0xFFD080FF)
	}
	
	@objc class func colourOrange() -> NSColor {
		return colourFromHex( 0xF7B409FF)
	}
	
	@objc class func colourYellow() -> NSColor {
		return colourFromHex( 0xF8F888FF)
	}
	
	@objc class func colourLightGreen() -> NSColor {
		return colourFromHex( 0xD0FFD0FF)
	}
	
	@objc class func colourGreen() -> NSColor {
		return colourFromHex( 0xA8E79CFF)
	}
	
	@objc class func colourLightBlue() -> NSColor {
		return colourFromHex( 0xB8F0FFFF)
	}
	
	@objc class func colourBlue() -> NSColor {
		return colourFromHex( 0x80ACFFFF)
	}
	
	@objc class func colourLightPurple() -> NSColor {
		return colourFromHex( 0xE0C0FFFF)
	}
	
	@objc class func colourPurple() -> NSColor {
		return colourFromHex( 0xA070FFFF)
	}
	
	@objc class func colourPeach() -> NSColor {
		return colourFromHex( 0xFFE8D0FF)
	}
	
	@objc class func colourBabyPink() -> NSColor {
		return colourFromHex( 0xFFE0E8FF)
	}
	
	@objc class func colourPink() -> NSColor {
		return colourFromHex( 0xFC80F6FF)
	}
	
	@objc class func colourNavy() -> NSColor {
		return colourFromHex( 0x28276BFF)
	}
	
	@objc class func colourBrown() -> NSColor {
		return colourFromHex( 0xC0A078FF)
	}
	
	@objc class func colourLightBlack() -> NSColor {
		return colourFromHex( 0x282828FF)
	}
	
	@objc class func colourGrey() -> NSColor {
		return colourFromHex( 0xC0C0C8FF)
	}
	
	@objc class func colourDarkGrey() -> NSColor {
		return colourFromHex( 0xA0A0A8FF)
	}
	
	@objc class func colourLightGrey() -> NSColor {
		return colourFromHex( 0xF0F0FCFF)
	}
	
	@objc class func colourMainTheme() -> NSColor {
		return colourWhite()
	}
	
	@objc class func colourBackground() -> NSColor {
		return colourLightGrey()
	}
	
	@objc class func colourBlur() -> NSColor {
		return colourFromHex( 0x70ACFF80)
	}
	
	//MARK: - Dates
	@objc class func dateFormatter() -> DateFormatter {
		let formatter = DateFormatter()
		formatter.dateStyle = .medium
		formatter.timeStyle = .short
		return formatter
	}
	
	//MARK: - Photos
	@objc class func photoDefault() -> NSImage {
		let image = NSImage(named: NSImage.Name(rawValue: "PhotoDefault"))!
		return image
	}
	
}







