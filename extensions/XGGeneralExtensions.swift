//
//  XGGeneralExtensions.swift
//  GoD Tool
//
//  Created by Stars Momodu on 28/01/2021.
//

import Foundation

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
				if self.startOffset == 0 || (file == .common_rel && settings.enableExperimentalFeatures) {
					if settings.verbose {
						printg("string was too long, adding \(difference + 0x200 - extraCharacters) bytes to table \(self.file.fileName)")
					}
					// add a little extra so it doesn't keep hitting this case every time there's even a 1 character increase
					self.stringTable.insertRepeatedByte(byte: 0, count: difference + 0x200 - extraCharacters, atOffset: stringTable.length)

					return self.replaceString(string, alert: alert, save: save)
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
