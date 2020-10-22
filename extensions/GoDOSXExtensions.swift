//
//  GoDOSXExtensions.swift
//  GoD Tool
//
//  Created by The Steez on 28/08/2018.
//

#if ENV_OSX
import Cocoa

extension NSColor {
	var vec3 : [GLfloat] {
		return [Float(self.redComponent).gl, Float(self.greenComponent).gl, Float(self.blueComponent).gl]
	}
}

extension Float {
	var gl : GLfloat {
		return GLfloat(self)
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








