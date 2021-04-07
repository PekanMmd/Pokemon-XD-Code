//
//  XGImage.swift
//  GoD Tool
//
//  Created by Stars Momodu on 21/10/2020.
//

import Foundation
#if canImport(Cocoa)
import Cocoa
#endif

struct XGImage {
	let width: Int
	let height: Int
	let pixels: [XGColour]
}

extension XGImage {

	static var dummy: XGImage {
		return .init(width: 1, height: 1, pixels: [.none()])
	}

	var tex0Data: XGMutableData {
		let data = XGMutableData()

		// - TEX0 header -
		data.appendBytes([0x54, 0x45, 0x58, 0x30]) // TEX0 magic bytes
		data.appendBytes([0,0,0,0]) // reserve sub file length
		data.appendBytes([0,0,0,3]) //version number
		data.appendBytes([0,0,0,0]) // unused
		data.appendBytes([0,0,0,0x40]) // section start offset
		data.appendBytes([0,0,0,0]) // reserve sub file name offset

		// - TEX0 version 3 header -
		data.appendBytes([0,0,0,0]) // unused
		data.appendBytes(Array(width.charArray[2...3]))
		data.appendBytes(Array(height.charArray[2...3]))
		data.appendBytes(GoDTextureFormats.RGB5A3.standardRawValue.charArray)
		data.appendBytes([0,0,0,1]) // number of images
		data.appendBytes([0,0,0,0]) // unused
		data.appendBytes(Float(0.0).floatToHex().charArray) // number of mip maps as float
		data.appendBytes([0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]) // padding

		// pixel data
		data.appendBytes(getTexture(format: .RGB5A3, paletteFormat: nil).pixelCharStream())

		// add file name
		let filenameOffset = data.length
		let tex0Size = data.length - 4
		// dummy filename: "dummy.tex0"
		data.appendBytes([0x64, 0x75, 0x6D, 0x6D, 0x79, 0x2E, 0x74, 0x65, 0x78, 0x30, 0x00])
		while data.length % 16 != 0 {
			data.appendBytes([0])
		}

		// update offsets
		data.replace4BytesAtOffset(0x4, withBytes: tex0Size)
		data.replace4BytesAtOffset(0x14, withBytes: filenameOffset)

		return data
	}

	static func fromTEX0File(tex0File file: XGFiles) -> XGImage {
		guard file.exists, let data = file.data else {
			printg("Image could not be found:", file.path)
			return .dummy
		}
		return fromTEX0Data(tex0Data: data)
	}

	static func fromTEX0Data(tex0Data data: XGMutableData) -> XGImage {
		guard data.length > 0x40, data.getWordAtOffset(0) == 0x54455830  else {
			printg("Could not load image. Not a TEX0 file.", data.file.fileName)
			return .dummy
		}

		// This is a partial implementation just for the specific purpose of loading pngs
		// that were converted to tex0's by this tool using wimgt so a lot of assumptions
		// are being made here
		let versionNumber = data.get4BytesAtOffset(0x8)
		let imageFormat = data.get4BytesAtOffset(0x20)
		guard versionNumber == 3, imageFormat == GoDTextureFormats.RGB5A3.standardRawValue else {
			printg("Could not load image. Unrecognised TEX0 format.", "version number:", versionNumber, "image format:", imageFormat)
			return .dummy
		}

		let textureStartOffset = data.get4BytesAtOffset(0x10)
		let imageWidth = data.get2BytesAtOffset(0x1c)
		let imageHeight = data.get2BytesAtOffset(0x1e)

		let texture = GoDTexture(forImage: .init(width: imageWidth, height: imageHeight, pixels: []), format: .RGB5A3, paletteFormat: nil)
		guard data.length > textureStartOffset + texture.textureLength else {
			printg("Could not load image. Failed to parse pixels.")
			return .dummy
		}
		let textureBytes = data.getByteStreamFromOffset(textureStartOffset, length: texture.textureLength)
		texture.replaceTextureData(newBytes: textureBytes)

		return texture.image
	}

