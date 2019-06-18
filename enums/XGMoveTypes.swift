//
//  MoveTypes.swift
//  Mausoleum Move Tool
//
//  Created by StarsMmd on 28/12/2014.
//  Copyright (c) 2014 StarsMmd. All rights reserved.
//

import Foundation

enum XGMoveTypes : Int, Codable, CaseIterable {
	
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
			let stringID = data.nameID
			
			return XGFiles.common_rel.stringTable.stringSafelyWithID(stringID).string
		}
	}
	
	var data : XGType {
		return XGType(index: self.rawValue)
	}
	
	var category : XGMoveCategories {
		get {
			return data.category
		}
	}
	
	func cycle() -> XGMoveTypes {
		
		return XGMoveTypes(rawValue: self.rawValue + 1) ?? XGMoveTypes(rawValue: 0)!
		
	}
	
	static func random() -> XGMoveTypes {
		let rand = Int(arc4random_uniform(UInt32(kNumberOfTypes)))
		return XGMoveTypes(rawValue: rand) ?? .normal
	}
	
}

extension XGMoveTypes: XGEnumerable {
	var enumerableName: String {
		return name
	}
	
	var enumerableValue: String? {
		return rawValue.string
	}
	
	static var enumerableClassName: String {
		return "Types"
	}
	
	static var allValues: [XGMoveTypes] {
		return allCases
	}
}







