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

extension XGStringTable {

	@discardableResult
	func replaceString(_ string: XGString, alert: Bool = false, save: Bool = false) -> Bool {

		guard let oldText = self.stringWithID(string.id), let stringOffset = offsetForStringID(string.id)  else {
			printg("String table '\(self.file.fileName)' doesn't contain string with id: \(string.id)")
			return false
		}

		let difference = string.dataLength - oldText.dataLength

		if difference <= self.extraCharacters {

			if difference < 0 {
				stringTable.deleteBytes(start: stringOffset, count: abs(difference))
				stringTable.appendBytes([UInt8](repeating: 0, count: abs(difference))) // preserve file size
			} else if difference > 0 {
				stringTable.insertRepeatedByte(byte: 0, count: difference, atOffset: stringOffset)
				stringTable.deleteBytes(start: stringTable.length - difference, count: difference) // preserve file size
			}

			stringTable.replaceBytesFromOffset(stringOffset, withByteStream: string.byteStream)

			if string.dataLength > oldText.dataLength {
				self.increaseOffsetsAfter(stringOffset, by: difference)

			} else if string.dataLength < oldText.dataLength {
				let difference = oldText.dataLength - string.dataLength
				self.decreaseOffsetsAfter(stringOffset, by: difference)
			}

			self.updateOffsets()
			if save {
				self.save()
			}

			return true

		} else {
			if settings.increaseFileSizes {
				if self.startOffset == 0 {
					if settings.verbose {
						printg("string was too long, adding \(difference + 0x50 - extraCharacters) bytes to table \(self.file.fileName)")
					}
					// add a little extra so it doesn't keep hitting this case every time there's even a 1 character increase
					self.stringTable.insertRepeatedByte(byte: 0, count: difference + 0x50 - extraCharacters, atOffset: stringTable.length)
					return self.replaceString(string, alert: alert, save: true)
				}
			}
		}

		printg("Couldn't replace string, not enough free space in string table: \(self.file.fileName)")
		if self.startOffset != 0 {
			printg("The size of this string table cannot be increased.")
		}
		return false
	}
}






