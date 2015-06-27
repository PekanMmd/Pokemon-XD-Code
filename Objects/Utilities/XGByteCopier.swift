//
//  XGByteCopier.swift
//  XG Tool
//
//  Created by The Steez on 24/06/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//

import UIKit

class XGByteCopier: NSObject {
	
	var targetFile = XGFiles.NameAndFolder("", .Documents)
	var targetStartOffset = 0
	
	var bytes = [Int]()
	
	private var data = XGMutableData()
	
	init(copyFile: XGFiles, copyOffset: Int, length: Int, targetFile: XGFiles, targetOffset: Int) {
		super.init()
		
		self.targetFile = targetFile
		self.targetStartOffset = targetOffset
		
		self.data = targetFile.data
		
		var cData = copyFile.data
		self.bytes = cData.getByteStreamFromOffset(copyOffset, length: length)
		
	}
	
	func copyByte(index: Int) {
		self.data.replaceByteAtOffset(targetStartOffset + index, withByte: bytes[index])
	}
	
	func save() {
		self.data.save()
	}
	
}




















