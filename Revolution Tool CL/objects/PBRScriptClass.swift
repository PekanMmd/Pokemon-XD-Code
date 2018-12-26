//
//  PBRScriptClass.swift
//  Revolution Tool CL
//
//  Created by The Steez on 26/12/2018.
//

import Foundation


enum XGScriptFunction {
	
	case operators(String,Int,Int)
	case unknownOperator(Int)
	case known(String,Int,Int)
	case unknown(Int)
	
	var name : String {
		switch self {
		case .operators(let name,_,_)	: return name
		case .unknownOperator(let val)  : return "operator\(val)"
		case .known(let name,_,_)	: return name
		case .unknown(let val)			: return "function\(val)"
		}
	}
	
	var index : Int {
		switch self {
		case .operators(_,let val,_)	: return val
		case .unknownOperator(let val)	: return val
		case .known(_,let val,_)	: return val
		case .unknown(let val)			: return val
		}
	}
	
	var parameters : Int {
		switch self {
		case .operators(_,_,let val)	: return val
		case .unknownOperator(_) 		: return 0
		case .known(_,_,let val)	: return val
		case .unknown					: return 0
		}
	}
}

enum XGScriptClass {
	case operators
	case classes(Int)
	
	var name : String {
		switch self {
		case .operators			: return "Operator"
		case .classes(let val)	: return ScriptClassNames[val] ?? "Class\(val)"
		}
	}
	
	var index : Int {
		switch self {
		case .operators			: return -1
		case .classes(let val)	: return val
		}
	}
	
	subscript(id: Int) -> XGScriptFunction {
		
		switch self {
		case .operators			: return operatorWithID(id)
		case .classes			: return functionWithID(id)
		}
		
	}
	
	func operatorWithID(_ id: Int) -> XGScriptFunction {
		
		for (name,index,parameters) in ScriptOperators {
			if index == id {
				return .operators(name, index, parameters)
			}
			
		}
		
		return .unknownOperator(id)
	}
	
	func functionWithID(_ id: Int) -> XGScriptFunction {
		
		let info = ScriptClassFunctions[self.index]
		
		if info == nil {
			return .unknown(id)
		}
		
		for (name,index,parameters) in info! {
			if index == id {
				return .known(name, index, parameters)
			}
		}
		
		return .unknown(id)
	}
	
	func classDotFunction(_ id: Int) -> String {
		return self.name + "." + self[id].name
	}
	
	func functionWithName(_ name: String) -> XGScriptFunction? {
		
		let kMaxNumberOfXDSClassFunctions = 200 // theoretical limit is 0xffff but 200 is probably safe
		for i in 0 ..< kMaxNumberOfXDSClassFunctions {
			let info = self[i]
			if info.name.lowercased() == name.lowercased() {
				return info
			}
			
			// so old scripts can still refer to renamed functions by "function" + number
			if XGScriptFunction.unknown(i).name.lowercased() == name.lowercased() {
				return self[i]
			}
			
		}
		
		return nil
	}
	
	static func getClassNamed(_ name: String) -> XGScriptClass? {
		
		// so old scripts can still refer to renamed classes by "Class" + number
		if name.length > 5 {
			if name.substring(from: 0, to: 5) == "Class" {
				if let val = name.substring(from: 5, to: name.length).integerValue {
					if val < 127 {
						return XGScriptClass.classes(val)
					}
				}
			}
		}
		
		let kNumberOfXDSClasses = 100 // vanilla has max class of 60 but leave room for expansion
		for i in 0 ... kNumberOfXDSClasses {
			let info = XGScriptClass.classes(i)
			if info.name.lowercased() == name.lowercased() {
				return info
			}
		}
		return nil
	}
	
}

