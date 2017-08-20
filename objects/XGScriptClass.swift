//
//  XGScriptClass.swift
//  XGCommandLineTools
//
//  Created by The Steez on 21/05/2016.
//  Copyright © 2016 Ovation International. All rights reserved.
//

import Foundation

enum XGScriptFunctionInfo {
	
	case operators(String,Int,Int)
	case known(String,Int,Int,Bool)
	case unknown(Int)
	
	var name : String {
		switch self {
			case .operators(let name,_,_)	: return name
			case .known(let name,_,_,_)		: return name
			case .unknown(let val)			: return "UnknownFunction\(val)"
		}
	}
	
	var index : Int {
		switch self {
			case .operators(_,let val,_)	: return val
			case .known(_,let val,_,_)	: return val
			case .unknown(let val)		: return val
		}
	}
	
	var parameters : Int {
		switch self {
			case .operators(_,_,let val)	: return val
			case .known(_,_,let val,_)	: return val
			case .unknown				: return 0
		}
	}
	
	var variadic : Bool {
		switch self {
			case .operators				:return false
			case .known(_,_,_,let val)	: return val
			case .unknown				: return false
		}
	}
}

enum XGScriptClassesInfo {
	case operators
	case classes(Int)
	
	var name : String {
		switch self {
			case .operators			: return "Operator"
			case .classes(let val)	: return classNames[val] ?? "UnknownClass\(val)"
		}
	}
	
	var index : Int {
		switch self {
			case .operators			: return -1
			case .classes(let val)	: return val
		}
	}
	
	subscript(id: Int) -> XGScriptFunctionInfo {
		
		switch self {
			case .operators			: return operatorWithIndex(id)
			case .classes				: return functionForClass(self, withId: id)
		}
		
	}
	
	var functionsList : [XGScriptFunctionInfo] {
		
		var ops = true
		var funcs = [XGScriptFunctionInfo]()
		
		switch self {
			case .operators	: ops = true
			case .classes		: ops = false
		}
		
		
		if ops {
			/*for (name,index,parameters) in XGScriptClassesInfo.operators {
				funcs.append(.operators(name, index, parameters))
			}*/
		} else {
			for (name,index,parameters,variadic) in functions[self.index] ?? [] {
				funcs.append(.known(name, index, parameters, variadic))
			}
		}
		return funcs
	}
	
	func operatorWithIndex(_ id: Int) -> XGScriptFunctionInfo {
		
		/*for (name,index,parameters) in XGScriptClassesInfo.operators {
			if index == id {
				return .operators(name, index, parameters)
			}
		}*/
		
		return .unknown(id)
	}
	
	func functionForClass(_ scriptClass: XGScriptClassesInfo, withId id: Int) -> XGScriptFunctionInfo {
		let finfo = functions[id]
		
		guard let info = finfo else {
			return .unknown(id)
		}
		
		for (name,findex,parameters,variadic) in info {
			if findex == id {
				return .known(name, findex, parameters, variadic)
			}
		}
		
		return .unknown(id)
	}
	
}

