	var colourCount: Int {
		return colourCount(threshold: 0)
	}

	// If it's greater than C8's palette size then the exact number isn't important so can stop counting
	func colourCount(threshold: Int, limit: Int = GoDTextureFormats.C8.paletteCount + 1) -> Int {
		XGColour.colourThreshold = threshold
		let palette = XGTexturePalette()
		for colour in pixels {
			if palette.indexForColour(colour) == nil {
				palette.append(colour)
				if palette.length > limit {
					break
				}
			}
		}
		return palette.length
	}

	var texture : GoDTexture {
		return GoDTextureImporter.getTextureData(image: self)
	}

	func getTexture(format: GoDTextureFormats, paletteFormat: GoDTextureFormats?) -> GoDTexture {
		return GoDTextureImporter.getTextureData(image: self, format: format, paletteFormat: paletteFormat)
	}

	var textures : [GoDTexture] {
		return GoDTextureImporter.getMultiFormatTextureData(image: self)
	}

	func writePNGData(toFile file: XGFiles) {
		#if canImport(Cocoa)
		pngData.write(to: file)
		#else
		let tex0File = XGFiles.nameAndFolder(file.fileName.removeFileExtensions() + XGFileTypes.tex0.fileExtension, file.folder)
		let data = tex0Data
		data.file = tex0File
		data.save()
		guard tex0File.exists else {
			printg("Failed to convert texture to .tex0 file")
			return
		}
		let args = "decode -o \(tex0File.path.escapedPath) -d \(file.path.escapedPath)"
		GoDShellManager.run(.wimgt, args: args)
		tex0File.delete()
		#endif
	}

	static func loadImageData(fromFile file: XGFiles) -> XGImage? {
		guard file.exists, XGFileTypes.imageFormats.contains(file.fileType) else {
			return nil
		}
		#if canImport(Cocoa)
		let image = file.image
		return XGImage(nsImage: image)
		#else
		let tex0File = XGFiles.nameAndFolder(file.fileName.removeFileExtensions() + XGFileTypes.tex0.fileExtension, file.folder)
		let format = "-x TEX.RGB5A3"
		let overwrite = "-o"
		let mipmaps = "--n-mipmaps 0" // don't generate mipmaps since we don't need them
		let args = "encode \(overwrite) \(mipmaps) \(format) \(file.path.escapedPath) -d \(tex0File.path.escapedPath)"
		GoDShellManager.run(.wimgt, args: args)
		guard tex0File.exists, let data = tex0File.data else {
			printg("Failed to convert png image to tex0:", file.path)
			return nil
		}
		defer {
			tex0File.delete()
		}
		return XGImage.fromTEX0Data(tex0Data: data)
		#endif
	}
}

#if canImport(Cocoa)
extension XGImage {

	var pngData: Data {
		return data(fileType: .png)
	}

	var jpegData: Data {
		return data(fileType: .jpeg)
	}

	var bmpData: Data {
		return data(fileType: .bmp)
	}


	var nsImage: NSImage {
		return NSImage(data: self.pngData) ?? NSImage()
	}

	init(nsImage image: NSImage) {
		self.init(width: image.width, height: image.height, pixels: image.bitmap)
	}

	private func data(fileType: XGFileTypes) -> Data {
		guard XGFileTypes.imageFormats.contains(fileType) else {
			return Data()
		}

		let bytesPerRow = width * 4

		let bitmap = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: width, pixelsHigh: height, bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: NSColorSpaceName.deviceRGB, bitmapFormat: NSBitmapImageRep.Format(rawValue: UInt(CGBitmapInfo.byteOrder32Big.union(CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)).rawValue)), bytesPerRow: bytesPerRow, bitsPerPixel: 32)!

		for index in 0 ..< width * height {
			let x = index % width
			let y = index / width

			let colour = pixels[index]
			bitmap.setColor(colour.NSColour, atX: x, y: y)
		}

		return bitmap.representation(using: fileType.NSFileType, properties: [:]) ?? Data()
	}
}
#endif
