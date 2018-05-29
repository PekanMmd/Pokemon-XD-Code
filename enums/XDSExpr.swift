//
//  XDSExpr.swift
//  GoDToolCL
//
//  Created by The Steez on 29/05/2018.
//

import Foundation

typealias Variable   = String
typealias Location   = String
typealias ClassID    = Int
typealias FunctionID = Int
indirect enum XDSExpr {
	
	case bracket(XDSExpr)
	case unaryOperator(XDSExpr)
	case binaryOperator(XDSExpr, XDSExpr)
	case loadImmediate(XGScriptVar)
	case loadVariable(Variable)
	case setVariable(Variable, XDSExpr)
	case setVector(Variable, XGScriptVar)
	case call(Location, [XDSExpr])
	case scriptReturn(XDSExpr)
	case callStandard(ClassID, FunctionID, [XDSExpr])
	case jumpTrue(XDSExpr, Location)
	case jumpFalse(XDSExpr, Location)
	case jump(Location)
	case reserve(Int)
	case exit
	case setLine(Int)
	case loadNonCopyableVariable(Variable)
	
	
	
}

