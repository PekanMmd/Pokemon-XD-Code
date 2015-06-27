//
//  XGAbilities.swift
//  XG Tool
//
//  Created by The Steez on 01/06/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//

import Foundation

let kFirstAbilityNameID = 0xC1D
let kFirstAbilityDescriptionID = 0xCE5
let kNumberOfAbilities = 0x4D

enum XGAbilities {
	
	case Ability(Int)
	
	var index : Int {
		get {
			switch self {
				case .Ability(let i): return i
			}
		}
	}
	
	var nameID : Int {
		get {
			if (index == 0) || (index > kNumberOfAbilities) {
				return 0
			}
			
			return kFirstAbilityNameID + index - 1
		}
	}
	
	var name : XGString {
		get {
			return XGStringTable.common_rel().stringSafelyWithID(nameID)
		}
	}
	
	var descriptionID : Int {
		get {
			if (index == 0) || (index > kNumberOfAbilities) {
				return 0
			}
			
			return kFirstAbilityDescriptionID + index - 1
		}
	}
	
	var description : XGString {
		get {
			return XGStringTable.common_rel().stringSafelyWithID(descriptionID)
		}
	}
	
}