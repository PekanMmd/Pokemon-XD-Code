//
//  GoDDesign.swift
//  GoD Tool
//
//  Created by StarsMmd on 29/06/2016.
//  Copyright © 2016 StarsMmd. All rights reserved.
//

#if GUI
import AppKit
#endif
import Foundation

class GoDDesign {

	#if GUI
	static var isDarkModeEnabled: Bool {
		let mode = UserDefaults.standard.string(forKey: "AppleInterfaceStyle")
		return mode == "Dark"
	}
	
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
	#endif
	
	
	//MARK: - Colours
	
	class func colourClear() -> XGColour {
		return XGColour(raw:0x00000000)
	}
	
	class func colourBlack() -> XGColour {
		return XGColour(raw:0x000000FF)
	}
	
	class func colourWhite() -> XGColour {
		return XGColour(raw:0xFFFFFFFF)
	}
	
	class func colourRed() -> XGColour {
		return XGColour(raw:0xFC6848FF)
	}
	
	class func colourLightOrange() -> XGColour {
		return XGColour(raw: 0xFFD080FF)
	}
	
	class func colourOrange() -> XGColour {
		return XGColour(raw: 0xF7B409FF)
	}
	
	class func colourYellow() -> XGColour {
		return XGColour(raw: 0xF8F888FF)
	}
	
	class func colourLightGreen() -> XGColour {
		return XGColour(raw: 0xD0FFD0FF)
	}
	
	class func colourGreen() -> XGColour {
		return XGColour(raw: 0xA8E79CFF)
	}
	
	class func colourLightBlue() -> XGColour {
		return XGColour(raw: 0xB8F0FFFF)
	}
	
	class func colourBlue() -> XGColour {
		return XGColour(raw: 0x80ACFFFF)
	}
	
	class func colourLightPurple() -> XGColour {
		return XGColour(raw: 0xE0C0FFFF)
	}
	
	class func colourPurple() -> XGColour {
		return XGColour(raw: 0xA070FFFF)
	}
	
	class func colourPeach() -> XGColour {
		return XGColour(raw: 0xFFE8D0FF)
	}
	
	class func colourBabyPink() -> XGColour {
		return XGColour(raw: 0xFFE0E8FF)
	}
	
	class func colourPink() -> XGColour {
		return XGColour(raw: 0xFC80F6FF)
	}
	
	class func colourNavy() -> XGColour {
		return XGColour(raw: 0x28276BFF)
	}
	
	class func colourBrown() -> XGColour {
		return XGColour(raw: 0xC0A078FF)
	}
	
	class func colourLightBlack() -> XGColour {
		return XGColour(raw: 0x282828FF)
	}
	
	class func colourGrey() -> XGColour {
		return XGColour(raw: 0xC0C0C8FF)
	}
	
	class func colourDarkGrey() -> XGColour {
		return XGColour(raw: 0xA0A0A8FF)
	}
	
	class func colourLightGrey() -> XGColour {
		return XGColour(raw: 0xF0F0FCFF)
	}
	
	class func colourMainTheme() -> XGColour {
		return colourWhite()
	}
	
	class func colourBackground() -> XGColour {
		return colourLightGrey()
	}
	
	class func colourBlur() -> XGColour {
		return XGColour(raw: 0x70ACFF80)
	}

	#if GUI
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
	#endif
	
}







