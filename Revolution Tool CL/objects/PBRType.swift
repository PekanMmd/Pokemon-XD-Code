//
//  XGTypeData.swift
//  XG Tool
//
//  Created by StarsMmd on 19/05/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

let kNumberOfTypes = PBRDataTable.typeMatchups.entrySize // 18
let kFirstTypeNameID = 0xca6

class XGType: NSObject, XGIndexedValue, Codable {
	
	var index			 	= 0
	var effectivenessTable	= [XGEffectivenessValues]()
    var category = XGMoveCategories.none // dummy for gc compatibility
	
    var nameID : Int {
        get {
            if self.index < 0 || self.index > kNumberOfTypes {
                return 0
            }
            return kFirstTypeNameID + self.index
        }
        set {
            // get only atm, set will be ignored
        }
	}
	var name : XGString {
		get {
			return getStringSafelyWithID(id: self.nameID)
		}
	}
	
	func setEffectiveness(_ effectiveness: XGEffectivenessValues, againstType type: XGMoveTypes) {
		effectivenessTable[type.index] = effectiveness
	}
	
	func damageDealtTo(type: XGMoveTypes) -> XGEffectivenessValues {
		return effectivenessTable[type.index]
	}
	
	@objc init(index: Int) {
		super.init()
		
		self.index = index
		let data = PBRDataTableEntry.typeMatchups(index: self.index)
		
		for i in 0 ..< kNumberOfTypes {
			effectivenessTable.append(XGEffectivenessValues(rawValue: data.getByte(i))!)
		}
		
	}
	
	@objc func save() {
		let data = PBRDataTableEntry.typeMatchups(index: self.index)
		for i in 0 ..< self.effectivenessTable.count {
			data.setByte(i, to: effectivenessTable[i].rawValue)
		}
		
		data.save()
	}
}











