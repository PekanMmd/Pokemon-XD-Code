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
let kTextureTypeOffset = 0x04
let kTexturePointerOffset = 0x28
let kPalettePointerOffset = 0x48

class GoDTexture: NSObject {

	var data : XGMutableData!
	
	var width = 0
	var height = 0
	var type = 0
	var textureStart = 0
	var paletteStart = 0
	
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
		self.type = data.getByteAtOffset(kTextureTypeOffset)
		self.textureStart = Int(data.get4BytesAtOffset(kTexturePointerOffset))
		self.paletteStart = Int(data.get4BytesAtOffset(kPalettePointerOffset))
		
	}
	
	func save() {
		
		self.data.replace2BytesAtOffset(kTextureWidthOffset, withBytes: self.width)
		self.data.replace2BytesAtOffset(kTextureHeightOffset, withBytes: self.height)
		self.data.replaceByteAtOffset(kTextureTypeOffset, withByte: self.type)
		self.data.replace4BytesAtOffset(kTexturePointerOffset, withBytes: UInt32(self.textureStart))
		self.data.replace4BytesAtOffset(kPalettePointerOffset, withBytes: UInt32(self.paletteStart))
		
		self.data.save()
	}
	
	func replaceTextureData(newBytes: [Int]) {
		self.data.replaceBytesFromOffset(self.textureStart, withByteStream: newBytes)
	}
	
	func replacePaletteData(newBytes: [Int]) {
		self.data.replaceBytesFromOffset(self.paletteStart, withByteStream: newBytes)
	}
	
}











