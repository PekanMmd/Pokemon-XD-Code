//
//  PBRTMs.swift
//  Revolution Tool CL
//
//  Created by The Steez on 28/12/2018.
//

import Foundation

enum XGTMs : XGIndexedValue {
	case TM(Int)
	
	var index : Int {
		switch self {
		case .TM(let i): return i
		}
	}
	
	var move : XGMoves {
		return .move(PBRDataTableEntry.TMs(index: index - 1).getShort(0))
	}
	
}










