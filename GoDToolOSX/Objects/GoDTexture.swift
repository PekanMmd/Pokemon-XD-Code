//
//  GoDTexture.swift
//  GoD Tool
//
//  Created by The Steez on 12/09/2017.
//
//

import Cocoa

let kTextureWidthOffset = 0x00
let kTextureHeightOffset = 0x02
let kTextureBPPOffset = 0x04      // bits per pixel
let kTextureIndexOffset = 0x5
let kTextureFormatOffset = 0xb
let kPaletteFormatOffset = 0xf
let kTexturePointerOffset = 0x28
let kPalettePointerOffset = 0x48

// The textures in poke_dance.fsys start with this data so it can be used to identify them.
// Those textures start at 0xA0 with some extra data added beforehand (probably used to animate it).
let kDancerBytes = [0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x28, 0x00, 0x00, 0x32, 0x80, 0x00, 0x00, 0x00, 0xA0]
let kDancerStartOffset = 0xA0

class GoDTexture: NSObject {

	@objc var data : XGMutableData!
	
	@objc var width = 0
	@objc var height = 0
	@objc var textureStart = 0
	@objc var paletteStart = 0
	var format = GoDTextureFormats.C8
	@objc var paletteFormat = 0
	
	@objc var isIndexed : Bool {
		return format.isIndexed
	}
	
	var BPP : Int {
		return format.bitsPerPixel
	}
	
	@objc var blockWidth : Int {
		return format.blockWidth
	}
	
	@objc var blockHeight : Int {
		return format.blockHeight
	}
	
	@objc var textureLength : Int {
		get {
			return self.isIndexed ? paletteStart - textureStart : data.length - textureStart
		}
	}
	
	@objc var paletteLength : Int {
		return self.isIndexed ? (self.data.length - self.paletteStart) : 0
	}
	
	@objc var paletteCount : Int {
		return paletteLength / 2
	}
	
	var file : XGFiles {
		get {
			return self.data.file
		}
		set {
			self.data.file = newValue
		}
	}
	
	@objc var isPokeDance = false
	@objc var startOffset = 0x0
	
	convenience init(file: XGFiles) {
		self.init(data: file.data!)
	}
	
	@objc init(data: XGMutableData) {
		super.init()
		
		self.data = data
		
		self.isPokeDance = data.getByteStreamFromOffset(0, length: kDancerBytes.count) == kDancerBytes
		startOffset = isPokeDance ? kDancerStartOffset : 0x0
		self.setUp()
		
	}
	
	@objc func setStartOffset(offset: Int) {
		self.startOffset = offset
		self.setUp()
	}
	
	init(forImage image: NSImage, format: GoDTextureFormats, paletteFormat: GoDTextureFormats = .RGB565) {
		super.init()
		
		self.width = Int(image.size.width)
		self.height = Int(image.size.height)
		self.format = format
		self.textureStart = 0x80
		
		var requiredPixelsPerRow = self.width
		while requiredPixelsPerRow % format.blockWidth != 0 {
			requiredPixelsPerRow += 1
		}
		var requiredPixelsPerCol = self.height
		while requiredPixelsPerCol % format.blockHeight != 0 {
			requiredPixelsPerCol += 1
		}
		
		let requiredTextureBytes = requiredPixelsPerRow * requiredPixelsPerCol * self.BPP / 8
		let requiredPaletteBytes = format.paletteCount * paletteFormat.bitsPerPixel / 8
		
		if self.format.isIndexed {
			self.paletteFormat = paletteFormat.paletteID ?? GoDTextureFormats.RGB5A3.paletteID!
			self.paletteStart = 0x80 + requiredTextureBytes
		}
		
		self.data = XGMutableData(byteStream: [Int](repeating: 0, count: 0x80 + requiredTextureBytes + requiredPaletteBytes))
		
		self.writeMetaData()
	}
	
	@objc func setUp() {
		
		self.width = data.get2BytesAtOffset(startOffset + kTextureWidthOffset)
		self.height = data.get2BytesAtOffset(startOffset + kTextureHeightOffset)
		self.textureStart = startOffset + Int(data.getWordAtOffset(startOffset + kTexturePointerOffset))
		self.paletteStart = startOffset + Int(data.getWordAtOffset(startOffset + kPalettePointerOffset))
		let formatIndex = data.getByteAtOffset(startOffset + kTextureFormatOffset)
		self.format = GoDTextureFormats(rawValue: formatIndex) ?? .C8
		self.paletteFormat = data.getByteAtOffset(startOffset + kPaletteFormatOffset)
		
	}
	
	func writeMetaData() {
		self.data.replace2BytesAtOffset(startOffset + kTextureWidthOffset, withBytes: self.width)
		self.data.replace2BytesAtOffset(startOffset + kTextureHeightOffset, withBytes: self.height)
		self.data.replaceByteAtOffset(startOffset + kTextureBPPOffset, withByte: self.BPP)
		self.data.replaceWordAtOffset(startOffset + kTexturePointerOffset, withBytes: UInt32(self.textureStart - startOffset))
		self.data.replaceWordAtOffset(startOffset + kPalettePointerOffset, withBytes: UInt32(self.paletteStart - startOffset))
		self.data.replaceByteAtOffset(startOffset + kTextureFormatOffset, withByte: self.format.rawValue)
		self.data.replaceByteAtOffset(startOffset + kPaletteFormatOffset, withByte: self.paletteFormat)
		self.data.replaceByteAtOffset(startOffset + kTextureIndexOffset, withByte: self.isIndexed ? 1 : 0)
	}
	
	@objc func save() {
		self.writeMetaData()
		self.data.save()
	}
	
	@objc func replaceTextureData(newBytes: [Int]) {
		self.data.replaceBytesFromOffset(self.textureStart, withByteStream: newBytes)
	}
	
	@objc func replacePaletteData(newBytes: [Int]) {
		self.data.replaceBytesFromOffset(self.paletteStart, withByteStream: newBytes)
	}
	
}











