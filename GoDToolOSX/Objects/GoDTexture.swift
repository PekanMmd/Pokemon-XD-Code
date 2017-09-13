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
	
	convenience init(file: XGFiles) {
		self.init(data: file.data)
	}
	
	init(data: XGMutableData) {
		super.init()
		
		self.data = data
		
		self.width = data.get2BytesAtOffset(kTextureWidthOffset)
		self.height = data.get2BytesAtOffset(kTextureHeightOffset)
		self.BPP = data.getByteAtOffset(kTextureBPPOffset)
		self.textureStart = Int(data.get4BytesAtOffset(kTexturePointerOffset))
		self.paletteStart = Int(data.get4BytesAtOffset(kPalettePointerOffset))
		let formatIndex = data.getByteAtOffset(kTextureFormatOffset)
		self.format = GoDTextureFormats(rawValue: formatIndex) ?? .C8
		self.paletteFormat = data.getByteAtOffset(kPaletteFormatOffset)
		
	}
	
	func save() {
		
		self.data.replace2BytesAtOffset(kTextureWidthOffset, withBytes: self.width)
		self.data.replace2BytesAtOffset(kTextureHeightOffset, withBytes: self.height)
		self.data.replaceByteAtOffset(kTextureBPPOffset, withByte: self.BPP)
		self.data.replace4BytesAtOffset(kTexturePointerOffset, withBytes: UInt32(self.textureStart))
		self.data.replace4BytesAtOffset(kPalettePointerOffset, withBytes: UInt32(self.paletteStart))
		self.data.replaceByteAtOffset(kTextureFormatOffset, withByte: self.format.rawValue)
		self.data.replaceByteAtOffset(kPaletteFormatOffset, withByte: self.paletteFormat)
		
		self.data.save()
	}
	
	func replaceTextureData(newBytes: [Int]) {
		self.data.replaceBytesFromOffset(self.textureStart, withByteStream: newBytes)
	}
	
	func replacePaletteData(newBytes: [Int]) {
		self.data.replaceBytesFromOffset(self.paletteStart, withByteStream: newBytes)
	}
	
}











