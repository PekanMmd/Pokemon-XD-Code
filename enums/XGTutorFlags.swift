//
//  XGTutorActivationIndexes.swift
//  XG Tool
//
//  Created by The Steez on 09/08/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//

import Foundation

enum XGTutorFlags : Int, XGDictionaryRepresentable {
	
	case immediately		 = 0x01
	case pyriteVisited		 = 0x24
	case phenacVisited		 = 0x32
	case snagemHideoutKnown  = 0x50
	case cipherLairVisited	 = 0x55
	case citadarkVisited	 = 0x5A
	
	var string : String {
		get {
			switch self {
				case .immediately			: return "From the beginning"
				case .pyriteVisited			: return "Visit Pyrite Town"
				case .phenacVisited			: return "Visit Phenac City"
				case .snagemHideoutKnown	: return "Hear About Snagem Hideout"
				case .cipherLairVisited		: return "Visit Cipher's Key Lair"
				case .citadarkVisited		: return "Visit Citadark Isle"
			}
		}
	}
	
	func cycle() -> XGTutorFlags {
		switch self {
			case .immediately			: return .pyriteVisited
			case .pyriteVisited			: return .phenacVisited
			case .phenacVisited			: return .snagemHideoutKnown
			case .snagemHideoutKnown	: return .cipherLairVisited
			case .cipherLairVisited		: return .citadarkVisited
			case .citadarkVisited		: return .immediately
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









