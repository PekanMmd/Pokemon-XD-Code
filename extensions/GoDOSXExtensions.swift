//
//  GoDOSXExtensions.swift
//  GoD Tool
//
//  Created by The Steez on 28/08/2018.
//

#if canImport(Cocoa)
import Cocoa

extension NSColor {
	var vec3: [Float] {
		return [Float(self.redComponent), Float(self.greenComponent), Float(self.blueComponent)]
	}
}

extension XGColour {
	var NSColour : NSColor {
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








