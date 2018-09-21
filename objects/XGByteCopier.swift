//
//  XGByteCopier.swift
//  XG Tool
//
//  Created by StarsMmd on 24/06/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

class XGByteCopier: NSObject {
	
	var targetFile = XGFiles.nameAndFolder("", .Documents)
	@objc var targetStartOffset = 0
	
	@objc var bytes = [Int]()
	
	fileprivate var data = XGMutableData()
	
	init(copyFile: XGFiles, copyOffset: Int, length: Int, targetFile: XGFiles, targetOffset: Int) {
		super.init()
		
		self.targetFile = targetFile
		self.targetStartOffset = targetOffset
		
		self.data = targetFile.data
		
		let cData = copyFile.data
		self.bytes = cData.getByteStreamFromOffset(copyOffset, length: length)
		
	}
	
	@objc func copyByte(_ index: Int) {
		self.data.replaceByteAtOffset(targetStartOffset + index, withByte: bytes[index])
	}
	
	@objc func copyAll() {
		self.data.replaceBytesFromOffset(targetStartOffset, withByteStream: self.bytes)
	}
	
	@objc func save() {
		self.data.save()
	}
	
}




















