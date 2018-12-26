//
//  XGTypeData.swift
//  XG Tool
//
//  Created by StarsMmd on 19/05/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

let kNumberOfTypes = 0x12

class XGType: NSObject {
	
	@objc var index			 = 0
	@objc var nameID		 = 0
	var effectivenessTable	 = [XGEffectivenessValues]()
	
	@objc var name : XGString {
		get {
			return XGString(string: "", file: nil, sid: nil)
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
	
	@objc init(index: Int) {
		super.init()
		
		self.nameID		= 0
		
		if let data	= PBRDataTable.typeMatchups!.dataForEntryWithIndex(index) {
			self.index		= index
			
			for offset in 0 ..< kNumberOfTypes {
				
				let value = data.getByteAtOffset(offset)
				let effectiveness = XGEffectivenessValues(rawValue: value)!
				effectivenessTable.append(effectiveness)
				
			}
		}
		
	}
	
	@objc func save() {
		
		if let data	= PBRDataTable.typeMatchups!.dataForEntryWithIndex(index) {
			for i in 0 ..< self.effectivenessTable.count {
				
				let value = effectivenessTable[i].rawValue
				data.replaceByteAtOffset(i, withByte: value)
				
			}
			
			PBRDataTable.typeMatchups!.replaceData(data: data, forIndex: index)
			PBRDataTable.typeMatchups!.save()
		}
		
	}
	
	
}











