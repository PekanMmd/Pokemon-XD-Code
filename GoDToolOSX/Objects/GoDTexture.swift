//
//  GoDTexture.swift
//  GoD Tool
//
//  Created by The Steez on 12/09/2017.
//
//

import Foundation

let kTextureWidthOffset = 0x00
let kTextureHeightOffset = 0x02
let kTextureBPPOffset = 0x04      // bits per pixel
let kTextureFormatOffset = 0xb
let kPaletteFormatOffset = 0xf
let kTexturePointerOffset = 0x28
let kPalettePointerOffset = 0x48

// The textures in poke_dance.fsys start with this data so it can be used to identify them.
// Those textures start at 0xA0 with some extra data added beforehand (probably used to animate it).
let kDancerBytes = [0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x28, 0x00, 0x00, 0x32, 0x80, 0x00, 0x00, 0x00, 0xA0]
let kDancerStartOffset = 0xA0

class GoDTexture: NSObject {

	var data : XGMutableData!
	
	var width = 0
	var height = 0
	var BPP = 0
	var textureStart = 0
	var paletteStart = 0
	var format = GoDTextureFormats.C8
	var paletteFormat = 0
	
	var isIndexed : Bool {
		return format.isIndexed
	}
	
	var blockWidth : Int {
		return format.blockWidth
	}
	
	var blockHeight : Int {
		return format.blockHeight
	}
	
	var textureLength : Int {
		get {
			return self.isIndexed ? paletteStart - textureStart : data.length - textureStart
		}
	}
	
	var paletteLength : Int {
		return self.isIndexed ? (self.data.length - self.paletteStart) : 0
	}
	
	var paletteCount : Int {
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
	
	var isPokeDance = false
	var startOffset = 0x0
	
	convenience init(file: XGFiles) {
		self.init(data: file.data)
	}
	
	init(data: XGMutableData) {
		super.init()
		
		self.data = data
		
		self.isPokeDance = data.getByteStreamFromOffset(0, length: kDancerBytes.count) == kDancerBytes
		startOffset = isPokeDance ? kDancerStartOffset : 0x0
		self.setUp()
		
	}
	
	func setStartOffset(offset: Int) {
		self.startOffset = offset
		self.setUp()
	}
	
	func setUp() {
		
		self.width = data.get2BytesAtOffset(startOffset + kTextureWidthOffset)
		self.height = data.get2BytesAtOffset(startOffset + kTextureHeightOffset)
		self.BPP = data.getByteAtOffset(startOffset + kTextureBPPOffset)
		self.textureStart = startOffset + Int(data.get4BytesAtOffset(startOffset + kTexturePointerOffset))
		self.paletteStart = startOffset + Int(data.get4BytesAtOffset(startOffset + kPalettePointerOffset))
		let formatIndex = data.getByteAtOffset(startOffset + kTextureFormatOffset)
		self.format = GoDTextureFormats(rawValue: formatIndex) ?? .C8
		self.paletteFormat = data.getByteAtOffset(startOffset + kPaletteFormatOffset)
	}
	
	func save() {
		
		self.data.replace2BytesAtOffset(startOffset + kTextureWidthOffset, withBytes: self.width)
		self.data.replace2BytesAtOffset(startOffset + kTextureHeightOffset, withBytes: self.height)
		self.data.replaceByteAtOffset(startOffset + kTextureBPPOffset, withByte: self.BPP)
		self.data.replace4BytesAtOffset(startOffset + kTexturePointerOffset, withBytes: UInt32(self.textureStart - startOffset))
		self.data.replace4BytesAtOffset(startOffset + kPalettePointerOffset, withBytes: UInt32(self.paletteStart - startOffset))
		self.data.replaceByteAtOffset(startOffset + kTextureFormatOffset, withByte: self.format.rawValue)
		self.data.replaceByteAtOffset(startOffset + kPaletteFormatOffset, withByte: self.paletteFormat)
		
		self.data.save()
	}
	
	func replaceTextureData(newBytes: [Int]) {
		self.data.replaceBytesFromOffset(self.textureStart, withByteStream: newBytes)
	}
	
	func replacePaletteData(newBytes: [Int]) {
		self.data.replaceBytesFromOffset(self.paletteStart, withByteStream: newBytes)
	}
	
}











