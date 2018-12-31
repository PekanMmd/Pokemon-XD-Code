//
//  MoveTypes.swift
//  Mausoleum Move Tool
//
//  Created by StarsMmd on 28/12/2014.
//  Copyright (c) 2014 StarsMmd. All rights reserved.
//

import Foundation

enum XGMoveTypes : XGDictionaryRepresentable, XGIndexedValue {
	
	case type(Int)
	
	var index : Int {
		switch self {
			case .type(let i): return i
		}
	}
	
	var rawValue : Int {
		return self.index
	}
	
	var name : String {
		get {
			return data.name.string
		}
	}
	
	var data : XGType {
		return XGType(index: index)
	}
	
	var dictionaryRepresentation: [String : AnyObject] {
		get {
			return ["Value" : self.index as AnyObject]
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
				t.append(XGMoveTypes.type(i))
			}
			return t
		}
	}
	
	static func random() -> XGMoveTypes {
		let rand = Int(arc4random_uniform(UInt32(kNumberOfTypes)))
		return XGMoveTypes.type(rand)
	}
	
}









