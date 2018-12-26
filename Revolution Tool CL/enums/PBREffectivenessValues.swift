//
//  XGEffectivenessValues.swift
//  XG Tool
//
//  Created by StarsMmd on 19/05/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

enum XGEffectivenessValues : Int, XGDictionaryRepresentable {

	case superEffective		= 0
	case neutral			= 1
	case notVeryEffective	= 2
	case ineffective		= 3
	case unknown1			= 4
	case unknown2			= 5
	
	var string : String {
		get {
			switch self {
				case .ineffective:			return "No Effect"
				case .notVeryEffective:		return "Not Very Effective"
				case .neutral:				return "Neutral"
				case .superEffective:		return "Super Effective"
				case .unknown1:				return "Unknown 1"
				case .unknown2:				return "Unknown 2"
			}
		}
	}
	
	var dictionaryRepresentation: [String : AnyObject] {
		get {
			return ["Value" : self.rawValue as AnyObject]
		}
	}
	
	var readableDictionaryRepresentation: [String : AnyObject] {
		get {
			return ["Value" : self.string as AnyObject]
		}
	}
	
}







