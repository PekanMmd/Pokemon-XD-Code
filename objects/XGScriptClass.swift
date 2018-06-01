//
//  XGScriptClass.swift
//  XGCommandLineTools
//
//  Created by StarsMmd on 21/05/2016.
//  Copyright © 2016 StarsMmd. All rights reserved.
//

import Foundation

enum XGScriptFunctionInfo {
	
	case operators(String,Int,Int)
	case known(String,Int,Int,[XDSMacroTypes?]?, XDSMacroTypes?)
	case unknown(Int)
	
	var name : String {
		switch self {
			case .operators(let name,_,_)	: return name
			case .known(let name,_,_,_,_)	: return name
			case .unknown(let val)			: return "function\(val)"
		}
	}
	
	var index : Int {
		switch self {
			case .operators(_,let val,_)	: return val
			case .known(_,let val,_,_,_)	: return val
			case .unknown(let val)			: return val
		}
	}
	
	var parameters : Int {
		switch self {
			case .operators(_,_,let val)	: return val
			case .known(_,_,let val,_,_)	: return val
			case .unknown					: return 0
		}
	}
	
	var macros : [XDSMacroTypes?]? {
		switch self {
			case .operators				:return nil
			case .known(_,_,_,let val,_): return val
			case .unknown				: return nil
		}
	}
	
	var returnMacro : XDSMacroTypes? {
		switch self {
		case .operators				:return nil
		case .known(_,_,_,_,let val): return val
		case .unknown				: return nil
		}
	}
}

enum XGScriptClassesInfo {
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
	
	subscript(id: Int) -> XGScriptFunctionInfo {
		
		switch self {
			case .operators			: return operatorWithID(id)
			case .classes			: return functionWithID(id)
		}
		
	}
	
	func operatorWithID(_ id: Int) -> XGScriptFunctionInfo {
		
		for (name,index,parameters) in ScriptOperators {
			if index == id {
				return .operators(name, index, parameters)
			}
			
		}
		
		return .unknown(id)
	}
	
	func functionWithID(_ id: Int) -> XGScriptFunctionInfo {
		let info = ScriptClassFunctions[self.index]
		
		if info == nil {
			return .unknown(id)
		}
		
		for (name,index,parameters,macros, macro) in info! {
			if index == id {
				return .known(name, index, parameters, macros, macro)
			}
		}
		
		return .unknown(id)
	}
	
}

























