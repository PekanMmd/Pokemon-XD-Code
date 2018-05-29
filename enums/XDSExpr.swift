//
//  XDSExpr.swift
//  GoDToolCL
//
//  Created by The Steez on 29/05/2018.
//

import Foundation

typealias XDSVariable   = String
typealias XDSLocation   = String
typealias XDSClassID    = Int
typealias XDSFunctionID = Int
typealias XDSOperator	= Int

indirect enum XDSExpr {
	
	case bracket(XDSExpr)
	case unaryOperator(XDSOperator, XDSExpr)
	case binaryOperator(XDSOperator, XDSExpr, XDSExpr)
	case loadImmediate(XGScriptVar)
	case loadVariable(XDSVariable)
	case setVariable(XDSVariable, XDSExpr)
	case setVector(XDSVariable, XGScriptVar)
	case call(XDSLocation, [XDSExpr])
	case XDSReturn(XDSExpr)
	case callStandard(XDSClassID, XDSFunctionID, [XDSExpr])
	case jumpTrue(XDSExpr, XDSLocation)
	case jumpFalse(XDSExpr, XDSLocation)
	case jump(XDSLocation)
	case loadNonCopyableVariable(XDSVariable)
	case reserve(Int)
	case exit
	case setLine(Int)
	
	
	
	var text : String {
		switch self {
			
		case .bracket(let e):
			return "(" + e.text + ")"
		case .unaryOperator(let e):
			return ""
		case .binaryOperator(_, _):
			<#code#>
		case .loadImmediate(_):
			<#code#>
		case .loadVariable(_):
			<#code#>
		case .setVariable(_, _):
			<#code#>
		case .setVector(_, _):
			<#code#>
		case .call(_, _):
			<#code#>
		case .scriptReturn(_):
			<#code#>
		case .callStandard(_, _, _):
			<#code#>
		case .jumpTrue(_, _):
			<#code#>
		case .jumpFalse(_, _):
			<#code#>
		case .jump(_):
			<#code#>
		case .reserve(_):
			<#code#>
		case .exit:
			<#code#>
		case .setLine(_):
			<#code#>
		case .loadNonCopyableVariable(_):
			<#code#>
		}
	}
	
	
}










