//
//  MoveTypes.swift
//  Mausoleum Move Tool
//
//  Created by The Steez on 28/12/2014.
//  Copyright (c) 2014 Ovation International. All rights reserved.
//

import UIKit

enum XGMoveTypes : Int {
	
	case Normal		= 0x00
	case Fighting	= 0x01
	case Flying		= 0x02
	case Poison		= 0x03
	case Ground		= 0x04
	case Rock		= 0x05
	case Bug		= 0x06
	case Ghost		= 0x07
	case Steel		= 0x08
	case None		= 0x09
	case Fire		= 0x0A
	case Water		= 0x0B
	case Grass		= 0x0C
	case Electric	= 0x0D
	case Psychic	= 0x0E
	case Ice		= 0x0F
	case Dragon		= 0x10
	case Dark		= 0x11
	
	var name : String {
		get {
			let stringID = XGType(index: self.rawValue).nameID
			
			return XGStringTable.common_rel().stringSafelyWithID(stringID).string
		}
	}
	
	var image : UIImage {
		get {
			return XGFiles.TypeImage(self.rawValue).image
		}
	}
	
	func cycle() -> XGMoveTypes {
		
		return XGMoveTypes(rawValue: self.rawValue + 1) ?? XGMoveTypes(rawValue: 0)!
		
	}
	
}









