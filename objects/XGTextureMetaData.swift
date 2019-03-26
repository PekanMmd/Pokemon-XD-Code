//
//  XGTextureMetaData.swift
//  GoD Tool
//
//  Created by The Steez on 26/03/2019.
//

import Foundation

let kSizeOfTextureMetaData = 72
let kTextureMetaDataStartOffset = 0x2FD1A8 // XD, US version
let kNumberOfTextures = 0x3fb

let kTMDCropXOffset = 0x8
let kTMDCropYOffset = 0xa
let kTMDCropWidthOffset = 0xc
let kTMDCropHeightOffset = 0xe
let kTMDFileIdentifierOffset = 0x10

class XGTextureMetaData {
	
	var id = 0
	var startOffset = 0
	
	var cropX = 0
	var cropY = 0
	var cropWidth = 0
	var cropHeight = 0
	
	var fileIdentifier : UInt32 = 0
	
	init(id: Int) {
		self.id = id
		let dol = XGFiles.dol.data!
		
		self.startOffset = kTextureMetaDataStartOffset + (id * kSizeOfTextureMetaData)
		
		self.cropX = dol.get2BytesAtOffset(startOffset + kTMDCropXOffset)
		self.cropY = dol.get2BytesAtOffset(startOffset + kTMDCropYOffset)
		self.cropWidth = dol.get2BytesAtOffset(startOffset + kTMDCropWidthOffset)
		self.cropHeight = dol.get2BytesAtOffset(startOffset + kTMDCropHeightOffset)
		
		self.fileIdentifier = dol.getWordAtOffset(startOffset + kTMDFileIdentifierOffset)
		
		
	}
	
}








