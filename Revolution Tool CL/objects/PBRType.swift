//
//  XGTypeData.swift
//  XG Tool
//
//  Created by StarsMmd on 19/05/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

var kNumberOfTypes: Int {
	return GoDDataTable.typeMatchups.entrySize // 18 in vanilla
}
let kFirstTypeNameID = 0xca6

final class XGType: NSObject, XGIndexedValue, Codable {
	
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
	
	init(index: Int) {
		super.init()
		
		self.index = index
		let data = GoDDataTableEntry.typeMatchups(index: self.index)
		
		for i in 0 ..< kNumberOfTypes {
			effectivenessTable.append(XGEffectivenessValues(rawValue: data.getByte(i))!)
		}
		
	}

	func save() {
		let data = GoDDataTableEntry.typeMatchups(index: self.index)
		for i in 0 ..< self.effectivenessTable.count {
			data.setByte(i, to: effectivenessTable[i].rawValue)
		}

		guard PBRTypeManager.updateTypeMatchupDolData(allowSizeIncrease: false) else {
			displayAlert(title: "Failed to save type: " + name.unformattedString, description: "Couldn't save type match data. The number of non neutral matchups is too large for the data table.")
			return
		}
		
		data.save()
	}
}

extension XGType: XGEnumerable {
	var enumerableName: String {
		return name.unformattedString
	}

	var enumerableValue: String? {
		return index.string
	}

	static var className: String {
		return "Types"
	}

	static var allValues: [XGType] {
		return XGMoveTypes.allTypes.map { $0.data }
	}
}









