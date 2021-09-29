//
//  HashExtensions.swift
//  GoD Tool
//
//  Created by Stars Momodu on 09/09/2021.
//

import Foundation

extension XXH64 {
	/// Overload func for "digest(_ array: [UInt8], seed: UInt64 = 0)".
	static func digest(_ data: XGMutableData, seed: UInt64 = 0) -> UInt64 {
		return digest(data.charStream, seed: seed)
	}

	/// Overload func for "digestHex(_ array: [UInt8], seed: UInt64 = 0)".
	static func digestHex(_ data: XGMutableData, seed: UInt64 = 0) -> String {
		let h = digest(data, seed: seed)
		return xxHash.Common.UInt64ToHex(h)
	}
}

extension XGMutableData {
	var xxHash: String {
		return XXH64.digestHex(self)
	}
}

extension GoDTexture {
	var dolphinFileName: String {
		let paletteHashText = paletteHash == nil ? "" : "_\(paletteHash!)"
		return "tex1_\(width)x\(height)_\(textureHash)\(paletteHashText)_\(format.standardRawValue).png"
	}
	
	var textureHash: String {
		return data.getSubDataFromOffset(textureStart, length: textureLength).xxHash
	}

	var paletteHash: String? {
		return usedPaletteData?.xxHash
	}

	private var usedPaletteData: XGMutableData? {
		if isIndexed {
			let indices = pixelData()
			if let min = indices.min(), let max = indices.max() {
				return data.getSubDataFromOffset(paletteStart + (min * 2), length: (max + 1 - min) * 2)
			}
		}
		return nil
	}

	func writeDolphinFormatted(to folder: XGFolders) {
		writePNGData(toFile: .nameAndFolder(dolphinFileName, folder))
	}
}
