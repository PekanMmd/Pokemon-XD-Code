//
//  CMScript.swift
//  GoD Tool
//
//  Created by The Steez on 13/03/2019.
//

import Foundation

typealias FTBL = (codeOffset: Int, end: Int, name: String, index: Int)
typealias GIRI = (groupID: Int, resourceID: Int)
typealias VECT = (x: Float, y: Float, z: Float)

class XGScript {
	
	var file : XGFiles!
	@objc var mapRel : XGMapRel?
	@objc var data : XGMutableData!
	
	var ftbl = [FTBL]()
	@objc var strg = [String]()
	var vect = [VECT]()
	var giri = [GIRI]()
	
	var scriptID : UInt32 = 0x0
	
	@objc var codeLength : Int {
		return 0
	}
	
	init(file: XGFiles) {
		self.file = file
		
		if let data = file.data {
			let numberOfFunctions = data.get2BytesAtOffset(4)
			for i in 0 ..< numberOfFunctions {
				self.ftbl.append((codeOffset: 0, end: 0, name: "function_\(i)", index: i))
			}
		}
	}
	
}




