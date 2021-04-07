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
	var texturePaletteData: [(format: Int?, offset: Int?, numberOfEntries: Int)] { get }
	var usesDATTextureHeaderFormat: Bool { get }
}

extension GoDTexturesContaining {
	var usesDATTextureHeaderFormat: Bool { return false }

	private var uniqueOffsets: [(header: Int, data: Int, palette: (format: Int?, offset: Int?, numberOfEntries: Int)?)] {
		var unique = [(header: Int, data: Int, palette: (format: Int?, offset: Int?, numberOfEntries: Int)?)]()
		for i in 0 ..< textureHeaderOffsets.count {
			if !unique.contains(where: { (_, data, _) -> Bool in
				return data == textureDataOffsets[i]
			}) {
				let palette: (format: Int?, offset: Int?, numberOfEntries: Int)?
				if usesDATTextureHeaderFormat, i < texturePaletteData.count {
					palette = texturePaletteData[i]
				} else {
					palette = nil
				}
				unique.append((header: textureHeaderOffsets[i], data: textureDataOffsets[i], palette: palette))
			}
		}
		return unique
	}

	var textures: [GoDTexture] {
		guard let data = data else { return [] }
		var textures = [GoDTexture]()

		for i in 0 ..< uniqueOffsets.count {
			let (textureHeaderOffset, textureDataOffset, palette) = uniqueOffsets[i]

			let headerData: XGMutableData
			if usesDATTextureHeaderFormat {
				headerData = XGMutableData(length: 0x50)
			} else {
				headerData = data.getSubDataFromOffset(textureHeaderOffset, length: 0x50)
			}

			let textureData = XGMutableData(data: headerData.data)
			textureData.file = .nameAndFolder(data.file.fileName.removeFileExtensions() + "_\(i)" + data.file.fileType.fileExtension + ".gtx", data.file.folder)
			textureData.appendBytes(.init(repeating: 0, count: 0x30))

			let texture = GoDTexture(data: textureData)
			texture.textureStart = 0x80

			if usesDATTextureHeaderFormat {
				let datImageStruct = GoDStruct(name: "Image", format: [
					.short(name: "Width", description: "", type: .uint),
					.short(name: "Height", description: "", type: .uint),
					.word(name: "Texture Format", description: "", type: .uint),
					.word(name: "Mip Map", description: "", type: .uint)
				])
				let metaData = GoDStructData(properties: datImageStruct, fileData: data, startOffset: textureHeaderOffset)
				if let width: Int = metaData.get("Width") {
					texture.width = width
				}
				if let height: Int = metaData.get("Height") {
					texture.height = height
				}
				if let formatID: Int = metaData.get("Texture Format"), let format = GoDTextureFormats.fromStandardRawValue(formatID) {
					texture.format = format
				}

				if let paletteFormatId = palette?.format {
					texture.paletteFormat = GoDTextureFormats.fromPaletteID(paletteFormatId) ?? .IA8
				}
			}

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
			let paletteLength = texture.isIndexed ? texture.format.paletteCount * texture.paletteFormat.bitsPerPixel / 8 : 0
			let paletteStart = texture.textureStart + dataLength
			if usesDATTextureHeaderFormat {
				texture.data.appendData(data.getSubDataFromOffset(textureDataOffset, length: dataLength))
				if let offset = palette?.offset,
				   let format = GoDTextureFormats.fromPaletteID(palette?.format ?? 0),
				   let paletteCount = palette?.numberOfEntries {
					texture.data.appendData(XGMutableData(length: paletteLength))
					let oldPalette = data.getSubDataFromOffset(offset, length: format.bitsPerPixel * paletteCount / 8)
					texture.data.replaceData(data: oldPalette, atOffset: paletteStart)
				}
			}
			if !usesDATTextureHeaderFormat {
				texture.data.appendBytes(data.getCharStreamFromOffset(textureDataOffset, length: dataLength + paletteLength))
			}
			texture.paletteStart = texture.isIndexed ? paletteStart : 0
			
			texture.writeMetaData()
			textures.append(texture)
		}
		
		return textures
	}

	func importTextures(_ textures: [GoDTexture]) {
		for i in 0 ..< uniqueOffsets.count {
			let (_, textureDataOffset, palette) = uniqueOffsets[i]
			let texture = textures[i]
			if usesDATTextureHeaderFormat {
				if let offset = palette?.offset,
				   let paletteCount = palette?.numberOfEntries {
					let fullPalette = XGMutableData(byteStream: texture.paletteData())
					let usedColours = fullPalette.getSubDataFromOffset(0, length: paletteCount * texture.paletteFormat.bitsPerPixel / 8)
					if texture.limitColourIndexes(to: paletteCount) {
						printg("Warning: The image \(texture.file.path) has more colours than the original file. The number of colours has been limited so the texture may not be accurate in game. This texture is limited to \(paletteCount) colours.")
					}
					data?.replaceBytesFromOffset(textureDataOffset, withByteStream: texture.pixelCharStream())
					data?.replaceData(data: usedColours, atOffset: offset)
				}
			} else {
				data?.replaceBytesFromOffset(textureDataOffset, withByteStream: texture.pixelCharStream() + texture.paletteCharStream())
			}
		}
		data?.save()
	}
}
