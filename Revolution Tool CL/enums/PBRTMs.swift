//
//  PBRTMs.swift
//  Revolution Tool CL
//
//  Created by The Steez on 28/12/2018.
//

import Foundation

enum XGTMs: XGIndexedValue {
	case tm(Int)
	case tutor(Int)
	
	var index : Int {
		switch self {
		case .tm(let i): return i
		default:
			assertionFailure("Only for XD compatibility")
			return -1
		}
	}
	
	var move : XGMoves {
		return .move(PBRDataTableEntry.TMs(index: index - 1).getShort(0))
	}

	static var allTMs: [XGTMs] {
		(0 ..< kNumberOfTMsAndHMs).map { (index) -> XGTMs in
			.tm(index)
		}
	}
}










