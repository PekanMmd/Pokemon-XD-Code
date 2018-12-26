//
//  MoveTypes.swift
//  Mausoleum Move Tool
//
//  Created by StarsMmd on 28/12/2014.
//  Copyright (c) 2014 StarsMmd. All rights reserved.
//

import Foundation

enum XGMoveTypes : Int, XGDictionaryRepresentable {
	
	case normal		= 0x00
	case fighting	= 0x01
	case flying		= 0x02
	case poison		= 0x03
	case ground		= 0x04
	case rock		= 0x05
	case bug		= 0x06
	case ghost		= 0x07
	case steel		= 0x08
	case none		= 0x09
	case fire		= 0x0A
	case water		= 0x0B
	case grass		= 0x0C
	case electric	= 0x0D
	case psychic	= 0x0E
	case ice		= 0x0F
	case dragon		= 0x10
	case dark		= 0x11
	
	var name : String {
		get {
			return data.name.string
		}
	}
	
	var data : XGType {
		return XGType(index: self.rawValue)
	}
	
	func cycle() -> XGMoveTypes {
		
		return XGMoveTypes(rawValue: self.rawValue + 1) ?? XGMoveTypes(rawValue: 0)!
		
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
	
	static var allTypes : [XGMoveTypes] {
		get {
			var t = [XGMoveTypes]()
			for i in 0 ..< kNumberOfTypes {
				t.append(XGMoveTypes(rawValue: i)!)
			}
			return t
		}
	}
	
	static func random() -> XGMoveTypes {
		let rand = Int(arc4random_uniform(UInt32(kNumberOfTypes)))
		return XGMoveTypes(rawValue: rand) ?? .normal
	}
	
}









