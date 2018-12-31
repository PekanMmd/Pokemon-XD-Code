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

class XGType: NSObject, XGIndexedValue {
	
	var index			 	= 0
	var effectivenessTable	= [XGEffectivenessValues]()
	
	var nameID : Int {
		if self.index < 0 || self.index > kNumberOfTypes {
			return 0
		}
		return kFirstTypeNameID + self.index
	}
	var name : XGString {
		get {
			return getStringSafelyWithID(id: self.nameID)
		}
	}
	
	@objc var dictionaryRepresentation : [String : AnyObject] {
		get {
			var dictRep = [String : AnyObject]()
			dictRep["name"] = self.name
			
			var effectivenessTableArray = [ [String : AnyObject] ]()
			for a in effectivenessTable {
				effectivenessTableArray.append(a.dictionaryRepresentation)
			}
			dictRep["effectivenessTable"] = effectivenessTableArray as AnyObject?
			
			return dictRep
		}
	}
	
	@objc var readableDictionaryRepresentation : [String : AnyObject] {
		get {
			var dictRep = [String : AnyObject]()
			
			var effectivenessTableArray = [AnyObject]()
			for a in effectivenessTable {
				effectivenessTableArray.append(a.string as AnyObject)
			}
			dictRep["effectivenessTable"] = effectivenessTableArray as AnyObject?
			
			return ["\(self.index) " + self.name.string : dictRep as AnyObject]
		}
	}
	
	func damageDealtToType(_ type: XGMoveTypes) -> XGEffectivenessValues {
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











