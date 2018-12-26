//
//  XGTrainerModels.swift
//  XG Tool
//
//  Created by StarsMmd on 31/05/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

let kNumberOfTrainerModels = 0

enum XGTrainerModels : Int, XGDictionaryRepresentable {
	
	case none	= 0x00
	
	var name : String {
		return ""
	}
	
	var pkxModelIdentifier : UInt32 {
		return 0
	}
	
	var pkxFSYS : XGFsys? {
		return nil
	}
	
	var pkxData : XGMutableData? {
		return nil
	}
	
	var dictionaryRepresentation: [String : AnyObject] {
		get {
			return ["Value" : self.rawValue as AnyObject]
		}
	}
	
	var readableDictionaryRepresentation: [String : AnyObject] {
		get {
			return ["Value" : self.name as AnyObject]
		}
	}
	
	
}
















