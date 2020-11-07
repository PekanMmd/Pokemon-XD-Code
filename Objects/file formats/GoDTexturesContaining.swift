//
//  GoDTexturesContaining.swift
//  GoD Tool
//
//  Created by Stars Momodu on 04/11/2020.
//

import Foundation

protocol GoDTexturesContaining {
	var data: XGMutableData? { get }
	var textureHeaderOffsets: [Int] { get }
	var textureDataOffsets: [Int] { get }
}

extension GoDTexturesContaining {
	private var uniqueOffsets: [(header: Int, data: Int)] {
		var unique = [(header: Int, data: Int)]()
		for i in 0 ..< min(textureHeaderOffsets.count, textureDataOffsets.count) {
			if !unique.contains(where: { (header, data) -> Bool in
				return data == textureDataOffsets[i]
			}) {
				unique.append((header: textureHeaderOffsets[i], data: textureDataOffsets[i]))
			}
		}
		return unique
	}

	var textures: [GoDTexture] {
		guard let data = data else { return [] }
		var textures = [GoDTexture]()

		for i in 0 ..< uniqueOffsets.count {
			let (textureHeaderOffset, textureDataOffset) = uniqueOffsets[i]

			let textureData = XGMutableData(byteStream: data.getCharStreamFromOffset(textureHeaderOffset, length: 0x50))
			textureData.file = .nameAndFolder(data.file.fileName.removeFileExtensions() + "_\(i)" + data.file.fileType.fileExtension + ".gtx", data.file.folder)
			textureData.appendBytes(.init(repeating: 0, count: 0x30))

			let texture = GoDTexture(data: textureData)
			texture.textureStart = 0x80

			var requiredPixelsPerRow = texture.width
			while requiredPixelsPerRow % texture.format.blockWidth != 0 {
				requiredPixelsPerRow += 1
			}
			var requiredPixelsPerCol = texture.height
			while requiredPixelsPerCol % texture.format.blockHeight != 0 {
				requiredPixelsPerCol += 1
			}

			let pixelCount = requiredPixelsPerRow * requiredPixelsPerCol
			let dataLength = pixelCount * texture.BPP / 8
			let paletteFormat = GoDTextureFormats.fromPaletteID(texture.paletteFormat) ?? .RGB565
			let paletteLength = texture.isIndexed ? texture.format.paletteCount * paletteFormat.bitsPerPixel : 0
			texture.data.appendBytes(data.getCharStreamFromOffset(textureDataOffset, length: dataLength + paletteLength))
			texture.paletteStart = texture.isIndexed ? (texture.textureStart + texture.textureLength) : 0
			
			texture.writeMetaData()
			textures.append(texture)
		}
		
		return textures
	}

	func importTextures(_ textures: [GoDTexture]) {
		for i in 0 ..< min(textures.count, uniqueOffsets.count) {
			let (_, textureDataOffset) = uniqueOffsets[i]
			let texture = textures[i]
			data?.replaceBytesFromOffset(textureDataOffset, withByteStream: texture.pixelCharStream() + texture.paletteCharStream())
		}
		data?.save()
	}
}
